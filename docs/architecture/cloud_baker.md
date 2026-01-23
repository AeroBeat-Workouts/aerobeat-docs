# Cloud Baker Architecture

The **Cloud Baker** is the server-side pipeline responsible for validating, optimizing, and packaging User Generated Content (UGC). It ensures that raw assets uploaded by creators are safe and performant before they reach athletes' devices.

## 🏗️ The Pipeline

The pipeline is triggered via a webhook when a file lands in the S3 "Uploads" bucket.

### Stage 1: Validation (The Gatekeeper)
*   **Environment:** Ephemeral Docker Container (Network Isolated).
*   **Input:** Raw `.pck` or Source Files (GLB/WAV).
*   **Checks:**
    1.  **Manifest Check:** Is `manifest.tres` valid?
    2.  **Script Scan:** Grep for `script/source` or `type="GDScript"` in all text resources. **Fail immediately if found.**
    3.  **Path Check:** Ensure all internal paths start with `res://mods/`. Reject overwrites to `res://addons/` or `res://src/`.

### Stage 2: Optimization (The Crunch)
*   **Texture Compression:**
    *   Convert raw PNG/JPG to **WebP** (Lossless) for UI.
    *   Convert textures to **ASTC** (4x4 block) for Mobile/VR performance.
*   **Audio Conversion:**
    *   Convert WAV/MP3 to **Ogg Vorbis** (Quality 7) for streaming.
*   **Mesh LODs:**
    *   Generate LOD1 and LOD2 meshes automatically using Godot's mesh optimizer.

### Stage 3: Packaging (The Baker)
*   **Tool:** Headless Godot Editor (`godot --headless --export-pack`).
*   **Action:**
    1.  Import the optimized assets into a temporary project.
    2.  Generate the final `.pck` file.
    3.  Sign the package with the AeroBeat Private Key (preventing tampering).

## ☁️ Infrastructure

*   **Orchestrator:** AWS Step Functions / Temporal.
*   **Compute:** AWS Fargate (Serverless Containers).
*   **Storage:**
    *   `s3://aerobeat-uploads/`: Raw, untrusted files (Lifecycle: 24h).
    *   `s3://aerobeat-assets/`: Processed, public artifacts (CDN backed).

## 🔄 Re-Baking Strategy

One of the biggest risks in Godot development is **Binary Compatibility**. A `.pck` exported in Godot 4.2 might not load in Godot 4.3.

To solve this, we store the **Source Assets** (GLB, WAV, Tres), not just the final PCK.

*   **Trigger:** When AeroBeat upgrades the engine version.
*   **Action:** The Cloud Baker spins up thousands of workers to re-import and re-export every active mod using the *new* Godot version.
*   **Result:** Athletes automatically download the v2 version of their skins without the creator needing to lift a finger.

## 🛡️ Security Measures

1.  **Sandboxing:** The Baker runs with **No Outbound Internet Access**. It cannot phone home or download malware.
2.  **Resource Limits:** Strict RAM (2GB) and CPU limits prevent "Zip Bomb" attacks from crashing the cluster.
3.  **Timeout:** Any job taking > 5 minutes is hard-killed.