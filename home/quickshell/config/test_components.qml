import QtQuick
import "./utils"

Item {
    id: testRunner
    
    property bool testCompleted: false
    
    DeviceDetector {
        id: deviceDetector
        
        onDeviceDetected: function(device) {
            console.log("=== DeviceDetector Test Results ===")
            console.log("Detected device:", device)
            console.log("Device name:", deviceName)
            console.log("Is Doraemon:", isDoraemon)
            console.log("Is Nobita:", isNobita)
            console.log("Is portable:", isPortableDevice)
            console.log("Device config:", JSON.stringify(getDeviceSpecificConfig()))
            
            testConfigManager()
        }
    }
    
    ConfigManager {
        id: configManager
        
        onConfigLoaded: function(configName, configData) {
            console.log("=== ConfigManager Test Results ===")
            console.log("Config loaded:", configName)
            console.log("Config data:", JSON.stringify(configData))
            
            // Test saving a config
            let testConfig = {
                "version": "1.0",
                "testData": "Hello World",
                "timestamp": Date.now()
            }
            
            configManager.saveConfig("test-config", testConfig)
        }
        
        onConfigSaved: function(configName) {
            console.log("Config saved successfully:", configName)
            testRunner.testCompleted = true
            console.log("=== All Tests Completed ===")
        }
        
        onConfigError: function(configName, error) {
            console.error("Config error for", configName, ":", error)
        }
    }
    
    Component.onCompleted: {
        console.log("=== Starting Component Tests ===")
        // DeviceDetector will start automatically
    }
    
    function testConfigManager() {
        console.log("Testing ConfigManager...")
        
        // Test loading a config with defaults
        let defaultConfig = {
            "version": "1.0",
            "enabled": true,
            "settings": {}
        }
        
        configManager.loadConfig("test-config", defaultConfig)
    }
}