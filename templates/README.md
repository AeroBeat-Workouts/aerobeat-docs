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

Go to the AeroBeat-Fitness GitHub organization and look for repositories named `aerobeat-template-*`. Click the green **"Use this template"** button to start a new project.

## Template Types

| Type | Folder | License | Key Files |
| :--- | :--- | :--- | :--- |
| **Assembly** | `assembly/` | GPLv3 | `setup_dev.py` |
| **Feature** | `feature/` | GPLv3 | `.testbed/`, `setup_dev.py` |
| **Input** | `input/` | MPL 2.0 | `setup_dev.py` |
| **UI Kit** | `ui-kit/` | MPL 2.0 | `setup_dev.py` |
| **UI Shell** | `ui-shell/` | GPLv3 | `sync_ui_kit.py`, `setup_dev.py` |
| **Asset** | `asset/` | CC BY-NC 4.0 | `setup_dev.py`, `LICENSE` |

> **Note:** All templates include the `.github/workflows/cla.yml` workflow automatically.