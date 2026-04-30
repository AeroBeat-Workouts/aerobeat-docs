# AeroBeat Step Chart YAML Slice

**Date:** 2026-04-30  
**Status:** In Progress  
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

**Bead ID:** `aerobeat-docs-9ve`  
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

**Status:** ✅ Complete

**Results:** Researched the current AeroBeat Step docs plus public DDR / StepMania vocabulary and the strongest durable-v1 recommendation is to keep Step inside the same shared chart envelope as Boxing / Flow / Dance: flat authored `beats` rows with `start`, optional inclusive `end`, required `type`, and only the smallest Step-specific side fields needed beside them. Internal AeroBeat Step docs consistently teach a 4-lane authored space (`left`, `down`, `up`, `right`) plus four core gameplay concepts: single steps/taps, holds/freezes, jumps (two simultaneous arrows), and mines/avoid notes. Public StepMania note-family references confirm that the broad ecosystem has additional objects (`roll`, `lift`, `fake`, autokeysound, etc.), but those are not currently taught by AeroBeat’s Step docs and would add complexity without first-pass justification. Therefore the recommended first-pass durable Step primitives are: `tap`, `hold`, and `mine` as the actual `type` family; lane ownership should **not** be exploded into `type` names like `left`, `jump_left_up`, or `mine_down`, because that would create combinatorial type growth and would encode simultaneity awkwardly. Instead, Step should use a small side field for lane identity — preferably `lanes` as an ordered unique array of lane ids — with validation rules per type. Recommended v1 semantics: `tap` requires `lanes` and supports lane-count `1..2`; one lane is an ordinary step and two simultaneous lanes are the authored equivalent of a jump, so `jump` should be treated as choreography/runtime vocabulary derived from simultaneity, not as its own durable `type`. `hold` requires exactly one lane plus `end`; that cleanly captures freeze-arrow semantics without adding a separate duration field. `mine` requires `lanes`; one-lane mines cover the common avoid-note case, while allowing up to two lanes keeps simultaneity available without inventing new mine-family types. Strong pressure-test conclusion: simultaneity belongs in the lane field cardinality, not in `type`; sustained-note span belongs in the shared `end` field, not a Step-only duration field; and footedness guidance / crossover intent / jack semantics / stream difficulty / scoring windows should stay out of the durable chart contract because they are emergent pattern-reading or runtime concerns, not authored primitive families. Also recommended for v1 scope discipline: do **not** add `roll`, `lift`, `fake`, `bracket`, `triple`, or `quad` yet; triples/brackets/hands are advanced execution interpretations better treated as out-of-scope or invalid in first-pass validation unless Derrick later wants explicit support.

---

### Task 2: Inspect open Step chart data shapes for authoring-contract lessons

**Bead ID:** `aerobeat-docs-7he`  
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

**Status:** ✅ Complete

**Results:** Public StepMania / DDR-style chart formats strongly reinforce the current AeroBeat direction to keep Step inside the same shared chart envelope as Boxing / Flow / Dance rather than inventing a Step-only outer structure. The key authored-data lesson from `.sm` / `.ssc` note data is that a Step chart row is fundamentally **time + per-lane occupancy**, not a large taxonomy of special composite note names. In StepMania note data, each line in a measure encodes one moment across the chart’s columns; for `dance-single`, that means four stable lane positions, and simultaneity is expressed simply by multiple non-zero columns on the same row. That is the strongest public evidence that AeroBeat should keep lane identity out of `type` names and should instead author lane ownership in a small side field such as `lanes`. This also strongly supports representing a jump as a normal Step row whose `lanes` cardinality is `2`, not as a separate durable `jump` type. Public StepMania note families also pressure-test hold semantics well: holds/freezes are modeled by a lane-local head plus a later tail on the **same column**, which means the durable authored truth is really a start time and end time bound to one lane, not a bespoke Step-only duration field. That confirms the current Task 1 instinct that AeroBeat Step holds should use shared `end` span semantics and should validate to exactly one lane per hold in v1. Avoid-note semantics are similarly clean in the public lineage: mines are encoded as negative notes on specific lanes/rows, so AeroBeat should keep avoid notes as an authored chart primitive (`mine`) with lane ownership, rather than treating them as scoring metadata, runtime hazards detached from lanes, or a global section flag. Public StepMania formats do include additional note families such as `roll`, `lift`, `fake`, and autokeysound markers, but those read as format/runtime/editor expansion pressure rather than first-pass AeroBeat authored-contract requirements; they are good evidence for what to explicitly leave out of the durable v1 chart slice. Strong contract recommendation from this research: Step rows should stay small and authored-facing — required `start`, required `type`, optional shared `end`, and a tiny lane field — with validation roughly as follows: `tap` requires `lanes` count `1..2`; `hold` requires exactly one lane plus `end`; `mine` requires at least one lane and should probably stay capped at `1..2` for v1 discipline. What should stay out of the durable contract: row-string serialization details, measure-line density, groove radar / meter internals, score/life/judgment behavior, editor-specific note variants, keysounds, fake-note semantics, view/rendering behavior, and advanced execution interpretations like brackets/hands/triples unless AeroBeat later deliberately expands Step scope. Net result: the public Step lineage **confirms** the Task 1 direction more than it contradicts it. The main refinement is that `lanes` should be treated as the real semantic carrier for lane identity and simultaneity, while `type` should stay small and behavior-level (`tap`, `hold`, `mine`) rather than absorbing lane names or jump-specific labels.

---

### Task 3: Propose the first-pass Step chart authored shape

**Bead ID:** `aerobeat-docs-yf0`  
**SubAgent:** `primary` (for `research`)  
**Role:** `research`  
**References:** `REF-01`, `REF-02`, `REF-03`, `REF-04`, `REF-05`, `REF-06`, `REF-07`, `REF-08`  
**Prompt:** Using the approved shared chart-envelope direction plus the Step research, propose the first-pass authored YAML shape for `feature: step`. Keep the shared flat `beats:` container unless strong evidence proves otherwise. Recommend the Step `type` family, any minimal optional fields that belong beside `type`, span semantics for holds, handling for simultaneous panels/jumps, and authored-contract validation rules.

**Folders Created/Deleted/Modified:**
- `.plans/`
- research notes only if needed

**Files Created/Deleted/Modified:**
- This plan file unless separate notes are justified

**Status:** ✅ Complete

**Results:** Proposed the first-pass authored Step chart contract as a **shared flat chart envelope** with `feature: step` and a Step-specific flat `beats:` payload, aligned with Boxing / Flow / Dance rather than introducing a Step-only outer shape. Recommended canonical YAML shape:

```yaml
schemaId: aerobeat.chart.step.v1
schemaVersion: 1
recordVersion: 1
createdByTool: aerobeat-tool-content-authoring
createdByToolVersion: 0.1.0
createdAt: 2026-04-30T12:00:00Z
updatedAt: 2026-04-30T12:00:00Z
chartId: uid
chartName: string
feature: step
difficulty: medium
beats:
  - start: 8.0
    type: tap
    lanes: [left]
  - start: 12.0
    type: tap
    lanes: [left, right]
  - start: 16.0
    end: 18.0
    type: hold
    lanes: [down]
  - start: 20.0
    type: mine
    lanes: [up]
```

Recommended **required shared/envelope fields** stay unchanged from the approved sibling features: `schemaId`, `schemaVersion`, `recordVersion`, `createdByTool`, `createdByToolVersion`, `createdAt`, `updatedAt`, `chartId`, `chartName`, `feature`, `difficulty`, `beats`. Recommended **Step beat row fields** are intentionally minimal: required float `start`, optional inclusive float `end`, required `type`, and required `lanes` for every Step beat family in v1. The Step `type` family should stay compact and behavior-level: `tap`, `hold`, `mine` only. Do **not** explode lane identity or simultaneity into `type` names like `left`, `jump`, `freeze_left`, `mine_right`, or similar combinations.

Recommended exact semantics for `lanes`: `lanes` is an ordered unique array of lane ids drawn only from the stable 4-panel Step lane set `left | down | up | right`. In v1, ordering is normalized for determinism/human readability using pad order `[left, down, up, right]`; authors should write that canonical order and validators should either enforce it or normalize to it. `lanes` is the semantic owner of lane identity and simultaneity. A one-item `lanes` array means a single-panel authored object. A two-item `lanes` array means simultaneous panels on one beat row. That means a Step **jump is not its own durable type**; it is a `tap` whose `lanes` cardinality is `2`. This keeps the contract compact, avoids type explosion, and matches the public StepMania lesson that simultaneous occupancy is fundamentally column cardinality at one moment in time.

Recommended hold/span semantics: `hold` uses the same shared `start` + inclusive `end` span model already approved for the other chart features. A Step hold represents one sustained occupied panel from `start` through `end`, and therefore `hold` must author **exactly one lane** in v1. Do not add a Step-only `duration`, `length`, `tail`, or nested hold payload. The chart owns only the authored lane and beat span; head/tail rendering, hold-body visualization, scoring windows, and release/judgment logic belong in Step runtime/feature code rather than in durable chart YAML.

Recommended mine semantics: `mine` represents an avoid-note on one or more authored lanes at `start`. For v1 discipline, the stronger recommendation is to allow `lanes` cardinality `1..2`, mirroring the same simultaneity ceiling as `tap`; one-lane mines cover the common case and two-lane simultaneous mines remain available without adding new types. If Derrick later wants stricter onboarding, this can be narrowed to exactly one lane without changing the outer contract shape. Either way, mine semantics stay authored as lane-local avoid objects, not as global section modifiers or scoring metadata.

Recommended authored-contract validation rules for Step v1:
- chart `feature` must equal `step`
- `beats` must remain a flat list; no nested lane grids or measure-string payloads
- every beat requires `start`, `type`, and `lanes`
- `type` must be exactly one of `tap | hold | mine`
- every `lanes[*]` value must be one of `left | down | up | right`
- `lanes` must be non-empty, unique, and canonically ordered as `[left, down, up, right]`
- `tap` requires `lanes` count `1..2` and must not include `end`
- `hold` requires `lanes` count exactly `1`, requires `end`, and `end` must be `>= start`
- `mine` requires `lanes` count `1..2` and must not include `end`
- triples/quads (`lanes` count `> 2`) are invalid in first-pass authored Step YAML
- duplicate rows with the same `start`, `type`, and same lane set should be rejected as redundant authoring
- overlapping holds on the same lane should be rejected unless a future Step expansion explicitly allows them
- no chart row should encode footedness, crossover intent, brackets, hands, jacks, stream labels, scoring windows, or presentation/runtime hints; those stay outside the durable authored contract

Rationale: this proposal preserves exact envelope parity with Boxing / Flow / Dance, keeps Step authoring compact and human-readable, and puts the durable truth in the same place StepMania-style formats do: time + lane occupancy. It also draws a clear authored/runtime boundary. The chart owns beat positions, Step object family, lane occupancy, and hold span. The Step feature/runtime owns receptor visuals, scroll/view presentation, hold-body rendering, timing windows, mine penalties, difficulty interpretation, footing guidance, and advanced execution semantics. No separate architecture note was justified because the change is still a local definition slice, so the proposal was kept localized to this active plan file.

---

### Task 4: Turn the approved Step contract into docs/examples, then QA and audit

**Bead ID:** `aerobeat-docs-7y9`  
**SubAgent:** `primary` (for `coder` / `qa` / `auditor`)  
**Role:** `coder` / `qa` / `auditor`  
**References:** `REF-01`, `REF-02`, `REF-03`, `REF-04`, `REF-05`, `REF-06`, `REF-07`, `REF-08`  
**Prompt:** After Derrick approves the Step payload shape, update the docs/examples accordingly and run the standard coder → QA → auditor loop.

**Folders Created/Deleted/Modified:**
- implementation scope only

**Files Created/Deleted/Modified:**
- implementation scope only

**Status:** ⏳ In Progress

**Results:** 2026-04-30 Derrick approved the first-pass Step contract proposal for execution. Environment/assets YAML files and asset links remain outside chart YAML and are linked through Sets at engine interpretation time. Coder implementation completed for docs/examples in this repo. Updated Step contract teaching in `docs/guides/choreography/step.md` and `docs/gdd/gameplay/step.md`; promoted the approved Step payload rules into `docs/architecture/content-model.md` and `docs/architecture/workout-package-storage-and-discovery.md`; refreshed example-package references in `docs/guides/demo_workout_package.md`, `docs/examples/workout-packages/overview.md`, `docs/examples/workout-packages/demo-neon-boxing-bootcamp/README.md`, and `docs/examples/workout-packages/demo-neon-boxing-bootcamp/workout.yaml`; and added the checked-in Step chart example `docs/examples/workout-packages/demo-neon-boxing-bootcamp/charts/ab-chart-neon-stride-step-medium.yaml`. Validation run: `python3 scripts/create_placeholders.py` and `./venv/bin/mkdocs build --strict` (passed). Commit hash: `335317b` (`docs: add first-pass step chart contract example`).

---

## Final Results

**Status:** ⚠️ Draft / Discussion only

**What We Built:** Created the definition-first plan for the Step chart YAML slice. This plan assumes the shared AeroBeat chart envelope remains stable and that the next design work is about Step payload vocabulary: what note families exist, whether lane ownership is best represented in `type` names or small side fields, how holds and jumps should author cleanly, and which StepMania-style concepts should remain outside the durable chart contract.

### Session Resume — 2026-04-30

Derrick approved the first-pass `feature: step` contract direction and added one more boundary clarification: environment/assets YAML files and asset links are responsible for customization and are connected via Sets when interpreted by the AeroBeat engine, so they do **not** belong in Step chart YAML directly. With that boundary locked, this slice can now move from research/proposal into the docs/examples execution phase.

**Reference Check:** Pending.

**Commits:**
- `e417366` - docs: add historical plan files

**Lessons Learned:** Dance reinforced that the biggest risk is not the outer chart envelope but accidentally leaking feature/runtime semantics into chart rows. Step will likely be more structurally inspectable than Dance because of the open DDR / StepMania lineage, but it still needs the same authored-boundary discipline.

---

*Completed on 2026-04-30 (draft for discussion)*
