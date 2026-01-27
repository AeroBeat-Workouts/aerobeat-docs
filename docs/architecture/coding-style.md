# Coding Style Guide

This guide contains rules for .gdscript files in AeroBeat.

### Syntax Rules

1.  **Typed Variables:** ALWAYS use explicit types.
    *   ❌ `var score = 0`
    *   ✅ `var score: int = 0`
2.  **Private Methods:** Prefix internal functions with `_`.
    *   ✅ `func _calculate_score() -> void:`
3.  **Inferred Types:** Use `:=` only for unambiguous types (Vector2, String).

### Architectural Patterns

1.  **Composition over Inheritance:** Use components (`Node` children) rather than deep `extends` chains.
2.  **Signal Up, Call Down:**
    *   Children emit **Signals** to talk to Parents.
    *   Parents call **Functions** to talk to Children.
    *   **NEVER** let a Child node access `get_parent()`.

### AeroBeat Specifics

1.  **Input:** NEVER use `Input.is_action_pressed()`. ALWAYS use `AeroInputProvider`.
2.  **Time:** NEVER use `delta` for rhythm sync. ALWAYS use `AudioServer.get_dsp_time()`.

### File Structure & Organization

1.  **Docstring:** `##` Description of the class.
2.  **Class Definition:** `class_name` then `extends`.
3.  **Regions:** Organize code in this order using `#region`:
    1.  `SIGNALS`
    2.  `ENUMS & CONSTANTS`
    3.  `EXPORTS`
    4.  `PUBLIC VARIABLES`
    5.  `PRIVATE VARIABLES` (`_`)
    6.  `ONREADY`
    7.  `LIFECYCLE` (`_ready`, `_process`)
    8.  `PUBLIC API`
    9.  `PRIVATE API` (`_`)

### Documentation & Formatting

1.  **Docstrings:** Use `##` for all classes and public functions (required for auto-docs).
2.  **Separators:** Use `# ---------------------------------------------` for major blocks.
3.  **Spacing:** Two empty lines between functions.

### Godot Syntax Rules

1. **Prefixes:** All core classes must start with `Aero` (e.g., `AeroSessionContext`).
2. **Extensions:** Use `.gd` for logic, `.tscn` for scenes, `.tres` for data.
3. **Strict Typing:** All GDScript must be static typed (e.g., `func get_name() -> String:`).
