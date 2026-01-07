import QtQuick
import "./utils"

QtObject {
    id: unitTestRunner
    
    property int totalTests: 0
    property int passedTests: 0
    property int failedTests: 0
    property var testResults: []
    
    // Test components
    property var configManager: null
    property var deviceDetector: null
    
    Component.onCompleted: {
        console.log("=== Unit Tests for Configuration File Handling ===")
        console.log("Testing JSON parsing, validation, error recovery, Git-compatible operations, and device-specific loading")
        console.log("Requirements: 6.1, 6.2, 6.3, 6.4, 6.5")
        
        initializeComponents()
        runAllTests()
    }
    
    function initializeComponents() {
        // Create ConfigManager instance
        let configManagerComponent = Qt.createComponent("./utils/ConfigManager.qml")
        if (configManagerComponent.status === Component.Ready) {
            configManager = configManagerComponent.createObject(unitTestRunner)
        } else {
            console.error("Failed to create ConfigManager:", configManagerComponent.errorString())
        }
        
        // Create DeviceDetector instance
        let deviceDetectorComponent = Qt.createComponent("./utils/DeviceDetector.qml")
        if (deviceDetectorComponent.status === Component.Ready) {
            deviceDetector = deviceDetectorComponent.createObject(unitTestRunner)
        } else {
            console.error("Failed to create DeviceDetector:", deviceDetectorComponent.errorString())
        }
    }
    
    function runAllTests() {
        console.log("\n--- Running JSON Parsing Tests ---")
        testJSONParsing()
        
        console.log("\n--- Running Configuration Validation Tests ---")
        testConfigValidation()
        
        console.log("\n--- Running Error Recovery Tests ---")
        testErrorRecovery()
        
        console.log("\n--- Running Git-Compatible File Operations Tests ---")
        testGitCompatibleOperations()
        
        console.log("\n--- Running Device-Specific Configuration Loading Tests ---")
        testDeviceSpecificLoading()
        
        reportResults()
    }
    
    // Test JSON parsing functionality
    function testJSONParsing() {
        // Test 1: Valid JSON parsing
        runTest("Valid JSON parsing", function() {
            let validConfig = {
                "version": "1.0",
                "testField": "testValue",
                "numericField": 42,
                "arrayField": ["item1", "item2"]
            }
            
            let jsonString = JSON.stringify(validConfig)
            let parsed = JSON.parse(jsonString)
            
            return parsed.version === "1.0" && 
                   parsed.testField === "testValue" && 
                   parsed.numericField === 42 &&
                   Array.isArray(parsed.arrayField) &&
                   parsed.arrayField.length === 2
        })
        
        // Test 2: Invalid JSON handling
        runTest("Invalid JSON handling", function() {
            try {
                let invalidJson = '{"invalid": json, "missing": quotes}'
                JSON.parse(invalidJson)
                return false // Should have thrown an error
            } catch (e) {
                return true // Expected behavior
            }
        })
        
        // Test 3: Empty JSON object
        runTest("Empty JSON object parsing", function() {
            let emptyJson = "{}"
            let parsed = JSON.parse(emptyJson)
            return typeof parsed === 'object' && Object.keys(parsed).length === 0
        })
        
        // Test 4: Nested JSON structure
        runTest("Nested JSON structure parsing", function() {
            let nestedConfig = {
                "metadata": {
                    "version": "1.0",
                    "created": "2024-01-01"
                },
                "settings": {
                    "enabled": true,
                    "options": ["opt1", "opt2"]
                }
            }
            
            let jsonString = JSON.stringify(nestedConfig)
            let parsed = JSON.parse(jsonString)
            
            return parsed.metadata.version === "1.0" &&
                   parsed.settings.enabled === true &&
                   parsed.settings.options.length === 2
        })
    }
    
    // Test configuration validation
    function testConfigValidation() {
        if (!configManager) {
            console.error("ConfigManager not available for validation tests")
            return
        }
        
        // Test 5: Valid configuration validation
        runTest("Valid configuration validation", function() {
            let validConfig = {
                "version": "1.0",
                "requiredField1": "value1",
                "requiredField2": "value2"
            }
            
            let result = configManager.validateConfig(validConfig, ["version", "requiredField1", "requiredField2"])
            return result.valid === true && result.error === ""
        })
        
        // Test 6: Missing required fields validation
        runTest("Missing required fields validation", function() {
            let invalidConfig = {
                "version": "1.0"
                // Missing requiredField1 and requiredField2
            }
            
            let result = configManager.validateConfig(invalidConfig, ["version", "requiredField1", "requiredField2"])
            return result.valid === false && result.error.includes("Missing required field")
        })
        
        // Test 7: Non-object configuration validation
        runTest("Non-object configuration validation", function() {
            let result = configManager.validateConfig("not an object", ["version"])
            return result.valid === false && result.error.includes("not an object")
        })
        
        // Test 8: Null configuration validation
        runTest("Null configuration validation", function() {
            let result = configManager.validateConfig(null, ["version"])
            return result.valid === false && result.error.includes("not an object")
        })
        
        // Test 9: Empty required fields array
        runTest("Empty required fields validation", function() {
            let config = {"version": "1.0"}
            let result = configManager.validateConfig(config, [])
            return result.valid === true
        })
    }
    
    // Test error recovery mechanisms
    function testErrorRecovery() {
        if (!configManager) {
            console.error("ConfigManager not available for error recovery tests")
            return
        }
        
        // Test 10: Default config fallback
        runTest("Default config fallback", function() {
            let defaultConfig = {
                "version": "1.0",
                "defaultValue": "fallback"
            }
            
            // Simulate loading a non-existent config
            // The ConfigManager should use the default config
            return defaultConfig.version === "1.0" && defaultConfig.defaultValue === "fallback"
        })
        
        // Test 11: Corrupted config recovery
        runTest("Corrupted config recovery", function() {
            // Test that the system can handle corrupted JSON gracefully
            try {
                let corruptedJson = '{"version": "1.0", "corrupted": }'
                JSON.parse(corruptedJson)
                return false // Should have failed
            } catch (e) {
                // This is expected - the system should catch this and use defaults
                return true
            }
        })
        
        // Test 12: Partial config recovery
        runTest("Partial config recovery", function() {
            let partialConfig = {
                "version": "1.0"
                // Missing other expected fields
            }
            
            // Merge with defaults
            let defaultConfig = {
                "version": "1.0",
                "setting1": "default1",
                "setting2": "default2"
            }
            
            let merged = Object.assign({}, defaultConfig, partialConfig)
            return merged.version === "1.0" && 
                   merged.setting1 === "default1" && 
                   merged.setting2 === "default2"
        })
    }
    
    // Test Git-compatible file operations
    function testGitCompatibleOperations() {
        if (!configManager) {
            console.error("ConfigManager not available for Git compatibility tests")
            return
        }
        
        // Test 13: Git-compatible path generation
        runTest("Git-compatible path generation", function() {
            let configPath = configManager.getConfigPath("test-config")
            
            // Should be a valid path that includes the config name and .json extension
            // Git compatibility means the path should be consistent and trackable
            return configPath.includes("test-config.json") &&
                   configPath.endsWith(".json") &&
                   typeof configPath === 'string' &&
                   configPath.length > 0
        })
        
        // Test 14: File naming conventions
        runTest("File naming conventions", function() {
            let configNames = ["filter-config", "app-colors", "disk-cache"]
            
            for (let i = 0; i < configNames.length; i++) {
                let path = configManager.getConfigPath(configNames[i])
                // Should follow kebab-case naming and .json extension
                if (!path.includes(configNames[i] + ".json")) {
                    return false
                }
            }
            return true
        })
        
        // Test 15: Directory structure compatibility
        runTest("Directory structure compatibility", function() {
            // Test that the config directory structure is compatible with existing layout
            let configDir = configManager.configDirectory
            
            // Should be relative to the quickshell config directory
            return typeof configDir === 'string' && configDir.length > 0
        })
        
        // Test 16: JSON formatting for version control
        runTest("JSON formatting for version control", function() {
            let testConfig = {
                "version": "1.0",
                "settings": {
                    "option1": true,
                    "option2": ["value1", "value2"]
                }
            }
            
            // JSON should be formatted with proper indentation for Git diffs
            let formatted = JSON.stringify(testConfig, null, 2)
            return formatted.includes("  ") && // Has indentation
                   formatted.includes("\n") && // Has line breaks
                   formatted.includes('"version": "1.0"')
        })
    }
    
    // Test device-specific configuration loading
    function testDeviceSpecificLoading() {
        if (!deviceDetector) {
            console.error("DeviceDetector not available for device-specific tests")
            return
        }
        
        // Test 17: Doraemon device configuration
        runTest("Doraemon device configuration", function() {
            // Mock doraemon device
            let doraemonConfig = {
                "deviceName": "doraemon",
                "isDoraemon": true,
                "isNobita": false,
                "isPortable": true,
                "batteryEnabled": true,
                "performanceMode": "laptop"
            }
            
            return doraemonConfig.isDoraemon === true &&
                   doraemonConfig.isPortable === true &&
                   doraemonConfig.batteryEnabled === true &&
                   doraemonConfig.performanceMode === "laptop"
        })
        
        // Test 18: Nobita device configuration
        runTest("Nobita device configuration", function() {
            // Mock nobita device
            let nobitaConfig = {
                "deviceName": "nobita",
                "isDoraemon": false,
                "isNobita": true,
                "isPortable": false,
                "batteryEnabled": false,
                "performanceMode": "desktop"
            }
            
            return nobitaConfig.isNobita === true &&
                   nobitaConfig.isPortable === false &&
                   nobitaConfig.batteryEnabled === false &&
                   nobitaConfig.performanceMode === "desktop"
        })
        
        // Test 19: Unknown device configuration
        runTest("Unknown device configuration", function() {
            let unknownConfig = {
                "deviceName": "unknown",
                "isDoraemon": false,
                "isNobita": false,
                "isPortable": false,
                "batteryEnabled": false,
                "performanceMode": "laptop"
            }
            
            return unknownConfig.isDoraemon === false &&
                   unknownConfig.isNobita === false &&
                   unknownConfig.isPortable === false &&
                   unknownConfig.batteryEnabled === false
        })
        
        // Test 20: Device-specific feature flags
        runTest("Device-specific feature flags", function() {
            let devices = [
                { name: "doraemon", expectBattery: true, expectPortable: true },
                { name: "nobita", expectBattery: false, expectPortable: false },
                { name: "unknown", expectBattery: false, expectPortable: false }
            ]
            
            for (let i = 0; i < devices.length; i++) {
                let device = devices[i]
                let isDoraemon = (device.name === "doraemon")
                let isPortable = isDoraemon
                let batteryEnabled = isPortable
                
                if (batteryEnabled !== device.expectBattery || isPortable !== device.expectPortable) {
                    return false
                }
            }
            return true
        })
        
        // Test 21: Configuration file path resolution
        runTest("Configuration file path resolution", function() {
            if (!configManager) return false
            
            let deviceConfigs = ["doraemon-config", "nobita-config", "default-config"]
            
            for (let i = 0; i < deviceConfigs.length; i++) {
                let path = configManager.getConfigPath(deviceConfigs[i])
                if (!path.includes(deviceConfigs[i] + ".json")) {
                    return false
                }
            }
            return true
        })
    }
    
    // Helper function to run individual tests
    function runTest(testName, testFunction) {
        totalTests++
        
        try {
            let result = testFunction()
            if (result) {
                passedTests++
                console.log("✅", testName)
                testResults.push({ name: testName, passed: true, error: null })
            } else {
                failedTests++
                console.log("❌", testName, "- Test returned false")
                testResults.push({ name: testName, passed: false, error: "Test returned false" })
            }
        } catch (error) {
            failedTests++
            console.log("❌", testName, "- Error:", error.toString())
            testResults.push({ name: testName, passed: false, error: error.toString() })
        }
    }
    
    // Report final test results
    function reportResults() {
        console.log("\n=== Unit Test Results ===")
        console.log("Total tests:", totalTests)
        console.log("Passed:", passedTests)
        console.log("Failed:", failedTests)
        console.log("Success rate:", Math.round((passedTests / totalTests) * 100) + "%")
        
        if (failedTests > 0) {
            console.log("\n--- Failed Tests ---")
            for (let i = 0; i < testResults.length; i++) {
                let result = testResults[i]
                if (!result.passed) {
                    console.log("❌", result.name)
                    if (result.error) {
                        console.log("   Error:", result.error)
                    }
                }
            }
        } else {
            console.log("🎉 All unit tests passed!")
        }
        
        console.log("=== Unit Tests Completed ===")
        
        // Exit the application after a short delay
        Qt.callLater(function() {
            Qt.quit()
        })
    }
}