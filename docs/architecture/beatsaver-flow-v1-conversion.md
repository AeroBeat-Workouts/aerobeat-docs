# BeatSaver to AeroBeat Flow v1 Conversion

This document is the canonical AeroBeat docs home for the **Flow v1 BeatSaver conversion spec**.

Use this page when you need the current truth for:

- what BeatSaver / Beat Saber Standard-map objects AeroBeat Flow v1 converts
- which direct calibrated 4x3 gameplay rules are already locked
- which source objects are scored, guidance-only, or hazard-only in Flow v1
- the frozen first-pass Flow burst object schema
- which important implementation seams are still intentionally open

This page is intentionally a **conversion architecture and rules** document, not a general Flow gameplay page and not a choreography how-to.

## Why this is the canonical home

The Flow gameplay pages describe the player-facing feature and current product intent. They are not the most truthful place for a BeatSaver-specific import/conversion contract that spans:

- external source semantics
- calibration-locked gameplay geometry
- source-object handling policy
- timing-window policy
- authored-chart schema seams
- provenance and converter artifact policy

Those concerns belong in Architecture because they define the tooling and content-conversion seam between BeatSaver source data and AeroBeat-authored Flow charts.

## Scope

This document covers **AeroBeat Flow v1 conversion from BeatSaver / Beat Saber Standard-map source data**.

It does not define:

- the general AeroBeat Flow player fantasy
- Boxing conversion in full detail
- every future Flow runtime implementation choice outside the locked conversion contract

## Canonical philosophy

### Source truth

For BeatSaver-derived Flow content, the **raw BeatSaver source remains canonical source truth**.

That means:

- the original BeatSaver map package remains the authoritative record of what was imported
- AeroBeat Flow charts are a **derived authored runtime form**, not the primary archival source
- source-specific provenance, debug traces, warnings, and mapping diagnostics belong in package artifacts, not in the clean runtime chart payload

### Conversion goal

Flow v1 aims for a **deterministic, BeatSaver-first conversion system** grounded in direct camera-space gameplay rather than a larger semantic translation layer.

The current product direction is:

- preserve BeatSaver spatial/timing truth as directly as practical
- convert notes one-to-one into a calibrated athlete-relative 4x3 play grid
- keep scoring rules explicit, inspectable, and tunable
- accept honest simplifications rather than pretending unsupported semantics were preserved perfectly

### Product posture

Flow v1 should be treated as a **camera-first AeroBeat gameplay translation** of BeatSaver input, not as a one-to-one preservation of VR saber semantics.

## Architecture choice now locked

### Locked v1 architecture: direct calibrated 4x3 Flow conversion

The current canonical direction is a **direct calibrated 4x3 Flow model**.

BeatSaver notes map into a fixed athlete-relative 4x3 gameplay board captured during calibration, not into the older AeroBeat portal-era authored placement/direction abstraction.

The converter should derive Flow gameplay from source chart structure, not from:

- portal-based authored placement vocabularies
- large gesture-taxonomy reinterpretation passes
- hidden runtime-only semantic remapping with no durable conversion trace
- extra music-analysis heuristics unrelated to the BeatSaver chart

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

For Flow v1, those source cells map directly into the athlete's calibrated gameplay grid rather than being collapsed into an 8-way-plus-center authored placement system first.

## Locked calibration model

### Calibration pose and anchors

Flow v1 uses a **calibration-locked athlete-relative grid**.

Locked first-pass calibration rules:

- the athlete calibrates in a simple **T-pose**
- horizontal grid width is derived directly from the calibrated wrist-to-wrist span
- grid anchor `x` is the calibrated `nose` landmark `x`
- grid anchor `y` is derived from the calibrated average of the two shoulder `y` landmark positions
- the grid is then **locked in place for gameplay** rather than following the athlete dynamically

### Grid geometry

Locked first-pass geometry rules:

- the 4 columns are split evenly across the calibrated wrist-to-wrist width
- each cell width is `wrist_span / 4`
- the 3 rows use the same dimension so cells stay square in first pass
- shoulder level is the center-row height reference in camera space
- the bottom row sits below shoulder level
- the top row sits above shoulder level

### Runtime landmarks

Flow gameplay evaluates these landmarks against the locked grid:

- `wrist_left`
- `wrist_right`
- `nose`

## Locked object coverage

The recent Flow architecture refresh closes the policy treatment for the major Standard-map object families.

### Explicitly covered in Flow v1

- normal colored notes
- directionless / dot notes
- bombs
- obstacles / walls
- arcs / sliders
- burst sliders

Coverage does **not** mean every object becomes a scored authored Flow beat. Some become scored note targets, some remain guidance-only, and some remain hazard-only.

## Locked conversion rules

## 1. Normal note target rule

Each normal BeatSaver note targets **one exact 4x3 cell**.

- left-color notes use `wrist_left`
- right-color notes use `wrist_right`
- the correct wrist must **enter** the target cell during the valid timing window
- simply already being parked in the target cell before the valid window does **not** satisfy the note

This entry-event rule is the core direct-grid Flow v1 hit rule.

## 2. Dot-note rule

Dot notes still require a correct-wrist **entry event** into the target cell during the valid timing window.

They do **not** add a directional validation requirement.

## 3. Arrow-direction rule

Arrow notes require both:

- correct-wrist entry into the target cell during the valid timing window, and
- a direction match between the required BeatSaver arrow direction and the athlete's recent wrist motion

### Locked motion-direction model

Flow v1 direction validation uses a **rolling shoulder-relative wrist-motion system**.

Locked first-pass rules:

- maintain a short rolling wrist-position history for each hand
- compute a smoothed recent motion vector over a tunable recent time window rather than from a single-frame delta
- interpret that motion vector in **8-way shoulder-relative directional space**
- left-wrist direction uses the **left shoulder** as its anchor frame
- right-wrist direction uses the **right shoulder** as its anchor frame
- if recent motion magnitude is below a tunable minimum threshold, direction is treated as ambiguous/invalid rather than allowing tiny jitter to count as a real swing

This closes the previously open diagonal-approach problem by not depending on a brittle one-cell predecessor rule.

## 4. Timing-window rule

BeatSaver source timing remains the note timing truth, but AeroBeat owns the gameplay forgiveness window around that truth.

### Locked timing architecture

- timing evaluation attaches to the wrist **entry event** into the target cell
- early and late windows are symmetric in first pass
- camera-delay compensation stays in a **separate calibration layer** and is not folded into chart conversion semantics
- base timing windows vary by difficulty
- an athlete-facing modifier may widen or tighten those windows without changing the converted chart structure

### Locked first-pass timing defaults

Base timing window by difficulty:

- `Easy = ±220ms`
- `Normal = ±180ms`
- `Hard = ±145ms`
- `Expert = ±115ms`
- `ExpertPlus = ±90ms`

Athlete-facing timing preference modifier:

- `Very Lenient = +40ms`
- `Lenient = +20ms`
- `Standard = 0ms`
- `Strict = -20ms`
- `Very Strict = -40ms`

The important architectural lock is the layering:

- BeatSaver timing truth
- AeroBeat-owned difficulty timing window
- optional athlete preference modifier
- separate camera-delay calibration

## 5. Bomb rule

Bombs are **fail-on-contact only** in Flow v1.

Locked first-pass bomb rules:

- bombs are direct 4x3 **wrist-space exclusion objects**
- a live bomb occupies its authored source cell/time window in the calibrated grid
- the relevant wrist must avoid contacting that live bomb cell during the active window
- bombs do **not** synthesize separate authored avoidance beats or reroute/pathfinding hints in v1

## 6. Obstacle / wall rule

Obstacles are **nose-space occupancy bans only** in Flow v1.

Locked first-pass obstacle rules:

- wrist/hand positions do **not** fail a Flow obstacle by themselves
- the athlete avoids the obstacle by keeping the `nose` landmark out of the blocked obstacle cells/window while it is active
- this intentionally mirrors Beat Saber head-collider semantics rather than inventing a separate full-body movement-beat vocabulary

## 7. Arc / slider rule

Arcs/sliders are **guidance-only** objects in Flow v1.

Locked first-pass arc/slider rules:

- preserve them as visuals because they help sight-reading and wrist-position anticipation
- do **not** score them as strict continuous path-follow requirements
- do **not** fail the athlete for not tracing the exact arc path

This preserves useful mapper guidance without overclaiming brittle path-validation semantics.

## 8. Burst-slider rule

Burst sliders survive in Flow v1 as a **higher-level Flow burst object** rather than being flattened away.

### Locked behavior intent

- bursts remain burst-shaped gameplay, not ordinary single-note replacements
- the burst preserves source timing span, hand ownership, and head/tail cell identity
- `checkpointCount` gives the repeated checkpoint density across the burst window
- `spacingBias` optionally preserves source compression/shaping intent when the converter wants it
- the runtime derives internal checkpoints across `start..end` using the `placement -> tailPlacement` path

### Frozen authored schema

The frozen first-pass AeroBeat Flow burst object stays inside the existing flat `beats:` list.

```yaml
- start: <number>
  end: <number>
  type: burst
  hand: left | right
  placement: <int>
  direction: <int>
  tailPlacement: <int>
  checkpointCount: <int>
  spacingBias: <number>   # optional
```

### Locked field mapping from BeatSaver source

- head time -> `start`
- tail time -> `end`
- head cell -> `placement`
- tail cell -> `tailPlacement`
- head cut direction -> `direction`
- color / hand lane -> `hand`
- `sliceCount` / `sc` -> `checkpointCount`
- `squish` / `s` -> optional `spacingBias`

Raw source-specific field names stay out of the authored AeroBeat chart and remain converter/trace concerns only.

## Authored chart posture in this slice

### What is already frozen

The only Flow object shape currently frozen tightly enough to teach as durable authored schema is the first-pass `burst` object above.

### What is not yet frozen

The final general-purpose AeroBeat YAML encoding for ordinary Flow notes, bombs, obstacles, and guidance objects is **not yet fully rewritten and locked** around the direct 4x3 model.

That means:

- the direct gameplay contract in this document is canonical
- the old `portal` / `placement` / follow-through `direction` authored model is **not** canonical current truth
- docs and examples should not reintroduce old `portal`, `swing_*`, `trail_*`, `warn_*`, or `reward_*` vocabulary as fallback guidance

## Provenance and artifact policy

BeatSaver-derived Flow packages should preserve source and conversion introspection material under artifacts rather than inside the clean authored runtime chart.

Typical artifact material may include:

- original BeatSaver ZIP
- normalized source summary
- conversion warnings
- converter trace / diagnostics
- unsupported-object notes

This keeps the runtime chart AeroBeat-native while preserving reconversion/debug truth.

## Important seams intentionally still open

These seams remain open on purpose and should not be papered over as if they are already settled:

## 1. Final ordinary Flow YAML contract

The direct 4x3 gameplay rules are locked, but the final durable authored YAML shape for ordinary non-burst Flow objects is still being rewritten.

## 2. Exact row-boundary tuning and recenter behavior

The anchor model is locked, but the following still need implementation tuning:

- exact row boundaries around the shoulder-height center reference
- whether light recenter/recalibration behavior is needed between songs or after tracking drift

## 3. Motion-direction tuning knobs

The direction-validation architecture is locked, but first-pass tuning remains implementation-owned, especially for:

- recent motion direction window length
- minimum motion magnitude threshold
- smoothing behavior and debug visualization

## 4. Burst checkpoint math details

The burst schema is frozen, but these details remain intentionally open for implementation iteration:

- exact checkpoint spacing math for `checkpointCount`
- the precise practical effect/formula for `spacingBias`
- any needed normalization differences between BeatSaver v3 burst sliders and v4 chains

## 5. Source-format normalization details

The Flow-side policy is locked, but the exact converter normalization seam across supported BeatSaver / Beat Saber source versions still belongs to implementation work rather than this architecture page.

## Cross-links

For adjacent current-truth pages, use:

- [Gameplay Core: Flow](../gdd/gameplay/flow.md)
- [Creating Flow Choreography](../guides/choreography/flow.md)
- [Content Model](content-model.md)
- [BeatSaver to AeroBeat Boxing v1 Conversion](beatsaver-boxing-v1-conversion.md)

When these pages disagree about BeatSaver Flow conversion specifics, this architecture page is the canonical source.
