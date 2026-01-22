# Creating 3D Environments

Environments in AeroBeat are more than just backgrounds; they are reactive light shows that immerse the athlete in the music.

## 🛠️ The Environment SDK

*   **SDK:** `aerobeat-sdk-environment`
*   **Tools:** Godot 4.x Editor with AeroBeat plugins.
*   **Output:** An `AeroEnvironment` resource packed into a `.pck`.

## 📐 Technical Constraints

To ensure your environment runs on mobile phones and VR headsets:

*   **Triangle Count:** Keep visible geometry under **50k triangles**.
*   **Draw Calls:** Use shared materials. Target < 50 draw calls.
*   **Scale:** 1 Unit = 1 Meter.
*   **Player Zone:** The player stands at `(0, 0, 0)`. Keep a 2m radius clear of geometry.
*   **Forward:** The player faces **Negative Z**.

## 💡 Lighting & Reactivity

Since you cannot write scripts (`.gd`) in Asset Packs, AeroBeat uses a **Data-Driven Reactivity** system. You define *what* lights are, and the Engine controls *when* they flash.

### 1. Setup Lights

Place standard `OmniLight3D` or `SpotLight3D` nodes in your scene.

### 2. The `AeroEnvironment` Resource

This is the brain of your level.

1.  Create a new resource: `AeroEnvironment`.
2.  **Beat Lights:** Drag lights here to flash on every beat (1/4 note).
3.  **Measure Lights:** Drag lights here to flash on every bar (1/1 note).
4.  **Spectrum Material:** Assign a `StandardMaterial3D`. The engine will modulate its `Emission Energy` based on the song's loudness.

### 3. Global Illumination (GI)

*   **Realtime GI (SDFGI):** Too heavy for mobile. **Do not use.**
*   **Baked Lightmaps:** Highly recommended.
    1.  Add a `LightmapGI` node.
    2.  Select your meshes -> `Use in Baked Light: Static`.
    3.  Click **Bake Lightmaps**.
    4.  The generated `.exr` files will be automatically packed with your mod.

## 🚀 Workflow

### Phase 1: Layout

1.  **Import:** Drag your `.glb` / `.gltf` files into the SDK.
2.  **Scene:** Create a `Node3D` root. Assemble your mesh instances.
3.  **Boundaries:** Ensure the floor is at `Y=0`.

### Phase 2: Atmosphere

1.  **WorldEnvironment:** Add a `WorldEnvironment` node.
2.  **Sky:** Define a `Sky` resource (Panorama or Procedural).
3.  **Fog:** Enable Volumetric Fog for depth (use sparingly for mobile performance).

### Phase 3: Configuration

1.  Create the `AeroEnvironment` resource.
2.  Assign your Scene file (`.tscn`).
3.  Assign your Sky resource.
4.  Populate the Reactive Light arrays.

### Phase 4: Validation & Upload

1.  Create the `AeroModManifest` (Type: `ENVIRONMENT`).
2.  Open the **AeroBeat Uploader**.
3.  **Validate:** Checks for high poly counts or unbaked lights and accidentally added scripts.
4.  **Upload:** Publish to the server.

## 🎨 Best Practices

*   **Darkness is your Friend:** Rhythm games look best with high contrast. Keep the ambient light low and use the reactive lights to create energy.
*   **Guide the Eye:** Use geometry to frame the "Highway" (where targets come from).
*   **Avoid Strobing:** Don't make *every* light flash on every beat. It causes fatigue. Use "Measure Lights" for big changes and "Beat Lights" for subtle pulses.
*   **VR Comfort:** Avoid moving the floor or the horizon. It causes motion sickness.