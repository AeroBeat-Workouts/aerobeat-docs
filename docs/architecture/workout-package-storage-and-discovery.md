# Workout Package Storage and Discovery

!!! warning "Historical / retired architecture note"
    This page is preserved only as a record of an **older manual-authored workout-package lane**.
    It is **not** current AeroBeat package, discovery, or runtime truth.

    For current truth, use these pages instead:

    - [Architecture Overview](overview.md)
    - [Content Model](content-model.md)
    - [Content Repo Shapes (Current Contract Notes)](content-repo-shapes.md)
    - [UGC Distribution Strategy](ugc-distribution-strategy.md)
    - [BeatSaver to Boxing v1 Conversion](beatsaver-boxing-v1-conversion.md)
    - [BeatSaver to Flow v1 Conversion](beatsaver-flow-v1-conversion.md)

## Why this page was retired

This document originally described a richer **manual-authored workout-package** lane built around:

- `workout.yaml` as the package root
- `workouts.db` as a local discovery index
- package-local coaching configuration
- package-owned environments
- workout-ordered `setId` composition

That lane is no longer AeroBeat's current canonical direction.

Derrick's locked direction for current repo truth is now:

- imported/default content is centered on **`song-package.yaml`**
- one song package can contain multiple exact chart/difficulty slices under one song root
- future multi-song grouping should be described as **playlists**, not workouts
- coaching is **outside** the default imported song-package contract
- environments are handled **outside** the default imported song-package contract
- retired workout-era package semantics should not be taught as live architecture guidance

## What this page still preserves

This page now exists only to explain the shape of the **retired** lane so older notes, file names, and planning packets remain intelligible during archaeology.

Historically, that lane assumed:

- self-contained package folders
- durable authored YAML
- `workout.yaml` as the root record
- `sets/` as workout composition inputs
- optional package-local coaching media/config
- package-local environment records
- a derived `workouts.db` for browsing/indexing

Those details are historical only. They should **not** be used for new implementation, validation, tooling, or docs truth.

## Historical package layout that was once proposed

```text
aerobeat-workouts/
├── workouts.db
└── workouts/
    └── <workout-id>/
        ├── workout.yaml
        ├── songs/
        ├── charts/
        ├── sets/
        ├── coaches/
        ├── environments/
        ├── media/
        └── cache/
            └── leaderboard-cache.db
```

Again: this layout is a **retired reference**, not a current contract.

## Current replacement direction at a glance

For the current imported-player/default lane:

- the canonical imported package root is **`song-package.yaml`**
- chart difficulty vocabulary follows BeatSaver-style labels such as `Easy`, `Normal`, `Hard`, `Expert`, and `ExpertPlus`
- packages focus on songs, charts, and sets
- coaching and environment ownership are not part of the default song-package contract
- discovery/distribution should be discussed in terms of AeroBeat-controlled validation/trust plus the current UGC/distribution docs, not the retired `workouts.db` lane

## If you touch adjacent docs

When older docs still reference this page, treat that as a sign the surrounding text may also be historical or needs de-scoping. Prefer linking readers to the current song-package / playlist / imported-player pages listed above.
