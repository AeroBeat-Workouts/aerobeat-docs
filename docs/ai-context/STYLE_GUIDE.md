# AeroBeat GDScript Style Guide

## 1. Syntax Rules
* **Typed Variables:** ALWAYS use explicit types.
  * ❌ `var health = 100`
  * ✅ `var health: int = 100`
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