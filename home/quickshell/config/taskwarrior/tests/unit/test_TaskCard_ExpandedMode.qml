import QtQuick
import QtTest

TestCase {
    id: testCase
    name: "TaskCard_ExpandedMode"
    
    // Test component loader
    Component {
        id: taskCardComponent
        
        Item {
            width: 400
            height: 600
            
            // Load TaskCard from parent directory
            Loader {
                id: loader
                anchors.fill: parent
                source: "../../TaskCard.qml"
            }
            
            property alias taskCard: loader.item
        }
    }
    
    function test_listView_exists() {
        var container = createTemporaryObject(taskCardComponent, testCase)
        verify(container !== null, "Container should be created")
        
        var card = container.taskCard
        verify(card !== null, "TaskCard should be loaded")
        
        // Find the ListView by searching children
        var listView = findListView(card)
        verify(listView !== null, "ListView should exist in TaskCard")
    }
    
    function test_listView_hidden_when_collapsed() {
        var container = createTemporaryObject(taskCardComponent, testCase)
        var card = container.taskCard
        
        // Set up test data
        card.clientName = "TestClient"
        card.tasks = [
            { description: "Task 1", uuid: "uuid1", status: "pending" },
            { description: "Task 2", uuid: "uuid2", status: "pending" }
        ]
        card.isExpanded = false
        
        wait(100) // Wait for UI to update
        
        // Find the task list container
        var listContainer = findTaskListContainer(card)
        verify(listContainer !== null, "Task list container should exist")
        verify(!listContainer.visible, "Task list container should be hidden when collapsed")
    }
    
    function test_listView_visible_when_expanded() {
        var container = createTemporaryObject(taskCardComponent, testCase)
        var card = container.taskCard
        
        // Set up test data
        card.clientName = "TestClient"
        card.tasks = [
            { description: "Task 1", uuid: "uuid1", status: "pending" },
            { description: "Task 2", uuid: "uuid2", status: "pending" }
        ]
        card.isExpanded = true
        
        wait(100) // Wait for UI to update
        
        // Find the task list container
        var listContainer = findTaskListContainer(card)
        verify(listContainer !== null, "Task list container should exist")
        verify(listContainer.visible, "Task list container should be visible when expanded")
    }
    
    function test_listView_displays_all_tasks() {
        var container = createTemporaryObject(taskCardComponent, testCase)
        var card = container.taskCard
        
        // Set up test data with 3 tasks
        card.clientName = "TestClient"
        card.tasks = [
            { description: "Task 1", uuid: "uuid1", status: "pending" },
            { description: "Task 2", uuid: "uuid2", status: "pending" },
            { description: "Task 3", uuid: "uuid3", status: "pending" }
        ]
        card.isExpanded = true
        
        wait(100) // Wait for UI to update
        
        // Find the ListView
        var listView = findListView(card)
        verify(listView !== null, "ListView should exist")
        compare(listView.count, 3, "ListView should have 3 items")
    }
    
    function test_card_height_adjusts_when_expanded() {
        var container = createTemporaryObject(taskCardComponent, testCase)
        var card = container.taskCard
        
        // Set up test data
        card.clientName = "TestClient"
        card.tasks = [
            { description: "Task 1", uuid: "uuid1", status: "pending" },
            { description: "Task 2", uuid: "uuid2", status: "pending" }
        ]
        
        // Start collapsed
        card.isExpanded = false
        wait(100)
        var collapsedHeight = card.height
        
        // Expand
        card.isExpanded = true
        wait(300) // Wait for animation
        var expandedHeight = card.height
        
        verify(expandedHeight > collapsedHeight, 
               "Card height should increase when expanded (collapsed: " + collapsedHeight + ", expanded: " + expandedHeight + ")")
    }
    
    function test_listView_model_bound_to_tasks_property() {
        var container = createTemporaryObject(taskCardComponent, testCase)
        var card = container.taskCard
        
        // Set initial tasks
        card.tasks = [
            { description: "Task 1", uuid: "uuid1", status: "pending" }
        ]
        card.isExpanded = true
        wait(100)
        
        var listView = findListView(card)
        compare(listView.count, 1, "ListView should have 1 item initially")
        
        // Update tasks
        card.tasks = [
            { description: "Task 1", uuid: "uuid1", status: "pending" },
            { description: "Task 2", uuid: "uuid2", status: "pending" }
        ]
        wait(100)
        
        compare(listView.count, 2, "ListView should update to 2 items")
    }
    
    // Helper function to find ListView in component tree
    function findListView(item) {
        if (!item) return null
        
        // Check if this item is a ListView
        if (item.toString().indexOf("ListView") !== -1) {
            return item
        }
        
        // Recursively search children
        var children = item.children
        if (children) {
            for (var i = 0; i < children.length; i++) {
                var result = findListView(children[i])
                if (result !== null) {
                    return result
                }
            }
        }
        
        return null
    }
    
    // Helper function to find task list container
    function findTaskListContainer(item) {
        if (!item) return null
        
        // Look for Item with id "taskListContainer"
        if (item.objectName === "taskListContainer" || 
            (item.toString().indexOf("Item") !== -1 && item.visible !== undefined)) {
            // Check if this item contains a ListView
            var listView = findListView(item)
            if (listView !== null) {
                return item
            }
        }
        
        // Recursively search children
        var children = item.children
        if (children) {
            for (var i = 0; i < children.length; i++) {
                var result = findTaskListContainer(children[i])
                if (result !== null) {
                    return result
                }
            }
        }
        
        return null
    }
}
