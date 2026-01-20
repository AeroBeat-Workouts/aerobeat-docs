# Technical Architecture Document (TAD)

**Project:** AeroBeat Platform

**Target Version:** 0.0.1 (Prototype)

**Date:** 2026-01-19

**Engine:** Godot 4.x

**Language:** GDScript (Primary), Python (CV Sidecar)

**Organization:** AeroBeat-Fitness

## 1. Executive Summary
AeroBeat is a **Modular Rhythm Platform**. We strictly decouple **Input** (Hardware), **UI** (Platform Interaction), **Logic** (Gameplay), and **Content** (Assets).

## 2. Repository Topology
We adhere to a strict 7-Tier repository structure.

| Tier | Repo Name | Role | Dependencies Allowed | License |
| :--- | :--- | :--- | :--- | :--- |
| **Assembly** | `aerobeat-assembly` | The "App." Builds the Executable (Client/Server). | All Packages. | **GPLv3** |
| **Core** | `aerobeat-core` | The "Hub." Interfaces, Enums, Constants, Utils. | **None** (Zero-Dependency). | **MPL 2.0** |
| **Input** | `aerobeat-input-*` | Input managers seperated by their integration method. ex: `aerobeat-input-mediapipe-python`. | Core, Vendor. | **MPL 2.0** |
| **UI** | `aerobeat-ui-*` | **Interaction Layer.** Platform-specific Menus (Mobile vs VR). | **GPLv3** |
| **Feature** | `aerobeat-feature-*` | Logic Satellites. Pure gameplay mechanics. | Core, Vendor. | **GPLv3** |
| **Asset** | `aerobeat-asset-*` | Content Satellites. Scenes, Models, Audio. | Core, **Single** Feature. | **CC BY-NC 4.0** |
| **Docs** | `aerobeat-docs` | Documentation Website (MkDocs). | None. | **CC BY-NC 4.0** |
| **Vendor** | `aerobeat-vendor` | 3rd Party Utilities (Peer Dependencies). | None. | *(As Upstream)* |

### 2.0.5 The UI Tier Strategy (MVVM)
We do not have a "Default UI." The Assembly defines **UI Contracts** (`AeroMenuProvider`), and the UI Tier implements them.
* **`aerobeat-ui-mobile`**: 2D Touch-based interface (Scrolls, Taps).
* **`aerobeat-ui-desktop`**: Mouse/Keyboard interface (Hover states, Keybinds).
* **`aerobeat-ui-vr`**: Spatial interface (Laser pointers, World-Space Canvas).

### 2.1 Repository List (v0.0.1)
* **`aerobeat-assembly`**: The main Godot project. Contains `project.godot`, Export Presets, and Main Menu logic.
* **`aerobeat-core`**: The unified hub for Contracts (`AeroInputStrategy`), Signals (`AeroEvents`), Constants (`AeroConst`), and Data Types.
* **`aerobeat-input-mediapipe-python`**: Tracks body movement using MediaPipe camera events, then passes them via UDP listeners.
* **`aerobeat-feature-boxing`**: The Boxing gameplay loop, hit detection, and choreography parser.
* **`aerobeat-asset-prototypes`**: Grey-box environments and dummy targets.

---

## 3. Core Systems Architecture

### 3.1 Input Pipeline (`aerobeat-feature-input`)
Input is abstracted via a Strategy Pattern to allow hot-swapping between CV, VR, and Debug modes.

* **Interface:** `AeroInputStrategy` (Defined in Core).
* **Strategies:**
    * `StrategyHydra`: Launches/Monitors Python process. Listens on UDP `localhost:8100` for MediaPipe landmarks.
    * `StrategyJoycon`: Interfaces with Switch controllers.
    * `StrategyDebug`: Simulates input via Keyboard/Mouse.
* **Normalization:** All inputs are normalized to `0.0 - 1.0` Viewport Space before leaving this package.

### 3.2 State Management
* **Session Context:** `AeroSessionContext` (Core). Injected into Features at runtime.
* **User Profile:** Managed by Assembly, passed to UI for display.

1.  **Definition (`aerobeat-core`):** `class_name AeroSessionContext`. Defines immutable rules for a round (Speed Multiplier, No Fail, Hit Window MS).
2.  **Assembly (`aerobeat-assembly`):** The App constructs this object based on User Profile + UI Overrides immediately before gameplay.
3.  **Consumption (`aerobeat-feature-*`):** Features receive this Context in their `setup()` function. They do not access Global variables.

### 3.3 Audio Conductor
We do not use `_process(delta)` for rhythm timing.
* **Time Source:** `AudioServer.get_dsp_time()` + `AudioServer.get_time_since_last_mix()`.
* **Latency:** Visual spawn times are offset by a user-calibrated `latency_ms`.
* **Signals:** The Conductor emits `beat_hit(beat_index)`. Spawners listen to signals; they do not count time themselves.

### 3.4 Headless Safety (Multiplayer Prep)
Feature Logic must be safe to run on a Linux Headless Server (No GPU/Audio).
* **Forbidden:** Logic scripts calling `$Audio.play()` or `$Particles.emit()`.
* **Required:** Logic emits `signal hit_confirmed`. A separate `_view_connector.gd` (Client Only) listens and plays FX.

## 3.5 UI Architecture (Atomic Design)

We utilize the **Atomic Design Methodology** to maximize code reuse across disparate platforms (VR vs. Mobile). UI development is split between a centralized "Kit" and platform-specific "Shells."

### 3.5.1 The UI Kit (`aerobeat-ui-kit`)
* **Role:** The Source of Truth. Contains pure, stateless visual components.
* **License:** **MPL 2.0** (Treat as a standard library).
* **Structure:**
    * **Atoms:** Irreducible controls (e.g., `AeroButton`, `AeroLabel`, `AeroSlider`). Styles are driven by Theme Resources.
    * **Molecules:** Simple functional groups (e.g., `SongCard` = Cover Art + Title + Difficulty Badge).
    * **Organisms:** Complex, distinct sections (e.g., `SongList`, `LeaderboardRow`, `ProfileHeader`).
* **Testing:** Every Atom/Molecule must include a `_testbed/` scene demonstrating its states (Normal, Hover, Disabled, Focused).

### 3.5.2 The UI Shells (`aerobeat-ui-mobile`, `aerobeat-ui-vr`)
* **Role:** The Assembler. Defines "Templates" and "Pages."
* **License:** **GPLv3** (Contains Application Logic).
* **Responsibility:**
    1.  **Import:** Consumes the `aerobeat-ui-kit` via the **UI Sync Protocol**.
    2.  **Layout:** Arranges Organisms into usable Screens (`MainMenu`, `GameplayHUD`).
    3.  **Wiring:** Connects component signals to App Logic (`aerobeat-assembly`).

### 3.5.3 The UI Sync Protocol (Tooling)
Since Godot lacks a native package manager for assets, we enforce consistency via custom tooling.

1.  **The Script:** `./sync_ui_kit` (Python/Bash).
    * Located in the root of every UI Shell repo.
    * **Action:** Pulls the specific version of `aerobeat-ui-kit` defined in `.kit_version`.
    * **Validation:** Runs the `test_components` command to ensure the imported atoms are compatible with the current project settings.
2.  **The Workflow:**
    * Developers **NEVER** modify `addons/aerobeat-ui-kit` inside a Shell repo.
    * Updates are made in the `aerobeat-ui-kit` repo, tagged, and then pulled into Shells via the sync script.

---

## 4. Development Workflow

### 4.1 Dependency Management
* **Git Submodules:** Managed via a `setup_dev` script in each repo root.
* **Peer Dependencies:** 3rd Party Plugins (e.g., PhantomCamera) are installed in the `aerobeat-assembly` root. Feature packages access them via `class_name` availability (Duck Typing).

### 4.2 The `.testbed` Pattern
To develop Features in isolation:
1.  Feature Repos contain an ignored `.testbed/` folder.
2.  Developers run `./setup_dev` to clone dependencies (`aerobeat-core`) into `.testbed/addons/`.
3.  Developers work inside `.testbed/project.godot`.

### 4.3 Asset Pipeline
* **Inheritance:** Artists inherit `res://templates/base_target.tscn` (from Feature) to create skins.
* **Single Dependency:** An Asset Package may only depend on **one** Feature. Shared assets must move to `aerobeat-asset-*-common`.

---

## 5. Internal Assets & UGC Strategy

### 5.1 Internal Policy
Scripts (`.gd`) and Shaders (`.gdshader`) are **PERMITTED** in Internally developed Asset Repos (Visual Polish).

### 5.2 Community Content Policy
Scripts are **STRICTLY BANNED** in Community Packages to prevent RCE.
* **Method:** **Data-Driven Injection**.
* **Flow:** The Game spawns the Logic Entity (Feature Repo). The Loader reads a `SkinConfig` resource (UGC) and swaps the Mesh/Material at runtime.
* **Validation:** The Asset Loader rejects any imported package containing text resources with `script/source` references.

## 6. Security & Licensing

* **UI Code:** Licensed under **GPLv3** because it contains complex logic (state handling, animation controllers).
* **Assets:** Visuals used by the UI (Icons, Fonts) can be stored inside the UI repo if they are specific to that UI, or pulled from `aerobeat-asset-common` if shared.

---

## 6. Directory Structure Reference

### A. The Core Project (`aerobeat-core`)
```
aerobeat-core/
├── contracts/          # Interfaces (AeroInputStrategy)
├── data_types/         # Resources (AeroSessionContext, BeatData)
├── globals/            # Static Consts (AeroConst, AeroEvents)
└── utils/              # Math Helpers (KalmanFilter)
```

### B. A Feature Project (`aerobeat-feat-input`)
```
aerobeat-input-mediapipe-python/
├── python_mediapipe/       # CV Sidecar Code
├── scripts/
│   ├── strategies/     # Logic Implementation
│   │   ├── strategy_mediapipe.gd
│   │   └── strategy_debug.gd
│   └── input_manager.gd
├── .testbed/           # Ignored Ghost Project
└── plugin.cfg
```

### C. The UI-Kit Project (`aerobeat-ui-kit`)
```
aerobeat-ui-kit/
├── atoms/
│   ├── aero_button/
│   │   ├── AeroButton.tscn
│   │   ├── AeroButton.gd
│   │   └── AeroButton_Test.tscn  <-- The Atomic Test
│   └── aero_slider/ ...
├── molecules/
│   ├── song_card/
│   │   ├── SongCard.tscn         <-- Uses AeroButton + AeroLabel
│   │   └── SongCard_Test.tscn
├── scripts/
│   └── theme_utils.gd            <-- Shared logic
└── sync_manifest.json            <-- Defines exports
```