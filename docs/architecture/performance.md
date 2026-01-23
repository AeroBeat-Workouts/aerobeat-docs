# Performance Architecture

Rhythm games require consistent frame timing. A dropped frame means a missed beat, which breaks the player's flow and ruins the experience.

This document outlines the strategies AeroBeat uses to ensure a locked **60 FPS (Mobile)**, **90 FPS (VR)**, and **120+ FPS (PC)**.

## 1. The "Zero Stutter" Mandate

We prioritize **Frame Pacing** over **Graphical Fidelity**.

*   **Rule:** No resource loading, shader compilation, or heavy garbage collection is allowed during the `Gameplay` state.
*   **Enforcement:** The `AeroPerformanceMonitor` tracks frame times. If a spike > 16ms occurs during gameplay, it is logged as a "Performance Strike" against the active UGC.

## 2. Shader Pre-Warming

Godot 4.x (Vulkan) compiles shaders asynchronously, but pipeline creation can still cause hitches on the main thread the first time a material appears on screen.

### The Strategy

We use a **Pre-Warm Phase** during the "Loading..." screen.

1.  **Scan:** The `ModLoader` identifies all unique `Materials` and `Meshes` required by the selected Song, Environment, Skins, and Avatars.
2.  **Instantiate:** The `AeroShaderCache` singleton spawns a hidden `SubViewport`.
3.  **Render:** It instances every unique mesh+material combination into this viewport.
4.  **Wait:** The game waits for 3 frames (to ensure the GPU pipeline is fully built).
5.  **Cleanup:** The instances are removed, but the driver cache remains hot.
6.  **Start:** The song begins.

> **Note:** This applies to **Particles** as well. All particle systems must emit at least one particle during pre-warm.

## 3. Draw Call Budgets

To support mobile VR (Quest) and Phones, we enforce strict draw call limits.

| Platform | Target Draw Calls | Max Polycount (Scene) |
| :--- | :--- | :--- |
| **Mobile / Quest** | < 150 | 100k |
| **PC / Console** | < 1000 | 500k |

### Mitigation Strategies

1.  **GPU Instancing:** The Core Engine automatically uses `MultiMeshInstance3D` for all gameplay targets (Notes, Obstacles).
2.  **Texture Atlasing:** The **Cloud Baker** attempts to merge textures for static environment geometry.
3.  **Avatar Limits:** Avatars are limited to **3 Materials** max.

## 4. Level of Detail (LOD)

We rely on Godot's automatic LOD system, but we enforce generation at the Cloud Baker level.

### Cloud Baker Pipeline

When a creator uploads a high-poly mesh (e.g., a 20k poly statue):

1.  The Baker generates **LOD1** (50%) and **LOD2** (20%) meshes using the mesh optimizer.
2.  These are packed into the `.pck`.

### Runtime Selection

*   **PC:** Uses `LOD0` (Original) by default.
*   **Mobile:** Forces `LOD Bias` to prefer `LOD1` immediately, saving vertex processing power.

## 5. Memory Management (VRAM)

Rhythm games often load hundreds of songs. We cannot keep everything in memory.

### The "Jukebox" Lifecycle

1.  **Menu:** Only the "Preview Audio" (30s clip) and "Thumbnail" (512px) are loaded.
2.  **Selection:** When a song is picked, the full `.ogg` and Environment `.pck` are loaded.
3.  **Gameplay:** All assets are pinned in VRAM.
4.  **End Screen:** Assets remain loaded (for "Replay").
5.  **Exit to Menu:** **Aggressive Unload.** All gameplay resources are freed. `GC.collect()` is forced.

### Texture Compression

*   **Mobile:** All textures are converted to **ASTC 6x6** by the Cloud Baker.
*   **PC:** Textures use **S3TC (BC7)**.
*   **UI:** Uses **WebP** (Lossless) to save disk space while keeping sharpness.

## 6. Object Pooling

We do not `instantiate()` notes during gameplay.

*   **Pools:** `AeroTargetPool`, `AeroObstaclePool`, `AeroEffectPool`.
*   **Size:** Pools are initialized during the Loading Screen based on the song's note count (plus a 20% buffer).
*   **Behavior:** When a note is hit, it is `reparented` or `hidden`, not `queue_free()`'d.