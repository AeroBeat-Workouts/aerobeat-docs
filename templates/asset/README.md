# AeroBeat Internal Asset Template

This is the official template for creating an **Internal Asset** repository within the AeroBeat ecosystem.

**Internal Assets** contain system-critical content: UI Icons, Default Fonts, Mock Data, and Fallback Meshes. These are **NOT** for User Generated Content (UGC).

## 📋 Repository Details

*   **Type:** Internal Asset (System)
*   **License:** **CC BY-NC 4.0** (Attribution-NonCommercial)
*   **Constraints:**
    *   **Internal Use Only:** These assets are required by the Assembly or UI Shells and are not swappable via the Modding API.
    *   **Scripts Allowed:** Unlike UGC, internal asset repos **MAY** contain helper scripts (`.gd`) or shaders (`.gdshader`) for visual polish.

## 🚀 Getting Started

1.  **Clone your new repo:**
    ```bash
    git clone https://github.com/YourOrg/aerobeat-asset-custom.git
    ```
2.  **Run Setup:**
    Initialize the environment (Downloads Core contracts so you can edit Resources).
    ```bash
    python setup_dev.py
    ```
3.  **Add Content:**
    Place your system files into the `assets/` directory.
4.  **Import:**
    This repository is intended to be used as a submodule or direct download into an `aerobeat-assembly-*` project.

## 📂 Structure

*   `assets/` - The root folder for all content.
    *   `ui/` - Icons and Themes.
    *   `fonts/` - TTF/OTF files.
    *   `mock/` - JSON/Resource data for testing.
    *   `prototypes/` - Greybox meshes.
*   `LICENSE` - The CC BY-NC 4.0 legal text.

## 📝 Licensing & Commercial Use

*   **Non-Commercial:** You are free to use, remix, and share these assets for non-commercial projects.
*   **Commercial:** You **CANNOT** use these assets in a commercial product (sold on Steam, App Store, etc.) without replacing them or obtaining a specific license from the original creator.