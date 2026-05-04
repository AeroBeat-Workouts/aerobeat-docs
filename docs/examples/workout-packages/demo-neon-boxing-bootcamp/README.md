# Demo Package: Neon Boxing Bootcamp

`demo-neon-boxing-bootcamp` is the canonical docs example for the current AeroBeat workout-package contract.

It is intentionally aligned to the narrowed product slice:

- official gameplay features in the example are **Boxing** and **Flow**
- package-local **environments** remain in scope
- package-local gameplay **assets** are no longer part of the taught contract

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
├── media/
│   ├── art/
│   ├── audio/
│   ├── coaching/
│   └── environments/
└── sql/
    ├── leaderboard-cache.db.schema.sql
    └── workouts.db.schema.sql
```

## Scenario modeled by this package

This package imagines a short three-set workout:

1. **Neon Stride Opening Round** — medium Boxing opener
2. **Neon Stride Flow Round** — medium Flow follow-up reusing the same song
3. **Midnight Sprint Finish Round** — harder Boxing finisher

It uses one shared coach config, two environments, one warmup video, one cooldown video, and overlay audio cues selected per set.

## Reading order

- Start with [`workout.yaml`](workout.yaml).
- Follow the set ids into `sets/`.
- From each set, follow ids into `songs/`, `charts/`, `environments/`, and `coaches/coach-config.yaml`.
- Finish with the SQL schema examples.

## Intentional boundaries shown here

- `workout.yaml` owns package metadata plus `setOrder`
- `sets/*.yaml` are the single source of truth for song/chart/environment/coaching links
- coaching stays inside the package's single `coaches/coach-config.yaml`
- workout sets choose exactly one environment
- the docs example no longer teaches package-local gameplay asset selection

## Boxing / Flow contract notes

- Boxing straight punches use `punch_left` / `punch_right` in the example charts.
- `guard` is the canonical guard wording.
- `orthodox` / `southpaw` remain authored chart semantics and should not be read as tracked input events.
- Flow keeps `placement` and `direction` separate: `placement` is where the beat passes, while `direction` guides follow-through.

## Validation note

Use [`aerobeat-tool-content-authoring`](https://github.com/AeroBeat-Workouts/aerobeat-tool-content-authoring) to validate this package. This repo is the fixture and explanation layer.
