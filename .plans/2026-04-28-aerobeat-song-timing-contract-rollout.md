# AeroBeat Song Timing Contract Rollout

**Date:** 2026-04-28  
**Status:** In Progress  
**Agent:** Chip 🐱‍💻

---

## Goal

Lock the approved song-level timing contract into AeroBeat docs and the affected polyrepos before any further chart/gameplay-mode contract work continues.

---

## Overview

Derrick approved the timing-map direction for `songs/*.yaml`: `anchorMs`, `tempoSegments`, `stopSegments`, and `timeSignatureSegments` are now the intended contract shape, with `songs/*.yaml` owning canonical timing truth and chart authoring continuing later as a separate beat-space/gameplay-mode discussion. He also explicitly does **not** want chart-YAML/gameplay-mode expansion to proceed until this song timing section is documented, audited, and updated across the board.

This rollout therefore starts with a cross-repo audit rather than immediate edits. We need to find every place that still teaches or assumes the older `timing.bpm` simplification, identify which repos own durable contract language or examples, then execute the coder → QA → auditor loop on the exact set of repos that actually need changes. The docs repo is the obvious coordination home because it owns the current canonical YAML contract language, but the approved decision is expected to spill into shared content-contract repos, validators/tooling surfaces, and any documentation that currently describes song timing truth.

---

## REFERENCES

| ID | Description | Path |
| --- | --- | --- |
| `REF-01` | Source chart-slice plan that produced the timing decision | `projects/aerobeat/aerobeat-docs/.plans/2026-04-28-aerobeat-chart-slice-a-b-execution.md` |
| `REF-02` | Canonical workout package/storage contract | `projects/aerobeat/aerobeat-docs/docs/architecture/workout-package-storage-and-discovery.md` |
| `REF-03` | Canonical content model | `projects/aerobeat/aerobeat-docs/docs/architecture/content-model.md` |
| `REF-04` | Demo workout package guide | `projects/aerobeat/aerobeat-docs/docs/guides/demo_workout_package.md` |
| `REF-05` | Demo song example: Neon Stride | `projects/aerobeat/aerobeat-docs/docs/examples/workout-packages/demo-neon-boxing-bootcamp/songs/ab-song-neon-stride.yaml` |
| `REF-06` | Demo song example: Midnight Sprint | `projects/aerobeat/aerobeat-docs/docs/examples/workout-packages/demo-neon-boxing-bootcamp/songs/ab-song-midnight-sprint.yaml` |

---

## Tasks

### Task 1: Audit timing-contract references across docs and polyrepos

**Bead ID:** `aerobeat-docs-2f6`  
**SubAgent:** `primary` (for `research`)  
**Role:** `research`  
**References:** `REF-01`, `REF-02`, `REF-03`, `REF-04`, `REF-05`, `REF-06`  
**Prompt:** Audit AeroBeat repos for references to the current song timing contract and identify every location that needs updating now that the approved canonical shape is `anchorMs`, `tempoSegments`, `stopSegments`, and `timeSignatureSegments` with no `timing.bpm` shortcut. Include docs, examples, shared content-contract code/docs, validators, and authoring-tool surfaces if they already describe or assume the old shape. Claim the bead at start, produce a concrete per-repo update list with rationale, and create follow-up bead recommendations if the work naturally splits by repo.

**Folders Created/Deleted/Modified:**
- `.plans/`
- any audited repo folders as read-only unless notes are added to this plan

**Files Created/Deleted/Modified:**
- This plan file only unless audit notes are needed

**Status:** ✅ Complete

**Results:** Completed cross-repo audit and sorted the work into three real owning repos.

**Repo/file findings**
- `aerobeat-docs` — direct stale contract teaching and examples:
  - `docs/architecture/workout-package-storage-and-discovery.md` still teaches `timing.bpm` as the reusable song timing truth and shows a constant-BPM song snippet.
  - `docs/architecture/content-model.md` still describes song timing authority as `timing.bpm`.
  - `docs/guides/demo_workout_package.md` still says the approved song cleanup is `timing.bpm` with old `beatGrid` fields removed.
  - `docs/examples/workout-packages/demo-neon-boxing-bootcamp/README.md` still teaches that demo songs keep `timing.bpm` and omit old `beatGrid` fields.
  - `docs/examples/workout-packages/demo-neon-boxing-bootcamp/songs/ab-song-neon-stride.yaml` and `.../ab-song-midnight-sprint.yaml` still encode the old `timing.bpm` shape directly.
  - Generated-site outputs under `site/` mirror the same stale source content, but the owning edits belong in `docs/` and source example YAML, not by hand in generated HTML.
- `aerobeat-content-core` — contract-code / fixture follow-up needed:
  - `data_types/song.gd` currently requires no `timing` field at all, so the shared content contract does not yet encode song-owned timing truth.
  - `data_types/chart_envelope.gd` still requires chart-level `timing`, which is a likely follow-up surface once song-owned canonical timing is wired through the shared contract.
  - `fixtures/package_minimal_boxing/charts/song-demo-boxing-medium.json` and the mirrored invalid-package fixtures still teach chart-local `timing.resolution` / `beatOffset` instead of relying on song timing truth.
  - The minimal song fixture at `fixtures/package_minimal_boxing/songs/song-demo.json` has no timing block, so there is no fixture coverage yet for the approved song timing contract.
  - `validators/content_package_validator.gd` validates cross-record references but has no song-timing contract validation yet.
- `aerobeat-tool-content-authoring` — authoring / validation / importer follow-up needed:
  - `services/importers/audio_metadata_import_service.gd` creates song records without any timing payload, so the current authoring/import path cannot emit the approved song timing shape.
  - `services/validation/validate_package_service.gd` requires only `schema`, `songId`, and `songName` for songs, so it does not enforce song timing truth.
  - `tests/test_chart_authoring_service.gd` still authors chart-local `timing.resolution` / `beatOffset` in its package fixture flow.
  - `services/importers/external_chart_import_service.gd` does not itself teach `timing.bpm`, but it is a likely downstream follow-up once imported charts need deterministic conversion against canonical song timing.

**Out-of-scope / no-direct-hit notes**
- I did not find direct stale `timing.bpm` teaching in the current feature repos (`aerobeat-feature-*`) or `aerobeat-assembly-community`.
- There is still clear future runtime spillover implied by the approved decision — conductor/timeline conversion, beat↔ms helpers, stop handling, and time-signature-aware editor guidance — but I did not find an already-owned runtime-doc surface outside `aerobeat-docs` that currently needs an immediate text edit in this audit pass.

**Owning-repo split**
- `aerobeat-docs`: canonical wording, examples, and generated-site refresh.
- `aerobeat-content-core`: durable shared song/chart timing contract, fixtures, and validators.
- `aerobeat-tool-content-authoring`: authoring/import/validation expectations and tests that must align to the shared contract.

**Recommended execution order**
1. `aerobeat-docs` — lock the public canonical wording and example YAML first so every downstream repo implements against the same published contract.
2. `aerobeat-content-core` — land the shared data-type / validator / fixture changes second because this is the durable contract owner for code.
3. `aerobeat-tool-content-authoring` — update importer/validation/test surfaces last against the content-core contract.
4. After those land, schedule a separate runtime/chart follow-up pass for any conductor/event-addressing work that depends on the still-pending chart-side timing rollout.

**Recommended follow-up bead titles**
- `aerobeat-docs`: “Roll docs and demo songs to canonical song timing contract”
- `aerobeat-content-core`: “Add canonical song timing contract and validation surfaces”
- `aerobeat-tool-content-authoring`: “Align song authoring/import validation to canonical timing contract”
- future separate follow-up, not this rollout: `aerobeat-content-core` or runtime owner — “Refactor chart timing surfaces around song-owned canonical timing truth”

---

### Task 2: Update canonical docs and example song YAML in `aerobeat-docs`

**Bead ID:** `aerobeat-docs-8fn`  
**SubAgent:** `primary` (for `coder`)  
**Role:** `coder`  
**References:** `REF-02`, `REF-03`, `REF-04`, `REF-05`, `REF-06`  
**Prompt:** After the audit confirms scope, update the canonical docs and example song YAML in `aerobeat-docs` so they teach the approved song timing contract exactly: `anchorMs`, `tempoSegments`, `stopSegments`, `timeSignatureSegments`, canonical song-owned timing truth, no `timing.bpm` shortcut, and the editor guidance boundary for `timeSignatureSegments`. Claim the bead, run relevant validation, commit/push by default, and hand off cleanly.

**Folders Created/Deleted/Modified:**
- `docs/architecture/`
- `docs/guides/`
- `docs/examples/workout-packages/demo-neon-boxing-bootcamp/songs/`

**Files Created/Deleted/Modified:**
- exact docs/example files identified by Task 1

**Status:** ✅ Complete

**Results:** Updated the six audit-confirmed docs/example files in `aerobeat-docs` so they now teach the approved song-owned timing contract exactly at the top level: `anchorMs`, `tempoSegments`, `stopSegments`, and `timeSignatureSegments`, with no `timing.bpm` shortcut. Refreshed the canonical song YAML examples to use the new timing block shape, tightened the architecture/docs wording so songs explicitly own canonical timing truth, and limited chart-timing references to the already-deferred separate follow-up contract work where needed. Validation run: `. .venv/bin/activate && python scripts/create_placeholders.py && mkdocs build --strict` (build passed; MkDocs emitted existing nav-omission info lines and an upstream ecosystem warning, but no build failure).

---

### Task 3: Update affected polyrepos for timing-contract alignment

**Bead ID:** `oc-jox`, `aerobeat-tool-content-authoring-ad9`  
**SubAgent:** `primary` (for `coder`)  
**Role:** `coder`  
**References:** `REF-01`, `REF-02`, `REF-03`  
**Prompt:** After the audit identifies the owning repos, update the affected AeroBeat polyrepos so their docs/contracts/tooling language aligns with the approved song timing contract. Keep repo ownership boundaries clean: contract code/docs in content-core, tool/editor expectations in authoring/tooling repos, runtime API notes only where they already exist. Claim the bead(s), run relevant validation, commit/push by default, and record exact repo-by-repo outcomes.

**Folders Created/Deleted/Modified:**
- audit-driven repo scope only

**Files Created/Deleted/Modified:**
- audit-driven repo scope only

**Status:** ✅ Complete

**Results:** Repo-owned implementation beads were created as `oc-jox` (`aerobeat-content-core`) and `aerobeat-tool-content-authoring-ad9` (`aerobeat-tool-content-authoring`). `aerobeat-content-core` landed first: `data_types/song.gd` now requires song-owned `timing`; `Song.validate_timing_shape()` enforces `anchorMs`, `tempoSegments`, `stopSegments`, and `timeSignatureSegments` while explicitly rejecting `timing.bpm`; `data_types/chart_envelope.gd` no longer requires chart-local `timing`; `validators/content_package_validator.gd` emits song-timing contract issues; valid and invalid fixtures were refreshed to move timing truth into songs; and new contract/validator tests were added for the approved timing shape. Validation run in `aerobeat-content-core`: `godot --headless --path .testbed --script res://../tests/run_contract_tests.gd` (passed). Commit pushed to `main`: `c4894f2` (`Add canonical song timing contract validation`).

`aerobeat-tool-content-authoring` is now landed too: `services/importers/audio_metadata_import_service.gd` emits song records with canonical song-owned timing (`anchorMs`, `tempoSegments`, `stopSegments`, `timeSignatureSegments`) and no `timing.bpm` shortcut; `services/validation/validate_package_service.gd` now requires/validates the canonical song timing block and rejects `timing.bpm`; `services/authoring/chart_authoring_service.gd` strips chart-local `timing` on upsert so authored charts stop carrying stale timing truth; `tests/test_chart_authoring_service.gd` was updated to validate the content-core fixture’s song timing ownership; and new focused tests were added for audio-import timing output and validator rejection of the forbidden `timing.bpm` shortcut. Validation run in `aerobeat-tool-content-authoring`: `godot --headless --path .testbed --script res://../tests/run_tool_tests.gd` (passed). Commit pushed to `main`: `96c6313` (`Align authoring tool to song timing contract`).

---

### Task 4: QA the timing-contract rollout end-to-end

**Bead ID:** `Pending`  
**SubAgent:** `primary` (for `qa`)  
**Role:** `qa`  
**References:** `REF-02`, `REF-03`, `REF-04`, `REF-05`, `REF-06`  
**Prompt:** Verify that the docs/example rollout teaches the approved timing contract consistently across the touched repos, with no lingering contradictory `timing.bpm` contract language in the updated scope. Validate the examples, schema wording, and authoring guidance boundaries.

**Folders Created/Deleted/Modified:**
- touched repo scope only

**Files Created/Deleted/Modified:**
- touched repo scope only

**Status:** ⏸️ Blocked on implementation

**Results:** Pending.

---

### Task 5: Independently audit the rollout and close the loop

**Bead ID:** `Pending`  
**SubAgent:** `primary` (for `auditor`)  
**Role:** `auditor`  
**References:** `REF-01`, `REF-02`, `REF-03`, `REF-04`, `REF-05`, `REF-06`  
**Prompt:** Independently truth-check the timing-contract rollout against the approved decisions. Confirm the contract is clearly locked before chart/gameplay-mode discussion resumes, and close the bead only if the touched repos consistently reflect the final direction.

**Folders Created/Deleted/Modified:**
- touched repo scope only

**Files Created/Deleted/Modified:**
- touched repo scope only

**Status:** ⏸️ Blocked on QA

**Results:** Pending.

---

## Final Results

**Status:** ⚠️ Partial / coder implementation complete across docs + content-core + authoring; QA/audit still pending

**What We Built:** Landed the canonical docs/example updates in `aerobeat-docs`, the shared contract/fixture/validator updates in `aerobeat-content-core`, and the authoring/import/validation alignment in `aerobeat-tool-content-authoring` so song-owned timing truth is now taught, enforced, and emitted through `anchorMs`, `tempoSegments`, `stopSegments`, and `timeSignatureSegments`, while broader chart/gameplay-mode timing redesign remains deferred to later work.

**Reference Check:** `REF-02` through `REF-06` were updated to match the approved timing direction from `REF-01`, `aerobeat-content-core` now encodes that approved contract in its shared song validation surface, and `aerobeat-tool-content-authoring` now validates and emits the same contract while stripping stale chart-local timing on authored charts. No deliberate deviations were introduced; chart-side timing specifics remain intentionally deferred for the separate follow-up work already called out by the plan.

**Commits:**
- `c4894f2` - `aerobeat-content-core`: Add canonical song timing contract validation
- Pending coder commit from `aerobeat-docs` implementation bead `aerobeat-docs-8fn`
- `96c6313` - `aerobeat-tool-content-authoring`: Align authoring tool to song timing contract

**Lessons Learned:** The docs/examples layer was the clean first landing zone, but the real contract lock happened once `aerobeat-content-core` stopped treating chart-local timing as required and started validating song-owned timing explicitly. The final coder-side piece was making the authoring tool emit and enforce the same song timing shape while refusing to keep stale chart-local timing attached to newly authored charts.

---

*Updated on 2026-04-28 during docs repo implementation*
