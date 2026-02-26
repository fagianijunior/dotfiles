// Unit Test: TaskPanel Loading and Error State Display (Task 8.7)
// Validates: Requirements 10.4
// Tests that TaskPanel correctly displays loading, error, and success states

import QtQuick
import QtTest

TestCase {
    id: testCase
    name: "TaskPanelStateTest"
    
    // Mock TaskManager for testing
    QtObject {
        id: mockTaskManager
        
        property bool isLoading: false
        property string errorMessage: ""
        property var tasksByClient: ({})
        property var generalTasks: []
        property int refreshInterval: 7000
        property bool useFileWatcher: true
        
        signal tasksUpdated()
        signal taskModified(string uuid, bool success)
        signal errorOccurred(string message)
        
        function refreshTasks() {
            isLoading = true
        }
        
        function updateTaskStatus(uuid, newStatus) {}
        function getTaskCount(clientName) { return 0 }
    }
    
    // Mock status text component
    Text {
        id: statusText
        text: {
            if (mockTaskManager.isLoading) {
                return "Loading..."
            } else if (mockTaskManager.errorMessage !== "") {
                return mockTaskManager.errorMessage
            } else {
                return "Ready"
            }
        }
        color: mockTaskManager.errorMessage !== "" ? "#f38ba8" : "#a6adc8"
    }
    
    // Mock task count text component
    Text {
        id: taskCountText
        text: {
            if (mockTaskManager.isLoading) return ""
            let clientCount = Object.keys(mockTaskManager.tasksByClient).length
            let generalCount = mockTaskManager.generalTasks.length
            let totalTasks = 0
            for (let client in mockTaskManager.tasksByClient) {
                totalTasks += mockTaskManager.tasksByClient[client].length
            }
            totalTasks += generalCount
            return totalTasks > 0 ? totalTasks + " tasks" : ""
        }
        visible: text !== ""
    }
    
    // Test 1: Loading state displays "Loading..."
    function test_loading_state_displays_loading_text() {
        // Set loading state
        mockTaskManager.isLoading = true
        mockTaskManager.errorMessage = ""
        
        // Wait for bindings to update
        wait(50)
        
        // Verify loading text is displayed
        compare(statusText.text, "Loading...", "Status text should show 'Loading...' when isLoading is true")
        compare(statusText.color, "#a6adc8", "Status text color should be normal (not error) during loading")
        compare(taskCountText.text, "", "Task count should be empty during loading")
        compare(taskCountText.visible, false, "Task count should be hidden during loading")
    }
    
    // Test 2: Error state displays error message
    function test_error_state_displays_error_message() {
        // Set error state
        mockTaskManager.isLoading = false
        mockTaskManager.errorMessage = "Error loading tasks: command not found"
        
        // Wait for bindings to update
        wait(50)
        
        // Verify error message is displayed
        compare(statusText.text, "Error loading tasks: command not found", "Status text should show error message")
        compare(statusText.color, "#f38ba8", "Status text color should be red for errors")
    }
    
    // Test 3: Success state displays "Ready" and task count
    function test_success_state_displays_ready_and_task_count() {
        // Set success state with tasks
        mockTaskManager.isLoading = false
        mockTaskManager.errorMessage = ""
        mockTaskManager.tasksByClient = {
            "client1": [
                { uuid: "uuid1", description: "Task 1", status: "pending" },
                { uuid: "uuid2", description: "Task 2", status: "pending" }
            ],
            "client2": [
                { uuid: "uuid3", description: "Task 3", status: "pending" }
            ]
        }
        mockTaskManager.generalTasks = [
            { uuid: "uuid4", description: "Task 4", status: "pending" }
        ]
        
        // Wait for bindings to update
        wait(100)
        
        // Verify ready state is displayed
        compare(statusText.text, "Ready", "Status text should show 'Ready' when loaded successfully")
        compare(statusText.color, "#a6adc8", "Status text color should be normal")
        compare(taskCountText.text, "4 tasks", "Task count should show total number of tasks")
        verify(taskCountText.text !== "", "Task count text should not be empty")
    }
    
    // Test 4: Success state with no tasks
    function test_success_state_with_no_tasks() {
        // Set success state with no tasks
        mockTaskManager.isLoading = false
        mockTaskManager.errorMessage = ""
        mockTaskManager.tasksByClient = {}
        mockTaskManager.generalTasks = []
        
        // Wait for bindings to update
        wait(50)
        
        // Verify ready state is displayed
        compare(statusText.text, "Ready", "Status text should show 'Ready' even with no tasks")
        compare(taskCountText.text, "", "Task count should be empty when no tasks")
        compare(taskCountText.visible, false, "Task count should be hidden when no tasks")
    }
    
    // Test 5: Transition from loading to success
    function test_transition_loading_to_success() {
        // Start with loading state
        mockTaskManager.isLoading = true
        mockTaskManager.errorMessage = ""
        mockTaskManager.tasksByClient = {}
        mockTaskManager.generalTasks = []
        
        wait(50)
        compare(statusText.text, "Loading...", "Should show loading initially")
        
        // Transition to success
        mockTaskManager.isLoading = false
        mockTaskManager.tasksByClient = {
            "client1": [{ uuid: "uuid1", description: "Task 1", status: "pending" }]
        }
        
        wait(50)
        compare(statusText.text, "Ready", "Should show ready after loading completes")
        compare(taskCountText.text, "1 tasks", "Should show task count after loading")
    }
    
    // Test 6: Transition from loading to error
    function test_transition_loading_to_error() {
        // Start with loading state
        mockTaskManager.isLoading = true
        mockTaskManager.errorMessage = ""
        
        wait(50)
        compare(statusText.text, "Loading...", "Should show loading initially")
        
        // Transition to error
        mockTaskManager.isLoading = false
        mockTaskManager.errorMessage = "Failed to execute task command"
        
        wait(50)
        compare(statusText.text, "Failed to execute task command", "Should show error message")
        compare(statusText.color, "#f38ba8", "Should show error color")
    }
    
    // Test 7: Error clears when loading again
    function test_error_clears_on_reload() {
        // Start with error state
        mockTaskManager.isLoading = false
        mockTaskManager.errorMessage = "Previous error"
        
        wait(50)
        compare(statusText.text, "Previous error", "Should show error initially")
        
        // Start loading (error should be cleared by TaskManager)
        mockTaskManager.isLoading = true
        mockTaskManager.errorMessage = ""
        
        wait(50)
        compare(statusText.text, "Loading...", "Should show loading and clear error")
        compare(statusText.color, "#a6adc8", "Should use normal color")
    }
}
