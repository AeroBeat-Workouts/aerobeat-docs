# Content Repo Shapes: current contract notes

This page is retained as a **repo-shape reference**, but the older workout-centered examples are retired.

## Status

**Do not treat the pre-song-package examples from earlier versions of this page as current architecture.**

The current durable truth after the contract rewrite is:

- `aerobeat-content-core` owns the durable content language for the **song-package** direction
- the canonical imported package root is **`song-package.yaml`**, not `workout.yaml`
- multi-difficulty content lives under one song package via referenced chart/set slices
- coaching and environments are **not** part of the default imported song-package contract
- future multi-song grouping should use **playlist** language instead of reviving workout-package bundles as the default imported-player noun
- BeatSaver-style difficulty labels are now canonical:
  - `Easy`
  - `Normal`
  - `Hard`
  - `Expert`
  - `ExpertPlus`

## What changed from the older draft

The earlier version of this page described repo shapes around contracts such as:

- `Workout`
- `workout_resolution`
- `workout.yaml`
- example fixtures like `song-demo-boxing-medium.json`
- tool/service seams named around `workout_authoring_service`

Those were useful during an earlier architecture phase, but they no longer match the landed contract. Treat them as historical planning residue, not active repo truth.

## Current repo-shape guidance

### `aerobeat-content-core`

Current default ownership should be read as:

- canonical song-package records and validation
- `Song`, `Chart`, `Set`, and supporting package/manifest contracts
- shared schema/version/constants
- shared structural validators and fixtures
- canonical difficulty vocabulary and feature vocabulary
- chart-envelope / event validation rules

Current default ownership should **not** be read as:

- default workout-root orchestration
- `workout_resolution` as a current shared seam
- `workout.yaml` as the canonical package-home contract
- package-required coaching/environment linkage for imported song packages

### `aerobeat-tool-content-authoring`

Current default ownership should be read as:

- song-package authoring workflows
- package validation, migration, packaging, and import helpers
- visible tool/runtime entrypoints named around **song packages**, not workouts
- shared services that produce/consume canonical `song-package.yaml` content

Current default ownership should **not** be read as:

- a tool whose public current truth centers on workout-era wrappers
- `boxing-medium` fixture naming as the active difficulty vocabulary
- `workout.yaml` bootstrap/validation/package flows as canonical default behavior

## Safe interpretation rule for older references

If another older page, diagram, or filename example disagrees with the bullets above:

1. trust the current song-package contract first
2. treat workout-root examples as historical unless explicitly marked as a still-supported compatibility seam
3. prefer the currently validated repos over stale architecture prose

## Related current-truth docs

- [Overview](overview.md)
- [Content Model](content-model.md)
- [UGC Modding](ugc_modding.md)
- [BeatSaver to AeroBeat Boxing v1 Conversion](beatsaver-boxing-v1-conversion.md)
- [BeatSaver to AeroBeat Flow v1 Conversion](beatsaver-flow-v1-conversion.md)

## Historical note

This page intentionally stops short of re-documenting the full old workout-centered repo trees. Keeping those trees here as if they were still authoritative was causing audit confusion after the song-package rewrite. If a future historical appendix is needed, it should be explicitly labeled historical rather than mixed into current architecture guidance.
