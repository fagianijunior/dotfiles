import QtQuick
import QtQuick.Layouts
import Quickshell.Io
// A importação do popup foi removida
import "./task_data_model.py" as TaskModel

ColumnLayout {
    id: taskwarriorWidget
    
    // Lista de sumários de projetos, alimentada pelo Python
    property var projectsSummary: []
    // Variável para armazenar o projeto selecionado para o popup
    property var selectedProject: null
    
    Component.onCompleted: {
        console.log("TaskwarriorWidget loaded")
        refreshTimer.triggered() // Inicia o carregamento
    }

    // Processo para carregar o sumário de projetos do Python
    Process {
        id: loadDataProcess
        command: ["python3", "home/quickshell/config/taskwarrior/task_data_model.py"]
        
        stdout: StdioCollector {
            onStreamFinished: {
                if (this.text.trim()) {
                    try {
                        var result = JSON.parse(this.text.trim())
                        if (result.error) {
                            console.error("Erro do script Python:", JSON.stringify(result.error))
                            taskwarriorWidget.projectsSummary = []
                        } else {
                            taskwarriorWidget.projectsSummary = result.projectsSummary || []
                            console.log("Carregado", projectsSummary.length, "resumos de projetos")
                        }
                    } catch (e) {
                        console.error("Falha ao fazer parse do JSON do Python:", e)
                        console.error("Saída bruta:", this.text)
                        taskwarriorWidget.projectsSummary = []
                    }
                } else {
                    console.error("Saída do script Python vazia.")
                    taskwarriorWidget.projectsSummary = []
                }
            }
        }
    }

    // Funções de controle
    function refreshData() {
        loadDataProcess.running = true
    }

    function performAction(taskUuid, action) {
        let actionProcess = Qt.createQmlObject(`
            import Quickshell.Io
            Process {
                command: ["task", "${taskUuid}", "${action}"]
                
                // Coleta saídas para uso posterior no onExited
                property string stdoutText: ""
                property string stderrText: ""

                stdout: StdioCollector {
                    onStreamFinished: parent.stdoutText = this.text.trim()
                }
                stderr: StdioCollector {
                    onStreamFinished: parent.stderrText = this.text.trim()
                }

                onExited: (exitCode) => {
                    // Loga stdout se houver
                    if (stdoutText) console.log("Task Action Stdout:", stdoutText)

                    if (exitCode === 0) {
                        console.log("Ação '${action}' executada com sucesso para ${taskUuid}")
                        
                        // Se houver stderr mas sucesso, é apenas um aviso/info do Taskwarrior
                        if (stderrText) console.log("Task Action Info/Warn:", stderrText)
                        
                        refreshData()
                        // Atualiza popup se necessário
                    } else {
                        // Erro real
                        if (stderrText) console.warn("Task Action Error Output:", stderrText)
                        console.warn("Ação '${action}' falhou com código " + exitCode + ". Verifique se a tarefa já está no estado desejado.")
                    }
                }
            }
        `, taskwarriorWidget)
        actionProcess.running = true
    }
    
    // Timer para recarregar os dados
    Timer {
        id: refreshTimer
        interval: 30000 // 30 segundos
        running: false
        repeat: true
        
        onTriggered: {
            refreshData()
        }
    }
    
    // Loader para o componente Popup
    Loader {
        id: popupLoader
        // A fonte é definida dinamicamente quando o popup é necessário
        
        onLoaded: {
            console.log("Popup Loader loaded item successfully")
            let popup = item
            if (popup) {
                popup.projectData = taskwarriorWidget.selectedProject
                popup.visible = true
                
                // Conecta os sinais
                // Desconecta primeiro para evitar múltiplas conexões se recarregado
                try { popup.taskAction.disconnect(performAction) } catch(e) {}
                try { popup.closePopup.disconnect(closePopupHandler) } catch(e) {}
                
                popup.taskAction.connect(performAction)
                popup.closePopup.connect(closePopupHandler)
            }
        }
        
        // Handler para fechar o popup, definido aqui para poder ser referenciado
        function closePopupHandler() {
            console.log("Closing popup handler triggered")
            if (item) item.visible = false
            taskwarriorWidget.selectedProject = null
            popupLoader.source = "" // Descarrega
            refreshData()
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
                color: "#cad3f5"
                font.bold: true
                font.pixelSize: 12
                Layout.alignment: Qt.AlignLeft
            }
            
            Text {
                text: projectsSummary.reduce((acc, current) => acc + current.count, 0).toString()
                color: "#94e2d5"
                font.bold: true
                font.pixelSize: 10
                Layout.alignment: Qt.AlignRight
            }
        }
        
        MouseArea {
            anchors.fill: parent
            onClicked: {
                // Abre o taskwarrior-tui
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

    // Listagem de Projetos (Repeater)
    Repeater {
        model: taskwarriorWidget.projectsSummary
        
        Rectangle {
            property var projectData: modelData
            
            Layout.fillWidth: true
            height: 40
            color: Qt.rgba(0.15, 0.15, 0.25, 0.8)
            border.color: "#8aadf4"
            border.width: 1
            radius: 5
            
            RowLayout {
                anchors.fill: parent
                anchors.margins: 8
                
                Text {
                    text: "📁 " + projectData.project
                    color: "#cad3f5"
                    font.pixelSize: 12
                    font.bold: true
                }
                
                Item { Layout.fillWidth: true }
                
                Text {
                    text: projectData.count.toString()
                    color: "#94e2d5"
                    font.pixelSize: 12
                    font.bold: true
                }
            }
            
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    console.log("Project clicked:", projectData.project)
                    taskwarriorWidget.selectedProject = projectData
                    
                    // Define a fonte do loader para iniciar o carregamento
                    // Se já estiver carregado, recarrega para garantir estado limpo ou apenas reabre
                    if (popupLoader.source.toString() !== "") {
                         popupLoader.source = ""
                    }
                    console.log("Setting popup source...")
                    popupLoader.source = Qt.resolvedUrl("TaskProjectPopup.qml")
                }
            }
        }
    }

    // Spacer e Empty State (permanecem os mesmos)
    Rectangle {
        Layout.fillWidth: true
        height: 15
        color: "transparent"
        visible: taskwarriorWidget.projectsSummary.length > 0
    }
    
    Rectangle {
        Layout.fillWidth: true
        height: 60
        color: "transparent"
        visible: taskwarriorWidget.projectsSummary.length === 0
        
        Text {
            anchors.centerIn: parent
            text: "✨ No pending projects"
            color: "#a5adcb"
            font.pixelSize: 11
            font.italic: true
        }
    }
}
