# Creating Boxing Choreography

Boxing is a core retained AeroBeat gameplay feature and should be authored for the current camera-first product slice.

## Authoring priorities

- keep movement readable on camera
- favor safe, repeatable workout motion
- use portal placement when it improves choreography, not just because the system allows it
- optimize first for the PC community release path

## Chart shape

A Boxing chart is a reusable **Chart** record. The song owns audio/timing, the chart owns one concrete playable difficulty, and a package-local **Set** links the chart to the selected song, environment, and optional coaching overlay.

Each boxing beat uses:

- required `start`
- optional inclusive `end`
- required concrete `type`
- optional integer `portal`

For current chart truth:

- use `punch_left` / `punch_right` for straight punches, not `jab` / `cross`
- use `guard` for guard holds/prompts
- treat `orthodox` / `southpaw` as authored stance semantics, not tracked input events

## BeatSaver conversion reference

If you need the canonical import/conversion rules for deriving Boxing charts from BeatSaver source data, use:

- [BeatSaver to AeroBeat Boxing v1 Conversion](../../architecture/beatsaver-boxing-v1-conversion.md)

This choreography page stays focused on authoring guidance rather than source-conversion policy.

## Scope note

Portal-aware presentation remains valid in the docs, but it should not be read as a promise that VR or non-camera Boxing is official v1 scope.
