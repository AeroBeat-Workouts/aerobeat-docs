# Demo Package: Neon Boxing Bootcamp

`demo-neon-boxing-bootcamp` is the canonical docs example for the current AeroBeat v1 workout package contract.

It is designed for onboarding, code review, validation planning, and tool implementation. A new developer should be able to read the files in this folder and understand:

- what records exist in a package
- how ids connect across files
- which fields belong in package YAML
- which concerns belong in local SQLite databases instead
- how the approved coaching model fits into the package

## Package shape

```text
demo-neon-boxing-bootcamp/
├── README.md
├── workout.yaml
├── songs/
│   ├── ab-song-midnight-sprint.yaml
│   └── ab-song-neon-stride.yaml
├── routines/
│   ├── ab-routine-midnight-sprint-boxing.yaml
│   └── ab-routine-neon-stride-boxing.yaml
├── charts/
│   ├── ab-chart-midnight-sprint-boxing-hard.yaml
│   └── ab-chart-neon-stride-boxing-medium.yaml
├── coaches/
│   └── coach-config.yaml
├── environments/
│   ├── ab-environment-neon-rooftop.yaml
│   └── ab-environment-sunrise-studio.yaml
├── assets/
│   ├── ab-asset-gloves-neon-pulse.yaml
│   ├── ab-asset-obstacles-light-walls.yaml
│   ├── ab-asset-targets-holo-rings.yaml
│   └── ab-asset-trails-comet-streak.yaml
├── media/
│   ├── art/
│   ├── assets/
│   ├── audio/
│   ├── coaching/
│   └── scenes/
└── sql/
    ├── leaderboard-cache.db.schema.sql
    └── workouts.db.schema.sql
```

## Scenario modeled by this package

This example package imagines a short boxing workout with two songs:

1. **Neon Stride** — medium difficulty opener in a rooftop night environment
2. **Midnight Sprint** — harder follow-up in a brighter studio environment

The package uses one shared coach config, a two-coach roster, two environments, four gameplay-facing asset selections, one warmup video, one cooldown video, and one overlay audio clip per workout entry.

## Reading order

- Start with [`workout.yaml`](workout.yaml).
- Then follow the ids into `songs/`, `routines/`, and `charts/`.
- After that, read [`coaches/coach-config.yaml`](coaches/coach-config.yaml), then inspect `environments/` and `assets/`.
- Finish with [`sql/workouts.db.schema.sql`](sql/workouts.db.schema.sql) and [`sql/leaderboard-cache.db.schema.sql`](sql/leaderboard-cache.db.schema.sql).

## Intentional v1 boundaries shown here

- discoverability/search metadata is not authored into `workout.yaml`
- coaching stays inside the package's single `coaches/coach-config.yaml` file
- warmup/cooldown references live in coach-config under the approved coaching model
- each workout entry maps to exactly one overlay audio clip through coach-config `entryId` references
- workout entries choose one environment and zero-or-one asset per gameplay-facing asset type
- local install/discovery state lives in `workouts.db`
- local leaderboard snapshots live in the package's disposable cache DB
- no inheritance, patching, remote catalog data, trigger graphs, or signing metadata appears in the authored package files

## Validation note

The `media/` tree in this docs example contains tiny placeholder files so file-existence validation examples have something real to point at. They are stand-ins for real package media, not production assets.
