# DataWatcher to TaskManager Connection Pattern

## Overview

This document describes how to connect the DataWatcher component to the TaskManager component to enable automatic task refresh when Taskwarrior data changes.

## Requirements

This connection pattern implements:
- **Requirement 7.2**: When Taskwarrior data changes, Data_Layer shall reload Task_Export data
- **Requirement 7.3**: When Task_Export data is reloaded, Rendering_Layer shall update displayed tasks

## Connection Pattern

### Basic Connection

The connection is established through QML signal-slot mechanism:

```qml
DataWatcher {
    id: dataWatcher
    taskDataPath: Quickshell.env("HOME") + "/.task"
    enabled: true
    
    onDataChanged: {
        taskManager.refreshTasks()
    }
}

TaskManager {
    id: taskManager
    
    onTasksUpdated: {
        // Update UI here
    }
}
```

### Data Flow

1. **Change Detection** (DataWatcher)
   - FileView monitors `~/.task/pending.data` and `~/.task/completed.data`
   - When files change, FileView emits `fileChanged` signal
   - DataWatcher emits `dataChanged` signal

2. **Data Reload** (TaskManager)
   - `dataChanged` signal triggers `taskManager.refreshTasks()`
   - TaskManager executes `task status:pending export` command
   - JSON output is parsed and grouped by client attribute

3. **UI Update** (Rendering Layer)
   - TaskManager emits `tasksUpdated` signal
   - UI components rebuild their models from `tasksByClient` and `generalTasks`
   - ListView displays updated task cards

### Timing Diagram

```
File Change → FileView.fileChanged → DataWatcher.dataChanged
                                            ↓
                                    TaskManager.refreshTasks()
                                            ↓
                                    Process: task export
                                            ↓
                                    JSON parsing & grouping
                                            ↓
                                    TaskManager.tasksUpdated
                                            ↓
                                    UI Model Update
                                            ↓
                                    ListView Refresh
```

## Implementation in TaskPanel

When implementing TaskPanel.qml (Task 8), use this pattern:

```qml
import Quickshell
import QtQuick

Item {
    id: taskPanel
    
    // Data Layer Components
    TaskManager {
        id: taskManager
        refreshInterval: 7000
        useFileWatcher: true
        
        onTasksUpdated: {
            // Rebuild task card model
            rebuildTaskCardModel()
        }
        
        onErrorOccurred: function(message) {
            errorText.text = message
            errorText.visible = true
        }
    }
    
    DataWatcher {
        id: dataWatcher
        taskDataPath: Quickshell.env("HOME") + "/.task"
        enabled: true
        pollingInterval: taskManager.refreshInterval
        
        // KEY CONNECTION: Wire dataChanged to refreshTasks
        onDataChanged: {
            taskManager.refreshTasks()
        }
    }
    
    // UI Components
    ListView {
        id: taskCardList
        model: taskCardModel
        delegate: TaskCard { }
    }
    
    ListModel {
        id: taskCardModel
    }
    
    // Helper function to rebuild model from TaskManager data
    function rebuildTaskCardModel() {
        taskCardModel.clear()
        
        // Add client-specific cards
        for (const client in taskManager.tasksByClient) {
            taskCardModel.append({
                clientName: client,
                tasks: taskManager.tasksByClient[client]
            })
        }
        
        // Add general card if there are tasks without client
        if (taskManager.generalTasks.length > 0) {
            taskCardModel.append({
                clientName: "General",
                tasks: taskManager.generalTasks
            })
        }
    }
    
    Component.onCompleted: {
        // Initial data load
        taskManager.refreshTasks()
    }
}
```

## Fallback Behavior

### File Watcher Unavailable

If FileView fails to monitor files:
- DataWatcher automatically falls back to polling mode
- Timer triggers `dataChanged` every 7 seconds (configurable)
- Same connection pattern applies - no code changes needed

### Error Handling

If task export fails:
- TaskManager emits `errorOccurred` signal
- UI can display error message
- Previous task data is preserved (not cleared)
- Next refresh attempt will retry

## Testing

The connection can be tested with mock components:

```qml
// Mock TaskManager
QtObject {
    property int refreshCallCount: 0
    function refreshTasks() { refreshCallCount++ }
}

// Mock DataWatcher
QtObject {
    signal dataChanged()
    onDataChanged: mockTaskManager.refreshTasks()
}

// Test
mockDataWatcher.dataChanged()
verify(mockTaskManager.refreshCallCount === 1)
```

See `tests/test_connection.qml` for complete test implementation.

## Benefits of This Pattern

1. **Loose Coupling**: DataWatcher and TaskManager are independent components
2. **Automatic Refresh**: No manual polling needed in UI code
3. **Non-Blocking**: All operations are asynchronous
4. **Testable**: Components can be tested independently
5. **Flexible**: Easy to add additional signal handlers or modify behavior

## References

- **ConnectionExample.qml**: Complete working example
- **tests/test_connection.qml**: Unit tests for connection pattern
- **Design Document**: Section on "Architecture" and "Component Overview"
- **Requirements**: 7.2 (Data reload) and 7.3 (UI update)
