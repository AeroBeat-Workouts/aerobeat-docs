# AI Manifest & File Topology

## Global Rules
1. **Prefixes:** All core classes must start with `Aero` (e.g., `AeroSessionContext`).
2. **Extensions:** Use `.gd` for logic, `.tscn` for scenes, `.tres` for data.
3. **Strict Typing:** All GDScript must be static typed (e.g., `func get_name() -> String:`).

## Architecture Constraints (Strict)
1. **Dependency Flow:** `Assembly` -> `Feature` -> `Core`. Dependencies must flow DOWN.
2. **UI Isolation:** `Feature` logic must NEVER depend on `UI` classes. Use Signals to communicate state changes.
3. **Tool Isolation:** `aerobeat-tool-*` (Services) must NEVER depend on `aerobeat-feature-*` (Gameplay).
4. **Headless Safety:** Logic scripts in `aerobeat-feature-*` must NOT access `AudioStreamPlayer` or `VisualInstance3D` directly. Use Signals.

## Directory Map
* `aerobeat-core/`
  * `contracts/`: Interfaces only. No game logic.
  * `data_types/`: `Resource` definitions only.
  * `globals/`: Singletons (SignalBus).
* `aerobeat-ui-core/`
  * `scripts/`: Base logic classes (`AeroButtonBase`). No scenes.
* `aerobeat-tool-*/`
  * `src/`: Service logic and Autoloads the Singleton manager(ex: `AeroToolManager`).
  * `.testbed/`: Isolated testing scenes.
* `aerobeat-ui-kit-*/`
  * `atoms/`: Themed components inheriting Core logic.
  * `molecules/`: Composite components.
* `aerobeat-ui-shell-*/`
  * `screens/`: Full page layouts (MainMenu, HUD).
* `aerobeat-feature-*/`
  * `scripts/`: Implementation logic.
  * `.testbed/`: Isolated testing scenes (Ignore in production builds).
* `aerobeat-skins-*/`
  * `assets/`: Gloves, Targets, Obstacles.
  * `.testbed/`: Visualization scene.
* `aerobeat-avatars-*/`
  * `assets/`: Character meshes.
* `aerobeat-cosmetics-*/`
  * `assets/`: Accessories (Hats, Glasses).
* `aerobeat-environments-*/`
  * `assets/`: Level geometry and lightmaps.
* `aerobeat-asset-*/`
  * `assets/`: Internal system files (UI, Fonts).