# Technical Architecture Overview

**Project:** AeroBeat Platform  
**Target Version:** Prototype toward v1  
**Engine:** Godot 4.x  
**Language:** GDScript (Primary), Python (CV Sidecar)

## Executive summary

AeroBeat keeps a modular lane-based architecture, but the active product scope is now intentionally narrower:

- official v1 gameplay features: **Boxing** and **Flow**
- official v1 gameplay input: **camera only**
- release priority: **PC community first**, then **mobile**, then **VR**

The architecture should keep future-compatible seams without overstating current product promises.

## Lane-based polyrepo topology

AeroBeat is documented as six domain-specific lanes:

1. `aerobeat-input-core`
2. `aerobeat-feature-core`
3. `aerobeat-content-core`
4. `aerobeat-asset-core`
5. `aerobeat-ui-core`
6. `aerobeat-tool-core`

That topology remains valid. What changed is scope messaging, not the need for clean boundaries.

## What the current docs should optimize for

### 1. Camera-first gameplay runtime

The near-term runtime should make camera-driven Boxing and Flow excellent on PC rather than spreading equal effort across every possible device/input combination.

### 2. Durable content contracts

The content model should stay centered on reusable authored records:

- Song
- Chart
- Set
- Workout
- Coach Config
- Environment

Package-local gameplay asset records are no longer part of the official workout-package concept for this slice.

### 3. Honest future-facing docs

Future-facing repos and APIs can stay documented when they are genuinely useful, especially for:

- non-camera input providers
- VR shells and presentation
- platform-specific expansion after the first PC release

Those surfaces should be labeled as future-platform or future-input work, not described as present-tense v1 parity.

## Architectural implications of the downscope

- Feature docs and examples should focus on Boxing and Flow.
- Input docs should treat camera as the only official gameplay path.
- Workout package docs should retain environments and coaching while removing package-asset customization as a taught concept.
- Release docs should stop implying simultaneous PC/mobile/VR parity.

## Still-valid future directions

The architecture still leaves room for:

- mobile-native camera gameplay
- VR re-entry
- additional gameplay features beyond Boxing and Flow
- deeper avatar/cosmetics systems

Those are roadmap possibilities, not the baseline promise of the current product docs.
