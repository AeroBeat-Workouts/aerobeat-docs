# UGC & Modding Architecture

This page exists mostly to prevent stale mod-loader or workout-package assumptions from re-entering the docs.

## Current truth

For the current docs slice, AeroBeat's default creator-facing/imported content contract is:

- **BeatSaver-powered song packages** for imported playable content
- **playlists** for future multi-song grouping above those song packages

Use these as the canonical sources of truth:

- [BeatSaver to AeroBeat Flow v1 Conversion](beatsaver-flow-v1-conversion.md)
- [BeatSaver to AeroBeat Boxing v1 Conversion](beatsaver-boxing-v1-conversion.md)
- [Content Model](content-model.md)
- [User Content Overview](../gdd/user-content/overview.md)
- [Community Creations](../gdd/user-content/community-creations.md)

## What is not current truth

Do **not** describe AeroBeat's public creator story as any of the following unless a future architecture decision explicitly restores them:

- public `.pck` mod packs as the main creator workflow
- `AeroModManifest` or `manifest.tres` as the public package contract
- startup scanning of `res://mods/*` as the canonical discovery model
- arbitrary runtime code or gameplay-asset swap packs as equal-status public UGC
- manual-authored one-difficulty workout packages as the default imported-player contract
- package-required coaching or package-owned environment selection as the default imported-player story

Those were older ideas or narrower side lanes. They are not the present-tense docs contract.

## Current creator lanes

### Default lane: imported song packages

The active lane currently centers on imported content packages such as:

- one source song root
- multiple converted Boxing and/or Flow charts
- multiple exact playable difficulty slices under that same song package
- source provenance and normalized local playback artifacts

### Future grouping lane: playlists

If AeroBeat groups many songs into one athlete-facing sequence, that grouping should be described as a **playlist**.

Do not collapse playlist language back into the older workout-package noun as default truth.

### Separate lane: customization

Avatar and cosmetics work may exist as product customization, but that is **not** the same thing as the song-package import/play contract.

If you mention customization in docs, frame it as:

- controlled/profile-driven customization
- curated or product-owned unlocks
- a future-expanding system with its own contract

not as proof that AeroBeat currently ships a broad public mod-loader.

## Internal packages are not public UGC packages

AeroBeat's internal repo/dependency architecture is a different layer:

- **GodotEnv/addon packages** explain repo composition and engine/runtime dependencies
- **song packages** explain imported gameplay content
- **playlists** explain future multi-song athlete grouping

Do not merge those layers into one vague "package" or "mod" story.

## Bottom line

If another page needs a short rule, use this one:

- **Imported song packages are the current default content path.**
- **Playlists are the future multi-song grouping noun.**
- **Customization is separate from song-package authoring.**
- **Do not reintroduce manifest-era public mod-loader truth by accident.**
