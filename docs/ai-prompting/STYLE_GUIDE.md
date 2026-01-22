# AeroBeat GDScript Style Guide

## 1. Syntax Rules
* **Typed Variables:** ALWAYS use explicit types.
  * ❌ `var score = 0`
  * ✅ `var score: int = 0`
* **Private Methods:** Prefix internal functions with `_` (e.g., `func _calculate_score()`).
* **Inferred Types:** Use `:=` only for unambiguous types (Vector2, String).

## 2. Architectural Patterns
* **Composition over Inheritance:** Use components (`Node` children) rather than deep `extends` chains.
* **Signal Up, Call Down:** * Children emit Signals to talk to Parents.
  * Parents call Functions to talk to Children.
  * **NEVER** let a Child node access `get_parent()`.

## 3. AeroBeat Specifics
* **Input:** NEVER use `Input.is_action_pressed()`. ALWAYS use `AeroInputProvider`.
* **Time:** NEVER use `delta` for rhythm sync. ALWAYS use `AudioServer.get_dsp_time()`.

## 4. File Structure & Organization
To maintain consistency, we enforce a strict file layout using Godot 4's `#region` support.

### Order of Operations
1.  **Docstring:** `##` Description of the class.
2.  **Class Definition:** `class_name` then `extends`.
3.  **Regions:** Organize code in the following order:
    *   `#region SIGNALS`
    *   `#region ENUMS & CONSTANTS`
    *   `#region EXPORTS` (Inspector variables)
    *   `#region PUBLIC VARIABLES`
    *   `#region PRIVATE VARIABLES` (`_` prefix)
    *   `#region ONREADY`
    *   `#region LIFECYCLE` (`_init`, `_enter_tree`, `_ready`, `_process`)
    *   `#region PUBLIC API`
    *   `#region PRIVATE API` (`_` prefix)

## 5. Documentation & Formatting
*   **Docstrings:** Use `##` for all classes and public functions. The Godot editor automatically parses these to create rich tooltips when you hover over your code, similar to IntelliSense in other IDEs.
*   **Separators:** Use `# ---------------------------------------------` to separate major logic blocks if Regions are not enough.
*   **Spacing:** Two empty lines between functions.

## 6. External Documentation

We use automated tools to generate the API Reference on the website from these docstrings.

*   **Tool:** `gdscript-docs-maker` (or similar).
*   **Requirement:** Every `public` function and variable MUST have a `##` docstring to appear in the online documentation.
*   **Private Members:** Functions starting with `_` are automatically excluded from the web docs.

### Example Template

```gdscript
## A brief description of what this class does.
##
## Detailed description of behavior.
class_name AeroExample
extends Node

#region SIGNALS
signal state_changed(new_state: int)
#endregion

#region ENUMS & CONSTANTS
enum State { IDLE, ACTIVE }
const MAX_SPEED: float = 100.0
#endregion

#region EXPORTS
@export var initial_score: int = 0
#endregion

#region PRIVATE VARIABLES
var _internal_state: State = State.IDLE
#endregion

#region LIFECYCLE
func _ready() -> void:
    pass
#endregion

#region PUBLIC API
## Returns the calculated damage based on speed.
func apply_damage(amount: int) -> void:
    pass
#endregion
```