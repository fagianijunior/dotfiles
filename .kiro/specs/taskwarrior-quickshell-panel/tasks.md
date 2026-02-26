# Implementation Plan: Taskwarrior Quickshell Panel

## Overview

This implementation plan breaks down the Taskwarrior Quickshell Panel into discrete coding tasks. The approach follows a bottom-up strategy: build the data layer first, then the rendering components, and finally integrate everything into the existing shell. Each task includes property-based tests to validate correctness properties from the design document.

## Tasks

- [x] 1. Set up project structure and data layer foundation
  - Create directory structure: `home/quickshell/config/taskwarrior/`
  - Create TaskManager.qml skeleton with properties and signals
  - Create DataWatcher.qml skeleton with file watching and polling support
  - Set up test framework for QML components
  - _Requirements: 6.1, 8.1, 8.3_

- [x] 2. Implement core data loading and parsing
  - [x] 2.1 Implement task export execution in TaskManager.qml
    - Add Process component for `task export` command
    - Add StdioCollector for stdout/stderr handling
    - Implement JSON parsing with error handling
    - Expose parsed tasks through properties
    - _Requirements: 6.1, 6.2, 10.1, 10.4_
  
  - [ ]* 2.2 Write property test for JSON parsing round-trip
    - **Property 10: JSON Parsing Round-Trip**
    - **Validates: Requirements 6.2, 6.3**
    - Generate random valid Taskwarrior JSON with varying fields
    - Verify UUID, description, status, client preserved after parsing
    - Run 100+ iterations with different task structures
  
  - [x] 2.3 Implement task grouping by client attribute
    - Add groupTasksByClient() function in TaskManager.qml
    - Populate tasksByClient and generalTasks properties
    - Filter to only include pending tasks
    - Emit tasksUpdated signal on completion
    - _Requirements: 1.1, 1.3_
  
  - [ ]* 2.4 Write property test for task grouping
    - **Property 1: Task Grouping by Client Attribute**
    - **Validates: Requirements 1.1, 1.3**
    - Generate random task arrays with varying client values
    - Verify all tasks with same client are grouped together
    - Verify tasks without client go to general group
    - Run 100+ iterations

- [x] 3. Implement data watching and refresh mechanism
  - [x] 3.1 Implement file system watcher in DataWatcher.qml
    - Add FileSystemWatcher for pending.data and completed.data
    - Connect file change signals to dataChanged signal
    - Implement fallback detection if watcher unavailable
    - _Requirements: 7.1, 7.4_
  
  - [x] 3.2 Implement polling fallback in DataWatcher.qml
    - Add Timer component with 7-second interval
    - Connect timer to dataChanged signal
    - Enable polling when file watcher unavailable
    - _Requirements: 7.1, 7.5_
  
  - [x] 3.3 Connect DataWatcher to TaskManager refresh
    - Wire dataChanged signal to refreshTasks() method
    - Implement refreshTasks() to trigger task export
    - _Requirements: 7.2, 7.3_
  
  - [ ]* 3.4 Write property test for data change triggers reload
    - **Property 11: Data Change Triggers Reload**
    - **Validates: Requirements 7.2**
    - Simulate file changes and verify reload triggered
    - Verify reload executes new task export command

- [x] 4. Checkpoint - Verify data layer functionality
  - Ensure all tests pass, ask the user if questions arise.

- [x] 5. Implement task modification commands
  - [x] 5.1 Implement updateTaskStatus() in TaskManager.qml
    - Add Process component for task modification commands
    - Use UUID-based commands (e.g., `task <uuid> done`)
    - Emit taskModified signal with success/failure status
    - Trigger refreshTasks() after successful modification
    - _Requirements: 4.3, 4.4, 10.1_
  
  - [ ]* 5.2 Write property test for status update command format
    - **Property 8: Status Update Command Uses UUID**
    - **Validates: Requirements 4.4**
    - Generate random task UUIDs
    - Verify generated commands include UUID (not numeric ID)
    - Verify command format matches Taskwarrior syntax
  
  - [x] 5.3 Implement error handling for task modifications
    - Capture stderr from modification commands
    - Emit errorOccurred signal on failure
    - Log errors to console without blocking UI
    - _Requirements: 10.4_

- [x] 6. Implement TaskCard component (rendering layer)
  - [x] 6.1 Create TaskCard.qml with compact/expanded states
    - Define Rectangle with clientName and tasks properties
    - Implement State definitions for compact and expanded modes
    - Add Transition with height animation
    - Add MouseArea for click handling
    - _Requirements: 2.1, 3.1, 3.4, 8.2_
  
  - [x] 6.2 Implement compact mode display
    - Display client name (or "General" for tasks without client)
    - Display task count badge
    - Add optional priority indicator for high-priority tasks
    - _Requirements: 2.2, 2.3, 2.4_
  
  - [ ]* 6.3 Write property test for client name display
    - **Property 4: Client Name Display**
    - **Validates: Requirements 2.2**
    - Generate random client names and general tasks
    - Verify displayed name matches client attribute or "General"
  
  - [ ]* 6.4 Write property test for task count accuracy
    - **Property 3: Task Count Accuracy**
    - **Validates: Requirements 2.3**
    - Generate random task groups with varying sizes
    - Verify displayed count equals actual task count
  
  - [x] 6.5 Implement expanded mode display
    - Add ListView for displaying tasks
    - Show/hide ListView based on isExpanded state
    - Adjust card height to fit task list
    - _Requirements: 3.3_
  
  - [ ]* 6.6 Write property test for expanded card shows all tasks
    - **Property 6: Expanded Card Shows All Tasks**
    - **Validates: Requirements 3.3**
    - Generate random task groups
    - Verify all tasks visible when card expanded

- [x] 7. Implement TaskItem component (individual task display)
  - [x] 7.1 Create TaskItem.qml with basic layout
    - Define Rectangle with task property
    - Add RowLayout with status button and description area
    - _Requirements: 8.2_
  
  - [x] 7.2 Implement status change button
    - Add Button with status icon display
    - Connect click handler to TaskManager.updateTaskStatus()
    - Implement optimistic UI update (immediate visual change)
    - _Requirements: 4.1, 4.2_
  
  - [ ]* 7.3 Write property test for status button presence
    - **Property 7: Status Button Presence**
    - **Validates: Requirements 4.1**
    - Generate random tasks
    - Verify status button rendered for each task
  
  - [x] 7.4 Implement task description and metadata display
    - Display task description with priority-based styling
    - Add ColumnLayout for metadata row
    - Display priority indicator (colored dot)
    - Display tags with # prefix
    - Display due date with overdue styling
    - _Requirements: 9.1, 9.2, 9.3, 9.4_
  
  - [ ]* 7.5 Write property test for metadata display completeness
    - **Property 13: Metadata Display Completeness**
    - **Validates: Requirements 9.1, 9.2, 9.3**
    - Generate tasks with varying metadata (priority, tags, due date)
    - Verify indicators present when metadata defined
  
  - [x] 7.6 Implement terminal launch for task detail navigation
    - Add MouseArea for task description area
    - Create Process component for terminal launch
    - Use UUID-based command (e.g., `kitty --class floating -e task <uuid> edit`)
    - Ensure non-blocking execution
    - _Requirements: 5.1, 5.2, 5.3, 5.4, 10.2_
  
  - [ ]* 7.7 Write property test for terminal launch uses UUID
    - **Property 9: Terminal Launch Uses UUID**
    - **Validates: Requirements 5.2**
    - Generate random task UUIDs
    - Verify terminal commands include UUID
    - Verify command format correct

- [x] 8. Implement TaskPanel component (main container)
  - [x] 8.1 Create TaskPanel.qml with header and task list
    - Add ColumnLayout with header section
    - Add ScrollView with ListView for task cards
    - Add status indicator for loading/error states
    - Add manual refresh button
    - _Requirements: 8.2_
  
  - [x] 8.2 Instantiate TaskManager and DataWatcher
    - Create TaskManager instance
    - Create DataWatcher instance
    - Configure data path to ~/.task directory
    - Connect signals between components
    - _Requirements: 8.3_
  
  - [x] 8.3 Build ListModel from tasksByClient
    - Convert tasksByClient map to ListModel
    - Include generalTasks as separate card
    - Update model when tasksUpdated signal emitted
    - _Requirements: 1.2, 1.4_
  
  - [ ]* 8.4 Write property test for card count matches distinct clients
    - **Property 2: Card Count Matches Distinct Clients**
    - **Validates: Requirements 1.2, 1.4**
    - Generate random task sets with varying client counts
    - Verify card count equals distinct clients + general (if present)
  
  - [x] 8.5 Implement single-focus card expansion logic
    - Track currently expanded card
    - Collapse other cards when one expands
    - Handle expansion state changes
    - _Requirements: 3.2_
  
  - [ ]* 8.6 Write property test for single card expansion
    - **Property 5: Single Card Expansion (Mutual Exclusion)**
    - **Validates: Requirements 3.1, 3.2**
    - Simulate multiple card expansion attempts
    - Verify at most one card expanded at any time
  
  - [x] 8.7 Implement loading and error state display
    - Show "Loading..." when isLoading is true
    - Display error messages from errorMessage property
    - Show task count when loaded successfully
    - _Requirements: 10.4_

- [x] 9. Checkpoint - Verify rendering layer functionality
  - Ensure all tests pass, ask the user if questions arise.

- [ ]* 10. Write property test for UI updates after data reload
  - **Property 12: UI Updates After Data Reload**
  - **Validates: Requirements 7.3**
  - Simulate data reload with changed task data
  - Verify UI reflects new data within one refresh cycle

- [ ]* 11. Write property test for non-blocking execution
  - **Property 14: Non-Blocking Execution**
  - **Validates: Requirements 5.3, 10.1, 10.2, 10.3**
  - Simulate command execution and terminal launches
  - Verify UI remains responsive (can process input events)
  - Test with mock delays to simulate slow operations

- [ ]* 12. Write property test for error handling without blocking
  - **Property 15: Error Handling Without Blocking**
  - **Validates: Requirements 10.4**
  - Simulate command failures
  - Verify errors logged/displayed without preventing interactions

- [x] 13. Integrate panel into existing shell.qml
  - [x] 13.1 Import TaskPanel into shell.qml
    - Add import statement for taskwarrior directory
    - Add TaskPanel instance to ColumnLayout
    - Configure Layout properties (fillWidth, preferredHeight)
    - Respect sensitiveData privacy mode
    - _Requirements: 8.2_
  
  - [x] 13.2 Apply Catppuccin Macchiato styling
    - Define color constants matching existing shell theme
    - Apply colors to TaskPanel, TaskCard, TaskItem components
    - Ensure visual consistency with existing shell elements
  
  - [x] 13.3 Test integration with existing shell
    - Verify panel loads on shell startup
    - Verify panel doesn't interfere with other shell components
    - Verify privacy mode hides panel correctly

- [x] 14. Implement terminal emulator detection and fallback
  - [x] 14.1 Add terminal detection logic
    - Check for kitty availability
    - Fall back to $TERMINAL environment variable
    - Fall back to common terminals (alacritty, wezterm, foot)
    - _Requirements: 5.3_
  
  - [x] 14.2 Implement Hyprland-specific floating window support
    - Detect Hyprland compositor
    - Use `--class floating` flag for kitty
    - _Requirements: 5.4_

- [x] 15. Final checkpoint and validation
  - Ensure all tests pass, ask the user if questions arise.

## Notes

- Tasks marked with `*` are optional property-based tests and can be skipped for faster MVP
- Each task references specific requirements for traceability
- Property tests validate universal correctness properties with 100+ iterations
- Checkpoints ensure incremental validation at key milestones
- Implementation follows bottom-up approach: data layer → rendering layer → integration
- All Taskwarrior commands use UUID (not numeric ID) for reliability
- All command executions are non-blocking to maintain UI responsiveness
