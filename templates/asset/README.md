# AeroBeat Asset Pack Template

This is the official template for creating an **Asset Pack** repository within the AeroBeat ecosystem.

**Asset Packs** contain the creative content for the game: 3D Models, Textures, Audio, and Level Data. They are strictly separated from code to allow for different licensing terms.

## 📋 Repository Details

*   **Type:** Asset Pack (Content)
*   **License:** **CC BY-NC 4.0** (Attribution-NonCommercial)
*   **Constraints:**
    *   **NO CODE ALLOWED:** You cannot include `.gd` scripts or compiled binaries in this repository.
    *   **Attribution Required:** You must credit AeroBeat-Fitness if you modify existing assets.
    *   **Scope:** An asset pack should target **Core** (Generic) or **One Feature** (Specific). Do not mix assets for different gameplay features in one repo.

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
    Place your `.glb`, `.png`, `.ogg`, `.webm`, or `.tres` files into the `assets/` directory.
4.  **Import:**
    This repository is intended to be used as a submodule or direct download into an `aerobeat-assembly-*` project.

## 📂 Structure

*   `assets/` - The root folder for all content.
    *   `models/` - 3D meshes (GLTF/GLB).
    *   `textures/` - 2D images.
    *   `audio/` - Sound effects and music.
    *   `video/` - Coaching videos (.webm).
    *   `materials/` - Godot StandardMaterials.
*   `LICENSE` - The CC BY-NC 4.0 legal text.

## 📝 Licensing & Commercial Use

*   **Non-Commercial:** You are free to use, remix, and share these assets for non-commercial projects.
*   **Commercial:** You **CANNOT** use these assets in a commercial product (sold on Steam, App Store, etc.) without replacing them or obtaining a specific license from the original creator.