# AeroBeat Workout YAML / SQLite Feature Alignment

**Date:** 2026-04-29  
**Status:** Draft  
**Agent:** Chip 🐱‍💻

---

## Goal

Review the overall workout YAML and workout-database SQLite contract surfaces, then align them to the canonical `feature` naming so boxing, flow, dance, and step no longer drift behind older `mode` terminology.

---

## Overview

This picks up immediately after the boxing chart-YAML cleanup. Boxing chart docs are now internally consistent, but Derrick called out the next likely mismatch: some workout-level YAML and SQLite surfaces still appear to use `mode` where the durable gameplay-facing term should now be `feature`. That means the next pass should zoom back out from charts to the package/discovery layer and inspect how workouts, example package metadata, and the documented SQLite/index layer describe gameplay classification.

This pass should stay definition-first and alignment-first before implementation. We should identify exactly where `mode` still survives in workout YAML, example SQLite schemas/snippets, and directly coupled documentation, decide whether every such use is truly gameplay classification rather than some separate concept, and then make a bounded cleanup plan. Because this likely touches both example authored data and the docs that teach the SQLite/query layer, the scope needs to stay careful: fix the canonical naming drift without silently redesigning broader storage concerns that are unrelated to the `mode` → `feature` normalization.

Derrick also called out two additional repos that must be part of the audit scope: `aerobeat-content-core` and `aerobeat-tool-content-authoring`. Those repos may still encode old `mode` terminology in validators, mappers, fixtures, schemas, or repo-local docs. So this is no longer just a docs-repo pass; it is now a cross-repo naming-alignment review with `aerobeat-docs` as the coordination home, and any implementation work should split repo-local fixes cleanly rather than hiding cross-repo changes inside one docs-only task.

---

## REFERENCES

| ID | Description | Path |
| --- | --- | --- |
| `REF-01` | Fresh boxing chart-contract completion plan | `projects/aerobeat/aerobeat-docs/.plans/2026-04-29-aerobeat-boxing-chart-taxonomy-and-review.md` |
| `REF-02` | Canonical workout package/storage contract | `projects/aerobeat/aerobeat-docs/docs/architecture/workout-package-storage-and-discovery.md` |
| `REF-03` | Canonical content model | `projects/aerobeat/aerobeat-docs/docs/architecture/content-model.md` |
| `REF-04` | Demo workout package overview | `projects/aerobeat/aerobeat-docs/docs/guides/demo_workout_package.md` |
| `REF-05` | Demo workout package root YAML | `projects/aerobeat/aerobeat-docs/docs/examples/workout-packages/demo-neon-boxing-bootcamp/workout.yaml` |
| `REF-06` | Prior workout/sqlite direction memory | `memory/2026-04-24-workout-schema.md` |
| `REF-07` | Prior storage-shape memory | `memory/2026-04-23.md` |
| `REF-08` | AeroBeat content-core repo | `projects/aerobeat/aerobeat-content-core/` |
| `REF-09` | AeroBeat content-authoring repo | `projects/aerobeat/aerobeat-tool-content-authoring/` |

---

## Tasks

### Task 1: Audit workout YAML and SQLite-facing docs for `mode` vs `feature` drift

**Bead ID:** `aerobeat-docs-aut`  
**SubAgent:** `primary` (for `research`)  
**Role:** `research`  
**References:** `REF-02`, `REF-03`, `REF-04`, `REF-05`, `REF-06`, `REF-07`  
**Prompt:** Audit the workout YAML, workout-database SQLite contract docs/snippets, directly coupled teaching docs, and the relevant naming/validation/docs surfaces in `aerobeat-content-core` and `aerobeat-tool-content-authoring` for any remaining use of `mode` where the canonical gameplay-facing term should now be `feature`. Claim bead `aerobeat-docs-aut` at start with `bd update aerobeat-docs-aut --status in_progress --json` and close it on completion. Separate true naming drift from any places where `mode` still means something else and should remain.

**Folders Created/Deleted/Modified:**
- `.plans/`
- `docs/architecture/`
- `docs/guides/`
- `docs/examples/workout-packages/`

**Files Created/Deleted/Modified:**
- This plan file unless review notes are needed

**Status:** ✅ Complete

**Results:** Completed a cross-repo audit of `mode` → `feature` naming drift across `aerobeat-docs`, `aerobeat-content-core`, and `aerobeat-tool-content-authoring`, and closed bead `aerobeat-docs-aut`. Found that the demo `workout.yaml` and chart YAML examples are already aligned, but the docs SQL examples still use `workout_modes` / `mode` and the leaderboard cache schema still carries a `mode` column. Also found deeper repo-local drift in `aerobeat-content-core` and `aerobeat-tool-content-authoring`, where validators, interfaces, fixtures, tests, authoring/import services, and supporting docs still treat `mode` as the canonical gameplay classification field. Separated those from legitimate non-scope uses such as dependency-mode docs, failure-mode/no-op-mode wording, and general player-facing gameplay prose like “Boxing mode.” Main implementation ambiguity from the audit was whether to rename `mode` inside the current older content-core/content-authoring scaffolds and whether to include helper/class/table naming like `ContentMode` and `workout_modes`; Derrick has now explicitly approved fixing those known issues while deferring broader redesign, with a request that the remaining deferred legacy-scaffold elements be documented for later review.

---

### Task 2: Define the exact alignment surface for workout YAML + SQLite docs

**Bead ID:** `aerobeat-docs-89v`  
**SubAgent:** `primary` (for `research`)  
**Role:** `research`  
**References:** `REF-02`, `REF-03`, `REF-04`, `REF-05`  
**Prompt:** Based on the audit, define the exact cleanup surface needed to normalize workout YAML, SQLite-facing docs, and the relevant content-core / content-authoring naming surfaces to `feature`. Claim bead `aerobeat-docs-89v` at start with `bd update aerobeat-docs-89v --status in_progress --json` and close it on completion. Derrick has approved fixing the known `mode`→`feature` issues now, including field/schema/table/helper/class naming that is directly tied to the canonical gameplay classification contract, while explicitly deferring broader legacy-scaffold redesign. Call out any schema snippets, example rows/tables, validators, mappers, fixtures, package fields, helper/class renames, and a written defer list of remaining broader legacy elements that should stay out of this implementation pass.

**Folders Created/Deleted/Modified:**
- `.plans/`
- implementation scope to be determined

**Files Created/Deleted/Modified:**
- This plan file unless scoping notes are needed

**Status:** ✅ Complete

**Results:** Completed the cross-repo scoping pass and closed bead `aerobeat-docs-89v` without editing files. Defined a minimum safe alignment surface covering the docs SQLite contract (`workout_modes` / `mode` and leaderboard-cache `mode`), the shared `aerobeat-content-core` contract fields/helpers/validators/fixtures/tests, and the first-order `aerobeat-tool-content-authoring` workflow/validation/import/test surfaces that read or emit those canonical gameplay-classification fields. The recommended full pass for this implementation expands that to directly tied helper/class/file identities and browse-core catalog terminology from `modes` to `features` in repo docs, while still respecting Derrick’s no-broader-redesign boundary. The agreed implementation direction for coder is: rename canonical gameplay-classification fields, directly tied table/column names, directly tied helper/class/file names, and matching fixtures/tests/docs across the three repos, but do not use this pass to modernize the broader older scaffolds. Explicit defer list recorded from the scoping pass: generated `.testbed` artifacts, historical plan files, general prose uses like “Boxing mode” / “view modes” / dependency modes, and any redesign of older chart/editor/runtime scaffolds beyond the direct naming alignment. Remaining naming choices were narrowed to implementation details, and the orchestrator is proceeding with the recommended full alignment surface for this pass.

---

### Task 3: Apply approved workout YAML / SQLite naming edits, then QA + audit

**Bead ID:** `aerobeat-docs-aw7` / `aerobeat-docs-24q` / `aerobeat-docs-0fy`  
**SubAgent:** `primary` (for `coder` / `qa` / `auditor`)  
**Role:** `coder` / `qa` / `auditor`  
**References:** `REF-02`, `REF-03`, `REF-04`, `REF-05`  
**Prompt:** After Derrick approves the cleanup scope, update the workout YAML examples, SQLite-facing docs/snippets, and any approved content-core / content-authoring naming surfaces to align with canonical `feature` naming, run relevant validation, then perform the normal coder → QA → auditor loop before closing the bead(s). Keep the work focused on naming alignment and avoid redesigning unrelated storage concerns.

**Folders Created/Deleted/Modified:**
- implementation scope only

**Files Created/Deleted/Modified:**
- implementation scope only

**Status:** ✅ QA passed; auditor in progress

**Results:** Coder implementation completed on bead `aerobeat-docs-aw7` and pushed bounded `mode` → `feature` gameplay-classification alignment commits across all three repos. In `aerobeat-content-core`, commit `c84a2fa` (`Rename content mode contracts to feature`) renamed canonical contract fields, helper/class/file surfaces (`ContentMode` / `content_mode.gd` → `ContentFeature` / `content_feature.gd`), validator issue/message wording, workout-resolution contract wording, and the audited routine/chart fixture JSONs. In `aerobeat-tool-content-authoring`, commit `a5d40b9` (`Rename authoring content mode fields to feature`) renamed workflow/import/validation/test field handling, validation issue/message wording, browse-core catalog docs, and chart path slugging to derive from `feature`. In `aerobeat-docs`, commit `6982d5d` (`Align docs schema examples to feature naming`) renamed the documented SQL schema/table surface (`workout_modes` → `workout_features`, `mode` columns → `feature`) and updated directly coupled docs/snippets for `song/feature/difficulty` matching and `content_feature.gd`. Validation performed by the coder included targeted repo-local grep/search confirmation plus automated Godot test runs in `aerobeat-content-core` and `aerobeat-tool-content-authoring`, both of which passed. The implementation stayed within the approved rename boundary and did not broaden into general gameplay prose or deeper legacy-scaffold redesign. QA on bead `aerobeat-docs-24q` then passed across all three repos: direct gameplay-classification contract surfaces now use `feature`, SQL/table/column naming aligns (`workout_features`, `feature`), the `content_feature.gd` helper/class/file rename is coherent with no tracked `content_mode.gd` remaining, fixtures/tests/docs were updated consistently, and remaining `mode` hits are legitimate out-of-scope prose or architecture wording. QA reran the relevant automated Godot tests in both `aerobeat-content-core` and `aerobeat-tool-content-authoring`, both passed, and an authoring import smoke surfaced only one unrelated pre-existing `demo-song.ogg` decode/import error that does not block this rename scope. The work is now ready for independent audit on bead `aerobeat-docs-0fy`.

---

## Final Results

**Status:** ⚠️ Draft / Awaiting Derrick review

**What We Built:** Opened the next alignment plan for workout YAML plus workout-database SQLite-facing docs, focused on normalizing `mode` to `feature` where that now represents gameplay classification.

**Reference Check:** `REF-06` and `REF-07` preserve the earlier source-of-truth direction that workout YAML is authored truth while the SQLite layer is a query/index surface, which keeps this pass grounded while we align naming.

**Commits:**
- Pending

**Lessons Learned:** Boxing showed that canonical naming drift can hide in higher-level docs even after local examples are fixed, so this pass starts with an explicit audit before any rewrite work.

---

*Completed on 2026-04-29 (draft for review)*
