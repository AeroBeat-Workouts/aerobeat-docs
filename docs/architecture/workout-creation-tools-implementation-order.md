# Workout Creation Tools Implementation Order

## Status: historical / de-scoped

This page is preserved only as a record of an earlier **manual-authored workout-package tool rollout plan**.

It is **not** the current implementation-order source of truth for the default AeroBeat content direction.

## Current truth

The current contract after the song-package rewrite is:

- the canonical imported package root is **`song-package.yaml`**
- imported content defaults to **song packages**, not workout packages
- public/current tooling should prefer song-package naming over workout-root naming
- coaching and environments are outside the default imported song-package contract
- future multi-song grouping should use **playlist** language

## Why this page was de-scoped

The earlier version of this page staged work around assumptions such as:

- package-root authority centered on `workout.yaml`
- `aerobeat-workout` as the package-home CLI/product seam
- coaching/environment-heavy package flows as part of the default package story
- a roadmap whose early milestones taught the retired workout-root worldview

Those assumptions are no longer the active contract.

## How to use this page now

Only use this page as historical context for how an earlier workout-package lane was being phased.

Do **not** use it as a live execution checklist for current repo work.

For current work, prefer implementation planning that:

- validates and authors **`song-package.yaml`**
- keeps the default imported-player path centered on songs, charts, and sets
- avoids reviving workout-root wrappers as visible current truth
- treats coaching and environments as separate/future extension lanes rather than required default package structure

## Related current-truth docs

- [Overview](overview.md)
- [Content Model](content-model.md)
- [Content Repo Shapes](content-repo-shapes.md)
- [UGC Modding](ugc_modding.md)

## Historical retention note

This page remains only to keep historical links working while the docs are converged. It should not drive current implementation sequencing.
