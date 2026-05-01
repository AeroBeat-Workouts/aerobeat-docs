# AeroBeat: Concept Overview

AeroBeat is an open-source rhythm workout platform with a deliberately narrowed v1: **camera-based Boxing and Flow, shipped to the PC community first**.

Older docs described AeroBeat as broadly gameplay-agnostic, hardware-agnostic, and ready to launch across many devices at once. That is no longer the official v1 product claim. The current product thesis is narrower on purpose so the team can ship a strong, coherent first experience.

## High concept

> **Accessible rhythm workouts through a standard camera, with community-first content on PC.**

AeroBeat still keeps a modular architecture, but the v1 product promise is now specific:

1. **Input:** official gameplay support is camera tracking
2. **Gameplay:** official v1 features are Boxing and Flow
3. **Content:** community-authored songs, charts, sets, workouts, coaching, and environments
4. **Progression:** profile, workout points, and controlled avatar/cosmetics customization

## Product pillars for this slice

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

### Modular architecture, scoped promises

AeroBeat still benefits from modular content, input, and feature boundaries. The key change is marketing and product truthfulness: future-compatible architecture does **not** mean every feature, device, or platform is official v1 scope.

## Explicitly out of current gameplay scope

- Dance as a gameplay feature
- Step as a gameplay feature
- official non-camera gameplay input support
- package-local gameplay asset swapping as a core workout-package concept

## Still valid but future-facing

- JoyCon, gamepad, keyboard, touch, mouse, and XR input providers
- VR-focused presentation and shells
- broader platform packaging after the PC-first community release

## Content direction

Workout packages should focus on the durable authored content that matters most for this slice:

- songs
- charts
- sets
- workouts
- coaching
- environments

Older package-asset customization examples are being retired. Future customization docs should point toward **controlled avatar and cosmetics unlocks via workout points** rather than teaching freeform package-local gameplay asset swaps as the main product path.
