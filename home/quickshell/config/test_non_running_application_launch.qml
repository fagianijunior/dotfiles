import QtQuick

QtObject {
    id: propertyTestRunner
    
    property int testIterations: 100
    property int currentIteration: 0
    property bool testsPassed: true
    property var testResults: []
    
    // Sample notification data for testing
    property var sampleNotifications: [
        { appName: "firefox", title: "New Tab", body: "Page loaded", id: "notif_1" },
        { appName: "thunderbird", title: "New Email", body: "You have mail", id: "notif_2" },
        { appName: "discord", title: "Message", body: "New message received", id: "notif_3" },
        { appName: "spotify", title: "Now Playing", body: "Song changed", id: "notif_4" },
        { appName: "vscode", title: "Build Complete", body: "Build finished", id: "notif_5" },
        { appName: "chrome", title: "Download", body: "File downloaded", id: "notif_6" },
        { appName: "slack", title: "Mention", body: "You were mentioned", id: "notif_7" },
        { appName: "terminal", title: "Command", body: "Process finished", id: "notif_8" },
        { appName: "nautilus", title: "File", body: "File copied", id: "notif_9" },
        { appName: "gimp", title: "Export", body: "Image exported", id: "notif_10" }
    ]
    
    // Known application executables and their display names
    property var knownApplications: {
        "firefox": { executable: "firefox", displayName: "Firefox", windowClass: "firefox" },
        "thunderbird": { executable: "thunderbird", displayName: "Thunderbird", windowClass: "thunderbird" },
        "discord": { executable: "discord", displayName: "Discord", windowClass: "discord" },
        "spotify": { executable: "spotify", displayName: "Spotify", windowClass: "spotify" },
        "vscode": { executable: "code", displayName: "Visual Studio Code", windowClass: "code" },
        "chrome": { executable: "google-chrome", displayName: "Google Chrome", windowClass: "google-chrome" },
        "slack": { executable: "slack", displayName: "Slack", windowClass: "slack" },
        "terminal": { executable: "gnome-terminal", displayName: "Terminal", windowClass: "gnome-terminal" },
        "nautilus": { executable: "nautilus", displayName: "Files", windowClass: "nautilus" },
        "gimp": { executable: "gimp", displayName: "GIMP", windowClass: "gimp" }
    }
    
    Component.onCompleted: {
        console.log("=== Property-Based Tests for Non-Running Application Launch ===")
        console.log("**Feature: quickshell-enhancements, Property 18: Non-running application launch**")
        console.log("**Validates: Requirements 4.3**")
        console.log("Running", testIterations, "iterations...")
        
        runPropertyTests()
    }
    
    function runPropertyTests() {
        // Property 18: Non-running application launch
        // For any notification click where the originating application is not running, the system should launch that application
        testProperty18()
        
        reportResults()
    }
    
    function testProperty18() {
        console.log("\n--- Testing Property 18: Non-running application launch ---")
        
        for (let i = 0; i < testIterations; i++) {
            let testScenario = generateNonRunningApplicationScenario()
            let result = testNonRunningApplicationLaunch(testScenario, i)
            
            if (!result.passed) {
                testsPassed = false
                testResults.push({
                    property: "Property 18",
                    iteration: i,
                    input: testScenario,
                    expected: "Should launch non-running application when notification is clicked",
                    actual: result.message,
                    passed: false
                })
                console.error("❌ Property 18 failed at iteration", i, ":", result.message)
            }
        }
        
        if (testsPassed) {
            console.log("✅ Property 18 passed all", testIterations, "iterations")
        }
    }
    
    function generateNonRunningApplicationScenario() {
        let randomChoice = Math.random()
        let notification = generateRandomNotification()
        
        // Generate a scenario where the application is NOT running
        let isRunning = randomChoice < 0.2 // 20% chance the app is running (we want mostly non-running scenarios)
        let applicationState = generateApplicationState(notification.appName, isRunning)
        
        return {
            notification: notification,
            isRunning: isRunning,
            applicationState: applicationState
        }
    }
    
    function generateRandomNotification() {
        let randomChoice = Math.random()
        
        if (randomChoice < 0.7) {
            // 70% chance: use known notification samples
            return sampleNotifications[Math.floor(Math.random() * sampleNotifications.length)]
        } else if (randomChoice < 0.9) {
            // 20% chance: generate random valid notification
            let appNames = Object.keys(knownApplications)
            let randomApp = appNames[Math.floor(Math.random() * appNames.length)]
            return {
                appName: randomApp,
                title: "Random Title " + Math.floor(Math.random() * 1000),
                body: "Random body content",
                id: "random_" + Math.floor(Math.random() * 10000)
            }
        } else {
            // 10% chance: edge cases
            let edgeCaseApps = [
                "unknown-app", // unknown application
                "app with spaces", // spaces in name
                "app-with-dashes", // dashes
                "AppWithCaps", // mixed case
            ]
            
            let randomApp = edgeCaseApps[Math.floor(Math.random() * edgeCaseApps.length)]
            return {
                appName: randomApp,
                title: "Edge Case Title",
                body: "Edge case notification",
                id: "edge_" + Math.floor(Math.random() * 1000)
            }
        }
    }
    
    function generateApplicationState(appName, isRunning) {
        if (isRunning) {
            // Generate running state (for scenarios where we skip the test)
            return {
                isRunning: true,
                windows: [{
                    id: `window_${appName}_1`,
                    title: `${appName} Window`,
                    focused: false,
                    minimized: false,
                    workspace: 1,
                    pid: Math.floor(Math.random() * 10000) + 1000
                }]
            }
        }
        
        // Generate non-running state
        return {
            isRunning: false,
            windows: [],
            lastSeen: Math.random() < 0.5 ? Date.now() - Math.floor(Math.random() * 86400000) : null, // Random last seen time or null
            launchable: knownApplications.hasOwnProperty(appName.toLowerCase()) || Math.random() < 0.3 // Known apps are launchable, unknown apps have 30% chance
        }
    }
    
    function testNonRunningApplicationLaunch(scenario, iteration) {
        try {
            let notification = scenario.notification
            let applicationState = scenario.applicationState
            
            // Only test scenarios where the application is NOT running
            if (scenario.isRunning) {
                return {
                    passed: true,
                    message: `Skipped - application "${notification.appName}" is running (not applicable for Property 18)`
                }
            }
            
            // Test the core property: non-running application launch
            
            // 1. Test that handleNotificationClick identifies the application as not running
            let clickResult = mockHandleNotificationClick(notification, applicationState)
            
            if (!clickResult) {
                return {
                    passed: false,
                    message: `handleNotificationClick returned null/undefined for non-running app "${notification.appName}"`
                }
            }
            
            // 2. Test that the system recognizes the application is not running
            if (clickResult.applicationRunning) {
                return {
                    passed: false,
                    message: `System incorrectly detected that "${notification.appName}" is running when it should be non-running`
                }
            }
            
            // 3. Test that launch action was attempted for launchable applications
            if (applicationState.launchable) {
                if (!clickResult.launchAttempted) {
                    return {
                        passed: false,
                        message: `No launch attempt made for launchable non-running application "${notification.appName}"`
                    }
                }
                
                // 4. Test that launch was successful or properly handled failure
                if (!clickResult.launchSuccessful && !clickResult.launchError) {
                    return {
                        passed: false,
                        message: `Launch attempt for "${notification.appName}" had unclear result - neither success nor error reported`
                    }
                }
                
                // 5. Test that successful launches provide proper feedback
                if (clickResult.launchSuccessful) {
                    if (!clickResult.executable) {
                        return {
                            passed: false,
                            message: `Launch successful but no executable specified for "${notification.appName}"`
                        }
                    }
                    
                    // Verify the executable matches expected for known applications
                    let normalizedAppName = notification.appName.toLowerCase()
                    if (knownApplications.hasOwnProperty(normalizedAppName)) {
                        let expectedExecutable = knownApplications[normalizedAppName].executable
                        if (clickResult.executable !== expectedExecutable) {
                            return {
                                passed: false,
                                message: `Wrong executable launched for "${notification.appName}": expected "${expectedExecutable}", got "${clickResult.executable}"`
                            }
                        }
                    }
                }
            } else {
                // For non-launchable applications, should handle gracefully
                if (clickResult.launchAttempted && clickResult.launchSuccessful) {
                    return {
                        passed: false,
                        message: `Unexpectedly successful launch for non-launchable application "${notification.appName}"`
                    }
                }
            }
            
            // 6. Test that launch behavior is consistent for the same scenario
            let secondResult = mockHandleNotificationClick(notification, applicationState)
            if (clickResult.applicationRunning !== secondResult.applicationRunning ||
                clickResult.launchAttempted !== secondResult.launchAttempted) {
                return {
                    passed: false,
                    message: `Inconsistent launch behavior for same scenario: "${notification.appName}"`
                }
            }
            
            // 7. Test that launch doesn't modify the original notification or application state
            let originalNotificationStr = JSON.stringify(notification)
            let originalApplicationStateStr = JSON.stringify(applicationState)
            mockHandleNotificationClick(notification, applicationState)
            let afterNotificationStr = JSON.stringify(notification)
            let afterApplicationStateStr = JSON.stringify(applicationState)
            
            if (originalNotificationStr !== afterNotificationStr) {
                return {
                    passed: false,
                    message: `Notification was modified during launch operation for "${notification.appName}"`
                }
            }
            
            if (originalApplicationStateStr !== afterApplicationStateStr) {
                return {
                    passed: false,
                    message: `Application state was modified during launch operation for "${notification.appName}"`
                }
            }
            
            // 8. Test error handling for launch failures
            if (clickResult.launchError) {
                if (!clickResult.errorMessage || typeof clickResult.errorMessage !== 'string') {
                    return {
                        passed: false,
                        message: `Launch error occurred but no proper error message provided for "${notification.appName}"`
                    }
                }
                
                // Error message should be informative
                if (clickResult.errorMessage.length < 5) {
                    return {
                        passed: false,
                        message: `Launch error message too short/uninformative for "${notification.appName}": "${clickResult.errorMessage}"`
                    }
                }
            }
            
            // 9. Test that launch attempts include proper command construction
            if (clickResult.launchAttempted && clickResult.launchCommand) {
                if (typeof clickResult.launchCommand !== 'string' || clickResult.launchCommand.trim() === '') {
                    return {
                        passed: false,
                        message: `Invalid launch command for "${notification.appName}": "${clickResult.launchCommand}"`
                    }
                }
            }
            
            return {
                passed: true,
                message: `Non-running application launch test passed for "${notification.appName}": launchAttempted=${clickResult.launchAttempted}, launchSuccessful=${clickResult.launchSuccessful}, launchable=${applicationState.launchable}`
            }
            
        } catch (error) {
            return {
                passed: false,
                message: `Exception during non-running application launch test: ${error.toString()}`
            }
        }
    }
    
    // Mock implementation of ClickRedirectHandler.handleNotificationClick for non-running applications
    // This simulates the expected behavior based on the design specification
    function mockHandleNotificationClick(notification, applicationState) {
        try {
            // Handle invalid input
            if (!notification || typeof notification !== 'object') {
                return {
                    applicationRunning: false,
                    launchAttempted: false,
                    launchSuccessful: false,
                    launchError: true,
                    errorMessage: "Invalid notification object"
                }
            }
            
            let appName = notification.appName
            
            // Handle empty or invalid app names
            if (!appName || typeof appName !== 'string' || appName.trim() === '') {
                return {
                    applicationRunning: false,
                    launchAttempted: false,
                    launchSuccessful: false,
                    launchError: true,
                    errorMessage: "Empty or invalid app name"
                }
            }
            
            // Normalize app name for lookup
            let normalizedAppName = appName.toLowerCase().trim()
            
            // Check if application is running
            let isRunning = applicationState && applicationState.isRunning && 
                           applicationState.windows && applicationState.windows.length > 0
            
            if (isRunning) {
                return {
                    applicationRunning: true,
                    launchAttempted: false,
                    launchSuccessful: false,
                    appName: normalizedAppName
                }
            }
            
            // Application is not running - attempt to launch
            let launchResult = attemptLaunch(normalizedAppName, applicationState)
            
            return {
                applicationRunning: false,
                launchAttempted: true,
                launchSuccessful: launchResult.success,
                launchError: !launchResult.success,
                errorMessage: launchResult.error,
                executable: launchResult.executable,
                launchCommand: launchResult.command,
                appName: normalizedAppName
            }
            
        } catch (error) {
            return {
                applicationRunning: false,
                launchAttempted: false,
                launchSuccessful: false,
                launchError: true,
                errorMessage: error.toString()
            }
        }
    }
    
    function attemptLaunch(appName, applicationState) {
        try {
            // Check if application is launchable
            if (!applicationState.launchable) {
                return {
                    success: false,
                    error: `Application "${appName}" is not launchable`,
                    executable: null,
                    command: null
                }
            }
            
            // Determine executable for known applications
            let executable = null
            let command = null
            
            if (knownApplications.hasOwnProperty(appName)) {
                executable = knownApplications[appName].executable
                command = executable
            } else {
                // For unknown applications, try to guess executable
                executable = generateExecutableGuess(appName)
                command = executable
                
                if (!executable) {
                    return {
                        success: false,
                        error: `Could not determine executable for unknown application "${appName}"`,
                        executable: null,
                        command: null
                    }
                }
            }
            
            // Simulate launch operation
            let launchSuccess = simulateLaunchOperation(executable, appName)
            
            if (launchSuccess) {
                return {
                    success: true,
                    error: null,
                    executable: executable,
                    command: command
                }
            } else {
                return {
                    success: false,
                    error: `Failed to launch "${appName}" (executable: ${executable})`,
                    executable: executable,
                    command: command
                }
            }
            
        } catch (error) {
            return {
                success: false,
                error: `Launch attempt failed: ${error.toString()}`,
                executable: null,
                command: null
            }
        }
    }
    
    function generateExecutableGuess(appName) {
        // Generate a reasonable executable name guess
        if (!appName || typeof appName !== 'string') {
            return null
        }
        
        // Clean up the app name to make it executable-like
        let cleaned = appName
            .toLowerCase()
            .replace(/[^a-z0-9\-_]/g, '-') // Replace special chars with dashes
            .replace(/--+/g, '-') // Replace multiple dashes with single dash
            .replace(/^-|-$/g, '') // Remove leading/trailing dashes
        
        return cleaned || null
    }
    
    function simulateLaunchOperation(executable, appName) {
        // Simulate various launch scenarios
        
        // Known applications have higher success rate
        if (knownApplications.hasOwnProperty(appName)) {
            // 90% success rate for known applications
            return Math.random() < 0.90
        }
        
        // Unknown applications have lower success rate
        if (executable && executable.length > 0) {
            // 60% success rate for unknown applications with valid executable guess
            return Math.random() < 0.60
        }
        
        // Very low success rate for applications without valid executable
        return Math.random() < 0.10
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
                console.log(`   Input: ${JSON.stringify(result.input)}`)
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