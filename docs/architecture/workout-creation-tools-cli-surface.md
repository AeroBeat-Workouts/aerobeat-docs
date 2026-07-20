# Workout Creation Tools CLI Surface

## Status: historical / de-scoped

This page is preserved only as a record of an earlier **manual-authored workout-package CLI** concept.

It is **not** the current default CLI contract for AeroBeat content work.

## Current truth

The current contract after the song-package rewrite is:

- the canonical imported package root is **`song-package.yaml`**
- public/current tool seams should prefer **song-package** terminology over workout-root terminology
- imported package validation should center on songs, charts, and sets
- coaching and environments are outside the default imported song-package contract
- BeatSaver-style difficulty labels are canonical: `Easy`, `Normal`, `Hard`, `Expert`, `ExpertPlus`

## What this older page got wrong for current use

Older drafts here treated the following as the active default shape:

- `workout.yaml` as the package root
- `aerobeat-workout` as the package-home public CLI
- domain/tool names built around workout-root orchestration
- package-wide validation that assumes package-default coaching and environment records

Those assumptions are no longer current truth.

## How to interpret any surviving workout-named CLI examples

If older examples still mention commands such as:

- `aerobeat-workout validate`
- `aerobeat-workout inspect`
- `aerobeat-workout package`
- `aerobeat-workout import package-shell`

read them as historical examples from the retired workout-package lane, not as canonical names for current tool work.

## Current direction instead

Current and future tooling should prefer surfaces that:

- read/write/validate **`song-package.yaml`**
- use song-package naming in public entrypoints and service seams
- keep legacy workout-root wrappers out of the visible default contract
- keep coaching/environment helpers outside the default imported-package workflow unless a separate extension lane is intentionally documented

## Related current-truth docs

- [Overview](overview.md)
- [Content Model](content-model.md)
- [Content Repo Shapes](content-repo-shapes.md)
- [UGC Modding](ugc_modding.md)

## Historical retention note

This page remains only to keep older cross-links from breaking while the docs converge. Do not use it as current implementation guidance.
