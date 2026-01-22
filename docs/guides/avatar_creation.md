# Creating Custom Avatars

Avatars in AeroBeat serve two critical roles:

1.  **The Coach:** In Dance Mode, they are the "Virtual Coach" that players mirror.
2.  **The Athlete:** In Multiplayer, this is how other players see **You**.

This guide covers how to rig, import, and configure custom 3D characters that look great in both scenarios.

## 🛠️ The Cosmetics SDK

*   **SDK:** `aerobeat-sdk-cosmetics`
*   **Tools:** Blender, Godot 4.x.
*   **Output:** An `AeroAvatar` resource packed into a `.pck`.

## 🦴 Technical Constraints

To ensure your avatar works with our animation system (and runs on mobile):

### 1. The Skeleton (Rig)

AeroBeat uses a standard **Humanoid Skeleton**.

*   **Bone Names:** Must match standard naming conventions (e.g., `Hips`, `Spine`, `Chest`, `Head`, `LeftShoulder`, `LeftUpperArm`, etc.).
*   **T-Pose:** The model must be exported in a T-Pose.
*   **Root Motion:** The root bone should be at `(0,0,0)` on the floor.

> **Tip:** We highly recommend using **Mixamo** or **VRM** compatible rigs. The SDK includes a "Retargeting Tool" to map common skeletons to the AeroBeat standard.

### 2. Geometry

*   **Polycount:** < 20k triangles. (Mobile optimization).
*   **Meshes:** Combine meshes where possible (e.g., Body + Clothes = 1 Mesh) to reduce draw calls.
*   **Scale:** 1 Unit = 1 Meter. A standard character should be ~1.7m tall.

### 3. Materials

*   **Shaders:** Standard PBR (`StandardMaterial3D`).
*   **Textures:** Max 2048x2048.
*   **Transparency:** Avoid alpha blending (hair/glasses) if possible, as it is expensive on mobile. Use "Alpha Scissor" instead.

## 🚀 Workflow

### Phase 1: Modeling & Rigging

1.  Create your character in Blender/Maya/VRoid.
2.  Rig it to a Humanoid skeleton.
3.  Export as `.glb` (GLTF Binary). Ensure "Export Deformation Bones Only" is checked if using Blender.

### Phase 2: Import to SDK

1.  Open `aerobeat-sdk-cosmetics`.
2.  Drag your `.glb` into the `assets/avatars/` folder.
3.  Double-click the file to open the **Advanced Import Settings**.
4.  **Skeleton Map:** Select the "Skeleton" profile (Godot Humanoid) to ensure bones are mapped correctly.

### Phase 3: Configuration

1.  **Create Resource:** Right-click -> New -> `AeroAvatar`.
2.  **Assign Scene:** Drag your imported `.glb` (which Godot treats as a scene) into the `avatar_scene` slot.
3.  **Metadata:** Set the `display_name` and `height_meters`.

### Phase 4: Validation & Upload

1.  Create `AeroModManifest` (Type: `SKIN`).
2.  Open **AeroBeat Uploader**.
3.  **Validate:** The tool will check bone hierarchy and polycounts.
4.  **Upload:** Publish to the server.

## 🎨 Best Practices

*   **Readability:** The player needs to see the limbs clearly to mimic them. Avoid baggy clothes that hide the elbows and knees.
*   **Contrast:** Bright colors work best against the typically dark game environments.
*   **Multiplayer Performance:** Since up to 4 avatars may be visible in a multiplayer lobby, keeping polycounts low (< 20k) is critical for mobile performance.
*   **Face:** While facial animation is not currently supported in v1, a friendly static expression is better than a T-Pose stare!