import QtQuick
import "./cache"

QtObject {
    id: testRunner
    
    Component.onCompleted: {
        console.log("=== Testing DiskCacheManager ===")
        testCacheManager()
    }
    
    DiskCacheManager {
        id: testCacheManager
        
        onCacheLoaded: function(diskData) {
            console.log("✓ Cache loaded successfully with", diskData.length, "disks")
            
            // Test saving new data
            let testData = [
                {
                    mountPoint: "/",
                    usage: 45,
                    color: "#cba6f7",
                    device: "/dev/nvme0n1p2"
                },
                {
                    mountPoint: "/home",
                    usage: 67,
                    color: "#fab387",
                    device: "/dev/nvme0n1p3"
                }
            ]
            
            console.log("Testing cache save...")
            testCacheManager.saveDiskCache(testData)
        }
        
        onCacheSaved: function() {
            console.log("✓ Cache saved successfully")
            
            // Test cache validity
            console.log("Cache valid:", testCacheManager.isCacheValid())
            
            // Test cache stats
            let stats = testCacheManager.getCacheStats()
            console.log("Cache stats:", JSON.stringify(stats, null, 2))
            
            console.log("=== DiskCacheManager tests completed ===")
        }
        
        onCacheError: function(error) {
            console.error("✗ Cache error:", error)
        }
    }
    
    function testCacheManager() {
        console.log("Testing cache initialization...")
        console.log("Cache enabled:", testCacheManager.cacheEnabled)
        console.log("Cache expiry hours:", testCacheManager.cacheExpiryHours)
        
        // The cache will automatically load on Component.onCompleted
    }
}