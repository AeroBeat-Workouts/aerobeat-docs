
# 🗺️ Repository Map (The Rigs)

Use this map to route tasks to the correct Repository/Rig within the `~/aerobeat/` parent/town directory.

*   **`aerobeat-assembly-community`**: Combines multiple dependencies to build the AeroBeat Community executable for the Client or Server
*   **`aerobeat-asset-prototypes`**: Prototyping assets used during development of AeroBeat.
*   **`aerobeat-core`**: The 'Hub' of the AeroBeat project. Stores Interfaces, Enums, Constants, and Utils.
*   **`aerobeat-docs`**: Public design and technical documentation in `mkdocs` format. Also contains all AI-Orchestration logic.
*   **`aerobeat-feature-boxing`**: Gameplay feature code for `Boxing`.
*   **`aerobeat-feature-dance`**: Gameplay feature code for `Dance`.
*   **`aerobeat-feature-flow`**: Gameplay feature code for `Flow`.
*   **`aerobeat-feature-step`**: Gameplay feature code for `Step`.
*   **`aerobeat-input-gamepad`**: General controller support for AeroBeat via Godot's built in controller detection.
*   **`aerobeat-input-joycon-hid`**: The dedicated Bluetooth driver for switch controllers in AeroBeat. Uses gestures to simulate athletes actions.
*   **`aerobeat-input-keyboard`**: Generic keyboard support for AeroBeat via Godot's built in keyboard input management.
*   **`aerobeat-input-mediapipe-native`**: Input system for CV based controls in AeroBeat via a standard webcam. Runs a MediaPipe instance via native API calls on mobile operating systems.
*   **`aerobeat-input-mediapipe-python`**: Input system for CV based controls in AeroBeat via a standard webcam. Runs a MediaPipe instance via Python and passes the data via UDP 3.0.
*   **`aerobeat-input-mouse`**: Maps mouse inputs to AeroBeat actions using Godot's built in mouse management.
*   **`aerobeat-input-touch`**: Maps touch inputs to AeroBeat actions using Godot's built in touch management.
*   **`aerobeat-input-xr`**: XR input management layer for the AeroBeat platform.
*   **`aerobeat-tool-api`**: Backend API Client to connect with the AeroBeat servers.
*   **`aerobeat-tool-settings`**: User Preferences & Persistence management within the AeroBeat platform.
*   **`aerobeat-ui-core`**: Interfaces, variables, enums, and signals used across our UI-Kits and UI-Shells
*   **`aerobeat-ui-kit-community`**: AeroBeat's default user interface visual components used by the Community Edition versions
*   **`aerobeat-ui-shell-desktop-community`**: AeroBeat's Community Edition user interface for desktop (large screen) environments. Uses the 'aerobeat-ui-kit-community'
*   **`aerobeat-ui-shell-mobile-community`**: AeroBeat's Community Edition user interface for mobile (small screen) environments. Uses the 'aerobeat-ui-kit-community'
*   **`aerobeat-ui-shell-web-community`**: AeroBeat's Community Edition user interface for web environments. Uses the 'aerobeat-ui-kit-community'
*   **`aerobeat-ui-shell-xr-community`**: AeroBeat's Community Edition user interface for XR (6DOF world-space 3D) environments. Uses the 'aerobeat-ui-kit-community'