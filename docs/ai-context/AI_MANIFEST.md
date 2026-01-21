# AI Manifest & File Topology

## Global Rules
1. **Prefixes:** All core classes must start with `Aero` (e.g., `AeroSessionContext`).
2. **Extensions:** Use `.gd` for logic, `.tscn` for scenes, `.tres` for data.
3. **Strict Typing:** All GDScript must be static typed (e.g., `func get_name() -> String:`).

## Directory Map
* `aerobeat-core/`
  * `contracts/`: Interfaces only. No game logic.
  * `data_types/`: `Resource` definitions only.
  * `globals/`: Singletons (SignalBus).
* `aerobeat-ui-core/`
  * `scripts/`: Base logic classes (`AeroButtonBase`). No scenes.
* `aerobeat-ui-kit-*/`
  * `atoms/`: Themed components inheriting Core logic.
  * `molecules/`: Composite components.
* `aerobeat-ui-shell-*/`
  * `screens/`: Full page layouts (MainMenu, HUD).
* `aerobeat-feature-*/`
  * `scripts/`: Implementation logic.
  * `.testbed/`: Isolated testing scenes (Ignore in production builds).