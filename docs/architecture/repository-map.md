# 🗺️ Repository Map (The Rigs)

Use this map to route work to the correct repository within the `~/aerobeat/` parent directory.

## Core contract repos

These six repos are the canonical lane owners for shared contracts and dependency-light base types.

* **[`aerobeat-input-core`](https://github.com/AeroBeat-Workouts/aerobeat-input-core)**: Shared input abstractions, provider contracts, normalized input-facing enums, and input runtime interfaces.
* **[`aerobeat-feature-core`](https://github.com/AeroBeat-Workouts/aerobeat-feature-core)**: Shared gameplay-mode and runtime-rule contracts that interpret athlete actions against authored content over time.
* **[`aerobeat-content-core`](https://github.com/AeroBeat-Workouts/aerobeat-content-core)**: Canonical authored-content contracts, including `Song`, `Routine`, `Chart Variant`, `Workout`, shared chart-envelope types, and content loading / validation interfaces.
* **[`aerobeat-asset-core`](https://github.com/AeroBeat-Workouts/aerobeat-asset-core)**: Shared asset-side contracts such as avatars, cosmetics, environments, and other reusable asset definitions.
* **[`aerobeat-ui-core`](https://github.com/AeroBeat-Workouts/aerobeat-ui-core)**: Shared UI abstractions, signals, enums, and base types used across UI kits and shells.
* **[`aerobeat-tool-core`](https://github.com/AeroBeat-Workouts/aerobeat-tool-core)**: Shared tool-side contracts for settings, backend/API integration, validation, and other common tooling models.

## Product and implementation repos

* **`aerobeat-assembly-community`**: Community assembly repo. Composes only the core repos and concrete packages it needs through GodotEnv.
* **`aerobeat-asset-prototypes`**: Prototyping assets used during development of AeroBeat.
* **`aerobeat-docs`**: Public design and technical documentation in `mkdocs` format. Also contains shared template source files for new AeroBeat repositories.
* **`aerobeat-feature-boxing`**: Boxing gameplay implementation built on `aerobeat-feature-core` and the content contracts it consumes.
* **`aerobeat-feature-dance`**: Dance gameplay implementation built on `aerobeat-feature-core` and the content contracts it consumes.
* **`aerobeat-feature-flow`**: Flow gameplay implementation built on `aerobeat-feature-core` and the content contracts it consumes.
* **`aerobeat-feature-step`**: Step gameplay implementation built on `aerobeat-feature-core` and the content contracts it consumes.
* **`aerobeat-input-gamepad`**: General controller support for AeroBeat via Godot's built-in controller detection.
* **`aerobeat-input-joycon-hid`**: Dedicated Bluetooth driver for Switch controllers in AeroBeat. Uses gestures to simulate athlete actions.
* **`aerobeat-input-keyboard`**: Generic keyboard support for AeroBeat via Godot's built-in keyboard input management.
* **`aerobeat-input-mediapipe-native`**: Input system for CV-based controls in AeroBeat via a standard webcam. Runs MediaPipe via native API calls on mobile operating systems.
* **`aerobeat-input-mediapipe-python`**: Input system for CV-based controls in AeroBeat via a standard webcam. Runs MediaPipe via Python and passes the data via UDP 3.0.
* **`aerobeat-input-mouse`**: Maps mouse inputs to AeroBeat actions using Godot's built-in mouse management.
* **`aerobeat-input-touch`**: Maps touch inputs to AeroBeat actions using Godot's built-in touch management.
* **`aerobeat-input-xr`**: XR input management layer for the AeroBeat platform.
* **`aerobeat-tool-api`**: Backend API client built on `aerobeat-tool-core` contracts.
* **`aerobeat-tool-settings`**: User preferences and persistence management built on `aerobeat-tool-core` contracts.
* **`aerobeat-ui-kit-community`**: AeroBeat's default UI visual components used by the Community Edition.
* **`aerobeat-ui-shell-desktop-community`**: AeroBeat's Community Edition desktop UI. Uses `aerobeat-ui-kit-community`.
* **`aerobeat-ui-shell-mobile-community`**: AeroBeat's Community Edition mobile UI. Uses `aerobeat-ui-kit-community`.
* **`aerobeat-ui-shell-web-community`**: AeroBeat's Community Edition web UI. Uses `aerobeat-ui-kit-community`.
* **`aerobeat-ui-shell-xr-community`**: AeroBeat's Community Edition XR UI for 6DOF world-space 3D environments. Uses `aerobeat-ui-kit-community`.

## Ownership rule

AeroBeat no longer treats `aerobeat-core` as the long-term universal hub. The platform is documented as a lane-based architecture with one core repo per domain. Concrete repos depend on the core repos for their lane and on any adjacent lane contracts they consume, especially `aerobeat-content-core` for authored playable content and `aerobeat-asset-core` for reusable asset definitions.
