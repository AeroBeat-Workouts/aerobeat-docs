# Creating Custom Cosmetics

In AeroBeat, "Cosmetics" allow athletes to personalize their equipment. This guide covers creating custom **Boxing Gloves** and **Targets**.

## 🛠️ The Cosmetics SDK

*   **SDK:** `aerobeat-sdk-cosmetics`
*   **Tools:** Godot 4.x Editor.
*   **Output:** An `AeroCosmetic` resource packed into a `.pck`.

## 🥊 Boxing Gloves

Gloves are the athlete's primary connection to the game. They must look good from the "First Person" perspective.

### Technical Constraints

*   **Polycount:** < 10k triangles per glove.
*   **Orientation:** Fingers point **Negative Z**. Palm faces **Negative Y** (Down).
*   **Materials:** Standard PBR. Avoid transparent materials for performance.

### The Left/Right Rule

AeroBeat relies on color coding for gameplay.

*   **Left Hand:** Must be predominantly **Dark / Black**.
*   **Right Hand:** Must be predominantly **Light / White**.
*   *Why?* Players instinctively match the glove color to the target color. If you make a "Red vs Blue" set, players might get confused hitting Black/White targets.

## 🎯 Targets

Targets are the objects flying at the player.

### Types

1.  **Directional Target:** Has a clear "Front" face. Used for punches.
2.  **Omni Target:** Symmetrical. Used for "Any Direction" hits.
3.  **Obstacle:** Walls or shapes to dodge.

### Technical Constraints

*   **Polycount:** < 2k triangles per target. (There can be 50+ on screen).
*   **Hitbox:** You are creating the *Visual Mesh*. The game engine handles the physics collision. Your mesh should fit roughly within a **0.5m x 0.5m x 0.5m** cube.
*   **Center Point:** The mesh must be centered at `(0,0,0)`.

## 🚀 Workflow

### Phase 1: Modeling & Texturing

1.  Create your assets in Blender/Maya.
2.  Export as `.glb` (GLTF Binary).
3.  **Textures:** Embed them or keep them in a relative folder.

### Phase 2: Import to SDK

1.  Open `aerobeat-sdk-cosmetics`.
2.  Drag your `.glb` files into the FileSystem.
3.  Double-click to open and verify materials.

### Phase 3: Configuration

1.  **Create Resource:** Right-click -> New -> `AeroGlove` or `AeroTargetSkin`.
2.  **Assign Mesh:** Drag your imported mesh into the `mesh_visual` slot.
3.  **Offset:** Adjust position/rotation offset if the mesh doesn't align with the default hand bones.

### Phase 4: Validation & Upload

1.  Create `AeroModManifest` (Type: `SKIN`).
2.  Open **AeroBeat Uploader**.
3.  **Validate:** Checks for polycounts and material errors or accidentally added scripts.
4.  **Upload:** Publish to the server.

## 🎨 Best Practices

*   **Readability:** Targets move fast. Ensure the "Directional Arrow" or indicator on the target is high contrast.
*   **Silhouette:** Unique shapes are great, but don't make them so complex that the hit direction is ambiguous.
*   **Glove Comfort:** Remember the player sees the *back* of the glove 90% of the time. Put your best details there.