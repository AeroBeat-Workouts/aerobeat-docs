# Creating Boxing Choreography

Boxing is a core retained AeroBeat gameplay feature and should be authored for the current camera-first product slice.

## Authoring priorities

- keep movement readable on camera
- favor safe, repeatable workout motion
- optimize first for the PC community release path
- align example/chart vocabulary with the locked BeatSaver Boxing v1 conversion contract

## Chart shape

A Boxing chart is a reusable **Chart** record. The song owns audio/timing, the chart owns one concrete playable difficulty, and a package-local **Set** links the chart to the selected song, environment, and optional coaching overlay.

For the current first-pass canonical Boxing vocabulary, use flat `beats:` entries built from:

- required `start`
- optional inclusive `end`
- required concrete `type`

Current contract-aligned Boxing beat families are:

- `straight_left` / `straight_right`
- `hook_left` / `hook_right`
- `uppercut_left` / `uppercut_right`
- `guard`
- `squat`
- `weave_left` / `weave_right`

For this docs pass:

- do **not** treat `portal` as part of the current Boxing chart contract
- do **not** teach `punch_left` / `punch_right`, `knee_*`, `leg_lift_*`, `sidestep_*`, or `run_in_place` as current canonical Boxing chart vocabulary
- keep the Boxing chart semantic and runtime-focused rather than source-shaped

## BeatSaver conversion reference

If you need the canonical import/conversion rules for deriving Boxing charts from BeatSaver source data, use:

- [BeatSaver to AeroBeat Boxing v1 Conversion](../../architecture/beatsaver-boxing-v1-conversion.md)

This choreography page stays focused on authoring guidance rather than source-conversion policy.

## Scope note

Portal-aware or VR-oriented presentation ideas can still exist as future runtime concerns, but they should not be taught as part of the current Boxing chart contract.
