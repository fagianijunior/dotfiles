#!/bin/bash

echo "=== Running All Quickshell Enhancement Tests ==="
echo

# Array of property test files
PROPERTY_TESTS=(
    "test_cache_storage_properties.qml"
    "test_cache_loading_precedence.qml"
    "test_cache_expiration_behavior.qml"
    "test_cache_fallback_reliability.qml"
    "test_notification_filter_processing.qml"
    "test_block_list_enforcement.qml"
    "test_allow_list_priority.qml"
    "test_real_time_filter_updates.qml"
    "test_color_determination_consistency.qml"
    "test_configured_color_application.qml"
    "test_category_based_color_fallback.qml"
    "test_multi_notification_color_consistency.qml"
    "test_application_identification_accuracy.qml"
    "test_running_application_focus.qml"
    "test_device_detection_properties.qml"
    "test_battery_update_responsiveness.qml"
    "test_warning_color_threshold.qml"
    "test_critical_color_threshold.qml"
)

# Array of unit test files
UNIT_TESTS=(
    "test_configuration_file_handling.qml"
)

# Array of shell script tests
SHELL_TESTS=(
    "test_cache_integration.sh"
    "test_disk_detection.sh"
)

PASSED=0
FAILED=0

echo "Running Property-Based Tests..."
echo "================================"

for test in "${PROPERTY_TESTS[@]}"; do
    echo -n "Running $test... "
    if timeout 15s quickshell -p "$test" >/dev/null 2>&1; then
        echo "✅ PASSED"
        ((PASSED++))
    else
        echo "❌ FAILED"
        ((FAILED++))
    fi
done

echo
echo "Running Unit Tests..."
echo "===================="

for test in "${UNIT_TESTS[@]}"; do
    echo -n "Running $test... "
    if timeout 15s quickshell -p "$test" >/dev/null 2>&1; then
        echo "✅ PASSED"
        ((PASSED++))
    else
        echo "❌ FAILED"
        ((FAILED++))
    fi
done

echo
echo "Running Shell Script Tests..."
echo "============================="

for test in "${SHELL_TESTS[@]}"; do
    echo -n "Running $test... "
    if bash "$test" >/dev/null 2>&1; then
        echo "✅ PASSED"
        ((PASSED++))
    else
        echo "❌ FAILED"
        ((FAILED++))
    fi
done

echo
echo "Testing Main Shell Configuration..."
echo "=================================="
echo -n "Testing shell.qml... "
if timeout 5s quickshell -p shell.qml >/dev/null 2>&1; then
    echo "✅ PASSED"
    ((PASSED++))
else
    echo "❌ FAILED"
    ((FAILED++))
fi

echo
echo "=== Test Summary ==="
echo "Total tests: $((PASSED + FAILED))"
echo "Passed: $PASSED"
echo "Failed: $FAILED"

if [ $FAILED -eq 0 ]; then
    echo "🎉 All tests passed!"
    exit 0
else
    echo "⚠️  Some tests failed"
    exit 1
fi