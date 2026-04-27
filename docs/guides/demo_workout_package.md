# Demo Workout Package Guide

If you want to understand the current AeroBeat v1 package contract by reading one concrete example instead of stitching it together from several architecture pages, this is the shortest path.

## Where the example lives

The canonical docs example lives here:

- [`docs/examples/workout-packages/demo-neon-boxing-bootcamp/`](../examples/workout-packages/demo-neon-boxing-bootcamp/README.md)

That folder is intentionally authored as a **teaching package** rather than a minimal fixture.

## What to open first

1. [`workout.yaml`](../examples/workout-packages/demo-neon-boxing-bootcamp/workout.yaml)
2. Set records:
   - [`ab-set-neon-stride-opening-round.yaml`](../examples/workout-packages/demo-neon-boxing-bootcamp/sets/ab-set-neon-stride-opening-round.yaml)
   - [`ab-set-midnight-sprint-finish-round.yaml`](../examples/workout-packages/demo-neon-boxing-bootcamp/sets/ab-set-midnight-sprint-finish-round.yaml)
3. Song records:
   - [`ab-song-neon-stride.yaml`](../examples/workout-packages/demo-neon-boxing-bootcamp/songs/ab-song-neon-stride.yaml)
   - [`ab-song-midnight-sprint.yaml`](../examples/workout-packages/demo-neon-boxing-bootcamp/songs/ab-song-midnight-sprint.yaml)
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
8. [`sql/workouts.db.schema.sql`](../examples/workout-packages/demo-neon-boxing-bootcamp/sql/workouts.db.schema.sql)
9. [`sql/leaderboard-cache.db.schema.sql`](../examples/workout-packages/demo-neon-boxing-bootcamp/sql/leaderboard-cache.db.schema.sql)

## What the example demonstrates

### 1. One self-contained workout package

The example models a single package with:

- one root `workout.yaml`
- two songs
- two charts
- two sets
- one coaching domain file
- two environments
- four gameplay-facing asset records

### 2. Exact ids, not loose lookup rules

The set files point to exact:

- `songId`
- `chartId`
- `environmentId`
- `coachingOverlayId`
- gameplay-facing asset ids

That is the current v1 direction. Discovery happens elsewhere; package playback resolves exact ids.

### 2a. What the song examples are teaching

The two demo song YAML files also model the currently approved song-contract cleanup:

- `licensing.licenseType` uses the locked enum-oriented contract
- `licensing.streamingSafe` is a required boolean
- `licensing.aiAssisted` is a required boolean
- structured AI disclosure fields are only needed when `aiAssisted: true`
- `timing.bpm` stays on the song, while the old `timing.beatGrid.resolution` and `timing.beatGrid.anchors` teaching fields are gone from this slice
- `audio.previewStartMs` remains on the song
- `metadata.explicit` stays boolean
- `metadata.language` should be a valid BCP 47 language tag, with base language codes preferred unless extra specificity matters
- `metadata.genres` stays on the locked normalized lowercase enum
- song-level `tags` are intentionally absent from the current demo contract

### 3. The coaching split

The package shows the approved coaching rule clearly:

- every package has exactly one `coaches/coach-config.yaml`
- coaching is optional all-or-nothing
- if coaching is enabled, warmup/cooldown media live in coach-config, not in `workout.yaml`
- coach-config owns the overlay audio registry
- set files choose overlay clips by `coachingOverlayId`
- workout roots do not carry reusable trigger graphs or per-set overlay lists

### 4. SQLite authority boundaries

The SQL examples show the difference between:

- **authored package truth** in YAML
- **shared catalog browse/search data** in the catalog core tables
- **local install-only state** in `workout_local` when the catalog lives on disk as `workouts.db`
- **remote catalog-only state** in `workout_remote` when the same core schema is used for a downloaded/bundled remote snapshot
- **non-authoritative per-workout leaderboard cache data** in `leaderboard-cache.db`

## Why this example matters

This example is meant to be the easiest place for a new developer to answer questions like:

- "What does a valid v1 workout package folder look like?"
- "Where does coach config live?"
- "Where do warmup/cooldown references live under the approved coaching model?"
- "How does a set pick the right coaching overlay clip?"
- "Where does browse metadata belong versus package metadata?"
- "How should ids line up across package files?"

## Related docs

- [Workout Package Storage and Discovery](../architecture/workout-package-storage-and-discovery.md)
- [Content Model](../architecture/content-model.md)
- [Project Glossary](../gdd/glossary/terms.md)
- [Example package overview](../examples/workout-packages/overview.md)
