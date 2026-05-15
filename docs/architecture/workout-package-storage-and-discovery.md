# Workout Package Storage and Discovery

This document defines the current canonical direction for how AeroBeat workout packages are authored, stored on disk, discovered at runtime, and indexed for browsing.

## Locked direction for this slice

- workout packages are **self-contained**
- YAML is the **durable authored format**
- discoverability lives in **`workouts.db`**, not in package YAML
- the package contains the data required to validate and play the workout
- each package has one `coaches/` folder containing exactly one `coach-config.yaml`
- coaching is optional all-or-nothing
- alternate versions are created by duplication/forking, not inheritance layering
- `sets/` is the package's single source of truth for workout composition
- `workout.yaml` owns package metadata plus ordered `setId` values
- `sets/*.yaml` link songs, charts, environments, and coaching overlay ids together using ids, not paths
- environments remain part of the package concept
- package-local gameplay assets are **not** part of the official v1 package concept for this docs slice

## Durable package hierarchy

- **Song** — reusable audio and timing identity
- **Chart** — one exact playable difficulty slice
- **Set** — package-local composition record linking exact ids
- **Workout** — the workout/package root that orders authored sets
- **Coach Config** — the workout-level coaching/media registry
- **Environment** — a reusable environment record authorable inside the package

## Authority split

### 1. Package YAML = authored truth

Package YAML owns:

- songs, charts, sets, workout metadata
- optional package-local coaching configuration
- package-local environments
- schema/package/tool provenance metadata

Package YAML does **not** own:

- browse/search indexing
- athlete/device calibration overrides
- authoritative leaderboard history
- player-wide social/profile state
- package-local gameplay asset customization contracts for this v1 slice

### 2. `workouts.db` = discovery index

`workouts.db` powers local browsing, filtering, moderation surfaces, and install-state lookups. It is derived data, not authored truth.

### 3. `leaderboard-cache.db` = disposable local cache

The leaderboard cache remains non-authoritative, disposable, and excluded from submission payloads.

## Canonical on-disk layout

```text
aerobeat-workouts/
├── workouts.db
└── workouts/
    └── <workout-id>/
        ├── workout.yaml
        ├── songs/
        │   └── <song-id>.yaml
        ├── charts/
        │   └── <chart-id>.yaml
        ├── sets/
        │   └── <set-id>.yaml
        ├── coaches/
        │   └── coach-config.yaml
        ├── environments/
        │   └── <environment-id>.yaml
        ├── media/
        │   ├── audio/
        │   ├── art/
        │   ├── coaching/
        │   └── environments/
        └── cache/
            └── leaderboard-cache.db
```

## Layout rules

1. The package root contains exactly one `workout.yaml`.
2. `songs/`, `charts/`, `sets/`, `coaches/`, and `environments/` are the authored content folders taught in this slice.
3. `coaches/` contains exactly one YAML file for the workout-level coach config domain.
4. Media/resource references should resolve inside the package folder.
5. `cache/` contains only disposable derived data.

## Set composition rule

A `Set` links:

- one `songId`
- one `chartId`
- one `environmentId`
- optional `coachingOverlayId`

The older `assetSelections` package pattern is intentionally removed from the official workout-package contract in this docs pass.

## Environment direction

Environment records remain part of the package concept because they meaningfully shape the workout experience without reopening the older package-asset sprawl.

The locked Environment v1 `type` enum remains:

- `image_background`
- `video_background`
- `glb_environment`
- `splat`

Baseline `godot_scene` should still be treated as an advanced future controlled-pipeline path, not a default loose-package handoff. `splat` is now an official package-facing environment type, but it remains a controlled advanced path: AeroBeat should prefer `.compressed.ply` as the official recommended package payload, while `.ply`, `.splat`, and `.sog` remain compatibility-supported through GDGS. The exported workout still copies the chosen splat payload into `media/environments/` so the package stays self-contained, and the currently validated runtime path is desktop / Forward Plus / compute-bound rather than a broad cross-device guarantee.

## Coaching direction

Coaching stays inside the package's single `coaches/coach-config.yaml` domain.

- disabled coaching may be represented by `enabled: false`
- enabled coaching owns the roster, warmup video, cooldown video, and overlay audio registry
- sets reference enabled overlay clips through `coachingOverlayId`

## Validation expectations

Tooling for this slice should validate:

- the authored YAML records under `workout.yaml`, `songs/`, `charts/`, `sets/`, `coaches/`, and `environments/`
- the checked-in SQL schema files under `sql/`
- package-local id integrity across workout/set/song/chart/environment/coaching references

## Product note on customization

Removing package-local gameplay assets from the workout-package contract does **not** mean AeroBeat is abandoning customization. It means customization should move toward a more controlled product path such as profile-driven avatar and cosmetics unlocks tied to workout progression.
