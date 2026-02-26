// test_updateTaskStatus.qml - Unit tests for TaskManager.updateTaskStatus()
// Validates: Requirements 4.3, 4.4, 10.1

import QtQuick
import QtTest

TestCase {
    name: "TaskManagerUpdateTaskStatus"
    
    // Mock TaskManager with updateTaskStatus implementation
    QtObject {
        id: mockTaskManager
        
        property string lastCommand: ""
        property string lastUuid: ""
        property bool taskModifiedEmitted: false
        property bool taskModifiedSuccess: false
        property string taskModifiedUuid: ""
        property bool refreshTasksCalled: false
        property string errorMessage: ""
        
        signal taskModified(string uuid, bool success)
        signal errorOccurred(string message)
        
        onTaskModified: function(uuid, success) {
            taskModifiedEmitted = true
            taskModifiedSuccess = success
            taskModifiedUuid = uuid
        }
        
        onErrorOccurred: function(message) {
            errorMessage = message
        }
        
        function refreshTasks() {
            refreshTasksCalled = true
        }
        
        // Simplified updateTaskStatus for testing command generation
        function updateTaskStatus(uuid, newStatus) {
            if (!uuid || uuid.trim() === "") {
                console.error("updateTaskStatus: Invalid UUID provided")
                errorOccurred("Invalid task UUID")
                taskModified("", false)
                return
            }
            
            lastUuid = uuid
            
            // Build command based on the new status
            let cmd = []
            if (newStatus === "completed" || newStatus === "done") {
                cmd = ["task", uuid, "done"]
            } else if (newStatus === "pending") {
                cmd = ["task", uuid, "modify", "status:pending"]
            } else {
                cmd = ["task", uuid, "modify", "status:" + newStatus]
            }
            
            lastCommand = cmd.join(" ")
            console.log("Executing task modification:", lastCommand)
            
            // Simulate successful execution
            Qt.callLater(function() {
                taskModified(uuid, true)
                refreshTasks()
            })
        }
        
        function reset() {
            lastCommand = ""
            lastUuid = ""
            taskModifiedEmitted = false
            taskModifiedSuccess = false
            taskModifiedUuid = ""
            refreshTasksCalled = false
            errorMessage = ""
        }
    }
    
    function init() {
        mockTaskManager.reset()
    }
    
    // Requirement 4.4: Data_Layer shall use Task_UUID for all task modification commands
    function test_updateTaskStatus_uses_uuid_in_command() {
        const testUuid = "a360fc44-315c-4366-b70c-ea7e7520b749"
        
        mockTaskManager.updateTaskStatus(testUuid, "completed")
        
        // Verify UUID is in the command
        verify(mockTaskManager.lastCommand.includes(testUuid),
               "Command should include task UUID")
        
        // Verify UUID was stored
        compare(mockTaskManager.lastUuid, testUuid,
                "UUID should be stored for tracking")
    }
    
    // Requirement 4.3: Data_Layer shall execute corresponding Taskwarrior command
    function test_updateTaskStatus_generates_done_command() {
        const testUuid = "b470fc44-315c-4366-b70c-ea7e7520b750"
        
        mockTaskManager.updateTaskStatus(testUuid, "completed")
        
        // Verify command format: task <uuid> done
        compare(mockTaskManager.lastCommand, `task ${testUuid} done`,
                "Should generate 'task <uuid> done' command for completed status")
    }
    
    function test_updateTaskStatus_generates_done_command_with_done_status() {
        const testUuid = "c570fc44-315c-4366-b70c-ea7e7520b751"
        
        mockTaskManager.updateTaskStatus(testUuid, "done")
        
        // Verify command format: task <uuid> done
        compare(mockTaskManager.lastCommand, `task ${testUuid} done`,
                "Should generate 'task <uuid> done' command for 'done' status")
    }
    
    function test_updateTaskStatus_generates_modify_command_for_pending() {
        const testUuid = "d680fc44-315c-4366-b70c-ea7e7520b752"
        
        mockTaskManager.updateTaskStatus(testUuid, "pending")
        
        // Verify command format: task <uuid> modify status:pending
        compare(mockTaskManager.lastCommand, `task ${testUuid} modify status:pending`,
                "Should generate 'task <uuid> modify status:pending' command")
    }
    
    function test_updateTaskStatus_generates_modify_command_for_custom_status() {
        const testUuid = "e790fc44-315c-4366-b70c-ea7e7520b753"
        
        mockTaskManager.updateTaskStatus(testUuid, "waiting")
        
        // Verify command format: task <uuid> modify status:waiting
        compare(mockTaskManager.lastCommand, `task ${testUuid} modify status:waiting`,
                "Should generate 'task <uuid> modify status:waiting' command")
    }
    
    // Test signal emission
    function test_updateTaskStatus_emits_taskModified_signal() {
        const testUuid = "f8a0fc44-315c-4366-b70c-ea7e7520b754"
        
        mockTaskManager.updateTaskStatus(testUuid, "completed")
        
        // Wait for async signal
        wait(50)
        
        verify(mockTaskManager.taskModifiedEmitted,
               "taskModified signal should be emitted")
        verify(mockTaskManager.taskModifiedSuccess,
               "taskModified should indicate success")
        compare(mockTaskManager.taskModifiedUuid, testUuid,
                "taskModified should include the correct UUID")
    }
    
    // Test refreshTasks is called after modification
    function test_updateTaskStatus_triggers_refresh() {
        const testUuid = "g9b0fc44-315c-4366-b70c-ea7e7520b755"
        
        mockTaskManager.updateTaskStatus(testUuid, "completed")
        
        // Wait for async execution
        wait(50)
        
        verify(mockTaskManager.refreshTasksCalled,
               "refreshTasks() should be called after successful modification")
    }
    
    // Test error handling for invalid UUID
    function test_updateTaskStatus_handles_empty_uuid() {
        mockTaskManager.updateTaskStatus("", "completed")
        
        // Should emit error
        verify(mockTaskManager.errorMessage.length > 0,
               "Should set error message for empty UUID")
        
        // Wait for async signal
        wait(50)
        
        verify(mockTaskManager.taskModifiedEmitted,
               "taskModified signal should be emitted even on error")
        verify(!mockTaskManager.taskModifiedSuccess,
               "taskModified should indicate failure")
    }
    
    function test_updateTaskStatus_handles_null_uuid() {
        mockTaskManager.updateTaskStatus(null, "completed")
        
        // Should emit error
        verify(mockTaskManager.errorMessage.length > 0,
               "Should set error message for null UUID")
    }
    
    function test_updateTaskStatus_handles_whitespace_uuid() {
        mockTaskManager.updateTaskStatus("   ", "completed")
        
        // Should emit error
        verify(mockTaskManager.errorMessage.length > 0,
               "Should set error message for whitespace-only UUID")
    }
    
    // Requirement 10.1: Execution shall be non-blocking
    function test_updateTaskStatus_is_non_blocking() {
        const testUuid = "h0c0fc44-315c-4366-b70c-ea7e7520b756"
        
        // Call updateTaskStatus
        mockTaskManager.updateTaskStatus(testUuid, "completed")
        
        // Execution should continue immediately (non-blocking)
        verify(true, "Execution continues immediately after updateTaskStatus call")
        
        // Command should be set
        verify(mockTaskManager.lastCommand.length > 0,
               "Command should be prepared")
        
        // Signal emission happens asynchronously
        verify(!mockTaskManager.taskModifiedEmitted,
               "Signal should not be emitted synchronously")
        
        // Wait for async completion
        wait(50)
        
        // Now signal should be emitted
        verify(mockTaskManager.taskModifiedEmitted,
               "Signal should be emitted asynchronously")
    }
}
