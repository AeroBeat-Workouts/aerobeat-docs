# AeroBeat Workout Creation Tools

**Date:** 2026-05-11  
**Status:** In Progress  
**Agent:** Chip 🐱‍💻

---

## Goal

Lock the next high-level design decisions for AeroBeat workout creation tools and identify the specific product/architecture questions Derrick is ready to answer next.

---

## Overview

This planning slice picks up from the earlier content-model, chart-contract, package-storage, coaching, and tool-lane decisions. The current architecture already says that authored workout content lives in package YAML, that `aerobeat-content-core` owns durable contracts, and that `aerobeat-tool-content-authoring` should own the human/automation workflows used to create, validate, migrate, package, and inspect that content.

The remaining work for this session is not implementation. It is product-shaping: deciding what the first workout-creation tool actually needs to do, where the workflow boundaries sit, and which questions should be answered now versus deferred. The immediate output should be a clean queue of decision prompts Derrick can answer without reopening already-locked schema and package decisions.

---

## REFERENCES

| ID | Description | Path |
| --- | --- | --- |
| `REF-01` | Day-one Tool-lane repo shape for content authoring | `docs/architecture/content-repo-shapes.md` |
| `REF-02` | Package storage/discovery contract for authored workouts | `docs/architecture/workout-package-storage-and-discovery.md` |
| `REF-03` | Implementation phasing for content lane and first authoring repo | `docs/architecture/content-lane-implementation-phases.md` |
| `REF-04` | Current coaching/package authoring guidance | `docs/guides/coaching.md` |
| `REF-05` | Prior chart-contract handoff and open vocabulary/tooling follow-up | `.plans/2026-04-28-aerobeat-chart-contract-post-song-timing.md` |

---

## Tasks

### Task 1: Draft canonical workout creation tools architecture decisions doc

**Bead ID:** `aerobeat-docs-3tl2`  
**SubAgent:** `primary`  
**Role:** `coder`  
**References:** `REF-01`, `REF-02`, `REF-03`, `REF-04`, `REF-05`  
**Prompt:** Draft the canonical AeroBeat workout creation tools architecture/design doc in `aerobeat-docs`. Claim bead `aerobeat-docs-3tl2` on start with `bd update aerobeat-docs-3tl2 --status in_progress --json` and close it on completion. Capture the now-locked decisions: separate CLI tools by YAML domain, package-wide workout validation as orchestrator, one-scene-per-YAML GUI structure with `workout.yaml` as package-home, chart editor as the heavyweight specialized scene, FFmpeg-backed asset normalization, explicit repair confirmation flow in GUI delegating to full package `--fix`, CLI `--fix` / `--fix-*` philosophy, embedded assembly integration via GodotEnv, accepted-vs-stored format distinction, and current canonical stored formats (`.ogg`, `.ogv`, `.png`, vanilla `.glb`). Also note explicitly deferred optimization work (KTX2/Draco) without reopening it.

**Folders Created/Deleted/Modified:**
- `docs/architecture/`
- `.plans/`

**Files Created/Deleted/Modified:**
- `docs/architecture/workout-creation-tools-architecture.md`
- `mkdocs.yml`
- `.plans/2026-05-11-aerobeat-workout-creation-tools-hld-questions.md`

**Status:** ✅ Complete

**Results:** Drafted `docs/architecture/workout-creation-tools-architecture.md` as the canonical decisions doc for the workout creation product. The doc captures the locked split to a separate tool repo imported into `aerobeat-assembly-community` via GodotEnv, separate CLI tools per YAML/workflow domain, package-wide validation/repair orchestration from the `workout` surface, one-scene-per-YAML GUI structure with `workout.yaml` as package-home, the chart editor as the heavyweight specialized scene, FFmpeg-backed media normalization/import, explicit GUI confirmation before full package repair, CLI `--fix` / `--fix-*` philosophy, the accepted-vs-stored format distinction, currently locked stored canonical formats (`.ogg`, `.ogv`, `.png`, vanilla `.glb`), and explicit deferral of KTX2/Draco/broader runtime-asset optimization work. Also added a bounded `mkdocs.yml` nav entry for the new architecture doc. Commit/push and validation pending in this task handoff.

---

### Task 2: QA the workout creation tools architecture decisions doc

**Bead ID:** `aerobeat-docs-2hvf`  
**SubAgent:** `primary`  
**Role:** `qa`  
**References:** `REF-01`, `REF-02`, `REF-03`, `REF-04`, `REF-05`  
**Prompt:** Independently QA the new workout creation tools architecture/design doc after the coder lands it. Claim bead `aerobeat-docs-2hvf` on start with `bd update aerobeat-docs-2hvf --status in_progress --json`. Verify the doc truthfully captures Derrick's decisions from this planning session, stays lane-correct with the existing content/tool/package docs, clearly separates accepted vs stored formats, and does not accidentally promise KTX2/Draco or broader optimization support. Run appropriate docs validation if available. Close the bead only if the QA pass is genuinely clean; otherwise leave clear failure notes.

**Folders Created/Deleted/Modified:**
- `docs/architecture/`
- `.plans/`

**Files Created/Deleted/Modified:**
- `docs/architecture/<new-doc>.md`
- `.plans/2026-05-11-aerobeat-workout-creation-tools-hld-questions.md`

**Status:** ⏳ Pending

**Results:** Pending.

---

### Task 3: Audit the workout creation tools architecture decisions doc

**Bead ID:** `aerobeat-docs-zsg8`  
**SubAgent:** `primary`  
**Role:** `auditor`  
**References:** `REF-01`, `REF-02`, `REF-03`, `REF-04`, `REF-05`  
**Prompt:** Perform an independent audit of the finalized workout creation tools architecture/design doc after QA passes. Claim bead `aerobeat-docs-zsg8` on start with `bd update aerobeat-docs-zsg8 --status in_progress --json`. Truth-check the doc against the plan, the prior architecture docs, and Derrick's locked decisions from this session. Confirm the scope is appropriately bounded to workout creation tooling and that deferred optimization work remains clearly deferred. Close the bead only if the work is genuinely complete; otherwise record the exact gap.

**Folders Created/Deleted/Modified:**
- `docs/architecture/`
- `.plans/`

**Files Created/Deleted/Modified:**
- `docs/architecture/<new-doc>.md`
- `.plans/2026-05-11-aerobeat-workout-creation-tools-hld-questions.md`

**Status:** ⏳ Pending

**Results:** Pending.

---

## Decision Notes From Derrick

- **Authoring surface:** CLI first.
- **Repo strategy:** one repo for the product.
- **Workflow unit:** one YAML file per workflow unit; the workout package root YAML is the primary/top-level unit.
- **CLI structure:** one CLI tool/command surface per YAML type, initially focused on validating that file shape plus its linked-file existence.
- **GUI structure:** one Godot scene per YAML file; chart editing lives in a dedicated chart editor scene, while the rest are form editors.
- **Coaching UX:** form-based file selection / drag-and-drop only, not an A/V editor; validation should surface simple non-technical errors.
- **Vertical slice goal:** full package coverage, but not full media editing; every YAML gets an editor surface.
- **Non-interactive requirements:** validate / inspect / migrate / package remain good baseline CLI directions.
- **Validation philosophy:** hard-locked constraints should fail with proper non-technical user-facing errors in both CLI and GUI.
- **Asset import priority:** critical; dropped/selected assets should be validated for purpose and copied into the correct package folder.
- **Product framing:** workout creation is one product; choreography/beat-chart editing is one high-scope part inside that product.
- **Design dependency:** Penpot screen designs should precede Godot GUI implementation.
- **Potential distribution direction:** editor may ship as part of `aerobeat-assembly-community` builds for discoverability and ease of use.

## Additional Locked Decisions From Derrick

- **CLI fragmentation:** prefer separate CLI tools early rather than one shared binary with subcommands, to keep testing/debugging and separation of concerns clean as tools grow.
- **Validation boundary:** validating one YAML must not imply full-package validation; `workout` validation is the package-wide orchestrator that calls into the specific validators for the referenced package parts.
- **Repo/integration boundary:** the editor and CLI tools live in their own repo and are imported into `aerobeat-assembly-community` via GodotEnv.
- **Asset replacement rule:** when a user replaces a slotted file, the old package file is deleted and the new validated canonical asset is copied in.
- **Canonical asset naming:** imported/generated media should be renamed to a normalized schema ending with a uid plus extension (example: `coaching-warm-up-video-49189afea.ogg`).
- **Media pipeline dependency:** `ffmpeg` should be a dependency of the workout creation tools.
- **Audio/video normalization:** accepted source formats may be converted into canonical Godot-friendly forms before being copied into the package; current locked canonical media directions are song audio `.ogg`, coaching audio `.ogg`, coaching video `.ogv`, and environment video `.ogv`, with target optimization direction up to `1080p 60fps` for video and up to `24-bit/96kHz` for audio.
- **Image import workflow:** near-valid images should use an aspect-ratio marquee/crop flow before canonical conversion/storage rather than failing outright for size mismatch.
- **Accepted vs stored formats:** the docs should explicitly separate broad accepted import formats from the narrower canonical stored formats used inside workout packages.
- **Current locked image/storage direction:** use `.png` for stored workout-package images for now; Godot does not support `.avif`, mod.io expects `.jpg`/`.png`, and the current practical choice is to stay unoptimized until profiling proves texture optimization is worth the scope.
- **Current locked 3D environment direction:** use vanilla `.glb` for stored 3D environments for now.
- **Optimization deferral:** KTX2 texture optimization and Draco-compressed GLB are explicitly deferred side-missions for future engine/runtime optimization work rather than part of the current workout-creation-tool scope.
- **Environment media rule:** short environment videos may loop to cover the set audio; overly long environment videos are acceptable because playback ends when the set transitions.
- **GUI repair philosophy:** when opening an out-of-date or invalid workout package, the GUI should explicitly warn that repair may materially change the package and recommend retesting afterward; only after user confirmation should it run the full package `--fix` flow.
- **CLI fixup philosophy:** CLI validation should hard-error on fixable issues and recommend a `--fix` command that performs the safe structural/content repair.
- **Universal vs targeted fixups:** `--fix` is the broad repair entrypoint, while more specific `--fix-*` commands may exist where useful.
- **Invalid enums / beat payloads:** repair/stripping semantics are owned by the specific CLI tools; GUI repair delegates to the same full repair flow after confirmation, while CLI validate should fail and direct users to `--fix`.
- **Duplicate ids / illegal package layout:** GUI repair should happen only through the explicit confirmed package repair flow; CLI validate should hard-error and point to `--fix`.
- **Scene map:** the canonical first-pass scene map is approved (`workout`, `song`, `chart`, `set`, `coach-config`, `environment`), though later UX-driven consolidation is still allowed.
- **Package-home UX:** package opening should land on the `workout.yaml`-driven overview/home scene and navigate outward to the other editors.
- **Chart editor boundary:** chart creation requires a chosen audio source; the editor owns waveform/timeline scrubbing, beat placement, preview/playback, and fast set testing from a selected point in time.
- **Chart editor testing aspiration:** a future `test` flow should launch standalone gameplay from the chosen timeline point after the normal set-start calibration path.
- **Environment editor future scope:** image preview/cropping is in scope; video preview is desirable; future GLB environments will need preview plus scale/rotation/orientation controls.
- **Assembly integration model:** embedded tool mode inside the main build, with scene-based transitions into the creation tools and a way back to the main game.

## Final Results

**Status:** ⚠️ Partial

**What We Built:** Created the living plan for the next AeroBeat workout-creation-tool design slice and captured Derrick's high-level product decisions around separate CLI validators, package-vs-file validation boundaries, one-scene-per-YAML GUI structure, FFmpeg-backed asset normalization/import, GUI-vs-CLI fixup policy, chart-editor boundaries, and embedded assembly integration.

**Reference Check:** Discussion aligns strongly with `REF-01`, `REF-02`, `REF-03`, and `REF-04`; the biggest remaining work is translating these product decisions into a formal tool architecture and a concrete implementation order.

**Commits:**
- None yet.

**Lessons Learned:** The content/package contracts are much more settled than the actual authoring-product workflow, so the next useful conversation should stay focused on tool scope and UX/workflow boundaries rather than reopening schema debates.

---

*Completed on 2026-05-11*
