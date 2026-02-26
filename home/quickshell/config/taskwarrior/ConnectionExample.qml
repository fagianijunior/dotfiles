// ConnectionExample.qml - Integration Pattern Documentation
// This file demonstrates how to connect DataWatcher to TaskManager
// This pattern will be used in TaskPanel.qml (Task 8)
// Validates: Requirements 7.2, 7.3

import Quickshell
import QtQuick

QtObject {
    id: root
    
    // ---- Component Instances ----
    
    // TaskManager handles all Taskwarrior data operations
    TaskManager {
        id: taskManager
        
        // Configuration
        refreshInterval: 7000
        useFileWatcher: true
        
        // Signal handlers for monitoring state
        onTasksUpdated: {
            console.log("Tasks updated - UI should refresh now")
            // In TaskPanel, this will trigger ListView model updates
        }
        
        onErrorOccurred: function(message) {
            console.error("TaskManager error:", message)
            // In TaskPanel, this will update error display
        }
        
        onTaskModified: function(uuid, success) {
            if (success) {
                console.log("Task modified successfully:", uuid)
            } else {
                console.error("Task modification failed:", uuid)
            }
        }
    }
    
    // DataWatcher monitors Taskwarrior data files for changes
    DataWatcher {
        id: dataWatcher
        
        // Configuration - point to user's Taskwarrior directory
        taskDataPath: Quickshell.env("HOME") + "/.task"
        enabled: true
        pollingInterval: taskManager.refreshInterval
        
        // ---- KEY CONNECTION ----
        // Wire dataChanged signal to TaskManager's refreshTasks() method
        // This implements Requirements 7.2 and 7.3:
        // - When Taskwarrior data changes, Data_Layer shall reload Task_Export data (7.2)
        // - When Task_Export data is reloaded, Rendering_Layer shall update displayed tasks (7.3)
        onDataChanged: {
            console.log("Data change detected - triggering task refresh")
            taskManager.refreshTasks()
        }
    }
    
    // ---- Initialization ----
    
    Component.onCompleted: {
        console.log("Connection example initialized")
        console.log("DataWatcher monitoring:", dataWatcher.taskDataPath)
        
        // Perform initial data load
        taskManager.refreshTasks()
    }
    
    // ---- Usage Notes ----
    
    // When implementing TaskPanel.qml (Task 8), follow this pattern:
    //
    // 1. Instantiate TaskManager and DataWatcher as shown above
    // 2. Connect dataWatcher.onDataChanged to taskManager.refreshTasks()
    // 3. Connect taskManager.onTasksUpdated to your UI update logic
    // 4. Call taskManager.refreshTasks() on Component.onCompleted for initial load
    //
    // This ensures:
    // - Automatic refresh when Taskwarrior data changes (via file watcher or polling)
    // - UI updates when task data is reloaded (via tasksUpdated signal)
    // - Non-blocking operation (all Process executions are async)
    // - Proper error handling (via errorOccurred signal)
    //
    // Example UI update in TaskPanel:
    //
    // TaskManager {
    //     id: taskManager
    //     onTasksUpdated: {
    //         // Rebuild ListModel from tasksByClient and generalTasks
    //         taskCardModel.clear()
    //         for (const client in taskManager.tasksByClient) {
    //             taskCardModel.append({
    //                 clientName: client,
    //                 tasks: taskManager.tasksByClient[client]
    //             })
    //         }
    //         if (taskManager.generalTasks.length > 0) {
    //             taskCardModel.append({
    //                 clientName: "General",
    //                 tasks: taskManager.generalTasks
    //             })
    //         }
    //     }
    // }
}
