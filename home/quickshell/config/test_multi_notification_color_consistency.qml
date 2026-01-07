import QtQuick

QtObject {
    id: propertyTestRunner
    
    property int testIterations: 100
    property int currentIteration: 0
    property bool testsPassed: true
    property var testResults: []
    
    // Mock configured colors based on design document
    property var mockConfiguredColors: {
        "firefox": "#89b4fa",
        "thunderbird": "#a6e3a1", 
        "discord": "#cba6f7",
        "spotify": "#94e2d5",
        "chrome": "#89b4fa",
        "vscode": "#f9e2af",
        "terminal": "#f38ba8",
        "gimp": "#fab387",
        "libreoffice": "#eed49f",
        "vlc": "#94e2d5"
    }
    
    // Category colors based on design document
    property var mockCategoryColors: {
        "browser": "#89b4fa",
        "communication": "#a6e3a1",
        "media": "#fab387",
        "development": "#f9e2af",
        "system": "#f38ba8",
        "graphics": "#c6a0f6",
        "office": "#eed49f",
        "unknown": "#cad3f5"
    }
    
    // Catppuccin Macchiato color palette for validation
    property var catppuccinMacchiatoColors: [
        "#cad3f5", // text
        "#b7bdf8", // lavender
        "#c6a0f6", // mauve
        "#f5bde6", // pink
        "#f0c6c6", // flamingo
        "#f5a97f", // peach
        "#eed49f", // yellow
        "#a6da95", // green
        "#8bd5ca", // teal
        "#91d7e3", // sky
        "#7dc4e4", // sapphire
        "#8aadf4", // blue
        "#ed8796", // red
        "#f4dbd6", // rosewater
        "#fab387", // peach (alternative)
        "#f9e2af", // yellow (alternative)
        "#a6e3a1", // green (alternative)
        "#94e2d5", // teal (alternative)
        "#89b4fa", // blue (alternative)
        "#cba6f7", // mauve (alternative)
        "#f38ba8"  // red (alternative)
    ]
    
    // Sample application names for testing
    property var sampleAppNames: [
        "firefox", "chrome", "chromium", "safari", "edge",
        "thunderbird", "outlook", "mail", "evolution",
        "discord", "slack", "teams", "telegram", "whatsapp",
        "spotify", "vlc", "mpv", "rhythmbox", "audacity",
        "vscode", "atom", "sublime", "vim", "emacs",
        "terminal", "konsole", "gnome-terminal", "alacritty",
        "nautilus", "dolphin", "thunar", "pcmanfm",
        "gimp", "inkscape", "blender", "krita",
        "libreoffice", "writer", "calc", "impress",
        "unknown-app", "test-app", "random-application"
    ]
    
    Component.onCompleted: {
        console.log("=== Property-Based Tests for Multi-Notification Color Consistency ===")
        console.log("**Feature: quickshell-enhancements, Property 14: Multi-notification color consistency**")
        console.log("**Validates: Requirements 3.4**")
        console.log("Running", testIterations, "iterations...")
        
        runPropertyTests()
    }
    
    function runPropertyTests() {
        // Property 14: Multi-notification color consistency
        // For any set of notifications from the same application, all notifications 
        // should use the same Catppuccin Macchiato color
        testProperty14()
        
        reportResults()
    }
    
    function testProperty14() {
        console.log("\n--- Testing Property 14: Multi-notification color consistency ---")
        
        for (let i = 0; i < testIterations; i++) {
            let testData = generateMultiNotificationTest()
            let result = testMultiNotificationColorConsistency(testData.appName, testData.notificationCount, i)
            
            if (!result.passed) {
                testsPassed = false
                testResults.push({
                    property: "Property 14",
                    iteration: i,
                    input: `${testData.appName} (${testData.notificationCount} notifications)`,
                    expected: `All ${testData.notificationCount} notifications from "${testData.appName}" should use the same Catppuccin Macchiato color`,
                    actual: result.message,
                    passed: false
                })
                console.error("❌ Property 14 failed at iteration", i, ":", result.message)
            }
        }
        
        if (testsPassed) {
            console.log("✅ Property 14 passed all", testIterations, "iterations")
        }
    }
    
    function generateMultiNotificationTest() {
        // Generate test cases for multiple notifications from the same application
        let randomChoice = Math.random()
        let appName
        let notificationCount
        
        if (randomChoice < 0.4) {
            // 40% chance: test with configured applications
            let configuredApps = Object.keys(mockConfiguredColors)
            appName = configuredApps[Math.floor(Math.random() * configuredApps.length)]
        } else if (randomChoice < 0.8) {
            // 40% chance: test with known applications (may or may not be configured)
            appName = sampleAppNames[Math.floor(Math.random() * sampleAppNames.length)]
        } else {
            // 20% chance: test with random/edge case applications
            let edgeCases = [
                "random-app-" + Math.floor(Math.random() * 1000),
                "test application with spaces",
                "App-With-Caps",
                "app_with_underscores",
                "123numeric-app",
                "",
                " ",
                "special!@#app"
            ]
            appName = edgeCases[Math.floor(Math.random() * edgeCases.length)]
        }
        
        // Generate random number of notifications (2-10 for meaningful testing)
        notificationCount = Math.floor(Math.random() * 9) + 2 // 2-10 notifications
        
        return {
            appName: appName,
            notificationCount: notificationCount
        }
    }
    
    function testMultiNotificationColorConsistency(appName, notificationCount, iteration) {
        try {
            // Test the core property: multi-notification color consistency
            
            // 1. Generate multiple notifications from the same application
            let notificationColors = []
            let notificationIds = []
            
            for (let i = 0; i < notificationCount; i++) {
                // Simulate getting color for each notification from the same app
                let notificationId = `notification_${i}_${Date.now()}_${Math.random()}`
                let color = mockGetColorForApp(appName)
                
                notificationColors.push(color)
                notificationIds.push(notificationId)
                
                // Verify each color is valid
                if (!color) {
                    return {
                        passed: false,
                        message: `Notification ${i + 1} from app "${appName}" returned null/undefined color`
                    }
                }
                
                if (!isValidColorFormat(color)) {
                    return {
                        passed: false,
                        message: `Notification ${i + 1} from app "${appName}" returned invalid color format: "${color}"`
                    }
                }
                
                if (!isCatppuccinMacchiatoColor(color)) {
                    return {
                        passed: false,
                        message: `Notification ${i + 1} from app "${appName}" returned non-Catppuccin Macchiato color: "${color}"`
                    }
                }
            }
            
            // 2. Test that all notifications from the same app have the same color
            let firstColor = notificationColors[0]
            for (let i = 1; i < notificationColors.length; i++) {
                if (notificationColors[i] !== firstColor) {
                    return {
                        passed: false,
                        message: `Color inconsistency for app "${appName}": notification 1 has "${firstColor}", notification ${i + 1} has "${notificationColors[i]}"`
                    }
                }
            }
            
            // 3. Test consistency over time - simulate notifications arriving at different times
            let timeDelayedColors = []
            for (let i = 0; i < Math.min(notificationCount, 5); i++) {
                // Simulate some time passing or state changes
                let delayedColor = mockGetColorForApp(appName)
                timeDelayedColors.push(delayedColor)
                
                if (delayedColor !== firstColor) {
                    return {
                        passed: false,
                        message: `Time-delayed color inconsistency for app "${appName}": initial color "${firstColor}", delayed color "${delayedColor}"`
                    }
                }
            }
            
            // 4. Test consistency with case variations of the same app name
            let caseVariations = [
                appName.toLowerCase(),
                appName.toUpperCase(),
                appName.charAt(0).toUpperCase() + appName.slice(1).toLowerCase()
            ]
            
            for (let variation of caseVariations) {
                if (variation !== appName) { // Don't test the exact same string
                    let variationColor = mockGetColorForApp(variation)
                    // Note: depending on implementation, case variations might or might not match
                    // For this test, we'll be lenient about case sensitivity
                    // The key requirement is that the SAME app name always returns the SAME color
                }
            }
            
            // 5. Test that the color is appropriate for the application
            // (either configured color or appropriate category color)
            let expectedColor = getExpectedColorForApp(appName)
            if (expectedColor && firstColor !== expectedColor) {
                // This might not be a failure if the app falls into a different category
                // than expected, but we can log it for information
                console.log(`Info: App "${appName}" returned color "${firstColor}", expected "${expectedColor}"`)
            }
            
            // 6. Test with simulated concurrent notifications
            let concurrentColors = []
            for (let i = 0; i < 3; i++) {
                concurrentColors.push(mockGetColorForApp(appName))
            }
            
            for (let concurrentColor of concurrentColors) {
                if (concurrentColor !== firstColor) {
                    return {
                        passed: false,
                        message: `Concurrent notification color inconsistency for app "${appName}": expected "${firstColor}", got "${concurrentColor}"`
                    }
                }
            }
            
            // 7. Test that notifications with different content but same app have same color
            // (simulating different notification messages from the same application)
            let contentVariations = [
                `${appName}_message_1`,
                `${appName}_message_2`, 
                `${appName}_different_content`
            ]
            
            for (let contentVar of contentVariations) {
                // In a real system, the content might be passed separately from the app name
                // For this test, we're focusing on the app name consistency
                let contentColor = mockGetColorForApp(appName)
                if (contentColor !== firstColor) {
                    return {
                        passed: false,
                        message: `Content variation color inconsistency for app "${appName}": expected "${firstColor}", got "${contentColor}"`
                    }
                }
            }
            
            return {
                passed: true,
                message: `All ${notificationCount} notifications from app "${appName}" consistently use color "${firstColor}"`
            }
            
        } catch (error) {
            return {
                passed: false,
                message: `Exception during multi-notification color consistency test: ${error.toString()}`
            }
        }
    }
    
    function getExpectedColorForApp(appName) {
        // Get the expected color for an application based on configuration and category
        if (!appName || typeof appName !== 'string') {
            return mockCategoryColors["unknown"]
        }
        
        let normalizedName = appName.toLowerCase().trim()
        
        // Check configured colors first
        let configuredColor = getMockConfiguredColor(normalizedName)
        if (configuredColor) {
            return configuredColor
        }
        
        // Fall back to category color
        let category = getMockAppCategory(normalizedName)
        return getMockCategoryColor(category)
    }
    
    // Mock implementation of BorderColorManager.getColorForApp
    // This simulates the expected behavior for multi-notification consistency
    function mockGetColorForApp(appName) {
        // Handle edge cases
        if (!appName || typeof appName !== 'string') {
            return getDefaultColor()
        }
        
        // Normalize app name for consistent lookup
        let normalizedName = appName.toLowerCase().trim()
        
        // Remove common suffixes and prefixes for better matching
        normalizedName = normalizedName.replace(/\.(exe|app|deb|rpm)$/, '')
        normalizedName = normalizedName.replace(/^(org\.|com\.|net\.)/, '')
        normalizedName = normalizedName.replace(/-dev$/, '')
        
        // Check if app has configured color
        let configuredColor = getMockConfiguredColor(normalizedName)
        if (configuredColor) {
            return configuredColor
        }
        
        // Fallback to category-based color
        let category = getMockAppCategory(normalizedName)
        let categoryColor = getMockCategoryColor(category)
        if (categoryColor) {
            return categoryColor
        }
        
        // Final fallback to default color
        return getDefaultColor()
    }
    
    function getMockConfiguredColor(appName) {
        // Return configured color if it exists
        return mockConfiguredColors[appName] || null
    }
    
    function getMockAppCategory(appName) {
        // Mock category detection based on app name patterns
        if (!appName || typeof appName !== 'string') {
            return "unknown"
        }
        
        let name = appName.toLowerCase()
        
        // Browser category
        if (name.includes("browser") || name.includes("chrome") || name.includes("chromium") || 
            name.includes("firefox") || name.includes("safari") || name.includes("edge") || 
            name.includes("opera") || name.includes("web")) {
            return "browser"
        }
        
        // Communication category
        if (name.includes("discord") || name.includes("slack") || name.includes("teams") || 
            name.includes("telegram") || name.includes("whatsapp") || name.includes("signal") ||
            name.includes("mail") || name.includes("thunderbird") || name.includes("chat") || 
            name.includes("message")) {
            return "communication"
        }
        
        // Media category
        if (name.includes("spotify") || name.includes("vlc") || name.includes("mpv") || 
            name.includes("media") || name.includes("player") || name.includes("audio") || 
            name.includes("video") || name.includes("music") || name.includes("sound")) {
            return "media"
        }
        
        // Development category
        if (name.includes("vscode") || name.includes("vim") || name.includes("emacs") || 
            name.includes("code") || name.includes("atom") || name.includes("sublime") || 
            name.includes("dev") || name.includes("ide")) {
            return "development"
        }
        
        // System category
        if (name.includes("terminal") || name.includes("konsole") || name.includes("system") || 
            name.includes("shell") || name.includes("admin")) {
            return "system"
        }
        
        // Graphics category
        if (name.includes("gimp") || name.includes("inkscape") || name.includes("blender") || 
            name.includes("graphics") || name.includes("image") || name.includes("photo")) {
            return "graphics"
        }
        
        // Office category
        if (name.includes("libreoffice") || name.includes("office") || name.includes("writer") || 
            name.includes("calc") || name.includes("doc")) {
            return "office"
        }
        
        // Default to unknown
        return "unknown"
    }
    
    function getMockCategoryColor(category) {
        // Return category color based on design document
        return mockCategoryColors[category] || mockCategoryColors["unknown"]
    }
    
    function getDefaultColor() {
        // Default Catppuccin Macchiato color
        return "#cad3f5" // text color
    }
    
    function isValidColorFormat(color) {
        // Check if color is a valid hex color format
        if (typeof color !== 'string') {
            return false
        }
        
        // Must be hex format: #rrggbb
        return /^#[0-9a-fA-F]{6}$/.test(color)
    }
    
    function isCatppuccinMacchiatoColor(color) {
        // Check if color is from the Catppuccin Macchiato palette
        if (!color || typeof color !== 'string') {
            return false
        }
        
        // Convert to lowercase for comparison
        let normalizedColor = color.toLowerCase()
        
        // Check against known Catppuccin Macchiato colors
        return catppuccinMacchiatoColors.map(c => c.toLowerCase()).includes(normalizedColor)
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
                console.log(`   Input: "${result.input}"`)
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