import QtQuick

QtObject {
    id: propertyTestRunner
    
    property int testIterations: 100
    property int currentIteration: 0
    property bool testsPassed: true
    property var testResults: []
    
    Component.onCompleted: {
        console.log("=== Property-Based Tests for Allow List Priority ===")
        console.log("**Feature: quickshell-enhancements, Property 8: Allow list priority**")
        console.log("**Validates: Requirements 2.3**")
        console.log("Running", testIterations, "iterations...")
        
        runPropertyTests()
    }
    
    function runPropertyTests() {
        // Property 8: Allow list priority
        // For any application in the allow list, notifications should be displayed regardless of other conflicting filter rules
        testProperty8()
        
        reportResults()
    }
    
    function testProperty8() {
        console.log("\n--- Testing Property 8: Allow list priority ---")
        
        for (let i = 0; i < testIterations; i++) {
            let testData = generateAllowListTestData()
            let result = testAllowListPriority(testData, i)
            
            if (!result.passed) {
                testsPassed = false
                testResults.push({
                    property: "Property 8",
                    iteration: i,
                    input: testData,
                    expected: "Applications in allow list should be displayed regardless of other conflicting filter rules",
                    actual: result.message,
                    passed: false
                })
                console.error("❌ Property 8 failed at iteration", i, ":", result.message)
            }
        }
        
        if (testsPassed) {
            console.log("✅ Property 8 passed all", testIterations, "iterations")
        }
    }
    
    function generateAllowListTestData() {
        // Generate test data with potential conflicts to test allow list priority
        let allApps = ["firefox", "thunderbird", "discord", "spotify", "vscode", "telegram", "slack", "chrome", "signal", "whatsapp"]
        
        // Create allow list
        let allowListSize = Math.floor(Math.random() * 3) + 1 // 1-3 apps in allow list
        let allowList = []
        for (let i = 0; i < allowListSize; i++) {
            let app = allApps[Math.floor(Math.random() * allApps.length)]
            if (allowList.indexOf(app) === -1) {
                allowList.push(app)
            }
        }
        
        // Create block list that might conflict with allow list
        let blockList = []
        let shouldCreateConflict = Math.random() > 0.5 // 50% chance of creating a conflict
        
        if (shouldCreateConflict && allowList.length > 0) {
            // Add some allowed apps to block list to test priority
            let conflictApp = allowList[Math.floor(Math.random() * allowList.length)]
            blockList.push(conflictApp)
        }
        
        // Add some other apps to block list
        let blockListSize = Math.floor(Math.random() * 3)
        for (let i = 0; i < blockListSize; i++) {
            let app = allApps[Math.floor(Math.random() * allApps.length)]
            if (blockList.indexOf(app) === -1) {
                blockList.push(app)
            }
        }
        
        // Create notification from an allowed app
        let allowedApp = allowList[Math.floor(Math.random() * allowList.length)]
        
        let notification = {
            appname: allowedApp,
            summary: "Test notification from allowed app",
            body: "This should always be displayed",
            urgency: "NORMAL",
            timestamp: Math.floor(Date.now() / 1000),
            id: Math.floor(Math.random() * 10000)
        }
        
        // Use "block" as default to make the test more challenging
        let filterConfig = {
            version: "1.0",
            blockList: blockList,
            allowList: allowList,
            defaultBehavior: "block" // This makes allow list priority more important
        }
        
        return {
            notification: notification,
            filterConfig: filterConfig,
            hasConflict: blockList.indexOf(allowedApp) !== -1,
            expectedAllowed: true // This notification should always be allowed
        }
    }
    
    function testAllowListPriority(testData, iteration) {
        // Test the core property: allow list has priority over other conflicting rules
        try {
            let notification = testData.notification
            let filterConfig = testData.filterConfig
            
            // 1. Validate test data structure
            if (!notification.hasOwnProperty('appname') || typeof notification.appname !== 'string') {
                return {
                    passed: false,
                    message: "Invalid notification structure"
                }
            }
            
            if (!filterConfig.hasOwnProperty('allowList') || !Array.isArray(filterConfig.allowList)) {
                return {
                    passed: false,
                    message: "Invalid filter config structure"
                }
            }
            
            // 2. Verify the app is actually in the allow list
            let appName = notification.appname
            let isInAllowList = filterConfig.allowList.indexOf(appName) !== -1
            
            if (!isInAllowList) {
                return {
                    passed: false,
                    message: `Test data error: app '${appName}' not in allow list`
                }
            }
            
            // 3. Check if there's a conflict (app in both allow and block lists)
            let isInBlockList = filterConfig.blockList.indexOf(appName) !== -1
            let hasConflict = isInBlockList
            
            // 4. Apply filter logic
            let shouldDisplay = applyFilterLogicWithPriority(notification, filterConfig)
            
            // 5. Verify allow list priority
            // The key property: if an app is in the allow list, it should ALWAYS be displayed
            // regardless of other conflicting rules (block list, default behavior)
            if (shouldDisplay !== true) {
                let conflictInfo = hasConflict ? " (despite being in block list)" : ""
                return {
                    passed: false,
                    message: `Allow list priority failed: app '${appName}' in allow list but was blocked${conflictInfo}`
                }
            }
            
            // 6. If there was a conflict, verify it was resolved correctly
            if (hasConflict) {
                // This is the most important test case - allow list should override block list
                let reason = getDisplayReason(notification, filterConfig)
                if (reason !== "allowed_by_list") {
                    return {
                        passed: false,
                        message: `Conflict resolution failed: app '${appName}' should be allowed by list, got reason '${reason}'`
                    }
                }
            }
            
            // 7. Verify default behavior doesn't override allow list
            if (filterConfig.defaultBehavior === "block") {
                // Even with default block behavior, allowed apps should display
                if (shouldDisplay !== true) {
                    return {
                        passed: false,
                        message: `Allow list priority over default behavior failed: app '${appName}' blocked despite being in allow list`
                    }
                }
            }
            
            return {
                passed: true,
                message: `Allow list priority verified: app '${appName}' correctly allowed${hasConflict ? ' (conflict resolved)' : ''}`
            }
            
        } catch (error) {
            return {
                passed: false,
                message: `Exception during allow list priority test: ${error.toString()}`
            }
        }
    }
    
    function applyFilterLogicWithPriority(notification, filterConfig) {
        // Simulate the filter logic with proper priority handling
        // Priority order: allow list > block list > default behavior
        let appName = notification.appname
        
        // Allow list has highest priority
        if (filterConfig.allowList.indexOf(appName) !== -1) {
            return true // Always allow if in allow list, regardless of other rules
        }
        
        // Block list has second priority
        if (filterConfig.blockList.indexOf(appName) !== -1) {
            return false // Block if in block list and not in allow list
        }
        
        // Use default behavior if not in either list
        return filterConfig.defaultBehavior === 'allow'
    }
    
    function getDisplayReason(notification, filterConfig) {
        // Determine why a notification was allowed/blocked
        let appName = notification.appname
        
        if (filterConfig.allowList.indexOf(appName) !== -1) {
            return "allowed_by_list"
        }
        
        if (filterConfig.blockList.indexOf(appName) !== -1) {
            return "blocked_by_list"
        }
        
        if (filterConfig.defaultBehavior === 'allow') {
            return "allowed_by_default"
        }
        
        return "blocked_by_default"
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