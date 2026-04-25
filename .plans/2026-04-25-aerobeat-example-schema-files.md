# AeroBeat Example Schema Files

**Date:** 2026-04-25  
**Status:** In Progress  
**Agent:** Chip 🐱‍💻

---

## Goal

Create a commented demo workout package for the AeroBeat package system so a human can understand the full folder shape, each file, each field, each section, and each enum option directly from the example artifacts without needing to cross-reference the docs or codebase.

---

## Overview

The package contract and wider docs cleanup are now landed, but the next missing layer is concrete examples. Right now the architecture is described clearly in prose, yet a creator or implementer still has to translate that prose into “what does an actual file look like?” Derrick’s request points to the right next slice: produce a full demo workout package whose artifacts are self-explanatory on their own.

These should not be bare minimal examples. They should be **teaching examples**. That means every meaningful variable/section should have comments above it explaining what it is for, what values are allowed, and where the boundaries are. Enums should be spelled out inline where practical. The goal is that someone can open the demo workout folder, inspect the YAML files, and understand the package shape without needing a second tab open to the docs or repo internals.

The strongest version is not isolated snippets — it is one coherent demo workout folder with matching ids across files, realistic relationships between `workout.yaml` and the referenced package records, and a docs page that links to that demo workout as the canonical example package. This work belongs in `aerobeat-docs`, because the docs repo is the canonical review surface for the package contract. If the examples are strong, they will likely become the seed/reference for future authoring-tool exports, schema validation fixtures, and implementation examples in other repos.

---

## REFERENCES

| ID | Description | Path |
| --- | --- | --- |
| `REF-01` | Current package/storage contract | `projects/aerobeat/aerobeat-docs/docs/architecture/workout-package-storage-and-discovery.md` |
| `REF-02` | Current content model | `projects/aerobeat/aerobeat-docs/docs/architecture/content-model.md` |
| `REF-03` | Current glossary definitions | `projects/aerobeat/aerobeat-docs/docs/gdd/glossary/terms.md` |
| `REF-04` | Remaining-decisions cleanup plan that just landed | `projects/aerobeat/aerobeat-docs/.plans/2026-04-25-aerobeat-remaining-package-decisions-and-docs-sweep.md` |
| `REF-05` | Active content-core definition lineage | `projects/aerobeat/aerobeat-content-core/.plans/2026-04-23-aerobeat-content-core-first-implementation-slice.md` |

---

## Tasks

### Task 1: Define the demo workout package layout and example conventions

**Bead ID:** `aerobeat-docs-jq3`  
**SubAgent:** `primary` (for `research`)  
**Role:** `research`  
**References:** `REF-01`, `REF-02`, `REF-03`, `REF-05`  
**Prompt:** Decide exactly how the demo workout package should be laid out, where it should live in `aerobeat-docs`, how it should be linked from the docs, and what commenting conventions it should use so the files are self-explanatory. Include YAML examples for all current package domains and SQLite schema examples where useful.

**Folders Created/Deleted/Modified:**
- `docs/`
- likely a new examples/reference folder
- `.plans/`

**Files Created/Deleted/Modified:**
- likely a new example-schema doc or example file set
- this plan file

**Status:** ✅ Complete

**Results:** Defined the canonical docs example layout under `docs/examples/workout-packages/demo-neon-boxing-bootcamp/` with one coherent package folder plus a sibling docs overview page. Chose a teaching-first convention: comments above meaningful fields/sections, matching ids across all files, one shared workout scenario instead of disconnected snippets, and explicit SQL examples in `sql/` to teach the boundary between authored YAML and derived SQLite. Also added a dedicated guide page and docs-nav links so the example is easy to find.

---

### Task 2: Author the commented demo workout package files

**Bead ID:** `aerobeat-docs-8nh`  
**SubAgent:** `primary` (for `coder`)  
**Role:** `coder`  
**References:** `REF-01`, `REF-02`, `REF-03`  
**Prompt:** Create a coherent commented demo workout folder for the current package domains so each file explains itself inline and the whole folder teaches the package shape. At minimum cover: `workout.yaml`, `songs/*.yaml`, `routines/*.yaml`, `charts/*.yaml`, `coaches/coach-config.yaml`, `environments/*.yaml`, and `assets/*.yaml`. Comments should explain what each section/field is for and list enum options where applicable.

**Folders Created/Deleted/Modified:**
- docs example/reference folders to be determined
- `.plans/`

**Files Created/Deleted/Modified:**
- commented example YAML files
- possibly supporting doc index pages that explain how to read them
- this plan file

**Status:** ✅ Complete

**Results:** Authored the complete commented demo workout package under `docs/examples/workout-packages/demo-neon-boxing-bootcamp/`, including `workout.yaml`, two `songs/*.yaml`, two `routines/*.yaml`, two `charts/*.yaml`, `coaches/coach-config.yaml`, two `environments/*.yaml`, and six `assets/*.yaml` covering the full locked v1 `assetType` enum. The package is coherent and realistic: all ids match across records, workout entries use exact references, coaching overlays resolve through the single coach-config domain, and coach support assets are referenced from coach config rather than workout entry `assetSelections`.

---

### Task 3: Add SQLite schema examples and usage notes

**Bead ID:** `aerobeat-docs-z3y`  
**SubAgent:** `primary` (for `coder`)  
**Role:** `coder`  
**References:** `REF-01`, `REF-03`  
**Prompt:** Add example schema/reference material for `workouts.db` and the per-workout leaderboard cache DB, including enough comments or adjacent explanation that a reader can understand table purpose and authority boundaries without hunting elsewhere.

**Folders Created/Deleted/Modified:**
- docs example/reference folders to be determined
- `.plans/`

**Files Created/Deleted/Modified:**
- example SQL/schema files and/or schema reference docs
- this plan file

**Status:** ✅ Complete

**Results:** Added readable SQL examples at `docs/examples/workout-packages/demo-neon-boxing-bootcamp/sql/workouts.db.schema.sql` and `docs/examples/workout-packages/demo-neon-boxing-bootcamp/sql/leaderboard-cache.db.schema.sql`. The comments explain authority boundaries clearly: `workouts.db` is the local installed-workout discovery index, `leaderboard-cache.db` is disposable local cache only, and the future online catalog DB remains intentionally separate from local `workouts.db`.

---

### Task 4: Review, QA, and align the example set with canonical docs

**Bead ID:** `aerobeat-docs-des`  
**SubAgent:** `primary` (for `qa` then `auditor`)  
**Role:** `qa` / `auditor`  
**References:** `REF-01`, `REF-02`, `REF-03`, `REF-04`  
**Prompt:** Independently verify the example files match the locked package contract and do not quietly introduce new rules. Confirm the comments are accurate, useful, and do not contradict the canonical architecture docs.

**Folders Created/Deleted/Modified:**
- docs example/reference folders
- `.plans/`

**Files Created/Deleted/Modified:**
- example files if fixes are needed
- this plan file

**Status:** ⏳ Pending discussion

**Results:** Need confidence that the examples teach the current contract instead of inventing a slightly different one.

---

## Current Discussion Direction

The example set should be optimized for readability and onboarding, not just machine shape. Derrick explicitly wants a full demo workout framing, with comments above each variable/section so a person can read the files and understand:

- what the field does
- what enum values are allowed
- what belongs there versus elsewhere
- what is v1-only versus future/optional complexity

The examples should be one coherent demo workout package with realistic relationships across files rather than isolated toy stubs. The docs should link directly to the demo workout folder so new workout developers can inspect the full valid package shape in one place.

---

## Open Questions To Resolve In This Pass

1. The examples should live under `docs/examples/workout-packages/` so they are versioned with the docs and easy to link from architecture/guides pages.
2. The YAML examples should be one coherent sample package with matching ids across files rather than isolated snippets.
3. SQLite examples should be committed as readable `.sql` schema files, with nearby markdown guide pages linking to them.
4. Optional/future complexity should stay mostly out of the example so the package teaches the v1 contract clearly.
5. For now, keep the example set documentation-oriented first, while leaving room for future validation/fixture reuse if implementation repos later want to consume it.

---

## Final Results

**Status:** ⚠️ Coder complete; QA/audit pending

**What We Built:** Added a canonical docs example package at `docs/examples/workout-packages/demo-neon-boxing-bootcamp/` plus a new `docs/guides/demo_workout_package.md` onboarding guide and an `docs/examples/workout-packages/overview.md` landing page. The example package now teaches the full current v1 shape for workout/session metadata, songs, routines, charts, coach config, environments, assets, and the two local SQLite schemas.

**Reference Check:** The example package and SQL files were kept aligned to `REF-01`, `REF-02`, `REF-03`, and the locked package decisions summarized in `REF-04`. In particular, the example uses `Chart` terminology, one `coaches/coach-config.yaml` domain, coach asset references only from coach config, discoverability in `workouts.db` rather than package YAML, self-contained package-local references, duplication/forking rather than inheritance, a separate future catalog DB story, deferred signing/integrity metadata, and the strict six-value v1 `assetType` enum.

**Commits:**
- `e93ae04` - Add AeroBeat demo workout package docs

**Lessons Learned:** After the architecture prose is stable, the most helpful next artifact is a coherent package someone can open and understand in one pass. The example is strongest when it teaches both the happy-path file shape and the authority boundaries between authored YAML and derived SQLite.

---

*Created on 2026-04-25*
