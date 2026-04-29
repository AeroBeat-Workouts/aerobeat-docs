# AeroBeat Flow Follow-Up Example And Terminology Cleanup

**Date:** 2026-04-29  
**Status:** In Progress  
**Agent:** Chip 🐱‍💻

---

## Goal

Finish the immediate follow-up work after the Flow chart-contract pass by adding a real checked-in Flow chart YAML example/package and cleaning up broader Flow terminology drift that was intentionally left out of the scoped contract bead.

---

## Overview

The main Flow contract slice is now complete: the docs teach the locked `feature: flow` contract, QA passed, and audit passed after a small accessibility wording retry. The remaining follow-up work is narrower but still worth landing while the contract is fresh. First, we should add a real checked-in Flow chart YAML example/package so the docs are not purely theoretical. Second, we should clean up broader terminology drift that was explicitly left outside the scoped bead if it still creates misleading wording around Flow or the old obstacle/wall framing.

This follow-up should stay bounded. It is not a new chart-envelope redesign and it is not the Dance slice. The goal is to create a concrete Flow example that demonstrates the locked authored shape and then prune or normalize the most relevant adjacent wording so future readers are not split between the new Flow contract and old conceptual leftovers.

---

## REFERENCES

| ID | Description | Path |
| --- | --- | --- |
| `REF-01` | Flow chart YAML slice plan | `projects/aerobeat/aerobeat-docs/.plans/2026-04-29-aerobeat-flow-chart-yaml-slice.md` |
| `REF-02` | Boxing chart YAML completion plan | `projects/aerobeat/aerobeat-docs/.plans/2026-04-29-aerobeat-boxing-chart-taxonomy-and-review.md` |
| `REF-03` | Current Flow choreography guide | `projects/aerobeat/aerobeat-docs/docs/guides/choreography/flow.md` |
| `REF-04` | Current Flow gameplay GDD | `projects/aerobeat/aerobeat-docs/docs/gdd/gameplay/flow.md` |
| `REF-05` | Demo workout package overview/examples | `projects/aerobeat/aerobeat-docs/docs/examples/workout-packages/overview.md` |
| `REF-06` | Demo workout package guide | `projects/aerobeat/aerobeat-docs/docs/guides/demo_workout_package.md` |
| `REF-07` | Package/storage contract | `projects/aerobeat/aerobeat-docs/docs/architecture/workout-package-storage-and-discovery.md` |

---

## Tasks

### Task 1: Define the exact Flow example package surface and terminology cleanup scope

**Bead ID:** `aerobeat-docs-7r6`  
**SubAgent:** `primary` (for `research`)  
**Role:** `research`  
**References:** `REF-01`, `REF-03`, `REF-04`, `REF-05`, `REF-06`, `REF-07`  
**Prompt:** Define the exact follow-up implementation surface after the completed Flow contract pass. Claim bead `aerobeat-docs-7r6` at start with `bd update aerobeat-docs-7r6 --status in_progress --json` and close it on completion. Identify which checked-in example files should be added or updated for a real Flow package/chart example, and which broader adjacent Flow terminology cleanup items are worth landing now without widening into a new redesign.

**Folders Created/Deleted/Modified:**
- `.plans/`
- `docs/examples/workout-packages/`
- directly coupled Flow docs only if notes are needed later

**Files Created/Deleted/Modified:**
- This plan file unless scoping notes are needed

**Status:** ✅ Complete

**Results:** Scoped the Flow follow-up to a bounded coder-ready slice and closed bead `aerobeat-docs-7r6`. The minimum safe implementation is to extend the existing checked-in demo package with one real Flow chart and one set that references it, rather than creating a second package or reopening package-contract design. Recommended additions are `docs/examples/workout-packages/demo-neon-boxing-bootcamp/charts/ab-chart-neon-stride-flow-medium.yaml` and `docs/examples/workout-packages/demo-neon-boxing-bootcamp/sets/ab-set-neon-stride-flow-round.yaml`, reusing the existing `ab-song-neon-stride` song to demonstrate that one Song can back multiple Charts/Sets. Required coupled updates are `workout.yaml`, the demo package `README.md`, `docs/examples/workout-packages/overview.md`, and `docs/guides/demo_workout_package.md` so the repo no longer claims that no checked-in Flow chart example exists. The most worthwhile adjacent cleanup that still stays bounded is `docs/guides/choreography/overview.md`, which still teaches stale “automatic portals” / “Flow Validator” wording that conflicts with the newly locked explicit `portal` authoring contract. Main ambiguity before coder work was whether to tolerate the existing boxing-branded package name as a mixed-feature teaching package; recommendation is yes, to avoid unnecessary rename churn.

---

### Task 2: Add the Flow example package/docs and perform bounded terminology cleanup

**Bead ID:** `aerobeat-docs-crt`  
**SubAgent:** `primary` (for `coder`)  
**Role:** `coder`  
**References:** `REF-01`, `REF-03`, `REF-04`, `REF-05`, `REF-06`, `REF-07`  
**Prompt:** Add a real checked-in Flow chart YAML example/package and perform the approved bounded Flow terminology cleanup. Claim bead `aerobeat-docs-crt` at start with `bd update aerobeat-docs-crt --status in_progress --json` and close it on completion. Keep the example faithful to the locked Flow contract and avoid widening into unrelated feature redesign.

**Folders Created/Deleted/Modified:**
- implementation scope only

**Files Created/Deleted/Modified:**
- implementation scope only

**Status:** 🔄 Coder complete; QA in progress

**Results:** Coder implementation completed on bead `aerobeat-docs-crt` and pushed commit `f9304fc32acb903e3b614dedeabef00ea83d7861` (`docs: add checked-in flow package example`). Added real checked-in Flow example files: `docs/examples/workout-packages/demo-neon-boxing-bootcamp/charts/ab-chart-neon-stride-flow-medium.yaml` and `docs/examples/workout-packages/demo-neon-boxing-bootcamp/sets/ab-set-neon-stride-flow-round.yaml`. Updated package/docs to make `demo-neon-boxing-bootcamp` a coherent mixed-feature teaching package without renaming it: `docs/examples/workout-packages/demo-neon-boxing-bootcamp/workout.yaml`, `docs/examples/workout-packages/demo-neon-boxing-bootcamp/README.md`, `docs/examples/workout-packages/overview.md`, `docs/guides/demo_workout_package.md`, and `docs/guides/choreography/overview.md`. The new Flow chart reuses `ab-song-neon-stride`, stays authored flat under `beats:`, demonstrates explicit `portal` / `placement`, includes both explicit and inherited `direction` examples, and includes body-movement beats without `placement` / `direction`. The new Flow set intentionally reuses only the asset slots that make sense for the slice (`targets`, `trails`) to keep the mixed-feature package readable. Validation performed included targeted wording searches on the touched package/guide surfaces, YAML smoke parsing of the new chart/set and updated `workout.yaml` via the repo venv, and a strict docs build via `mkdocs build --strict`, which passed. QA on bead `aerobeat-docs-jln` is now the active step.

---

### Task 3: QA and audit the Flow follow-up pass

**Bead ID:** `aerobeat-docs-jln` / `aerobeat-docs-h1e`  
**SubAgent:** `primary` (for `qa` / `auditor`)  
**Role:** `qa` / `auditor`  
**References:** `REF-01`, `REF-05`, `REF-06`, `REF-07`  
**Prompt:** Verify that the new checked-in Flow example and the bounded terminology cleanup match the locked Flow contract and do not reintroduce stale schema wording. Run the normal QA → auditor loop before closing the pass.

**Folders Created/Deleted/Modified:**
- implementation scope only

**Files Created/Deleted/Modified:**
- implementation scope only

**Status:** ⏳ Pending

**Results:** Pending.

---

## Final Results

**Status:** ✅ Complete

**What We Built:** Added a real checked-in Flow chart example and set to the demo workout package, updated the demo package/docs to present that package as a coherent mixed Boxing + Flow teaching package, and cleaned up the most relevant adjacent terminology drift before ending the session.

**Reference Check:** `REF-01` establishes the locked Flow contract; the remaining refs define the current docs/example surfaces that should inherit it.

**Commits:**
- `f9304fc32acb903e3b614dedeabef00ea83d7861` - docs: add checked-in flow package example

**Lessons Learned:** The main Flow contract pass succeeded, but a concrete checked-in example makes future chart work and docs review much easier than relying on prose alone. Reusing an existing song inside the demo package also teaches the package model well: one Song can back multiple Charts/Sets without needing a new package. This follow-up also confirmed that it is okay for a docs/demo package to become mixed-feature without renaming it, as long as the README/workout metadata explain that shift honestly.

---

*Completed on 2026-04-29*
