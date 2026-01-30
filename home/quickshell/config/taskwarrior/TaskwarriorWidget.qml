import QtQuick
import QtQuick.Layouts
import Quickshell.Io

ColumnLayout {
    id: taskwarriorWidget
    
    property var tasks: []
    property int maxTasks: 5
    property bool showCompleted: false
    
    Component.onCompleted: {
        console.log("TaskwarriorWidget loaded")
    }
    
    // Task refresh timer
    Timer {
        id: refreshTimer
        interval: 30000 // 30 seconds
        running: true
        repeat: true
        triggeredOnStart: true
        
        onTriggered: {
            taskProcess.running = true
        }
    }
    
    // Process to get tasks (with StdioCollector)
    Process {
        id: taskProcess
        command: ["bash", "-c", "task export status:pending limit:5 2>&1"]
        
        stdout: StdioCollector {
            onStreamFinished: {
                console.log("Task stdout received:", this.text)
                if (this.text && this.text.trim()) {
                    // Check if it's an error message
                    if (this.text.includes("error") || this.text.includes("Error") || this.text.includes("command not found")) {
                        console.error("Task command error:", this.text)
                        tasks = []
                        return
                    }
                    
                    try {
                        var taskData = JSON.parse(this.text.trim())
                        // Filter only pending tasks
                        var pendingTasks = taskData.filter(function(task) {
                            return task.status === "pending"
                        })
                        tasks = pendingTasks || []
                        console.log("Loaded", tasks.length, "pending tasks from StdioCollector")
                    } catch (e) {
                        console.error("Failed to parse task JSON:", e)
                        console.error("Raw text:", this.text)
                        tasks = []
                    }
                } else {
                    console.error("Empty or null stdout from task command")
                    tasks = []
                }
            }
        }
        
        onExited: function(exitCode) {
            console.log("Task process exited with code:", exitCode)
            if (exitCode !== 0) {
                console.error("Task command failed with exit code:", exitCode)
            }
        }
    }
    
    // Header
    Rectangle {
        Layout.fillWidth: true
        height: 30
        color: "transparent"
        
        RowLayout {
            anchors.fill: parent
            anchors.margins: 5
            
            Text {
                text: "📋 Tasks"
                color: "#cad3f5" // Catppuccin Macchiato Text
                font.bold: true
                font.pixelSize: 12
                Layout.alignment: Qt.AlignLeft
            }
            
            Text {
                text: tasks.length > 0 ? tasks.length.toString() : "0"
                color: "#94e2d5" // Catppuccin Macchiato Teal
                font.bold: true
                font.pixelSize: 10
                Layout.alignment: Qt.AlignRight
            }
        }
        
        // MouseArea for opening TUI
        MouseArea {
            anchors.fill: parent
            z: 1
            onClicked: {
                console.log("Opening taskwarrior-tui")
                // Open taskwarrior-tui
                Qt.createQmlObject(`
                    import Quickshell.Io
                    Process {
                        command: ["wezterm", "start", "--", "taskwarrior-tui"]
                        running: true
                    }
                `, taskwarriorWidget)
            }
        }
    }
    
    // Task list
    Repeater {
        model: tasks.length
        
        Rectangle {
            Layout.fillWidth: true
            height: Math.max(40, taskContent.implicitHeight + 10)
            color: Qt.rgba(0.15, 0.15, 0.25, 0.8)
            border.color: getPriorityColor(tasks[index])
            border.width: 1
            radius: 5
            
            function getPriorityColor(task) {
                if (!task || !task.priority) return "#5b6078" // Surface1
                
                switch (task.priority) {
                    case "H": return "#ed8796" // Red
                    case "M": return "#eed49f" // Yellow  
                    case "L": return "#a5adcb" // Subtext0
                    default: return "#5b6078" // Surface1
                }
            }
            
            ColumnLayout {
                id: taskContent
                anchors.fill: parent
                anchors.margins: 8
                spacing: 2
                
                // Task description
                Text {
                    text: tasks[index] ? (tasks[index].description || "No description") : ""
                    color: "#cad3f5" // Text
                    font.pixelSize: 11
                    font.bold: tasks[index] && tasks[index].priority === "H"
                    Layout.fillWidth: true
                    wrapMode: Text.WordWrap
                    maximumLineCount: 2
                    elide: Text.ElideRight
                }
                
                // Task metadata
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 8
                    
                    // Project
                    Text {
                        text: (tasks[index] && tasks[index].project) ? "📁 " + tasks[index].project : ""
                        color: "#8aadf4" // Blue
                        font.pixelSize: 9
                        visible: !!(tasks[index] && tasks[index].project)
                    }
                    
                    // Priority
                    Text {
                        text: (tasks[index] && tasks[index].priority) ? "⚡ " + tasks[index].priority : ""
                        color: getPriorityColor(tasks[index])
                        font.pixelSize: 9
                        font.bold: true
                        visible: !!(tasks[index] && tasks[index].priority)
                    }
                    
                    // Due date
                    Text {
                        text: (tasks[index] && tasks[index].due) ? "📅 " + formatDate(tasks[index].due) : ""
                        color: isOverdue(tasks[index]) ? "#ed8796" : "#f5a97f" // Red if overdue, Peach otherwise
                        font.pixelSize: 9
                        visible: !!(tasks[index] && tasks[index].due)
                    }
                    
                    Item { Layout.fillWidth: true } // Spacer
                    
                    // Task ID
                    Text {
                        text: (tasks[index] && tasks[index].id !== undefined) ? "#" + tasks[index].id : ""
                        color: "#6e738d" // Overlay0
                        font.pixelSize: 8
                    }
                }
            }
            
            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton | Qt.RightButton
                
                onClicked: function(mouse) {
                    if (mouse.button === Qt.LeftButton) {
                        // Left click: mark as done
                        if (tasks[index] && tasks[index].id) {
                            Qt.createQmlObject(`
                                import Quickshell.Io
                                Process {
                                    command: ["task", "${tasks[index].id}", "done"]
                                    running: true
                                    onExited: {
                                        if (exitCode === 0) {
                                            refreshTimer.triggered()
                                        }
                                    }
                                }
                            `, taskwarriorWidget)
                        }
                    } else if (mouse.button === Qt.RightButton) {
                        // Right click: open TUI and edit the specific task
                        if (tasks[index] && tasks[index].id) {
                            Qt.createQmlObject(`
                                import Quickshell.Io
                                Process {
                                    command: ["wezterm", "start", "--", "bash", "-c", "echo 'Task Details:' && task ${tasks[index].id} info && echo '\\n--- Press Enter to open TUI or Ctrl+C to exit ---' && read && taskwarrior-tui"]
                                    running: true
                                }
                            `, taskwarriorWidget)
                        }
                    }
                }
            }
        }
    }
    
    // Empty state
    Rectangle {
        Layout.fillWidth: true
        height: 60
        color: "transparent"
        visible: tasks.length === 0
        
        Text {
            anchors.centerIn: parent
            text: "✨ No pending tasks"
            color: "#a5adcb" // Subtext0
            font.pixelSize: 11
            font.italic: true
        }
    }
    
    // Helper functions
    function formatDate(dateString) {
        if (!dateString || dateString === undefined) return ""
        
        try {
            var date = new Date(dateString)
            var now = new Date()
            var diffTime = date.getTime() - now.getTime()
            var diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24))
            
            if (diffDays === 0) return "Today"
            if (diffDays === 1) return "Tomorrow"
            if (diffDays === -1) return "Yesterday"
            if (diffDays > 1) return diffDays + "d"
            if (diffDays < -1) return Math.abs(diffDays) + "d ago"
            
            return date.toLocaleDateString()
        } catch (e) {
            return ""
        }
    }
    
    function isOverdue(task) {
        if (!task || !task.due || task.due === undefined) return false
        
        try {
            var dueDate = new Date(task.due)
            var now = new Date()
            return dueDate < now
        } catch (e) {
            return false
        }
    }
}