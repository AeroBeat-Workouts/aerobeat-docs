# Content Model: Song Packages, Songs, Charts, Sets, and Playlists

AeroBeat content is authored and imported as a layered model rather than a single flat chart blob.

## Durable default hierarchy

- **Song Package**
- **Song**
- **Chart**
- **Set**
- **Playlist** (future multi-song grouping)

Default imported-player truth does **not** require package-local coaching or package-local environments.

## Current schema direction

- use consistent `*Id` + `*Name` fields where applicable
- all primary ids are UIDs
- authored YAML records carry shared schema/provenance fields
- `Song Package` is the durable term for one imported source song/root
- `Chart` is the durable term for one concrete playable feature+difficulty slice
- `Set` is the durable linker for one exact song+chart playable selection
- `Playlist` is the durable multi-song grouping concept above song packages
- `Song` records do not link to playlists directly
- athlete/device calibration data does not belong in durable content

## Why AeroBeat still needs `Set`

`Set` remains the durable playable linker between exact song content and exact chart content.

A set owns the exact playable slice:

- `songId`
- `chartId`

That keeps selection explicit without stuffing feature/difficulty semantics into the song record itself.

## Environment direction

Environment choice is now treated as player/system state outside the default imported song package.

That means current imported content docs should **not** teach:

- package-owned environment folders as the default path
- per-set environment requirements for ordinary imported song packages
- environment selection as the center of the BeatSaver-powered import contract

AeroBeat may still support built-in, downloaded, or custom environment packages elsewhere in the product, but those are a sibling system rather than default song-package truth.

## Coaching direction

Coaching is not part of the default imported-player contract.

That means current imported content docs should **not** teach:

- package-local `coaches/coach-config.yaml` as a normal expectation
- warm-up / cool-down / overlay voice assets as default imported content baggage
- all-or-nothing coaching as the baseline imported-player rule

If coaching returns later, it should be documented as an optional extension rather than a structural requirement of every imported package.

## Shared chart envelope

AeroBeat still uses shared chart concepts with feature-specific payload meaning. For the active gameplay docs slice, the important authored/imported features are Boxing and Flow.

- Boxing conversion rules are defined in [BeatSaver to AeroBeat Boxing v1 Conversion](beatsaver-boxing-v1-conversion.md).
- Flow conversion rules are defined in [BeatSaver to AeroBeat Flow v1 Conversion](beatsaver-flow-v1-conversion.md).
- Portal-era chart language is not current contract truth for either feature.

## Customization direction after asset-package removal

The removal of package-local gameplay asset records from the default content story is a product-scope decision, not a statement that visuals never matter. The current customization direction should point toward:

- player profile identity
- avatars
- cosmetics
- controlled unlocks via workout points

That keeps the default song-package contract focused on imported playable content while leaving room for broader account-level customization later.
