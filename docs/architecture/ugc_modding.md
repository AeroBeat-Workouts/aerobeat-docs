# UGC & Modding Architecture

AeroBeat is designed to be extensible by the community. While our internal development uses Git Submodules (`aerobeat-asset-*`), our athletes consume content via **Godot Resource Packs (`.pck`)**.

This document outlines the architecture for the **Modding SDK** and the **Runtime Loading Protocol**.

## 🏗️ The Gap: Git vs. PCK

*   **Internal Devs:** Clone repos, edit in Godot Editor, commit to Git.
*   **Community Creators:** Download a specialized SDK, validate assets, and **Upload directly to AeroBeat Servers**.
*   **Athletes:** Browse the **In-Game Content Browser**, download content, and play. (Power users can still manually drop `.pck` files into `user://mods/`).

## 🛠️ The Modding SDKs

To ensure quality and ease of use, we provide **Specialized SDKs** tailored to specific asset types.

*   **Type:** Godot Project.
*   **Variants:**
    *   `aerobeat-sdk-environment`: Tools for lighting baking and skyboxes.
    *   `aerobeat-sdk-choreography`: Charting tools and audio analysis.
    *   `aerobeat-sdk-cosmetics`: Import tools for Gloves, Targets, and Avatars.
    *   `aerobeat-sdk-coaching`: Import tools for Warm-up/Cool-down videos (`.webm`) and Audio Overlays.
*   **Integrated Browser:** All SDKs connect to the AeroBeat API. This allows creators to search, preview, and "Remix" existing server-side assets (e.g., selecting a Song to chart, or a Playlist to coach) without manually downloading files.
*   **Validation:** Each SDK includes a **Quality Gate** plugin. It checks poly-counts, texture sizes, and file formats locally. The "Upload" button is disabled until validation passes.

## 🛡️ Security: The Double Verification Strategy

To prevent malicious code execution (RCE) and ensure performance, every asset undergoes two layers of validation.

### 1. Client-Side (SDK)

*   **Role:** Immediate feedback for the creator.
*   **Checks:**
    *   **Performance:** Poly-count limits, Texture resolution caps (e.g., Max 2048x2048).
    *   **Completeness:** Ensures all dependencies (textures) are included in the pack.
    *   **Format:** Validates that audio is `.ogg` (not `.wav` for streaming) or `.mp3`.
    *   **Video:** Validates that videos are `.webm` (VP8/VP9) for cross-platform compatibility.

### 2. Server-Side (The Gatekeeper)

*   **Role:** Security and Integrity.
*   **Process:** When a `.pck` is uploaded, the server spins up a headless validator.
*   **Checks:**
    *   **Script Scanning:** Greps all text resources (`.tres`, `.tscn`) for `[sub_resource type="GDScript"]` or `script/source`.
    *   **Extension Whitelist:** Rejects any file ending in `.gd`, `.gdc`, `.dll`, `.so`, `.dylib`.
    *   **Core Overwrites:** Verifies the pack does not attempt to mount files into `res://addons/` or `res://src/`.

## 📜 The Manifest Protocol

To make UGC discoverable at runtime without hardcoding paths, every Mod must contain a standardized **Entry Point**.

### 1. The File Structure
A valid mod is a `.pck` or `.zip` file that, when mounted, adheres to this structure:

```text
my_cool_skin.pck (Mounts to res://mods/my_cool_skin/)
├── manifest.tres      <-- The Entry Point (AeroModManifest)
├── assets/            <-- Raw files (Textures, Audio, GLB)
│   ├── glove_albedo.png
│   └── glove_mesh.glb
└── resources/         <-- Godot Resources
    └── GloveSkin.tres <-- The actual game-ready resource
```

### 2. The Manifest Resource (`AeroModManifest`)

The game scans `res://mods/*/manifest.tres` on startup.

```gdscript
class_name AeroModManifest
extends Resource

enum ModType { SKIN, SONG, ENVIRONMENT, GAMEPLAY_TWEAK, COACHING, PLAYLIST }

@export var id: String = "my_cool_skin" # Unique ID
@export var display_name: String = "Cyberpunk Gloves"
@export var author: String = "CommunityUser"
@export var version: String = "1.0.0"
@export var type: ModType = ModType.SKIN
@export var target_feature: String = "boxing" # e.g., "boxing", "flow"

# The actual content to load
@export var content_resource: Resource 
```

## 🔄 The Runtime Loading Flow

1.  **Download:** Athlete selects content in the Browser. The game downloads the `.pck` to `user://mods/cache/`.
2.  **Discovery:** On startup (or after download), the `ModLoader` scans `user://mods/` and mounts valid packs using `ProjectSettings.load_resource_pack()`.
3.  **Registration:** The loader reads the `manifest.tres` from the mounted path and registers it in the `ContentRegistry`.
4.  **Offline Support:** Since files are saved locally, downloaded content remains available without an internet connection.