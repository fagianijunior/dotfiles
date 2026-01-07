import QtQuick
import Quickshell.Io
import "../utils"

QtObject {
    id: diskCacheManager
    
    // Properties
    property string cacheDirectory: ""
    property string cacheFileName: "disk-cache.json"
    property bool cacheEnabled: true
    property int cacheExpiryHours: 24
    property var cachedDisks: []
    property bool cacheValid: false
    
    // Configuration manager for handling JSON operations
    property ConfigManager configManager: ConfigManager {
        id: configManager
    }
    
    // Signals
    signal cacheLoaded(var diskData)
    signal cacheSaved()
    signal cacheRefreshed(var diskData)
    signal cacheError(string error)
    
    // Initialize cache directory
    Component.onCompleted: {
        cacheDirectory = Qt.resolvedUrl("../cache/").toString().replace("file://", "")
        console.log("DiskCacheManager initialized with directory:", cacheDirectory)
        
        // Ensure cache directory exists
        configManager.ensureDirectory(cacheDirectory)
        
        // Load existing cache if available
        loadCachedDisks()
    }
    
    // Load cached disk configurations
    function loadCachedDisks() {
        if (!cacheEnabled) {
            console.log("Cache disabled, skipping load")
            return []
        }
        
        let defaultCache = {
            version: "1.0",
            timestamp: 0,
            disks: []
        }
        
        // Use ConfigManager to load cache
        let loadProcess = configManager.loadConfig("cache/" + cacheFileName.replace(".json", ""), defaultCache)
        
        // Connect to config loaded signal
        let connection = configManager.configLoaded.connect(function(configName, configData) {
            if (configName === "cache/" + cacheFileName.replace(".json", "")) {
                processCacheData(configData)
                configManager.configLoaded.disconnect(connection)
            }
        })
        
        return cachedDisks
    }
    
    // Process loaded cache data
    function processCacheData(cacheData) {
        if (!cacheData || !cacheData.disks) {
            console.log("No valid cache data found")
            cachedDisks = []
            cacheValid = false
            cacheLoaded([])
            return
        }
        
        // Check cache validity based on timestamp
        let currentTime = Date.now() / 1000 // Convert to seconds
        let cacheTime = cacheData.timestamp || 0
        let ageHours = (currentTime - cacheTime) / 3600
        
        cacheValid = ageHours < cacheExpiryHours
        cachedDisks = cacheData.disks || []
        
        console.log("Cache loaded:", cachedDisks.length, "disks, age:", Math.round(ageHours), "hours, valid:", cacheValid)
        
        cacheLoaded(cachedDisks)
        
        // If cache is expired, trigger refresh
        if (!cacheValid) {
            console.log("Cache expired, will refresh on next detection")
        }
    }
    
    // Save disk cache
    function saveDiskCache(diskData) {
        if (!cacheEnabled) {
            console.log("Cache disabled, skipping save")
            return
        }
        
        if (!Array.isArray(diskData)) {
            console.error("Invalid disk data provided to cache")
            cacheError("Invalid disk data format")
            return
        }
        
        let cacheData = {
            version: "1.0",
            timestamp: Math.floor(Date.now() / 1000), // Unix timestamp in seconds
            disks: diskData
        }
        
        // Use ConfigManager to save cache
        let saveProcess = configManager.saveConfig("cache/" + cacheFileName.replace(".json", ""), cacheData)
        
        // Connect to config saved signal
        let connection = configManager.configSaved.connect(function(configName) {
            if (configName === "cache/" + cacheFileName.replace(".json", "")) {
                cachedDisks = diskData
                cacheValid = true
                console.log("Disk cache saved successfully:", diskData.length, "disks")
                cacheSaved()
                configManager.configSaved.disconnect(connection)
            }
        })
        
        // Connect to error signal
        let errorConnection = configManager.configError.connect(function(configName, error) {
            if (configName === "cache/" + cacheFileName.replace(".json", "")) {
                console.error("Failed to save disk cache:", error)
                cacheError("Failed to save cache: " + error)
                configManager.configError.disconnect(errorConnection)
            }
        })
    }
    
    // Check if cache is valid (not expired)
    function isCacheValid() {
        return cacheValid && cachedDisks.length > 0
    }
    
    // Refresh cache by detecting disks and saving new data
    function refreshCache() {
        console.log("Refreshing disk cache...")
        
        // Create process to detect current disk usage
        let detectProcess = Qt.createQmlObject(`
            import Quickshell.Io
            Process {
                command: ["bash", "-c", "df -h | grep -E '^/dev/' | awk '{print $6 \":\" $5}' | sed 's/%//' | sort"]
                
                stdout: StdioCollector {
                    onStreamFinished: {
                        diskCacheManager.processDetectionResult(this.text)
                    }
                }
                
                stderr: StdioCollector {
                    onStreamFinished: {
                        if (this.text.trim() !== "") {
                            console.error("Disk detection error:", this.text.trim())
                            diskCacheManager.cacheError("Disk detection failed: " + this.text.trim())
                        }
                    }
                }
            }
        `, diskCacheManager)
        
        detectProcess.running = true
    }
    
    // Process disk detection results
    function processDetectionResult(output) {
        let lines = output.trim().split('\n')
        let colors = ["#cba6f7", "#fab387", "#89b4fa", "#a6e3a1", "#f38ba8"] // Catppuccin Macchiato colors
        let newDiskData = []
        
        for (let i = 0; i < lines.length && i < colors.length; i++) {
            let line = lines[i].trim()
            if (line === "") continue
            
            let parts = line.split(':')
            if (parts.length !== 2) continue
            
            let mountPoint = parts[0]
            let usage = parseInt(parts[1])
            
            // Filter valid mount points
            if (mountPoint.startsWith("/") && !mountPoint.includes("snap") && 
                !mountPoint.includes("loop") && mountPoint.length < 20) {
                
                newDiskData.push({
                    mountPoint: mountPoint,
                    usage: usage,
                    color: colors[i % colors.length],
                    device: "unknown", // Could be enhanced to detect actual device
                    timestamp: Math.floor(Date.now() / 1000)
                })
            }
        }
        
        if (newDiskData.length > 0) {
            saveDiskCache(newDiskData)
            cacheRefreshed(newDiskData)
            console.log("Cache refreshed with", newDiskData.length, "disks")
        } else {
            console.warn("No valid disks detected during refresh")
            cacheError("No valid disks detected")
        }
    }
    
    // Get cached disks or trigger refresh if needed
    function getCachedDisks() {
        if (isCacheValid()) {
            return cachedDisks
        } else {
            console.log("Cache invalid or empty, triggering refresh")
            refreshCache()
            return cachedDisks // Return current cache even if expired, refresh will update it
        }
    }
    
    // Force cache invalidation
    function invalidateCache() {
        cacheValid = false
        cachedDisks = []
        console.log("Cache invalidated")
    }
    
    // Get cache statistics
    function getCacheStats() {
        let currentTime = Date.now() / 1000
        let cacheAge = 0
        
        if (cachedDisks.length > 0) {
            // Try to get timestamp from ConfigManager's loaded config
            let cacheConfig = configManager.getConfig("cache/" + cacheFileName.replace(".json", ""))
            if (cacheConfig && cacheConfig.timestamp) {
                cacheAge = Math.round((currentTime - cacheConfig.timestamp) / 3600 * 10) / 10 // Hours with 1 decimal
            }
        }
        
        return {
            enabled: cacheEnabled,
            valid: cacheValid,
            diskCount: cachedDisks.length,
            ageHours: cacheAge,
            expiryHours: cacheExpiryHours
        }
    }
    
    // Enable or disable caching
    function setCacheEnabled(enabled) {
        cacheEnabled = enabled
        console.log("Cache", enabled ? "enabled" : "disabled")
    }
    
    // Set cache expiry time
    function setCacheExpiry(hours) {
        if (hours > 0) {
            cacheExpiryHours = hours
            console.log("Cache expiry set to", hours, "hours")
            
            // Re-validate current cache with new expiry
            if (cachedDisks.length > 0) {
                let cacheConfig = configManager.getConfig("cache/" + cacheFileName.replace(".json", ""))
                if (cacheConfig && cacheConfig.timestamp) {
                    let currentTime = Date.now() / 1000
                    let ageHours = (currentTime - cacheConfig.timestamp) / 3600
                    cacheValid = ageHours < cacheExpiryHours
                }
            }
        }
    }
}