# Technical Architecture Overview

**Project:** AeroBeat Platform

**Target Version:** 0.0.1 (Prototype)

**Engine:** Godot 4.x

**Language:** GDScript (Primary), Python (CV Sidecar)

**Organization:** AeroBeat-Workouts

## Executive Summary

AeroBeat is a modular rhythm platform. We strictly decouple **Input**, **Feature Runtime**, **Content**, **Assets**, **UI**, and **Tools**.

The platform is documented as a lane-based polyrepo architecture with six domain-specific core repos:

1. [`aerobeat-input-core`](https://github.com/AeroBeat-Workouts/aerobeat-input-core)
2. [`aerobeat-feature-core`](https://github.com/AeroBeat-Workouts/aerobeat-feature-core)
3. [`aerobeat-content-core`](https://github.com/AeroBeat-Workouts/aerobeat-content-core)
4. [`aerobeat-asset-core`](https://github.com/AeroBeat-Workouts/aerobeat-asset-core)
5. [`aerobeat-ui-core`](https://github.com/AeroBeat-Workouts/aerobeat-ui-core)
6. [`aerobeat-tool-core`](https://github.com/AeroBeat-Workouts/aerobeat-tool-core)

AeroBeat no longer treats `aerobeat-core` as the long-term universal hub. The former shared input-facing core now lives at `aerobeat-input-core`, and each lane owns its own shared contracts so concrete repos depend only on the lanes they actually consume.

## Technical Structure Overview

Our architecture is built on four key pillars designed to maximize modularity and contributor safety.

### 1. Lane-based polyrepo topology

AeroBeat does not use a monolithic repository or a universal shared hub. Instead, each domain has one explicit core repo that owns that lane's stable contracts.

- **Input core** owns provider abstractions and normalized input-facing contracts.
- **Feature core** owns gameplay-mode/runtime rules that interpret athlete actions against authored content over time.
- **Content core** owns durable authored-content contracts.
- **Asset core** owns avatars, cosmetics, environments, and other asset-side definitions.
- **UI core** owns shared UI abstractions.
- **Tool core** owns shared tool-side contracts.

Assembly repos such as `aerobeat-assembly-community` compose only the core repos and concrete packages they need through GodotEnv.

### 2. Input agnosticism (the provider pattern)

Gameplay code never talks directly to hardware. It depends on normalized input contracts from `aerobeat-input-core`, allowing AeroBeat to swap between webcam tracking, XR controllers, JoyCons, keyboard, touch, or other providers without rewriting feature logic.

### 3. Feature consumes content; it does not own content

Feature means gameplay-mode/runtime rules that interpret authored content against athlete actions over time. That work belongs in `aerobeat-feature-core` and concrete `aerobeat-feature-*` repos.

The durable content model belongs in `aerobeat-content-core`.

For playable fitness content, AeroBeat uses a layered model:

- **Song:** Reusable audio and timing source.
- **Routine:** Gameplay-mode-specific package for one song.
- **Chart Variant:** One concrete playable difficulty / compatibility slice.
- **Workout:** A program that assembles selections into a session.

Charts share a common envelope for ids, timing, scoring, presentation hints, and metadata, while the event payload remains mode-specific. This preserves input agnosticism without forcing Boxing, Dance, Step, and Flow into a fake one-size-fits-all event schema.

### 4. Data-driven content and asset safety

To support community modding safely, AeroBeat bans executable scripts in community asset packs. All content and assets load through strict resource definitions and validation contracts.

Asset-side contracts such as avatars, cosmetics, environments, and related reusable asset definitions belong in `aerobeat-asset-core`. Feature repos may consume those definitions, but they do not own them.
