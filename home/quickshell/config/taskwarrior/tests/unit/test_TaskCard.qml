import QtQuick
import QtTest

TestCase {
    id: testCase
    name: "TaskCardTests"
    
    // Test component loader
    Component {
        id: taskCardComponent
        
        Item {
            width: 400
            height: 600
            
            // Load TaskCard dynamically
            Loader {
                id: cardLoader
                source: "../../TaskCard.qml"
                width: parent.width
            }
            
            property alias card: cardLoader.item
        }
    }
    
    function test_taskCard_initialState() {
        var container = createTemporaryObject(taskCardComponent, testCase)
        verify(container !== null, "Container should be created")
        verify(container.card !== null, "TaskCard should be loaded")
        
        // Verify initial state is compact (not expanded)
        compare(container.card.isExpanded, false, "Card should start in compact mode")
    }
    
    function test_taskCard_clientNameProperty() {
        var container = createTemporaryObject(taskCardComponent, testCase)
        verify(container.card !== null)
        
        // Set client name
        container.card.clientName = "Test Client"
        compare(container.card.clientName, "Test Client", "Client name should be set")
    }
    
    function test_taskCard_tasksProperty() {
        var container = createTemporaryObject(taskCardComponent, testCase)
        verify(container.card !== null)
        
        // Set tasks array
        var testTasks = [
            { description: "Task 1", uuid: "uuid-1" },
            { description: "Task 2", uuid: "uuid-2" }
        ]
        container.card.tasks = testTasks
        compare(container.card.tasks.length, 2, "Tasks array should have 2 items")
    }
    
    function test_taskCard_expansionToggle() {
        var container = createTemporaryObject(taskCardComponent, testCase)
        verify(container.card !== null)
        
        // Initially compact
        compare(container.card.isExpanded, false)
        
        // Toggle to expanded
        container.card.isExpanded = true
        compare(container.card.isExpanded, true, "Card should be expanded")
        
        // Toggle back to compact
        container.card.isExpanded = false
        compare(container.card.isExpanded, false, "Card should be compact")
    }
    
    function test_taskCard_stateTransition() {
        var container = createTemporaryObject(taskCardComponent, testCase)
        verify(container.card !== null)
        
        // Set some tasks
        container.card.tasks = [
            { description: "Task 1" },
            { description: "Task 2" }
        ]
        
        // Check compact state height
        compare(container.card.isExpanded, false)
        compare(container.card.height, 60, "Compact mode height should be 60")
        
        // Expand and verify height changes
        container.card.isExpanded = true
        wait(250) // Wait for animation to complete
        verify(container.card.height > 60, "Expanded mode height should be greater than 60")
    }
    
    function test_taskCard_expansionSignal() {
        var container = createTemporaryObject(taskCardComponent, testCase)
        verify(container.card !== null)
        
        var signalSpy = createTemporaryObject(signalSpyComponent, testCase, {
            target: container.card,
            signalName: "expansionChanged"
        })
        
        // Trigger expansion
        container.card.isExpanded = true
        container.card.expansionChanged(true)
        
        compare(signalSpy.count, 1, "expansionChanged signal should be emitted once")
        compare(signalSpy.signalArguments[0][0], true, "Signal should pass true for expanded state")
    }
    
    Component {
        id: signalSpyComponent
        SignalSpy {}
    }
    
    function test_taskCard_hasHighPriorityTask_withHighPriority() {
        var container = createTemporaryObject(taskCardComponent, testCase)
        verify(container.card !== null)
        
        // Set tasks with high priority
        container.card.tasks = [
            { description: "Task 1", priority: "H" },
            { description: "Task 2", priority: "M" }
        ]
        
        verify(container.card.hasHighPriorityTask(), "Should detect high priority task")
    }
    
    function test_taskCard_hasHighPriorityTask_withoutHighPriority() {
        var container = createTemporaryObject(taskCardComponent, testCase)
        verify(container.card !== null)
        
        // Set tasks without high priority
        container.card.tasks = [
            { description: "Task 1", priority: "M" },
            { description: "Task 2", priority: "L" }
        ]
        
        verify(!container.card.hasHighPriorityTask(), "Should not detect high priority task")
    }
    
    function test_taskCard_hasHighPriorityTask_emptyTasks() {
        var container = createTemporaryObject(taskCardComponent, testCase)
        verify(container.card !== null)
        
        // Set empty tasks array
        container.card.tasks = []
        
        verify(!container.card.hasHighPriorityTask(), "Should return false for empty tasks")
    }
    
    function test_taskCard_hasHighPriorityTask_noPriority() {
        var container = createTemporaryObject(taskCardComponent, testCase)
        verify(container.card !== null)
        
        // Set tasks without priority field
        container.card.tasks = [
            { description: "Task 1" },
            { description: "Task 2" }
        ]
        
        verify(!container.card.hasHighPriorityTask(), "Should return false when no priority defined")
    }
}
