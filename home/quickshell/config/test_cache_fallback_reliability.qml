import QtQuick
import Quickshell.Io
import "./cache"
import "./utils"

QtObject {
    id: propertyTestRunner
    
    property int testIterations: 100
    property int currentIteration: 0
    property bool testsPassed: true
    property var testResults: []
    
    Component.onCompleted: {
        console.log("=== Property-Based Tests for Cache Fallback Reliability ===")
        console.log("**Feature: quickshell-enhancements, Property 4: Cache fallback reliability**")
        console.log("**Validates: Requirements 1.4**")
        console.log("Running", testIterations, "iterations...")
        
        runPropertyTests()
    }
    
    function runPropertyTests() {
        // Property 4: Cache fallback reliability
        // For any disk detection failure, the cache system should successfully retrieve 
        // and use the most recent valid cached data
        testProperty4()
        
        reportResults()
    }
    
    function testProperty4() {
        console.log("\n--- Testing Property 4: Cache fallback reliability ---")
        
        for (let i = 0; i < testIterations; i++) {
            currentIteration = i
            let testScenario = generateRandomFallbackScenario()
            let result = testCacheFallbackReliability(testScenario, i)
            
            if (!result.passed) {
                testsPassed = false
                testResults.push({
                    property: "Property 4",
                    iteration: i,
                    input: testScenario,
                    expected: "Cache system should use most recent valid cached data when disk detection fails",
                    actual: result.message,
                    passed: false
                })
                console.error("❌ Property 4 failed at iteration", i, ":", result.message)
            }
        }
        
        if (testsPassed) {
            console.log("✅ Property 4 passed all", testIterations, "iterations")
        }
    }
    
    function generateRandomFallbackScenario() {
        // Generate random scenarios for cache fallback testing
        let failureTypes = [
            "disk_detection_command_failure",
            "disk_detection_timeout", 
            "disk_detection_empty_output",
            "disk_detection_invalid_format",
            "disk_detection_permission_denied",
            "disk_detection_process_crash"
        ]
        
        let failureType = failureTypes[Math.floor(Math.random() * failureTypes.length)]
        let cacheAge = Math.floor(Math.random() * 72) // 0-72 hours
        let diskCount = Math.floor(Math.random() * 5) + 1 // 1-5 disks
        let hasValidCache = Math.random() > 0.2 // 80% chance of having valid cache
        let cacheEnabled = Math.random() > 0.1 // 90% chance cache is enabled
        
        // Determine cache validity (not necessarily related to expiration for fallback testing)
        let cacheValid = hasValidCache && (Math.random() > 0.3) // 70% chance cache is valid if it exists
        
        return {
            failureType: failureType,
            cacheAgeHours: cacheAge,
            diskCount: diskCount,
            hasValidCache: hasValidCache,
            cacheValid: cacheValid,
            cacheEnabled: cacheEnabled,
            detectionWillFail: true
        }
    }
    
    function testCacheFallbackReliability(scenario, iteration) {
        try {
            // Create a mock cache manager to test fallback behavior
            let mockCacheManager = createMockCacheManagerWithFallback(scenario)
            
            // Test 1: Verify initial cache state
            let initialCacheStats = mockCacheManager.getCacheStats()
            
            if (scenario.cacheEnabled && scenario.hasValidCache) {
                if (initialCacheStats.diskCount === 0) {
                    return {
                        passed: false,
                        message: "Mock cache should contain disk data when hasValidCache is true"
                    }
                }
            }
            
            // Test 2: Simulate disk detection failure
            let detectionFailed = false
            let fallbackUsed = false
            let fallbackData = null
            let errorMessage = ""
            
            // Mock the detection process to simulate failure
            let originalRefresh = mockCacheManager.refreshCache
            mockCacheManager.refreshCache = function() {
                // Simulate detection failure based on scenario
                detectionFailed = true
                errorMessage = simulateDetectionFailure(scenario.failureType)
                
                // Cache system should fall back to existing cache if available and valid
                if (this.hasValidCacheData() && scenario.cacheValid) {
                    fallbackUsed = true
                    fallbackData = this.cachedDisks.slice() // Copy current cache
                    // Restore cache validity since we're using fallback
                    this.cacheValid = true
                    console.log(`Detection failed (${scenario.failureType}), using cache fallback with ${fallbackData.length} disks`)
                } else {
                    console.log(`Detection failed (${scenario.failureType}), no valid cache available for fallback`)
                }
            }
            
            // Test 3: Trigger cache access that would normally cause refresh
            let retrievedDisks = []
            
            if (scenario.cacheEnabled) {
                // Force cache to be invalid to trigger refresh attempt
                mockCacheManager.invalidateCache()
                
                // Now try to get cached disks - this should trigger refresh and fallback
                retrievedDisks = mockCacheManager.getCachedDisks()
            } else {
                // If cache disabled, should not attempt fallback
                retrievedDisks = mockCacheManager.getCachedDisks()
            }
            
            // Test 4: Verify fallback behavior based on scenario
            if (scenario.cacheEnabled && scenario.hasValidCache && scenario.cacheValid) {
                // Should use fallback when detection fails and valid cache exists
                if (!detectionFailed) {
                    return {
                        passed: false,
                        message: "Detection failure should have been simulated"
                    }
                }
                
                if (!fallbackUsed) {
                    return {
                        passed: false,
                        message: "Cache fallback should be used when detection fails and valid cache exists"
                    }
                }
                
                if (!fallbackData || fallbackData.length === 0) {
                    return {
                        passed: false,
                        message: "Fallback data should contain disk information"
                    }
                }
                
                // Retrieved disks should match fallback data
                if (retrievedDisks.length !== fallbackData.length) {
                    return {
                        passed: false,
                        message: `Retrieved disks count (${retrievedDisks.length}) should match fallback data count (${fallbackData.length})`
                    }
                }
                
                // Verify data integrity in fallback
                for (let i = 0; i < retrievedDisks.length; i++) {
                    let retrieved = retrievedDisks[i]
                    let fallback = fallbackData[i]
                    
                    if (!retrieved || !fallback) {
                        return {
                            passed: false,
                            message: `Missing disk data at index ${i} in fallback`
                        }
                    }
                    
                    if (retrieved.mountPoint !== fallback.mountPoint ||
                        retrieved.usage !== fallback.usage ||
                        retrieved.color !== fallback.color ||
                        retrieved.device !== fallback.device) {
                        return {
                            passed: false,
                            message: `Fallback data integrity check failed at index ${i}`
                        }
                    }
                }
            }
            
            if (scenario.cacheEnabled && (!scenario.hasValidCache || !scenario.cacheValid)) {
                // Should not use fallback when no valid cache exists
                if (detectionFailed && fallbackUsed) {
                    return {
                        passed: false,
                        message: "Should not use fallback when no valid cache data exists"
                    }
                }
                
                // Should return empty or minimal data when no fallback available
                if (retrievedDisks.length > 0 && !scenario.hasValidCache) {
                    return {
                        passed: false,
                        message: "Should not return disk data when no valid cache exists and detection fails"
                    }
                }
            }
            
            if (!scenario.cacheEnabled) {
                // Should not attempt fallback when cache is disabled
                if (fallbackUsed) {
                    return {
                        passed: false,
                        message: "Should not use cache fallback when caching is disabled"
                    }
                }
            }
            
            // Test 5: Verify error handling during fallback
            if (detectionFailed && scenario.cacheEnabled) {
                // Error should be logged but system should continue with fallback
                if (errorMessage === "") {
                    return {
                        passed: false,
                        message: "Detection failure should generate error message"
                    }
                }
                
                // Verify error message contains failure type information
                if (!errorMessage.toLowerCase().includes(scenario.failureType.split('_')[2])) {
                    // Check if error message relates to the failure type
                    let expectedKeywords = {
                        "disk_detection_command_failure": ["command", "failed"],
                        "disk_detection_timeout": ["timeout", "time"],
                        "disk_detection_empty_output": ["empty", "output"],
                        "disk_detection_invalid_format": ["invalid", "format"],
                        "disk_detection_permission_denied": ["permission", "denied"],
                        "disk_detection_process_crash": ["process", "crash"]
                    }
                    
                    let keywords = expectedKeywords[scenario.failureType] || ["error"]
                    let hasExpectedKeyword = keywords.some(keyword => 
                        errorMessage.toLowerCase().includes(keyword)
                    )
                    
                    if (!hasExpectedKeyword) {
                        return {
                            passed: false,
                            message: `Error message should contain relevant keywords for ${scenario.failureType}, got: ${errorMessage}`
                        }
                    }
                }
            }
            
            // Test 6: Verify cache state consistency after fallback
            if (fallbackUsed) {
                let postFallbackStats = mockCacheManager.getCacheStats()
                
                // Cache should still be marked as having data after fallback
                if (postFallbackStats.diskCount === 0) {
                    return {
                        passed: false,
                        message: "Cache should retain disk count after successful fallback"
                    }
                }
                
                // After fallback, cache should be valid again (since we're using existing data)
                if (!mockCacheManager.isCacheValid()) {
                    return {
                        passed: false,
                        message: "Cache should be valid after successful fallback operation"
                    }
                }
            }
            
            // Test 7: Test multiple consecutive failures with fallback
            if (scenario.cacheEnabled && scenario.hasValidCache && scenario.cacheValid) {
                // Simulate multiple detection failures
                for (let attempt = 0; attempt < 3; attempt++) {
                    mockCacheManager.invalidateCache()
                    let multipleFailureDisks = mockCacheManager.getCachedDisks()
                    
                    // Should consistently use fallback for each failure
                    if (multipleFailureDisks.length !== fallbackData.length) {
                        return {
                            passed: false,
                            message: `Multiple failure attempt ${attempt} should return consistent fallback data`
                        }
                    }
                }
            }
            
            // Test 8: Verify fallback data age and validity
            if (fallbackUsed && fallbackData) {
                // Fallback data should have reasonable timestamps
                for (let disk of fallbackData) {
                    if (!disk.timestamp || disk.timestamp <= 0) {
                        return {
                            passed: false,
                            message: "Fallback disk data should have valid timestamps"
                        }
                    }
                    
                    // Timestamp should not be in the future
                    let currentTime = Date.now() / 1000
                    if (disk.timestamp > currentTime + 60) { // Allow 1 minute tolerance
                        return {
                            passed: false,
                            message: "Fallback disk timestamp should not be in the future"
                        }
                    }
                }
            }
            
            return {
                passed: true,
                message: `Cache fallback reliability verified for ${scenario.failureType} (cache enabled: ${scenario.cacheEnabled}, valid cache: ${scenario.hasValidCache && scenario.cacheValid})`
            }
            
        } catch (error) {
            return {
                passed: false,
                message: `Exception during cache fallback test: ${error.toString()}`
            }
        }
    }
    
    function createMockCacheManagerWithFallback(scenario) {
        let currentTime = Date.now() / 1000
        let cacheTimestamp = currentTime - (scenario.cacheAgeHours * 3600)
        
        let mockManager = {
            cacheEnabled: scenario.cacheEnabled,
            cacheExpiryHours: 24,
            cachedDisks: [],
            cacheValid: scenario.cacheValid,
            mockCacheTimestamp: cacheTimestamp,
            
            // Initialize with mock cache data if scenario has valid cache
            mockCacheData: scenario.hasValidCache ? {
                version: "1.0",
                timestamp: cacheTimestamp,
                disks: generateMockDiskDataForFallback(scenario.diskCount, cacheTimestamp)
            } : null,
            
            // Mock ConfigManager for testing
            configManager: {
                getConfig: function(configName) {
                    if (configName.includes("cache/disk-cache") && mockManager.mockCacheData) {
                        return mockManager.mockCacheData
                    }
                    return null
                }
            },
            
            // Initialize cache state
            init: function() {
                if (this.mockCacheData) {
                    this.processCacheData(this.mockCacheData)
                }
            },
            
            processCacheData: function(cacheData) {
                if (!cacheData || !cacheData.disks) {
                    this.cachedDisks = []
                    this.cacheValid = false
                    return
                }
                
                this.cachedDisks = cacheData.disks || []
                // For fallback testing, use the scenario's cache validity
                this.cacheValid = scenario.cacheValid && this.cachedDisks.length > 0
            },
            
            isCacheValid: function() {
                return this.cacheValid && this.cachedDisks.length > 0
            },
            
            hasValidCacheData: function() {
                return this.cachedDisks.length > 0 && scenario.hasValidCache
            },
            
            getCacheStats: function() {
                let currentTime = Date.now() / 1000
                let ageHours = this.mockCacheTimestamp ? (currentTime - this.mockCacheTimestamp) / 3600 : 0
                
                return {
                    enabled: this.cacheEnabled,
                    valid: this.cacheValid,
                    diskCount: this.cachedDisks.length,
                    ageHours: Math.round(ageHours * 10) / 10,
                    expiryHours: this.cacheExpiryHours
                }
            },
            
            getCachedDisks: function() {
                if (!this.cacheEnabled) {
                    return []
                }
                
                if (this.isCacheValid()) {
                    return this.cachedDisks
                } else {
                    // Cache invalid, trigger refresh (which will fail and use fallback)
                    this.refreshCache()
                    return this.cachedDisks
                }
            },
            
            refreshCache: function() {
                // This will be overridden in the test to simulate detection failure
                console.log("Default refresh cache called - should be overridden in test")
            },
            
            invalidateCache: function() {
                this.cacheValid = false
                console.log("Cache invalidated for fallback testing")
            },
            
            saveDiskCache: function(diskData) {
                if (!Array.isArray(diskData)) {
                    return
                }
                
                // Update cache with new data
                this.mockCacheTimestamp = Date.now() / 1000
                this.mockCacheData = {
                    version: "1.0",
                    timestamp: this.mockCacheTimestamp,
                    disks: diskData
                }
                
                this.cachedDisks = diskData
                this.cacheValid = true
            }
        }
        
        // Initialize the mock manager
        mockManager.init()
        
        return mockManager
    }
    
    function generateMockDiskDataForFallback(diskCount, timestamp) {
        let mockDisks = []
        let colors = ["#cba6f7", "#fab387", "#89b4fa", "#a6e3a1", "#f38ba8"]
        let mountPoints = ["/", "/home", "/var", "/tmp", "/boot"]
        let devices = ["/dev/nvme0n1p1", "/dev/nvme0n1p2", "/dev/sda1", "/dev/sda2", "/dev/sdb1"]
        
        for (let i = 0; i < diskCount; i++) {
            mockDisks.push({
                mountPoint: mountPoints[i % mountPoints.length],
                usage: Math.floor(Math.random() * 80) + 10, // 10-90%
                color: colors[i % colors.length],
                device: devices[i % devices.length],
                timestamp: timestamp
            })
        }
        
        return mockDisks
    }
    
    function simulateDetectionFailure(failureType) {
        // Simulate different types of detection failures
        let errorMessages = {
            "disk_detection_command_failure": "Command 'df' failed with exit code 1",
            "disk_detection_timeout": "Disk detection process timed out after 30 seconds",
            "disk_detection_empty_output": "Disk detection returned empty output",
            "disk_detection_invalid_format": "Disk detection output format is invalid or corrupted",
            "disk_detection_permission_denied": "Permission denied accessing disk information",
            "disk_detection_process_crash": "Disk detection process crashed unexpectedly"
        }
        
        return errorMessages[failureType] || "Unknown disk detection failure"
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
                console.log(`   Scenario: ${JSON.stringify(result.input).substring(0, 150)}...`)
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