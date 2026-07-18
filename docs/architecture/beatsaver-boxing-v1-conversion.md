# BeatSaver to AeroBeat Boxing v1 Conversion

This document is the canonical AeroBeat docs home for the **Boxing v1 BeatSaver conversion spec**.

Use this page when you need the current truth for:

- what BeatSaver / Beat Saber Standard-map objects AeroBeat Boxing v1 converts
- which conversion rules are already locked
- which BeatSaver objects are intentionally ignored or dropped in Boxing v1
- which alternate architectures were considered and why they were rejected or deferred
- which formerly bounded edge cases are now explicitly closed in the Boxing v1 spec

This page is intentionally a **conversion architecture and rules** document, not a general Boxing gameplay page and not a choreography how-to.

## Why this is the canonical home

The Boxing gameplay pages describe the player-facing feature and current authored chart intent. They are not the most truthful place for a BeatSaver-specific import/conversion contract that spans:

- external source semantics
- conversion heuristics
- dropped-object policy
- provenance and artifact policy
- the final locked treatment of previously unresolved source edge cases

Those concerns belong in Architecture because they define a tooling and content-conversion seam between BeatSaver source data and AeroBeat-authored Boxing charts.

## Scope

This document covers **AeroBeat Boxing v1 conversion from BeatSaver / Beat Saber Standard-map source data**.

It does not define:

- the general AeroBeat Boxing player fantasy
- Flow conversion in full detail
- broader runtime implementation details outside the conversion contract

## Canonical philosophy

### Source truth

For BeatSaver-derived Boxing content, the **raw BeatSaver source remains canonical source truth**.

That means:

- the original BeatSaver map package remains the authoritative record of what was imported
- AeroBeat Boxing charts are a **derived authored runtime form**, not the primary archival source
- source-specific provenance, debug traces, warnings, and mapping diagnostics belong in package artifacts, not in the clean runtime chart payload

### Conversion goal

Boxing v1 aims for a **deterministic, BeatSaver-only conversion system**.

The current product direction is:

- use BeatSaver-authored chart data as the only required gameplay source
- avoid extra music-analysis heuristics for v1
- prefer rules that are codable, inspectable, and replayable
- accept some honest lossiness rather than pretending unsupported semantics were preserved perfectly

### Product posture

Boxing v1 should be treated as a **camera-first AeroBeat gameplay translation** of BeatSaver input, not as an attempt to preserve VR-native semantics one-to-one.

## Architecture choice now locked

### Locked v1 architecture: direct BeatSaver-grid-derived Boxing conversion

The current canonical direction is a **BeatSaver-only Boxing conversion** based on the authored BeatSaver 4x3 note grid and obstacle geometry.

The converter should derive Boxing gameplay from source chart structure, not from:

- extra phrase-energy analysis
- music-structure inference
- generated choreography unrelated to the BeatSaver chart
- hidden runtime-only gesture-classifier guesses that have no durable conversion trace

### Source grid

BeatSaver note and obstacle reasoning in this spec uses the standard 4x3 cell model:

```text
[0][1][2][3]
[4][5][6][7]
[8][9][10][11]
```

Rows are interpreted as:

- top row: `0..3`
- middle row: `4..7`
- bottom row: `8..11`

## Locked object coverage

The recent Boxing v1 source-coverage audit confirmed that the major Standard-map gameplay object families are all accounted for at the policy level.

### Explicitly covered in Boxing v1

- normal colored notes
- directionless / dot notes
- simultaneous center dual-note guard pairs
- non-guard simultaneous dual-note groups
- obstacles / walls
- bombs
- burst sliders
- arcs / sliders

Coverage does **not** mean every object is emitted as a Boxing-authored beat. Some are deliberately converted, and some are deliberately ignored.

## Locked conversion rules

## 1. Single-note rule

Single BeatSaver notes convert by **row family**, with handedness coming from note color / hand lane.

- top row (`0..3`) -> handed `uppercut`
- middle row (`4..7`) -> handed `straight`
- bottom row (`8..11`) -> handed `hook`

This is the core deterministic Boxing v1 note rule.

## 2. Dot-note rule

Directionless / dot notes do **not** receive special Boxing semantics in v1.

They convert exactly like normal notes:

- top row dot -> handed `uppercut`
- middle row dot -> handed `straight`
- bottom row dot -> handed `hook`

BeatSaver cut-direction data is not needed for Boxing punch-family choice in this v1 rule set.

## 3. Guard rule for center pairs

The following simultaneous center-pair note groups resolve directly to `guard`:

- `{1, 2}`
- `{5, 6}`
- `{9, 10}`

AeroBeat Boxing v1 currently treats `guard` as a simple true/false authored gesture, not as separate high/mid/low guard variants.

## 4. Non-guard dual-note rule

All non-guard simultaneous dual-note groups use **alternating-drop tracking**.

### State

Maintain:

- `next_dual_keep_hand`

Initialize:

- `next_dual_keep_hand = right`

### Rule

When a non-guard dual-note group appears:

1. keep only the note owned by `next_dual_keep_hand`
2. drop the other simultaneous note
3. map the retained note by the locked single-note row-family rule
4. emit the retained handed strike
5. flip `next_dual_keep_hand`

Center guard pairs do **not** consume or flip this tracker.

### Why this is locked

This rule was chosen because it:

- resolves same-row and mixed-row non-guard duals with one consistent policy
- preserves a simple single-strike Boxing vocabulary
- avoids inventing speculative dual-punch action families for v1
- stays deterministic and easy to trace in artifacts

## 5. Obstacle / wall rule

Obstacle conversion is intentionally narrow in Boxing v1.

### Allowed synthesized Boxing avoidance outputs

- `squat`
- `weave_left`
- `weave_right`

### Forbidden synthesized Boxing avoidance outputs

- no `side_step_*`
- no `knee_*`
- no leg lifts
- no knee strikes
- no run-in-place inventions

### Collider side sets

```text
left_side_colliders = {0, 1, 4, 5, 8, 9}
right_side_colliders = {2, 3, 6, 7, 10, 11}
```

### Counting rule

For each normalized obstacle window:

- count occupied obstacle cells in `left_side_colliders`
- count occupied obstacle cells in `right_side_colliders`
- if multiple source obstacles overlap, compose them into one effective window before counting

Resolution:

- if `left_count > right_count` -> `weave_right`
- if `right_count > left_count` -> `weave_left`
- if `left_count == right_count` -> `squat`

### Locked interpretation

Balanced or non-dominant lateral pressure intentionally resolves to `squat` in Boxing v1.

## 6. Bomb rule

Bombs do **not** create Boxing-authored beats by themselves in v1.

Current locked rule:

- bomb-only content -> no Boxing-authored beat

Bombs are therefore modifier-only source signals in Boxing v1, not independent authored gameplay events.

## 7. Burst-slider rule

Burst sliders are converted in Boxing v1.

### Locked behavior

A BeatSaver burst slider expands into an **alternating-hand combo**.

Rules:

- the burst head instant is the first emitted punch
- the starting hand comes from the burst-head hand / color lane
- emitted punches alternate left/right over the burst window
- emitted punch density is limited by per-difficulty minimum interval settings
- for each emitted punch timestamp, sample the burst path at that exact moment
- map the sampled point's row band using the standard row-family rule:
  - top -> `uppercut`
  - middle -> `straight`
  - bottom -> `hook`

### Locked first-pass minimum interval table

- Easy: `1500ms`
- Normal: `1250ms`
- Hard: `1000ms`
- Expert: `750ms`
- ExpertPlus: `500ms`

These are explicit first-pass tuning knobs, not permanent claims about ideal human punch cadence.

## 8. Arc / slider rule

BeatSaver arcs / sliders produce **no Boxing-authored beat** in v1.

They are intentionally treated as guidance-only source objects for the Boxing lane.

This is a deliberate scope choice, not an accidental omission.

## Intentionally ignored or dropped source semantics

The following source semantics are intentionally not preserved as direct Boxing-authored beats in v1:

- bomb-only gameplay moments
- arc / slider authored guidance as Boxing beats
- BeatSaver cut-direction semantics as a direct Boxing punch-family input
- side-step-style avoidance output families
- lower-body speculative gesture families such as `knee_*`, leg lifts, and knee strikes
- VR-native portal-style source interpretations that do not map honestly to camera-first Boxing

## Alternatives considered

## 1. BeatSaver + extra music-analysis heuristics

### Idea

Use BeatSaver charts plus additional music-analysis signals such as phrase energy or other non-chart heuristics.

### Why not v1

This was rejected for v1 because it weakens traceability and makes the conversion less inspectable. The current direction prefers a chart-derived Boxing system first.

## 2. Gesture-classification-first Boxing architecture

### Idea

Infer Boxing moves from richer pose/velocity/gesture classification rather than from the BeatSaver chart grid as the primary authored truth.

### Why not the canonical v1 center

This remains interesting for runtime experimentation, but it was not chosen as the canonical conversion architecture because it increases ambiguity and weakens converter determinism.

## 3. Explicit dual-strike authored actions

### Idea

Preserve non-guard simultaneous dual notes by creating explicit dual-punch Boxing actions such as double hooks or double uppercuts.

### Why deferred

This was deferred because it expands the authored vocabulary and runtime validation burden, and its physical Boxing plausibility is not yet proven.

## 4. Highest-row-wins dual-note priority

### Idea

Resolve mixed-row dual notes by a fixed priority such as top row over middle row over bottom row.

### Why not chosen

This was a strong fallback candidate, but alternating-drop tracking was chosen because it handles same-row and mixed-row duals with one unified rule while preserving handed single-strike output.

## 5. Boxing arc / slider conversion

### Idea

Translate arcs / sliders into Boxing follow-through actions or calmer extended strike patterns.

### Why deferred

This was rejected for Boxing v1 because the source semantics map much more naturally to Flow than to Boxing. Forcing them into Boxing would add scope with weak truth value.

## 6. Bomb-authored Boxing gameplay

### Idea

Treat bombs as direct Boxing-authored events.

### Why rejected

This was rejected for v1 because bombs are weaker, modifier-like source cues and do not cleanly imply a distinct Boxing action family on their own.

## Provenance and artifact policy

BeatSaver-derived Boxing packages should preserve source and conversion introspection material under artifacts rather than inside the authored runtime chart.

### Canonical policy

- raw BeatSaver source stays canonical
- AeroBeat Boxing chart stays clean and runtime-focused
- conversion traces, warnings, dropped-event notes, and mapping diagnostics belong in artifacts

### Recommended artifact contents

Typical package-local artifact material may include:

- original BeatSaver ZIP
- source manifest snapshot
- extracted `Info.dat` / beatmap snapshots as needed
- conversion report
- event-by-event conversion trace or log
- warnings for dropped or ambiguous source semantics

## Closed edge-case decisions

The Boxing v1 source-coverage audit originally left a bounded set of edge cases open. Those decisions are now explicitly closed in the canonical spec.

## 1. Same-color simultaneous note groups

When multiple simultaneous notes belong to the same hand/color lane:

1. collapse the same-hand simultaneous cluster first
2. count the cluster's occupied notes by row family (`top`, `middle`, `bottom`)
3. choose the dominant row across that cluster
4. on row-count ties, the **highest row wins**
5. retain one representative note for that hand using that chosen row family
6. discard the other same-hand simultaneous notes

If both hands still remain after that collapse, apply the normal non-guard dual-note alternating-drop rule between the retained left-hand and right-hand representatives.

## 2. Explicit note angle-offset semantics

Beat Saber note angle offsets are **ignored for Boxing gameplay conversion** in v1.

They should be preserved only in conversion trace/log artifacts so future analysis or reconversion can still inspect the original source nuance.

## 3. Burst-slider source fields versus interval-based Boxing bursts

Beat Saber burst-slider source fields such as:

- `sliceCount` / `sc`
- `squish` / `s`

are **ignored for Boxing gameplay conversion** in v1.

They should be preserved only in conversion trace/log artifacts. Emitted Boxing punches still follow the locked AeroBeat interval-based burst rule.

## 4. Same-beat hybrid group priority

Resolve mixed-family same-beat collisions in two phases.

### Phase 1: family-normalize first

- resolve guard pairs within the note family
- collapse same-hand simultaneous note clusters within the note family
- preserve bursts as bursts
- treat bombs as artifact-only for Boxing-authored output
- treat arcs/sliders as artifact-only for Boxing-authored output

### Phase 2: cross-family priority

If multiple Boxing-authored candidates still remain at the same beat time after family normalization, use this priority order:

1. `burst`
2. `guard`
3. `single-punch note result`
4. ignored/artifact-only objects never win authored Boxing output

Notes that collide with an ongoing burst or a burst starting at that same time lose to the burst.

## 5. Final Boxing authored chart encoding

The final Boxing chart is a **semantic authored Boxing chart**.

That means:

- bursts are expanded during conversion into normal Boxing beats
- there is no special Boxing hold concept for this source seam
- repeated guard prompting is expressed as multiple `guard` events over time
- raw BeatSaver source plus conversion traces remain the introspection and reconversion truth
- BeatSaver-specific source-only metadata does not live in the authored Boxing runtime chart

## Implementation posture

Treat this document as the canonical Boxing v1 conversion rules source.

When the conversion is lossy, preserve the relevant source detail in artifacts rather than inventing hidden runtime semantics.

## Relationship to other docs

Use this page together with:

- `docs/gdd/gameplay/boxing.md` for the gameplay feature framing
- `docs/guides/choreography/boxing.md` for current authoring/choreography guidance
- the active BeatSaver conversion plan in `/home/derrick/.openclaw/workspace/projects/aerobeat/.plans/2026-06-23-beatsaver-conversion-architecture-and-flow-first.md` for historical decision context

When these pages disagree about BeatSaver Boxing conversion specifics, this architecture page is the canonical source.