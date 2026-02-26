// TaskItemTest.qml - Unit tests for TaskItem component
// Tests basic functionality, status button, metadata display, and terminal launch

import QtQuick
import QtTest
import "../../"

TestCase {
    name: "TaskItemTest"
    
    // Mock TaskManager for testing
    QtObject {
        id: mockTaskManager
        
        property string lastModifiedUuid: ""
        property string lastModifiedStatus: ""
        property bool modifySuccess: true
        
        signal taskModified(string uuid, bool success)
        
        function updateTaskStatus(uuid, newStatus) {
            lastModifiedUuid = uuid
            lastModifiedStatus = newStatus
            taskModified(uuid, modifySuccess)
        }
    }
    
    // Test: TaskItem renders with valid task data
    function test_taskItem_renders() {
        const task = {
            uuid: "test-uuid-123",
            description: "Test task description",
            status: "pending",
            priority: "H",
            tags: ["work", "urgent"],
            due: "20240125T000000Z"
        }
        
        const item = Qt.createQmlObject(`
            import QtQuick
            import "../../"
            TaskItem {
                task: null
                taskManager: null
            }
        `, this, "taskItemTest")
        
        verify(item !== null, "TaskItem should be created")
        item.task = task
        item.taskManager = mockTaskManager
        
        compare(item.task.uuid, "test-uuid-123")
        compare(item.task.description, "Test task description")
        
        item.destroy()
    }
    
    // Test: Status icon display
    function test_statusIcon_display() {
        const item = Qt.createQmlObject(`
            import QtQuick
            import "../../"
            TaskItem {
                task: null
                taskManager: null
            }
        `, this, "statusIconTest")
        
        compare(item.getStatusIcon("pending"), "⭕")
        compare(item.getStatusIcon("completed"), "✓")
        compare(item.getStatusIcon("done"), "✓")
        compare(item.getStatusIcon("deleted"), "✗")
        compare(item.getStatusIcon("waiting"), "⏸")
        
        item.destroy()
    }
    
    // Test: Priority color mapping
    function test_priorityColor_mapping() {
        const item = Qt.createQmlObject(`
            import QtQuick
            import "../../"
            TaskItem {
                task: null
                taskManager: null
            }
        `, this, "priorityColorTest")
        
        compare(item.getPriorityColor("H"), "#f38ba8")  // Red
        compare(item.getPriorityColor("M"), "#fab387")  // Peach
        compare(item.getPriorityColor("L"), "#89b4fa")  // Blue
        
        item.destroy()
    }
    
    // Test: Due date formatting
    function test_dueDate_formatting() {
        const item = Qt.createQmlObject(`
            import QtQuick
            import "../../"
            TaskItem {
                task: null
                taskManager: null
            }
        `, this, "dueDateTest")
        
        // Test with a specific date (format: YYYYMMDDTHHMMSSZ)
        const formatted = item.formatDueDate("20240125T000000Z")
        verify(formatted.length > 0, "Due date should be formatted")
        
        item.destroy()
    }
    
    // Test: Overdue detection
    function test_overdue_detection() {
        const item = Qt.createQmlObject(`
            import QtQuick
            import "../../"
            TaskItem {
                task: null
                taskManager: null
            }
        `, this, "overdueTest")
        
        // Test with a past date (should be overdue)
        const pastDate = "20200101T000000Z"
        verify(item.isOverdue(pastDate), "Past date should be detected as overdue")
        
        // Test with a future date (should not be overdue)
        const futureDate = "20991231T000000Z"
        verify(!item.isOverdue(futureDate), "Future date should not be overdue")
        
        item.destroy()
    }
    
    // Test: Status update calls TaskManager
    function test_statusUpdate_callsTaskManager() {
        const task = {
            uuid: "test-uuid-456",
            description: "Test task",
            status: "pending"
        }
        
        const item = Qt.createQmlObject(`
            import QtQuick
            import "../../"
            TaskItem {
                task: null
                taskManager: null
            }
        `, this, "statusUpdateTest")
        
        item.task = task
        item.taskManager = mockTaskManager
        
        // Reset mock
        mockTaskManager.lastModifiedUuid = ""
        mockTaskManager.lastModifiedStatus = ""
        
        // Simulate status button click by calling updateTaskStatus directly
        item.taskManager.updateTaskStatus(task.uuid, "completed")
        
        compare(mockTaskManager.lastModifiedUuid, "test-uuid-456")
        compare(mockTaskManager.lastModifiedStatus, "completed")
        
        item.destroy()
    }
    
    // Test: Empty task handling
    function test_emptyTask_handling() {
        const item = Qt.createQmlObject(`
            import QtQuick
            import "../../"
            TaskItem {
                task: null
                taskManager: null
            }
        `, this, "emptyTaskTest")
        
        verify(item !== null, "TaskItem should handle null task")
        
        // Should not crash with null task
        const icon = item.getStatusIcon(null)
        verify(icon !== null, "Should return default icon for null status")
        
        item.destroy()
    }
}

    // Test: Terminal detection initializes
    function test_terminalDetection_initializes() {
        const item = Qt.createQmlObject(`
            import QtQuick
            import "../../"
            TaskItem {
                task: null
                taskManager: null
            }
        `, this, "terminalDetectionTest")
        
        verify(item !== null, "TaskItem should be created")
        
        // Verify terminal fallbacks are defined
        verify(item.terminalFallbacks.length > 0, "Terminal fallbacks should be defined")
        verify(item.terminalFallbacks.includes("kitty"), "kitty should be in fallbacks")
        verify(item.terminalFallbacks.includes("alacritty"), "alacritty should be in fallbacks")
        verify(item.terminalFallbacks.includes("wezterm"), "wezterm should be in fallbacks")
        verify(item.terminalFallbacks.includes("foot"), "foot should be in fallbacks")
        
        item.destroy()
    }
    
    // Test: Hyprland detection function exists
    function test_hyprlandDetection_exists() {
        const item = Qt.createQmlObject(`
            import QtQuick
            import "../../"
            TaskItem {
                task: null
                taskManager: null
            }
        `, this, "hyprlandDetectionTest")
        
        verify(item !== null, "TaskItem should be created")
        verify(typeof item.detectHyprland === "function", "detectHyprland function should exist")
        verify(typeof item.isHyprland === "boolean", "isHyprland property should be boolean")
        
        item.destroy()
    }
    
    // Test: Terminal command generation for kitty with Hyprland
    function test_terminalCommand_kitty_hyprland() {
        const item = Qt.createQmlObject(`
            import QtQuick
            import "../../"
            TaskItem {
                task: null
                taskManager: null
            }
        `, this, "terminalCommandKittyHyprlandTest")
        
        // Simulate Hyprland environment
        item.isHyprland = true
        
        const uuid = "test-uuid-789"
        const command = item.getTerminalCommand("kitty", uuid)
        
        verify(command.length > 0, "Command should be generated")
        compare(command[0], "kitty", "First element should be kitty")
        verify(command.includes("--class"), "Should include --class flag for Hyprland")
        verify(command.includes("floating"), "Should include floating class")
        verify(command.includes("task"), "Should include task command")
        verify(command.includes(uuid), "Should include task UUID")
        verify(command.includes("edit"), "Should include edit command")
        
        item.destroy()
    }
    
    // Test: Terminal command generation for kitty without Hyprland
    function test_terminalCommand_kitty_noHyprland() {
        const item = Qt.createQmlObject(`
            import QtQuick
            import "../../"
            TaskItem {
                task: null
                taskManager: null
            }
        `, this, "terminalCommandKittyNoHyprlandTest")
        
        // Simulate non-Hyprland environment
        item.isHyprland = false
        
        const uuid = "test-uuid-xyz"
        const command = item.getTerminalCommand("kitty", uuid)
        
        verify(command.length > 0, "Command should be generated")
        compare(command[0], "kitty", "First element should be kitty")
        verify(!command.includes("--class"), "Should NOT include --class flag without Hyprland")
        verify(!command.includes("floating"), "Should NOT include floating class without Hyprland")
        verify(command.includes("-e"), "Should include -e flag")
        verify(command.includes("task"), "Should include task command")
        verify(command.includes(uuid), "Should include task UUID")
        verify(command.includes("edit"), "Should include edit command")
        
        item.destroy()
    }
    
    // Test: Terminal command generation for generic terminal
    function test_terminalCommand_generic() {
        const item = Qt.createQmlObject(`
            import QtQuick
            import "../../"
            TaskItem {
                task: null
                taskManager: null
            }
        `, this, "terminalCommandGenericTest")
        
        const uuid = "test-uuid-abc"
        const command = item.getTerminalCommand("alacritty", uuid)
        
        verify(command.length > 0, "Command should be generated")
        compare(command[0], "alacritty", "First element should be alacritty")
        verify(command.includes("-e"), "Should include -e flag")
        verify(command.includes("task"), "Should include task command")
        verify(command.includes(uuid), "Should include task UUID")
        verify(command.includes("edit"), "Should include edit command")
        
        item.destroy()
    }
}
