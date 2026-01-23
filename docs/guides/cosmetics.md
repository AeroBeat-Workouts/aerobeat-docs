# Creating Custom Cosmetics

In AeroBeat, **"Cosmetics"** are accessories that players can equip on their Avatars to express their style. This includes Hats, Glasses, Backpacks, and other wearables.

## 🛠️ The Cosmetics SDK

*   **SDK:** `aerobeat-cosmetics-*` (Template: `cosmetics`)
*   **Tools:** Blender, Godot 4.x.
*   **Output:** An `AeroCosmeticAttachment` resource packed into a `.pck`.

## 🧢 Technical Constraints

To ensure accessories fit correctly and perform well:

### 1. Geometry

*   **Polycount:** < 5k triangles per item.
*   **Origin Point:** The mesh origin `(0,0,0)` is the **Attachment Point**.
    *   *Example:* For a Hat, the origin should be at the center of the bottom rim (where it touches the head).
*   **Scale:** 1 Unit = 1 Meter.

### 2. Materials

*   **Shaders:** Standard PBR (`StandardMaterial3D`).
*   **Textures:** Max 1024x1024.
*   **Draw Calls:** Try to use a single material per item.

## 🦴 The Socket System

Cosmetics attach to specific bones on the standard **Humanoid Skeleton**. When you define a cosmetic, you must choose which "Socket" it belongs to.

| Socket Name | Bone Target | Usage |
| :--- | :--- | :--- |
| **Head** | `Head` | Hats, Helmets, Masks. |
| **Face** | `Head` (with offset) | Glasses, Visors. |
| **Spine** | `Spine` / `Chest` | Backpacks, Wings, Capes. |
| **Waist** | `Hips` | Belts, Tails. |
| **LeftHand** | `LeftHand` | Watches, Bracelets. |
| **RightHand** | `RightHand` | Watches, Bracelets. |

> **Note:** The engine handles the parenting logic. You just need to specify the target bone name.

## 🚀 Workflow

### Phase 1: Modeling

1.  **Reference:** Import a standard dummy head into Blender to check scale.
2.  **Model:** Create your accessory.
3.  **Pivot:** Move the mesh so the attachment point is at `(0,0,0)`.
4.  **Export:** Export as `.glb` (GLTF Binary).

### Phase 2: Import to SDK

1.  Open the `aerobeat-cosmetics-*` project.
2.  Drag your `.glb` into the `assets/accessories/` folder.
3.  Double-click to verify materials.

### Phase 3: Configuration

1.  **Create Resource:** Right-click -> New -> `AeroCosmeticAttachment`.
2.  **Assign Mesh:** Drag your imported `.glb` into the `mesh_visual` slot.
3.  **Select Socket:** Type the bone name (e.g., `Head`) in the `socket_bone` property.
4.  **Offsets:** Use `position_offset` and `rotation_offset` to fine-tune the fit without re-exporting the mesh.

### Phase 4: Validation & Upload

1.  Create `AeroModManifest` (Type: `COSMETIC`).
2.  Open **AeroBeat Uploader**.
3.  **Validate:** Checks for polycounts and valid bone names.
4.  **Upload:** Publish to the server.

## 🎨 Best Practices

*   **Universal Fit:** Avatars have different head shapes. Design hats that are slightly loose or have adjustable straps (visually) to minimize clipping.
*   **Hair Interaction:** Large hats often clip with hair.
    *   *Advanced:* You can set the `hides_hair` property to `true` in the resource. This tells the Avatar system to disable the hair mesh when this hat is equipped.