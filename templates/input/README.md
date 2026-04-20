# AeroBeat Input Driver Template

This is the official template for creating an **Input Driver** repository within the AeroBeat ecosystem.

Input Drivers bridge hardware (Webcams, VR Controllers, Smart Watches) to the AeroBeat input contracts.

## 📋 Repository Details

*   **Type:** Input Driver
*   **License:** **Mozilla Public License 2.0 (MPL 2.0)**
*   **Dependencies:**
    *   `aerobeat-input-core` (Required)
    *   `aerobeat-vendor-*` (Allowed)

## 🚀 Getting Started

1.  **Clone your new repo:**
    ```bash
    git clone https://github.com/YourOrg/aerobeat-input-custom.git
    ```
2.  **Run Setup:**
    Initialize the testbed environment.
    ```bash
    python setup_dev.py
    ```
3.  **Open in Godot:**
    Import the `project.godot` file located inside the `.testbed/` folder into **Godot 4.6.2 stable standard**.

## 🧪 Testing

This template comes pre-configured with **GUT (Godot Unit Test)** workflows.

*   **Local Testing:** Run tests via the "GUT" panel in the Godot Editor (inside the Testbed).
*   **Requirement:** 100% Code Coverage is enforced.

## 📂 Structure

*   `src/` - The driver logic (GDScript).
*   `.testbed/tests/` - Repo-local unit tests run by the testbed.
*   `.testbed/` - A local-only Godot project used to run/debug the driver.