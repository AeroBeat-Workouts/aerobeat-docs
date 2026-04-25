# Demo Workout Package Example

This section gives you one **complete, docs-friendly AeroBeat v1 workout package** you can inspect file by file.

If you are new to the package system, start here before reading the lower-level schema prose. The example package is intentionally written as a teaching artifact:

- ids match across files
- comments sit **above** each meaningful field or section
- the files model the current **locked v1 contract**
- the package demonstrates the split between authored YAML, local `workouts.db`, and per-workout `leaderboard-cache.db`

## Start Here

- [Demo package README](demo-neon-boxing-bootcamp/README.md)
- [Package root `workout.yaml`](demo-neon-boxing-bootcamp/workout.yaml)
- Songs:
  - [`ab-song-neon-stride.yaml`](demo-neon-boxing-bootcamp/songs/ab-song-neon-stride.yaml)
  - [`ab-song-midnight-sprint.yaml`](demo-neon-boxing-bootcamp/songs/ab-song-midnight-sprint.yaml)
- Routines:
  - [`ab-routine-neon-stride-boxing.yaml`](demo-neon-boxing-bootcamp/routines/ab-routine-neon-stride-boxing.yaml)
  - [`ab-routine-midnight-sprint-boxing.yaml`](demo-neon-boxing-bootcamp/routines/ab-routine-midnight-sprint-boxing.yaml)
- Charts:
  - [`ab-chart-neon-stride-boxing-medium.yaml`](demo-neon-boxing-bootcamp/charts/ab-chart-neon-stride-boxing-medium.yaml)
  - [`ab-chart-midnight-sprint-boxing-hard.yaml`](demo-neon-boxing-bootcamp/charts/ab-chart-midnight-sprint-boxing-hard.yaml)
- [Coach config](demo-neon-boxing-bootcamp/coaches/coach-config.yaml)
- Environments:
  - [`ab-environment-neon-rooftop.yaml`](demo-neon-boxing-bootcamp/environments/ab-environment-neon-rooftop.yaml)
  - [`ab-environment-sunrise-studio.yaml`](demo-neon-boxing-bootcamp/environments/ab-environment-sunrise-studio.yaml)
- Assets:
  - [`ab-asset-gloves-neon-pulse.yaml`](demo-neon-boxing-bootcamp/assets/ab-asset-gloves-neon-pulse.yaml)
  - [`ab-asset-targets-holo-rings.yaml`](demo-neon-boxing-bootcamp/assets/ab-asset-targets-holo-rings.yaml)
  - [`ab-asset-obstacles-light-walls.yaml`](demo-neon-boxing-bootcamp/assets/ab-asset-obstacles-light-walls.yaml)
  - [`ab-asset-trails-comet-streak.yaml`](demo-neon-boxing-bootcamp/assets/ab-asset-trails-comet-streak.yaml)
  - [`ab-asset-coach-avatar-aria-holo.yaml`](demo-neon-boxing-bootcamp/assets/ab-asset-coach-avatar-aria-holo.yaml)
  - [`ab-asset-coach-voice-aria-energetic.yaml`](demo-neon-boxing-bootcamp/assets/ab-asset-coach-voice-aria-energetic.yaml)
- [Local `workouts.db` schema example](demo-neon-boxing-bootcamp/sql/workouts.db.schema.sql)
- [Per-workout `leaderboard-cache.db` schema example](demo-neon-boxing-bootcamp/sql/leaderboard-cache.db.schema.sql)

## What this example is teaching

This demo package is aligned to the current package rules:

- **Chart** is the durable term, not chart variant.
- A package has **one** `coaches/` folder and **one** `coach-config.yaml` file.
- Workout entries select gameplay-facing assets through `assetSelections` only.
- Coach avatar/voice assets are referenced from `coaches/coach-config.yaml`, not from workout entries.
- Local discoverability belongs in **`workouts.db`**, not in package YAML.
- Packages are **self-contained** and are versioned by duplication/forking rather than inheritance/patch layering.
- The future online catalog DB is intentionally **separate** from local `workouts.db`.
- Signing and integrity metadata are **deferred** from the v1 authored package contract.
- The locked v1 `assetType` enum is:
  - `gloves`
  - `targets`
  - `obstacles`
  - `trails`
  - `coach_avatar`
  - `coach_voice`

## How to read the package

1. Open [`workout.yaml`](demo-neon-boxing-bootcamp/workout.yaml) to see the package root, session order, and referenced ids.
2. Open the `songs/`, `routines/`, and `charts/` files to follow how exact playable content is layered.
3. Open [`coaches/coach-config.yaml`](demo-neon-boxing-bootcamp/coaches/coach-config.yaml) to see the single-package coaching domain.
4. Open the `environments/` and `assets/` files to see how reusable package-local presentation content is defined.
5. Open the two SQL files to see what belongs in local discovery/cache databases versus authored YAML.

## Important scope note

This is a **documentation example**, not a shippable media bundle. The YAML records point at realistic package-local `media/...` paths, but this docs repo does not include the large binary audio/video/scene payloads those paths would resolve to in a real installed workout package.
