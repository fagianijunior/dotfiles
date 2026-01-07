import QtQuick

QtObject {
    id: testRunner
    
    Component.onCompleted: {
        console.log("=== Testing Notification Filter Logic ===")
        runLogicTests()
    }
    
    function runLogicTests() {
        console.log("Testing core filter logic without I/O dependencies...")
        
        // Test the filter logic directly
        let testConfig = {
            blockList: ["spotify", "discord"],
            allowList: ["firefox", "thunderbird"],
            defaultBehavior: "allow"
        }
        
        console.log("Test configuration:", JSON.stringify(testConfig))
        
        // Test cases
        let testCases = [
            { app: "spotify", expected: false, reason: "blocked app" },
            { app: "discord", expected: false, reason: "blocked app" },
            { app: "firefox", expected: true, reason: "allowed app" },
            { app: "thunderbird", expected: true, reason: "allowed app" },
            { app: "unknown-app", expected: true, reason: "default allow" },
            { app: "", expected: true, reason: "empty app name" },
        ]
        
        console.log("\nRunning test cases:")
        for (let i = 0; i < testCases.length; i++) {
            let testCase = testCases[i]
            let result = applyFilterLogic(testCase.app, testConfig)
            let passed = result === testCase.expected
            
            console.log(`Test ${i + 1}: ${testCase.app || '(empty)'} -> ${result} (expected: ${testCase.expected}) [${testCase.reason}] ${passed ? '✅' : '❌'}`)
        }
        
        // Test priority logic (allow list overrides block list)
        console.log("\nTesting priority logic:")
        let conflictConfig = {
            blockList: ["test-app"],
            allowList: ["test-app"], // Same app in both lists
            defaultBehavior: "block"
        }
        
        let priorityResult = applyFilterLogic("test-app", conflictConfig)
        console.log(`Priority test: test-app in both lists -> ${priorityResult} (should be true - allow list priority) ${priorityResult === true ? '✅' : '❌'}`)
        
        console.log("\n=== Logic Tests Completed ===")
    }
    
    function applyFilterLogic(appName, config) {
        // Replicate the filter logic from NotificationFilter.qml
        if (!appName || typeof appName !== 'string') {
            return config.defaultBehavior === "allow"
        }
        
        // Priority: allow list > block list > default behavior
        if (config.allowList.indexOf(appName) !== -1) {
            return true
        }
        
        if (config.blockList.indexOf(appName) !== -1) {
            return false
        }
        
        return config.defaultBehavior === "allow"
    }
}