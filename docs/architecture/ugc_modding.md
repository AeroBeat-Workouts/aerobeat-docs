# UGC & Modding Architecture

AeroBeat is designed to be extensible by the community. While our internal development uses Git Submodules (`aerobeat-asset-*`), our athletes consume content via **Godot Resource Packs (`.pck`)**.

This document outlines the architecture for the **Modding SDK** and the **Runtime Loading Protocol**.

## 🏗️ The Gap: Git vs. PCK

*   **Internal Devs:** Clone repos, edit in Godot Editor, commit to Git.
*   **Community Creators:** Download a specialized SDK, validate assets, and **Upload directly to AeroBeat Servers**.
*   **Athletes:** Browse the **In-Game Content Browser**, download content, and play. (Power users can still manually drop `.pck` files into `user://mods/`).

## 🛠️ Creator Tooling Strategy

We utilize a **Hybrid Tooling Strategy** to match the technical comfort of different creator personas.

### 1. Native SDKs (Godot Editor)
For **3D Artists** who need full control over materials, import settings, and baking.
*   **SDKs:** `environment`, `cosmetics`.
*   **Workflow:** Download Godot -> Open SDK -> Import Assets -> Upload.

### 2. Standalone Apps (Web / Desktop)
For **Musicians, Coaches, and Choreographers** who need a streamlined, focused interface without the complexity of a game engine. These are Godot projects exported as standalone applications.

*   **Musician Portal (Web):**
    *   **Features:** Audio upload, Cloud conversion (WAV -> OGG), BPM detection.
    *   **Preview:** Visualizer that plays the song against a selected "Test Chart" from the server.
*   **Choreography Studio (Desktop/Web):** Specialized timeline editor for mapping.
*   **Coaching Studio (Web):** Wizard for syncing voice-overs and video.

### 3. Shared Core
All tools (Native and Web) share the same `aerobeat-core` logic. This ensures that a song validated in the Web Portal is guaranteed to work in the Game Client.

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