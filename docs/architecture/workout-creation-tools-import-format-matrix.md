# Workout Creation Tools Import Format Matrix

## Status: historical / de-scoped

This page is preserved only as a record of an earlier **manual-authored workout-package import matrix**.

It is **not** the current default import contract for the BeatSaver/song-package direction.

## Current truth

The current contract after the song-package rewrite is:

- the canonical imported package root is **`song-package.yaml`**
- imported content defaults to **song packages** built around songs, charts, and sets
- coaching media is outside the default imported song-package contract
- package-owned environment linkage is outside the default imported song-package contract
- future multi-song grouping should use **playlist** language

## Why this page was de-scoped

The earlier version of this page described import/storage rules for a richer workout-package lane that assumed media slots such as:

- coaching overlay audio
- coaching warm-up / cool-down video
- environment background image/video
- package-owned environment payloads
- workout/package art as part of the same canonical package story

Those details may still matter if AeroBeat later revives a separate authored-package lane, but they are not current truth for the default imported song-package direction.

## Safe reading rule

If you need current implementation guidance for the default imported lane:

- do **not** use this page as the source of truth
- prefer the current content contract and tooling repos instead
- assume coaching/environment-heavy import rules here are historical unless reintroduced in a clearly separate extension doc

## Related current-truth docs

- [Overview](overview.md)
- [Content Model](content-model.md)
- [UGC Modding](ugc_modding.md)
- [BeatSaver to AeroBeat Boxing v1 Conversion](beatsaver-boxing-v1-conversion.md)
- [BeatSaver to AeroBeat Flow v1 Conversion](beatsaver-flow-v1-conversion.md)

## Historical retention note

This page remains only so older references still resolve while the docs settle. It should not be treated as canonical for new imported-content tooling work.
