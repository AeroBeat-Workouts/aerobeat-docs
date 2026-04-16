# 🗺️ Repository Map (The Rigs)

Use this map to route work to the correct repository within the `~/aerobeat/` parent directory.

* **`aerobeat-assembly-community`**: Combines multiple dependencies to build the AeroBeat Community executable for the client or server.
* **`aerobeat-asset-prototypes`**: Prototyping assets used during development of AeroBeat.
* **`aerobeat-core`**: The hub of the AeroBeat project. Stores interfaces, enums, constants, and utilities.
* **`aerobeat-docs`**: Public design and technical documentation in `mkdocs` format. Also contains shared template source files for new AeroBeat repositories.
* **`aerobeat-feature-boxing`**: Gameplay feature code for `Boxing`.
* **`aerobeat-feature-dance`**: Gameplay feature code for `Dance`.
* **`aerobeat-feature-flow`**: Gameplay feature code for `Flow`.
* **`aerobeat-feature-step`**: Gameplay feature code for `Step`.
* **`aerobeat-input-gamepad`**: General controller support for AeroBeat via Godot's built-in controller detection.
* **`aerobeat-input-joycon-hid`**: The dedicated Bluetooth driver for Switch controllers in AeroBeat. Uses gestures to simulate athlete actions.
* **`aerobeat-input-keyboard`**: Generic keyboard support for AeroBeat via Godot's built-in keyboard input management.
* **`aerobeat-input-mediapipe-native`**: Input system for CV-based controls in AeroBeat via a standard webcam. Runs a MediaPipe instance via native API calls on mobile operating systems.
* **`aerobeat-input-mediapipe-python`**: Input system for CV-based controls in AeroBeat via a standard webcam. Runs a MediaPipe instance via Python and passes the data via UDP 3.0.
* **`aerobeat-input-mouse`**: Maps mouse inputs to AeroBeat actions using Godot's built-in mouse management.
* **`aerobeat-input-touch`**: Maps touch inputs to AeroBeat actions using Godot's built-in touch management.
* **`aerobeat-input-xr`**: XR input management layer for the AeroBeat platform.
* **`aerobeat-tool-api`**: Backend API client to connect with the AeroBeat servers.
* **`aerobeat-tool-settings`**: User preferences and persistence management within the AeroBeat platform.
* **`aerobeat-ui-core`**: Interfaces, variables, enums, and signals used across UI kits and UI shells.
* **`aerobeat-ui-kit-community`**: AeroBeat's default UI visual components used by the Community Edition.
* **`aerobeat-ui-shell-desktop-community`**: AeroBeat's Community Edition desktop UI. Uses `aerobeat-ui-kit-community`.
* **`aerobeat-ui-shell-mobile-community`**: AeroBeat's Community Edition mobile UI. Uses `aerobeat-ui-kit-community`.
* **`aerobeat-ui-shell-web-community`**: AeroBeat's Community Edition web UI. Uses `aerobeat-ui-kit-community`.
* **`aerobeat-ui-shell-xr-community`**: AeroBeat's Community Edition XR UI for 6DOF world-space 3D environments. Uses `aerobeat-ui-kit-community`.
