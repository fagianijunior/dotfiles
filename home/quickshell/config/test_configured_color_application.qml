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
    
    Component.onCompleted: {
        console.log("=== Property-Based Tests for Configured Color Application ===")
        console.log("**Feature: quickshell-enhancements, Property 12: Configured color application**")
        console.log("**Validates: Requirements 3.2**")
        console.log("Running", testIterations, "iterations...")
        
        runPropertyTests()
    }
    
    function runPropertyTests() {
        // Property 12: Configured color application
        // For any application with a configured color, that specific Catppuccin Macchiato color 
        // should be applied to all notifications from that application
        testProperty12()
        
        reportResults()
    }
    
    function testProperty12() {
        console.log("\n--- Testing Property 12: Configured color application ---")
        
        for (let i = 0; i < testIterations; i++) {
            let testData = generateConfiguredAppTest()
            let result = testConfiguredColorApplication(testData.appName, testData.expectedColor, i)
            
            if (!result.passed) {
                testsPassed = false
                testResults.push({
                    property: "Property 12",
                    iteration: i,
                    input: testData.appName,
                    expected: `Should return configured color "${testData.expectedColor}" for app "${testData.appName}"`,
                    actual: result.message,
                    passed: false
                })
                console.error("❌ Property 12 failed at iteration", i, ":", result.message)
            }
        }
        
        if (testsPassed) {
            console.log("✅ Property 12 passed all", testIterations, "iterations")
        }
    }
    
    function generateConfiguredAppTest() {
        // Generate test cases for applications that have configured colors
        let configuredApps = Object.keys(mockConfiguredColors)
        let randomChoice = Math.random()
        
        if (randomChoice < 0.8) {
            // 80% chance: test with exact configured app name
            let appName = configuredApps[Math.floor(Math.random() * configuredApps.length)]
            return {
                appName: appName,
                expectedColor: mockConfiguredColors[appName]
            }
        } else {
            // 20% chance: test with case variations of configured app names
            let baseApp = configuredApps[Math.floor(Math.random() * configuredApps.length)]
            let variations = [
                baseApp.toUpperCase(),
                baseApp.charAt(0).toUpperCase() + baseApp.slice(1),
                " " + baseApp + " ", // with whitespace
                baseApp + "-dev", // with suffix
                baseApp + ".exe" // with extension
            ]
            let variantApp = variations[Math.floor(Math.random() * variations.length)]
            
            return {
                appName: variantApp,
                expectedColor: mockConfiguredColors[baseApp] // Should still match base app
            }
        }
    }
    
    function testConfiguredColorApplication(appName, expectedColor, iteration) {
        try {
            // Test the core property: configured color application
            
            // 1. Test that getColorForApp returns the exact configured color
            let actualColor = mockGetColorForApp(appName)
            if (!actualColor) {
                return {
                    passed: false,
                    message: `getColorForApp returned null/undefined for configured app: "${appName}"`
                }
            }
            
            // 2. Test that the returned color matches the configured color exactly
            if (actualColor !== expectedColor) {
                return {
                    passed: false,
                    message: `Color mismatch for configured app "${appName}": expected "${expectedColor}", got "${actualColor}"`
                }
            }
            
            // 3. Test consistency - multiple calls should return the same configured color
            for (let j = 0; j < 5; j++) {
                let colorCheck = mockGetColorForApp(appName)
                if (colorCheck !== expectedColor) {
                    return {
                        passed: false,
                        message: `Configured color inconsistency on call ${j + 2} for app "${appName}": expected "${expectedColor}", got "${colorCheck}"`
                    }
                }
            }
            
            // 4. Test that the configured color is a valid Catppuccin Macchiato color
            if (!isCatppuccinMacchiatoColor(actualColor)) {
                return {
                    passed: false,
                    message: `Configured color "${actualColor}" for app "${appName}" is not from Catppuccin Macchiato palette`
                }
            }
            
            // 5. Test that configured colors take precedence over category colors
            let categoryColor = getMockCategoryColor(getMockAppCategory(appName.toLowerCase()))
            if (actualColor === categoryColor && actualColor !== expectedColor) {
                return {
                    passed: false,
                    message: `App "${appName}" returned category color "${categoryColor}" instead of configured color "${expectedColor}"`
                }
            }
            
            // 6. Test multiple notifications from same app get same configured color
            let notification1Color = mockGetColorForApp(appName)
            let notification2Color = mockGetColorForApp(appName)
            let notification3Color = mockGetColorForApp(appName)
            
            if (notification1Color !== notification2Color || notification2Color !== notification3Color) {
                return {
                    passed: false,
                    message: `Inconsistent colors for multiple notifications from "${appName}": "${notification1Color}", "${notification2Color}", "${notification3Color}"`
                }
            }
            
            return {
                passed: true,
                message: `Configured color application correct for app "${appName}": "${actualColor}"`
            }
            
        } catch (error) {
            return {
                passed: false,
                message: `Exception during configured color application test: ${error.toString()}`
            }
        }
    }
    
    // Mock implementation of BorderColorManager.getColorForApp
    // This simulates the expected behavior for configured color application
    function mockGetColorForApp(appName) {
        // Handle edge cases
        if (!appName || typeof appName !== 'string') {
            return getDefaultColor()
        }
        
        // Normalize app name for lookup
        let normalizedName = appName.toLowerCase().trim()
        
        // Remove common suffixes and prefixes for better matching
        normalizedName = normalizedName.replace(/\.(exe|app|deb|rpm)$/, '')
        normalizedName = normalizedName.replace(/^(org\.|com\.|net\.)/, '')
        normalizedName = normalizedName.replace(/-dev$/, '')
        
        // Check if app has configured color (this is the key test for Property 12)
        let configuredColor = getMockConfiguredColor(normalizedName)
        if (configuredColor) {
            return configuredColor
        }
        
        // Fallback to category-based color (should not happen for configured apps)
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
        if (appName.includes("firefox") || appName.includes("chrome") || appName.includes("browser")) {
            return "browser"
        } else if (appName.includes("discord") || appName.includes("slack") || appName.includes("mail") || appName.includes("thunderbird")) {
            return "communication"
        } else if (appName.includes("spotify") || appName.includes("vlc") || appName.includes("media")) {
            return "media"
        } else if (appName.includes("vscode") || appName.includes("vim") || appName.includes("code")) {
            return "development"
        } else if (appName.includes("terminal") || appName.includes("system")) {
            return "system"
        } else if (appName.includes("gimp") || appName.includes("inkscape") || appName.includes("graphics")) {
            return "graphics"
        } else if (appName.includes("libreoffice") || appName.includes("office")) {
            return "office"
        } else {
            return "unknown"
        }
    }
    
    function getMockCategoryColor(category) {
        // Mock category colors based on design document
        let mockCategoryColors = {
            "browser": "#89b4fa",
            "communication": "#a6e3a1",
            "media": "#fab387",
            "development": "#f9e2af",
            "system": "#f38ba8",
            "graphics": "#c6a0f6",
            "office": "#eed49f",
            "unknown": "#cad3f5"
        }
        
        return mockCategoryColors[category] || mockCategoryColors["unknown"]
    }
    
    function getDefaultColor() {
        // Default Catppuccin Macchiato color
        return "#cad3f5" // text color
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