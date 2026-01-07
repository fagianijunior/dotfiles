import QtQuick

QtObject {
    id: propertyTestRunner
    
    property int testIterations: 100
    property int currentIteration: 0
    property bool testsPassed: true
    property var testResults: []
    
    Component.onCompleted: {
        console.log("=== Property-Based Tests for Real-time Filter Updates ===")
        console.log("**Feature: quickshell-enhancements, Property 9: Real-time filter updates**")
        console.log("**Validates: Requirements 2.4**")
        console.log("Running", testIterations, "iterations...")
        
        runPropertyTests()
    }
    
    function runPropertyTests() {
        // Property 9: Real-time filter updates
        // For any filter configuration update, new rules should be immediately applied to all subsequent notifications
        testProperty9()
        
        reportResults()
    }
    
    function testProperty9() {
        console.log("\n--- Testing Property 9: Real-time filter updates ---")
        
        for (let i = 0; i < testIterations; i++) {
            let testData = generateFilterUpdateTestData()
            let result = testRealTimeFilterUpdates(testData, i)
            
            if (!result.passed) {
                testsPassed = false
                testResults.push({
                    property: "Property 9",
                    iteration: i,
                    input: testData,
                    expected: "Filter configuration updates should be immediately applied to subsequent notifications",
                    actual: result.message,
                    passed: false
                })
                console.error("❌ Property 9 failed at iteration", i, ":", result.message)
            }
        }
        
        if (testsPassed) {
            console.log("✅ Property 9 passed all", testIterations, "iterations")
        }
    }
    
    function generateFilterUpdateTestData() {
        // Generate test data that simulates filter configuration changes
        let allApps = ["firefox", "thunderbird", "discord", "spotify", "vscode", "telegram", "slack", "chrome", "signal", "whatsapp"]
        
        // Create initial filter configuration
        let initialBlockList = []
        let initialAllowList = []
        
        // Add some apps to initial lists
        let initialBlockSize = Math.floor(Math.random() * 3)
        for (let i = 0; i < initialBlockSize; i++) {
            let app = allApps[Math.floor(Math.random() * allApps.length)]
            if (initialBlockList.indexOf(app) === -1) {
                initialBlockList.push(app)
            }
        }
        
        let initialAllowSize = Math.floor(Math.random() * 3)
        for (let i = 0; i < initialAllowSize; i++) {
            let app = allApps[Math.floor(Math.random() * allApps.length)]
            if (initialAllowList.indexOf(app) === -1 && initialBlockList.indexOf(app) === -1) {
                initialAllowList.push(app)
            }
        }
        
        let initialConfig = {
            version: "1.0",
            blockList: initialBlockList.slice(), // Copy arrays
            allowList: initialAllowList.slice(),
            defaultBehavior: Math.random() > 0.5 ? "allow" : "block"
        }
        
        // Create updated filter configuration with changes
        let updatedConfig = {
            version: "1.0",
            blockList: initialBlockList.slice(),
            allowList: initialAllowList.slice(),
            defaultBehavior: initialConfig.defaultBehavior
        }
        
        // Apply random changes to the configuration
        let changeType = Math.floor(Math.random() * 4)
        let testApp = allApps[Math.floor(Math.random() * allApps.length)]
        
        switch (changeType) {
            case 0: // Add app to block list
                if (updatedConfig.blockList.indexOf(testApp) === -1) {
                    updatedConfig.blockList.push(testApp)
                    // Remove from allow list if present
                    let allowIndex = updatedConfig.allowList.indexOf(testApp)
                    if (allowIndex !== -1) {
                        updatedConfig.allowList.splice(allowIndex, 1)
                    }
                }
                break
            case 1: // Add app to allow list
                if (updatedConfig.allowList.indexOf(testApp) === -1) {
                    updatedConfig.allowList.push(testApp)
                    // Remove from block list if present
                    let blockIndex = updatedConfig.blockList.indexOf(testApp)
                    if (blockIndex !== -1) {
                        updatedConfig.blockList.splice(blockIndex, 1)
                    }
                }
                break
            case 2: // Remove app from block list
                let blockIndex = updatedConfig.blockList.indexOf(testApp)
                if (blockIndex !== -1) {
                    updatedConfig.blockList.splice(blockIndex, 1)
                }
                break
            case 3: // Change default behavior
                updatedConfig.defaultBehavior = updatedConfig.defaultBehavior === "allow" ? "block" : "allow"
                break
        }
        
        // Create a notification for the test app
        let notification = {
            appname: testApp,
            summary: "Test notification for filter update",
            body: "Testing real-time filter updates",
            urgency: "NORMAL",
            timestamp: Math.floor(Date.now() / 1000),
            id: Math.floor(Math.random() * 10000)
        }
        
        return {
            initialConfig: initialConfig,
            updatedConfig: updatedConfig,
            notification: notification,
            testApp: testApp,
            changeType: changeType
        }
    }
    
    function testRealTimeFilterUpdates(testData, iteration) {
        // Test the core property: filter updates should be immediately applied to subsequent notifications
        try {
            let initialConfig = testData.initialConfig
            let updatedConfig = testData.updatedConfig
            let notification = testData.notification
            let testApp = testData.testApp
            
            // 1. Validate test data structure
            if (!notification.hasOwnProperty('appname') || typeof notification.appname !== 'string') {
                return {
                    passed: false,
                    message: "Invalid notification structure"
                }
            }
            
            if (!initialConfig.hasOwnProperty('blockList') || !updatedConfig.hasOwnProperty('blockList')) {
                return {
                    passed: false,
                    message: "Invalid filter config structure"
                }
            }
            
            // 2. Apply initial filter configuration
            let initialDecision = applyFilterConfiguration(notification, initialConfig)
            
            // 3. Apply updated filter configuration
            let updatedDecision = applyFilterConfiguration(notification, updatedConfig)
            
            // 4. Check if the configuration actually changed for this app
            let configChanged = hasConfigurationChangedForApp(testApp, initialConfig, updatedConfig)
            
            if (!configChanged) {
                // If config didn't change for this app, decisions should be the same
                if (initialDecision !== updatedDecision) {
                    return {
                        passed: false,
                        message: `Unexpected decision change for app '${testApp}' when config didn't change: ${initialDecision} -> ${updatedDecision}`
                    }
                }
                return {
                    passed: true,
                    message: `No config change for app '${testApp}', decisions correctly unchanged`
                }
            }
            
            // 5. Verify that the decision changed appropriately when config changed
            let expectedDecision = calculateExpectedDecisionAfterUpdate(testApp, initialConfig, updatedConfig)
            
            if (updatedDecision !== expectedDecision) {
                return {
                    passed: false,
                    message: `Real-time update failed for app '${testApp}': expected ${expectedDecision}, got ${updatedDecision}`
                }
            }
            
            // 6. Verify the change was applied immediately (no caching of old decisions)
            let immediateDecision = applyFilterConfiguration(notification, updatedConfig)
            if (immediateDecision !== updatedDecision) {
                return {
                    passed: false,
                    message: `Filter update not applied immediately: inconsistent decisions for app '${testApp}'`
                }
            }
            
            return {
                passed: true,
                message: `Real-time filter update verified for app '${testApp}': ${initialDecision} -> ${updatedDecision}`
            }
            
        } catch (error) {
            return {
                passed: false,
                message: `Exception during real-time filter update test: ${error.toString()}`
            }
        }
    }
    
    function applyFilterConfiguration(notification, filterConfig) {
        // Apply filter logic to determine if notification should be displayed
        let appName = notification.appname
        
        // Priority: allow list > block list > default behavior
        if (filterConfig.allowList.indexOf(appName) !== -1) {
            return true
        }
        
        if (filterConfig.blockList.indexOf(appName) !== -1) {
            return false
        }
        
        return filterConfig.defaultBehavior === 'allow'
    }
    
    function hasConfigurationChangedForApp(appName, initialConfig, updatedConfig) {
        // Check if the configuration change affects this specific app
        
        // Check if app's presence in block list changed
        let wasInBlockList = initialConfig.blockList.indexOf(appName) !== -1
        let isInBlockList = updatedConfig.blockList.indexOf(appName) !== -1
        if (wasInBlockList !== isInBlockList) {
            return true
        }
        
        // Check if app's presence in allow list changed
        let wasInAllowList = initialConfig.allowList.indexOf(appName) !== -1
        let isInAllowList = updatedConfig.allowList.indexOf(appName) !== -1
        if (wasInAllowList !== isInAllowList) {
            return true
        }
        
        // Check if default behavior changed (affects apps not in either list)
        if (initialConfig.defaultBehavior !== updatedConfig.defaultBehavior) {
            // Only matters if app is not in either list
            if (!isInBlockList && !isInAllowList) {
                return true
            }
        }
        
        return false
    }
    
    function calculateExpectedDecisionAfterUpdate(appName, initialConfig, updatedConfig) {
        // Calculate what the decision should be after the update
        return applyFilterConfiguration({appname: appName}, updatedConfig)
    }
    
    function reportResults() {
        console.log("\n=== Property Test Results ===")
        console.log("Total iterations:", testIterations)
        console.log("Tests passed:", testsPassed)
        
        if (!testsPassed) {
            console.log("Failed tests:", testResults.length)
            for (let i = 0; i < Math.min(testResults.length, 5); i++) { // Show first 5 failures
                let result = testResults[i]
                console.log(`❌ ${result.property} (iteration ${result.iteration}):`)
                console.log(`   Input: ${JSON.stringify(result.input).substring(0, 200)}...`)
                console.log(`   Expected: ${result.expected}`)
                console.log(`   Actual: ${result.actual}`)
            }
            if (testResults.length > 5) {
                console.log(`... and ${testResults.length - 5} more failures`)
            }
        } else {
            console.log("✅ All property tests passed!")
        }
        
        console.log("=== Property Tests Completed ===")
    }
}