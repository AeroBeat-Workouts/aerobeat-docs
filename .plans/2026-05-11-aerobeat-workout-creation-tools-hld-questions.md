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

**Results:** Initial coder pass drafted `docs/architecture/workout-creation-tools-architecture.md` as the canonical decisions doc for the workout creation product and added a bounded `mkdocs.yml` nav entry. After QA flagged two scoped consistency leaks, the retry pass fixed both surgically: this active plan's canonical coaching-video filename example now uses the locked `.ogv` suffix, and `docs/guides/coaching.md` now explicitly distinguishes accepted source video import formats from the normalized canonical package-stored coaching video format `.ogv`, consistent with the architecture doc. A later retry also reconciled the architecture doc's implementation-posture section with `docs/architecture/workout-creation-tools-implementation-order.md` so repo/shared-service/headless CLI foundations are now explicitly ordered ahead of Penpot-driven scene work.

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

**Status:** ❌ Failed

**Results:** QA failed the first pass. The new architecture doc was broadly correct, but scoped consistency review found two follow-up fixes needed before QA can pass: (1) this active plan still used a coaching-video canonical filename example ending in `.ogg` instead of `.ogv`, and (2) `docs/guides/coaching.md` still described package-local coaching videos in terms of accepted source formats rather than the locked stored canonical `.ogv` format after import/normalization.

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
- **Canonical asset naming:** imported/generated media should be renamed to a normalized schema ending with a uid plus extension (example: `coaching-warm-up-video-49189afea.ogv`).
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

### Task 4: Define accepted import format matrix per slot

**Bead ID:** `aerobeat-docs-hg6q`
**SubAgent:** `primary`
**Role:** `coder`
**References:** `REF-01`, `REF-02`, `REF-03`, `REF-04`, `REF-05`
**Prompt:** Draft the canonical accepted import format matrix for the AeroBeat workout creation tools. Claim bead `aerobeat-docs-hg6q` on start with `bd update aerobeat-docs-hg6q --status in_progress --json` and close it on completion. Produce a bounded docs pass that clearly maps accepted source/import formats vs stored canonical formats for each relevant slot/domain in the workout package (songs, coaching audio/video, environment image/video, GLB environments, and any immediately relevant image/art slots), staying consistent with the locked architecture decisions and current Godot/mod.io constraints.

**Folders Created/Deleted/Modified:**
- `docs/architecture/`
- `.plans/`

**Files Created/Deleted/Modified:**
- `docs/architecture/workout-creation-tools-import-format-matrix.md`
- `mkdocs.yml`
- `.plans/2026-05-11-aerobeat-workout-creation-tools-hld-questions.md`

**Status:** ✅ Complete

**Results:** Added `docs/architecture/workout-creation-tools-import-format-matrix.md` as the canonical slot-by-slot import/storage matrix for workout creation tooling. The doc clearly separates accepted source/import formats from stored package formats, covers the in-scope package slots (song audio, coaching audio/video, environment image/video, GLB, and package art image), stays aligned with the locked `.ogg` / `.ogv` / `.png` / `.glb` storage decisions, and adds actionable validation/canonicalization rules for future CLI and GUI import flows. Added one bounded nav entry in `mkdocs.yml`. Landed in commit `4e8be59` (`docs: add workout creation tool specs`) with strict docs validation passing.

---

### Task 5: QA the accepted import format matrix per slot

**Bead ID:** `aerobeat-docs-5sxf`
**SubAgent:** `primary`
**Role:** `qa`
**References:** `REF-01`, `REF-02`, `REF-03`, `REF-04`, `REF-05`
**Prompt:** Independently QA the accepted import format matrix doc after the coder lands it. Claim bead `aerobeat-docs-5sxf` on start with `bd update aerobeat-docs-5sxf --status in_progress --json`. Verify that the matrix truthfully matches the already-locked workout creation architecture, correctly reflects current Godot/mod.io constraints, clearly distinguishes accepted import formats from stored canonical formats, and does not quietly reopen optimization or GUI-scope debates. Close the bead only if the QA pass is genuinely clean.

**Folders Created/Deleted/Modified:**
- `docs/architecture/`
- `.plans/`

**Files Created/Deleted/Modified:**
- `docs/architecture/<matrix-doc>.md`
- `.plans/2026-05-11-aerobeat-workout-creation-tools-hld-questions.md`

**Status:** ✅ Complete

**Results:** QA passed. Verified that `docs/architecture/workout-creation-tools-import-format-matrix.md` matches the locked workout creation architecture, clearly separates accepted source/import formats from stored canonical formats, covers the current in-scope slots, reflects current Godot/mod.io constraints without overclaiming unsupported optimization/runtime-import behavior, and keeps KTX2/Draco explicitly deferred. Validation passed with `git diff --check` and `.venv/bin/mkdocs build --strict`.

---

### Task 6: Audit the accepted import format matrix per slot

**Bead ID:** `aerobeat-docs-bizl`
**SubAgent:** `primary`
**Role:** `auditor`
**References:** `REF-01`, `REF-02`, `REF-03`, `REF-04`, `REF-05`
**Prompt:** Perform an independent audit of the accepted import format matrix doc after QA passes. Claim bead `aerobeat-docs-bizl` on start with `bd update aerobeat-docs-bizl --status in_progress --json`. Truth-check the matrix against the architecture doc, workout package storage rules, coaching guidance, and Derrick's locked decisions from this session. Confirm the matrix is complete for current scope and stays bounded to workout-creation tooling. Close the bead only if the audit is genuinely clean.

**Folders Created/Deleted/Modified:**
- `docs/architecture/`
- `.plans/`

**Files Created/Deleted/Modified:**
- `docs/architecture/<matrix-doc>.md`
- `.plans/2026-05-11-aerobeat-workout-creation-tools-hld-questions.md`

**Status:** ⏳ Pending

**Results:** Pending.

---

### Task 7: Define CLI surface spec for workout creation tools repo

**Bead ID:** `aerobeat-docs-eqoh`
**SubAgent:** `primary`
**Role:** `coder`
**References:** `REF-01`, `REF-02`, `REF-03`, `REF-04`, `REF-05`
**Prompt:** Draft the canonical CLI surface spec for the AeroBeat workout creation tools repo. Claim bead `aerobeat-docs-eqoh` on start with `bd update aerobeat-docs-eqoh --status in_progress --json` and close it on completion. Capture the separate-CLI direction per YAML/workflow domain, the `workout` package-orchestrator behavior, baseline commands like validate / fix / inspect / migrate / package where appropriate, and the intended boundary between per-domain tools and shared internal libraries/services. Keep the spec bounded and consistent with the locked architecture decisions.

**Folders Created/Deleted/Modified:**
- `docs/architecture/`
- `.plans/`

**Files Created/Deleted/Modified:**
- `docs/architecture/<cli-spec-doc>.md`
- `.plans/2026-05-11-aerobeat-workout-creation-tools-hld-questions.md`

**Status:** ✅ Complete

**Results:** Added `docs/architecture/workout-creation-tools-cli-surface.md` as the bounded canonical CLI surface spec for the workout creation tools repo. The doc keeps the locked separate-tool direction explicit, defines `aerobeat-workout` as the package-wide orchestrator, assigns baseline command categories per relevant tool (`validate`, `fix`, `inspect`, `migrate`, `package`, and justified `import` flows), and clarifies the boundary between public CLI tools and shared internal workflow services. Added a bounded `mkdocs.yml` nav entry for the new architecture doc. Landed in commit `4e8be59` (`docs: add workout creation tool specs`) with strict docs validation passing.

---

### Task 8: QA the CLI surface spec for workout creation tools repo

**Bead ID:** `aerobeat-docs-qs12`
**SubAgent:** `primary`
**Role:** `qa`
**References:** `REF-01`, `REF-02`, `REF-03`, `REF-04`, `REF-05`
**Prompt:** Independently QA the CLI surface spec doc after the coder lands it. Claim bead `aerobeat-docs-qs12` on start with `bd update aerobeat-docs-qs12 --status in_progress --json`. Verify that the CLI surface remains faithful to Derrick's locked direction of separate tools, does not collapse back into a single primary CLI, keeps package-wide orchestration on the `workout` surface, and stays lane-correct with the tool/content architecture. Close the bead only if the QA pass is genuinely clean.

**Folders Created/Deleted/Modified:**
- `docs/architecture/`
- `.plans/`

**Files Created/Deleted/Modified:**
- `docs/architecture/<cli-spec-doc>.md`
- `.plans/2026-05-11-aerobeat-workout-creation-tools-hld-questions.md`

**Status:** ✅ Complete

**Results:** QA passed. Verified that `docs/architecture/workout-creation-tools-cli-surface.md` stays faithful to the locked separate-tool direction, does not collapse back into a single universal CLI, keeps `aerobeat-workout` as the package-wide orchestrator, uses sensible bounded command surfaces, and clearly documents the boundary between public CLI tools and shared internal services. Validation passed with `git diff --check` and `.venv/bin/mkdocs build --strict`.

---

### Task 9: Audit the CLI surface spec for workout creation tools repo

**Bead ID:** `aerobeat-docs-ra0l`
**SubAgent:** `primary`
**Role:** `auditor`
**References:** `REF-01`, `REF-02`, `REF-03`, `REF-04`, `REF-05`
**Prompt:** Perform an independent audit of the CLI surface spec doc after QA passes. Claim bead `aerobeat-docs-ra0l` on start with `bd update aerobeat-docs-ra0l --status in_progress --json`. Truth-check the CLI surface against the architecture doc, the active plan, and Derrick's locked product decisions. Confirm the spec is actionable without drifting into premature implementation detail or violating the separate-tool direction. Close the bead only if the audit is genuinely clean.

**Folders Created/Deleted/Modified:**
- `docs/architecture/`
- `.plans/`

**Files Created/Deleted/Modified:**
- `docs/architecture/<cli-spec-doc>.md`
- `.plans/2026-05-11-aerobeat-workout-creation-tools-hld-questions.md`

**Status:** ⏳ Pending

**Results:** Pending.

---

### Task 10: Define implementation order for workout creation tools repo

**Bead ID:** `aerobeat-docs-zbln`
**SubAgent:** `primary`
**Role:** `coder`
**References:** `REF-01`, `REF-02`, `REF-03`, `REF-04`, `REF-05`
**Prompt:** Draft the canonical implementation-order / milestone plan for the AeroBeat workout creation tools repo. Claim bead `aerobeat-docs-zbln` on start with `bd update aerobeat-docs-zbln --status in_progress --json` and close it on completion. Build on the locked workout-creation architecture, import-format matrix, and CLI surface spec to propose a sane staged implementation order that can begin before Penpot GUI work. Keep it bounded to milestones, dependencies, and why the order is safe; do not drift into detailed sprint management or reopen settled design decisions.

**Folders Created/Deleted/Modified:**
- `docs/architecture/`
- `.plans/`

**Files Created/Deleted/Modified:**
- `docs/architecture/<implementation-order-doc>.md`
- `.plans/2026-05-11-aerobeat-workout-creation-tools-hld-questions.md`

**Status:** ✅ Complete

**Results:** Initial implementation-order doc landed in `docs/architecture/workout-creation-tools-implementation-order.md` and correctly put headless CLI/package/import/validation work before Penpot-dependent GUI work. QA then found a real contradiction in the older `docs/architecture/workout-creation-tools-architecture.md` doc: its stale “Recommended implementation posture” still front-loaded Penpot screen/design work before repo/shared-service foundations. The retry pass resolved that contradiction surgically by rewriting the architecture doc's implementation-posture section to match the implementation-order doc: repo/shared-service/headless CLI foundations now come first, Penpot remains a dependency for polished GUI work rather than a gate for starting the repo, and the later scene/editor ordering remains unchanged.

---

### Task 11: QA the implementation order for workout creation tools repo

**Bead ID:** `aerobeat-docs-9iha`
**SubAgent:** `primary`
**Role:** `qa`
**References:** `REF-01`, `REF-02`, `REF-03`, `REF-04`, `REF-05`
**Prompt:** Independently QA the implementation-order doc after the coder lands it. Claim bead `aerobeat-docs-9iha` on start with `bd update aerobeat-docs-9iha --status in_progress --json`. Verify that the proposed sequence is faithful to Derrick's locked architecture, starts with safe CLI/package work that does not depend on Penpot GUI design, respects the chart editor as the heavyweight later slice, and remains actionable without becoming over-specified project management. Close the bead only if the QA pass is genuinely clean.

**Folders Created/Deleted/Modified:**
- `docs/architecture/`
- `.plans/`

**Files Created/Deleted/Modified:**
- `docs/architecture/<implementation-order-doc>.md`
- `.plans/2026-05-11-aerobeat-workout-creation-tools-hld-questions.md`

**Status:** ⏳ Pending

**Results:** Pending.

---

### Task 12: Audit the implementation order for workout creation tools repo

**Bead ID:** `aerobeat-docs-midr`
**SubAgent:** `primary`
**Role:** `auditor`
**References:** `REF-01`, `REF-02`, `REF-03`, `REF-04`, `REF-05`
**Prompt:** Perform an independent audit of the implementation-order doc after QA passes. Claim bead `aerobeat-docs-midr` on start with `bd update aerobeat-docs-midr --status in_progress --json`. Truth-check the sequence against the architecture doc, import-format matrix, CLI surface spec, and the active plan. Confirm the order is coherent, bounded, and does not smuggle in unapproved GUI or optimization assumptions. Close the bead only if the audit is genuinely clean.

**Folders Created/Deleted/Modified:**
- `docs/architecture/`
- `.plans/`

**Files Created/Deleted/Modified:**
- `docs/architecture/<implementation-order-doc>.md`
- `.plans/2026-05-11-aerobeat-workout-creation-tools-hld-questions.md`

**Status:** ⏳ Pending

**Results:** Pending.

---

## Final Results

**Status:** ⚠️ Partial

**What We Built:** Created the living plan for this AeroBeat workout-creation-tool design slice, captured Derrick's locked high-level product decisions, landed the canonical workout-creation-tools architecture doc, corrected the coaching-video canonical-format wording, and then landed the two safe follow-on docs that do not depend on Penpot GUI design: the accepted import format matrix per slot and the CLI surface spec. The next safe extension is now the implementation-order doc for the tool repo.

**Reference Check:** Discussion and resulting docs align strongly with `REF-01`, `REF-02`, `REF-03`, and `REF-04`; the current docs package now covers the product boundary, accepted-vs-stored asset rules, and separate-CLI surface direction without reopening deferred optimization or GUI-implementation work.

**Commits:**
- `a9383fb` - `docs: add workout creation tools architecture`
- `035eb82` - `docs: fix coaching video canonical format wording`
- `4e8be59` - `docs: add workout creation tool specs`

**Lessons Learned:** The content/package contracts are much more settled than the actual authoring-product workflow, so the next useful conversation should stay focused on tool scope and UX/workflow boundaries rather than reopening schema debates. Also, once parallel coder/QA passes converge on the same bounded docs batch, the plan file must be updated immediately so audit is checking truth instead of stale task prose.

---

*Completed on 2026-05-11*
