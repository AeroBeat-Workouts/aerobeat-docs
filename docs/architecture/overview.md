# Technical Architecture Overview

**Project:** AeroBeat Platform

**Target Version:** 0.0.1 (Prototype)

**Engine:** Godot 4.x

**Language:** GDScript (Primary), Python (CV Sidecar)

**Organization:** AeroBeat-Workouts

## Executive Summary

AeroBeat is a **Modular Rhythm Platform**. We strictly decouple **Input** (Hardware), **UI** (Platform Interaction), **Logic** (Gameplay), and **Content** (Assets).

## Technical Structure Overview

Our architecture is built on four key pillars designed to maximize modularity and contributor safety.

### 1. Hub-and-Spoke Topology

We do not use a monolithic repository. Instead, we use a **Polyrepo** approach where `aerobeat-core` acts as the central hub containing shared Interfaces (Contracts) and Data Types. Feature repositories (like Boxing or Flow) depend on Core, but never on each other.

### 2. Input Agnosticism (The Provider Pattern)

The game logic never communicates directly with hardware. Instead, it requests normalized data (0.0 - 1.0) from an **Input Provider**. This allows us to hot-swap between a Webcam, VR Controllers, or a Keyboard without changing a single line of gameplay code.

### 3. Atomic UI Design

We separate visual components (Buttons, Cards) from application logic.

*   **UI Kit:** A library of pure, stateless components.
*   **UI Shells:** Platform-specific applications (Mobile, VR) that assemble these components into screens.

### 4. Data-Driven Content

To support community modding safely, we ban scripts in asset packs. All content (Skins, Avatars, Cosmetics, Environments, Songs) are loaded via strict Resource definitions, preventing Remote Code Execution (RCE) from malicious mods.