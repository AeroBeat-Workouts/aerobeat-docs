# AeroBeat Docs

**Date:** 2026-05-15  
**Status:** Stale  
**Agent:** Cookie 🍪

---

## Goal

Audit and fix documentation references for the new environment family rename, then update the architecture docs so `aerobeat-environment-core`, `aerobeat-environment-loader`, and `aerobeat-environment-gaussian-splat` are represented correctly in the repo/architecture documentation.

---

## Overview

Derrick has already completed the GitHub-side changes and the local repo switchover work is now done. The remaining step is a docs-focused cleanup: make sure the architecture/reference docs no longer point at the old repo names and that the new environment family is documented clearly.

This likely touches the repo inventory / repository-map material first, but it may also require updates in the broader architecture docs that talk about repo families, loader/provider roles, or future environment architecture. Since Derrick believes the architecture plans already list out the repos, the docs pass should explicitly confirm which pages are the source of truth for repo-family inventory and update those, rather than scattering redundant partial lists everywhere.

---

## REFERENCES

| ID | Description | Path |
| --- | --- | --- |
| `REF-01` | Docs repo owning this sweep | `/home/derrick/Documents/projects/aerobeat/aerobeat-docs` |
| `REF-02` | Repo family rollout coordination plan | `/home/derrick/Documents/projects/aerobeat/aerobeat-assembly-community/.plans/2026-05-15-environment-core-rollout-and-repo-rename-coordination.md` |
| `REF-03` | Repository inventory doc likely needing updates | `/home/derrick/Documents/projects/aerobeat/aerobeat-docs/docs/architecture/repository-map.md` |
| `REF-04` | Repo shape / architecture reference likely needing updates | `/home/derrick/Documents/projects/aerobeat/aerobeat-docs/docs/architecture/repo-structure-reference.md` |
| `REF-05` | Content repo shapes / architecture family docs that may mention environment family positioning | `/home/derrick/Documents/projects/aerobeat/aerobeat-docs/docs/architecture/content-repo-shapes.md` |
| `REF-06` | New environment family repos | `/home/derrick/Documents/projects/aerobeat/aerobeat-environment-core`, `/home/derrick/Documents/projects/aerobeat/aerobeat-environment-loader`, `/home/derrick/Documents/projects/aerobeat/aerobeat-environment-gaussian-splat` |

---

## Tasks

### Task 1: Audit docs references to old environment repo names and identify the source-of-truth architecture pages

**Bead ID:** `aerobeat-docs-734`  
**SubAgent:** `primary` (for `research` workflow role)  
**Role:** `research`  
**References:** `REF-01`, `REF-03`, `REF-04`, `REF-05`, `REF-06`  
**Prompt:** In repo `/home/derrick/Documents/projects/aerobeat/aerobeat-docs`, claim the assigned bead and audit all active docs references to the old repo names (`aerobeat-tool-environment`, `aerobeat-tool-gaussian-splat`). Also identify which architecture docs are the authoritative places to list or describe the environment family repos so the update is centralized and coherent.

**Folders Created/Deleted/Modified:**
- Docs only expected

**Files Created/Deleted/Modified:**
- Audit notes only

**Status:** ✅ Complete

**Results:** Audit complete. No active docs under `docs/` still reference the old repo names `aerobeat-tool-environment` or `aerobeat-tool-gaussian-splat`; the only old-name hits in this repo were in this active plan while it still described the task. The architecture source-of-truth pages for this sweep are `docs/architecture/repository-map.md` for live repo inventory/routing, `docs/architecture/workflow.md` for dependency/ownership rules explaining where concrete environment repos fit, and `docs/architecture/repo-structure-reference.md` for concrete repo-family shape examples. `docs/architecture/overview.md` and `docs/architecture/testing.md` were flagged as follow-up touchpoints only if the environment-family rollout implied a lane-count change, but current repo/template evidence shows `aerobeat-environment-core` is a concrete internal environment package built on `aerobeat-asset-core`, not a replacement for the six-core lane model. The next step is to update those source-of-truth routing/ownership docs first, then validate whether broader summary pages need clarifying language.

---

### Task 2: Update repository/architecture docs for the new environment family

**Bead ID:** `aerobeat-docs-bds`  
**SubAgent:** `primary` (for `coder` workflow role)  
**Role:** `coder`  
**References:** `REF-03`, `REF-04`, `REF-05`, `REF-06`  
**Prompt:** Update the docs so the active environment family is represented correctly: `aerobeat-environment-core`, `aerobeat-environment-loader`, and `aerobeat-environment-gaussian-splat`. Replace old active repo-name references, update architecture descriptions as needed, and make sure the docs explain the family roles clearly without over-duplicating the same repo list across many pages.

**Folders Created/Deleted/Modified:**
- `/home/derrick/Documents/projects/aerobeat/aerobeat-docs/docs/architecture/`

**Files Created/Deleted/Modified:**
- `docs/architecture/repository-map.md`
- `docs/architecture/workflow.md`
- `docs/architecture/repo-structure-reference.md`

**Status:** ✅ Complete

**Results:** Updated the source-of-truth architecture pages first instead of scattering ad hoc mentions. `docs/architecture/repository-map.md` now lists the new environment family explicitly and explains each repo's role. `docs/architecture/workflow.md` now explains where `aerobeat-environment-*` repos fit in dependency and ownership terms, including the important clarification that `aerobeat-environment-core` is a concrete internal environment package baseline built on `aerobeat-asset-core`, not a new universal core lane. `docs/architecture/repo-structure-reference.md` now adds concrete environment-family repo examples for `aerobeat-environment-core`, `aerobeat-environment-loader`, and `aerobeat-environment-gaussian-splat`, using the current repo/template reality to describe their expected shapes and boundaries. No broader doc rewrites were needed because the audit showed the old names were not still being taught elsewhere in active docs.

---

### Task 3: Validate docs consistency and record any intentionally historical references left behind

**Bead ID:** `aerobeat-docs-4ts`  
**SubAgent:** `primary` (for `auditor` workflow role)  
**Role:** `auditor`  
**References:** `REF-01`, `REF-03`, `REF-04`, `REF-05`  
**Prompt:** Audit the docs sweep for consistency: confirm active docs no longer point at the old environment repo names, note any remaining historical/archive mentions that should stay as history, and update the plan with the final documentation outcome.

**Folders Created/Deleted/Modified:**
- Docs + plan only expected

**Files Created/Deleted/Modified:**
- docs files as needed
- `.plans/2026-05-15-environment-docs-reference-audit-and-core-rollout.md`

**Status:** ✅ Complete

**Results:** Validation complete. `git diff --check` passed, and repo-wide `grep` over `docs/` confirmed that no active docs still reference `aerobeat-tool-environment` or `aerobeat-tool-gaussian-splat`. The new family names now appear in the updated source-of-truth pages exactly where expected. A `mkdocs` strict build was attempted as an extra validation pass, but the current repo environment does not have the `mkdocs` module installed, so that check could not run here. The only remaining old-name references in this repo are intentional historical mentions inside this active plan, where they are preserved to describe the audit target and task history.

---

## Final Results

**Status:** ✅ Complete

**What We Built:** Audited and updated the AeroBeat docs source-of-truth architecture pages so the environment family is now documented as `aerobeat-environment-core`, `aerobeat-environment-loader`, and `aerobeat-environment-gaussian-splat`, with clear routing, ownership, and repo-shape guidance.

**Reference Check:** `REF-03`, `REF-04`, and `REF-05` were updated directly as the source-of-truth pages, and `REF-06` was checked against the live environment repos/templates to keep the docs aligned with reality. `REF-01` remained clean of active old-name docs references after the sweep. The rollout remained consistent with the broader family direction recorded in `REF-02`.

**Commits:**
- `d0293ce` - `docs: document environment family rollout`

**Lessons Learned:** Repo-family renames are only really complete once the source-of-truth docs explain the new boundaries clearly and explicitly state whether a renamed family is a new architecture lane versus a concrete package family layered on an existing core.

---

*Completed on 2026-05-15*
