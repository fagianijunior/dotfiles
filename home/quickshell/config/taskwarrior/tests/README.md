# Taskwarrior Quickshell Panel - Test Framework

## Overview

This directory contains tests for the Taskwarrior Quickshell Panel components.

## Test Types

### Unit Tests
- Test specific examples and edge cases
- Located in `unit/` directory
- File naming: `<Component>Test.qml`

### Property-Based Tests
- Test universal properties across randomized inputs
- Located in `property/` directory
- File naming: `<Component>PropertyTest.qml`
- Minimum 100 iterations per property test

## Testing Framework

**Framework**: QML TestCase with JavaScript property testing library

**Configuration**:
- Each test tagged with feature name and property number
- Tag format: `Feature: taskwarrior-quickshell-panel, Property {N}: {property_text}`

## Running Tests

Tests will be implemented in subsequent tasks. The test runner will be configured to:
1. Execute all unit tests
2. Execute all property-based tests
3. Report results with proper tagging

## Test Structure

```
tests/
├── README.md                 # This file
├── unit/                     # Unit tests
│   ├── TaskManagerTest.qml
│   ├── DataWatcherTest.qml
│   └── ...
├── property/                 # Property-based tests
│   ├── TaskGroupingProperty.qml
│   ├── CardCountProperty.qml
│   └── ...
└── helpers/                  # Test utilities
    ├── TaskGenerator.qml     # Generate random test data
    └── TestHelpers.qml       # Common test utilities
```

## Test Coverage Goals

- TaskManager.qml: JSON parsing, task grouping, command execution
- DataWatcher.qml: File watching, polling, change detection
- TaskPanel.qml: Card display, loading states
- TaskCard.qml: Expansion behavior, task count display
- TaskItem.qml: Status updates, metadata display

## Property Tests (from Design Document)

1. Task Grouping by Client Attribute (Req 1.1, 1.3)
2. Card Count Matches Distinct Clients (Req 1.2, 1.4)
3. Task Count Accuracy (Req 2.3)
4. Client Name Display (Req 2.2)
5. Single Card Expansion (Req 3.1, 3.2)
6. Expanded Card Shows All Tasks (Req 3.3)
7. Status Button Presence (Req 4.1)
8. Status Update Command Uses UUID (Req 4.4)
9. Terminal Launch Uses UUID (Req 5.2)
10. JSON Parsing Round-Trip (Req 6.2, 6.3)
11. Data Change Triggers Reload (Req 7.2)
12. UI Updates After Data Reload (Req 7.3)
13. Metadata Display Completeness (Req 9.1, 9.2, 9.3)
14. Non-Blocking Execution (Req 5.3, 10.1, 10.2, 10.3)
15. Error Handling Without Blocking (Req 10.4)
