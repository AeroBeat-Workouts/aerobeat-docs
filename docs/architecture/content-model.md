# Content Model: Songs, Charts, Sets, and Workouts

AeroBeat content is authored as a layered model rather than a single flat chart blob.

## Durable package hierarchy

- **Song**
- **Chart**
- **Set**
- **Workout**

Optional package-local domains kept in this slice:

- **Coach Config**
- **Environment**

Older docs also modeled package-local gameplay asset records. That is no longer part of the official workout-package concept for this v1 documentation pass.

## Current schema direction

- use consistent `*Id` + `*Name` fields where applicable
- all primary ids are UIDs
- authored YAML records carry shared schema/provenance fields
- `Chart` is the durable term for one concrete playable difficulty slice
- `Set` is the durable composition linker for exact song/chart/environment/coaching selections
- `Workout` resolves to an ordered list of `setId` values
- `Song` records do not link to charts, sets, or workouts
- `Chart` records do not link to songs or sets
- athlete/device calibration data does not belong in durable content

## Why AeroBeat needs `Set`

`Set` is the durable linker between exact playable authored content and an ordered workout program.

A set owns the exact composition for one playable slice:

- `songId`
- `chartId`
- `environmentId`
- optional `coachingOverlayId`

That keeps workout composition explicit without inlining everything into `workout.yaml`.

## Environment

An `Environment` is a reusable package-local presentation record selected by a set.

Environment v1 keeps the authored record intentionally small:

- `environmentId`
- `environmentName`
- `type`
- `resourcePath`

Locked `type` values:

- `image_background`
- `video_background`
- `glb_environment`
- `splat`

`image_background`, `video_background`, and `glb_environment` remain the broad creator-friendly lanes. `splat` is now an official package type too, but it should be treated as a controlled advanced environment path: exported workouts still stay self-contained, while the current validated runtime path is desktop-oriented and depends on Forward Plus plus compute-capable GPU support.

## Customization direction after asset-package removal

The removal of package-local gameplay asset records from this slice is a product-scope decision, not a statement that visuals never matter. The new customization direction should point toward:

- player profile identity
- avatars
- cosmetics
- controlled unlocks via workout points

That keeps the workout package focused on workout content while leaving room for broader account-level customization later.

## Shared chart envelope

AeroBeat still uses a shared chart envelope with feature-specific payload meaning. For the active gameplay docs slice, the important authored features are Boxing and Flow.

- Boxing uses a flat `beats` list with `start`, optional `end`, required `type`, and optional `portal`; straight punches should use `punch_left` / `punch_right`, `guard` is canonical wording, and `orthodox` / `southpaw` remain authored stance semantics rather than tracked input events
- Flow uses the same base shape with Flow-specific `placement` and optional `direction`, where `placement` is the pass-through location and `direction` is follow-through guidance
- Legacy `events` / `interactionFamily` chart-envelope wording is not part of the canonical v1 authored contract in this docs slice

Dance and Step are no longer active gameplay features in this docs set.
