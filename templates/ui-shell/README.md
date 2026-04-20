# AeroBeat UI Shell

This is an **Interaction Shell** for the AeroBeat platform.

*   **License:** GPLv3
*   **Role:** Defines the layout and flow of the application (Mobile, VR, Arcade).
*   **Dependencies:** `aerobeat-ui-core` (Required logic), `aerobeat-ui-kit-*` (Required visuals), with `aerobeat-asset-core` and `aerobeat-tool-core` only when the shell consumes those contracts.

## Setup

1.  **Initialize the local testbed:**
    Clones the required UI-layer contracts for the shell to compile.
    ```bash
    python setup_dev.py
    ```

2.  **Sync UI Kit:**
    Pulls the specific version of the UI Kit defined in this shell's configuration.
    ```bash
    python sync_ui_kit.py
    ```

## 📂 Structure

*   `.testbed/tests/` - Repo-local unit tests run by the hidden testbed.
*   `.testbed/scenes/` - Optional manual/workbench scenes when the shell needs them.
*   `.testbed/` - The local-only Godot workbench used to run/debug the shell.
