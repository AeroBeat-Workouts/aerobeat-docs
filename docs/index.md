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

* Read the about **Core Loop** and Scoring Logic.
* Understand the "Fitness-First" approach to difficulty.
* Explore the roadmap for Multiplayer and Workshop features.
* **Meta:** [Profile](gdd/meta/profile.md), [Preferences](gdd/meta/preferences.md), [Locker Room](gdd/meta/locker_room.md).
* **Economy:** [Currency](gdd/economy/currency.md), [Supporter Perks](gdd/economy/supporter_perks.md).
* **Social:** [Crews](gdd/social/crews.md).
* **Gamification:** [Quests](gdd/gamification/quests.md).

### 🛠️ [Technical Architecture](architecture/overview.md)

*For Software Engineers and System Architects.*

* Understand the **Hub-and-Spoke Polyrepo** topology.
* Learn how `aerobeat-core` manages contracts between modules.
* Dive into the **Session Context** dependency injection system.
* **Deep Dives:** Cloud Baker, Performance.
* **Key Tech:** Godot 4.x, GDScript, MediaPipe.

### 🤖 [AI-Assisted Workflow](ai-prompting/overview.md)

*For Developers using LLMs.*

* **New to the team? Start here.**
* Learn how to use our **Context Anchors** (`AI_MANIFEST`, `STYLE_GUIDE`) to get high-quality code from AI agents.
* Copy our standard **System Prompt** for consistency.

### 🎨 [Art Overview](gdd/art/overview.md)

*For Artists looking to add new art assets*

* How to inherit from `base_target.tscn` to create skins.
* Understanding the **Single-Dependency Rule** for Asset Packages.
* Licensing guide for **CC BY-NC 4.0** contributions.

### 📘 Guides & Legal

* **Development:** Feature Development.
* **Creation:** Cosmetics Guide.
* **Legal:** Refund Policy.

---

## 📂 Repository Ecosystem

AeroBeat uses a 15-tier repository structure to keep code clean and decoupled.

| Tier | Repo Name | Role | Required Deps | Allowed Deps | Dev-Only / Peer Deps | License |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **Assembly** | `aerobeat-assembly-*` | **The Product.** Specific editions (Community, Arcade). | All Active Packages | All Assets | Test Frameworks (Gut) | **GPLv3** |
| **Core** | `aerobeat-core` | **The Hub.** Interfaces, Data Types, Global Constants. | **None** | **None** | Unit Test Tools | **MPL 2.0** |
| **UI Core** | `aerobeat-ui-core` | **UI Logic.** Base classes (ViewModel) for components. | `aerobeat-core` | **None** | Unit Test Tools | **MPL 2.0** |
| **Tool** | `aerobeat-tool-*` | **Services.** Singleton Managers (ex: APIs, Analytics). | `aerobeat-core` | Vendor Utils | Testbed Scaffolding | **MPL 2.0** |
| **Input** | `aerobeat-input-*` | **Hardware Drivers.** (Camera, VR, Watch). | `aerobeat-core` | Vendor SDKs | Testbed Scaffolding | **MPL 2.0** |
| **UI Kit** | `aerobeat-ui-kit-*` | **Visual Library.** Themed scenes inheriting UI Core logic. | `aerobeat-ui-core` | `aerobeat-asset-common` | Testbed Scaffolding | **MPL 2.0** |
| **UI Shell** | `aerobeat-ui-shell-*` | **Interaction Layer.** Platform-specific screens. | `aerobeat-ui-kit-*` | `aerobeat-asset-common`<br>(Local Assets) | Vendor Tools (Tweeners)<br>Mock Data | **GPLv3** |
| **Feature** | `aerobeat-feature-*` | **Gameplay Logic.** Mechanics & Base Scenes (Boxing, Flow). | `aerobeat-core` | Vendor Utils | Testbed Scaffolding | **GPLv3** |
| **Skins** | `aerobeat-skins-*` | **Gameplay Visuals.** Gloves, Targets, Obstacles. | `aerobeat-feature-*` | `aerobeat-core` | Testbed Scaffolding | **CC BY-NC 4.0** |
| **Avatars** | `aerobeat-avatars-*` | **Characters.** Player/Coach models. | `aerobeat-core` | **None** | Testbed Scaffolding | **CC BY-NC 4.0** |
| **Cosmetics** | `aerobeat-cosmetics-*` | **Accessories.** Hats, Glasses. | `aerobeat-core` | **None** | Testbed Scaffolding | **CC BY-NC 4.0** |
| **Environments** | `aerobeat-environments-*` | **Levels.** Lighting, Skyboxes. | `aerobeat-core` | **None** | Testbed Scaffolding | **CC BY-NC 4.0** |
| **Asset** | `aerobeat-asset-*` | **System Assets.** UI Icons, Mock Data. | `aerobeat-core` | **None** | **None** | **CC BY-NC 4.0** |
| **Docs** | `aerobeat-docs` | **Manual.** Documentation Website. | **None** | **None** | MkDocs Plugins | **CC BY-NC 4.0** |
| **Vendor** | `aerobeat-vendor` | **3rd Party Tools.** Utilities and Helpers. | **None** | **None** | *(As Upstream)* | *(As Upstream)* |

---

## 🤝 Contributing

We welcome contributions of all kinds! To ensure you have the best experience, please choose the path that matches your skills and goals.

### 👩‍💻 For Software Engineers
*Looking to fix bugs, optimize the engine, or add new features?*

1.  Read the **Contributing Workflow** guide.
2.  Check the **Architecture Overview** to understand the system.
3.  Pick a repository (e.g., `aerobeat-core` or `aerobeat-feature-boxing`) and start coding.

### 🎨 For Engine Artists
*Looking to contribute official UI themes, icons, or core 3D assets to the open-source project?*

1.  Review the **Art Overview**.
2.  Understand our **Licensing for Creatives**.
3.  Join the discussion on our GitHub Discussions or Discord to coordinate with the Art Director.

### 🖌️ For Modders (UGC)
*Looking to create custom Boxing Gloves, Targets, or Environments for yourself and the community?*

1.  Download the **Skins SDK**, **Avatars SDK**, or **Environment SDK**.
2.  Learn how to pack your assets into `.pck` files.
3.  Upload your creations to the community hub.

### 🎵 For Creators (Music & Fitness)
*Are you a Composer, Choreographer, or Coach? You don't need to download the game engine!*

We provide specialized web-based tools for you:

*   **Musicians:** Upload tracks and get verified at **www.aerobeat-workouts.com/creators**.
*   **Choreographers:** Use the **Choreography Studio** to map songs.
*   **Coaches:** Create workout playlists and voice-overs in the **Coaching Studio**.

> **Current Status:** AeroBeat is currently in **Prototype (v0.0.1)**. We are actively building the Core Contracts and the initial Boxing Feature.

---

*AeroBeat-Workouts &copy; 2026. "Move to the Beat."*
