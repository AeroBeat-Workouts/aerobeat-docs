# AeroBeat Package Schema + SQLite Definition

**Date:** 2026-04-25  
**Status:** In Progress  
**Agent:** Chip 🐱‍💻

---

## Goal

Lock the current AeroBeat package-system decisions into explicit YAML schemas and SQLite structures, then update the docs repo so the package/content/catalog/cache architecture is clear enough to review before implementation.

---

## Overview

Derrick and I converged on a coherent package-system direction for AeroBeat: self-contained workout packages, YAML as the durable authored truth, root-level SQLite for discovery/catalog concerns, workout-local leaderboard-cache SQLite for score browsing, and folder-per-domain content organization inside each workout package. The main job for this pass was to turn that direction into concrete contracts rather than leave it as architecture prose.

This plan now reflects the actual output of the docs pass. The storage/discovery doc was upgraded from a draft into an implementation-guiding contract covering package folder shape, YAML schema direction for each authored record type, package authority boundaries, exact relationship rules, `workouts.db` table direction, and per-workout leaderboard cache DB direction. Supporting docs were aligned so the content-model and glossary agree with the same decisions.

This work belongs in `aerobeat-docs` because the docs repo is the current review surface. The decisions remain explicitly linked back to the active AeroBeat definition thread in `aerobeat-content-core`.

---

## REFERENCES

| ID | Description | Path |
| --- | --- | --- |
| `REF-01` | Active AeroBeat definition-phase plan and current decision log | `projects/aerobeat/aerobeat-content-core/.plans/2026-04-23-aerobeat-content-core-first-implementation-slice.md` |
| `REF-02` | Current content-model architecture doc | `projects/aerobeat/aerobeat-docs/docs/architecture/content-model.md` |
| `REF-03` | Current storage/discovery contract doc | `projects/aerobeat/aerobeat-docs/docs/architecture/workout-package-storage-and-discovery.md` |
| `REF-04` | Yesterday’s AeroBeat handoff/memory summary | `memory/2026-04-24-workout-schema.md` |

---

## Tasks

### Task 1: Define canonical YAML schema shapes

**Bead ID:** `aerobeat-docs-ugz`  
**SubAgent:** `primary` (for `research`)  
**Role:** `research`  
**References:** `REF-01`, `REF-02`, `REF-03`, `REF-04`  
**Prompt:** Define the canonical field set, ownership notes, and relationship rules for each authored YAML record in the workout package system: `workout.yaml`, `songs/*.yaml`, `routines/*.yaml`, `charts/*.yaml`, `coaches/*.yaml`, `environments/*.yaml`, and `assets/*.yaml`. Include per-song environment selection, per-song asset selections by type, one coach config YAML per workout, self-contained package rules, duplication/fork rules, and what stays intentionally out of package YAML (discoverability, authoritative scores, athlete-specific overrides).

**Folders Created/Deleted/Modified:**
- `docs/architecture/`
- `docs/gdd/glossary/`
- `.plans/`

**Files Created/Deleted/Modified:**
- `docs/architecture/workout-package-storage-and-discovery.md`
- `docs/architecture/content-model.md`
- `docs/gdd/glossary/terms.md`
- this plan file

**Status:** ✅ Complete  

**Results:** Documented the canonical authored YAML direction in `REF-03` for `workout.yaml`, `songs/*.yaml`, `routines/*.yaml`, `charts/*.yaml`, `coaches/coach-config.yaml`, `environments/*.yaml`, and `assets/*.yaml`. Locked the following key schema decisions into the docs: self-contained package-local references for v1 validation, one coach-config file per package, coach-config may define multiple featured coaches, one environment plus one asset per asset type per workout entry, duplication/forking instead of inheritance/patch layering, and explicit separation of authored package truth from discovery/score/cache concerns.

---

### Task 2: Define SQLite structures for catalog + leaderboard cache

**Bead ID:** `aerobeat-docs-0gs`  
**SubAgent:** `primary` (for `research`)  
**Role:** `research`  
**References:** `REF-01`, `REF-03`, `REF-04`  
**Prompt:** Define the SQLite structures for (1) the global/local `workouts.db` catalog index and (2) the per-workout leaderboard cache DB. Make the authority boundaries explicit: `workouts.db` owns discoverability/search/catalog metadata; the leaderboard cache DB is local, disposable, and non-authoritative; server API remains authoritative for score submission and player-wide stats. Include the intended upload/submission behavior where leaderboard cache data is ignored/removed during workout package validation/submission.

**Folders Created/Deleted/Modified:**
- `docs/architecture/`
- `.plans/`

**Files Created/Deleted/Modified:**
- `docs/architecture/workout-package-storage-and-discovery.md`
- this plan file

**Status:** ✅ Complete  

**Results:** Defined the minimum v1 SQLite direction in `REF-03`. `workouts.db` now has explicit table guidance for `workouts`, `workout_tags`, `workout_modes`, `workout_difficulties`, `workout_songs`, and `workout_assets`, plus authority notes that it is a derived install/discovery index rather than authored truth. The per-workout `cache/leaderboard-cache.db` direction now includes `cache_meta`, `leaderboard_entries`, and `leaderboard_sync_runs`, with explicit rules that the cache is disposable, non-authoritative, and ignored/stripped during package submission/export.

---

### Task 3: Update the docs repo with the locked package-system definition

**Bead ID:** `aerobeat-docs-18m`  
**SubAgent:** `primary` (for `coder`)  
**Role:** `coder`  
**References:** `REF-01`, `REF-02`, `REF-03`, `REF-04`  
**Prompt:** Update `aerobeat-docs` so the current package-system decisions are recorded clearly and consistently. Ensure the docs explain the full package map, YAML domain boundaries, catalog vs package authority split, leaderboard cache rules, package duplication/fork philosophy, and current self-contained-package validation requirement.

**Folders Created/Deleted/Modified:**
- `docs/architecture/`
- `docs/gdd/glossary/`
- `.plans/`

**Files Created/Deleted/Modified:**
- `docs/architecture/content-model.md`
- `docs/architecture/workout-package-storage-and-discovery.md`
- `docs/gdd/glossary/terms.md`
- this plan file

**Status:** ✅ Complete  

**Results:** Updated the docs repo so the package-system definition is now coherent across the main architecture surfaces. `REF-03` became the implementation-guiding package/storage/schema contract. `REF-02` now states the package boundary in self-contained terms and includes coaches/environments/assets plus the duplication/fork rule. The glossary now defines `Workout Package`, `Coach Config`, `Asset`, `workouts.db`, and `Leaderboard Cache` so downstream docs can reuse the same vocabulary.

---

### Task 4: QA + audit the resulting architecture docs for completeness and gaps

**Bead ID:** `aerobeat-docs-agv`  
**SubAgent:** `primary` (for `qa` then `auditor`)  
**Role:** `qa` / `auditor`  
**References:** `REF-01`, `REF-02`, `REF-03`, `REF-04`  
**Prompt:** Independently review the updated docs to confirm they reflect the actual decisions Derrick and Chip made, that no older wording contradicts the new package-system model, and that the remaining open questions are explicitly identified instead of hidden.

**Folders Created/Deleted/Modified:**
- `docs/architecture/`
- `.plans/`

**Files Created/Deleted/Modified:**
- `docs/architecture/content-model.md`
- this plan file

**Status:** ✅ QA complete / ⏳ auditor pending  

**Results:** QA reviewed `REF-02`, `REF-03`, the glossary, this plan, and commit `9353c21d93135afdacbd89c9039e5a9f85227398`. Two clear contract-weakening issues were fixed in a follow-up QA patch: (1) `REF-02` still described `Workout` ownership using older `coachId` / `coachName` / workout-level background-scene wording instead of the now-locked single `coachConfigId` plus per-entry environment/asset selection model, and (2) the minimal shared chart-envelope example still included `hitWindowMs` even though the doc says mode-global hit windows should stay out of durable chart content. After the patch, the main remaining QA note for the independent auditor is to truth-check whether the intentionally loose areas (for example the exact shared field set on every YAML record and how much coach/avatar media belongs under generic `assets/` versus coach-config references) match the real decision thread, since those are framed as direction rather than strict finalized schema.

---

## Actual Decisions Locked In During This Pass

- `workout.yaml` is the package root and combines workout/session data with package/schema/tool metadata.
- `songs/`, `routines/`, `charts/`, `coaches/`, `environments/`, and `assets/` are all first-class content-domain folders.
- `coaches/` contains exactly one coach-config YAML file per package.
- That single coach-config file may define multiple featured coaches and overlay/media mappings.
- Session entries resolve exact ids and choose one `environmentId` plus one asset per asset type.
- `workouts.db` is the install/discovery/search index only; discoverability does not live in package YAML.
- `cache/leaderboard-cache.db` is local, disposable, non-authoritative, and excluded from canonical submission payloads.
- Packages are v1 self-contained for validation/playback; alternate versions come from duplication/forking rather than inheritance or patch layering.
- Runtime may still unload/reload per entry transition even when consecutive entries reuse the same environment or asset ids.
- First-party/built-in assets and environments are future content under the same conceptual package system, not a separate exception path.

---

## Final Results

**Status:** ⚠️ Awaiting QA/Audit

**What We Built:** The docs repo now contains an implementation-guiding package contract for AeroBeat’s authored YAML records and SQLite index/cache structure, plus aligned supporting docs/glossary.

**Reference Check:**
- `REF-01` lineage preserved and reflected in final package decisions.
- `REF-02` updated to align package-boundary wording with the new schema/storage contract.
- `REF-03` is now the primary review surface for the package-system definition.
- `REF-04` decision thread carried forward where relevant.

**Commits:**
- Pending coder commit in this subagent pass.

**Lessons Learned:** The key missing piece was not more concept discussion but explicit authority boundaries. Once the docs clearly separated authored truth from search/index/cache state, the rest of the package contract became much easier to define coherently.

---

*Updated on 2026-04-25*