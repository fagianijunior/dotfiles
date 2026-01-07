import QtQuick
import "./filters"

Item {
    id: testRunner
    
    Timer {
        id: testTimer
        interval: 1000
        onTriggered: {
            runIntegrationTests()
        }
    }
    
    NotificationFilter {
        id: testFilter
    }
    
    Component.onCompleted: {
        console.log("=== Testing Notification Filter Integration ===")
        
        // Wait a moment for the filter to load its configuration
        testTimer.start()
    }
    
    function runIntegrationTests() {
        console.log("Running notification filter integration tests...")
        
        // Test 1: Check if filter loads configuration
        console.log("Test 1: Configuration loading")
        console.log("Config loaded:", testFilter.configLoaded)
        console.log("Block list:", JSON.stringify(testFilter.blockList))
        console.log("Allow list:", JSON.stringify(testFilter.allowList))
        console.log("Default behavior:", testFilter.defaultBehavior)
        
        // Test 2: Test filtering logic
        console.log("\nTest 2: Filter logic")
        
        // Test blocked app (spotify should be blocked by default config)
        let spotifyResult = testFilter.shouldDisplayNotification("spotify")
        console.log("Spotify notification (should be blocked):", spotifyResult)
        
        // Test allowed app (firefox should be allowed by default config)
        let firefoxResult = testFilter.shouldDisplayNotification("firefox")
        console.log("Firefox notification (should be allowed):", firefoxResult)
        
        // Test unknown app (should use default behavior)
        let unknownResult = testFilter.shouldDisplayNotification("unknown-app")
        console.log("Unknown app notification (should use default):", unknownResult)
        
        // Test 3: Dynamic configuration changes
        console.log("\nTest 3: Dynamic configuration changes")
        
        // Add an app to block list
        let addResult = testFilter.addToBlockList("test-app")
        console.log("Added test-app to block list:", addResult)
        
        // Test if it's now blocked
        let testAppResult = testFilter.shouldDisplayNotification("test-app")
        console.log("Test-app notification after blocking:", testAppResult)
        
        // Move it to allow list
        let allowResult = testFilter.addToAllowList("test-app")
        console.log("Added test-app to allow list:", allowResult)
        
        // Test if it's now allowed
        let testAppResult2 = testFilter.shouldDisplayNotification("test-app")
        console.log("Test-app notification after allowing:", testAppResult2)
        
        // Test 4: Filter statistics
        console.log("\nTest 4: Filter statistics")
        let stats = testFilter.getFilterStats()
        console.log("Filter stats:", JSON.stringify(stats))
        
        // Test 5: Filter reasons
        console.log("\nTest 5: Filter reasons")
        console.log("Spotify filter reason:", testFilter.getFilterReason("spotify"))
        console.log("Firefox filter reason:", testFilter.getFilterReason("firefox"))
        console.log("Unknown app filter reason:", testFilter.getFilterReason("unknown-app"))
        
        console.log("\n=== Integration Tests Completed ===")
    }
}