# Modding Quickstart Guide

Welcome to the AeroBeat Creator Community! This guide will help you create your first Skin, Song, or Environment and publish it to the in-game browser.

## 1. Choose Your SDK

We provide specialized Godot projects for different types of content. Download the one that matches your goal.

| SDK Name | Use Case |
| :--- | :--- |
| **Musician Portal (Web)** | Uploading Songs, converting audio, and setting BPM. |
| **Coaching Studio (Web)** | Creating immersive [Coaching](coaching.md) content (Warmups, Overlays). |
| **Choreography Studio** | Mapping songs. Specialized Apps for [Boxing](choreography/boxing.md), [Flow](choreography/flow.md), etc. |
| **Cosmetics SDK** | (Godot Editor) Creating Gloves, Targets, Obstacles, and Avatars. |
| **Environment SDK** | (Godot Editor) Building 3D scenes, Lighting setups, and Skyboxes. |

> **Note:** The **Cosmetics** and **Environment** SDKs require you to download the **Godot 4.x Editor**. The others run directly in your browser or as standalone apps.

## 2. Project Setup

1.  **Unzip** the SDK folder.
2.  Open **Godot Engine**.
3.  Click **Import** and select the `project.godot` file inside the SDK folder.
4.  **Log In:** In the top-right corner of the editor, click the "AeroBeat" button and log in with your Verified AeroBeat Account.

## 3. Creating Your Mod

### Step A: Import Assets

Drag your `.glb` (Models), `.png` (Textures), or `.ogg` (Audio) files into the FileSystem dock.
*   **Tip:** Keep your files organized in a folder named after your mod (e.g., `res://mods/my_cool_skin/`).

### Step B: Create the Resource

1.  Right-click in the FileSystem -> **Create New** -> **Resource**.
2.  Search for the specific type (e.g., `AeroSkin`, `AeroSongData`, `AeroEnvironment`).
3.  Fill in the properties (drag your mesh/audio into the slots).

### Step C: Create the Manifest

Every mod needs a Manifest to tell the game what it is.

1.  Create a new Resource of type **`AeroModManifest`**.
2.  **ID:** A unique string (e.g., `neon_gloves_v1`).
3.  **Display Name:** What players see in the browser.
4.  **Content Resource:** Drag the resource you created in Step B here.

## 4. Validation (The Quality Gate)

Before you can upload, your mod must pass local validation checks.

1.  Click the **"AeroBeat Uploader"** tab at the bottom of the screen.
2.  Select your `manifest.tres`.
3.  Click **"Validate"**.

**Common Errors:**
*   ❌ *Texture too large:* Max size is 2048x2048.
*   ❌ *Polycount exceeded:* Skins must be under 10k triangles.
*   ❌ *Script detected:* You cannot include `.gd` scripts in Asset Packs.

## 5. Upload & Publish

Once validation passes (Green Checkmark ✅):

1.  **Check Quota:** The bar shows how much cloud storage you have left.
2.  **Upload:** Click **"Publish to Server"**.
3.  **Wait:** The status will change to `UPLOADING` -> `PROCESSING`.

### What happens next?

Your mod is sent to our cloud validator for a final security scan. This usually takes 1-2 minutes. Once approved, it will immediately appear in the **"New Releases"** section of the in-game browser for all athletes!

---

## 💡 Pro Tips

*   **Testing:** You can test your mod locally by clicking the "Play" button in the SDK. It will launch a preview window with your asset loaded.
*   **Thumbnails:** The uploader will ask for a `thumbnail.png`. Make it 512x512 for best results.
*   **Updates:** To update a mod, simply keep the same **ID** in the manifest and increment the **Version** number.