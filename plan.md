# Strategic Plan: Specialized Asset Topology & Hybrid Tooling

This document outlines the architectural shift to specialized repository types for Content/UGC, separating "Art Assets" (Godot-based) from "Logic/Media Assets" (Web-based).

## 1. Topology Refactor

We will break the generic `asset` tier into specialized types to enforce stricter dependency rules and validation.

### A. The New Art Tiers (Godot Editor Workflow)
These repositories contain 3D assets and materials. Creators (Official or UGC) use the Godot Editor.

| New Repo Type | Content | Dependencies |
| :--- | :--- | :--- |
| **`aerobeat-skins-*`** | Gloves, Bats, Targets, Obstacles, Portals. | `aerobeat-feature-*` (Inheritance) |
| **`aerobeat-avatars-*`** | 3D Characters (Coach/Player). | `aerobeat-core` (Skeleton Map) |
| **`aerobeat-cosmetics-*`** | **Avatar Accessories.** Hats, Glasses, Wearables. | `aerobeat-core` (Socket Definitions) |
| **`aerobeat-environments-*`** | Levels, Lighting, Skyboxes. | `aerobeat-core` (Reactive Lights) |

### B. The Internal Tier
| Repo Type | Content | Usage |
| :--- | :--- | :--- |
| **`aerobeat-asset-*`** | **System Assets.** UI Icons, Fonts, Mock Data, Fallback Meshes. | **Internal Only.** Not swappable via UGC. Required by Assemblies/Shells. |

### C. The Media Tiers (Web Tool Workflow)
These assets are created via simplified Web/App interfaces, not raw Git repositories (though Official content may still be versioned in Git).

*   **Songs:** Uploaded via Musician Portal.
*   **Choreography:** Created via Choreography Studio.
*   **Coaching:** Created via Coaching Studio.
*   **Playlists:** Created via In-Game/Web Browser.

## 2. Template Implementation Plan

We need to create specific templates for the new Art Tiers. These effectively act as the "SDKs" for modders.

### Step 1: Create New Templates
*   `templates/skins/` (Replaces `sdk-cosmetics` plan)
*   `templates/avatars/` (Replaces `sdk-avatars` plan)
*   `templates/cosmetics/` (Accessories - *New*)
*   `templates/environments/` (Replaces `sdk-environment` plan)

**Base Inheritance:** All inherit `.gitignore`, `LICENSE`, `cla.yml` from the standard pattern.

### Step 2: Update Existing `asset` Template
*   Refactor `templates/asset/` to be the "Internal System Asset" template.
*   Update README to clarify it is for non-UGC content.

## 3. Detailed Specs for New Templates

### A. Skins Template (`templates/skins/`)
*   **Manifest:** `plugin.cfg` (Name: "AeroBeat Skins Repo")
*   **Structure:** `assets/gloves/`, `assets/bats/`, `assets/targets/`, `assets/obstacles/`, `assets/portals/`
*   **Setup:** Clones `aerobeat-core` AND `aerobeat-feature-*` (for base scenes).

### B. Avatars Template (`templates/avatars/`)
*   **Manifest:** `plugin.cfg` (Name: "AeroBeat Avatars Repo")
*   **Structure:** `assets/avatars/`
*   **Setup:** Clones `aerobeat-core`.

### C. Cosmetics Template (`templates/cosmetics/`)
*   **Manifest:** `plugin.cfg` (Name: "AeroBeat Cosmetics Repo")
*   **Structure:** `assets/accessories/`, `assets/apparel/`
*   **Setup:** Clones `aerobeat-core`.
*   **Key Resource:** `AeroCosmeticAttachment` (Defines which bone/socket it attaches to).

### D. Environments Template (`templates/environments/`)
*   **Manifest:** `plugin.cfg` (Name: "AeroBeat Environments Repo")
*   **Structure:** `assets/levels/`, `assets/lighting/`
*   **Setup:** Clones `aerobeat-core`.

## 4. Avatar & Cosmetic Integration Strategy

To ensure `cosmetics` work across different `avatars`, we must enforce strict contracts:

1.  **The Socket Contract:** All Avatars must use the standard Godot Humanoid Skeleton. The Engine will attach cosmetics to specific bones (e.g., `Head`, `Spine`, `LeftHand`).
2.  **Scale Normalization:** Cosmetics are modeled at 1.0 scale. Avatars must define their scale relative to the standard rig so attachments can be scaled to match.
3.  **Exclusion Rules:** An `AeroAvatar` resource must be able to disable specific slots (e.g., "No Hats") if the character geometry prevents it (e.g., a character with a flaming head).

## 5. Risk Analysis & Mitigation

| Risk | Impact | Mitigation Strategy |
| :--- | :--- | :--- |
| **Dependency Hell** | Updates to `feature-boxing` break all community `skins`. | **Stable Wrappers.** Feature repos must provide stable `export_*.tscn` scenes that act as API contracts. Breaking changes require a major version bump. |
| **Avatar Clipping** | Cosmetics don't fit non-standard Avatar shapes. | **Runtime Gizmo.** Allow players to manually adjust accessory position/scale in the Locker Room UI. |
| **Web Audio Latency** | Choreography created in Web Studio is off-sync. | **Desktop Priority.** Promote the Desktop App for serious charting. Add strict Audio Calibration to the Web Tool. |
| **Template Drift** | Maintaining 10+ templates leads to inconsistent CI/CD. | **Common Source.** Create a `templates/_common/` folder for shared files (`LICENSE`, `cla.yml`) and inject them during the sync process. |
| **Performance Variance** | UGC runs poorly on mobile (Quest/Phone). | **Cloud Optimization.** The Cloud Baker pipeline must generate platform-specific artifacts (LODs, ASTC textures) and reject assets exceeding draw-call budgets. |
| **Engine Upgrades** | Godot 4.x updates break `.pck` binary compatibility. | **Source Retention.** Store original uploads (GLB/WAV). The Cloud Baker can re-export all UGC for new engine versions automatically. |
| **Dependency Rot** | A Playlist breaks because a referenced Song/Skin was deleted or changed. | **Immutable Versioning.** Assets are never overwritten. Playlists reference specific versions (e.g., `song_id@v1`). Deletion is "Soft" (hidden from search, but available to existing playlists). |
| **Copyright / DMCA** | Users upload licensed music, risking legal action against the platform or streamers. | **Streamer Mode & Takedowns.** Implement a "Streamer Mode" toggle that disables UGC audio. Build a robust API for processing DMCA takedown requests efficiently. |
| **Toxic Content** | Users upload NSFW images or hate speech. | **Automated Moderation.** Integrate AI text/image analysis (e.g., AWS Rekognition) into the upload pipeline to flag content before it goes public. |
| **Storage Costs** | Uncompressed assets (WAV, 4K PNG) explode cloud storage bills. | **Aggressive Compression.** The Cloud Baker converts WAV -> OGG and PNG -> WebP/ASTC. Enforce strict file size limits at the upload endpoint. |
| **Shader Stutter** | Loading a new Skin during gameplay causes a frame drop (compilation). | **Pre-Warm Strategy.** The Game Client must preload and render all UGC assets for the playlist during the "Loading" phase, ensuring shaders are compiled before the song starts. |

## 6. Pre-Execution Audit Strategy

Before creating new templates, we must identify all references to the old topology to ensure nothing is missed.

*   **Keywords to Search:** `asset`, `cosmetics`, `avatars`, `environment`, `UGC`, `user generated content`, `cosmetics`, `topology`, `architecture`.
*   **Target Areas:** `docs/`, `templates/`, `scripts/`.
*   **Action:** Create a `scripts/audit_references.ps1` script to list all file paths containing these terms.

## 7. Audit Results
- [x] `docs/ai-prompting/AI_MANIFEST.md`
- [x] `docs/ai-prompting/GLOSSARY.md`
- [x] `docs/ai-prompting/overview.md`
- [x] `docs/api/assets/prototypes/index.md`
- [x] `docs/architecture/audio.md`
- [x] `docs/architecture/backend_api.md`
- [x] `docs/architecture/input.md`
- [x] `docs/architecture/multiplayer.md`
- [x] `docs/architecture/overview.md`
- [x] `docs/architecture/security.md`
- [x] `docs/architecture/state-management.md`
- [x] `docs/architecture/telemetry.md`
- [x] `docs/architecture/testing.md`
- [x] `docs/architecture/topology.md`
- [x] `docs/architecture/ugc_modding.md`
- [x] `docs/architecture/ui-ux.md`
- [x] `docs/architecture/workflow.md`
- [x] `docs/CODE_OF_CONDUCT.md`
- [x] `docs/gdd/art/overview.md`
- [x] `docs/gdd/concept.md`
- [x] `docs/gdd/gameplay/dance.md`
- [x] `docs/gdd/gamification/overview.md`
- [x] `docs/gdd/releases/community.md`
- [x] `docs/gdd/releases/digital-stores-and-arcades.md`
- [x] `docs/gdd/user-content/community-creations.md`
- [x] `docs/gdd/user-content/overview.md`
- [x] `docs/guides/accessibility.md`
- [x] `docs/guides/avatar_creation.md`
- [x] `docs/guides/choreography/dance.md`
- [x] `docs/guides/choreography/overview.md`
- [x] `docs/guides/coaching.md`
- [x] `docs/guides/contributing_workflow.md`
- [x] `docs/guides/cosmetics.md`
- [x] `docs/guides/environment_creation.md`
- [x] `docs/guides/modding_quickstart.md`
- [x] `docs/index.md`
- [x] `docs/licensing/attribution.md`
- [x] `docs/licensing/commercial.md`
- [x] `docs/licensing/CONTRIBUTING.md`
- [x] `docs/licensing/creative.md`
- [x] `docs/licensing/index.md`
- [x] `scripts/audit_references.ps1`
- [x] `scripts/create_placeholders.py`
- [x] `scripts/sync_templates.ps1`
- [x] `templates/assembly/LICENSE.md`
- [x] `templates/assembly/README.md`
- [x] `templates/assembly/setup_dev.py`
- [x] `templates/assembly/test/test_example.gd`
- [x] `templates/asset/.testbed/project.godot`
- [x] `templates/asset/plugin.cfg`
- [x] `templates/asset/README.md`
- [x] `templates/asset/setup_dev.py`
- [x] `templates/feature/LICENSE.md`
- [x] `templates/feature/README.md`
- [x] `templates/feature/test/test_example.gd`
- [x] `templates/input/LICENSE.md`
- [x] `templates/input/README.md`
- [x] `templates/README.md`
- [x] `templates/ui-kit/LICENSE.md`
- [x] `templates/ui-kit/test/test_example.gd`
- [x] `templates/ui-shell/LICENSE.md`
- [x] `templates/ui-shell/test/test_example.gd`

## 8. Execution Checklist

1.  [x] **Audit Codebase:** Run `scripts/audit_references.ps1` to find all legacy topology references.
2.  [x] **Update Docs:** Update files listed in the **Audit Results** section above to reflect new types.
3.  [x] **Create Templates:** Generate the 3 new folders in `templates/`.
4.  [x] **Create Common Folder:** Setup `templates/_common/` for shared files.
5.  [x] **Refactor Asset Template:** Modify `templates/asset/` for internal use.
6.  [x] **Update Sync Script:** Add new types and the `_common` injection logic to `sync_templates.ps1`.
7.  [x] **Design Cloud Baker:** Draft `docs/architecture/cloud_baker.md` to define the optimization/re-baking pipeline.
8.  [x] **Update Policing Policy:** Update `docs/gdd/user-content/policing-content.md` with the automated moderation strategy.

## 9. Risk Mitigation Documentation Plan

Based on the Risk Analysis in Section 5, we need to formalize the mitigation strategies into our documentation.

### New Documents
- [x] `docs/architecture/performance.md`
    - **Covers:** Shader Pre-warming (Stutter), Draw Call Budgets, LOD Strategies.
    - **Risk:** Shader Stutter, Performance Variance.
- [x] `docs/guides/feature_development.md`
    - **Covers:** Creating Stable Wrappers (`export_*.tscn`), API Contracts, Versioning for Features.
    - **Risk:** Dependency Hell.

### Document Updates
- [x] `docs/architecture/backend_api.md`
    - **Add:** "Immutable Versioning" & "Soft Delete" policies.
    - **Risk:** Dependency Rot.
- [x] `docs/architecture/ui-ux.md`
    - **Add:** "Locker Room" (Runtime Gizmos for Cosmetics).
    - **Add:** "Streamer Mode" (UI Toggle specs).
    - **Risk:** Avatar Clipping, Copyright/DMCA.
- [x] `docs/guides/choreography/overview.md`
    - **Update:** Add warning about Web Audio Latency and recommend Desktop App for final sync.
    - **Risk:** Web Audio Latency.
- [x] `docs/guides/feature_development.md`
    - **Update:** Add "Headless Server Compatibility" section.
    - **Rule:** Logic must be pure (No Visuals/Audio). Use Signals for feedback.
    - **Risk:** Multiplayer Server Crashes (Headless mode failing due to Audio/Rendering calls).