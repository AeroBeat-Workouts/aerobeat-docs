# Technical Architecture Overview

**Project:** AeroBeat Platform  
**Target Version:** Prototype toward v1  
**Engine:** Godot 4.x  
**Language:** GDScript (Primary), Python/CV sidecar where still needed

## Executive summary

AeroBeat keeps a modular lane-based architecture, but the active product scope is now intentionally narrower:

- official v1 gameplay features: **Boxing** and **Flow**
- official v1 gameplay input: **camera only**
- release priority: **PC community first**, then **mobile**, then **VR**
- default content direction: **BeatSaver-powered song import/conversion**

The architecture should keep future-compatible seams without overstating current product promises.

## Lane-based polyrepo topology

AeroBeat is documented as six domain-specific lanes:

1. `aerobeat-input-core`
2. `aerobeat-feature-core`
3. `aerobeat-content-core`
4. `aerobeat-asset-core`
5. `aerobeat-ui-core`
6. `aerobeat-tool-core`

That topology remains valid. What changed is scope messaging and default content truth, not the need for clean boundaries.

## What the current docs should optimize for

### 1. Camera-first gameplay runtime

The near-term runtime should make camera-driven Boxing and Flow excellent on PC rather than spreading equal effort across every possible device/input combination.

### 2. Durable imported content contracts

The default imported-player content model should stay centered on:

- **Song Package** — one imported source song/root
- **Song** — reusable audio + metadata record inside that package
- **Chart** — one exact playable feature+difficulty slice
- **Set** — one exact song+chart playable selection
- **Playlist** — future multi-song grouping above song packages

Environment selection is outside the default song package. Coaching is not part of the default imported-player contract.

### 3. Honest future-facing docs

Future-facing repos and APIs can stay documented when they are genuinely useful, especially for:

- non-camera input providers
- VR shells and presentation
- curated/manual-authored content workflows if they later return in a bounded form
- platform-specific expansion after the first PC release

Those surfaces should be labeled as future-platform, future-input, or historical work, not described as present-tense v1 parity.

## Architectural implications of the current direction

- Feature docs and examples should focus on Boxing and Flow.
- Input docs should treat camera as the only official gameplay path.
- Imported content docs should teach song packages with multiple difficulties under one song root.
- Multi-song grouping docs should use **playlist** language instead of teaching workout-package bundles as default truth.
- Environment docs should stop assuming every imported package owns environments.
- Coaching docs should stop assuming every imported package carries warm-up/cool-down/overlay baggage.
- Release docs should stop implying simultaneous PC/mobile/VR parity.

## Still-valid future directions

The architecture still leaves room for:

- mobile-native camera gameplay
- VR re-entry
- additional gameplay features beyond Boxing and Flow
- deeper avatar/cosmetics systems
- optional future curated/manual-authored content lanes

Those are roadmap possibilities, not the baseline promise of the current product docs.
