# AeroBeat Docs

**Date:** 2026-04-27  
**Status:** In Progress  
**Agent:** Chip 🐱‍💻

---

## Goal

Review and refine the demo workout package `charts/*.yaml` contract so it matches the now-locked set-centered v1 package model and the already-reviewed workout/song/set/coaching/SQLite boundaries.

---

## Overview

This is the next intentional slice after the prior workout-YAML alignment pass. The root `workout.yaml` contract is already locked, the package model is now Song → Chart → Set → Workout, and the docs/examples have already been normalized away from the old routine-centered shape. That means the remaining review should focus narrowly on what a chart record is allowed to own, what it must not own, and whether the comments/examples teach the right boundaries.

The main risk here is subtle contract drift: charts accidentally reintroducing composition wiring that belongs in `sets/*.yaml`, song linkage that belongs outside the chart record, or device/runtime assumptions that are too specific for the intended authored contract. We should review the chart examples field-by-field first, then pressure-test them against external charting/spec precedents before applying edits and running the normal coder → QA → auditor loop.

Derrick also explicitly wants a comparison packet against StepMania, osu!, Just Dance, Beat Saber, and Supernatural so the package/chart contract is evaluated against real shipping or de facto chart-authoring models, especially where those systems directly shape gameplay feel, authoring affordances, coaching/choreography coupling, and difficulty representation.

---

## REFERENCES

| ID | Description | Path |
| --- | --- | --- |
| `REF-01` | Prior completed alignment pass and explicit note that charts are the next review slice | `projects/aerobeat/aerobeat-docs/.plans/archive/2026-04-27-aerobeat-workout-yaml-alignment-pass.md` |
| `REF-02` | Current demo chart example: Neon Stride | `projects/aerobeat/aerobeat-docs/docs/examples/workout-packages/demo-neon-boxing-bootcamp/charts/ab-chart-neon-stride-boxing-medium.yaml` |
| `REF-03` | Current demo chart example: Midnight Sprint | `projects/aerobeat/aerobeat-docs/docs/examples/workout-packages/demo-neon-boxing-bootcamp/charts/ab-chart-midnight-sprint-boxing-hard.yaml` |
| `REF-04` | Canonical package/storage contract, including chart boundaries | `projects/aerobeat/aerobeat-docs/docs/architecture/workout-package-storage-and-discovery.md` |
| `REF-05` | Canonical content-model wording for Song → Chart → Set → Workout | `projects/aerobeat/aerobeat-docs/docs/architecture/content-model.md` |
| `REF-06` | Demo package overview used as reader-facing teaching surface | `projects/aerobeat/aerobeat-docs/docs/guides/demo_workout_package.md` |

---

## Tasks

### Task 1: Audit the current `charts/*.yaml` contract

**Bead ID:** `aerobeat-docs-3ue`  
**SubAgent:** `primary` (for `research`)  
**Role:** `research`  
**References:** `REF-01`, `REF-02`, `REF-03`, `REF-04`, `REF-05`, `REF-06`  
**Prompt:** Review the current demo `charts/*.yaml` files field-by-field against the now-locked set-centered v1 package contract. Claim bead `aerobeat-docs-3ue` at start with `bd update aerobeat-docs-3ue --status in_progress --json` and close it when done if the research pass is complete. Identify which fields/comments clearly belong in authored chart YAML, which ones feel redundant or weakly justified, whether any comments still imply composition/linkage that belongs in `sets/*.yaml`, and whether the boxing example payload teaches the right long-term chart shape. Pressure-test the shape against AeroBeat’s multi-feature needs (`boxing`, `flow`, `step`, `dance`) and compare the contract direction against how charting is handled in StepMania, osu!, Just Dance, Beat Saber, and Supernatural. Produce a concrete keep/change/remove recommendation list with rationale, plus explicit notes on what should be feature-agnostic core chart envelope vs mode-specific payload.

**Folders Created/Deleted/Modified:**
- `docs/examples/workout-packages/demo-neon-boxing-bootcamp/charts/`
- `.plans/`

**Files Created/Deleted/Modified:**
- `docs/examples/workout-packages/demo-neon-boxing-bootcamp/charts/ab-chart-neon-stride-boxing-medium.yaml`
- `docs/examples/workout-packages/demo-neon-boxing-bootcamp/charts/ab-chart-midnight-sprint-boxing-hard.yaml`
- related docs only if needed for consistency notes

**Status:** ✅ Complete

**Results:** Research audit completed and bead `aerobeat-docs-3ue` was closed. The current chart examples are broadly aligned with the locked Song → Chart → Set → Workout model, but the pass surfaced several contract-boundary concerns: `validatedInputProfiles` should be removed from authored chart YAML; `supportedInputProfiles`, `presentationHints`, and `scoringHints` should be treated as optional hint-level metadata if they survive at all; and the docs need a cleaner statement that the outer chart envelope is shared while `events[*]` are mode-specific payloads. The research also established that the current examples are boxing-led but not structurally wrong; the main risk is accidentally freezing a boxing-shaped mental model before timing, interaction-family, and marker/signal decisions are locked.

---

### Task 2: Gather external charting specifications and precedent notes

**Bead ID:** `aerobeat-docs-hcu`, `aerobeat-docs-sy5`, `aerobeat-docs-dhn`  
**SubAgent:** `primary` (for `research`)  
**Role:** `research`  
**References:** `REF-02`, `REF-03`, `REF-04`, `REF-05`, `REF-06`  
**Prompt:** Gather concrete charting/specification references for StepMania, osu!, Just Dance, Beat Saber, and Supernatural. Focus on: file/package structure, difficulty representation, timing model, gameplay object/event vocabulary, mode-specific payload shape, choreography/coaching coupling, and what parts are durable authored truth vs runtime or presentation behavior. Produce a comparison packet that makes it easy to line those systems up against AeroBeat’s chart contract decisions.

**Folders Created/Deleted/Modified:**
- `docs/examples/workout-packages/demo-neon-boxing-bootcamp/charts/`
- any directly coupled docs pages if required

**Files Created/Deleted/Modified:**
- chart YAML example files
- any directly related docs that must stay in sync

**Status:** ✅ Complete

**Results:** All three research lanes completed and their beads were closed: `aerobeat-docs-hcu` (StepMania + osu!), `aerobeat-docs-sy5` (Beat Saber + Just Dance), and `aerobeat-docs-dhn` (Supernatural + AeroBeat synthesis). The comparison packet validated the high-level Song → Chart → Set → Workout direction, strongly reinforced keeping song timing-map ownership separate from chart gameplay ownership, reinforced the split between a shared chart envelope and mode-specific event payloads, and provided explicit pressure-test points around chart movement semantics, timing/control structures, and the likely usefulness of generic chart-authored marker/signal events. The Supernatural follow-up also strengthened the current AeroBeat coaching direction: intro/outro video plus in-workout VO over music is the best-supported public inference, with no strong evidence yet that a triggered clip graph is required for v1.

---

### Task 3: Apply approved chart-contract changes

**Bead ID:** `Pending`  
**SubAgent:** `primary` (for `coder`)  
**Role:** `coder`  
**References:** `REF-02`, `REF-03`, `REF-04`, `REF-05`, `REF-06`  
**Prompt:** Apply the approved chart YAML changes and update any directly coupled docs/examples so the chart contract teaches the right boundaries. Keep charts reusable, exact, and set-independent. Do not reintroduce routine-era linkage, song back-links, or discoverability/install metadata.

**Folders Created/Deleted/Modified:**
- same as implementation scope

**Files Created/Deleted/Modified:**
- same as implementation scope

**Status:** ⏸️ Deferred

**Results:** Not started. Derrick approved several directional decisions before implementation: keep `Song -> Chart -> Set -> Workout`; remove `validatedInputProfiles`; do not add a numeric difficulty rating; keep movement tags/modifiers as the athlete-facing movement system; keep sets lean; and pause edits until two design slices are resolved in a fresh session: (A) timing truth / timing-map ownership and (B) chart-authored marker/signal events.

---

### Task 4: Verify and independently audit the chart-contract pass

**Bead ID:** `Pending`  
**SubAgent:** `primary` (for `qa` then `auditor`)  
**Role:** `qa` / `auditor`  
**References:** `REF-02`, `REF-03`, `REF-04`, `REF-05`, `REF-06`  
**Prompt:** Verify that the final chart examples and any coupled docs consistently reflect the locked package model. Confirm charts remain exact playable slices, carry only chart-owned metadata plus mode-specific event payload, and do not imply that charts own composition, song linkage, coaching ownership, or SQLite/discovery concerns. Close the bead only if the pass is genuinely coherent.

**Folders Created/Deleted/Modified:**
- same as implementation scope

**Files Created/Deleted/Modified:**
- same as implementation scope

**Status:** ⏸️ Deferred

**Results:** Deferred until Task 3 happens. The next session should start with Slice A (timing truth, beat vs time, song timing maps, conversion examples in multiple time signatures) and then Slice B (marker/signal event design, enum vocabulary, payload guarantees, and how engine systems subscribe to those authored signals).

---

## Final Results

**Status:** ⚠️ Partial / Paused for next session

**What We Built:** Completed the research and decision-framing pass for AeroBeat chart YAML without yet editing the chart examples. We now have: (1) a field-by-field audit of the current chart contract, (2) external charting/spec precedent from StepMania, osu!, Beat Saber, Just Dance, and Supernatural, and (3) Derrick-approved directional calls for the next implementation pass. The chart model remains Song → Chart → Set → Workout; `validatedInputProfiles` is slated for removal; numeric difficulty ratings are out for now; and the two intentionally next unresolved slices are timing truth/timing maps and chart-authored marker/signal events.

**Reference Check:** `REF-01` through `REF-06` were used for the local contract audit, while the external precedent packet pressure-tested those docs against real chart/package systems and curated VR fitness behavior. The high-level repo direction still holds after that comparison.

**Commits:**
- Pending commit for this plan handoff

**Lessons Learned:** The current chart examples are close enough that the biggest risk is not a dramatic rewrite but locking the wrong abstractions too early. Timing truth and marker/signal semantics should be decided before editing the canonical chart examples so the docs do not teach a half-right model.

---

*Completed on 2026-04-27 (paused for next session handoff)*
