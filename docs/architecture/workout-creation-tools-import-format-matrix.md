# Workout Creation Tools Import Format Matrix

This document defines the current canonical **accepted source/import formats** versus **stored canonical package formats** for the AeroBeat workout creation tools.

It exists to make the import boundary actionable for future CLI and GUI tooling.

Use this document when implementing:

- slot-aware import validation
- media normalization/transcode steps
- package repair/import commands
- drag-and-drop/file-picker filtering in the GUI
- clear user-facing error messages when a file is not acceptable for the chosen slot

## Scope

This is a **workout-package authoring** document, not a general engine media-support document.

It covers the currently relevant package media slots:

- song audio
- coaching overlay audio
- coaching warm-up video
- coaching cool-down video
- environment background image
- environment background video
- 3D environment GLB
- controlled advanced Gaussian splat environment payloads
- workout/package art images that logically belong in the current package scope

## Core rule

Every import decision must distinguish between:

1. **accepted source/import formats** — what the tools may ingest from the creator
2. **stored canonical package formats** — what the workout package keeps on disk after normalization

A file being acceptable for import does **not** mean it remains in that format inside the package.

## Locked stored canonical package formats

The current package-storage decisions remain locked:

- **song audio:** `.ogg`
- **coaching overlay audio:** `.ogg`
- **coaching warm-up / cool-down video:** `.ogv`
- **environment video:** `.ogv`
- **package/workout/environment images:** `.png`
- **3D environment:** vanilla `.glb`
- **controlled advanced Gaussian splat environment:** one validated splat payload stored self-contained inside the package; AeroBeat should prefer `.compressed.ply` as the official recommended package format, while `.ply`, `.splat`, and `.sog` remain compatibility-supported through GDGS

These are package-storage rules for the current workout-creation-tools slice.

## Canonical matrix

| Slot / domain | Typical package path area | Accepted source/import formats | Stored canonical package format | Import action | Notes for validation/tooling |
| --- | --- | --- | --- | --- | --- |
| Song audio | `media/audio/` | `.ogg`, `.wav`, `.mp3`, `.flac`, `.m4a`, `.aac` | `.ogg` | Copy if already-valid `.ogg`; otherwise transcode to canonical `.ogg` | Must be a single playable song asset for the `Song` record. Reject container/video files for this slot. Preserve enough quality for chart authoring/playback; exact encode presets can be tool-config detail later. |
| Coaching overlay audio | `media/coaching/` | `.ogg`, `.wav`, `.mp3`, `.flac`, `.m4a`, `.aac` | `.ogg` | Copy if already-valid `.ogg`; otherwise transcode to canonical `.ogg` | One final overlay clip per set under the current v1 coaching contract. Validation should ensure the referenced overlay exists and resolves through `coachingOverlayId`. |
| Coaching warm-up video | `media/coaching/` | `.ogv`, `.mp4`, `.webm`, `.mov` | `.ogv` | Copy if already-valid `.ogv`; otherwise transcode to canonical `.ogv` | Validation should enforce the existing coaching duration rule of **1:00 to 5:00 inclusive**. |
| Coaching cool-down video | `media/coaching/` | `.ogv`, `.mp4`, `.webm`, `.mov` | `.ogv` | Copy if already-valid `.ogv`; otherwise transcode to canonical `.ogv` | Same duration rule as warm-up: **1:00 to 5:00 inclusive**. |
| Environment background image | `media/environments/` | `.png`, `.jpg`, `.jpeg`, `.webp` | `.png` | Copy if already-valid `.png`; otherwise convert to canonical `.png`; allow crop/resize flow before final write when needed | Tooling should support the already-approved simple aspect-ratio crop flow for near-valid images instead of failing immediately for every sizing mismatch. |
| Workout/package art image | `media/art/` | `.png`, `.jpg`, `.jpeg`, `.webp` | `.png` | Copy if already-valid `.png`; otherwise convert to canonical `.png`; allow crop/resize flow before final write when needed | This covers immediately relevant package-scoped art such as a workout cover/thumbnail-style image stored inside the package. Keep the package canonical as `.png` even if downstream publishing surfaces later derive `.jpg` uploads. |
| Environment background video | `media/environments/` | `.ogv`, `.mp4`, `.webm`, `.mov` | `.ogv` | Copy if already-valid `.ogv`; otherwise transcode to canonical `.ogv` | Environment videos may loop if shorter than set playback. Longer videos are acceptable because the set ends the playback window. |
| 3D environment | `media/environments/` | `.glb` | `.glb` | Copy as-is after validation | Only accept **vanilla `.glb`** for the current package scope. Reject `.gltf` + sidecar asset sets to preserve self-contained package behavior. Reject Draco/KTX2 optimization requirements in this slice; those remain deferred. |
| Gaussian splat environment (controlled advanced path) | `media/environments/` | `.compressed.ply`, `.ply`, `.splat`, `.sog` | Prefer `.compressed.ply` as the official recommended package format; otherwise preserve one validated GDGS-compatible splat payload as-is inside the package | Copy as-is after format validation | Official package type is `splat`, but current support stays a controlled advanced lane. `.ply`, `.splat`, and `.sog` remain compatibility-supported through GDGS. Exported workouts must remain self-contained, and the current validated runtime path is desktop / Forward Plus / compute-bound rather than a broad cross-device guarantee. |

## Slot-by-slot implementation rules

### 1. Song audio

The song slot should accept common authoring-side audio sources, but the package should store one canonical `.ogg` file.

Tooling expectations:

- reject video containers when the user chooses a song-audio slot
- ensure the imported file resolves to the target song record
- normalize filename/path into the package naming scheme
- surface a clear error when the decoded asset is unreadable, empty, or unsupported by the import pipeline

### 2. Coaching overlay audio

Coaching overlay import should behave similarly to song audio at the file-format level, but with coaching-specific validation layered on top.

Tooling expectations:

- enforce audio-only input for this slot
- store canonical `.ogg`
- update the `overlayAudio` registry in `coaches/coach-config.yaml`
- keep per-set uniqueness rules in validator logic, not just import-time file acceptance

### 3. Coaching warm-up and cool-down video

Coaching video import is intentionally simple: creators can start from practical source video formats, and the tool normalizes the result to canonical `.ogv`.

Tooling expectations:

- accept common creator-side source video files
- reject audio-only files for video slots
- validate the coaching duration bounds after decode/import
- write canonical `.ogv` files and update `coaches/coach-config.yaml`

### 4. Environment background image

Environment image import should prioritize creator usability without weakening the package contract.

Tooling expectations:

- accept common still-image formats practical for creators today
- provide simple crop/resize assistance when aspect or dimensions are near-valid
- store canonical `.png`
- reject animated or multi-file image workflows in this first slice

### 5. Workout/package art image

The package already has a `media/art/` area, so package-scoped art images belong in this matrix when they are referenced by the workout package itself.

This document does **not** define every future consumer of that art. It only defines the package-authoring import/storage rule.

Tooling expectations:

- treat this as an image slot, not a free-form attachment bucket
- accept common source still-image formats
- normalize to canonical `.png`
- keep any mod.io or other storefront-specific export derivations outside the package canonical-storage rule

### 6. Environment background video

Environment videos follow the same accepted-source versus canonical-storage split as coaching videos.

Tooling expectations:

- accept common creator-side source video containers
- normalize to canonical `.ogv`
- validate the file is actually decodable and suitable for playback
- allow short looping backgrounds and longer backgrounds without treating set-length mismatch as an import failure

### 7. 3D environment GLB

The current package scope keeps 3D environment import intentionally narrow.

Tooling expectations:

- accept `.glb` only
- validate that the file is self-contained and readable
- reject `.gltf` plus loose textures/buffers for the current package contract
- reject optimization-side transformations as a baseline requirement

### 8. Gaussian splat environment

Gaussian splats are now an official package-facing environment type, but not a default beginner lane.

Tooling expectations:

- use `type: splat` for the record
- accept only the currently validated GDGS runtime-loader payload families: `.compressed.ply`, `.ply`, `.splat`, and `.sog`
- treat `.compressed.ply` as the official recommended AeroBeat splat payload when authors have a choice
- keep `.ply`, `.splat`, and `.sog` as compatibility-supported through GDGS rather than preferred package targets
- keep the stored package payload self-contained under `media/environments/` rather than relying on a remote catalog fetch
- validate and document that the current runtime path is desktop / Forward Plus / compute-bound
- avoid silently advertising splats as a cross-device baseline until broader runtime support is proven

## Actionable validation rules for future CLI/GUI tooling

Future import and validation tooling should implement the following posture:

### File-extension filtering is only the first gate

For every slot, tools should check:

1. file extension / picker filter
2. decodability / parser success
3. slot-category match
   - audio slot rejects video/image/3D inputs
   - video slot rejects audio/image/3D inputs
   - image slot rejects audio/video/3D inputs
   - GLB slot rejects non-GLB inputs
4. package-level policy rules for the slot
   - coaching duration bounds
   - package-local path normalization
   - expected YAML record/reference update

### Canonicalization rules

After acceptance, import should:

1. transcode or convert when needed
2. copy into the correct package folder
3. rename to the normalized slot-aware package filename
4. update the relevant YAML path reference
5. remove the superseded package asset when replacing an existing slotted file

### Suggested normalized filename direction

Examples:

- `song-audio-49189afea.ogg`
- `aria-neon-stride-overlay-49189afea.ogg`
- `coaching-warm-up-video-49189afea.ogv`
- `coaching-cool-down-video-49189afea.ogv`
- `environment-background-49189afea.png`
- `workout-cover-49189afea.png`
- `environment-loop-49189afea.ogv`
- `environment-3d-49189afea.glb`

The exact slugging rules can still be refined, but the slot-aware uid-suffixed naming direction remains the target.

## Explicit non-goals and deferrals

This document does **not** reopen the deferred optimization work.

Still deferred:

- KTX2 texture pipelines
- Draco-compressed GLB
- broader runtime-asset optimization requirements as a baseline authoring/import obligation

Those may become future tool capabilities, but they are not part of the current canonical workout-package import matrix.

## Recommended first-pass CLI implications

This matrix is designed to be directly consumable by future CLI surfaces such as:

- `song import-audio`
- `coach-config import-overlay-audio`
- `coach-config import-warmup-video`
- `coach-config import-cooldown-video`
- `environment import-image`
- `environment import-video`
- `environment import-glb`
- `workout import-cover-art`

The exact command names can evolve, but the slot-aware validation and canonicalization rules above should remain stable.
