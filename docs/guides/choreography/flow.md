# Creating Flow Choreography

Flow is a retained AeroBeat gameplay feature, but the old portal-driven authored chart model is no longer the current truth for the camera-first product slice.

## Authoring priorities

- preserve readable continuous motion on camera
- keep movement safe and well telegraphed
- optimize for the PC-first community release path
- stay honest about the direct calibrated 4x3 gameplay direction instead of re-teaching the older normalized Flow vocabulary

## Current direction

Flow is now aimed at a **direct calibrated 4x3 camera-space model**.

That means current docs should think in terms of:

- a fixed athlete-relative 4x3 grid locked from calibration
- left/right wrist entry into exact target cells
- arrow-note direction judged from recent wrist motion, not from old authored `portal` / `placement` semantics
- bombs as wrist-space avoid objects
- obstacles as nose-space occupancy bans
- arcs/sliders as guidance-only visuals in v1

## Chart-shape note for this pass

The old docs taught Flow as a flat `beats:` list with `portal`, `placement`, and follow-through `direction` as the canonical authored model. That is now stale and should not be treated as the current contract.

The only Flow object shape already frozen tightly enough to teach here is the first-pass `burst` beat object:

- required `start`
- required `end`
- required `type: burst`
- required `hand` (`left` / `right`)
- required head `placement`
- required head `direction`
- required `tailPlacement`
- required `checkpointCount`
- optional `spacingBias`

For ordinary Flow notes/objects, the durable YAML encoding is still being rewritten around the direct 4x3 model. Until that lands, do **not** author new canonical examples around old `portal`, `swing_*`, `trail_*`, `warn_*`, or `reward_*` chart vocabulary.

## BeatSaver conversion reference

If you need the canonical import/conversion rules for deriving Flow charts from BeatSaver source data, use:

- [BeatSaver to AeroBeat Flow v1 Conversion](../../architecture/beatsaver-flow-v1-conversion.md)

This choreography page stays focused on authoring guidance rather than source-conversion policy.

## Scope note

Flow still needs future-friendly rendering flexibility, but the official docs should stay grounded in camera gameplay first and should not preserve superseded portal-era contract language as fallback guidance.
