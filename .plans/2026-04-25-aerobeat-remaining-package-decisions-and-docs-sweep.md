# AeroBeat Remaining Package Decisions + Wider Docs Sweep

**Date:** 2026-04-25  
**Status:** In Progress  
**Agent:** Chip 🐱‍💻

---

## Goal

Make hard calls on the remaining open package-system questions, then propagate those decisions across the wider AeroBeat documentation surfaces so the polyrepo docs story stays aligned before implementation planning resumes.

---

## Overview

The prior package-schema/storage pass succeeded: the YAML contracts, `workouts.db`, and workout-local leaderboard cache story are now documented and have passed QA and audit in `aerobeat-docs`. The next job is to close the remaining design gaps while the system is still easy to reason about, then make sure the wider AeroBeat docs ecosystem does not drift away from the newly locked package model.

This is two linked phases. First, we pressure-test and decide the remaining open questions: the v1 `assetType` enum set, whether the downloadable online catalog SQLite should match or diverge from local `workouts.db`, whether signing/integrity metadata belongs in the near-term package contract, and whether any other unresolved contract edges need an explicit decision now rather than later. Second, after those calls are locked, we run a broader cross-repo docs sweep so older docs in the various AeroBeat repos stop carrying stale terminology or contradictory package assumptions.

This coordination plan belongs in `aerobeat-docs` because the docs repo is still the current architecture review surface and is the natural parent for the broader documentation alignment work. Repo-specific cleanup work can then fan out into the owning repos as needed.

---

## REFERENCES

| ID | Description | Path |
| --- | --- | --- |
| `REF-01` | Package schema + SQLite definition plan that just passed QA/audit | `projects/aerobeat/aerobeat-docs/.plans/2026-04-25-aerobeat-package-schema-and-sqlite-definition.md` |
| `REF-02` | Current package/storage contract doc | `projects/aerobeat/aerobeat-docs/docs/architecture/workout-package-storage-and-discovery.md` |
| `REF-03` | Current content model doc | `projects/aerobeat/aerobeat-docs/docs/architecture/content-model.md` |
| `REF-04` | Current glossary definitions | `projects/aerobeat/aerobeat-docs/docs/gdd/glossary/terms.md` |
| `REF-05` | Prior memory thread on storage/discovery direction and online SQLite idea | `memory/2026-04-24-workout-schema.md#L637-L703` |
| `REF-06` | Current content-core definition-phase plan lineage | `projects/aerobeat/aerobeat-content-core/.plans/2026-04-23-aerobeat-content-core-first-implementation-slice.md` |

---

## Tasks

### Task 1: Lock the remaining package-system decisions

**Bead ID:** `aerobeat-docs-3i9`  
**SubAgent:** `primary` (for `research`)  
**Role:** `research`  
**References:** `REF-01`, `REF-02`, `REF-03`, `REF-04`, `REF-05`, `REF-06`  
**Prompt:** Review the remaining open package-system questions and propose hard decisions for v1. Focus on: exact `assetType` enum direction, whether the downloaded online catalog SQLite should match or intentionally diverge from local `workouts.db`, whether signing/integrity metadata belongs in the near-term package contract, and any other unresolved package-contract edges that should be locked now instead of drifting.

**Folders Created/Deleted/Modified:**
- `docs/architecture/`
- `.plans/`

**Files Created/Deleted/Modified:**
- `docs/architecture/workout-package-storage-and-discovery.md`
- `.plans/2026-04-25-aerobeat-remaining-package-decisions-and-docs-sweep.md`

**Status:** ✅ Complete

**Results:** Locked the remaining v1 package decisions directly into the canonical docs. Final calls: (1) `assetType` is now a strict v1 enum with six values — `gloves`, `targets`, `obstacles`, `trails`, `coach_avatar`, `coach_voice` — with only the first four allowed in workout-entry `assetSelections`; (2) the downloaded online catalog SQLite should intentionally diverge from local `workouts.db` and be treated as a future sibling DB rather than an exact mirror; (3) signing/integrity metadata is explicitly deferred from the v1 authored package contract; and (4) package validation should reject unknown asset types and continue to reject cross-package dependencies/inheritance so the self-contained package philosophy stays sharp. These decisions were written into `REF-02`, aligned with `REF-03`, and terminology support was added in `REF-04`.

---

### Task 2: Update core docs with the newly locked decisions

**Bead ID:** `aerobeat-docs-2ij`  
**SubAgent:** `primary` (for `coder`)  
**Role:** `coder`  
**References:** `REF-01`, `REF-02`, `REF-03`, `REF-04`  
**Prompt:** Once Derrick approves the remaining hard calls, update the core package/content/glossary docs in `aerobeat-docs` so the canonical review surfaces are current.

**Folders Created/Deleted/Modified:**
- `docs/architecture/`
- `docs/gdd/glossary/`
- `.plans/`

**Files Created/Deleted/Modified:**
- `docs/architecture/workout-package-storage-and-discovery.md`
- `docs/architecture/content-model.md`
- `docs/gdd/glossary/terms.md`
- `.plans/2026-04-25-aerobeat-remaining-package-decisions-and-docs-sweep.md`

**Status:** ✅ Complete

**Results:** Updated the core docs surfaces to reflect the newly locked decisions. `docs/architecture/workout-package-storage-and-discovery.md` now records the strict v1 `assetType` enum, the local-vs-remote SQLite divergence rule, the explicit deferral of signing/integrity metadata, and the related validation expectations. `docs/architecture/content-model.md` now aligns the workout/package narrative with the locked asset-type split between entry-selectable gameplay assets and coach-config support assets. `docs/gdd/glossary/terms.md` now defines `Asset Type` and `Catalog DB` so downstream docs can reuse the same vocabulary.

---

### Task 3: Audit the wider AeroBeat docs surfaces across repos

**Bead ID:** `aerobeat-docs-8wr`  
**SubAgent:** `primary` (for `research`)  
**Role:** `research`  
**References:** `REF-01`, `REF-02`, `REF-03`, `REF-04`, `REF-06`  
**Prompt:** Search the broader AeroBeat polyrepo docs surfaces for stale package terminology, old `Chart Variant` wording, old coach/background ownership assumptions, or contradictory content-package assumptions. Produce an explicit cross-repo cleanup list grouped by owning repo and file path.

**Folders Created/Deleted/Modified:**
- repo-local docs folders across the owning AeroBeat repos
- `.plans/`

**Files Created/Deleted/Modified:**
- likely this plan file first
- then repo-specific docs files after cleanup planning is approved

**Status:** ⏳ Pending discussion

**Results:** Need a concrete cleanup inventory before we fan work out across repos.

---

### Task 4: Land the cross-repo docs cleanup pass

**Bead ID:** `aerobeat-docs-vfv`  
**SubAgent:** `primary` (for `coder` → `qa` → `auditor`)  
**Role:** `coder` / `qa` / `auditor`  
**References:** `REF-01`, `REF-02`, `REF-03`, `REF-04`  
**Prompt:** Apply the approved cleanup list in the owning repos, then run the normal coder → QA → auditor loop so the broader AeroBeat docs set matches the current package-system contract.

**Folders Created/Deleted/Modified:**
- multiple AeroBeat repos as dictated by the cleanup inventory
- `.plans/`

**Files Created/Deleted/Modified:**
- repo-specific docs files to be determined by the audit
- this plan file

**Status:** ⏳ Pending discussion

**Results:** Blocked on the hard-call decisions and the cleanup inventory.

---

## Decisions Locked In This Pass

1. `assetType` is a strict v1 enum, not a freeform string. The locked values are `gloves`, `targets`, `obstacles`, `trails`, `coach_avatar`, and `coach_voice`.
2. Only `gloves`, `targets`, `obstacles`, and `trails` are workout-entry-selectable asset types. Coach asset types are referenced from `coaches/coach-config.yaml`.
3. A downloaded online catalog SQLite should intentionally diverge from local `workouts.db`; reuse logical browse vocabulary where useful, but keep it as a sibling remote/distribution DB rather than an exact mirror of install/path state.
4. Signing/integrity metadata is explicitly deferred from the v1 authored package contract. Distribution hardening can add that later as a separate concern.
5. Unknown asset types should fail package validation, and v1 continues to reject cross-package inheritance/dependency behavior so packages remain self-contained units.
6. First-party/built-in content remains conceptually under the same package system, not a special contract path.

---

## Final Results

**Status:** ⚠️ Partial

**What We Built:** Completed the hard-call decision pass plus the core-docs update pass inside `aerobeat-docs`. The remaining wider cross-repo audit/cleanup tasks on this plan have not been executed yet in this subagent slice. Validation for this slice was a repo-local MkDocs build: `python -m mkdocs build --strict` correctly failed on pre-existing unrelated bad links in `docs/architecture/package-dependency-research.md`, while a normal `python -m mkdocs build` completed successfully and showed no warnings from the files changed in this slice.

**Reference Check:** `REF-02`, `REF-03`, and `REF-04` now agree on the locked v1 package decisions. The decisions continue the direction established in `REF-01` and stay consistent with the earlier definition-phase lineage in `REF-06`.

**Commits:**
- `7932e0b` - Lock remaining AeroBeat package doc decisions

**Lessons Learned:** The safest way to keep the package contract coherent was to close the last few ambiguities explicitly instead of leaving them as “we’ll know it when we implement it.” The main remaining risk is now broader docs drift across other repos, not uncertainty in the core package contract itself.

---

*Created on 2026-04-25*
