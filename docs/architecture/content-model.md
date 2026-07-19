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

`image_background`, `video_background`, and `glb_environment` remain the broad creator-friendly lanes. `splat` is now an official package type too, but it should be treated as a controlled advanced environment path: AeroBeat should prefer `.compressed.ply` as the official recommended splat payload, while `.ply`, `.splat`, and `.sog` remain compatibility-supported through GDGS. Exported workouts still stay self-contained, while the current validated runtime path is desktop-oriented and depends on Forward Plus plus compute-capable GPU support.

## Customization direction after asset-package removal

The removal of package-local gameplay asset records from this slice is a product-scope decision, not a statement that visuals never matter. The new customization direction should point toward:

- player profile identity
- avatars
- cosmetics
- controlled unlocks via workout points

That keeps the workout package focused on workout content while leaving room for broader account-level customization later.

## Shared chart envelope

AeroBeat still uses a shared chart envelope with feature-specific payload meaning. For the active gameplay docs slice, the important authored features are Boxing and Flow.

- Boxing uses a flat `beats` list with `start`, optional `end`, and required `type`. Current canonical Boxing examples should align with the semantic v1 vocabulary: handed `straight_*`, `hook_*`, and `uppercut_*` strikes plus `guard`, `squat`, and `weave_*` movement beats. Portal-based Boxing chart language is no longer current contract truth.
- Flow is moving to a direct calibrated 4x3 gameplay model built around wrist target cells, direction checks derived from motion, bomb hazards, nose-space obstacles, guidance arcs, and higher-level burst objects. The older `portal` / `placement` / follow-through `direction` authored model should not be presented as the current contract.
- Legacy `events` / `interactionFamily` chart-envelope wording is not part of the canonical v1 authored contract in this docs slice.

Dance and Step are no longer active gameplay features in this docs set.
