# AeroBeat Step Chart YAML Slice

**Date:** 2026-04-30  
**Status:** Draft  
**Agent:** Chip 🐱‍💻

---

## Goal

Define the first-pass chart YAML contract for AeroBeat `feature: step`, keeping the same shared chart envelope as the approved Boxing, Flow, and Dance features while grounding the Step payload in DDR / StepMania-style authored gameplay primitives.

---

## Overview

The outer chart-envelope direction is now strong and stable across recent AeroBeat slices: a chart declares exactly one `feature`, durable authored gameplay lives in a flat `beats:` event list, and feature-runtime concerns stay out of the chart itself. Boxing, Flow, and Dance all now reinforce the same authoring philosophy even though their payload vocabularies differ. For Step, Derrick has already sharpened the expected direction: the envelope should match the other features, while the Step-specific work should focus on the right `type` vocabulary and only the smallest set of additional optional fields that are truly needed beside `type`.

Step is a useful contrast case because it is much closer than Dance to a highly inspectable open rhythm-chart lineage. DDR / StepMania provide a rich public reference space for tap notes, holds, jumps, mines, timing density, lane ownership, and simultaneous inputs. That makes this slice less about whether Step needs a different envelope and more about how to encode Step’s note families cleanly inside the shared AeroBeat `beats:` contract without dragging in engine/runtime/editor baggage.

This slice stays definition-first. The immediate output should be a research-backed contract proposal, not docs/example rollout yet. Once Derrick approves the proposed Step payload shape, we can create execution beads for docs/examples and run the normal coder → QA → auditor loop.

---

## REFERENCES

| ID | Description | Path |
| --- | --- | --- |
| `REF-01` | Active post-song-timing chart-contract plan | `projects/aerobeat/aerobeat-docs/.plans/2026-04-28-aerobeat-chart-contract-post-song-timing.md` |
| `REF-02` | Approved Boxing chart example | `projects/aerobeat/aerobeat-docs/docs/examples/workout-packages/demo-neon-boxing-bootcamp/charts/ab-chart-neon-stride-boxing-medium.yaml` |
| `REF-03` | Approved Flow chart example | `projects/aerobeat/aerobeat-docs/docs/examples/workout-packages/demo-neon-boxing-bootcamp/charts/ab-chart-neon-stride-flow-medium.yaml` |
| `REF-04` | Approved Dance chart example | `projects/aerobeat/aerobeat-docs/docs/examples/workout-packages/demo-neon-boxing-bootcamp/charts/ab-chart-neon-stride-dance-medium.yaml` |
| `REF-05` | Current Step choreography guide | `projects/aerobeat/aerobeat-docs/docs/guides/choreography/step.md` |
| `REF-06` | Current Step gameplay GDD | `projects/aerobeat/aerobeat-docs/docs/gdd/gameplay/step.md` |
| `REF-07` | Canonical content model | `projects/aerobeat/aerobeat-docs/docs/architecture/content-model.md` |
| `REF-08` | Workout package/storage contract | `projects/aerobeat/aerobeat-docs/docs/architecture/workout-package-storage-and-discovery.md` |

---

## Tasks

### Task 1: Research Step vocabulary from internal docs and DDR / StepMania contract expectations

**Bead ID:** `Pending`  
**SubAgent:** `primary` (for `research`)  
**Role:** `research`  
**References:** `REF-01`, `REF-05`, `REF-06`, `REF-07`, `REF-08`  
**Prompt:** Research the current AeroBeat Step docs plus public DDR / StepMania gameplay vocabulary. Identify the durable authored Step primitives AeroBeat should support in first-pass chart YAML, including note families, simultaneous-hit concepts, sustained-note concepts, and avoid-note concepts. Pressure-test which concepts belong in `type` names versus small optional side fields.

**Folders Created/Deleted/Modified:**
- `.plans/`
- `docs/architecture/` only if separate notes are justified

**Files Created/Deleted/Modified:**
- This plan file
- optional supporting research note if justified

**Status:** ⏳ Pending

**Results:** Pending.

---

### Task 2: Inspect open Step chart data shapes for authoring-contract lessons

**Bead ID:** `Pending`  
**SubAgent:** `primary` (for `research`)  
**Role:** `research`  
**References:** `REF-01`, `REF-05`, `REF-06`, `REF-07`, `REF-08`  
**Prompt:** Inspect public Step-style formats and tooling with emphasis on StepMania / DDR-inspired chart structures. Extract the contract lessons that matter for AeroBeat authored YAML: lane identity, simultaneity, hold span semantics, avoid-note semantics, and what should stay out of the durable chart contract.

**Folders Created/Deleted/Modified:**
- `.plans/`
- `docs/architecture/` only if separate notes are justified

**Files Created/Deleted/Modified:**
- This plan file
- optional supporting research note if justified

**Status:** ⏳ Pending

**Results:** Pending.

---

### Task 3: Propose the first-pass Step chart authored shape

**Bead ID:** `Pending`  
**SubAgent:** `primary` (for `research`)  
**Role:** `research`  
**References:** `REF-01`, `REF-02`, `REF-03`, `REF-04`, `REF-05`, `REF-06`, `REF-07`, `REF-08`  
**Prompt:** Using the approved shared chart-envelope direction plus the Step research, propose the first-pass authored YAML shape for `feature: step`. Keep the shared flat `beats:` container unless strong evidence proves otherwise. Recommend the Step `type` family, any minimal optional fields that belong beside `type`, span semantics for holds, handling for simultaneous panels/jumps, and authored-contract validation rules.

**Folders Created/Deleted/Modified:**
- `.plans/`
- research notes only if needed

**Files Created/Deleted/Modified:**
- This plan file unless separate notes are justified

**Status:** ⏳ Pending

**Results:** Pending.

---

### Task 4: Turn the approved Step contract into docs/examples, then QA and audit

**Bead ID:** `Pending`  
**SubAgent:** `primary` (for `coder` / `qa` / `auditor`)  
**Role:** `coder` / `qa` / `auditor`  
**References:** `REF-01`, `REF-02`, `REF-03`, `REF-04`, `REF-05`, `REF-06`, `REF-07`, `REF-08`  
**Prompt:** After Derrick approves the Step payload shape, update the docs/examples accordingly and run the standard coder → QA → auditor loop.

**Folders Created/Deleted/Modified:**
- implementation scope only

**Files Created/Deleted/Modified:**
- implementation scope only

**Status:** ⏳ Pending

**Results:** Pending.

---

## Final Results

**Status:** ⚠️ Draft / Discussion only

**What We Built:** Created the definition-first plan for the Step chart YAML slice. This plan assumes the shared AeroBeat chart envelope remains stable and that the next design work is about Step payload vocabulary: what note families exist, whether lane ownership is best represented in `type` names or small side fields, how holds and jumps should author cleanly, and which StepMania-style concepts should remain outside the durable chart contract.

**Reference Check:** Pending.

**Commits:**
- `e417366` - docs: add historical plan files

**Lessons Learned:** Dance reinforced that the biggest risk is not the outer chart envelope but accidentally leaking feature/runtime semantics into chart rows. Step will likely be more structurally inspectable than Dance because of the open DDR / StepMania lineage, but it still needs the same authored-boundary discipline.

---

*Completed on 2026-04-30 (draft for discussion)*
