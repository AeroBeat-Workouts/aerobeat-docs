# AeroBeat GodotEnv Architecture Cleanup

**Date:** 2026-04-17  
**Status:** Complete  
**Agent:** Pico 🐱‍🏍

---

## Goal

Audit the full AeroBeat repo family and plan the architecture cleanup required to standardize dependency management around GodotEnv, retire obsolete setup/linking scripts, and update the docs to match the new model.

---

## Overview

AeroBeat is preparing to return to active development with a cleaner architecture and a better agentic workflow than the project had when many of the current repo conventions were created. Based on the research completed today, the target direction is an addon-first dependency model managed through GodotEnv manifests rather than a mix of custom setup scripts, submodules, and ad hoc symlink logic.

This work is broader than a single repo change. It affects package repos, assembly repos, templates, and the docs repo. We need a clear inventory of the current state before deciding what gets migrated, what gets deleted, and what needs transitional support. In particular, we need to identify which repos currently use `setup_dev.py`, `.testbed` linking conventions, submodules, template scaffolding, repo-local dependency assumptions, and docs that describe the old spoke-and-wheel model.

The output of this effort should be an actionable migration plan and repo-by-repo impact map. That includes documentation updates, a dedicated GodotEnv section/page in `aerobeat-docs`, and a list of scripts/workflows that can likely be removed once the new approach is adopted.

---

## REFERENCES

| ID | Description | Path |
| --- | --- | --- |
| `REF-01` | Derrick's requested architecture cleanup scope from current chat | `webchat conversation 2026-04-17` |
| `REF-02` | Package architecture research memo | `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-docs/docs/architecture/package-dependency-research.md` |
| `REF-03` | AeroBeat docs repo as coordination/docs owner | `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-docs` |
| `REF-04` | AeroBeat mono-folder containing the repo family to audit | `/home/derrick/.openclaw/workspace/projects/aerobeat` |

---

## Tasks

### Task 1: Audit current repo family for dependency/setup architecture

**Bead ID:** `oc-rlv`  
**SubAgent:** `research`  
**References:** `REF-01`, `REF-02`, `REF-04`  
**Prompt:** Audit the AeroBeat repo family, including templates, to inventory current dependency/setup architecture. For each relevant repo, identify current use of setup scripts, submodules, symlink logic, `.testbed` structure, dependency assumptions on `aerobeat-core` / `aerobeat-ui-core`, and whether the repo appears to be a package repo, contract repo, assembly repo, template, docs repo, or other supporting repo.

**Folders Created/Deleted/Modified:**
- `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-docs/.plans/`
- `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-docs/docs/`

**Files Created/Deleted/Modified:**
- `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-docs/.plans/2026-04-17-aerobeat-godotenv-architecture-cleanup.md`
- `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-docs/docs/architecture/godotenv-migration-audit.md`

**Status:** ✅ Complete

**Results:** Audited the full AeroBeat repo family and documented the current dependency/setup architecture in `docs/architecture/godotenv-migration-audit.md`. The audit covers repo classifications, recurring `setup_dev.py` / `.testbed` / submodule / UI sync patterns, and the foundational dependency role of `aerobeat-core` / `aerobeat-ui-core` with local evidence citations.

---

### Task 2: Produce repo-by-repo impact map for GodotEnv migration

**Bead ID:** `oc-7ct`  
**SubAgent:** `research`  
**References:** `REF-01`, `REF-02`, `REF-04`  
**Prompt:** Based on the audit, produce a repo-by-repo impact map for migrating to a GodotEnv-centered dependency architecture. For each repo, note likely changes, transitional concerns, which scripts can likely be removed, which docs will need updates, and whether the repo should own an `addons.jsonc`, a `.testbed` manifest, or other new dependency metadata.

**Folders Created/Deleted/Modified:**
- `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-docs/docs/`

**Files Created/Deleted/Modified:**
- `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-docs/docs/architecture/godotenv-migration-audit.md`

**Status:** ✅ Complete

**Results:** Produced a repo-by-repo GodotEnv migration impact map in `docs/architecture/godotenv-migration-audit.md`. Every audited repo now has a migration target, current-state summary, and likely cleanup/removal work called out, including templates and supporting repos.

---

### Task 3: Identify required docs revisions and new GodotEnv documentation

**Bead ID:** `oc-6yw`  
**SubAgent:** `research`  
**References:** `REF-01`, `REF-02`, `REF-03`  
**Prompt:** Review `aerobeat-docs` and identify which sections describe or imply the old architecture/workflows. Propose specific docs changes, including a new page/section for GodotEnv usage, dependency modes (tag/branch/symlink), `.testbed` expectations, contract repo responsibilities, and assembly/package repo conventions.

**Folders Created/Deleted/Modified:**
- `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-docs/docs/`

**Files Created/Deleted/Modified:**
- `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-docs/docs/architecture/godotenv-migration-audit.md`

**Status:** ✅ Complete

**Results:** Identified the published docs and template source files that still describe the old architecture/workflow, and captured a docs revision map plus a proposed new `GodotEnv` documentation page structure in `docs/architecture/godotenv-migration-audit.md`.

---

### Task 4: Produce an execution-ready migration plan

**Bead ID:** `oc-7pe`  
**SubAgent:** `research`  
**References:** `REF-01`, `REF-02`, `REF-03`, `REF-04`  
**Prompt:** Convert the audit and impact analysis into an execution-ready migration plan for the architecture cleanup. Include sequencing, likely bead/task breakdowns, suggested pilot repos, risk areas, and a recommendation for how to phase script removal, docs updates, and repo migrations without losing active development ergonomics.

**Folders Created/Deleted/Modified:**
- `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-docs/docs/`

**Files Created/Deleted/Modified:**
- `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-docs/docs/architecture/godotenv-migration-audit.md`

**Status:** ✅ Complete

**Results:** Converted the audit into an execution-ready migration plan in `docs/architecture/godotenv-migration-audit.md`, including sequencing, pilot repos, risks, transitional wrapper guidance, and a suggested bead/task breakdown for implementation.

---

## Final Results

**Status:** ✅ Complete

**What We Built:** Produced `docs/architecture/godotenv-migration-audit.md`, a single consolidated architecture audit covering the current repo-family inventory, repo-by-repo impact map, docs revision map, proposed new GodotEnv documentation structure, and an execution-ready migration plan for the AeroBeat GodotEnv cleanup.

**Reference Check:** Satisfied `REF-01` through `REF-04` by auditing the full repo family, using the earlier research memo as a reference point, and documenting the results in the docs-owning repo with concrete local evidence citations.

**Commits:**
- Not created in this research pass.

**Lessons Learned:** The family-wide cleanup is broad but very repetitive: most repos share the same `setup_dev.py` + `.testbed` bootstrap shape, while the real architectural special cases are the assembly repo, UI shell sync flow, docs/template source-of-truth, and the MediaPipe Python sidecar.

---

*Completed on 2026-04-17*
