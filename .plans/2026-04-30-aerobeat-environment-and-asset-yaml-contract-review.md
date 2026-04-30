# AeroBeat Environment and Asset YAML Contract Review

**Date:** 2026-04-30  
**Status:** In Progress  
**Agent:** Chip 🐱‍💻

---

## Goal

Human-review and lock the first intentional YAML contracts for AeroBeat package-local `Environment` and `Asset` records, then roll the approved contracts into docs and the authoring validator/tooling.

---

## Overview

The shared chart-envelope direction is now in a much stronger place than it was a few days ago: Boxing, Flow, Dance, and Step have all been pressure-tested and deliberately locked into the current set-centered package model. The remaining weak spot is exactly what Derrick called out today: the existing `environments/*.yaml` and `assets/*.yaml` examples/docs were introduced before a human-verified contract review, so they should be treated as **proposals**, not settled truth.

This slice is therefore approval-first, not implementation-first. We should extract the actual currently implied Environment and Asset record shapes from the docs/example package, compare them against the locked package boundaries, and present them back for human consideration field-by-field. Only after Derrick explicitly approves both contracts should we execute the follow-up rollout: update the docs repo to teach the approved shapes consistently, then update `aerobeat-tool-content-authoring` documentation and validation logic so the tool enforces the locked contracts instead of the current intentionally shallow structural checks.

This plan also keeps the repo boundary honest. `aerobeat-docs` is the right home for the contract-review and docs-teaching slice because that is where the example package and current public contract teaching live. `aerobeat-tool-content-authoring` is the right home for the validation/doc-tooling follow-up once the contracts are approved. The package validator slice landed earlier today on purpose with deeper environment/asset semantics deferred until this exact human-review pass.

### Session Resume — 2026-04-30

Derrick approved execution of this plan and added the first hard contract goals that must shape the review:

- **Environment** records must support exactly three first-pass environment presentation types:
  - `godot_scene`
  - `image_background`
  - `video_background`
- Each **Set** links exactly one environment record.
- The environment record owns a `type` field selecting one of those three values.
- Runtime/assembly/build-specific display behavior stays outside the environment YAML contract. The engine and assembly repos decide how to render or downgrade the selected environment depending on platform/build settings, and athletes may still override environment/asset choices for performance or preference reasons.
- **Asset** records also need a clearly defined `type` field.
- A **Set** may reference multiple asset records, but a valid workout package may include **at most one asset record per asset type in a single Set**.

Those constraints are now part of the source-of-truth review target for Tasks 1-3. The next execution step is to reconstruct the currently implied docs contract, compare it to these newly locked rules, and return an approval-ready Environment + Asset contract proposal before any implementation rollout starts.

---

## REFERENCES

| ID | Description | Path |
| --- | --- | --- |
| `REF-01` | Canonical content model and current package boundaries | `projects/aerobeat/aerobeat-docs/docs/architecture/content-model.md` |
| `REF-02` | Package storage/discovery contract | `projects/aerobeat/aerobeat-docs/docs/architecture/workout-package-storage-and-discovery.md` |
| `REF-03` | Demo package walkthrough | `projects/aerobeat/aerobeat-docs/docs/guides/demo_workout_package.md` |
| `REF-04` | Demo package environment example | `projects/aerobeat/aerobeat-docs/docs/examples/workout-packages/demo-neon-boxing-bootcamp/environments/ab-environment-neon-rooftop.yaml` |
| `REF-05` | Demo package second environment example | `projects/aerobeat/aerobeat-docs/docs/examples/workout-packages/demo-neon-boxing-bootcamp/environments/ab-environment-sunrise-studio.yaml` |
| `REF-06` | Demo package asset example (`gloves`) | `projects/aerobeat/aerobeat-docs/docs/examples/workout-packages/demo-neon-boxing-bootcamp/assets/ab-asset-gloves-neon-pulse.yaml` |
| `REF-07` | Demo package other asset examples (`targets`, `obstacles`, `trails`) | `projects/aerobeat/aerobeat-docs/docs/examples/workout-packages/demo-neon-boxing-bootcamp/assets/` |
| `REF-08` | Current authoring-tool responsibilities plan | `projects/aerobeat/aerobeat-tool-content-authoring/.plans/2026-04-25-aerobeat-tool-content-authoring-responsibilities.md` |
| `REF-09` | Completed package-validation CLI slice plan | `projects/aerobeat/aerobeat-tool-content-authoring/.plans/archive/2026-04-30-aerobeat-package-validation-cli-slice.md` |
| `REF-10` | Active Step contract plan showing the now-locked chart boundary re: environment/assets outside chart YAML | `projects/aerobeat/aerobeat-docs/.plans/2026-04-30-aerobeat-step-chart-yaml-slice.md` |

---

## Tasks

### Task 1: Reconstruct the currently implied Environment YAML contract from docs/examples

**Bead ID:** `aerobeat-docs-by1`  
**SubAgent:** `primary` (for `research`)  
**Role:** `research`  
**References:** `REF-01`, `REF-02`, `REF-03`, `REF-04`, `REF-05`, `REF-10`  
**Prompt:** Inspect the current AeroBeat docs and checked-in example package to reconstruct the currently implied `Environment` YAML contract. Identify which fields are merely example data versus fields that are actually being taught or depended on, and prepare a human-review-ready recommendation for the exact first-pass environment record shape, required/optional fields, and boundaries that should remain outside the environment record.

**Folders Created/Deleted/Modified:**
- `.plans/`
- `docs/architecture/` only if a separate review note is justified

**Files Created/Deleted/Modified:**
- This plan file
- optional supporting review note if justified

**Status:** ✅ Complete

**Results:** Repo evidence review completed and the approval-prep recommendation is now captured here.

#### Task 1 Findings — approval-ready first-pass `Environment` YAML recommendation

**Evidence summary**

- `REF-01` and `REF-02` already lock the macro boundary: `Set` is the package-local composition linker, and each set must resolve exactly one `environmentId` through `environments/*.yaml`.
- `REF-04` and `REF-05` show the current example shape, but only two fields are clearly taught as stable identity fields: `environmentId` and `environmentName`. The other payload fields (`scenePath`, `lightingProfile`, `fogProfile`, `tags`) appear only inside the pre-review examples rather than as repo-wide documented contract language.
- `REF-02` deliberately keeps environment validation at the structural/reference layer and says environment records own "resource references needed to load the environment" rather than a locked runtime behavior model.
- The environment-creation guide teaches that authored environment internals may involve scenes, sky resources, baked lighting, reactive-light bindings, and other Godot content, but those are SDK/runtime resource concerns, not proof that every one of those knobs belongs in package YAML.
- `docs/gdd/meta/preferences.md` explicitly confirms that athlete environment overrides are real and should win at runtime when chosen; that override state therefore must stay outside the durable environment record.

**Recommended exact v1 record shape**

```yaml
schemaId: aerobeat.environment.v1
schemaVersion: 1
recordVersion: 1
createdByTool: aerobeat-tool-content-authoring
createdByToolVersion: 0.1.0
createdAt: 2026-04-25T22:00:00Z
updatedAt: 2026-04-27T13:00:00Z

environmentId: ab-environment-neon-rooftop
environmentName: Neon Rooftop
type: godot_scene
resourcePath: media/scenes/neon-rooftop.tscn
```

**Why this exact shape is the strongest first-pass recommendation**

- It preserves the already-taught authored-record schema/provenance block from `REF-01` and `REF-02`.
- It preserves the stable package identity pair already shown in `REF-04` and `REF-05`: `environmentId` + `environmentName`.
- It adds Derrick's now-locked `type` discriminator without inventing runtime-specific substructures.
- It collapses the current example-only `scenePath` idea into one generic `resourcePath`, which better matches the doc language in `REF-02` (resource references needed to load the environment) and scales cleanly across the three approved first-pass environment types:
  - `godot_scene`
  - `image_background`
  - `video_background`

**Required durable fields**

- shared schema/provenance block:
  - `schemaId`
  - `schemaVersion`
  - `recordVersion`
  - `createdByTool`
  - `createdByToolVersion`
  - `createdAt`
  - `updatedAt`
- identity:
  - `environmentId`
  - `environmentName`
- payload contract:
  - `type`
  - `resourcePath`

**Optional durable fields in v1**

- **None recommended.**

That is the cleanest approval target because the repo does not currently prove a stable need for optional environment YAML metadata beyond the core identity + typed payload pointer. If future runtime-agnostic authored metadata becomes clearly necessary, it can be added in a later version instead of freezing speculative fields now.

**Current example fields that should *not* be treated as durable v1 contract yet**

- `scenePath`
  - useful as an example for a Godot-scene-backed environment
  - not strong enough as the durable cross-type contract field name once image/video environments are explicitly in scope
- `lightingProfile`
  - currently example-only vocabulary with no shared enum, schema, or cross-doc semantics
  - risks smuggling assembly/runtime display policy into authored content
- `fogProfile`
  - same problem as `lightingProfile`
  - currently descriptive/example flavor, not a repo-backed contract term
- `tags`
  - currently example metadata only
  - not referenced by the package boundary docs as required authored truth
  - discoverability/indexing belongs in derived systems, not silently in package YAML unless explicitly approved later

**Validation rules that belong in the contract**

1. File must live under `environments/` and parse as one environment record.
2. `schemaId` must equal `aerobeat.environment.v1`.
3. `schemaVersion` and `recordVersion` must be valid integers for the approved v1 contract.
4. `environmentId` must be present, non-empty, and unique within the package's environment records.
5. `environmentName` must be present and non-empty.
6. `type` must be present and must be exactly one of:
   - `godot_scene`
   - `image_background`
   - `video_background`
7. `resourcePath` must be present, non-empty, package-local, and resolve to an existing file.
8. `resourcePath` must match the selected `type` at the file-family level:
   - `godot_scene` → scene resource path (currently `.tscn`)
   - `image_background` → image file path
   - `video_background` → video file path
9. Every set must reference exactly one valid `environmentId` from `environments/` (`REF-01`, `REF-02`, `REF-10`).
10. Environment records must remain reusable package-local records; they do not point back to sets, workouts, songs, or charts.

**What should remain outside the environment YAML contract**

- runtime/assembly/build-specific rendering behavior, downgrade behavior, fallback selection, quality tiers, and platform-specific display policies
- athlete/profile preference overrides such as force-a-specific-environment behavior
- feature/runtime interpretation of how a `godot_scene` environment is instantiated in portal vs track vs XR vs menu contexts
- deep internals of the referenced Godot environment content (`AeroEnvironment` resource structure, sky assignment, reactive light arrays, baked GI details, node graphs, etc.)
- any future performance heuristics such as triangle budgets, draw-call thresholds, or automatic baking checks; those belong in tooling/runtime validation layers, not the durable YAML record itself

**Recommended doc implementation consequence once approved**

- Treat the current example environment YAMLs in `REF-04` and `REF-05` as pre-approval proposals.
- On rollout, normalize them to the approved shape by introducing `type` and replacing `scenePath` with `resourcePath`.
- Drop `lightingProfile`, `fogProfile`, and `tags` from the canonical v1 example unless Derrick explicitly chooses to promote any of them into contract later.

**Net recommendation for Derrick's review**

Approve a deliberately small first-pass environment contract: **identity + type discriminator + one package-local payload pointer**. The docs support that. They do **not** yet support freezing environment-style metadata like fog/lighting/tag taxonomies into v1.

---

### Task 2: Reconstruct the currently implied Asset YAML contract from docs/examples

**Bead ID:** `aerobeat-docs-tkq`  
**SubAgent:** `primary` (for `research`)  
**Role:** `research`  
**References:** `REF-01`, `REF-02`, `REF-03`, `REF-06`, `REF-07`, `REF-10`  
**Prompt:** Inspect the current AeroBeat docs and checked-in example package to reconstruct the currently implied `Asset` YAML contract. Identify the real durable v1 asset-record shape, the locked `assetType` enum usage, which metadata/tags are just examples versus durable contract, and what validation/boundary rules belong in the record versus in set composition or runtime interpretation.

**Folders Created/Deleted/Modified:**
- `.plans/`
- `docs/architecture/` only if a separate review note is justified

**Files Created/Deleted/Modified:**
- This plan file
- optional supporting review note if justified

**Status:** ✅ Complete

**Results:** Reviewed `REF-01`, `REF-02`, `REF-03`, `REF-06`, `REF-07`, and `REF-10` plus the related package/example/GDD wording that describes asset intent. Approval-ready first-pass recommendation:

- **Proposed exact record shape**

  ```yaml
  schemaId: aerobeat.asset.v1
  schemaVersion: 1
  recordVersion: 1
  createdByTool: aerobeat-tool-content-authoring
  createdByToolVersion: 0.1.0
  createdAt: 2026-04-25T22:00:00Z
  updatedAt: 2026-04-30T16:00:00Z

  assetId: uid
  assetName: string
  type: gloves | targets | obstacles | trails
  resourcePath: media/assets/.../file.ext
  ```

- **Required fields**
  - shared schema/provenance block already taught across the package examples
  - `assetId`
  - `assetName`
  - `type`
  - `resourcePath`

- **Optional fields**
  - **none in the first-pass durable contract**
  - The checked-in `metadata` and `tags` examples are useful flavor/example data, but current docs do not teach them as loader/validator/runtime contract and nothing else in the repo depends on them.

- **`assetType` vs `type`**
  - Recommend **rename the record field to `type`**.
  - Reason: Derrick’s locked rule now requires a clearly defined `type` field; environment is moving to the same pattern; chart rows already use `type`; and the real closed contract is the enum values, not the longer property name.
  - Keep the existing v1 **enum values** unchanged: `gloves`, `targets`, `obstacles`, `trails`.
  - After approval, docs/examples/validator text that currently says `assetType` should be updated to describe the same enum under `type` instead.

- **Which current example fields are durable contract vs example-only**
  - **Durable contract:** `assetId`, `assetName`, enum-validated `type`, `resourcePath`, plus the shared schema/provenance fields.
  - **Example-only / non-durable today:** the current `metadata.palette`, `metadata.style`, and `tags` arrays. They teach theme, not stable package semantics.
  - The file extension differences in examples (`.glb`, `.tres`) should also remain example data, not part of the YAML contract beyond “path must exist and be package-local.”

- **Validation that belongs in the asset record itself**
  - `schemaId` must be `aerobeat.asset.v1`.
  - `schemaVersion` / `recordVersion` must be valid integers under the shared record rules.
  - `assetId` must exist and be unique within the package.
  - `assetName` must exist and be non-empty.
  - `type` must exist and be one of `gloves`, `targets`, `obstacles`, `trails`.
  - `resourcePath` must exist, be non-empty, stay package-local, and resolve to a real file.

- **Validation that belongs in Set/package composition, not in the asset record itself**
  - A Set may reference **multiple asset records**.
  - A Set may include **at most one asset record per asset type**.
  - Every asset id referenced by a Set must resolve to an asset record.
  - The Set-side asset selection key/reference must match the referenced asset record’s `type`.
  - Asset reuse across multiple Sets is valid.
  - Feature-specific “this Set type should/should not use gloves/targets/obstacles/trails” remains composition/runtime policy, not record-shape policy, unless Derrick later wants stricter per-feature package validation.

- **What must remain outside the asset YAML contract**
  - runtime spawning/rendering behavior
  - engine/build/platform downgrade logic
  - assembly-specific bindings from authored asset type to scene/material/component implementation
  - athlete preference overrides (for example forcing preferred high-contrast targets or different gloves)
  - scoring/gameplay semantics already owned by chart + feature runtime rather than by the asset record
  - thumbnails, marketplace/discovery decoration, and other browse/index concerns unless later explicitly promoted into package contract

- **Why this shape best matches the current docs**
  - `REF-01` and `REF-02` already teach that Sets own composition and that asset records are reusable typed package-local records with one resource path.
  - The demo package and overview docs consistently teach a **closed four-value asset-type enum** and **zero-or-one selection per asset type per Set**.
  - GDD/user-content docs reinforce that assets are optional themed visuals that athletes may override, which argues against baking runtime/prefs/rendering policy into the asset YAML itself.

Validated references: `REF-01`, `REF-02`, `REF-03`, `REF-06`, `REF-07`, `REF-10`; also consistent with `docs/gdd/glossary/terms.md`, `docs/gdd/user-content/community-creations.md`, and `docs/gdd/user-content/overview.md`.

---

### Task 3: Human review and approval of both contracts

**Bead ID:** `aerobeat-docs-5ak`  
**SubAgent:** `primary` (for `research`)  
**Role:** `research`  
**References:** `REF-01` through `REF-10`  
**Prompt:** Turn the Environment and Asset contract reconstruction into a concise Derrick-facing review packet: proposed schema shape, required and optional fields, exact boundaries, open questions, and a recommended approval-ready version for each YAML family. Stop for explicit human approval before any contract-teaching or validator changes are executed.

**Folders Created/Deleted/Modified:**
- `.plans/`
- optional review note location if justified

**Files Created/Deleted/Modified:**
- This plan file
- optional review packet note if justified

**Status:** ✅ Complete

**Results:** Added the next approval-step environment analysis packet below, specifically addressing whether `type: godot_scene` is a sound first-pass contract choice for package content.

#### Task 3 Findings — targeted `godot_scene` viability analysis for environment packages

**Short answer**

- **Yes, Godot can straightforwardly load and instantiate a `PackedScene` that is already part of the exported project or a loaded Godot resource pack.** That path is normal engine behavior.
- **No, that does not automatically mean "arbitrary external Godot scenes from a user-authored loose package folder" are a good first-pass runtime contract.** Raw external `.tscn` / `.scn` loading is where dependency/import/path stability becomes fragile.
- **If AeroBeat wants the authored package folder itself to be directly consumable at runtime without a separate Godot import/build step, `godot_scene` is not the safest first v1 contract.** A narrower resource family such as `.glb` for 3D geometry/media-backed environments is materially safer.
- **If AeroBeat is willing to require a known Godot packaging/import flow before runtime use** (for example: author in package form -> validate -> import/build in a Godot environment -> ship/load as a PCK/ZIP or other pre-imported assembly-owned artifact), then `godot_scene` can still be viable **under strict constraints**.

**What local AeroBeat docs already imply**

- `REF-01` / `REF-02` keep the authored package contract intentionally small: environment records are reusable package-local records selected by Sets and they own only identity plus resource references.
- `REF-02` also explicitly says the current validator should stay at the **structural/reference** layer and avoid pretending deeper runtime semantics are settled yet.
- The checked-in example package uses `.tscn` scene paths today, but those example files were already being treated as **proposal inputs**, not final proof that raw Godot scenes are the correct durable v1 environment payload.
- `docs/guides/environment_creation.md` teaches a classic Godot-authoring workflow: import `.glb` / `.gltf`, build a `Node3D` scene, create an `AeroEnvironment` resource, then pack/export it. That is evidence that the environment authoring story is **editor/import driven**, not evidence that a shipping assembly can safely consume any loose arbitrary scene file dropped beside a package YAML.
- `docs/architecture/cloud_baker.md` already points toward a future import/build pipeline boundary: authored package/source assets can be validated/imported in a temporary Godot environment and then turned into runtime/distribution artifacts later.

**Grounded Godot 4 reality**

1. **Scenes already included in the exported app or in a loaded Godot resource pack are easy.**
   - If a scene and all of its dependencies are already imported and present under `res://`, loading a `PackedScene` is standard (`load()` / `ResourceLoader.load()` then `instantiate()`).
   - Godot's official pack/mod docs also support loading a separate PCK/ZIP with `ProjectSettings.load_resource_pack(...)`, after which those imported resources behave like normal `res://` assets.

2. **Loose external Godot resources are a different story.**
   - Godot's own runtime-file-loading docs explicitly frame loose runtime loading as better suited to formats like images, audio/video, and external 3D model files rather than project-native imported resource workflows.
   - The Godot proposal discussion around external runtime importing exists precisely because many formats normally rely on the **editor import pipeline** before they behave like regular resources in exported builds.
   - A `.tscn` can be text-parsed as a scene format, but in practice its referenced subresources often assume Godot-style project-relative paths, imported companions, and resource types that were already prepared in a Godot project context.

3. **Dependency and path coupling are the main fragility.**
   - A scene rarely stands alone. It may reference meshes, materials, textures, animations, sky resources, lightmap artifacts, shader resources, custom resources, and potentially scripts.
   - Those references may be relative, `res://` rooted, or point at imported artifacts generated by the editor.
   - If AeroBeat consumes loose package folders directly, the engine/runtime must now answer: what project path are these scenes loaded under, how are transitive dependencies resolved, and which imported sidecar artifacts are guaranteed to exist?

4. **Editor import matters a lot for scene-backed content.**
   - Godot's import pipeline converts many source assets into runtime-usable/import-optimized forms and generates metadata/sidecars the exported game relies on.
   - That is much less of a problem for file families Godot can load directly at runtime from disk, such as images, Ogg/video streams, or glTF/GLB through the documented runtime-loading APIs.
   - It is a bigger problem for "arbitrary unknown Godot scene package content" because the scene may transitively depend on assets that were only ever intended to exist after editor import.

5. **GLB is materially better for loose runtime loading than `.tscn`.**
   - Godot 4 exposes runtime glTF loading through `GLTFDocument` / `GLTFState` and also teaches runtime loading of external 3D model content in the official docs.
   - A `.glb` package payload is much narrower: one model container, fewer Godot-project-specific assumptions, better interoperability with DCC tools, and a cleaner security/stability story than a general scene file that may reference many Godot-native resource types.
   - `.glb` does not solve every environment need by itself (custom light rigs, Godot-only nodes/resources, gameplay-reactive authoring metadata), but it is a much saner first-pass geometry contract if the runtime must ingest loose external package content directly.

**Security / stability / modding risk profile**

- **Scripts are the red-line risk.** AeroBeat docs already ban scripts in community packages (`docs/architecture/workflow.md`, `docs/architecture/cloud_baker.md`). A `godot_scene` contract increases the surface area where script references or other engine-owned content can sneak in unless validation is quite strict.
- Even without scripts, a scene can still depend on unexpected resource graphs, unsupported node types, renderer-heavy content, broken references, or editor-only assumptions.
- `godot_scene` therefore raises the burden on validation and build tooling much earlier than image/video/GLB-style payloads do.
- In other words: `godot_scene` is not just "one file path like any other". It is potentially a whole Godot project-shaped dependency graph disguised as one record pointer.

**What is technically straightforward**

- **Straightforward today**
  - `godot_scene` that is already imported and shipped in the assembly or loaded from a Godot-created PCK/ZIP pack.
  - `image_background` and `video_background` from package-local files.
  - `glb`/`gltf`-style environment geometry loaded through documented runtime model-loading paths.

- **Not straightforward today**
  - "Take any arbitrary package-local `.tscn` someone authored elsewhere, with arbitrary dependencies, and load it directly in an exported game from a loose package folder".
  - Doing that robustly without a controlled import/build pipeline, strict path conventions, and deep validation.

**Decision recommendation for Derrick**

### Recommended default: do **not** treat arbitrary loose `godot_scene` as the v1 environment-runtime contract

If the intent of the YAML contract is: *"this authored package folder is the installable content unit, and the runtime should be able to consume it directly"*, then the safer v1 move is:

- keep the **small record shape** from Task 1 (`environmentId`, `environmentName`, `type`, `resourcePath`)
- but **narrow the allowed runtime-facing environment payload families** to things Godot can load more predictably from loose files:
  - `image_background`
  - `video_background`
  - preferably a narrower 3D geometry/media type such as **`glb_scene`** or a renamed equivalent instead of `godot_scene`

That gives AeroBeat a cleaner first implementation target and avoids prematurely committing the package contract to raw Godot scene semantics that probably want a build pipeline.

### Acceptable alternative: keep `godot_scene`, but only with a strict interpretation

If Derrick wants to preserve `godot_scene` in the contract now, I recommend approving it **only with language like this**:

- `godot_scene` does **not** mean an arbitrary unknown `.tscn` from any folder can be loose-loaded by any exported AeroBeat assembly.
- It means a **package-local Godot scene authored for the AeroBeat environment pipeline** whose dependencies are contained within the same package boundary and whose content is either:
  - imported/validated in a known Godot authoring/build step before runtime use, or
  - distributed via a Godot-native pack/mod flow where the scene and all dependencies are already imported and packaged as normal Godot resources.
- Community package validation must reject script-bearing scene graphs and should likely restrict allowed node/resource families.
- Runtime repos/assemblies remain free to downgrade, reject, or prebake these scenes per platform.

Under that interpretation, `godot_scene` is less a promise of **loose direct runtime ingestion** and more a promise of **authored source shape for a controlled pipeline**.

### Session Resume — 2026-04-30 (creator-pipeline follow-up)

Derrick wants the environment decision grounded in a **real creator workflow**, not just an engine-capability answer. That means the next approval step is not merely choosing `godot_scene` vs `.glb`; it is determining what authoring pipelines AeroBeat can responsibly recommend to:

### Session Resume — 2026-04-30 (Environment v1 approved for rollout)

Derrick approved the Environment v1 decision and explicitly chose the safer first-pass path:

- lock the Environment record to the small typed shape already proposed,
- lock the v1 `type` enum to:
  - `image_background`
  - `video_background`
  - `glb_environment`
- do **not** include `godot_scene` in the baseline v1 package contract,
- treat `godot_scene` instead as a future advanced controlled-pipeline / build-managed lane,
- proceed now with updating the docs and `aerobeat-tool-content-authoring` validator/tooling to lock environments around that approved v1 shape.

Asset-contract execution remains separate; the immediate implementation scope is environment locking.

- environment artists building directly in Blender / traditional 3D workflows,
- creators using AI-assisted environment generation,
- creators using photogrammetry,
- creators using Gaussian Splat capture / reconstruction workflows.

The research question is therefore: for each of those source pipelines, what is the most realistic and supportable path into Godot/AeroBeat, what runtime form should AeroBeat prefer (`glb`, image, video, controlled `godot_scene`, baked outputs, etc.), and what should the docs tell creators to use or avoid.

This follow-up should produce a creator-facing recommendation matrix, not implementation yet.

**My recommendation**

- **Best first-pass contract if AeroBeat wants direct runtime consumption of authored package folders:** use a narrower geometry/media contract (preferably `.glb` for 3D, plus image/video), not arbitrary `godot_scene`.
- **Best first-pass contract if AeroBeat is comfortable requiring a build/import/mod-pack pipeline before runtime:** `godot_scene` is viable, but only as constrained package-local authored content, not as a generic loose-file runtime-loading claim.

**Practical approval guidance**

1. **If simplicity and fast validator/runtime rollout matter most:** downgrade the 3D environment payload from `godot_scene` to a narrower `glb`-style type for v1.
2. **If preserving richer Godot-authored environment expressiveness matters most:** keep `godot_scene`, but document it as a controlled-pipeline type and explicitly avoid promising arbitrary loose-scene runtime loading.
3. In either case, keep Task 1's small YAML record shape. The real decision is not the field structure anymore; it is the semantics of the 3D payload family behind `resourcePath`.

---

### Task 3A: Research AI-assisted environment creation pipelines into Godot/AeroBeat

**Bead ID:** `aerobeat-docs-6xw`  
**SubAgent:** `primary` (for `research`)  
**Role:** `research`  
**References:** `REF-01`, `REF-02`, `REF-04`, `REF-05`, plus `docs/guides/environment_creation.md` and the Task 3 findings above  
**Prompt:** Research realistic AI-assisted creator pipelines for AeroBeat environments. Focus on what an environment artist or workout creator could actually use today to go from AI generation toward a Godot/AeroBeat-friendly environment artifact. Pressure-test outcomes like 2D image backgrounds, AI-generated video backgrounds, image-to-3D / text-to-3D outputs, AI-assisted mesh/material generation, and where Blender/Godot cleanup becomes mandatory. Recommend what AeroBeat docs should steer creators toward versus away from.

**Folders Created/Deleted/Modified:**
- `.plans/`
- supporting note only if justified

**Files Created/Deleted/Modified:**
- This plan file
- optional research note if justified

**Status:** ✅ Complete

**Results:** Completed the creator-facing AI-environment pipeline research and recommendation pass below.

#### Task 3A Findings — realistic AI-assisted environment creation guidance for Godot/AeroBeat

**Bottom line**

AI can help AeroBeat creators most reliably today in **three narrow ways**:

1. **Generate 2D background art** that ships as an image.
2. **Generate stylized looping background video** that ships as a video.
3. **Generate rough 3D starting points** that a human cleans in Blender/Godot before export, usually as `GLB`.

The hype path is: **"prompt once, get a finished performant 3D gameplay environment ready for mobile/VR."** That is not a responsible creator promise today.

**Why this recommendation fits current AeroBeat docs**

- The local docs already keep environment YAML intentionally small and package-local (`REF-01`, `REF-02`) and teach a Godot-editor-centered environment workflow rather than arbitrary magic runtime ingestion (`docs/guides/environment_creation.md`).
- Community packages ban scripts and should avoid deep engine-owned runtime behavior in content payloads (`docs/architecture/workflow.md`, `docs/architecture/cloud_baker.md`).
- Godot's own docs make the practical file-family split clear:
  - loose/runtime-loaded **images** are straightforward,
  - loose/runtime-loaded **3D models** are most naturally discussed as `glTF/FBX`-style assets,
  - core **video playback** is limited to **Ogg Theora (`.ogv`)**,
  - arbitrary project-native resource flows are better handled through import/build/pack pipelines than by pretending every loose Godot-native resource is equally safe/easy.

**Reality check by creator path**

### 1. 2D still-image backgrounds

**What AI is good at today**

- mood boards
- matte-painting-style backdrops
- stylized skies, cityscapes, neon arenas, forests, abstract light tunnels
- rapid variation generation for art direction

**Typical creator workflow**

- generate with an image model/tool
- clean up in Photoshop/Krita/GIMP
- crop/extend for target aspect ratios
- optionally convert into a panorama / skybox plate
- import as an AeroBeat environment background image

**What is realistic**

- **Very realistic today.**
- This is the safest, fastest AI-assisted environment path for non-technical workout creators.
- Especially strong for flat or far-distance environments where no close inspection/parallax is required.

**Limitations**

- not genuinely 3D
- limited parallax
- obvious artifacts if the player can get too close or if the camera/view expects depth
- VR immersion is weaker than a true 3D space

**Recommended AeroBeat payload**

- `type: image_background`
- `resourcePath: media/art/...` or similar image path

**Docs stance**

- **Recommend** this path.
- Position it as the easiest creator-friendly way to get a polished environment quickly.
- Encourage human paintover/cleanup before shipping.

---

### 2. AI-generated video backgrounds

**What AI is good at today**

- animated neon loops
- abstract motion backdrops
- scenic ambient plates
- music-reactive-feeling motion that is visually rich but not interactive

**Typical creator workflow**

- generate short clips with an AI video tool
- trim/loop in a video editor
- stabilize color/flicker if needed
- transcode to the actual runtime-supported format
- use as a background plane/screen/subviewport-driven backdrop

**What is realistic**

- **Realistic, but only for non-interactive background use.**
- Good for menu scenes, distant screens, tunnel walls, skyline plates, or flat backdrops.
- Bad as a substitute for a true navigable/6DoF environment.

**Important Godot constraint**

- Godot core video playback currently supports **Ogg Theora (`.ogv`)** in the built-in path.
- So even if creators generate `.mp4`/`.mov`, AeroBeat docs should teach that these are usually **source files**, not the final package payload.

**Limitations / risks**

- no true depth or collision
- loop seams and temporal warping artifacts
- can look bad in VR if treated like a real world instead of a distant surface
- heavier storage/bandwidth than a single image
- easy to overuse in a way that feels like a music visualizer rather than an environment

**Recommended AeroBeat payload**

- `type: video_background`
- `resourcePath` should point to the shipped playback file, ideally `.ogv` if using core Godot playback

**Docs stance**

- **Cautiously allow** this path.
- Recommend it for ambient motion backgrounds, not for primary 3D world geometry.
- Explicitly say creators should expect format conversion and looping cleanup.

---

### 3. Image-to-3D / text-to-3D generation

**What AI is good at today**

- rough concept meshes
- stylized props
- kitbash ingredients
- fast exploration of shape language
- occasional low-detail room/blockout inspiration

Official tool marketing and current product pages from tools such as Meshy/Tripo strongly emphasize browser generation plus exports like `GLB`/`FBX`/`OBJ`, which matches the idea that these tools are best treated as **upstream generators feeding a normal DCC pipeline**, not as the final runtime contract themselves.

**What is realistic**

- **Useful as a starting point, not as a one-click final environment path.**
- Works best for:
  - props
  - set dressing
  - stylized background structures
  - simple hero objects after cleanup
- Weak for:
  - fully playable finished scenes
  - accurate topology
  - predictable UVs/materials
  - clean collision-friendly geometry
  - mobile/VR-ready optimization without human intervention

**Human cleanup is usually mandatory**

Creators should assume they will need Blender work for some combination of:

- decimation / retopo
- fixing normals
- UV cleanup
- rebaking textures
- reauthoring materials
- separating or combining meshes sensibly
- setting scale/pivot/origin
- removing floating junk geometry

**Recommended AeroBeat payload**

- preferred first-pass payload: **`GLB`** (or equivalent narrow geometry type if Derrick wants to rename it)
- only use a controlled `godot_scene` form **after** human cleanup/assembly in Godot and only if AeroBeat decides that environment type belongs to a controlled import/build pipeline rather than loose direct runtime ingestion

**Docs stance**

- **Cautiously allow** this path.
- Teach it as **"generate -> clean in Blender -> export GLB -> validate"**.
- Steer creators away from believing the raw AI output is shipping-ready.

---

### 4. AI-assisted mesh / material / texture generation with human cleanup

**What AI is good at today**

This is the most practically useful 3D lane:

- generating texture ideas / variants
- creating emissive/noise/detail maps to polish a manually built scene
- producing concept geometry that artists rebuild or simplify
- assisting kitbash workflows
- helping with skybox plates, signage, decals, and surface inspiration

**What is realistic**

- **Very realistic when a human artist remains in the loop.**
- This is stronger than full text-to-final-3D because the creator can constrain scope and clean results.
- Best fit for AeroBeat's aesthetic needs: stylized, performance-conscious, readable environments rather than photoreal simulation.

**Recommended creator workflow**

- block out scene traditionally in Blender/Godot
- use AI to accelerate textures, decals, signage, surface variations, prop ideas, and background forms
- bake/clean materials
- export final geometry as `GLB`
- if richer Godot-only assembly is needed, convert that cleaned content into a controlled Godot scene during the editor/build step

**Recommended AeroBeat payload**

- **`GLB`** for geometry-first packages
- **image files** for texture/background inputs where the package contract exposes them indirectly through the environment asset
- **controlled `godot_scene` or prebaked build output** only when AeroBeat intentionally routes the content through a Godot import/build pipeline

**Docs stance**

- **Recommend** this path for advanced creators.
- Present it as the best balance of creativity, control, and realistic shipping quality.

---

## Recommended creator-facing guidance matrix

### Recommend

1. **AI-assisted 2D still-image backgrounds**
   - easiest
   - safest
   - lowest tooling burden
   - best v1 payload: `image_background`

2. **AI-assisted traditional 3D workflow with Blender cleanup**
   - most realistic path to good custom 3D environments
   - best v1 payload: `GLB` (or equivalent narrow geometry type)
   - optionally becomes controlled `godot_scene` only through a curated pipeline

### Cautiously allow

3. **AI-generated looping video backgrounds**
   - good for motion-heavy backdrop use
   - best v1 payload: `video_background`
   - docs must warn about `.ogv` conversion and non-interactive limitations

4. **Raw image-to-3D / text-to-3D outputs as starting points**
   - acceptable only with explicit cleanup expectations
   - best v1 payload after cleanup: `GLB`

### Steer creators away from

5. **"Prompt-to-finished fully playable environment" expectations**
   - too inconsistent
   - too hard to optimize
   - not trustworthy enough for mobile/VR performance targets

6. **Loose arbitrary `godot_scene` output directly from AI tools**
   - wrong abstraction level for creators
   - too much dependency/path/import fragility
   - too easy to smuggle unsupported complexity into a single file pointer

7. **Using AI video as if it were a true 3D world**
   - fine for distant ambience
   - bad for close, interactive, or VR-critical geometry

8. **Experimental direct-runtime formats like Gaussian splats for first-pass creator docs**
   - promising research area, not stable first-pass creator guidance
   - if ever supported, likely better as a prebaked/converted pipeline rather than the main v1 package payload

---

## Recommended AeroBeat payload policy by path

| Creator path | Realistic today? | Recommended payload | Docs stance |
| --- | --- | --- | --- |
| AI still image / matte background | Yes | `image_background` | Recommend |
| AI ambient video / loop | Yes, with limits | `video_background` (shipped in Godot-compatible playback format) | Cautiously allow |
| AI text/image-to-3D raw output | Only as a starting point | cleaned `GLB` | Cautiously allow |
| AI-assisted artist-built 3D scene | Yes | `GLB`, optionally controlled `godot_scene` after build/import | Recommend |
| Direct loose AI-generated Godot-native scene graph | Not responsible as a default promise | avoid as loose v1 payload | Steer away |
| Direct Gaussian splat runtime content | Not mature enough for first-pass docs | prebaked output only, if at all | Defer / steer away |

---

## Approval-oriented recommendation for Derrick

If AeroBeat wants creator docs that are honest and shippable:

1. **Recommend image backgrounds as the easiest AI path.**
2. **Allow video backgrounds for ambient motion, with explicit format/VR caveats.**
3. **Recommend AI-assisted 3D only when Blender/Godot cleanup is part of the documented workflow.**
4. **Prefer `GLB` as the main 3D handoff artifact for community-authored environments.**
5. **Keep `godot_scene` reserved for controlled/editor/baked pipelines, not as the default raw AI-output handoff.**
6. **Do not market full prompt-to-playable-environment as a reliable creator story.**

That gives AeroBeat a creator-facing story that is useful today without overpromising on immature 3D generation tech.

---

### Task 3B: Research photogrammetry pipelines into Godot/AeroBeat

**Bead ID:** `aerobeat-docs-pkn`  
**SubAgent:** `primary` (for `research`)  
**Role:** `research`  
**References:** `REF-01`, `REF-02`, `REF-04`, `REF-05`, plus `docs/guides/environment_creation.md` and the Task 3 findings above  
**Prompt:** Research realistic photogrammetry-to-Godot pipelines for AeroBeat environments. Focus on creator-accessible capture tools, cleanup/retopo/optimization expectations, export formats, and whether the end result is best treated as a GLB-style environment, baked image/video background, or controlled Godot-authored environment. Recommend what AeroBeat docs should steer creators toward versus away from.

**Folders Created/Deleted/Modified:**
- `.plans/`
- supporting note only if justified

**Files Created/Deleted/Modified:**
- This plan file
- optional research note if justified

**Status:** ✅ Complete

**Results:** Added the approval-ready photogrammetry recommendation packet below.

#### Task 3B Findings — photogrammetry creator pipeline recommendation

**Bottom-line recommendation**

Photogrammetry is a **realistic source pipeline** for AeroBeat environments, but the docs should frame it as a **capture -> reconstruction -> cleanup/optimization -> export -> optional Godot dressing** workflow, not as a raw-scan-direct-to-runtime story.

For first-pass creator docs, AeroBeat should recommend this default outcome order:

1. **Best default for playable 3D environments:** export the cleaned result as **GLB environment geometry**.
2. **Best fallback when the scan is visually nice but too heavy/messy for gameplay:** convert it into a **baked image or short looping video background**.
3. **Use controlled `godot_scene` content only when the creator is intentionally doing a Godot authoring pass** after cleanup/import, such as adding lighting, reactive lights, gameplay-safe boundaries, and other AeroBeat-specific dressing.

That aligns better with both the local docs and Godot reality than recommending arbitrary loose photogrammetry scenes as direct `godot_scene` runtime payloads.

**Why this matches current local AeroBeat docs**

- `REF-01` and `REF-02` already keep the package contract small and set-centered. They do not require environment YAML to encode scan-specific internals.
- `docs/guides/environment_creation.md` already teaches a creator workflow that begins with imported `.glb` / `.gltf`, then assembles a Godot scene, then configures an `AeroEnvironment` resource. That is a strong sign that **photogrammetry should usually enter AeroBeat through a cleaned interchange asset first**, not through a raw scanner-native project format.
- `docs/architecture/performance.md` is explicit that rhythm gameplay prioritizes frame pacing over fidelity, with strict draw-call and polycount budgets and a no-stutter loading rule.
- `docs/architecture/cloud_baker.md` and `docs/architecture/workflow.md` reinforce that community content should stay data-driven, script-free, and safe to validate/import/build later.

**Grounded tool/path research highlights**

- RealityScan/RealityCapture can export to common interchange formats including **GLB**, OBJ, FBX, PLY, DAE, and USD, and its docs note that if a model is simplified it must be **retextured** before texture export again. That matches the real photogrammetry cleanup loop rather than a one-click final-runtime asset story.
- Blender's official docs confirm the **Decimate** modifier is a standard way to reduce face count with minimal shape changes, and Cycles baking supports normal/AO/lighting-related texture baking workflows that are exactly what scanned assets usually need when going from high-poly to game-usable.
- Godot's docs say it supports importing 3D scenes from common formats and call out runtime custom-level/model loading as a better fit for **glTF/FBX-style external models** than for arbitrary project-native imported assets. Godot's export considerations also explicitly recommend **triangulating before export** and generally doing final lighting work in Godot rather than assuming imported lighting will be ideal.
- Blender's glTF docs reinforce why glTF/GLB is attractive here: it is designed for real-time delivery, automatically triangulates on export, and carries meshes/materials/textures in a runtime-friendly interchange format.

**Recommended creator-accessible workflow stages**

### 1. Capture

**Docs should recommend**

- Treat photogrammetry as best for **static real-world spaces or props with rich surface detail**.
- Prefer scans of spaces with:
  - even, diffuse lighting
  - lots of visual texture/features for alignment
  - minimal moving people/foliage/shadows
  - enough clearance to capture overlapping angles
- Use creator-accessible tools such as:
  - phone-first capture apps/workflows (for example Polycam / RealityScan-class capture)
  - camera-photo workflows feeding desktop reconstruction tools
  - higher-end capture only as an advanced path, not the baseline docs expectation

**Docs should discourage**

- glossy, transparent, reflective, or LED-heavy scenes as a first attempt
- active gyms, crowds, mirrors, glass walls, foliage, or moving sunlight/shadows
- trying to capture a complete giant arena as one first-pass environment
- assuming messy lighting can be fixed later without cost

### 2. Reconstruction

**Recommended tooling stance**

- Allow a range of reconstruction tools, but teach categories rather than hard-locking one vendor:
  - **creator-friendly / paid:** RealityCapture-class tools, Polycam-style exports
  - **free/open path:** Meshroom-class workflows where creators can tolerate slower/rougher results
- Tell creators to export the first reconstruction as a **high-detail working mesh**, not the final game asset.

**Docs should teach**

- Reconstruction output is usually the **source mesh** for cleanup, not the runtime deliverable.
- Preserve the highest-quality textured master until optimization is done.

### 3. Cleanup / retopo / decimation

This is the stage the docs should emphasize hardest. Raw scan meshes are rarely acceptable as-is for a rhythm-game environment.

**Recommended default path**

- Import the reconstructed mesh into **Blender**.
- Delete junk geometry, floaters, and badly reconstructed regions.
- Separate the environment into sensible chunks only if needed for cleanup or rebaking.
- Use **decimation** for rough reduction.
- For assets the player will get close to, perform **manual or guided retopo** when decimate-only output becomes ugly or unstable.
- Rebuild or clean UVs if the scan UVs are too fragmented for practical baking.

**Approval-oriented docs guidance**

- **Recommend:** decimation for large static background surfaces where exact topology is less important.
- **Recommend with caution:** manual retopo for hero structures, collision-sensitive areas, or silhouettes the player will notice.
- **Discourage:** shipping the original multi-million-triangle scan, even on PC-first assumptions.
- **Discourage:** preserving every micro-detail in geometry instead of baking it into textures/normal maps.

### 4. Texture/material baking

**Recommended default**

- Bake high-poly scan detail onto the optimized mesh.
- Prefer a game-ready material set centered on:
  - base color / albedo
  - normal map
  - ambient occlusion
  - roughness / metallic only where actually useful
- Treat photogrammetry color as a starting point, not sacred final truth. Creators may need cleanup for seams, exposure mismatches, shadows baked into albedo, or ugly color casts.

**Docs should teach**

- If the creator simplifies/retopologizes the mesh, **rebaking/retexturing is part of the normal workflow**, not a failure case.
- Aggressively preserve perceived detail in **textures**, not raw triangles.
- Avoid over-complicated multi-material setups when one or a few consolidated materials will do.

### 5. Export formats

**Recommended v1 export preference order**

1. **GLB** — best default interchange/runtime-facing format for cleaned 3D photogrammetry environments.
2. **glTF + external textures** — acceptable when creators need inspectable separate files, but less tidy than GLB.
3. **FBX/OBJ** — acceptable intermediate/DCC interchange, but not the preferred final docs story for AeroBeat package content.
4. **Scanner-native project formats / raw dense meshes / point clouds** — not recommended as package/runtime targets.

**Why GLB should be the default docs recommendation**

- cleaner creator story
- good Blender/Godot interoperability
- real-time-engine-friendly interchange
- lower ambiguity than raw Godot-scene dependency graphs
- closer to the local environment-creation guide, which already starts from imported 3D assets before Godot assembly

### 6. Blender/Godot integration

**Recommended split of responsibilities**

- **Blender owns:** cleanup, decimation, retopo, UV work, rebaking, export preparation.
- **Godot owns:** final scene assembly, gameplay-safe placement, lighting decisions, reactive-light authoring, and any AeroBeat-specific environment dressing.

**Docs should recommend**

- Import the cleaned **GLB** into Godot.
- Do final scale/orientation/collision sanity checks there.
- Add Godot-native lighting, fog, sky, reactive lights, and player-safe boundaries in the Godot pass rather than trying to preserve scanner lighting as runtime truth.
- Only graduate from GLB geometry to `godot_scene` when the creator intentionally wants a managed Godot-authored environment setup.

**When photogrammetry outputs fit each AeroBeat environment form best**

### Best treated as **GLB environment geometry**

Use this when:

- the creator wants a navigable 3D play space
- the scan has been cleaned and reduced to a game-appropriate budget
- the environment benefits from depth/parallax
- the creator is willing to do Blender cleanup and at least a light Godot import pass

This should be the **primary docs recommendation** for photogrammetry-based 3D environments.

### Best treated as **baked image/video backgrounds**

Use this when:

- the scan looks good from a constrained viewpoint but the geometry is too noisy/heavy
- the environment is mostly scenic backdrop, not interactive geometry
- the creator wants faster results with much lower runtime risk
- the target platform includes lower-end mobile/standalone VR where stable performance matters more than free camera movement

This is the right recommendation for many creator scans that are aesthetically cool but structurally poor.

### Best treated as **controlled `godot_scene` content**

Use this only when:

- the photogrammetry result is already cleaned and usually imported from GLB/gltf first
- the creator wants to add Godot-authored structure on top: lights, animated dressing, gameplay-safe blockers, custom sky/fog, reactive bindings, or platform-specific tuning
- AeroBeat is willing to treat the final result as **pipeline-managed Godot content**, not an arbitrary loose scene file dropped straight into runtime

In other words, photogrammetry should usually become `godot_scene` **after** a clean asset pipeline, not **instead of** one.

**Performance pitfalls the docs should call out explicitly**

1. **Raw scan density is hostile to rhythm-game frame pacing.**
   - Multi-million triangle outputs are normal in photogrammetry and are not an acceptable gameplay default.
2. **Draw-call explosion from fragmented materials/submeshes.**
   - Scan cleanups often preserve too many materials or object fragments.
3. **Huge textures and memory pressure.**
   - 8K/16K texture sets are common and can quickly become absurd for mobile/VR.
4. **Baked lighting/shadows embedded in textures.**
   - This can fight Godot-authored reactive lights and make the environment feel dead or visually dirty.
5. **Messy silhouettes and collision from decimate-only cleanup.**
   - Cheap decimation helps, but without spot retopo the environment may still look broken at player distance.
6. **Occlusion/culling assumptions failing on monolithic meshes.**
   - One giant welded scan mesh can be awkward to stream, cull, light, and optimize.
7. **Loose scan realism fighting gameplay readability.**
   - Environments with clutter everywhere can obscure targets and reduce contrast.
8. **Shader hitch risk from too many unique materials.**
   - This conflicts with AeroBeat's local "pre-warm and zero stutter" performance direction.

**What the docs should recommend vs discourage**

### Recommend

- photogrammetry for **static atmospheric spaces** and set dressing, not for gameplay logic
- a **scan -> Blender cleanup -> baked textures -> GLB export** default
- rebaking detail from high-poly to optimized low-poly meshes
- converting weak scans into image/video backgrounds instead of forcing bad 3D
- a final Godot dressing pass only when needed for AeroBeat-specific lighting and presentation
- conservative texture/material counts and strong contrast/readability over literal realism

### Cautiously allow

- controlled `godot_scene` environments built from photogrammetry-derived assets after cleanup/import
- PC-first or showcase environments that exceed mobile-friendly budgets, as long as docs clearly frame them as advanced/non-baseline
- selective higher detail near the player when the rest of the environment is aggressively simplified

### Discourage

- direct use of raw reconstruction meshes as package/runtime content
- scanner-native scene/project formats as the AeroBeat content contract
- assuming photogrammetry is the easiest path for complete playable environments
- environments that keep real-world clutter, baked shadows, or busy detail at the cost of target readability
- one huge scan mesh with many materials and giant textures as the default creator story

**Approval recommendation for Derrick**

If AeroBeat wants a realistic creator story for photogrammetry, the docs should explicitly endorse:

- **photogrammetry as a supported source pipeline**
- **GLB as the default first-pass 3D delivery shape**
- **image/video backgrounds as the preferred escape hatch** when scans are pretty but not game-ready
- **controlled `godot_scene` only as an advanced Godot assembly step** after the scan has already been cleaned and normalized

That keeps the docs creator-friendly without accidentally promising that raw scan outputs or arbitrary loose Godot scenes are suitable first-pass runtime content.

---

### Task 3C: Research Gaussian Splat pipelines into Godot/AeroBeat

**Bead ID:** `aerobeat-docs-qxw`  
**SubAgent:** `primary` (for `research`)  
**Role:** `research`  
**References:** `REF-01`, `REF-02`, `REF-04`, `REF-05`, plus `docs/guides/environment_creation.md` and the Task 3 findings above  
**Prompt:** Research realistic Gaussian Splat capture/reconstruction pipelines for AeroBeat environments and whether Godot/AeroBeat can support them sanely. Focus on current Godot support maturity, packaging/runtime implications, performance constraints, export/interchange limitations, and whether splats should be treated as direct runtime content, prebaked geometry/media, or avoided for first-pass creator docs.

**Folders Created/Deleted/Modified:**
- `.plans/`
- supporting note only if justified

**Files Created/Deleted/Modified:**
- This plan file
- optional research note if justified

**Status:** ✅ Complete

**Results:** Added the Gaussian-splat creator-pipeline review below.

#### Task 3C Findings — Gaussian Splat pipelines into Godot/AeroBeat

**Bottom line**

- **Gaussian Splat capture/reconstruction is real and useful today as a capture workflow, but it is not a good first-pass direct-runtime environment format for AeroBeat.**
- For AeroBeat's current docs assumptions, splats fit best as either:
  1. **an upstream capture/reconstruction step** that is later converted into more standard deliverables such as **mesh + textures (`.glb` / Godot scene)**, or
  2. **prebaked media** such as image/video backgrounds when the goal is visual ambiance rather than navigable 3D space.
- **Do not recommend raw splats as the primary v1 environment payload** for package-local runtime loading.
- If AeroBeat ever supports splats directly, treat that as a **future advanced desktop-only / controlled-pipeline feature**, not as a baseline creator path.

**Why this matters relative to local AeroBeat docs**

- `docs/guides/environment_creation.md` teaches a Godot-native environment workflow centered on imported `.glb` / `.gltf`, scene assembly, baked lighting, and export into an `AeroEnvironment` resource packed into a `.pck`.
- That same guide sets explicit performance expectations for mobile/VR-class targets: **visible geometry under ~50k triangles**, **< 50 draw calls**, **avoid heavy realtime GI**, and a package flow that assumes validated Godot/editor-owned assets.
- `REF-01` / `REF-02` keep environment YAML intentionally small and structural. That is good news here: it means AeroBeat does **not** need to promise that every plausible capture representation is directly loadable at runtime.
- The current package and docs shape already favors **stable, conventional payloads** over exotic runtime formats.

**Current Godot support maturity**

**What exists today**

- There is **no built-in Godot Gaussian Splat pipeline** comparable to normal mesh/material/scene import.
- Current Godot splat support is coming from **community plugins / experimental viewers**, not from a settled first-party engine asset path.
- The strongest current Godot plugin signal I found is `ReconWorldLab/godot-gaussian-splatting` (`gdgs`):
  - plugin version `2.2.0`
  - requires **Godot 4.4+**
  - requires **Forward Plus**
  - requires a **desktop GPU with compute shader support**
  - supports imported splat assets like `.ply`, `.compressed.ply`, `.splat`, `.sog`
  - renders through **CompositorEffect**, explicitly outside Godot's native mesh pipeline
  - repo notes its target is **desktop Forward Plus only** and says **mobile renderers are not supported**
- Other Godot projects found (`2Retr0/GodotGaussianSplatting`, `haztro/godot-gaussian-splatting`) are even more clearly **viewer/demo/experimental** in character:
  - `2Retr0` literally describes itself as a **toy viewer** and highlights compute-shader rendering / VRAM characteristics
  - `haztro` is a Godot 4.6 viewer implementation, not an ecosystem-standard import/runtime path

**Practical maturity assessment**

- **Maturity for research/demo use:** promising
- **Maturity for desktop-only art-tech experimentation:** plausible
- **Maturity for an AeroBeat creator-facing recommended baseline:** **not there yet**
- **Maturity for AeroBeat's implied cross-device/mobile/VR package contract:** **not acceptable today**

That mismatch matters a lot because local AeroBeat docs are not aimed at a “desktop RTX-only experimental showcase” audience.

**Runtime and performance implications**

**The positive case**

- Splats can look excellent for captured real spaces and difficult materials.
- They can avoid some of the failure cases of traditional photogrammetry, especially for reflective/low-texture areas.
- The raw viewing performance of good splat renderers can be impressive on desktop GPUs.

**The AeroBeat-relevant downside**

- Splat rendering is generally a **special rendering path**, not “just another mesh.”
- Godot plugin implementations rely on **compute shaders + compositor integration**, which already narrows platform support.
- The strongest Godot plugin evidence explicitly excludes **mobile renderer support** and assumes desktop-class GPU capability.
- One Godot viewer example (`2Retr0`) cites a desktop 3060 Ti running a benchmark scene at high performance while using **multiple gigabytes of VRAM**. Even if that is a good demo result, it is the wrong performance shape for AeroBeat's likely mod-friendly baseline.
- AeroBeat's environment guide is optimized for **mobile phones and VR headsets**. Raw splats currently pull in the opposite direction: desktop GPU heavy, compositor-dependent, and less aligned with predictable draw-call/triangle budgeting.

**Approval-oriented conclusion on runtime**

- **Do not design the v1 environment recommendation around raw splat runtime rendering.**
- If splats are mentioned at all, they should be framed as **capture source material**, not as the expected shipping runtime representation.

**Packaging and interchange formats**

**What the ecosystem looks like right now**

- Raw splat interchange is still fragmented:
  - `.ply` remains common but large and not standardized specifically for shipping splat content across engines
  - plugin ecosystems often add variants such as `.compressed.ply`, `.splat`, `.sog`
  - Niantic's open `.spz` format is promising because it is marketed as roughly **10x smaller than equivalent PLY** with minimal perceptual loss, but it is still a **splat-specific ecosystem format**, not a general Godot-native content primitive
- Coordinate-system and runtime compatibility details are still real integration work. Even the SPZ reference docs talk about coordinate-system conversion choices across ecosystems.
- By contrast, AeroBeat's existing environment guidance already has a much cleaner path for **`.glb` / `.gltf` -> Godot scene/resource -> packaged environment**.

**What that means for AeroBeat**

- Supporting direct splat payloads would force AeroBeat to choose and document a **specific splat interchange family** far earlier than the rest of the content model currently needs.
- That would create new validation, platform policy, importer, preview, and fallback burden for a format family that is still evolving.
- This is exactly the kind of complexity `REF-02` has been wisely avoiding by keeping environment records structural rather than overpromising runtime semantics.

**Creator workflow complexity**

A realistic creator workflow for splats today usually looks more like this:

1. **Capture** with a mobile or cloud tool such as Scaniverse / KIRI-style video capture.
2. **Reconstruct** into a splat representation (`.ply`, `.spz`, etc.).
3. **Inspect / trim / clean** in a splat editor/viewer (for example browser-based tools such as PlayCanvas SuperSplat or vendor tooling).
4. Then choose one of three exits:
   - **Exit A: keep as splat** and target a splat-capable renderer
   - **Exit B: convert to mesh** and continue in Blender/Godot as a standard asset
   - **Exit C: render out media** (video / stills / skybox-like imagery) for a lightweight background path

For AeroBeat, **Exit A is the hard part**. It demands that the engine/runtime/package validator all understand splat-specific behavior.

**Exit B and Exit C are much saner.**

- Mesh conversion workflows now exist in commercial/research tooling. The current industry pitch is essentially: **capture with splats, ship as mesh when you need standard engine compatibility.**
- That matches AeroBeat's current docs much better.
- It also lets creators keep the splat as a high-fidelity source artifact while still producing a conventional deliverable for the game.

**Direct splat support vs converting splat-derived data**

### Option 1: Direct splat runtime content

**Pros**
- Maximum fidelity to the original capture
- Great for showcase scenes and difficult materials
- Potentially fast on the right desktop GPU

**Cons**
- Godot support is plugin-based and experimental, not first-class
- Current evidence points to **desktop compute / Forward Plus only** rather than AeroBeat's broader target assumptions
- Packaging formats are fragmented
- Validation burden is high
- Runtime fallback / downgrade policy becomes messy
- Harder to reason about athlete-facing performance consistency
- Puts AeroBeat in the business of owning a niche rendering path early

**Recommendation**
- **Do not recommend as first-pass environment creation for AeroBeat.**
- At most, keep it on a future roadmap as an advanced, constrained, opt-in path.

### Option 2: Convert splat-derived data into standard 3D payloads

**Typical result**
- splat capture/reconstruction -> mesh extraction / retopo / cleanup -> texture bake -> `.glb` or controlled Godot-authored scene

**Pros**
- Fits AeroBeat's existing Godot docs and package assumptions
- Much easier to validate, optimize, and package
- Easier cross-platform story
- Lets creators use Blender/Godot cleanup and normal performance profiling
- Keeps direct-runtime semantics in standard engine territory

**Cons**
- Conversion loses some of the raw “magic” of direct splat rendering
- Cleanup is often mandatory
- Thin/transparent/reflective areas may still need manual help after conversion

**Recommendation**
- **Best overall recommendation for AeroBeat if creators want to start from Gaussian-splat capture.**
- Treat splats as a **source acquisition format**, not the final package payload.

### Option 3: Convert splat captures into prebaked image/video backgrounds

**Typical result**
- capture/reconstruct with splats -> render hero angles / loops / panoramas -> package as `image_background` or `video_background`

**Pros**
- Lowest runtime complexity
- Very creator-friendly for “looks cool behind the workout” use cases
- Strong match for the newly approved first-pass environment types already in plan discussion
- Avoids 3D runtime burden entirely

**Cons**
- Loses navigable 3D presence / parallax
- Less reusable for gameplay-aware staging
- Not appropriate when the environment needs interactive geometry meaningfully present in 3D space

**Recommendation**
- **Good fallback or even preferred recommendation** when the creator goal is mood/ambience rather than physically authored 3D play space.

**Recommended AeroBeat docs position**

### Recommended wording direction

- **Recommended:** traditional 3D environments authored as standard geometry/assets (`.glb` / Godot scene pipeline)
- **Cautiously allowed:** splat-based capture as a **source step** if the creator converts/bakes the result into standard deliverables before shipping
- **Deferred / not recommended for first pass:** direct raw Gaussian Splat runtime environments

### Practical policy recommendation

1. **Do not add a Gaussian Splat environment `type` to the first-pass YAML contract.**
2. If Gaussian Splats are mentioned in creator docs, describe them as:
   - useful for rapid reality-capture / difficult-surface acquisition
   - **not** the preferred direct package payload today
   - best converted into either:
     - a **standard 3D asset** (`.glb` / Godot-authored environment), or
     - an **image/video background**
3. If Derrick wants a future exploration path, frame it as a follow-up item like:
   - **desktop-only experimental splat environment support via controlled Godot plugin + approved interchange format + explicit fallback policy**
   - not part of baseline package authoring docs

**Final recommendation for Derrick's approval**

- **Gaussian Splatting should not be a first-pass AeroBeat-supported direct runtime environment workflow.**
- AeroBeat **can acknowledge splats as an upstream capture/reconstruction technique**, especially for creators scanning real places or hard-to-photogrammetry surfaces.
- The docs should recommend one of two shipping outcomes:
  - **preferred:** convert splat-derived captures into standard mesh/textured assets for the normal Godot environment pipeline
  - **secondary/lightweight:** bake them down into image/video background media
- In short: **support the capture idea, not the raw runtime format — yet.**

---

### Task 3D: Synthesize the environment creator-pipeline recommendation matrix

**Bead ID:** `aerobeat-docs-1av`  
**SubAgent:** `primary` (for `research`)  
**Role:** `research`  
**References:** `REF-01` through `REF-10`, Task 3 findings, and Tasks 3A-3C outputs  
**Prompt:** Turn the environment contract and creator-pipeline research into a Derrick-facing recommendation matrix. Compare traditional 3D/Blender, AI-assisted generation, photogrammetry, and Gaussian Splat paths by creator accessibility, Godot import/runtime viability, recommended AeroBeat payload type, performance risk, modding/tooling complexity, and whether the docs should recommend, cautiously allow, or defer each path.

**Folders Created/Deleted/Modified:**
- `.plans/`
- supporting note only if justified

**Files Created/Deleted/Modified:**
- This plan file
- optional research note if justified

**Status:** ✅ Complete

**Results:** Added the Derrick-facing synthesis below.

#### Task 3D Findings — Derrick-facing environment creator-pipeline recommendation matrix

**Executive summary**

The creator-pipeline research converges on a simple first-pass rule: **AeroBeat should prioritize payload forms that are easy to validate, easy to explain to creators, and predictable for Godot runtime performance.** That points to:

- **recommending** `image_background` for the easiest creator path,
- **recommending** standard cleaned 3D geometry as the main serious 3D path,
- **cautiously allowing** `video_background` where motion ambience helps,
- **reserving** `controlled godot_scene` for advanced curated/pipeline-managed cases,
- and **deferring** raw Gaussian Splat runtime content for now.

The biggest design lesson is that the best **source pipeline** is not always the best **package payload**. Photogrammetry and Gaussian Splat capture may both be useful upstream, but AeroBeat's docs should still steer creators toward a smaller set of safe shipping forms: image, video, cleaned geometry, and only selectively Godot-authored scene content.

### Recommendation matrix

| Creator path | Best AeroBeat payload form | Docs stance | Godot/runtime viability | Creator accessibility | Performance risk | Package / validator complexity | Contract safety | Why this is the recommendation |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Traditional 3D / Blender pipeline | **GLB-style 3D geometry** by default; **controlled `godot_scene`** only after intentional Godot assembly | **Recommend** | Strong for GLB import and normal Godot scene assembly; predictable toolchain | Moderate for experienced 3D creators; lower for non-artists | Medium, but manageable with known cleanup/export discipline | Moderate for GLB; higher for `godot_scene` | Strong for GLB; moderate for controlled `godot_scene` | This is the most mature and controllable path. It fits the existing Godot environment-creation guide and gives AeroBeat the cleanest serious 3D creator story. |
| AI-assisted still backgrounds | **`image_background`** | **Recommend** | Very strong; simplest runtime story | High; easiest path for non-technical creators | Low | Low | Very strong | Fastest path from idea to shippable environment mood. Minimal runtime risk, minimal validator burden, and the contract stays simple and safe. |
| AI-assisted video backgrounds | **`video_background`** | **Cautiously allow** | Viable for ambient/background use, but constrained by Godot playback format/path and non-interactive nature | High to moderate | Medium (storage, decode, loop quality, VR mismatch) | Low to moderate | Strong if kept as pure media | Good for motion ambience, but not a substitute for 3D space. Docs should allow it with format, looping, and "distant backdrop only" caveats. |
| AI-assisted 3D generation with cleanup | **GLB-style 3D geometry** after cleanup; `controlled godot_scene` only as an advanced downstream step | **Cautiously allow** | Viable only after Blender/Godot cleanup; raw outputs are unreliable | Moderate; approachable but still requires real cleanup skill | Medium to high before cleanup; medium after cleanup | Moderate | Moderate once cleaned; weak if treated as raw direct payload | AI is useful as a starting point, not a trustworthy final environment generator. Docs should explicitly teach "generate -> clean -> export" rather than "prompt -> ship." |
| Photogrammetry | **GLB-style 3D geometry** by default; fallback to **`image_background`** or **`video_background`** when scans are too heavy/noisy; `controlled godot_scene` only after cleanup/import | **Cautiously allow** | Strong after reconstruction cleanup and export to standard geometry; weak as raw scan/runtime content | Moderate; capture is accessible, optimization is not trivial | High before cleanup; medium after disciplined optimization | Moderate to high | Moderate to strong once normalized into standard deliverables | Photogrammetry is real and useful, but raw scans are a poor runtime contract. Docs should support the source pipeline while steering shipping output toward cleaned geometry or baked media. |
| Gaussian Splat capture / reconstruction | **Defer/avoid** as direct payload; if used upstream, convert to **GLB-style 3D geometry** or bake to **`image_background` / `video_background`** | **Defer for now** | Weak for baseline AeroBeat support today; plugin-dependent, desktop-leaning, not aligned with first-pass cross-device assumptions | Moderate for capture, low for reliable game-ready delivery | High | High | Weak as a first-pass direct contract | Splats are promising as capture tech, but current Godot support, packaging, performance, and validator complexity make them the wrong default creator/runtime story right now. |

### Path-by-path approval notes

#### 1. Traditional 3D / Blender pipeline

**Recommended payload:** `GLB`-style 3D geometry first; `controlled godot_scene` only when AeroBeat intentionally wants a Godot-authored assembly pass.

**Classification:** **Recommend**

**Reasoning**

- **Godot/runtime viability:** This is the most stable and understood path. Blender -> GLB -> Godot import is conventional, and a later Godot assembly step is predictable when done intentionally.
- **Creator accessibility:** Harder than images/video, but it is the standard serious 3D workflow and the one most likely to produce durable results.
- **Performance risk:** Real, but manageable through familiar game-art discipline: budgets, baking, material consolidation, collision sanity, and cleanup.
- **Package/validator complexity:** A narrow geometry contract is much easier to validate than arbitrary Godot-native scene graphs.
- **Contract safety:** Strong, because the YAML can stay small and point to a conventional artifact rather than an engine-specific dependency graph.

**Net:** This should be the primary recommended 3D creator path in first-pass docs.

#### 2. AI-assisted still/video backgrounds

##### Still images

**Recommended payload:** `image_background`

**Classification:** **Recommend**

**Reasoning**

- **Godot/runtime viability:** Excellent. Simple file load, simple fallback story, simple authoring story.
- **Creator accessibility:** Best in class. This is the most accessible path for non-technical creators.
- **Performance risk:** Lowest of all paths.
- **Package/validator complexity:** Minimal.
- **Contract safety:** Very strong.

**Net:** This should be the easiest first-pass creator recommendation, especially for early community packages.

##### Video backgrounds

**Recommended payload:** `video_background`

**Classification:** **Cautiously allow**

**Reasoning**

- **Godot/runtime viability:** Good enough for ambient motion backgrounds, but not equivalent to real geometry.
- **Creator accessibility:** Quite approachable, especially for AI video tools plus simple editing.
- **Performance risk:** Higher than images because of decode/storage and possible VR discomfort or loop artifacts.
- **Package/validator complexity:** Still fairly low if the contract only points to compatible video media.
- **Contract safety:** Strong as long as it stays pure media and does not pretend to encode 3D semantics.

**Net:** Allow it, but teach it as an ambience/background technique, not a general environment replacement.

#### 3. AI-assisted 3D generation with cleanup

**Recommended payload:** cleaned `GLB`-style 3D geometry; optionally `controlled godot_scene` only after a real cleanup/import/assembly pass.

**Classification:** **Cautiously allow**

**Reasoning**

- **Godot/runtime viability:** Acceptable only after human cleanup. Raw AI 3D outputs are too inconsistent to make a safe default contract promise.
- **Creator accessibility:** Better than fully manual modeling, but still demands real DCC/Godot skill to produce shippable output.
- **Performance risk:** Raw outputs are often topology-heavy, material-chaotic, and optimization-poor.
- **Package/validator complexity:** Moderate if AeroBeat only sees the cleaned final artifact; much worse if it tries to support raw tool outputs directly.
- **Contract safety:** Fine after normalization to GLB; weak if the contract is widened to accommodate tool-specific intermediate junk.

**Net:** Docs should position AI 3D as an accelerator for experienced creators, not as a one-click beginner path.

#### 4. Photogrammetry

**Recommended payload:** cleaned `GLB`-style 3D geometry by default; `image_background`/`video_background` if the scan is attractive but not gameplay-ready; `controlled godot_scene` only after cleanup/import when extra Godot dressing is intentional.

**Classification:** **Cautiously allow**

**Reasoning**

- **Godot/runtime viability:** Good after standard cleanup/export. Poor as raw scan data or arbitrary scan-scene payloads.
- **Creator accessibility:** Capture is easier than modeling from scratch, but optimization and cleanup are still skilled work.
- **Performance risk:** High if raw; manageable only after decimation/retopo/rebake/material cleanup.
- **Package/validator complexity:** Reasonable once converted to standard deliverables, but not if raw scan-specific complexity leaks into the contract.
- **Contract safety:** Good if the contract only sees normalized outputs; risky if it tries to encode photogrammetry-specific details.

**Net:** Support photogrammetry as an upstream source pipeline, but keep the package contract centered on standard deliverables.

#### 5. Gaussian Splat capture / reconstruction

**Recommended payload:** **defer/avoid** as a direct v1 payload. If creators use splats upstream, require conversion to cleaned geometry or baked media.

**Classification:** **Defer for now**

**Reasoning**

- **Godot/runtime viability:** Too plugin-dependent and platform-constrained for a baseline first-pass AeroBeat contract.
- **Creator accessibility:** Capture is becoming more accessible, but producing reliable cross-device runtime content is not.
- **Performance risk:** High and hard to reason about within AeroBeat's likely mobile/VR-friendly constraints.
- **Package/validator complexity:** High. It would force AeroBeat to standardize niche formats, renderer assumptions, fallback policy, and import validation too early.
- **Contract safety:** Weak for v1 because the direct payload semantics are neither stable nor simple.

**Net:** Mention splats as promising research or upstream capture tech, but do not make them part of the baseline first-pass environment contract or primary creator guidance.

### Recommended first-pass mapping from creator path -> contract payload

If Derrick wants the smallest, safest approval target, the docs should teach this mapping:

- **Still art / matte / panorama creators -> `image_background`**
- **Animated backdrop creators -> `video_background`**
- **Serious 3D environment creators (traditional, AI-assisted-with-cleanup, photogrammetry-after-cleanup) -> GLB-style 3D geometry**
- **Advanced curated Godot authors -> controlled `godot_scene`, explicitly described as advanced/pipeline-managed rather than the default community handoff**
- **Gaussian Splat creators -> convert/bake first; do not target raw direct payload support yet**

### What first-pass docs should recommend vs allow vs defer

**Recommend**

- `image_background`
- Traditional 3D / Blender -> cleaned GLB-style 3D geometry
- AI-assisted 3D only when framed as a cleanup-heavy variant of the normal 3D pipeline

**Cautiously allow**

- `video_background`
- Photogrammetry, but only when normalized into cleaned geometry or baked media
- `controlled godot_scene` for advanced creators using a deliberate Godot assembly/import path

**Advanced-only**

- `controlled godot_scene` as a package-facing environment type, because it carries more engine/runtime/package-coupling risk than image/video/GLB paths
- PC-first/high-fidelity photogrammetry scenes that exceed baseline mobile-friendly expectations

**Defer for now**

- Direct Gaussian Splat runtime payloads
- Raw scan-native or tool-native experimental formats
- Any docs promise that suggests "arbitrary loose Godot scene files from any source are a safe beginner environment path"

### Concise recommendation for Derrick

For the **first-pass environment contract and creator guidance**, AeroBeat should prioritize:

1. **A small environment YAML contract**: identity + `type` + one package-local payload pointer.
2. **Three practical shipping forms in the docs story**:
   - `image_background` for easiest creator success,
   - `video_background` for controlled ambience,
   - standard cleaned 3D geometry as the main serious 3D path.
3. **`controlled godot_scene` only as an advanced, pipeline-managed option**, not the default community handoff.
4. **Photogrammetry as a supported source pipeline**, but only when it exits into cleaned geometry or baked media.
5. **Gaussian Splats deferred as direct runtime/package payloads** until Godot support, platform policy, and validator/runtime complexity are worth the burden.

If the goal is to ship a creator-friendly v1 without overpromising, the safest approval direction is: **teach image/video + cleaned geometry first, keep Godot-scene support constrained, and defer raw splat/runtime-exotic formats.**

---

### Derrick-facing v1 approval proposal — Environment contract

This is the concrete approval recommendation to hand Derrick for the first-pass Environment YAML decision. This is **approval prep only**, not implementation. It stays aligned with the current package model where each `Set` links **exactly one** environment file.

#### 1) Exact first-pass Environment YAML shape

```yaml
schemaId: aerobeat.environment.v1
schemaVersion: 1
recordVersion: 1
createdByTool: aerobeat-tool-content-authoring
createdByToolVersion: 0.1.0
createdAt: 2026-04-25T22:00:00Z
updatedAt: 2026-04-30T17:00:00Z

environmentId: ab-environment-neon-rooftop
environmentName: Neon Rooftop
type: glb_environment
resourcePath: media/environments/neon-rooftop.glb
```

**Recommended required fields for v1**

- `schemaId`
- `schemaVersion`
- `recordVersion`
- `createdByTool`
- `createdByToolVersion`
- `createdAt`
- `updatedAt`
- `environmentId`
- `environmentName`
- `type`
- `resourcePath`

**Recommended optional fields for v1**

- none

**Why this exact shape**

- It keeps the record as small as the current docs evidence supports: identity + typed package-local payload pointer.
- It preserves the already-established package boundary where the `Set` chooses the environment and the environment record points at the payload.
- It does **not** bake runtime policy, athlete overrides, lighting taxonomies, fog taxonomies, or assembly/build behavior into the YAML.
- It leaves room for different environment payload families while keeping the validator and docs understandable for creators.

#### 2) Exact v1 `type` enum to recommend locking

**Recommended v1 enum**

- `image_background`
- `video_background`
- `glb_environment`

**Recommendation:** lock exactly those three values for v1.

**Explicit recommendation against `godot_scene` for v1**

- Do **not** lock `godot_scene` into the first-pass v1 package contract.
- The creator-pipeline synthesis shows that the most supportable shipping outcomes for community authors are:
  - still image backgrounds,
  - looping video backgrounds,
  - cleaned 3D geometry exported through a standard interchange path.
- `godot_scene` is the wrong first-pass public handoff type because it implies a much heavier dependency/import/path/runtime contract than the current package docs and validator responsibilities actually support.
- `godot_scene` belongs in a **later advanced controlled-pipeline lane**: a Godot-authored/imported/build-managed environment flow after AeroBeat intentionally decides to support that as a curated package/runtime path.
- In other words: `godot_scene` fits a future **pipeline-managed authoring/build step**, not the initial community-facing loose package payload contract.

**Why `glb_environment` is the better v1 3D enum**

- It matches the creator-pipeline synthesis across traditional 3D, AI-assisted 3D, and photogrammetry: all three converge most cleanly on a cleaned GLB handoff.
- It is easier to explain in docs.
- It is easier to validate structurally.
- It keeps the runtime/pipeline burden materially lower than arbitrary Godot scene graphs.
- It gives AeroBeat one serious 3D path without overcommitting to Godot-native content semantics too early.

#### 3) Creator-guidance bullets for what environment artists / workout creators should use

**Recommend**

- Use `image_background` when the goal is the fastest, safest, most creator-friendly environment path.
- Use `video_background` for ambient motion backdrops, not for primary navigable 3D world geometry.
- Use `glb_environment` for serious 3D environments, including:
  - traditional Blender-authored scenes,
  - AI-assisted 3D that has been cleaned up by a human,
  - photogrammetry that has been reconstructed, decimated/retopoed, rebaked, and exported cleanly.

**Cautiously allow**

- AI-generated still images, as long as creators clean/crop/polish them before packaging.
- AI-generated video loops, as long as creators expect looping cleanup and final format conversion.
- AI-generated 3D only when the documented workflow is **generate -> clean in Blender -> export GLB**.
- Photogrammetry only when the documented workflow is **capture -> reconstruct -> optimize -> export GLB** or bake down to image/video if the scan is not game-ready.

**Steer creators away from for v1**

- Do not tell creators that arbitrary loose `godot_scene` files are a normal first-pass package payload.
- Do not promise “prompt once, ship a finished 3D environment.”
- Do not recommend raw scan meshes, raw Gaussian Splat payloads, or tool-native experimental formats as package deliverables.
- Do not treat video backgrounds as equivalent to a true 3D environment.

**Advanced-only positioning**

- If a creator is doing a deeper Godot assembly pass with lighting, reactive elements, gameplay-safe setup, and build-managed import behavior, that belongs in a future advanced `godot_scene`/pipeline-managed track rather than the baseline v1 package docs.

#### 4) Validator implications for `aerobeat-tool-content-authoring`

These should stay practical and first-pass scoped.

**Environment-record validation to add for v1**

- Require the shared schema/provenance fields already used elsewhere.
- Require `environmentId`, `environmentName`, `type`, and `resourcePath`.
- Require `schemaId == aerobeat.environment.v1`.
- Require `type` to be exactly one of:
  - `image_background`
  - `video_background`
  - `glb_environment`
- Require `resourcePath` to stay package-local and resolve to an existing file.

**Type-to-file-family checks to add for v1**

- `image_background` -> file must be an image extension family accepted by the tool/runtime policy.
- `video_background` -> file must be a video extension family accepted by the tool/runtime policy.
- `glb_environment` -> file must be `.glb`.

**Set-composition validation to keep/enforce**

- Each `Set` must resolve exactly one `environmentId`.
- That `environmentId` must resolve to exactly one environment record in `environments/`.
- Environment records remain reusable package-local records and do not point back to Sets.

**What the validator should explicitly not do yet**

- Do not try to validate runtime rendering behavior.
- Do not try to validate Godot scene internals, lighting rigs, fog semantics, athlete override policy, or platform downgrade rules.
- Do not introduce deep geometry-quality heuristics in the first pass beyond the basic file-family/type checks.
- Do not pretend `godot_scene` is supported if the approval decision excludes it from v1.

**Practical docs/tooling consequence**

- The current environment example YAMLs should be treated as pre-approval examples and updated later to the approved v1 shape.
- If Derrick approves this proposal, `aerobeat-tool-content-authoring` should implement the narrow structural/type/file-family checks above first, and leave any richer environment-import/build validation for a later explicit pipeline slice.

**Concise recommendation to Derrick**

Approve a deliberately small Environment v1 contract built around **one environment record per file, one environment per Set, and exactly three creator-facing payload types: `image_background`, `video_background`, and `glb_environment`**. Explicitly keep `godot_scene` out of v1 and reserve it for a later advanced controlled-pipeline path once AeroBeat is ready to own that complexity.

### Task 4: Roll the approved contracts into `aerobeat-docs`

**Bead ID:** `Pending`  
**SubAgent:** `primary` (for `coder` / `qa` / `auditor`)  
**Role:** `coder` / `qa` / `auditor`  
**References:** `REF-01`, `REF-02`, `REF-03`, `REF-04`, `REF-05`, `REF-06`, `REF-07`, plus the human-approved contract notes from Tasks 1-3  
**Prompt:** After Derrick explicitly approves both contracts, update the docs repo to teach the locked Environment and Asset YAML shapes consistently, refresh the checked-in example package if required, and run the standard coder → QA → auditor loop.

**Folders Created/Deleted/Modified:**
- `docs/architecture/`
- `docs/guides/`
- `docs/examples/workout-packages/`
- `.plans/`

**Files Created/Deleted/Modified:**
- implementation scope only

**Status:** ✅ Complete

**Results:** Derrick approved the Environment v1 lock, and this coder pass rolled that approval into `aerobeat-docs` without broadening the contract. Updated `docs/architecture/content-model.md` and `docs/architecture/workout-package-storage-and-discovery.md` so they explicitly teach the small Environment v1 record (`environmentId`, `environmentName`, `type`, `resourcePath` plus the shared schema/provenance block), the exact enum (`image_background`, `video_background`, `glb_environment`), the rule that each Set links exactly one environment record, and the boundary that baseline `godot_scene` is not part of v1 and should only be framed as future advanced controlled-pipeline / build-managed work. Refreshed the checked-in demo package guidance in `docs/guides/demo_workout_package.md`, `docs/examples/workout-packages/overview.md`, `docs/examples/workout-packages/demo-neon-boxing-bootcamp/README.md`, and `docs/guides/environment_creation.md` so creator guidance now recommends image/video/cleaned-GLB lanes while keeping Godot-authored scene work explicitly advanced-only. Replaced the old proposal-style environment examples in `docs/examples/workout-packages/demo-neon-boxing-bootcamp/environments/*.yaml` with the approved v1 shape and added matching placeholder payload files under `docs/examples/workout-packages/demo-neon-boxing-bootcamp/media/environments/`. Validation run: `python3 scripts/create_placeholders.py`; `./venv/bin/mkdocs build --strict` (passed). Implementation commit hash: `37de6b4` (`docs: lock environment v1 docs contract`). This plan entry was corrected in a small follow-up metadata commit so the recorded implementation hash stays truthful.

**QA follow-up (bead `aerobeat-docs-bovo`):** Independently re-ran `python3 scripts/create_placeholders.py` and `./venv/bin/mkdocs build --strict` (passed). Re-inspected the touched architecture pages, demo-package docs, set examples, and both `environments/*.yaml` files against `REF-01` through `REF-05` plus the approved contract. Confirmed the docs consistently teach the shared schema/provenance block plus `environmentId`, `environmentName`, `type`, and `resourcePath`; the exact v1 enum `image_background` / `video_background` / `glb_environment`; no baseline `godot_scene`; and exactly one environment link per Set. Contradiction sweep found no lingering `scenePath`, `lightingProfile`, or `fogProfile` in active docs/examples, but it did find one stale glossary line still implying scene/lighting-only environment resources. That user-visible parity bug was corrected in commit `c0dc5a2` (`docs: fix environment glossary wording`) so the glossary now matches the locked v1 image/video/GLB contract.

---

### Task 5: Update `aerobeat-tool-content-authoring` docs and validation to enforce the approved contracts

**Bead ID:** `Pending`  
**SubAgent:** `primary` (for `coder` / `qa` / `auditor`)  
**Role:** `coder` / `qa` / `auditor`  
**References:** `REF-08`, `REF-09`, plus the approved contract outputs from Tasks 1-4  
**Prompt:** After the Environment and Asset contracts are approved and taught in `aerobeat-docs`, update `aerobeat-tool-content-authoring` so its docs and validator behavior align with the locked contracts. Replace today’s intentionally shallow environment/asset checks only as far as the approved contract actually justifies, then run the standard coder → QA → auditor loop.

**Folders Created/Deleted/Modified:**
- `projects/aerobeat/aerobeat-tool-content-authoring/docs/`
- `projects/aerobeat/aerobeat-tool-content-authoring/services/validation/`
- `projects/aerobeat/aerobeat-tool-content-authoring/tests/`
- plan files in the owning repo as needed

**Files Created/Deleted/Modified:**
- implementation scope only

**Status:** ⏳ Pending

**Results:** Blocked on human approval of both contracts and completion of the docs rollout.

---

## Final Results

**Status:** ⚠️ Partial

**What We Built:** Drafted the execution plan for the Environment + Asset YAML contract review/approval slice, completed the first research passes for both record families, added focused approval-step analyses for the proposed environment `type: godot_scene` option plus Gaussian Splat creator pipelines, and added a Derrick-facing recommendation matrix covering traditional 3D/Blender, AI-assisted still/video backgrounds, AI-assisted 3D generation with cleanup, photogrammetry, and Gaussian Splat capture/reconstruction. The approved Environment v1 docs rollout is now implemented and QA-verified: active architecture/docs/example pages consistently teach the small Environment record centered on `environmentId` / `environmentName` / `type` / `resourcePath` plus the shared schema-provenance block; the exact enum `image_background`, `video_background`, and `glb_environment`; the rule that each Set links exactly one environment record; and the boundary that baseline `godot_scene` is out of the v1 package contract and only belongs in future advanced controlled-pipeline work. QA also corrected one lingering glossary wording bug so the glossary no longer implies scene/lighting-only environment payloads. Task 2 still recommends keeping the closed four-value asset enum, renaming the record field from `assetType` to `type`, keeping `assetId` / `assetName` / `type` / `resourcePath` as the durable asset-record core, and enforcing per-Set uniqueness plus cross-record matching rules in Set/package validation rather than inside the asset record.

**Reference Check:** The plan intentionally treats the current environment/asset example files as proposal inputs (`REF-04` through `REF-07`) rather than already-approved truth, while preserving the already-locked package and chart boundaries (`REF-01`, `REF-02`, `REF-09`, `REF-10`). The new Task 3 packet also cross-checks against the local environment-authoring/build docs (`docs/guides/environment_creation.md`, `docs/architecture/cloud_baker.md`, `docs/architecture/workflow.md`) and grounded Godot 4 loading behavior around imported project resources, runtime file loading, GLTF runtime import, and `load_resource_pack()`-style mod packs.

**Commits:**
- `37de6b4` - `docs: lock environment v1 docs contract`
- `4c1b09f` - `docs: record environment plan handoff`
- `c0dc5a2` - `docs: fix environment glossary wording`

**Lessons Learned:** The risky move here would be to let example YAMLs silently harden into policy without a human review pass. The asset review confirmed that several fields currently shown in examples (`metadata`, `tags`) are illustrative, not yet durable contract, so the approval pass needs to lock that distinction explicitly before docs/validator rollout.

---

*Drafted on 2026-04-30*