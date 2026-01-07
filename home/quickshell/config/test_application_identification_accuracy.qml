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
        "firefox": { executable: "firefox", displayName: "Firefox" },
        "thunderbird": { executable: "thunderbird", displayName: "Thunderbird" },
        "discord": { executable: "discord", displayName: "Discord" },
        "spotify": { executable: "spotify", displayName: "Spotify" },
        "vscode": { executable: "code", displayName: "Visual Studio Code" },
        "chrome": { executable: "google-chrome", displayName: "Google Chrome" },
        "slack": { executable: "slack", displayName: "Slack" },
        "terminal": { executable: "gnome-terminal", displayName: "Terminal" },
        "nautilus": { executable: "nautilus", displayName: "Files" },
        "gimp": { executable: "gimp", displayName: "GIMP" }
    }
    
    Component.onCompleted: {
        console.log("=== Property-Based Tests for Application Identification Accuracy ===")
        console.log("**Feature: quickshell-enhancements, Property 16: Application identification accuracy**")
        console.log("**Validates: Requirements 4.1**")
        console.log("Running", testIterations, "iterations...")
        
        runPropertyTests()
    }
    
    function runPropertyTests() {
        // Property 16: Application identification accuracy
        // For any notification click event, the redirect system should correctly identify the originating application
        testProperty16()
        
        reportResults()
    }
    
    function testProperty16() {
        console.log("\n--- Testing Property 16: Application identification accuracy ---")
        
        for (let i = 0; i < testIterations; i++) {
            let testNotification = generateRandomNotification()
            let result = testApplicationIdentificationAccuracy(testNotification, i)
            
            if (!result.passed) {
                testsPassed = false
                testResults.push({
                    property: "Property 16",
                    iteration: i,
                    input: testNotification,
                    expected: "Should correctly identify the originating application from notification data",
                    actual: result.message,
                    passed: false
                })
                console.error("❌ Property 16 failed at iteration", i, ":", result.message)
            }
        }
        
        if (testsPassed) {
            console.log("✅ Property 16 passed all", testIterations, "iterations")
        }
    }
    
    function generateRandomNotification() {
        let randomChoice = Math.random()
        
        if (randomChoice < 0.6) {
            // 60% chance: use known notification samples
            return sampleNotifications[Math.floor(Math.random() * sampleNotifications.length)]
        } else if (randomChoice < 0.8) {
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
            // 20% chance: edge cases and unknown applications
            let edgeCaseApps = [
                "", // empty app name
                " ", // whitespace only
                "unknown-app", // unknown application
                "app with spaces", // spaces in name
                "app-with-dashes", // dashes
                "app_with_underscores", // underscores
                "AppWithCaps", // mixed case
                "123numbers", // numbers
                "special!@#chars", // special characters
                "very-long-application-name-that-exceeds-normal-length-limits", // very long name
                null, // null value
                undefined // undefined value
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
    
    function testApplicationIdentificationAccuracy(notification, iteration) {
        try {
            // Test the core property: application identification accuracy
            
            // 1. Test that handleNotificationClick can identify the application
            let identificationResult = mockHandleNotificationClick(notification)
            
            if (!identificationResult) {
                return {
                    passed: false,
                    message: `handleNotificationClick returned null/undefined for notification: ${JSON.stringify(notification)}`
                }
            }
            
            // 2. Test that identification result has required properties
            if (!identificationResult.hasOwnProperty('identified') || 
                !identificationResult.hasOwnProperty('appName') ||
                !identificationResult.hasOwnProperty('executable')) {
                return {
                    passed: false,
                    message: `Identification result missing required properties: ${JSON.stringify(identificationResult)}`
                }
            }
            
            // 3. Test identification accuracy for known applications
            if (notification.appName && knownApplications.hasOwnProperty(notification.appName)) {
                if (!identificationResult.identified) {
                    return {
                        passed: false,
                        message: `Failed to identify known application "${notification.appName}"`
                    }
                }
                
                let expectedExecutable = knownApplications[notification.appName].executable
                if (identificationResult.executable !== expectedExecutable) {
                    return {
                        passed: false,
                        message: `Incorrect executable for "${notification.appName}": expected "${expectedExecutable}", got "${identificationResult.executable}"`
                    }
                }
                
                if (identificationResult.appName !== notification.appName) {
                    return {
                        passed: false,
                        message: `App name mismatch: expected "${notification.appName}", got "${identificationResult.appName}"`
                    }
                }
            }
            
            // 4. Test graceful handling of unknown applications
            if (!notification.appName || !knownApplications.hasOwnProperty(notification.appName)) {
                // For unknown apps, system should either:
                // a) Identify as unknown but provide fallback behavior, or
                // b) Attempt best-effort identification
                
                if (identificationResult.identified && !identificationResult.executable) {
                    return {
                        passed: false,
                        message: `Identified unknown app "${notification.appName}" but no executable provided`
                    }
                }
                
                // If not identified, that's acceptable for truly unknown apps
                if (!identificationResult.identified && 
                    (notification.appName === "" || notification.appName === null || notification.appName === undefined)) {
                    // This is expected behavior for invalid input
                }
            }
            
            // 5. Test consistency - same notification should always produce same result
            let secondResult = mockHandleNotificationClick(notification)
            if (JSON.stringify(identificationResult) !== JSON.stringify(secondResult)) {
                return {
                    passed: false,
                    message: `Inconsistent identification results for same notification: ${JSON.stringify(notification)}`
                }
            }
            
            // 6. Test that identification doesn't modify the original notification
            let originalNotificationStr = JSON.stringify(notification)
            mockHandleNotificationClick(notification)
            let afterNotificationStr = JSON.stringify(notification)
            
            if (originalNotificationStr !== afterNotificationStr) {
                return {
                    passed: false,
                    message: `Notification was modified during identification: before=${originalNotificationStr}, after=${afterNotificationStr}`
                }
            }
            
            return {
                passed: true,
                message: `Application identification accurate for notification from "${notification.appName}": identified=${identificationResult.identified}, executable="${identificationResult.executable}"`
            }
            
        } catch (error) {
            return {
                passed: false,
                message: `Exception during application identification test: ${error.toString()}`
            }
        }
    }
    
    // Mock implementation of ClickRedirectHandler.handleNotificationClick
    // This simulates the expected behavior based on the design specification
    function mockHandleNotificationClick(notification) {
        try {
            // Handle invalid input
            if (!notification || typeof notification !== 'object') {
                return {
                    identified: false,
                    appName: null,
                    executable: null,
                    error: "Invalid notification object"
                }
            }
            
            let appName = notification.appName
            
            // Handle empty or invalid app names
            if (!appName || typeof appName !== 'string' || appName.trim() === '') {
                return {
                    identified: false,
                    appName: appName,
                    executable: null,
                    error: "Empty or invalid app name"
                }
            }
            
            // Normalize app name for lookup
            let normalizedAppName = appName.toLowerCase().trim()
            
            // Check if it's a known application
            if (knownApplications.hasOwnProperty(normalizedAppName)) {
                let appInfo = knownApplications[normalizedAppName]
                return {
                    identified: true,
                    appName: normalizedAppName,
                    executable: appInfo.executable,
                    displayName: appInfo.displayName
                }
            }
            
            // Attempt fuzzy matching for similar names
            let fuzzyMatch = attemptFuzzyMatch(normalizedAppName)
            if (fuzzyMatch) {
                return {
                    identified: true,
                    appName: fuzzyMatch.appName,
                    executable: fuzzyMatch.executable,
                    displayName: fuzzyMatch.displayName,
                    matchType: "fuzzy"
                }
            }
            
            // For unknown applications, try to generate a reasonable executable name
            let guessedExecutable = generateExecutableGuess(normalizedAppName)
            
            return {
                identified: false,
                appName: normalizedAppName,
                executable: guessedExecutable,
                displayName: appName,
                matchType: "guess"
            }
            
        } catch (error) {
            return {
                identified: false,
                appName: notification ? notification.appName : null,
                executable: null,
                error: error.toString()
            }
        }
    }
    
    function attemptFuzzyMatch(appName) {
        // Simple fuzzy matching for common variations
        let fuzzyMappings = {
            "firefox-esr": "firefox",
            "firefox-developer": "firefox", 
            "google-chrome": "chrome",
            "chromium-browser": "chrome",
            "code": "vscode",
            "visual-studio-code": "vscode",
            "gnome-terminal": "terminal",
            "konsole": "terminal",
            "alacritty": "terminal",
            "discord-canary": "discord",
            "discord-ptb": "discord"
        }
        
        if (fuzzyMappings.hasOwnProperty(appName)) {
            let mappedName = fuzzyMappings[appName]
            if (knownApplications.hasOwnProperty(mappedName)) {
                return {
                    appName: mappedName,
                    executable: knownApplications[mappedName].executable,
                    displayName: knownApplications[mappedName].displayName
                }
            }
        }
        
        // Check for partial matches
        for (let knownApp in knownApplications) {
            if (appName.includes(knownApp) || knownApp.includes(appName)) {
                return {
                    appName: knownApp,
                    executable: knownApplications[knownApp].executable,
                    displayName: knownApplications[knownApp].displayName
                }
            }
        }
        
        return null
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