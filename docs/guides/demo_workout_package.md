# Demo Workout Package Guide

This guide points to one concrete example of the current AeroBeat workout-package contract.

## Where the example lives

- [`docs/examples/workout-packages/demo-neon-boxing-bootcamp/`](../examples/workout-packages/demo-neon-boxing-bootcamp/README.md)

## What to open first

1. [`workout.yaml`](../examples/workout-packages/demo-neon-boxing-bootcamp/workout.yaml)
2. Set records:
   - [`ab-set-neon-stride-opening-round.yaml`](../examples/workout-packages/demo-neon-boxing-bootcamp/sets/ab-set-neon-stride-opening-round.yaml)
   - [`ab-set-neon-stride-flow-round.yaml`](../examples/workout-packages/demo-neon-boxing-bootcamp/sets/ab-set-neon-stride-flow-round.yaml)
   - [`ab-set-midnight-sprint-finish-round.yaml`](../examples/workout-packages/demo-neon-boxing-bootcamp/sets/ab-set-midnight-sprint-finish-round.yaml)
3. Song records
4. Chart records:
   - Boxing
   - Flow
5. [`coaches/coach-config.yaml`](../examples/workout-packages/demo-neon-boxing-bootcamp/coaches/coach-config.yaml)
6. Environment records
7. SQL schema examples

## What the example demonstrates

### 1. One self-contained workout package

The example models a single package with:

- one root `workout.yaml`
- two songs
- three charts
- three sets
- one coaching domain file
- two environments
- example SQL schema files

### 2. One public difficulty per package

The v1 publishing model treats each public package as **one difficulty only**.

That means this example should be read as a package-contract example, not as proof that multiple public difficulties should be bundled into one store item. Alternate difficulties should be split into separate public packages.

### 3. Exact ids, not loose lookup rules

The set files point to exact ids for:

- `songId`
- `chartId`
- `environmentId`
- `coachingOverlayId`

Discovery happens elsewhere; package playback resolves exact ids.

### 4. Coaching stays package-local and optional

- every package has exactly one `coaches/coach-config.yaml`
- coaching is optional all-or-nothing
- enabled coaching owns warm-up/cool-down media and the overlay registry
- sets choose overlay clips by `coachingOverlayId`
- when coaching is enabled, each set needs its own unique VO file

### 5. Environments remain part of the package model

The checked-in environment examples teach the small Environment v1 record shape:

- `environmentId`
- `environmentName`
- `type`
- `resourcePath`

The current official environment `type` values are `image_background`, `video_background`, `glb_environment`, and the controlled advanced `splat` path. Within that advanced splat lane, `.compressed.ply` is the official recommended AeroBeat payload, while `.ply`, `.splat`, and `.sog` remain compatibility-supported through GDGS. This checked-in demo package still only shows the more mainstream image + GLB lanes; it does not try to present splat as the default beginner example.

For public publishing, every set needs an environment, and a **static 2D background image** is an acceptable minimum.

### 6. Cover art is still required

The environment payload does **not** replace storefront art. Public packages still need a **thumbnail / cover-art asset**.

### 7. What is intentionally gone from this example

This docs pass removes the older package-local gameplay asset concept.

If you are looking for long-term customization direction, think in terms of:

- avatar identity
- cosmetics
- workout-point unlock paths

not freeform package-local asset swapping inside every workout.
