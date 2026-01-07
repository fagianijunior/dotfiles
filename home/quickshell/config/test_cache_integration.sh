#!/bin/bash

# Test script for disk cache integration
echo "=== Testing Disk Cache Integration ==="

# Check if cache directory exists
if [ -d "cache" ]; then
    echo "✓ Cache directory exists"
else
    echo "✗ Cache directory missing"
    exit 1
fi

# Check if DiskCacheManager.qml exists
if [ -f "cache/DiskCacheManager.qml" ]; then
    echo "✓ DiskCacheManager.qml exists"
else
    echo "✗ DiskCacheManager.qml missing"
    exit 1
fi

# Check if utils directory and components exist
if [ -f "utils/ConfigManager.qml" ] && [ -f "utils/DeviceDetector.qml" ]; then
    echo "✓ Required utility components exist"
else
    echo "✗ Missing utility components"
    exit 1
fi

# Test basic QML syntax (if quickshell is available)
if command -v quickshell &> /dev/null; then
    echo "Testing QML syntax with quickshell..."
    # This would require quickshell to be properly configured
    echo "Note: Full quickshell testing requires proper environment setup"
else
    echo "Note: quickshell not available for syntax testing"
fi

# Check if shell.qml has been modified to include cache
if grep -q "DiskCacheManager" shell.qml; then
    echo "✓ shell.qml has been integrated with cache system"
else
    echo "✗ shell.qml missing cache integration"
    exit 1
fi

# Test disk detection command (same as used in cache)
echo "Testing disk detection command..."
df -h | grep -E '^/dev/' | awk '{print $6 ":" $5}' | sed 's/%//' | sort > /tmp/disk_test.txt

if [ -s /tmp/disk_test.txt ]; then
    echo "✓ Disk detection command works"
    echo "Detected disks:"
    cat /tmp/disk_test.txt
    rm -f /tmp/disk_test.txt
else
    echo "✗ Disk detection command failed"
    exit 1
fi

echo "=== All tests passed! ==="