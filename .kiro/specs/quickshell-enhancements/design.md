# Design Document

## Overview

This design document outlines the implementation of five key enhancements to the quickshell configuration system within a NixOS environment. The enhancements focus on performance optimization through disk caching, improved user experience through notification filtering and visual feedback, enhanced interactivity through click-to-redirect functionality, and device-specific features like battery monitoring for the Doraemon notebook.

The design maintains compatibility with the existing Catppuccin Macchiato theme and ensures proper Git version control integration for NixOS rebuilds.

## Architecture

The enhanced quickshell system follows a modular architecture that extends the existing QML-based interface:

```
quickshell-enhancements/
├── cache/
│   ├── DiskCacheManager.qml
│   └── disk-cache.json
├── filters/
│   ├── NotificationFilter.qml
│   └── filter-config.json
├── colors/
│   ├── BorderColorManager.qml
│   └── app-colors.json
├── interaction/
│   └── ClickRedirectHandler.qml
├── battery/
│   └── BatteryGraph.qml
└── utils/
    ├── DeviceDetector.qml
    └── ConfigManager.qml
```

The architecture integrates with the existing shell.qml structure while maintaining separation of concerns and modularity.

## Components and Interfaces

### 1. Disk Cache System

**DiskCacheManager.qml**
- Manages persistent storage of disk configuration data
- Provides cache validation and refresh mechanisms
- Integrates with existing disk detection logic

**Interface:**
```qml
QtObject {
    function loadCachedDisks(): array
    function saveDiskCache(diskData: array): void
    function isCacheValid(): boolean
    function refreshCache(): void
    property bool cacheEnabled: true
    property int cacheExpiryHours: 24
}
```

### 2. Notification Filter System

**NotificationFilter.qml**
- Processes incoming notifications against filter rules
- Manages allow/block lists per application
- Provides real-time filter rule updates

**Interface:**
```qml
QtObject {
    function shouldDisplayNotification(appName: string): boolean
    function addToBlockList(appName: string): void
    function addToAllowList(appName: string): void
    function removeFromFilters(appName: string): void
    property var blockList: []
    property var allowList: []
}
```

### 3. Border Color System

**BorderColorManager.qml**
- Maps application names to Catppuccin Macchiato colors
- Provides fallback color schemes for unknown applications
- Manages color configuration persistence

**Interface:**
```qml
QtObject {
    function getColorForApp(appName: string): color
    function setColorForApp(appName: string, color: color): void
    function getCategoryColor(category: string): color
    property var appColors: ({})
    property var categoryColors: ({})
}
```

### 4. Click Redirect System

**ClickRedirectHandler.qml**
- Handles notification click events
- Manages application focus and launching
- Provides error handling for failed redirections

**Interface:**
```qml
QtObject {
    function handleNotificationClick(appName: string, notificationId: string): void
    function focusApplication(appName: string): boolean
    function launchApplication(appName: string): boolean
    signal redirectFailed(appName: string, error: string)
}
```

### 5. Battery Monitoring System

**BatteryGraph.qml**
- Extends the existing Graph.qml component
- Provides battery-specific visualization
- Includes device detection for conditional display

**Interface:**
```qml
Graph {
    property bool isPortableDevice: false
    property int warningThreshold: 20
    property int criticalThreshold: 10
    function updateBatteryLevel(): void
    function getBatteryColor(level: int): color
}
```

### 6. Device Detection Utility

**DeviceDetector.qml**
- Detects current device (Doraemon/Nobita)
- Provides device-specific configuration
- Integrates with NixOS hostname detection

**Interface:**
```qml
QtObject {
    function getCurrentDevice(): string
    function isPortableDevice(): boolean
    function getDeviceSpecificConfig(): object
    property string deviceName: ""
    property bool isDoraemon: false
    property bool isNobita: false
}
```

## Data Models

### Disk Cache Data Model
```json
{
  "version": "1.0",
  "timestamp": 1704067200,
  "disks": [
    {
      "mountPoint": "/",
      "usage": 45,
      "color": "#cba6f7",
      "device": "/dev/nvme0n1p2"
    }
  ]
}
```

### Notification Filter Configuration
```json
{
  "version": "1.0",
  "blockList": ["spotify", "discord-canary"],
  "allowList": ["firefox", "thunderbird"],
  "defaultBehavior": "allow"
}
```

### Application Color Mapping
```json
{
  "version": "1.0",
  "appColors": {
    "firefox": "#89b4fa",
    "thunderbird": "#a6e3a1",
    "discord": "#cba6f7",
    "spotify": "#94e2d5"
  },
  "categoryColors": {
    "browser": "#89b4fa",
    "communication": "#a6e3a1",
    "media": "#fab387",
    "development": "#f9e2af",
    "system": "#f38ba8"
  }
}
```

## Correctness Properties

*A property is a characteristic or behavior that should hold true across all valid executions of a system-essentially, a formal statement about what the system should do. Properties serve as the bridge between human-readable specifications and machine-verifiable correctness guarantees.*
Propert
y 1: Disk cache storage consistency
*For any* disk configuration data, storing it through the cache system should result in the data being persistently saved in a Git-trackable location with the correct format
**Validates: Requirements 1.1**

Property 2: Cache loading precedence
*For any* system startup sequence, cached disk configurations should be loaded and available before any new disk detection attempts are made
**Validates: Requirements 1.2**

Property 3: Cache expiration behavior
*For any* cached disk data older than 24 hours, the cache system should automatically refresh the data with new detection results
**Validates: Requirements 1.3**

Property 4: Cache fallback reliability
*For any* disk detection failure, the cache system should successfully retrieve and use the most recent valid cached data
**Validates: Requirements 1.4**

Property 5: Git compatibility preservation
*For any* new cache file created, the file format and location should be compatible with Git version control requirements
**Validates: Requirements 1.5**

Property 6: Notification filter processing
*For any* incoming notification, the filter system should check the application name against all configured filter rules
**Validates: Requirements 2.1**

Property 7: Block list enforcement
*For any* application in the block list, notifications from that application should be prevented from being displayed
**Validates: Requirements 2.2**

Property 8: Allow list priority
*For any* application in the allow list, notifications should be displayed regardless of other conflicting filter rules
**Validates: Requirements 2.3**

Property 9: Real-time filter updates
*For any* filter configuration update, new rules should be immediately applied to all subsequent notifications
**Validates: Requirements 2.4**

Property 10: Default filter behavior
*For any* application not in any filter list, notifications should follow the configured default display behavior
**Validates: Requirements 2.5**

Property 11: Color determination consistency
*For any* displayed notification, the border color system should determine and apply an appropriate Catppuccin Macchiato color based on the application name
**Validates: Requirements 3.1**

Property 12: Configured color application
*For any* application with a configured color, that specific Catppuccin Macchiato color should be applied to all notifications from that application
**Validates: Requirements 3.2**

Property 13: Category-based color fallback
*For any* application without a configured color, the system should use appropriate Catppuccin Macchiato colors based on the application category
**Validates: Requirements 3.3**

Property 14: Multi-notification color consistency
*For any* set of notifications from the same application, all notifications should use the same Catppuccin Macchiato color
**Validates: Requirements 3.4**

Property 15: Dynamic color configuration
*For any* color configuration update, new Catppuccin Macchiato colors should be applied to all newly displayed notifications
**Validates: Requirements 3.5**

Property 16: Application identification accuracy
*For any* notification click event, the redirect system should correctly identify the originating application
**Validates: Requirements 4.1**

Property 17: Running application focus
*For any* notification click where the originating application is running, the system should bring that application window to focus
**Validates: Requirements 4.2**

Property 18: Non-running application launch
*For any* notification click where the originating application is not running, the system should launch that application
**Validates: Requirements 4.3**

Property 19: Error handling for failed redirects
*For any* notification click where the application cannot be identified or launched, an appropriate error message should be displayed
**Validates: Requirements 4.4**

Property 20: Optional notification dismissal
*For any* successful notification click redirection, the notification should be optionally dismissed based on configuration
**Validates: Requirements 4.5**

Property 21: Device-specific battery display
*For any* system running on the Doraemon device, the battery monitoring component should be visible and functional
**Validates: Requirements 5.1**

Property 22: Non-portable device battery hiding
*For any* system running on Nobita or other non-portable devices, the battery monitoring component should remain hidden
**Validates: Requirements 5.2**

Property 23: Battery update responsiveness
*For any* battery level change, the display should update within 30 seconds of the change
**Validates: Requirements 5.3**

Property 24: Warning color threshold
*For any* battery level below 20%, the display should use Catppuccin Macchiato warning colors
**Validates: Requirements 5.4**

Property 25: Critical color threshold
*For any* battery level below 10%, the display should use Catppuccin Macchiato critical colors
**Validates: Requirements 5.5**

## Error Handling

### Cache System Error Handling
- **Corrupted Cache Files**: Automatic regeneration through fresh detection
- **Permission Issues**: Fallback to read-only mode with user notification
- **Disk Space Issues**: Cache cleanup with retention of essential data
- **JSON Parse Errors**: Cache invalidation and regeneration

### Notification System Error Handling
- **Filter Configuration Errors**: Fallback to default allow-all behavior
- **Color Configuration Errors**: Use system default Catppuccin Macchiato colors
- **Click Redirect Failures**: Display user-friendly error messages with retry options
- **Application Launch Failures**: Provide alternative action suggestions

### Battery System Error Handling
- **Device Detection Failures**: Graceful degradation with manual override option
- **Battery Information Unavailable**: Display appropriate status message
- **Update Failures**: Retry mechanism with exponential backoff

### Git Integration Error Handling
- **File Tracking Issues**: Automatic git add for new configuration files
- **Path Resolution Errors**: Fallback to absolute paths with warnings
- **Permission Conflicts**: User notification with resolution suggestions

## Testing Strategy

### Unit Testing Approach
The testing strategy employs Jest for JavaScript/QML testing with the following focus areas:

**Unit Tests Coverage:**
- Individual component functionality (cache operations, filter logic, color mapping)
- Configuration file parsing and validation
- Device detection accuracy
- Error handling scenarios
- Integration points between components

**Key Unit Test Categories:**
- Configuration file I/O operations
- Device-specific feature toggling
- Color scheme application and validation
- Notification processing pipeline
- Cache expiration and refresh logic

### Property-Based Testing Approach
Property-based testing will be implemented using fast-check for JavaScript, configured to run a minimum of 100 iterations per property test.

**Property Test Requirements:**
- Each correctness property must be implemented by a single property-based test
- All property tests must be tagged with comments referencing the design document property
- Tag format: **Feature: quickshell-enhancements, Property {number}: {property_text}**
- Generators must create realistic test data within valid input domains
- Tests must verify universal properties across all valid inputs

**Property Test Categories:**
- Cache consistency across different disk configurations
- Filter behavior across various notification patterns
- Color assignment consistency across application types
- Click redirect behavior across different application states
- Battery display behavior across different device configurations

**Test Data Generation Strategy:**
- Smart generators that constrain input space to realistic scenarios
- Device configuration generators for Doraemon/Nobita testing
- Notification generators with varied application names and content
- Battery level generators with realistic charge patterns
- Configuration file generators with valid JSON structures

The dual testing approach ensures comprehensive coverage: unit tests catch specific bugs and edge cases, while property tests verify general correctness across the entire input space.