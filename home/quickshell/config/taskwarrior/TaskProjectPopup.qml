import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

PopupWindow {
    id: projectPopup
    
    // Força a visibilidade ao ser criado
    visible: true
    
    Component.onCompleted: console.log("TaskProjectPopup created and visible set to true")
    
    // Ancoragem simples na janela pai, sem propriedades conflitantes
    // Isso deve fazer o popup aparecer, possivelmente sobrepondo a barra
    anchor {
        window: rootPanel
    }
    
    // Propriedades expostas
    property var projectData: ({}) 
    
    // Sinais emitidos para o componente pai
    signal closePopup()
    signal taskAction(string taskUuid, string action)
    
    // Propriedade interna para a lista de tarefas hierárquicas
    property var tasksHierarchy: []
    
    implicitWidth: 400
    implicitHeight: 500
    
    // Removidas propriedades x, y, width, height para evitar erros e usar padrões
    
    // O conteúdo visual
    Rectangle {
        anchors.fill: parent
        color: "#24273a" // Base
        radius: 10
        border.color: "#8aadf4" // Blue
        border.width: 1
        
        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 10
            spacing: 10
            
            // Header
            RowLayout {
                Layout.fillWidth: true
                
                Text {
                    text: projectData.project ? "Project: " + projectData.project : "Loading..."
                    color: "#cad3f5"
                    font.pixelSize: 16
                    font.bold: true
                    elide: Text.ElideRight
                    Layout.fillWidth: true
                }
                
                Button {
                    text: "✕"
                    font.pixelSize: 14
                    onClicked: projectPopup.closePopup()
                    
                    background: Rectangle {
                        color: "#ed8796" // Red
                        radius: 5
                        implicitWidth: 30
                        implicitHeight: 30
                    }
                    contentItem: Text {
                        text: parent.text
                        color: "#181926" // Base Text
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                }
            }
            
            // Área de Rolagem para a lista de tarefas
            ScrollView {
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true
                
                // ColumnLayout dentro de ScrollView precisa de ajuste de altura implícita
                contentWidth: availableWidth
                
                ColumnLayout {
                    id: tasksRepeater
                    width: parent.width
                    spacing: 8
                    
                    Repeater {
                        model: tasksHierarchy
                        delegate: Loader {
                            Layout.fillWidth: true
                            // Importante: Loader deve dimensionar sua altura com base no item
                            Layout.preferredHeight: item ? item.implicitHeight : 0
                            
                            sourceComponent: taskItemDelegate
                            
                            onLoaded: {
                                item.taskData = modelData
                            }
                        }
                    }
                }
            }
        }
    }

    // Função para construir a hierarquia
    function buildHierarchy(taskList) {
        let taskMap = {}
        let topLevelTasks = []

        taskList.forEach(task => {
            task.subtasks = []
            taskMap[task.uuid] = task
        })

        taskList.forEach(task => {
            if (task.parent && taskMap[task.parent]) {
                taskMap[task.parent].subtasks.push(task)
            } else {
                topLevelTasks.push(task)
            }
        })
        
        function sortSubtasks(tasks) {
            tasks.sort((a, b) => new Date(a.entry) - new Date(b.entry));
            tasks.forEach(t => {
                if (t.subtasks.length > 0) {
                    sortSubtasks(t.subtasks);
                }
            });
        }
        
        sortSubtasks(topLevelTasks);
        return topLevelTasks
    }

    // Trigger para carregar tarefas
    onVisibleChanged: {
        if (visible && projectData.tasks) {
            tasksHierarchy = buildHierarchy(projectData.tasks)
        }
    }

    // Delegate Component
    Component {
        id: taskItemDelegate
        
        ColumnLayout {
            id: taskItemLayout
            property var taskData: modelData
            
            width: parent.width // Usa a largura do pai (Loader -> ColumnLayout)
            spacing: 4
            
            // Altura implícita calculada automaticamente pelo ColumnLayout

            Rectangle {
                Layout.fillWidth: true
                implicitHeight: taskContentRow.implicitHeight + 16 // Padding
                color: "#363a4f" // Surface0
                radius: 8
                
                RowLayout {
                    id: taskContentRow
                    anchors.fill: parent
                    anchors.margins: 8
                    spacing: 10
                    
                    Process {
                        id: taskProcess
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor

                        onClicked: {
                            taskProcess.command = ["wezterm", "start", "--", "bash", "-c", "task " + taskData.uuid + " info; read -p 'Pressione Enter para fechar...'"]
                            taskProcess.running = true
                        }
                    }
                    // Texto da Tarefa
                    Text {
                        text: taskData.description || "Sem descrição"
                        color: "#cad3f5"
                        font.pixelSize: 12
                        Layout.fillWidth: true
                        wrapMode: Text.WordWrap
                        elide: Text.ElideRight
                        maximumLineCount: 3
                    }
                    
                    // Botões de Ação
                    RowLayout {
                        Layout.alignment: Qt.AlignRight | Qt.AlignTop
                        spacing: 5
                        
                        Button {
                            text: "✓"
                            font.bold: true
                            onClicked: projectPopup.taskAction(taskData.uuid, 'done')

                            ToolTip.visible: hovered
                            ToolTip.text: "Marcar tarefa como concluída"

                            background: Rectangle {
                                color: "#a6da95"
                                radius: 4
                                implicitWidth: 30
                                implicitHeight: 30
                            }

                            contentItem: Text {
                                text: parent.text
                                color: "#181926"
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }
                        }
                        
                        Button {
                            text: "▶"
                            font.bold: true
                            onClicked: projectPopup.taskAction(taskData.uuid, 'start')
                            
                            ToolTip.visible: hovered
                            ToolTip.text: "Iniciar tarefa"

                            background: Rectangle { 
                                color: "#8aadf4" // Blue
                                radius: 4 
                                implicitWidth: 30
                                implicitHeight: 30
                            }
                            contentItem: Text {
                                text: parent.text
                                color: "#181926"
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }
                        }
                    }
                }
            }
            
            // Subtarefas (Recursão)
            Repeater {
                model: taskData.subtasks || []
                delegate: Loader {
                    Layout.fillWidth: true
                    Layout.leftMargin: 20 // Indentação visual para subtarefas
                    Layout.preferredHeight: item ? item.implicitHeight : 0
                    
                    sourceComponent: taskItemDelegate
                    
                    onLoaded: {
                        item.modelData = modelData
                    }
                }
            }
        }
    }
}
