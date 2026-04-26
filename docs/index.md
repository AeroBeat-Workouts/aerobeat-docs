# Welcome to AeroBeat

**AeroBeat** is an open-source, modular rhythm game platform designed to democratize fitness gaming. Think of it as the "YouTube of Workout Games"—a place where hardware inputs, gameplay mechanics, and community content can be mixed and matched freely.

Unlike traditional rhythm games that are locked to specific hardware (VR headsets or consoles), AeroBeat is **Input Agnostic**. It runs on PC, Mobile, and VR, utilizing Computer Vision (CV) to turn standard webcams into motion controllers.

---

## 🚀 The Vision

We are building a platform, not just a game. Our architecture separates **Input** (How you move), **Logic** (The rules of the game), and **Content** (The music and visuals).

* **Hardware Agnostic:** Play using a Webcam (MediaPipe), VR Controllers, JoyCons, or even a Keyboard.
* **Modular Gameplay:** Swap the "Core Mechanic" instantly. Go from **Boxing** (punching targets) to **Flow** (Beat Saber style movement) without changing the engine.
* **Community First:** Built for modding. Artists can author package-local assets, Musicians can map songs, and Coders can write new input drivers.

---

## 📚 Documentation Structure

Our documentation is divided by role. Choose your path below:

### 🥊 [Game Design (GDD)](gdd/concept.md)

*For Designers and Visionaries.*

* Read about the **Core Loop** and scoring logic.
* Understand the fitness-first approach to difficulty.
* Explore the roadmap for multiplayer and workshop features.
* **Meta:** [Profile](gdd/meta/profile.md), [Preferences](gdd/meta/preferences.md), [Locker Room](gdd/meta/locker_room.md).
* **Economy:** [Currency](gdd/economy/currency.md), [Supporter Perks](gdd/economy/supporter_perks.md).
* **Social:** [Crews](gdd/social/crews.md).
* **Gamification:** [Quests](gdd/gamification/quests.md).

### 🛠️ [Technical Architecture](architecture/overview.md)

*For software engineers and system architects.*

* Understand the **lane-based six-core** topology.
* Learn how the six core repos divide contracts by lane, starting with `aerobeat-input-core`, `aerobeat-feature-core`, `aerobeat-content-core`, `aerobeat-asset-core`, `aerobeat-ui-core`, and `aerobeat-tool-core`.
* Dive into platform concerns such as Cloud Baker, testing strategy, security, and performance.
* Read the new [**Content Model**](architecture/content-model.md) doc for how Songs, Routines, Charts, and Workouts fit together.
* Read [**Workout Package Storage and Discovery**](architecture/workout-package-storage-and-discovery.md) for the locked v1 package contract, including `coaches/coach-config.yaml`, `workouts.db`, the strict v1 `assetType` enum, and the self-contained package rules.
* Read [**Content Repo Shapes**](architecture/content-repo-shapes.md) for the concrete day-one structure of `aerobeat-content-core` and `aerobeat-tool-content-authoring`.
* **Key Tech:** Godot 4.x, GDScript, Python sidecars, and modular package boundaries.

### 🧰 [Guides for Contributors](guides/contributing_workflow.md)

*For contributors who want practical setup and workflow guidance.*

* Start with the **Contributing Workflow** and **Feature Development** guides.
* Read the [**Demo Workout Package Guide**](guides/demo_workout_package.md) if you want one concrete end-to-end package example with linked YAML and SQL files.
* Use the calibration, accessibility, choreography, and content creation guides when working in specialized areas.
* Follow the licensing and contribution docs before publishing shared work.

### 🎨 [Art Overview](gdd/art/overview.md)

*For artists looking to add new art assets.*

* Learn how feature and UI-facing base scenes expose stable runtime contracts for skins, environments, and other asset packages.
* Understand the difference between authored package assets and runtime/distribution artifacts.
* Review licensing expectations for creative contributions.

### 📘 Guides & Legal

* **Development:** Feature Development.
* **Creation:** Cosmetics Guide.
* **Legal:** Refund Policy.

---

## 📂 Repository Ecosystem

AeroBeat uses a polyrepo repository structure to keep code clean and licenses decoupled.

* **Read More Here:** [Topology Documentation](./architecture/topology.md)
* **Template Source Files:** The `templates/` folder in this repo is the source of truth for AeroBeat starter repositories.

---

## 🤝 Contributing

We welcome contributions of all kinds. To ensure you have the best experience, choose the path that matches your skills and goals.

### 👩‍💻 For Software Engineers
*Looking to fix bugs, optimize the engine, or add new features?*

1. Read the **Contributing Workflow** guide.
2. Check the **Architecture Overview** to understand the system.
3. Pick a repository (for example `aerobeat-input-core` or `aerobeat-feature-boxing`) and start coding.

### 🎨 For Engine Artists
*Looking to contribute official UI themes, icons, or core 3D assets to the open-source project?*

1. Review the **Art Overview**.
2. Understand our **Licensing for Creatives**.
3. Join the discussion on our GitHub Discussions or Discord to coordinate with the art direction team.

### 🖌️ For Modders (UGC)
*Looking to create custom gloves, targets, obstacles, trails, environments, coaches, or full workout packages for yourself and the community?*

1. Start from the relevant `aerobeat-template-*` repo or its generated descendant.
2. Author a self-contained workout or asset package using the current YAML/package docs rather than treating `.pck` as the authored source of truth.
3. If a future distribution pipeline emits `.pck` or other runtime bundles, treat those as build artifacts layered on top of the authored package contract.

### 🎵 For Creators (Music & Fitness)
*Are you a composer, choreographer, or coach? You don't need to download the game engine.*

We provide specialized web-based tools for you:

* **Musicians:** Upload tracks and get verified at **www.aerobeat-workouts.com/creators**.
* **Choreographers:** Use the **Choreography Studio** to map songs and workouts.
* **Coaches:** Build optional workout-level coaching content around the package's single `coaches/coach-config.yaml` domain, with all-or-nothing enablement and one overlay audio clip per workout entry when enabled.

> **Current Status:** AeroBeat is currently in **Prototype (v0.0.1)**. We are actively building the six shared core lanes and the initial Boxing feature.

---

*AeroBeat-Workouts &copy; 2026. "Move to the Beat."*
