# Demo Workout Package Guide

If you want to understand the current AeroBeat v1 package contract by reading one concrete example instead of stitching it together from several architecture pages, this is the shortest path.

## Where the example lives

The canonical docs example lives here:

- [`docs/examples/workout-packages/demo-neon-boxing-bootcamp/`](../examples/workout-packages/demo-neon-boxing-bootcamp/README.md)

That folder is intentionally authored as a **teaching package** rather than a minimal fixture.

## What to open first

1. [`workout.yaml`](../examples/workout-packages/demo-neon-boxing-bootcamp/workout.yaml)
2. Song records:
   - [`ab-song-neon-stride.yaml`](../examples/workout-packages/demo-neon-boxing-bootcamp/songs/ab-song-neon-stride.yaml)
   - [`ab-song-midnight-sprint.yaml`](../examples/workout-packages/demo-neon-boxing-bootcamp/songs/ab-song-midnight-sprint.yaml)
3. Routine records:
   - [`ab-routine-neon-stride-boxing.yaml`](../examples/workout-packages/demo-neon-boxing-bootcamp/routines/ab-routine-neon-stride-boxing.yaml)
   - [`ab-routine-midnight-sprint-boxing.yaml`](../examples/workout-packages/demo-neon-boxing-bootcamp/routines/ab-routine-midnight-sprint-boxing.yaml)
4. Chart records:
   - [`ab-chart-neon-stride-boxing-medium.yaml`](../examples/workout-packages/demo-neon-boxing-bootcamp/charts/ab-chart-neon-stride-boxing-medium.yaml)
   - [`ab-chart-midnight-sprint-boxing-hard.yaml`](../examples/workout-packages/demo-neon-boxing-bootcamp/charts/ab-chart-midnight-sprint-boxing-hard.yaml)
5. [`coaches/coach-config.yaml`](../examples/workout-packages/demo-neon-boxing-bootcamp/coaches/coach-config.yaml)
6. Environment records:
   - [`ab-environment-neon-rooftop.yaml`](../examples/workout-packages/demo-neon-boxing-bootcamp/environments/ab-environment-neon-rooftop.yaml)
   - [`ab-environment-sunrise-studio.yaml`](../examples/workout-packages/demo-neon-boxing-bootcamp/environments/ab-environment-sunrise-studio.yaml)
7. Asset records:
   - [`ab-asset-gloves-neon-pulse.yaml`](../examples/workout-packages/demo-neon-boxing-bootcamp/assets/ab-asset-gloves-neon-pulse.yaml)
   - [`ab-asset-targets-holo-rings.yaml`](../examples/workout-packages/demo-neon-boxing-bootcamp/assets/ab-asset-targets-holo-rings.yaml)
   - [`ab-asset-obstacles-light-walls.yaml`](../examples/workout-packages/demo-neon-boxing-bootcamp/assets/ab-asset-obstacles-light-walls.yaml)
   - [`ab-asset-trails-comet-streak.yaml`](../examples/workout-packages/demo-neon-boxing-bootcamp/assets/ab-asset-trails-comet-streak.yaml)
   - [`ab-asset-coach-avatar-aria-holo.yaml`](../examples/workout-packages/demo-neon-boxing-bootcamp/assets/ab-asset-coach-avatar-aria-holo.yaml)
   - [`ab-asset-coach-voice-aria-energetic.yaml`](../examples/workout-packages/demo-neon-boxing-bootcamp/assets/ab-asset-coach-voice-aria-energetic.yaml)
8. [`sql/workouts.db.schema.sql`](../examples/workout-packages/demo-neon-boxing-bootcamp/sql/workouts.db.schema.sql)
9. [`sql/leaderboard-cache.db.schema.sql`](../examples/workout-packages/demo-neon-boxing-bootcamp/sql/leaderboard-cache.db.schema.sql)

## What the example demonstrates

### 1. One self-contained workout package

The example models a single package with:

- one root `workout.yaml`
- two songs
- two boxing routines
- two charts
- one coaching domain file
- two environments
- six asset records covering the full locked v1 `assetType` enum

### 2. Exact ids, not loose lookup rules

The workout session entries point to exact:

- `songId`
- `routineId`
- `chartId`
- `environmentId`
- gameplay-facing asset ids

That is the current v1 direction. Discovery happens elsewhere; package playback resolves exact ids.

### 3. The coaching split

The package shows the locked coaching rule clearly:

- workout entries use `assetSelections` only for gameplay-facing asset types
- coach avatar and voice assets live in the shared `assets/` domain
- those coach support assets are referenced from `coaches/coach-config.yaml`, not from workout entries

### 4. SQLite authority boundaries

The SQL examples show the difference between:

- **authored package truth** in YAML
- **installed workout browse/search data** in `workouts.db`
- **non-authoritative per-workout leaderboard cache data** in `leaderboard-cache.db`

## Why this example matters

This example is meant to be the easiest place for a new developer to answer questions like:

- "What does a valid v1 workout package folder look like?"
- "Where does coach config live?"
- "Which asset types can a workout entry select directly?"
- "Where does browse metadata belong versus package metadata?"
- "How should ids line up across package files?"

## Related docs

- [Workout Package Storage and Discovery](../architecture/workout-package-storage-and-discovery.md)
- [Content Model](../architecture/content-model.md)
- [Project Glossary](../gdd/glossary/terms.md)
- [Example package overview](../examples/workout-packages/overview.md)
