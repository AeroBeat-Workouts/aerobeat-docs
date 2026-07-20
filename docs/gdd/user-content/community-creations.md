# Community Creations

AeroBeat still aims to support community-facing content, but the current docs slice is explicit about the default **imported-player publishing model**.

## Durable content hierarchy

- **Song Package** → one imported source song/root that may contain multiple playable slices
- **Song** → reusable audio and timing source inside that package
- **Chart** → one concrete playable feature+difficulty slice
- **Set** → exact playable record linking one Song and one Chart
- **Playlist** → future multi-song grouping above song packages

## Community content types kept in this slice

- **Song packages**
- **Songs**
- **Charts / Sets** for Boxing and Flow
- **Playlists** as the future multi-song grouping concept
- **Environments** as a sibling system outside default song packages
- **Customization** as profile/account-level avatar + cosmetics work rather than package-local swaps

## Default imported-player rules

The following rules are the current default direction:

- one song package may contain **multiple charts/difficulties** for the same imported song root
- each chart is still **one exact playable slice**
- multi-song grouping should use **playlists**, not workout-package bundles
- coaching is **not** part of the default imported-player package contract
- environment choice is **outside** the default imported-player package contract
- **all public-facing product truth** should stay aligned to the BeatSaver conversion direction

## Building a playable song package

Creators/tools/importers assemble playable content by choosing:

- gameplay feature: Boxing or Flow
- exact chart difficulty
- exact song + chart pairing through a set
- optional future playlist sequencing above many song packages

## Athlete overrides

Athletes may still want profile-level preferences such as:

- avatar identity
- preferred environment style
- accessibility and comfort settings

Those account-level choices are different from the old package-local gameplay asset swap model.

## What changed

Older docs taught workout packages, package-local coaching, and package-local environments much more aggressively as current truth. That is no longer the default imported-player story.

Future customization direction should instead point toward:

- controlled avatar customization
- cosmetics unlocks
- profile-driven progression using workout points
