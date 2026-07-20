# Workout Creation Tools Architecture

## Status: historical / de-scoped

This page is preserved only as a record of an **earlier manual-authored workout-package tool concept**.

It is **not** the current default AeroBeat content-authoring contract.

## Current truth

The current contract after the content rewrite is:

- the canonical imported package root is **`song-package.yaml`**
- imported content defaults to **song packages**, not workout packages
- one song package may contain multiple chart/set difficulty slices under a single song root
- future multi-song grouping should use **playlist** language rather than workout-package grouping
- coaching is outside the default imported song-package contract
- environments are outside the default imported song-package contract
- BeatSaver-style difficulty labels are canonical:
  - `Easy`
  - `Normal`
  - `Hard`
  - `Expert`
  - `ExpertPlus`

## Why this page was de-scoped

Earlier drafts here described a product whose package-home truth centered on:

- `workout.yaml`
- workout-level orchestration
- package-default coaching flows
- package-owned environment linkage
- domain seams named around `workout`

That no longer matches the landed contract. Leaving those assumptions described as canonical architecture was teaching the wrong repo truth.

## How to read older tool references

If an older tool doc or sketch still talks about:

- opening on the `workout.yaml` scene
- `aerobeat-workout` as the default canonical package-root CLI
- package-required coaching or environments
- one-difficulty workout packages as the main content shape

read that material as **historical planning residue**, not as implementation guidance for the current contract.

## Current implementation direction instead

For current work, prefer tool flows that align with the landed repos:

- author and validate **`song-package.yaml`**
- use song-package terminology in public/runtime/tool surfaces
- keep imported-package validation centered on songs, charts, and sets
- treat coaching and environments as separate or future extension lanes rather than default imported-package structure
- keep playlist terminology for future multi-song grouping

## Related current-truth docs

- [Overview](overview.md)
- [Content Model](content-model.md)
- [UGC Modding](ugc_modding.md)
- [Content Repo Shapes](content-repo-shapes.md)

## Historical retention note

This page remains in the repo only so old links do not break immediately. It should not be used as a canonical source for new implementation work.
