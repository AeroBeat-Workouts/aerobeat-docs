# AeroBeat Repository Templates

This directory contains the starter files for new repositories in the AeroBeat ecosystem.

## Architecture

This folder is the **Source of Truth** for our GitHub Template Repositories. We do not edit the template repos directly; we edit them here and sync them.

### How to Update Templates

1.  **Edit:** Make changes to the files in the subfolders below (e.g., `assembly/setup_dev.py`).
2.  **Sync:** Run the sync script to push changes to the standalone repositories.
    ```powershell
    .\scripts\sync_templates.ps1
    ```

### How to Use (For Developers)

Go to the AeroBeat-Workouts GitHub organization and look for repositories named `aerobeat-template-*`. Click the green **"Use this template"** button to start a new project.

## Template Types

| Type | Folder | License | Project Location | Key Files |
| :--- | :--- | :--- | :--- | :--- |
| **Assembly** | `assembly/` | GPLv3 | **Root** | `project.godot`, `.gitignore`, `setup_dev.py` |
| **Feature** | `feature/` | GPLv3 | `.testbed/` | `plugin.cfg`, `.gitignore`, `.testbed/`, `setup_dev.py` |
| **Input** | `input/` | MPL 2.0 | `.testbed/` | `plugin.cfg`, `.gitignore`, `setup_dev.py` |
| **UI Kit** | `ui-kit/` | MPL 2.0 | `.testbed/` | `plugin.cfg`, `.gitignore`, `setup_dev.py` |
| **UI Shell** | `ui-shell/` | GPLv3 | `.testbed/` | `plugin.cfg`, `.gitignore`, `sync_ui_kit.py`, `setup_dev.py` |
| **Skins** | `skins/` | CC BY-NC 4.0 | `.testbed/` | `plugin.cfg`, `setup_dev.py`, `AeroSkin.gd` |
| **Avatars** | `avatars/` | CC BY-NC 4.0 | `.testbed/` | `plugin.cfg`, `setup_dev.py`, `AeroAvatar.gd` |
| **Cosmetics** | `cosmetics/` | CC BY-NC 4.0 | `.testbed/` | `plugin.cfg`, `setup_dev.py`, `AeroAccessory.gd` |
| **Environments** | `environments/` | CC BY-NC 4.0 | `.testbed/` | `plugin.cfg`, `setup_dev.py`, `AeroEnvironment.gd` |
| **Asset (Internal)** | `asset/` | CC BY-NC 4.0 | `.testbed/` | `plugin.cfg`, `.gitignore`, `setup_dev.py`, `LICENSE` |

> **Note:** All templates include the `.github/workflows/cla.yml` workflow automatically.