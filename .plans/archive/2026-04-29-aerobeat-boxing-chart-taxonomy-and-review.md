# AeroBeat Boxing Chart Taxonomy And Review

**Date:** 2026-04-29  
**Status:** Draft  
**Agent:** Chip 🐱‍💻

---

## Goal

Finish the next boxing-focused chart YAML pass by formalizing the boxing event taxonomy / beat shapes, then review the chart YAML built so far before moving on to Flow, Dance, and Step.

---

## Overview

This picks up directly from yesterday’s post-song-timing chart-contract work. The major shared-envelope decisions are already far enough along to keep moving: charts use `feature` plus `beatSpace`, songs remain the only canonical timing owner, `events` and `signals` are separate lanes, and weak compatibility/presentation/scoring hint fields are out of durable authored chart YAML. The next concrete job is not broad chart-envelope debate anymore; it is turning the approved boxing direction into a teachable first-pass boxing event taxonomy and pressure-testing the current chart YAML shape against that taxonomy.

The boxing slice should stay docs-first and payload-first. Before we jump to Flow, Dance, or Step, we should lock the boxing event families, point-vs-span behavior, required fields, zone/portal rules, and invalid combinations, then review the current chart YAML examples and surrounding docs for consistency gaps. That gives us a cleaner baseline for later features and reduces the risk that Flow or Step introduces accidental contract drift while boxing is still fuzzy.

---

## REFERENCES

| ID | Description | Path |
| --- | --- | --- |
| `REF-01` | Active post-song-timing chart contract plan | `projects/aerobeat/aerobeat-docs/.plans/2026-04-28-aerobeat-chart-contract-post-song-timing.md` |
| `REF-02` | Prior slice execution plan | `projects/aerobeat/aerobeat-docs/.plans/2026-04-28-aerobeat-chart-slice-a-b-execution.md` |
| `REF-03` | Boxing choreography guide | `projects/aerobeat/aerobeat-docs/docs/guides/choreography/boxing.md` |
| `REF-04` | Boxing gameplay GDD | `projects/aerobeat/aerobeat-docs/docs/gdd/gameplay/boxing.md` |
| `REF-05` | Demo boxing chart example: Neon Stride | `projects/aerobeat/aerobeat-docs/docs/examples/workout-packages/demo-neon-boxing-bootcamp/charts/ab-chart-neon-stride-boxing-medium.yaml` |
| `REF-06` | Demo boxing chart example: Midnight Sprint | `projects/aerobeat/aerobeat-docs/docs/examples/workout-packages/demo-neon-boxing-bootcamp/charts/ab-chart-midnight-sprint-boxing-hard.yaml` |
| `REF-07` | Canonical content model | `projects/aerobeat/aerobeat-docs/docs/architecture/content-model.md` |
| `REF-08` | Workout package/storage contract | `projects/aerobeat/aerobeat-docs/docs/architecture/workout-package-storage-and-discovery.md` |

---

## Tasks

### Task 1: Formalize the first-pass boxing event taxonomy

**Bead ID:** `aerobeat-docs-blz`  
**SubAgent:** `primary` (for `research`)  
**Role:** `research`  
**References:** `REF-01`, `REF-03`, `REF-04`, `REF-05`, `REF-06`, `REF-07`  
**Prompt:** Build the first-pass boxing chart taxonomy from the already approved direction. Claim bead `aerobeat-docs-blz` at start with `bd update aerobeat-docs-blz --status in_progress --json` and close it on completion. Produce a clear table covering each boxing event family, whether it is a point or span, required/optional fields, zone requirements, portal requirements by beatSpace, and invalid combinations. Explicitly pressure-test `strike`, `guard`, `obstacle`, `stance`, `knee`, `leg-lift`, and `run-in-place`, and recommend exact span-field naming.

**Folders Created/Deleted/Modified:**
- `.plans/`
- `docs/guides/`
- `docs/gdd/`
- `docs/examples/workout-packages/demo-neon-boxing-bootcamp/charts/`

**Files Created/Deleted/Modified:**
- This plan file unless follow-up notes are needed

**Status:** ✅ Complete

**Results:** First-pass boxing taxonomy research completed and bead `aerobeat-docs-blz` was closed. The initial pass formalized boxing families as `strike`, `guard`, `obstacle`, `stance`, `knee`, `leg-lift`, and `run-in-place`, with point families `strike`, `guard`, `knee` and span families `obstacle`, `stance`, `leg-lift`, `run-in-place`. The pass also recommended replacing legacy `holdMs` / `durationMs` with one unified beat-domain field, `durationBeats`. Derrick then tightened the boxing placement model further during review: remove authored `center` entirely and make guard implicitly center-only; collapse strike-authored zones from the earlier symbolic high/low layout down to just `left` and `right`; and let the engine infer upper vs lower strike placement from whether a crouch obstacle is active instead of encoding high/low in chart YAML. Derrick also clarified that when a placement target is authored, it is an integer portal / beat id from `0-11`, mapped like a clock face (`0` front, `3` right, `6` back, `9` left). That means the next review pass must now look for stale `center` / high-low boxing-zone teaching and any mismatch between symbolic portal language and the new `0-11` clock-style portal contract.

---

### Task 2: Review current boxing chart YAML against the taxonomy

**Bead ID:** `aerobeat-docs-69s`  
**SubAgent:** `primary` (for `research`)  
**Role:** `research`  
**References:** `REF-01`, `REF-05`, `REF-06`, `REF-07`, `REF-08`  
**Prompt:** Review the current boxing chart YAML and directly coupled docs against the proposed boxing taxonomy. Claim bead `aerobeat-docs-69s` at start with `bd update aerobeat-docs-69s --status in_progress --json` and close it on completion. Identify mismatches, ambiguities, stale field names (`mode` vs `feature`, old timing fields, older topology language), any places where the examples still teach `center` or explicit high/low boxing zones, and any mismatch between current portal language and the new `0-11` clock-style portal / beat-id contract.

**Folders Created/Deleted/Modified:**
- `.plans/`
- `docs/examples/workout-packages/demo-neon-boxing-bootcamp/charts/`
- directly coupled docs as needed later

**Files Created/Deleted/Modified:**
- This plan file unless review notes are needed

**Status:** ✅ Complete

**Results:** Completed the boxing review pass across the two demo boxing chart YAML files plus directly coupled boxing/content docs, and bead `aerobeat-docs-69s` was closed. The audit found that the current canonical examples still teach the pre-lock boxing contract rather than Derrick’s revised boxing taxonomy. Highest-priority mismatches are: (1) chart examples still use `mode` instead of `feature`; (2) both example YAML files and the boxing guide still author old envelope fields such as `interactionFamily`, `supportedInputProfiles`, `validatedInputProfiles`, `timing`, `presentationHints`, and `scoringHints`; (3) old span fields `holdMs` and `durationMs` are still present instead of unified beat-domain boxing event spans; (4) boxing docs/examples still teach symbolic `portal` values like `center` / `left` / `right` rather than the new authored `0-11` clock-style portal id contract; and (5) boxing docs/examples still teach the old 5-zone/high-low model (`left_high`, `right_high`, `left_low`, `right_low`, `center`) even though the revised boxing pass removes authored `center`, collapses authored strike zones to just `left` / `right`, and lets the engine infer upper/lower placement from crouch-obstacle state. Derrick then proposed a much simpler boxing beat shape that likely supersedes the earlier family/payload-table direction: each boxing event is a single `beat` object with required integer `start`, optional integer `end` (repeat every beat through the end beat), required `type` enum carrying the concrete move identity (`jab`, `cross`, `hook_left`, `hook_right`, `uppercut_left`, `uppercut_right`, `guard`, `reward_left`, `reward_right`, `orthodox`, `southpaw`, `squat`, `sidestep_left`, `sidestep_right`, `lean_left`, `lean_right`, `knee_left`, `knee_right`, `leg_lift_left`, `leg_lift_right`, `run_in_place`), and optional integer `portal` from `0-11` defaulting to `0`. That simplification changes the next task: instead of refining a richer boxing payload table, Task 3 must now decide the exact cleanup/implementation surface needed to migrate docs/examples onto this flattened boxing beat schema and note any last semantic gaps such as end-beat inclusivity and whether integer-only beat positions are sufficient for boxing authoring.

---

### Task 3: Decide the boxing cleanup / implementation surface

**Bead ID:** `aerobeat-docs-2wx`  
**SubAgent:** `primary` (for `research`)  
**Role:** `research`  
**References:** `REF-01`, `REF-05`, `REF-06`, `REF-07`, `REF-08`  
**Prompt:** Based on the taxonomy and review pass, define the exact implementation surface for the boxing cleanup. Claim bead `aerobeat-docs-2wx` at start with `bd update aerobeat-docs-2wx --status in_progress --json` and close it on completion. Use Derrick's newly simplified boxing event shape as the canonical proposal direction: each boxing beat has required float `start`, optional inclusive float `end`, required `type` enum carrying the concrete move identity, and optional integer `portal` from `0-11` defaulting to `0`; `orthodox` / `southpaw` are treated by the boxing feature as internal state changes without changing chart shape; unknown `type` values may later warn or hard-error at runtime without changing the authored schema; future per-type one-off optional fields are allowed if needed without abandoning the flattened shape; chart-level `beatSpace` should be treated as removable for boxing because optional `portal` targeting already lets the same chart work across lane and portal presentations; and authored YAML should use `beats:` rather than `events:` because chart entries were previously locked to the term `beats`. Separate immediate boxing-contract edits from follow-on work that should wait for Flow, Dance, and Step so we don’t accidentally overgeneralize the shared chart envelope too early.

**Folders Created/Deleted/Modified:**
- `.plans/`
- implementation scope to be determined

**Files Created/Deleted/Modified:**
- This plan file unless scoping notes are needed

**Status:** ✅ Complete

**Results:** Canonical boxing proposal research completed and bead `aerobeat-docs-2wx` was closed. The recommended boxing contract is now a flattened `beats` list rather than a richer nested event payload model: each boxing beat has required float `start`, optional inclusive float `end`, required concrete `type` enum, and optional integer `portal` from `0-11` defaulting to `0`. During review, Derrick further clarified that chart entries in authored YAML should use the already-approved chart terminology `beats:` rather than `events:`. The boxing proposal also now drops chart-level `beatSpace` for boxing because optional per-beat `portal` targeting lets one chart work across lane-style and portal-style presentations without a separate chart-wide topology flag. Immediate cleanup should therefore migrate the demo boxing chart examples and boxing authoring docs from the old nested `events` payload shape, old symbolic zones/portals, and old timing fields to the flattened `beats` shape with `start` / `end?` / `type` / `portal?`, while broader shared chart docs should be updated only where they directly teach the stale boxing contract. Remaining sign-off items before coder work are limited to final enum choices and validation/engine behavior details, not the overall boxing YAML shape.

---

### Task 4: Apply approved boxing chart/doc edits, then QA + audit

**Bead ID:** `aerobeat-docs-qtm` / `aerobeat-docs-im2` / `aerobeat-docs-xs5`  
**SubAgent:** `primary` (for `coder` / `qa` / `auditor`)  
**Role:** `coder` / `qa` / `auditor`  
**References:** `REF-03`, `REF-04`, `REF-05`, `REF-06`, `REF-07`, `REF-08`  
**Prompt:** After Derrick approves the boxing taxonomy and cleanup scope, update the boxing chart YAML examples and directly coupled docs, run relevant validation, then perform the normal coder → QA → auditor loop before closing the bead(s). Keep the work boxing-focused and avoid silently generalizing unresolved Flow/Dance/Step semantics.

**Folders Created/Deleted/Modified:**
- implementation scope only

**Files Created/Deleted/Modified:**
- implementation scope only

**Status:** ✅ Complete

**Results:** Coder implementation completed on bead `aerobeat-docs-qtm` and committed the main boxing-docs rewrite as `7f673d8` (`docs: flatten boxing charts to beats schema`). Updated files: `docs/examples/workout-packages/demo-neon-boxing-bootcamp/charts/ab-chart-neon-stride-boxing-medium.yaml`, `docs/examples/workout-packages/demo-neon-boxing-bootcamp/charts/ab-chart-midnight-sprint-boxing-hard.yaml`, `docs/guides/choreography/boxing.md`, `docs/architecture/workout-package-storage-and-discovery.md`, and `docs/architecture/content-model.md`. The coder rewrote the demo boxing charts to the locked flattened boxing schema (`feature: boxing`, `beats:`, per-beat `start` / optional inclusive `end` / `type` / optional integer `portal`), removed old boxing-authored shape details (`mode`, `events`, boxing `zone`, symbolic portal strings, nested boxing payload objects, `holdMs`, `durationMs`), updated the boxing guide to teach the new contract clearly, and refreshed the boxing-specific chart examples in the architecture docs without redesigning unresolved non-boxing payload schemas. Validation performed included a lightweight structural YAML check on both boxing examples plus a stale-key sweep across touched boxing files for `mode:`, `events:`, `beatSpace:`, `zone:`, `holdMs:`, `durationMs:`, and symbolic `portal` strings. One remaining `durationMs: 180000` hit in `docs/architecture/workout-package-storage-and-discovery.md` was confirmed to be unrelated song audio-duration content rather than a boxing-contract problem. QA on bead `aerobeat-docs-im2` then failed the first pass because `docs/architecture/content-model.md` still taught stale boxing-specific chart fields later in the document: interaction/profile guidance and presentation-hint guidance that contradicted the newly flattened boxing contract. A surgical coder retry on reopened bead `aerobeat-docs-qtm` then fixed only `docs/architecture/content-model.md` and landed commit `0002b8f` (`docs: remove stale boxing chart metadata guidance`). That retry replaced the stale boxing-specific metadata guidance with language that no longer teaches authored boxing interaction/profile/presentation fields as part of the current locked schema, while keeping broader architectural discussion framed as future/shared-contract follow-up. QA rerun on reopened bead `aerobeat-docs-im2` then passed: the two boxing example YAML files, `docs/guides/choreography/boxing.md`, `docs/architecture/workout-package-storage-and-discovery.md`, and `docs/architecture/content-model.md` now consistently teach the locked boxing contract (`feature`, `beats`, no chart-level `beatSpace`, per-beat `start` / optional inclusive `end` / `type` / optional integer `portal`, no authored `zone`, no symbolic portal strings, no nested boxing payloads, no old boxing timing fields). Independent audit on bead `aerobeat-docs-xs5` then passed and closed the loop: the touched docs truthfully match the finalized boxing contract, the scope stayed boxing-local, and the only residual out-of-scope artifact was the unrelated song-duration example in the storage doc.

---

## Final Results

**Status:** ✅ Complete

**What We Built:** Locked and documented the simplified canonical boxing chart YAML contract. Boxing charts now use `feature: boxing` with authored entries under `beats:` rather than `events:`, no chart-level `beatSpace`, and a flattened per-beat shape of required float `start`, optional inclusive float `end`, required concrete `type`, and optional integer `portal` in `0-11`. We also updated the demo boxing charts, the boxing choreography guide, and the relevant boxing-specific architecture snippets so they consistently teach that contract and no longer teach old boxing-only metadata such as authored zones, symbolic portals, nested payload families, or `holdMs` / `durationMs` timing fields.

**Reference Check:** `REF-01` carried forward the prior chart-envelope decisions, while `REF-03` through `REF-06` were used to reconcile and then rewrite the boxing-specific authored examples and teaching docs against the final simplified boxing contract.

**Commits:**
- `7f673d8` - docs: flatten boxing charts to beats schema
- `0002b8f` - docs: remove stale boxing chart metadata guidance

**Lessons Learned:** The flattened boxing beat schema is dramatically easier to sight-read and teach than the earlier nested taxonomy, and moving interpretation into the boxing feature repo removed a lot of authored-YAML complexity. The one real risk was partial-doc drift: even after the examples were fixed, a later section in `content-model.md` still reintroduced stale boxing metadata ideas, so the coder → QA → retry → audit loop was necessary to get the docs genuinely consistent.

---

*Completed on 2026-04-29*
