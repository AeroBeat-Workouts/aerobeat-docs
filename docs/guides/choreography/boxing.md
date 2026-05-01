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

## Scope note

Portal-aware presentation remains valid in the docs, but it should not be read as a promise that VR or non-camera Boxing is official v1 scope.
