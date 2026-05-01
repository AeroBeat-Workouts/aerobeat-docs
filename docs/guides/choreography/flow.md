# Creating Flow Choreography

Flow is a retained AeroBeat gameplay feature and should be authored conservatively for the current camera-first product slice.

## Authoring priorities

- preserve readable continuous motion
- keep body-movement prompts safe and well telegraphed
- optimize for the PC-first community release path
- treat broader platform/rendering flexibility as future-friendly, not equal-status v1 scope

## Chart shape

Flow charts use a flat `beats:` list under `feature: flow`.

Each beat may include:

- required `start`
- optional inclusive `end`
- required `type`
- optional `portal`
- optional `placement`
- optional `direction`

## Scope note

Flow's future adaptability across renderers and platforms is still useful, but the official product docs should stay grounded in camera-based gameplay first.
