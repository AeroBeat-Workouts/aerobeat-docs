# Demo Workout Package Example

This section gives you one complete docs-friendly AeroBeat workout package you can inspect file by file.

The example is intentionally aligned to the current product slice:

- Boxing and Flow only
- coaching retained
- environments retained
- package-local gameplay assets removed from the taught contract

## Start here

- [Demo package README](demo-neon-boxing-bootcamp/README.md)
- [Package root `workout.yaml`](demo-neon-boxing-bootcamp/workout.yaml)
- Songs
- Boxing and Flow charts
- Sets
- [Coach config](demo-neon-boxing-bootcamp/coaches/coach-config.yaml)
- Environment records
- SQL schema examples

## What this example is teaching

- **Chart** is one exact playable slice.
- **Set** is one package-local composition record.
- A package has one `coaches/` folder and one `coach-config.yaml` file.
- Workout sets link songs, charts, environments, and optional coaching overlays by exact ids.
- `workout.yaml` owns package metadata plus `setOrder`, not full set composition inline.
- Local discoverability belongs in `workouts.db`, not package YAML.
- Packages stay self-contained.
- Environment records remain part of the package contract.
- Package-local gameplay asset swapping is no longer part of the official workout-package docs contract.

## Important scope note

The example package still leaves room for later avatar/cosmetics customization at the product level, but it no longer teaches freeform gameplay asset bundles inside workout packages.
