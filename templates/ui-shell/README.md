# AeroBeat UI Shell

This is an **Interaction Shell** for the AeroBeat platform.

*   **License:** GPLv3
*   **Role:** Defines the layout and flow of the application (Mobile, VR, Arcade).
*   **Dependencies:** `aerobeat-core` (Contracts), `aerobeat-ui-kit-*` (Visuals).

## Setup

1.  **Initialize Core:**
    Clones the engine contracts required for the shell to compile.
    ```bash
    python setup_dev.py
    ```

2.  **Sync UI Kit:**
    Pulls the specific version of the UI Kit defined in this shell's configuration.
    ```bash
    python sync_ui_kit.py
    ```
