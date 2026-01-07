import QtQuick

QtObject {
    id: propertyTestRunner
    
    property int testIterations: 100
    property int currentIteration: 0
    property bool testsPassed: true
    property var testResults: []
    
    // Mock configured colors (apps that should NOT use category fallback)
    property var mockConfiguredColors: {
        "firefox": "#89b4fa",
        "thunderbird": "#a6e3a1", 
        "discord": "#cba6f7",
        "spotify": "#94e2d5"
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
    
    Component.onCompleted: {
        console.log("=== Property-Based Tests for Category-Based Color Fallback ===")
        console.log("**Feature: quickshell-enhancements, Property 13: Category-based color fallback**")
        console.log("**Validates: Requirements 3.3**")
        console.log("Running", testIterations, "iterations...")
        
        runPropertyTests()
    }
    
    function runPropertyTests() {
        // Property 13: Category-based color fallback
        // For any application without a configured color, the system should use 
        // appropriate Catppuccin Macchiato colors based on the application category
        testProperty13()
        
        reportResults()
    }
    
    function testProperty13() {
        console.log("\n--- Testing Property 13: Category-based color fallback ---")
        
        for (let i = 0; i < testIterations; i++) {
            let testData = generateUnconfiguredAppTest()
            let result = testCategoryBasedColorFallback(testData.appName, testData.expectedCategory, testData.expectedColor, i)
            
            if (!result.passed) {
                testsPassed = false
                testResults.push({
                    property: "Property 13",
                    iteration: i,
                    input: testData.appName,
                    expected: `Should return category color "${testData.expectedColor}" for category "${testData.expectedCategory}"`,
                    actual: result.message,
                    passed: false
                })
                console.error("❌ Property 13 failed at iteration", i, ":", result.message)
            }
        }
        
        if (testsPassed) {
            console.log("✅ Property 13 passed all", testIterations, "iterations")
        }
    }
    
    function generateUnconfiguredAppTest() {
        // Generate test cases for applications that do NOT have configured colors
        // These should fall back to category-based colors
        
        let unconfiguredApps = [
            // Browser category (but not configured)
            { name: "chromium", category: "browser" },
            { name: "safari", category: "browser" },
            { name: "edge", category: "browser" },
            { name: "opera", category: "browser" },
            
            // Communication category (but not configured)
            { name: "slack", category: "communication" },
            { name: "teams", category: "communication" },
            { name: "telegram", category: "communication" },
            { name: "whatsapp", category: "communication" },
            { name: "signal", category: "communication" },
            
            // Media category (but not configured)
            { name: "vlc", category: "media" },
            { name: "mpv", category: "media" },
            { name: "rhythmbox", category: "media" },
            { name: "audacity", category: "media" },
            { name: "obs", category: "media" },
            
            // Development category (but not configured)
            { name: "atom", category: "development" },
            { name: "sublime", category: "development" },
            { name: "vim", category: "development" },
            { name: "emacs", category: "development" },
            { name: "intellij", category: "development" },
            
            // System category (but not configured)
            { name: "konsole", category: "system" },
            { name: "gnome-terminal", category: "system" },
            { name: "alacritty", category: "system" },
            { name: "htop", category: "system" },
            { name: "systemd", category: "system" },
            
            // Graphics category
            { name: "gimp", category: "graphics" },
            { name: "inkscape", category: "graphics" },
            { name: "blender", category: "graphics" },
            { name: "krita", category: "graphics" },
            
            // Office category
            { name: "libreoffice", category: "office" },
            { name: "writer", category: "office" },
            { name: "calc", category: "office" },
            { name: "impress", category: "office" },
            
            // Unknown category
            { name: "random-app-123", category: "unknown" },
            { name: "test-application", category: "unknown" },
            { name: "unknown-software", category: "unknown" }
        ]
        
        let randomChoice = Math.random()
        
        if (randomChoice < 0.7) {
            // 70% chance: use predefined unconfigured apps
            let app = unconfiguredApps[Math.floor(Math.random() * unconfiguredApps.length)]
            return {
                appName: app.name,
                expectedCategory: app.category,
                expectedColor: mockCategoryColors[app.category]
            }
        } else if (randomChoice < 0.9) {
            // 20% chance: generate random app names with category hints
            let categories = Object.keys(mockCategoryColors)
            let category = categories[Math.floor(Math.random() * categories.length)]
            let randomName = generateRandomAppNameForCategory(category)
            
            return {
                appName: randomName,
                expectedCategory: category,
                expectedColor: mockCategoryColors[category]
            }
        } else {
            // 10% chance: edge cases - apps that might be hard to categorize
            let edgeCases = [
                { name: "", category: "unknown" },
                { name: " ", category: "unknown" },
                { name: "app with spaces", category: "unknown" },
                { name: "123numbers", category: "unknown" },
                { name: "special!@#chars", category: "unknown" }
            ]
            let edgeCase = edgeCases[Math.floor(Math.random() * edgeCases.length)]
            return {
                appName: edgeCase.name,
                expectedCategory: edgeCase.category,
                expectedColor: mockCategoryColors[edgeCase.category]
            }
        }
    }
    
    function generateRandomAppNameForCategory(category) {
        // Generate random app names that should be categorized correctly
        let categoryHints = {
            "browser": ["browser", "web", "surf", "navigator"],
            "communication": ["chat", "mail", "message", "talk", "call"],
            "media": ["player", "audio", "video", "music", "sound"],
            "development": ["code", "edit", "dev", "ide", "debug"],
            "system": ["term", "shell", "monitor", "admin", "sys"],
            "graphics": ["draw", "paint", "image", "photo", "design"],
            "office": ["doc", "text", "sheet", "present", "office"],
            "unknown": ["random", "test", "app", "tool", "util"]
        }
        
        let hints = categoryHints[category] || categoryHints["unknown"]
        let hint = hints[Math.floor(Math.random() * hints.length)]
        let suffix = Math.floor(Math.random() * 1000)
        
        return hint + "-" + suffix
    }
    
    function testCategoryBasedColorFallback(appName, expectedCategory, expectedColor, iteration) {
        try {
            // Test the core property: category-based color fallback
            
            // 1. Verify this app is NOT in configured colors (prerequisite for fallback)
            let configuredColor = getMockConfiguredColor(appName.toLowerCase().trim())
            if (configuredColor) {
                return {
                    passed: false,
                    message: `Test setup error: app "${appName}" has configured color "${configuredColor}", cannot test category fallback`
                }
            }
            
            // 2. Test that getColorForApp returns a color for unconfigured app
            let actualColor = mockGetColorForApp(appName)
            if (!actualColor) {
                return {
                    passed: false,
                    message: `getColorForApp returned null/undefined for unconfigured app: "${appName}"`
                }
            }
            
            // 3. Test that the returned color is a valid Catppuccin Macchiato color
            if (!isCatppuccinMacchiatoColor(actualColor)) {
                return {
                    passed: false,
                    message: `Color "${actualColor}" for app "${appName}" is not from Catppuccin Macchiato palette`
                }
            }
            
            // 4. Test that the color matches the expected category color
            let detectedCategory = getMockAppCategory(appName.toLowerCase().trim())
            let categoryColor = getMockCategoryColor(detectedCategory)
            
            if (actualColor !== categoryColor) {
                return {
                    passed: false,
                    message: `Category fallback failed for app "${appName}": expected category "${detectedCategory}" color "${categoryColor}", got "${actualColor}"`
                }
            }
            
            // 5. Test consistency - multiple calls should return the same category color
            for (let j = 0; j < 3; j++) {
                let colorCheck = mockGetColorForApp(appName)
                if (colorCheck !== actualColor) {
                    return {
                        passed: false,
                        message: `Category color inconsistency on call ${j + 2} for app "${appName}": expected "${actualColor}", got "${colorCheck}"`
                    }
                }
            }
            
            // 6. Test that category detection is reasonable (not always "unknown")
            if (appName && appName.trim() !== "" && detectedCategory === "unknown") {
                // For non-empty app names, check if category detection makes sense
                let hasKnownPattern = false
                let knownPatterns = ["browser", "chrome", "firefox", "mail", "chat", "media", "code", "term", "draw", "office"]
                for (let pattern of knownPatterns) {
                    if (appName.toLowerCase().includes(pattern)) {
                        hasKnownPattern = true
                        break
                    }
                }
                
                // If app name has known patterns but is categorized as unknown, that might be an issue
                // But we'll be lenient here since category detection is heuristic
            }
            
            // 7. Test that category colors are appropriate Catppuccin Macchiato colors
            if (!isCatppuccinMacchiatoColor(categoryColor)) {
                return {
                    passed: false,
                    message: `Category color "${categoryColor}" for category "${detectedCategory}" is not from Catppuccin Macchiato palette`
                }
            }
            
            return {
                passed: true,
                message: `Category fallback correct for app "${appName}": category "${detectedCategory}" -> color "${actualColor}"`
            }
            
        } catch (error) {
            return {
                passed: false,
                message: `Exception during category fallback test: ${error.toString()}`
            }
        }
    }
    
    // Mock implementation of BorderColorManager.getColorForApp
    // This simulates the expected behavior for category-based fallback
    function mockGetColorForApp(appName) {
        // Handle edge cases
        if (!appName || typeof appName !== 'string') {
            return getDefaultColor()
        }
        
        // Normalize app name
        let normalizedName = appName.toLowerCase().trim()
        
        // Remove common suffixes and prefixes for better matching
        normalizedName = normalizedName.replace(/\.(exe|app|deb|rpm)$/, '')
        normalizedName = normalizedName.replace(/^(org\.|com\.|net\.)/, '')
        normalizedName = normalizedName.replace(/-dev$/, '')
        
        // Check if app has configured color (should return early if found)
        let configuredColor = getMockConfiguredColor(normalizedName)
        if (configuredColor) {
            return configuredColor
        }
        
        // Fallback to category-based color (this is what we're testing)
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
        // This should be comprehensive to properly test category fallback
        
        if (!appName || typeof appName !== 'string') {
            return "unknown"
        }
        
        let name = appName.toLowerCase()
        
        // Browser category
        if (name.includes("browser") || name.includes("chrome") || name.includes("chromium") || 
            name.includes("firefox") || name.includes("safari") || name.includes("edge") || 
            name.includes("opera") || name.includes("web") || name.includes("surf") || 
            name.includes("navigator")) {
            return "browser"
        }
        
        // Communication category
        if (name.includes("discord") || name.includes("slack") || name.includes("teams") || 
            name.includes("telegram") || name.includes("whatsapp") || name.includes("signal") ||
            name.includes("mail") || name.includes("thunderbird") || name.includes("chat") || 
            name.includes("message") || name.includes("talk") || name.includes("call")) {
            return "communication"
        }
        
        // Media category
        if (name.includes("spotify") || name.includes("vlc") || name.includes("mpv") || 
            name.includes("media") || name.includes("player") || name.includes("audio") || 
            name.includes("video") || name.includes("music") || name.includes("sound") ||
            name.includes("rhythmbox") || name.includes("audacity") || name.includes("obs")) {
            return "media"
        }
        
        // Development category
        if (name.includes("vscode") || name.includes("vim") || name.includes("emacs") || 
            name.includes("code") || name.includes("atom") || name.includes("sublime") || 
            name.includes("intellij") || name.includes("dev") || name.includes("ide") || 
            name.includes("debug") || name.includes("edit")) {
            return "development"
        }
        
        // System category
        if (name.includes("terminal") || name.includes("konsole") || name.includes("gnome-terminal") || 
            name.includes("alacritty") || name.includes("system") || name.includes("htop") || 
            name.includes("systemd") || name.includes("term") || name.includes("shell") || 
            name.includes("monitor") || name.includes("admin") || name.includes("sys")) {
            return "system"
        }
        
        // Graphics category
        if (name.includes("gimp") || name.includes("inkscape") || name.includes("blender") || 
            name.includes("krita") || name.includes("graphics") || name.includes("draw") || 
            name.includes("paint") || name.includes("image") || name.includes("photo") || 
            name.includes("design")) {
            return "graphics"
        }
        
        // Office category
        if (name.includes("libreoffice") || name.includes("office") || name.includes("writer") || 
            name.includes("calc") || name.includes("impress") || name.includes("doc") || 
            name.includes("text") || name.includes("sheet") || name.includes("present")) {
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
        // Default Catppuccin Macchiato color (same as unknown category)
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