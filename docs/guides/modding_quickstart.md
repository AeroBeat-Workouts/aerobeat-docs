# Creator Quickstart Guide

Welcome to the AeroBeat creator/importer community.

## Before you start

Read the current canonical conversion and content-contract docs first:

- [BeatSaver to AeroBeat Flow v1 Conversion](../architecture/beatsaver-flow-v1-conversion.md)
- [BeatSaver to AeroBeat Boxing v1 Conversion](../architecture/beatsaver-boxing-v1-conversion.md)
- [Content Model](../architecture/content-model.md)
- [User Content Overview](../gdd/user-content/overview.md)

Those pages describe the active direction:

- imported **song packages**
- multiple charts/difficulties under one song root
- **playlists** for future multi-song grouping
- environments outside song packages by default
- no default coaching/portal baggage in the imported-player contract

## Creator lanes in this slice

- importers/converters turn source maps into AeroBeat song packages
- choreographers refine Boxing and Flow chart behavior where needed
- tool authors improve conversion, validation, inspection, and packaging workflows
- environment authors work in sibling environment systems rather than inside every imported song package by default

## Current sanity checklist

Before presenting a docs change or implementation as current truth, make sure that:

- the package is described as a **song package**, not a one-difficulty workout package
- multiple charts/difficulties are allowed under one imported song root
- multi-song grouping uses **playlist** language
- environment choice is not taught as package-owned default truth
- coaching is not taught as required default imported-package truth
- the docs stay aligned with the canonical BeatSaver conversion pages

## Customization note

Older docs talked much more heavily about package-local gameplay skins/assets. That is no longer the main content story in this slice. Future customization is more likely to live in controlled avatar/cosmetics systems tied to progression.
