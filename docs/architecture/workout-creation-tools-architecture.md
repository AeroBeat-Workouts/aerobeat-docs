# Workout Creation Tools Architecture

This document defines the current canonical architecture for AeroBeat workout creation tooling.

It builds on the already-locked package/content/tool lane decisions:

- authored workout truth lives in package YAML
- `aerobeat-content-core` owns durable content contracts
- `aerobeat-tool-core` plus concrete `aerobeat-tool-*` repos own authoring, validation, migration, packaging, and import workflows
- the first workout-creation product should cover the full package, while staying far away from becoming a general-purpose audio/video editor

## Purpose

The workout creation tools product exists to let creators author, inspect, validate, repair, migrate, import, and package a complete AeroBeat workout package.

That product includes both:

- **headless CLI workflows** for validation, migration, packaging, CI, and automation
- **interactive GUI workflows** for package editing, chart authoring, and guided media import

The product goal is **full package coverage**, not full media-production tooling.

## Locked architectural position

### Product/repo boundary

The workout creation tools live in their own concrete tool repo.

- canonical repo family: `aerobeat-tool-*`
- this workout-creation product is separate from `aerobeat-assembly-community`
- `aerobeat-assembly-community` may embed the tool as a user-facing mode through **GodotEnv**
- embedded mode is a desired UX/distribution path, but ownership remains with the separate tool repo

This preserves tool release cadence, testing boundaries, and ownership clarity.

### Tool-lane dependency boundary

The workout creation tools should:

- consume durable package/content contracts from `aerobeat-content-core`
- consume tool-common workflow/result contracts from `aerobeat-tool-core`
- expose creator-facing CLI and GUI entrypoints on top of shared workflow services

They should **not** redefine package schema locally, and they should **not** move package ownership into an assembly repo.

## CLI architecture

### Separate CLI tools early

The current locked direction is to use **separate CLI tools early**, one per YAML domain or workflow unit, rather than one large shared binary with deep subcommand trees.

Reasons:

- cleaner separation of concerns while the product is still evolving quickly
- easier targeted testing and debugging
- fewer hidden couplings between unrelated workflow surfaces
- a simpler path to domain-specific `validate`, `inspect`, and `fix` behavior

The package domains/workflow units currently in scope are:

- `workout`
- `song`
- `chart`
- `set`
- `coach-config`
- `environment`

The exact executable names can evolve, but the **domain split** should remain explicit.

### Validation boundary

Validation of one YAML file must **not** imply full-package validation.

The locked rule is:

- each domain tool validates its own authored record shape, local field rules, and directly referenced file existence as appropriate
- **package-wide workout validation** is orchestrated from the `workout` validation flow
- full workout validation is responsible for walking the package graph and invoking the relevant lower-level validators for referenced songs, charts, sets, coach config, environments, and package media/layout rules

That means `chart validate` is not secretly equivalent to `workout validate`, and `song validate` does not imply package integrity.

### Required CLI workflow categories

The minimum durable workflow categories remain:

- `validate`
- `inspect`
- `migrate`
- `package`
- `import`
- `fix`

Some of those may be domain-specific and some may be package-level orchestration surfaces, but the product should preserve headless capability for all of them.

### CLI repair policy

CLI validation should **hard-error** when the package or record is invalid, including when the issue is potentially fixable.

The CLI should then direct the user toward:

- a broad `--fix` path for safe structural/content repair
- more targeted `--fix-*` commands where useful for specific repair classes

Examples of issues that should fail validation and recommend repair instead of silently mutating during read/validate:

- invalid enums
- malformed beat payloads
- duplicate ids
- illegal package layout
- fixable out-of-date schema/content structure

The important boundary is that validation reports problems; repair is an explicit follow-up action.

## GUI architecture

### One scene per YAML file

The canonical first-pass GUI structure is **one Godot scene per YAML file/domain**:

- `workout`
- `song`
- `chart`
- `set`
- `coach-config`
- `environment`

This is a workflow-ownership decision, not a promise that every scene has equal complexity.

### Package-home UX

Opening a package should land on the **`workout.yaml` scene**.

That scene is the package-home / overview surface. It should:

- present package-level metadata and health
- surface package-wide validation/repair/import/package actions
- show navigation outward to the other package editors
- act as the main entrypoint for full-package operations

This matches the package contract where `workout.yaml` is the package root and orders the authored sets.

### Chart editor as the heavyweight specialized scene

The `chart` scene is the specialized high-complexity editor in the product.

It owns:

- audio-backed timeline/waveform scrubbing
- visual beat placement
- preview/playback
- chart creation against a chosen audio source
- future quick test entry from a selected timeline point after the normal set-start calibration path

By contrast, the other YAML scenes should mostly be **simpler form editors** with validation, media slotting, preview where useful, and links into related records.

### Bounded GUI scope

The GUI should support package creation and editing without turning into a full DAW, NLE, or 3D DCC.

Explicitly in scope:

- forms for package metadata and referenced records
- drag-and-drop / file-selection import flows
- validation errors with non-technical user-facing messaging
- chart editing with timeline/beat tooling
- image preview/cropping for environment/editor media flows
- desirable media preview for video where practical
- future GLB preview plus scale/rotation/orientation controls in the environment editor

Explicitly not in scope for this product slice:

- full audio editing/mixing
- full video editing
- broad media-production pipelines unrelated to package authoring
- runtime-asset optimization missions such as KTX2/Draco conversion as baseline authoring requirements

## Shared service rule

CLI and GUI surfaces should call the same underlying workflow services where possible.

That includes services for:

- validation
- repair/fix
- migration
- package assembly
- media import/normalization
- file replacement
- relationship/index refresh where needed

The GUI should not grow a second repair engine, and the CLI should not own private validation logic that the GUI cannot reuse.

## Media import and normalization architecture

### FFmpeg is a dependency

`ffmpeg` is a required dependency of the workout creation tools for media import/normalization workflows.

This is the canonical current direction for converting accepted source media into the stored canonical package formats.

### Import flow

When a user imports or replaces package media, the workflow should be:

1. validate the selected asset for the intended slot/purpose
2. convert to canonical stored format when needed
3. copy the resulting asset into the canonical package location
4. rename it to the normalized schema for that slot/domain, including a uid-suffixed filename
5. update the YAML reference(s) to the new canonical stored file
6. remove the superseded package asset when the user replaced an existing slotted file

Example naming direction:

- `coaching-warm-up-video-49189afea.ogv`
- `song-audio-49189afea.ogg`
- `environment-background-49189afea.png`

The exact naming schema can be refined later, but **normalized uid-suffixed canonical filenames** are locked.

### Accepted formats vs stored canonical formats

The docs must treat these as **separate concepts**:

- **accepted import formats**: the broader set of source file types the tools may ingest
- **stored canonical formats**: the narrower set of formats that workout packages actually keep on disk

Those accepted import formats should be documented separately from this architecture decision doc so the system can evolve import compatibility without muddying package-storage truth.

### Currently locked stored canonical formats

The currently locked package-storage formats are:

- **song audio:** `.ogg`
- **coaching audio:** `.ogg`
- **coaching video:** `.ogv`
- **environment video:** `.ogv`
- **images:** `.png`
- **3D environments:** vanilla `.glb`

These are storage decisions for the current package-authoring slice.

### Explicit optimization deferrals

The following are explicitly deferred side-missions, not baseline workout-creation-tool scope:

- KTX2 texture optimization
- Draco-compressed GLB
- broader runtime-asset optimization work beyond the current package canonical-format decisions

That work may matter later, but it should not be smuggled into the first workout-creation-tool scope.

### Image import nuance

For near-valid images that need packaging-friendly sizing/cropping, the preferred UX is a simple aspect-ratio marquee/crop flow before canonical conversion/storage, not immediate hard failure for every size mismatch.

### Environment media note

Environment videos may be shorter than the set audio and loop during playback. Longer videos are acceptable because playback ends when the set transitions.

## Repair / upgrade flows

### GUI repair policy

When the GUI opens an invalid or out-of-date package, it should:

1. clearly warn that repair may materially change the package
2. recommend retesting afterward
3. require explicit user confirmation before running repair
4. delegate to the full package `--fix` flow rather than performing silent ad hoc edits

This keeps the repair boundary honest and avoids accidental destructive mutation.

### CLI repair policy

The CLI should not auto-repair on plain validation.

Instead:

- `validate` should hard-error on fixable problems
- the error should recommend `--fix`
- targeted `--fix-*` flows may exist where useful
- package-wide repair orchestration belongs to the package/workout-level repair entrypoint

## Editor ownership boundaries by domain

### Workout scene

Owns:

- package metadata
- ordered set list
- package-wide validation, repair, migration, and packaging entrypoints
- top-level navigation to the package's other domains

### Song scene

Owns:

- song metadata fields
- canonical song audio slot/import
- validation of song-local record fields and referenced media

### Chart scene

Owns:

- chart timeline editing and beat placement
- playback preview and scrubbing
- future quick-test launch from selected timeline points
- chart-local validation and repair handoff

### Set scene

Owns:

- exact package-local composition wiring
- linking `songId`, `chartId`, `environmentId`, and optional `coachingOverlayId`
- form-based editing of composition references

### Coach-config scene

Owns:

- workout-level coaching enable/disable state
- roster, warm-up, cooldown, and overlay registry editing
- form-based media import/selection only

### Environment scene

Owns:

- environment record editing
- image/video/GLB import and preview helpers appropriate to the current scope

## Embedded assembly mode

The desired user-facing product experience includes an **embedded mode inside the main build**.

That means:

- the assembly can transition into the workout creation tools scenes
- the creator can navigate back out to the main game/application shell
- the tool still remains owned, versioned, and tested as a separate concrete tool repo imported via GodotEnv

Embedded availability is a UX/distribution decision, not an ownership merge.

## Non-goals

The current workout creation tools architecture does **not** promise:

- one universal binary that hides all workflow boundaries
- package-wide validation from every domain validator implicitly
- silent auto-repair on open or on validate
- an integrated full audio editor
- an integrated full video editor
- an integrated full 3D content creation suite
- current-scope KTX2/Draco optimization pipelines
- assembly ownership of the tool product

## Recommended implementation posture

Implementation should proceed in this order:

1. stand up the separate tool repo with shared workflow services plus separate CLI surfaces per domain
2. land package-home (`workout.yaml`) orchestration flows first so package validation/repair/import boundaries stay clean
3. ship the lower-risk headless workflow foundations across validation, inspect, fix, migrate, import, and packaging before scene work tries to own that logic
4. use Penpot to finalize the first-pass package-home and simpler form scene designs before polished GUI implementation begins
5. stand up the simpler form scenes (`song`, `set`, `coach-config`, `environment`) against the already-shipped shared services
6. build the heavyweight chart editor scene with waveform/timeline/preview/test-entry support
7. integrate the repo into `aerobeat-assembly-community` via GodotEnv for embedded access

That order preserves the full-package product goal while keeping repo/shared-service/headless foundations ahead of GUI work, while still treating Penpot as an important dependency for polished scene implementation.
