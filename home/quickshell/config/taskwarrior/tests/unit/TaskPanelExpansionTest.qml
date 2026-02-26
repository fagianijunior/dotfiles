import QtQuick
import QtTest

/**
 * Unit Test: Single-Focus Card Expansion Logic (Task 8.5)
 * 
 * Tests that only one TaskCard can be expanded at a time (mutual exclusion).
 * Validates Requirement 3.2: "WHEN a Task_Card transitions to Expanded_Mode, 
 * THE Rendering_Layer SHALL transition all other Task_Cards to Compact_Mode"
 */
TestCase {
    id: testCase
    name: "TaskPanelExpansionTest"
    
    // Mock TaskCard component for testing
    Component {
        id: mockTaskCard
        
        Rectangle {
            id: card
            property string clientName: ""
            property bool isExpanded: false
            signal expansionChanged(bool expanded)
            
            width: 200
            height: isExpanded ? 200 : 60
            
            function expand() {
                isExpanded = true
                expansionChanged(true)
            }
            
            function collapse() {
                isExpanded = false
                expansionChanged(false)
            }
        }
    }
    
    // Mock ListView with cards
    Component {
        id: mockListView
        
        ListView {
            id: listView
            width: 300
            height: 400
            
            model: ListModel {
                id: cardModel
            }
            
            delegate: Rectangle {
                id: cardDelegate
                property string clientName: model.clientName
                property bool isExpanded: false
                signal expansionChanged(bool expanded)
                
                width: listView.width
                height: isExpanded ? 200 : 60
                
                function expand() {
                    isExpanded = true
                    expansionChanged(true)
                }
                
                function collapse() {
                    isExpanded = false
                }
                
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        parent.expand()
                        collapseOtherCards(cardDelegate)
                    }
                }
            }
            
            // Single-focus expansion logic (from TaskPanel.qml)
            function collapseOtherCards(expandedCard) {
                for (let i = 0; i < count; i++) {
                    const item = itemAtIndex(i)
                    if (item && item !== expandedCard) {
                        item.isExpanded = false
                    }
                }
            }
            
            // Helper to add cards
            function addCard(name) {
                cardModel.append({ clientName: name })
            }
        }
    }
    
    /**
     * Test 1: Single card expansion
     * Verify that when one card expands, it is the only expanded card
     */
    function test_single_card_expansion() {
        const listView = createTemporaryObject(mockListView, testCase)
        verify(listView !== null, "ListView should be created")
        
        // Add three cards
        listView.addCard("Client A")
        listView.addCard("Client B")
        listView.addCard("Client C")
        
        wait(100) // Wait for items to be created
        
        compare(listView.count, 3, "Should have 3 cards")
        
        // Get card items
        const card1 = listView.itemAtIndex(0)
        const card2 = listView.itemAtIndex(1)
        const card3 = listView.itemAtIndex(2)
        
        verify(card1 !== null, "Card 1 should exist")
        verify(card2 !== null, "Card 2 should exist")
        verify(card3 !== null, "Card 3 should exist")
        
        // Initially all cards should be collapsed
        verify(!card1.isExpanded, "Card 1 should start collapsed")
        verify(!card2.isExpanded, "Card 2 should start collapsed")
        verify(!card3.isExpanded, "Card 3 should start collapsed")
        
        // Expand card 1
        card1.expand()
        listView.collapseOtherCards(card1)
        wait(50)
        
        // Verify only card 1 is expanded
        verify(card1.isExpanded, "Card 1 should be expanded")
        verify(!card2.isExpanded, "Card 2 should be collapsed")
        verify(!card3.isExpanded, "Card 3 should be collapsed")
    }
    
    /**
     * Test 2: Mutual exclusion when expanding different cards
     * Verify that expanding a second card collapses the first
     */
    function test_mutual_exclusion() {
        const listView = createTemporaryObject(mockListView, testCase)
        verify(listView !== null, "ListView should be created")
        
        // Add three cards
        listView.addCard("Client A")
        listView.addCard("Client B")
        listView.addCard("Client C")
        
        wait(100)
        
        const card1 = listView.itemAtIndex(0)
        const card2 = listView.itemAtIndex(1)
        const card3 = listView.itemAtIndex(2)
        
        // Expand card 1
        card1.expand()
        listView.collapseOtherCards(card1)
        wait(50)
        
        verify(card1.isExpanded, "Card 1 should be expanded")
        verify(!card2.isExpanded, "Card 2 should be collapsed")
        verify(!card3.isExpanded, "Card 3 should be collapsed")
        
        // Expand card 2 - should collapse card 1
        card2.expand()
        listView.collapseOtherCards(card2)
        wait(50)
        
        verify(!card1.isExpanded, "Card 1 should now be collapsed")
        verify(card2.isExpanded, "Card 2 should be expanded")
        verify(!card3.isExpanded, "Card 3 should be collapsed")
        
        // Expand card 3 - should collapse card 2
        card3.expand()
        listView.collapseOtherCards(card3)
        wait(50)
        
        verify(!card1.isExpanded, "Card 1 should be collapsed")
        verify(!card2.isExpanded, "Card 2 should now be collapsed")
        verify(card3.isExpanded, "Card 3 should be expanded")
    }
    
    /**
     * Test 3: At most one card expanded at any time
     * Verify the invariant that at most one card is expanded
     */
    function test_at_most_one_expanded() {
        const listView = createTemporaryObject(mockListView, testCase)
        verify(listView !== null, "ListView should be created")
        
        // Add five cards
        for (let i = 0; i < 5; i++) {
            listView.addCard("Client " + String.fromCharCode(65 + i))
        }
        
        wait(100)
        
        // Try expanding each card and verify only one is expanded
        for (let i = 0; i < 5; i++) {
            const card = listView.itemAtIndex(i)
            card.expand()
            listView.collapseOtherCards(card)
            wait(50)
            
            // Count expanded cards
            let expandedCount = 0
            for (let j = 0; j < 5; j++) {
                const c = listView.itemAtIndex(j)
                if (c.isExpanded) {
                    expandedCount++
                }
            }
            
            compare(expandedCount, 1, "Exactly one card should be expanded after expanding card " + i)
            verify(card.isExpanded, "Card " + i + " should be the expanded one")
        }
    }
    
    /**
     * Test 4: Collapsing all cards when clicking the same card
     * Verify that clicking an expanded card collapses it
     */
    function test_collapse_expanded_card() {
        const listView = createTemporaryObject(mockListView, testCase)
        verify(listView !== null, "ListView should be created")
        
        listView.addCard("Client A")
        listView.addCard("Client B")
        
        wait(100)
        
        const card1 = listView.itemAtIndex(0)
        const card2 = listView.itemAtIndex(1)
        
        // Expand card 1
        card1.expand()
        listView.collapseOtherCards(card1)
        wait(50)
        
        verify(card1.isExpanded, "Card 1 should be expanded")
        verify(!card2.isExpanded, "Card 2 should be collapsed")
        
        // Collapse card 1 (simulating toggle behavior)
        card1.collapse()
        wait(50)
        
        verify(!card1.isExpanded, "Card 1 should be collapsed")
        verify(!card2.isExpanded, "Card 2 should be collapsed")
        
        // Count expanded cards - should be zero
        let expandedCount = 0
        for (let i = 0; i < listView.count; i++) {
            if (listView.itemAtIndex(i).isExpanded) {
                expandedCount++
            }
        }
        
        compare(expandedCount, 0, "No cards should be expanded")
    }
}
