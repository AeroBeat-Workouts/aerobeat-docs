# AeroBeat Docs

**Date:** 2026-04-28  
**Status:** In Progress  
**Agent:** Chip 🐱‍💻

---

## Goal

Resolve the next two chart-contract design slices for AeroBeat — timing truth and chart-authored marker/signal events — before any chart YAML implementation edits.

---

## Overview

I picked this up from yesterday’s AeroBeat chart-contract handoff. The prior research pass is already done, the package model is still locked as `Song -> Chart -> Set -> Workout`, and the intentionally deferred work is now narrow: first decide where timing truth lives and how authored charts reference it, then decide whether generic chart-authored marker/signal events belong in the contract and what guarantees they should provide.

Per the handoff, we should begin with a human review of the prior conclusions before we push into implementation. Derrick also explicitly confirmed that these chart decisions likely affect gameplay architecture beyond the chart files themselves, so the review/research pass should actively surface spillover implications for runtime systems, feature contracts, docs, and authoring boundaries instead of treating this as a local YAML cleanup. Once that review is complete, the execution path should stay disciplined: research/decision framing for Slice A, then research/decision framing for Slice B, then only if the decisions feel solid do we create the implementation bead(s) for chart/doc edits and run the normal coder → QA → auditor loop.

---

## REFERENCES

| ID | Description | Path |
| --- | --- | --- |
| `REF-01` | Yesterday’s active chart review plan and paused implementation state | `projects/aerobeat/aerobeat-docs/.plans/2026-04-27-aerobeat-chart-yaml-review.md` |
| `REF-02` | Yesterday’s handoff memory with next-session slice lock-in | `memory/2026-04-27.md` |
| `REF-03` | Canonical package/storage contract | `projects/aerobeat/aerobeat-docs/docs/architecture/workout-package-storage-and-discovery.md` |
| `REF-04` | Canonical content model | `projects/aerobeat/aerobeat-docs/docs/architecture/content-model.md` |
| `REF-05` | Demo package overview / chart teaching surface | `projects/aerobeat/aerobeat-docs/docs/guides/demo_workout_package.md` |
| `REF-06` | Current demo chart example: Neon Stride | `projects/aerobeat/aerobeat-docs/docs/examples/workout-packages/demo-neon-boxing-bootcamp/charts/ab-chart-neon-stride-boxing-medium.yaml` |
| `REF-07` | Current demo chart example: Midnight Sprint | `projects/aerobeat/aerobeat-docs/docs/examples/workout-packages/demo-neon-boxing-bootcamp/charts/ab-chart-midnight-sprint-boxing-hard.yaml` |

---

## Tasks

### Task 1: Human review of the paused chart-contract state

**Bead ID:** `aerobeat-docs-3hs`  
**SubAgent:** `primary` (for `research`)  
**Role:** `research`  
**References:** `REF-01`, `REF-02`, `REF-03`, `REF-04`, `REF-05`, `REF-06`, `REF-07`  
**Prompt:** Reconstruct the current paused state of the AeroBeat chart-contract work from the active plan, current docs, and chart examples. Summarize what is already locked, what is explicitly deferred, and what exact decision questions must be answered next before implementation beads should be created. Claim the bead at start and close it when the review summary is done.

**Folders Created/Deleted/Modified:**
- `.plans/`
- `docs/architecture/`
- `docs/guides/`
- `docs/examples/workout-packages/demo-neon-boxing-bootcamp/charts/`

**Files Created/Deleted/Modified:**
- This plan file only unless consistency notes are required

**Status:** ✅ Complete

**Results:** Reconstructed the paused chart-contract state from the active 2026-04-27 plan plus the current architecture/docs/example charts. Locked direction remains `Song -> Chart -> Set -> Workout`; charts stay reusable exact playable slices that do not link to songs/sets/workouts; sets remain the single source of truth for composition wiring; boxing examples already teach structured event payloads; and the implementation pause is still correctly focused on two unresolved slices: (A) timing truth / timing-map ownership and authored beat-vs-time semantics, and (B) whether charts should own generic authored marker/signal events beyond gameplay events. The review also surfaced spillover beyond chart YAML itself: runtime timing conversion, feature/runtime subscription contracts, docs/examples, authoring/validation tools, and any shared content-core chart/timing interfaces. Recommended execution order remains Slice A first, Slice B second, because the marker/signal design depends on the chosen timing truth and event-addressing model.

---

### Task 2: Slice A — timing truth and timing-map ownership

**Bead ID:** `aerobeat-docs-whp`  
**SubAgent:** `primary` (for `research`)  
**Role:** `research`  
**References:** `REF-01`, `REF-03`, `REF-04`, `REF-05`, `REF-06`, `REF-07`  
**Prompt:** Research and recommend the durable AeroBeat timing contract for authored charts. Decide whether the song owns canonical timing maps, how charts reference that truth, whether events are authored in beats, time, or both, how BPM changes / offsets / multiple time signatures should be represented, and what examples/docs are needed so the contract is teachable and feature-agnostic.

**Folders Created/Deleted/Modified:**
- same as timing/design scope

**Files Created/Deleted/Modified:**
- chart example YAML if implementation is approved later
- directly coupled docs if implementation is approved later

**Status:** ✅ Complete

**Results:** Research completed. Recommended that `songs/*.yaml` own the canonical reusable timing map, while `charts/*.yaml` author gameplay events primarily in beat space against that shared song timing truth. Proposed a richer song-level `timing` contract that can represent anchor offset, BPM/tempo segments, stops/pauses, and optional time-signature segments, while keeping user/device latency offsets out of content. Derrick then explicitly approved the field-level direction: `anchorMs` is approved as the canonical beat-zero anchor in integer milliseconds; `tempoSegments` is approved as the single canonical tempo-map structure with no shortcut/legacy `bpm` alternative; `stopSegments` is approved as required support for StepMania-style timing stops because AeroBeat intends to support `step`; and `timeSignatureSegments` is approved as canonical musical meter plus recommended authoring guidance, while the editor remains free to offer alternate snap/grouping modes with soft indication when the working grid diverges from the song's declared meter. Recommended that chart YAML keep durable authored truth to beat-timed gameplay and authored marker/signal events, with absolute milliseconds, spawn times, and conductor caches treated as derived/runtime data. Also identified the main spillover areas once approved: `aerobeat-content-core` timing types, chart validators/converters, authoring-tool timeline UX, feature-runtime conductor APIs, docs/examples for multi-signature and stop cases, and migration rules for simple constant-BPM songs.

---

### Task 3: Slice B — marker/signal event model

**Bead ID:** `aerobeat-docs-bet`  
**SubAgent:** `primary` (for `research`)  
**Role:** `research`  
**References:** `REF-01`, `REF-03`, `REF-04`, `REF-05`, `REF-06`, `REF-07`  
**Prompt:** Research and recommend whether AeroBeat charts should support generic authored marker/signal events in addition to gameplay events. Define the intended use cases, enum vocabulary, payload guarantees, subscription model expectations for Godot systems, and the line between deterministic authored hooks versus runtime-generated behavior.

**Folders Created/Deleted/Modified:**
- same as signal/design scope

**Files Created/Deleted/Modified:**
- chart example YAML if implementation is approved later
- directly coupled docs if implementation is approved later

**Status:** ✅ Complete

**Results:** Research recommendation completed and bead `aerobeat-docs-bet` will be closed from the subagent handoff. Recommended direction: AeroBeat should support a small generic chart-authored marker/signal lane in addition to gameplay events, but keep it intentionally narrow and deterministic. The problem it solves is reusable authored synchronization for systems that need the chart timeline but should not reverse-engineer meaning from boxing/step/flow note payloads: debug checkpoints, section boundaries, phrase cues, deterministic environment/VFX hooks, and future lightweight authored training cues. Recommended v1 scope is a tiny enum-style taxonomy (`section`, `phrase`, `cue`, `state`) with stable ids, optional labels/tags, and a tightly bounded typed payload map; explicitly reject arbitrary script execution, dynamic branching, score/coaching logic, and freeform event buses in v1. Runtime direction: content/runtime loaders should expose authored signals as a separate typed timeline stream keyed to the same canonical timing truth as gameplay events, with Godot systems subscribing through content-driven signal dispatch rather than parsing chart YAML ad hoc. Spillover impact is real beyond YAML: content-core contracts, validators, authoring-tool UX, feature-runtime event dispatch, environment/coaching integration boundaries, and docs/examples all need to teach the line between deterministic authored hooks and runtime-generated gameplay/coaching decisions.

---

### Task 4: Apply approved chart/doc contract edits

**Bead ID:** `Pending`  
**SubAgent:** `primary` (for `coder`)  
**Role:** `coder`  
**References:** `REF-03`, `REF-04`, `REF-05`, `REF-06`, `REF-07`  
**Prompt:** After Slice A and Slice B are explicitly approved, update the chart examples and directly coupled docs so they teach the finalized timing contract and marker/signal model without reintroducing package-composition drift or boxing-specific overfitting. Claim the bead at start, run relevant validation, commit/push by default, and hand off cleanly for QA.

**Folders Created/Deleted/Modified:**
- implementation scope only

**Files Created/Deleted/Modified:**
- implementation scope only

**Status:** ⏸️ Blocked on design approval

**Results:** Pending.

---

### Task 5: QA and independent audit of the chart-contract pass

**Bead ID:** `Pending`  
**SubAgent:** `primary` (for `qa` then `auditor`)  
**Role:** `qa` / `auditor`  
**References:** `REF-03`, `REF-04`, `REF-05`, `REF-06`, `REF-07`  
**Prompt:** Verify that the final chart YAML and docs consistently teach the approved timing contract and marker/signal model, remain set-independent, and preserve the locked Song -> Chart -> Set -> Workout package boundaries. QA should validate behavior/docs coherence, and auditor should independently truth-check against the plan and references before closing the bead.

**Folders Created/Deleted/Modified:**
- implementation scope only

**Files Created/Deleted/Modified:**
- implementation scope only

**Status:** ⏸️ Blocked on implementation

**Results:** Pending.

---

## Final Results

**Status:** ⚠️ Draft / Awaiting Derrick review

**What We Built:** Created today’s continuation plan for the paused AeroBeat chart-contract work, preserving the prior handoff order: review first, then Slice A timing truth, then Slice B marker/signal design, then implementation + QA + audit only after approval.

**Reference Check:** `REF-01` and `REF-02` carried forward the paused state and next-session intent. The remaining references are queued for the active review/design pass.

**Commits:**
- Pending

**Lessons Learned:** The previous session already narrowed the problem correctly. The real discipline now is to avoid jumping into YAML edits before timing truth and authored-signal semantics are actually locked.

---

*Completed on 2026-04-28 (draft for review)*
