# Welcome to AeroBeat

**AeroBeat** is an open-source, modular rhythm game platform designed to democratize fitness gaming. Think of it as the "YouTube of Workout Games"—a place where hardware inputs, gameplay mechanics, and community content can be mixed and matched freely.

Unlike traditional rhythm games that are locked to specific hardware (VR headsets or consoles), AeroBeat is **Input Agnostic**. It runs on PC, Mobile, and VR, utilizing Computer Vision (CV) to turn standard webcams into motion controllers.

---

## 🚀 The Vision

We are building a platform, not just a game. Our architecture separates **Input** (How you move), **Logic** (The rules of the game), and **Content** (The music and visuals).

* **Hardware Agnostic:** Play using a Webcam (MediaPipe), VR Controllers, JoyCons, or even a Keyboard.
* **Modular Gameplay:** Swap the "Core Mechanic" instantly. Go from **Boxing** (punching targets) to **Flow** (Beat Saber style movement) without changing the engine.
* **Community First:** Built for modding. Artists can skin targets, Musicians can map songs, and Coders can write new input drivers.

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

* Understand the **Hub-and-Spoke Polyrepo** topology.
* Learn how `aerobeat-core` manages contracts between modules.
* Dive into platform concerns such as Cloud Baker, testing strategy, security, and performance.
* **Key Tech:** Godot 4.x, GDScript, Python sidecars, and modular package boundaries.

### 🧰 [Guides for Contributors](guides/contributing_workflow.md)

*For contributors who want practical setup and workflow guidance.*

* Start with the **Contributing Workflow** and **Feature Development** guides.
* Use the calibration, accessibility, choreography, and content creation guides when working in specialized areas.
* Follow the licensing and contribution docs before publishing shared work.

### 🎨 [Art Overview](gdd/art/overview.md)

*For artists looking to add new art assets.*

* Learn how to inherit from `base_target.tscn` to create skins.
* Understand the **Single-Dependency Rule** for asset packages.
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
3. Pick a repository (for example `aerobeat-core` or `aerobeat-feature-boxing`) and start coding.

### 🎨 For Engine Artists
*Looking to contribute official UI themes, icons, or core 3D assets to the open-source project?*

1. Review the **Art Overview**.
2. Understand our **Licensing for Creatives**.
3. Join the discussion on our GitHub Discussions or Discord to coordinate with the art direction team.

### 🖌️ For Modders (UGC)
*Looking to create custom Boxing Gloves, Targets, or Environments for yourself and the community?*

1. Download the **Skins SDK**, **Avatars SDK**, or **Environment SDK**.
2. Learn how to pack your assets into `.pck` files.
3. Upload your creations to the community hub.

### 🎵 For Creators (Music & Fitness)
*Are you a composer, choreographer, or coach? You don't need to download the game engine.*

We provide specialized web-based tools for you:

* **Musicians:** Upload tracks and get verified at **www.aerobeat-workouts.com/creators**.
* **Choreographers:** Use the **Choreography Studio** to map songs.
* **Coaches:** Create workout playlists and voice-overs in the **Coaching Studio**.

> **Current Status:** AeroBeat is currently in **Prototype (v0.0.1)**. We are actively building the core contracts and the initial Boxing feature.

---

*AeroBeat-Workouts &copy; 2026. "Move to the Beat."*
