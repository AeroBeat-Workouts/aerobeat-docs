# AeroBeat Repository Templates

This directory contains the starter files for new repositories in the AeroBeat ecosystem.

## How to use

1.  **Create a new Repo:** Go to GitHub and create a new repository (e.g., `aerobeat-feature-dance`).
2.  **Choose Type:** Identify the architecture tier (Assembly, Feature, Input, etc.).
3.  **Copy Files:** Copy the contents of the corresponding folder in `templates/` to your new repo.
4.  **Initialize:** Run `git init`, commit, and push.

## Template Types

| Type | Folder | License | Key Files |
| :--- | :--- | :--- | :--- |
| **Assembly** | `assembly/` | GPLv3 | `setup_dev.py` |
| **Feature** | `feature/` | GPLv3 | `.testbed/`, `setup_dev.py` |
| **Input** | `input/` | MPL 2.0 | `setup_dev.py` |
| **UI Shell** | `ui/` | GPLv3 | `sync_ui_kit.py` |
| **Asset** | `asset/` | CC BY-NC 4.0 | `LICENSE` |

> **Note:** All templates include the `.github/workflows/cla.yml` workflow automatically.