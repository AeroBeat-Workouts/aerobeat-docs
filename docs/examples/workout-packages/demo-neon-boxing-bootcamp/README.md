# Demo Package: Neon Boxing Bootcamp

`demo-neon-boxing-bootcamp` is the canonical docs example for the current AeroBeat v1 workout package contract.

It is designed for onboarding, code review, validation planning, and tool implementation. A new developer should be able to read the files in this folder and understand:

- what records exist in a package
- how ids connect across files
- which fields belong in package YAML
- which concerns belong in local SQLite databases instead
- how coaching, environments, and assets fit into the same package

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
│   ├── ab-asset-coach-avatar-aria-holo.yaml
│   ├── ab-asset-coach-voice-aria-energetic.yaml
│   ├── ab-asset-gloves-neon-pulse.yaml
│   ├── ab-asset-obstacles-light-walls.yaml
│   ├── ab-asset-targets-holo-rings.yaml
│   └── ab-asset-trails-comet-streak.yaml
└── sql/
    ├── leaderboard-cache.db.schema.sql
    └── workouts.db.schema.sql
```

## Scenario modeled by this package

This example package imagines a short boxing workout with two songs:

1. **Neon Stride** — medium difficulty opener in a rooftop night environment
2. **Midnight Sprint** — harder follow-up in a brighter studio environment

The package uses one shared coach config, one featured coach, two environments, four gameplay-facing asset selections, and two coach support assets.

## Reading order

- Start with [`workout.yaml`](workout.yaml).
- Then follow the ids into [`songs/`](songs/), [`routines/`](routines/), and [`charts/`](charts/).
- After that, read [`coaches/coach-config.yaml`](coaches/coach-config.yaml), [`environments/`](environments/), and [`assets/`](assets/).
- Finish with [`sql/workouts.db.schema.sql`](sql/workouts.db.schema.sql) and [`sql/leaderboard-cache.db.schema.sql`](sql/leaderboard-cache.db.schema.sql).

## Intentional v1 boundaries shown here

- discoverability/search metadata is not authored into `workout.yaml`
- coach avatar/voice assets are referenced from coach config only
- workout entries choose one environment and zero-or-one asset per gameplay-facing asset type
- local install/discovery state lives in `workouts.db`
- local leaderboard snapshots live in the package's disposable cache DB
- no inheritance, patching, remote catalog data, or signing metadata appears in the authored package files
