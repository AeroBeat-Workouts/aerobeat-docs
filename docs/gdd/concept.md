# AeroBeat: Concept Overview

AeroBeat is an open-source **free-to-play** rhythm workout platform with a deliberately narrowed v1: **camera-based Boxing and Flow, shipped to the PC community first**.

Older docs described AeroBeat as broadly gameplay-agnostic, hardware-agnostic, and ready to launch across many devices at once. That is no longer the official v1 product claim. The current product thesis is narrower on purpose so the team can ship a strong, coherent first experience.

## High concept

> **Accessible free-to-play rhythm workouts through a standard camera, with BeatSaver-powered song play on PC.**

AeroBeat still keeps a modular architecture, but the v1 product promise is now specific:

1. **Business model:** free-to-play app with a free core experience
2. **Input:** official gameplay support is camera tracking
3. **Gameplay:** official v1 features are Boxing and Flow
4. **Content:** imported **song packages** with multiple converted charts/difficulties under one song root
5. **Grouping:** future multi-song sessions should be described as **playlists**
6. **Progression:** AeroBeat-owned profile, workout points, and controlled avatar/cosmetics customization

## Product pillars for this slice

### Free-to-play without identity drift

AeroBeat is not just a free download. It is a free-to-play product that needs a clear long-term answer for athlete identity, progression, and workout access.

That means the architecture cannot quietly collapse into vendor-owned identity just because third-party catalog/community services exist. AeroBeat still needs an AeroBeat-owned account architecture as a first-class design concern, even if the full end-user account product is phased.

### Accessibility first through camera play

The first launch should let athletes start with hardware they already own: a laptop or desktop plus a camera. UI navigation may still use mouse on PC and touch on mobile surfaces, but official gameplay support is camera-first.

### Fitness-first choreography

Boxing and Flow are the retained gameplay pillars because they align with the current workout thesis: readable full-body movement, cardio, rhythm, and progression without requiring a controller ecosystem.

### Community-first release order

The release priority is:

1. **PC community first**
2. **mobile second**
3. **VR third**

That order should shape planning language throughout the docs. Mobile and VR remain meaningful future targets, but they are not current parity promises.

### Song packages first, playlists later

The default content model should support:

- one imported **song package** per source song/root
- multiple exact charts/difficulties under that same package
- future **playlists** for grouping many song packages together

The default imported-player path should not drag along manual-authored workout-package baggage such as required package-local coaching or required package-owned environments.

### Modular architecture, scoped promises

AeroBeat still benefits from modular content, input, and feature boundaries. The key change is product truthfulness: future-compatible architecture does **not** mean every feature, device, or platform is official v1 scope.

## Explicitly out of current gameplay scope

- Dance as a gameplay feature
- Step as a gameplay feature
- official non-camera gameplay input support
- portal-era authored chart semantics as default truth
- package-local gameplay asset swapping as a core content concept
- manual-authored one-difficulty workout packages as the default imported-player story

## Still valid but future-facing

- JoyCon, gamepad, keyboard, touch, mouse, and XR input providers
- VR-focused presentation and shells
- broader platform packaging after the PC-first community release
- optional future curated/manual-authored content flows beyond imported song packages

## Content direction

Default imported content should focus on the durable records that matter most for this slice:

- song packages
- songs
- charts
- sets
- playlists

Older package-heavy coaching/environment examples are being retired from the default truth surfaces. Future customization docs should point toward **controlled avatar and cosmetics unlocks via workout points** rather than teaching freeform package-local gameplay asset swaps as the main product path.
