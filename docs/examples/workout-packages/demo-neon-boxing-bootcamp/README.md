# Demo Package: Neon Boxing Bootcamp

`demo-neon-boxing-bootcamp` is the canonical docs example for the current AeroBeat v1 workout package contract.

It is designed for onboarding, code review, validation planning, and tool implementation. A new developer should be able to read the files in this folder and understand:

- what records exist in a package
- how ids connect across files
- which fields belong in package YAML versus set YAML
- which concerns belong in local SQLite databases instead
- how the approved coaching model fits into the package
- how one song can be reused by multiple exact playable charts
- how the checked-in Boxing, Flow, and Dance chart examples differ while sharing the same package contract

## Package shape

```text
demo-neon-boxing-bootcamp/
├── README.md
├── workout.yaml
├── songs/
│   ├── ab-song-midnight-sprint.yaml
│   └── ab-song-neon-stride.yaml
├── charts/
│   ├── ab-chart-midnight-sprint-boxing-hard.yaml
│   ├── ab-chart-neon-stride-boxing-medium.yaml
│   ├── ab-chart-neon-stride-dance-medium.yaml
│   └── ab-chart-neon-stride-flow-medium.yaml
├── sets/
│   ├── ab-set-midnight-sprint-finish-round.yaml
│   ├── ab-set-neon-stride-flow-round.yaml
│   └── ab-set-neon-stride-opening-round.yaml
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

This example package imagines a short mixed-feature workout with two songs and three exact playable sets:

1. **Neon Stride Opening Round** — medium Boxing opener in a rooftop night environment
2. **Neon Stride Flow Round** — medium Flow follow-up that reuses the same song with a different chart
3. **Midnight Sprint Finish Round** — harder Boxing finisher in a brighter studio environment

The package uses one shared coach config, a two-coach roster, two environments, four gameplay-facing asset selections, one warmup video, one cooldown video, and one overlay audio clip selected by each set. It also includes an extra checked-in Dance chart example for the same `Neon Stride` song so the docs package can teach the approved Dance contract without broadening the composed workout walkthrough. Every authored YAML record in the enabled example also carries the shared schema/provenance fields; the only deliberate exception path in this contract is a disabled `coach-config.yaml` sentinel of just `enabled: false`.

## Reading order

- Start with [`workout.yaml`](workout.yaml).
- Then follow the ordered set ids into `sets/`.
- From each set, follow the ids into `songs/`, `charts/`, `environments/`, `assets/`, and `coaches/coach-config.yaml`.
- Compare the two `Neon Stride` sets to see how one song can drive both Boxing and Flow chart slices without changing the package contract, then inspect the standalone `ab-chart-neon-stride-dance-medium.yaml` example to see the approved Dance row shape on that same shared chart envelope.
- Finish with [`sql/workouts.db.schema.sql`](sql/workouts.db.schema.sql) and [`sql/leaderboard-cache.db.schema.sql`](sql/leaderboard-cache.db.schema.sql).

## Intentional v1 boundaries shown here

- discoverability/search metadata is not authored into `workout.yaml`
- `workout.yaml` owns package metadata plus `setOrder`, not the full composition payload inline
- `sets/*.yaml` are the single source of truth for song/chart/environment/asset/coaching-overlay links
- song licensing uses the locked `licenseType` enum plus `streamingSafe` and `aiAssisted` booleans
- the demo song records keep `audio.previewStartMs`, boolean `metadata.explicit`, BCP 47 `metadata.language`, and locked-enum `metadata.genres`
- the demo song records now own canonical timing truth through `timing.anchorMs`, `timing.tempoSegments`, `timing.stopSegments`, and `timing.timeSignatureSegments`
- `timing.bpm`, `timing.beatGrid.resolution`, `timing.beatGrid.anchors`, song-level `usageRights`, and freeform `tags` are intentionally absent from this slice
- coaching stays inside the package's single `coaches/coach-config.yaml` file
- warmup/cooldown references live in coach-config under the approved coaching model
- each workout set maps to one overlay audio record through `coachingOverlayId`
- the checked-in chart examples now show the locked flattened Boxing, Flow, and Dance `beats:` contracts
- the Flow example demonstrates explicit `portal`, `placement`, optional `direction`, and inherited `direction = placement` on supported beat families
- the Dance example demonstrates the approved minimal row shape: required `start` + `type`, optional inclusive `end`, and optional `gold`
- workout sets choose one environment and zero-or-one asset per gameplay-facing asset type
- shared browse/discovery rows live in the catalog core tables, while local install-only state lives in `workout_local`
- local leaderboard snapshots live in the package's disposable cache DB
- no inheritance, patching, remote-only catalog companion fields, trigger graphs, or signing metadata appears in the authored package files

## Validation note

The `media/` tree in this docs example contains tiny placeholder files so file-existence validation examples have something real to point at. They are stand-ins for real package media, not production assets.
