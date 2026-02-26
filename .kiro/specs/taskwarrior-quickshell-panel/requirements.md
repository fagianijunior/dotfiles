# Requirements Document

## Introduction

This document specifies requirements for a Taskwarrior integration panel within Quickshell. The panel provides a productivity-focused visual interface for navigating and managing Taskwarrior tasks, organized by client context. The system maintains the CLI as the source of truth while offering quick visual navigation and status updates through the Quickshell interface.

## Glossary

- **Taskwarrior**: Command-line task management application that stores tasks in JSON format
- **Quickshell**: Desktop shell environment built with QML for Wayland compositors
- **Panel**: Visual component within Quickshell that displays task information
- **Client_Attribute**: Taskwarrior custom attribute used to categorize tasks by client name
- **Task_Card**: Visual container grouping all tasks for a specific client value
- **Compact_Mode**: Collapsed state of a Task_Card showing summary information only
- **Expanded_Mode**: Full state of a Task_Card displaying all associated tasks
- **Task_Export**: Taskwarrior JSON output from `task export` command
- **Task_UUID**: Unique identifier for a Taskwarrior task (preferred over numeric ID)
- **Data_Layer**: Component responsible for reading and writing Taskwarrior data
- **Rendering_Layer**: Component responsible for displaying tasks in Quickshell UI
- **General_Card**: Fallback Task_Card containing tasks without a defined Client_Attribute

## Requirements

### Requirement 1: Task Organization by Client

**User Story:** As a user managing multiple client projects, I want tasks grouped by client attribute, so that I can focus on one client context at a time.

#### Acceptance Criteria

1. WHEN the Panel loads Task_Export data, THE Data_Layer SHALL group tasks by Client_Attribute value
2. FOR EACH distinct Client_Attribute value, THE Rendering_Layer SHALL create one Task_Card
3. WHEN a task has no Client_Attribute value, THE Data_Layer SHALL assign it to the General_Card group
4. THE Panel SHALL display all Task_Cards simultaneously in the interface

### Requirement 2: Compact Card Display

**User Story:** As a user seeking low visual noise, I want cards to start collapsed, so that I can see an overview without distraction.

#### Acceptance Criteria

1. WHEN the Panel initializes, THE Rendering_Layer SHALL display all Task_Cards in Compact_Mode
2. WHILE in Compact_Mode, THE Task_Card SHALL display the client name
3. WHILE in Compact_Mode, THE Task_Card SHALL display the count of associated tasks
4. WHILE in Compact_Mode, THE Task_Card MAY display a visual indicator of pending priority tasks

### Requirement 3: Single Card Expansion

**User Story:** As a user reviewing tasks, I want to expand one card at a time, so that I maintain focus on a single client context.

#### Acceptance Criteria

1. WHEN a user clicks a Task_Card in Compact_Mode, THE Rendering_Layer SHALL transition that Task_Card to Expanded_Mode
2. WHEN a Task_Card transitions to Expanded_Mode, THE Rendering_Layer SHALL transition all other Task_Cards to Compact_Mode
3. WHILE in Expanded_Mode, THE Task_Card SHALL display the full list of associated tasks
4. THE Rendering_Layer SHALL apply smooth visual transitions between Compact_Mode and Expanded_Mode

### Requirement 4: Task Status Updates

**User Story:** As a user completing tasks, I want to change task status with one click, so that I can quickly mark work as done.

#### Acceptance Criteria

1. WHILE a Task_Card is in Expanded_Mode, THE Rendering_Layer SHALL display a status change button for each task
2. WHEN a user clicks a status change button, THE Rendering_Layer SHALL immediately update the visual state
3. WHEN a user clicks a status change button, THE Data_Layer SHALL execute the corresponding Taskwarrior command
4. THE Data_Layer SHALL use Task_UUID for all task modification commands

### Requirement 5: Task Detail Navigation

**User Story:** As a user needing detailed task information, I want to open Taskwarrior CLI for a specific task, so that I can view or edit complete task data.

#### Acceptance Criteria

1. WHEN a user clicks a task display area (excluding the status button), THE Panel SHALL open a terminal interface
2. THE Panel SHALL execute a Taskwarrior command positioned at the selected task using Task_UUID
3. THE Panel SHALL use non-blocking terminal execution to prevent Quickshell freezing
4. WHERE the compositor is Hyprland, THE Panel MAY open the terminal as a floating window

### Requirement 6: JSON-Based Data Consumption

**User Story:** As a developer maintaining the integration, I want to parse structured JSON data, so that the implementation remains stable across Taskwarrior versions.

#### Acceptance Criteria

1. THE Data_Layer SHALL execute `task export` to retrieve task data
2. THE Data_Layer SHALL parse the JSON output from Task_Export
3. THE Data_Layer SHALL map Task_UUID to displayed task properties
4. THE Data_Layer SHALL NOT parse text-based Taskwarrior output formats

### Requirement 7: Automatic Data Refresh

**User Story:** As a user working with both CLI and GUI, I want the panel to reflect CLI changes automatically, so that I always see current task state.

#### Acceptance Criteria

1. THE Data_Layer SHALL implement a mechanism to detect Taskwarrior data changes
2. WHEN Taskwarrior data changes, THE Data_Layer SHALL reload Task_Export data
3. WHEN Task_Export data is reloaded, THE Rendering_Layer SHALL update the displayed tasks
4. THE Data_Layer MAY use file system watching on the Taskwarrior data directory
5. THE Data_Layer MAY use periodic polling with an interval between 5 and 10 seconds

### Requirement 8: Architecture Separation

**User Story:** As a developer maintaining the codebase, I want clear separation between data and rendering, so that each layer can evolve independently.

#### Acceptance Criteria

1. THE Data_Layer SHALL handle all Taskwarrior command execution and JSON parsing
2. THE Rendering_Layer SHALL handle all Quickshell UI component rendering
3. THE Data_Layer SHALL expose task data to the Rendering_Layer through a defined interface
4. THE Rendering_Layer SHALL NOT execute Taskwarrior commands directly

### Requirement 9: Task Metadata Display

**User Story:** As a user prioritizing work, I want to see key task metadata at a glance, so that I can make informed decisions about what to work on.

#### Acceptance Criteria

1. WHILE a Task_Card is in Expanded_Mode, THE Rendering_Layer SHALL display task priority if defined
2. WHILE a Task_Card is in Expanded_Mode, THE Rendering_Layer SHALL display task tags if defined
3. WHILE a Task_Card is in Expanded_Mode, THE Rendering_Layer SHALL display task due date if defined
4. THE Rendering_Layer SHALL use visual indicators for metadata rather than verbose text

### Requirement 10: Non-Blocking Terminal Operations

**User Story:** As a user interacting with the panel, I want terminal commands to execute without freezing the interface, so that I maintain a smooth workflow.

#### Acceptance Criteria

1. WHEN the Data_Layer executes a Taskwarrior command, THE execution SHALL be non-blocking
2. WHEN the Panel opens a terminal for task detail, THE terminal launch SHALL be non-blocking
3. THE Panel SHALL remain responsive during all Taskwarrior command execution
4. IF a Taskwarrior command fails, THEN THE Panel SHALL log the error without blocking the interface
