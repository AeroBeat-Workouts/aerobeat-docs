# Cloud Baker Architecture

The **Cloud Baker** is the server-side pipeline responsible for validating, optimizing, and packaging User Generated Content (UGC). It ensures that raw creator submissions are safe and performant before they reach athletes' devices.

> **Package-contract boundary:** The Cloud Baker is a future distribution/build pipeline concern. It does **not** redefine the authored workout-package contract. The canonical authored truth remains the self-contained package folders/YAML described in the package docs. If this pipeline later emits `.pck` files or signed bundles, those are distribution artifacts layered on top of the authored package model.

## 🏗️ The Pipeline

The pipeline is triggered via a webhook when a file lands in the S3 "Uploads" bucket.

### Stage 1: Validation (The Gatekeeper)
*   **Environment:** Ephemeral Docker Container (Network Isolated).
*   **Input:** Authored workout packages or raw source assets destined for a later build step.
*   **Checks:**
    1.  **Package Shape Check:** Does the submission match the expected package/domain layout and parse cleanly?
    2.  **Script Scan:** Grep for `script/source` or `type="GDScript"` in any submitted runtime resources. **Fail immediately if found.**
    3.  **Reference Check:** Ensure paths and ids resolve inside the package boundary and do not attempt to overwrite engine/addon/runtime-owned paths.

### Stage 2: Optimization (The Crunch)
*   **Texture Compression:**
    *   Convert raw PNG/JPG to **WebP** (Lossless) for UI when appropriate.
    *   Convert textures to **ASTC** (4x4 block) for Mobile/VR performance when packaging runtime artifacts.
*   **Audio Conversion:**
    *   Convert WAV/MP3 to **Ogg Vorbis** (Quality 7) for streaming.
*   **Mesh LODs:**
    *   Generate LOD1 and LOD2 meshes automatically using Godot's mesh optimizer.

### Stage 3: Packaging (The Baker)
*   **Tool:** Headless Godot Editor or other packaging/runtime build steps.
*   **Action:**
    1.  Import the validated package into a temporary build environment.
    2.  Generate runtime/distribution artifacts such as exported packs if the target platform needs them.
    3.  Optionally sign the **distribution artifact** with AeroBeat-controlled keys.

Signing and integrity metadata here are a transport/distribution hardening concern. They are intentionally separate from the v1 authored package YAML contract.

## ☁️ Infrastructure

*   **Orchestrator:** AWS Step Functions / Temporal.
*   **Compute:** AWS Fargate (Serverless Containers).
*   **Storage:**
    *   `s3://aerobeat-uploads/`: Raw, untrusted files (Lifecycle: 24h).
    *   `s3://aerobeat-assets/`: Processed, public artifacts (CDN backed).

## 🔄 Re-Baking Strategy

One of the biggest risks in Godot development is **Binary Compatibility**. A runtime bundle exported in one Godot version might not load correctly in another.

To solve this, we store the **authored package/source assets**, not just the final exported artifact.

*   **Trigger:** When AeroBeat upgrades the engine version or its packaging pipeline.
*   **Action:** The Cloud Baker spins up workers to re-import and re-export active content using the new toolchain.
*   **Result:** Athletes download refreshed runtime artifacts without creators having to re-author the package contract itself.

## 🛡️ Security Measures

1.  **Sandboxing:** The Baker runs with **No Outbound Internet Access**. It cannot phone home or download malware.
2.  **Resource Limits:** Strict RAM (2GB) and CPU limits prevent "Zip Bomb" attacks from crashing the cluster.
3.  **Timeout:** Any job taking > 5 minutes is hard-killed.
