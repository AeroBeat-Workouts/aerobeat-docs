# AeroBeat Flow Chart YAML Slice

**Date:** 2026-04-29  
**Status:** Draft  
**Agent:** Chip 🐱‍💻

---

## Goal

Define the canonical Flow chart YAML shape, keeping it as close as possible to the now-locked Boxing beat schema while introducing only the Flow-specific `direction` field and the correct Flow `type` enum set.

---

## Overview

This starts the next chart-feature YAML slice immediately after Boxing and the cross-repo `mode` → `feature` cleanup both passed coder, QA, and audit. Derrick’s desired direction is intentionally conservative: Flow should inherit the same flattened authored shape as Boxing, so we do not re-open chart-envelope complexity unless Flow truly needs it. That means the default expectation is that Flow charts also use `feature: flow` with authored entries under `beats:`, and each beat keeps the same core fields: required float `start`, optional inclusive float `end`, required concrete `type`, and optional integer `portal`.

The one newly approved Flow-specific field is `direction`, another optional `0-11` integer. For Flow, this expresses directional intent around the athlete, with `0` directly above, `3` right, `6` down, and `9` left. Before implementation, we should formalize how `direction` coexists with `portal`, determine whether any Flow beat types do or do not require it, and research the concrete move/object taxonomy from the two inspiration anchors Derrick named: Supernatural and Beat Saber. The right path is: define the minimal shared beat shape first, audit/derive the Flow type set second, then update examples/docs only after the type vocabulary and validation rules are crisp.

---

## REFERENCES

| ID | Description | Path |
| --- | --- | --- |
| `REF-01` | Boxing chart YAML completion plan | `projects/aerobeat/aerobeat-docs/.plans/2026-04-29-aerobeat-boxing-chart-taxonomy-and-review.md` |
| `REF-02` | Cross-repo `mode` → `feature` alignment plan | `projects/aerobeat/aerobeat-docs/.plans/2026-04-29-aerobeat-workout-yaml-sqlite-feature-alignment.md` |
| `REF-03` | Canonical content model | `projects/aerobeat/aerobeat-docs/docs/architecture/content-model.md` |
| `REF-04` | Canonical workout package/storage contract | `projects/aerobeat/aerobeat-docs/docs/architecture/workout-package-storage-and-discovery.md` |
| `REF-05` | Prior chart-contract discussion state | `memory/2026-04-27.md` |
| `REF-06` | Current chart-contract follow-up memory | `memory/2026-04-28.md` |

---

## Tasks

### Task 1: Define the canonical Flow beat shape from the Boxing baseline

**Bead ID:** `aerobeat-docs-aqo`  
**SubAgent:** `primary` (for `research`)  
**Role:** `research`  
**References:** `REF-01`, `REF-03`, `REF-04`, `REF-05`, `REF-06`  
**Prompt:** Starting from the locked Boxing beat schema, define the canonical Flow beat YAML shape. Claim bead `aerobeat-docs-aqo` at start with `bd update aerobeat-docs-aqo --status in_progress --json` and close it on completion. Keep the shared fields identical where possible (`start`, optional inclusive `end`, `type`, optional `portal`) and formalize the new optional `direction` field (`0-11`, with `0` above, `3` right, `6` down, `9` left). Treat Derrick's latest direction as the current design baseline: `direction` is portal-relative placement for portal-based presentations, describing where the beat appears relative to the athlete standing position from that portal toward the athlete; a direction of `0` means above the athlete, `6` means centered at about waist height through the athlete; and in lane-based presentations the same Flow beats can still be used but `direction` is ignored. Identify any immediate validation rules or ambiguities around how `direction` and `portal` coexist.

**Folders Created/Deleted/Modified:**
- `.plans/`
- chart/docs paths only if notes are needed later

**Files Created/Deleted/Modified:**
- This plan file unless follow-up notes are needed

**Status:** ✅ Complete (superseded baseline refined)

**Results:** Initial Flow shape research completed and bead `aerobeat-docs-aqo` was closed. The first recommendation kept Flow almost identical to Boxing: a flattened `beats:` list with required float `start`, optional inclusive float `end`, required concrete `type`, optional integer `portal`, and optional integer `direction`. The original split treated `portal` as the presentation origin and `direction` as the athlete-relative passage hint around the athlete in a portal-facing frame, while allowing lane renderers to ignore `direction`. Derrick then refined the model after comparing more closely against Supernatural footage and identified that one field is not enough: Flow needs to separate **swing direction** from **swing placement**. Updated direction from Derrick now is: `direction` remains an optional integer used for the directional Flow families and means swing-direction/follow-through guidance; if unset on a swing beat, it adopts the same value as `placement`. Flow also adds `placement`, an optional `0-12` integer, where `0` is athlete height, `3` is athlete right arm length, `6` is athlete waist, `9` is athlete left arm length, and `12` is the special `center` value meaning the beat moves toward the athlete’s chest. Derrick then further locked the per-type field rules: both `placement` and `direction` are valid for `swing_left`, `swing_right`, `flow_left`, `flow_right`, `warn_left`, and `warn_right`; `reward_left` and `reward_right` support `placement` only and must not carry `direction`; and `squat`, `lean_left`, `lean_right`, `knee_left`, `knee_right`, `leg_lift_left`, `leg_lift_right`, and `run_in_place` support neither `placement` nor `direction`. This means the earlier one-field `direction` baseline was useful but is now superseded by a tighter two-concept model with explicit per-type support rules: `portal` = origin/presentation source, `placement` = where around the athlete the beat passes, and `direction` = how the supported Flow guidance/swing beats should be angled/followed through.

---

### Task 2: Research and propose the Flow `type` enum set from Beat Saber + Supernatural

**Bead ID:** `aerobeat-docs-2li`  
**SubAgent:** `primary` (for `research`)  
**Role:** `research`  
**References:** `REF-01`, `REF-03`, `REF-05`, `REF-06`  
**Prompt:** Research the concrete object/action types that should inform AeroBeat Flow from Beat Saber, Supernatural, and Starri. Claim bead `aerobeat-docs-2li` at start with `bd update aerobeat-docs-2li --status in_progress --json` and close it on completion. Produce a first-pass Flow `type` enum proposal that keeps the flattened beat shape but captures the durable authored distinctions we need for Flow. Separate high-confidence shared truths from inspiration-specific details that should stay out of the first contract.

**Folders Created/Deleted/Modified:**
- `.plans/`
- research-only unless notes are needed

**Files Created/Deleted/Modified:**
- This plan file unless review notes are needed

**Status:** ✅ Complete (requires refinement after new placement split)

**Results:** First-pass Flow type research completed and bead `aerobeat-docs-2li` was closed. Research across Beat Saber, Supernatural, and Starri suggested a deliberately small durable v1 set centered on handed swings plus fitness-shaped lower-body/body-movement beats. The initial recommendation was: `swing_left`, `swing_right`, `squat`, `lean_left`, `lean_right`, `leg_lift_left`, `leg_lift_right`, and `run_in_place`, with advice to keep richer Beat-Saber-style `arc` / `trail`, `chain`, `bomb` / `mine`, Starri-style `catch`, and explicit `turn_*` types out of the first contract. Derrick’s latest direct design update now expands and sharpens that baseline in three important ways. First, all of the following boxing-carried types are explicitly in scope for Flow as well: `reward_left`, `reward_right`, `squat`, `lean_left`, `lean_right`, `knee_left`, `knee_right`, `leg_lift_left`, `leg_lift_right`, and `run_in_place`. Second, Flow introduces new authored guidance/visual types that the first research pass had deferred; Derrick then explicitly renamed the guidance/trail family to match Supernatural wording and avoid overloading the feature name, so the approved type names are now `trail_left`, `trail_right`, `warn_left`, and `warn_right` rather than `flow_left` / `flow_right`. Third, Derrick locked the per-type placement/direction support rules: `swing_left`, `swing_right`, `trail_left`, `trail_right`, `warn_left`, and `warn_right` all support both `placement` and `direction`; `reward_left` and `reward_right` support `placement` only; and the remaining carryover movement/body types support neither field. That means the earlier tiny enum recommendation was a useful baseline, but the current recommended Flow type pool for the next synthesis step is now: `swing_left`, `swing_right`, `trail_left`, `trail_right`, `warn_left`, `warn_right`, `reward_left`, `reward_right`, `squat`, `lean_left`, `lean_right`, `knee_left`, `knee_right`, `leg_lift_left`, `leg_lift_right`, and `run_in_place`, with richer Beat-Saber-specific arc/chain/bomb families and Starri-specific catch-style mechanics still intentionally kept out of the first durable contract.

---

### Task 3: Synthesize the formal Flow contract proposal

**Bead ID:** `aerobeat-docs-7k4`  
**SubAgent:** `primary` (for `research`)  
**Role:** `research`  
**References:** `REF-01`, `REF-03`, `REF-04`  
**Prompt:** Synthesize the now-locked Flow decisions into a formal recommended Flow contract proposal before docs implementation begins. Claim bead `aerobeat-docs-7k4` at start with `bd update aerobeat-docs-7k4 --status in_progress --json` and close it on completion. Produce a clear schema summary, type × field validation matrix, and a first canonical Flow YAML example for Derrick to tweak.

**Folders Created/Deleted/Modified:**
- `.plans/`
- implementation scope to be determined after proposal approval

**Files Created/Deleted/Modified:**
- This plan file unless proposal notes are needed

**Status:** ✅ Complete

**Results:** Produced the formal recommended Flow contract proposal and closed bead `aerobeat-docs-7k4`. The proposal keeps the authored top level Boxing-like with `feature: flow`, `difficulty`, and `beats:`. Each beat uses required float `start`, optional inclusive float `end`, required `type`, and optional integer `portal`; Flow additionally introduces optional integer `placement` (`0..12`) and optional integer `direction` (`0..11`). The locked semantics are now stated plainly: `portal` is the origin/presentation source, `placement` is where around the athlete the beat passes, and `direction` is swing/follow-through guidance. The formal validation matrix locks per-type field support as follows: `swing_left`, `swing_right`, `trail_left`, `trail_right`, `warn_left`, and `warn_right` support both `placement` and `direction`; `reward_left` and `reward_right` support `placement` only; and `squat`, `lean_left`, `lean_right`, `knee_left`, `knee_right`, `leg_lift_left`, `leg_lift_right`, and `run_in_place` support neither. Derrick then closed the remaining ambiguities: `portal` uses the same `0..11` integer domain as Boxing; `trail_*` and `warn_*` also inherit `direction` from `placement` when `direction` is omitted; `placement: 12` is valid across all placement-supporting types; and `end` semantics match Boxing at the parser level (inclusive range), with the richer behavior remaining feature/runtime interpretation rather than chart-schema complexity. That means the current Flow proposal is now execution-ready for docs/example updates without reopening broader chart-envelope design.

---

### Task 4: Apply Flow chart/doc updates, then QA + audit

**Bead ID:** `aerobeat-docs-a6o` / `aerobeat-docs-43s` / `aerobeat-docs-1di`  
**SubAgent:** `primary` (for `coder` / `qa` / `auditor`)  
**Role:** `coder` / `qa` / `auditor`  
**References:** `REF-01`, `REF-03`, `REF-04`  
**Prompt:** After Derrick approves the formal Flow contract proposal, update the relevant Flow chart examples/docs, run validation, and perform the normal coder → QA → auditor loop. Keep the work focused on the approved Flow slice and avoid broadening into unrelated chart-envelope redesign.

**Folders Created/Deleted/Modified:**
- implementation scope only

**Files Created/Deleted/Modified:**
- implementation scope only

**Status:** ✅ Complete

**Results:** Coder implementation completed on bead `aerobeat-docs-a6o` and committed/pushed `b2922e9` (`docs: lock flow chart contract teaching`). Updated Flow teaching surfaces: `docs/guides/choreography/flow.md`, `docs/gdd/gameplay/flow.md`, `docs/guides/accessibility.md`, `docs/gdd/modifiers/accessibility.md`, `docs/architecture/content-model.md`, `docs/architecture/workout-package-storage-and-discovery.md`, `docs/guides/demo_workout_package.md`, and `docs/examples/workout-packages/overview.md`. The coder rewrote Flow contract teaching to the locked schema (`feature: flow`, `beats:`, required `start`, optional inclusive `end`, required `type`, optional `portal`, optional `placement`, optional `direction`), documented the explicit type pool, per-type field-support rules, and the `direction = placement` inheritance rule for `swing_*` / `trail_*` / `warn_*`, and removed stale Flow-specific guidance that implied older ring/bomb-based payload concepts. Because this repo does not currently contain a checked-in Flow demo chart YAML file, the work stayed bounded to the actual Flow teaching surfaces plus directly coupled architecture/docs; the only slightly wider edits were small accessibility/GDD cleanups needed to remove Flow-only concepts that contradicted the locked contract. Validation performed included targeted grep sweeps across touched Flow surfaces and a full strict docs build via `mkdocs build --strict`, which passed. QA on bead `aerobeat-docs-43s` then passed: the touched Flow docs consistently teach the locked contract, stale contradictory Flow payload guidance is removed from the scoped surfaces, the note that no checked-in Flow chart YAML example exists is honest and non-misleading, and the bounded-scope promise was respected. Independent audit on bead `aerobeat-docs-1di` then failed on two remaining scoped wording leaks in the accessibility surfaces: `docs/guides/accessibility.md` still described Flow in old obstacle/wall terms and `docs/gdd/modifiers/accessibility.md` still described Flow squats as obstacle-avoidance behavior. A surgical coder retry on reopened bead `aerobeat-docs-a6o` then fixed only those accessibility wording leaks and landed commit `8b9682c` (`docs: fix stale flow accessibility wording`). The retry reworded `No Squats`, `No Leg Lifts`, `No Obstacles`, and related modifier/accessibility text to describe Flow in terms of body-movement beats/prompts rather than old wall/obstacle framing, then reran a strict docs build successfully. QA rerun on reopened bead `aerobeat-docs-43s` then passed: the stale Flow obstacle/wall wording is fixed, the two accessibility surfaces now describe Flow in beats/prompts/body-movement terms, spot-checks found no regression in the broader Flow contract surfaces, and a strict docs build passed again. Auditor rerun on bead `aerobeat-docs-1di` then passed, confirming the locked Flow contract is consistently taught across the scoped surfaces, the accessibility wording no longer contradicts the flat-beat contract, and the docs-only scope remained appropriately bounded.

---

## Final Results

**Status:** ✅ Complete

**What We Built:** Locked and documented the canonical Flow chart YAML contract. Flow charts now use `feature: flow` with authored entries under `beats:` and a flat per-beat shape of required float `start`, optional inclusive float `end`, required concrete `type`, optional integer `portal` (`0..11`), optional integer `placement` (`0..12`), and optional integer `direction` (`0..11`). We also updated the Flow choreography/gameplay/accessibility/architecture teaching surfaces so they consistently describe the approved type pool, the per-type field-support rules, and the `direction = placement` inheritance behavior for `swing_*`, `trail_*`, and `warn_*`, without reintroducing older ring/bomb/obstacle-lane payload concepts.

**Reference Check:** `REF-01` and `REF-02` carried forward the boxing baseline and naming cleanup so Flow could inherit the same flat authored envelope without reopening shared chart complexity.

**Commits:**
- `b2922e9` - docs: lock flow chart contract teaching
- `8b9682c` - docs: fix stale flow accessibility wording

**Lessons Learned:** Flow still benefited from the Boxing-first flattening strategy, but unlike Boxing it needed one extra authored concept split: `placement` vs `direction`. The QA/audit loop also showed that accessibility docs can silently preserve older design assumptions even when the main contract docs look correct, so scoped follow-up wording passes are worth doing before calling a feature slice truly finished.

---

*Completed on 2026-04-29*
