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

We adhere to a strict **7-Tier** repository structure. Dependencies are categorized to ensure modularity and prevent circular references.

| Tier | Repo Name | Role | Required Deps | Allowed Deps | Dev-Only / Peer Deps | License |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **Assembly** | `aerobeat-assembly` | **The Router.** Manages App State & Dependency Injection. | All Active Packages | All Assets | Test Frameworks (Gut) | **GPLv3** |
| **Core** | `aerobeat-core` | **The Hub.** Interfaces, Data Types, Global Constants. | **None** | **None** | Unit Test Tools | **MPL 2.0** |
| **Input** | `aerobeat-input-*` | **Hardware Drivers.** (Camera, VR, Watch). | `aerobeat-core` | Vendor SDKs | Testbed Scaffolding | **MPL 2.0** |
| **UI Kit** | `aerobeat-ui-kit` | **Atomic Library.** Pure, stateless components (Buttons, Cards). | `aerobeat-core` | `aerobeat-asset-common` | Testbed Scaffolding | **MPL 2.0** |
| **UI Shell** | `aerobeat-ui-*` | **Interaction Layer.** Platform-specific screens (Mobile, VR). | `aerobeat-core`<br>`aerobeat-ui-kit` | `aerobeat-asset-common`<br>(Local Assets) | Vendor Tools (Tweeners)<br>Mock Data | **GPLv3** |
| **Feature** | `aerobeat-feature-*` | **Gameplay Logic.** Pure mechanics (Boxing, Flow). | `aerobeat-core` | Vendor Utils | Testbed Scaffolding | **GPLv3** |
| **Asset** | `aerobeat-asset-*` | **Content.** Skins, Songs, Environments. | `aerobeat-core` | **One** Feature (Inheritance) | **None** | **CC BY-NC 4.0** |
| **Docs** | `aerobeat-docs` | **Manual.** Documentation Website. | **None** | **None** | MkDocs Plugins | **CC BY-NC 4.0** |
| **Vendor** | `aerobeat-vendor` | **3rd Party Tools.** Utilities and Helpers. | **None** | **None** | *(As Upstream)* | *(As Upstream)* |

### 2.1 Dependency Definitions

* **Required Dependencies:** The code will not compile without these. They must be present in `addons/`.
* **Allowed Dependencies:** You may link to these if needed (e.g., using the Official Font from `asset-common`), but they are not strictly mandatory for logic.
* **Dev-Only / Peer Dependencies:** Tools used for testing (like `Gut` or `Tween` libraries). In Production, these are provided by the Host Assembly. In Development, they are cloned via `setup_dev`.

### 2.2 The UI Tier Strategy (MVVM)

We do not have a "Default UI." The Assembly defines **UI Contracts** (`AeroMenuProvider`), and the UI Tier implements them.

* **`aerobeat-ui-mobile`**: 2D Touch-based interface (Scrolls, Taps).
* **`aerobeat-ui-desktop`**: Mouse/Keyboard interface (Hover states, Keybinds).
* **`aerobeat-ui-vr`**: Spatial interface (Laser pointers, World-Space Canvas).

### 2.3 Repository List (v0.0.1)

* **`aerobeat-assembly`**: The main Godot project. Contains `project.godot`, Export Presets, and Main Menu logic.
* **`aerobeat-core`**: The unified hub for Contracts (`AeroInputStrategy`), Signals (`AeroEvents`), Constants (`AeroConst`), and Data Types.
* **`aerobeat-input-mediapipe-python`**: Tracks body movement using MediaPipe camera events, then passes them via UDP listeners.
* **`aerobeat-feature-boxing`**: The Boxing gameplay loop, hit detection, and choreography parser.
* **`aerobeat-asset-prototypes`**: Grey-box environments and dummy targets.

---

## 3. Core Systems Architecture

### 3.1 Input Pipeline (Provider Pattern)

Input is abstracted via a Strategy Pattern to allow hot-swapping between CV, VR, and Debug modes. The game logic never talks to hardware directly; it asks the **Input Provider** for normalized data.

* **Interface:** `AeroInputProvider` (Defined in `aerobeat-core`).
* **Contract:** Must return normalized `0.0 - 1.0` Viewport Coordinates for `LeftHand`, `RightHand`, and `Head`.

**Supported Strategies:**

| Strategy Name | Repository | Technology | Target Platform |
| :--- | :--- | :--- | :--- |
| **`StrategyMediaPipePython`** | `aerobeat-input-mediapipe-python` | **Sidecar Process.** Launches a Python subprocess that pipes landmark data via UDP `localhost:8100`. | Windows, Linux, Mac |
| **`StrategyMediaPipeNative`** | `aerobeat-input-mediapipe-native` | **GDExtension / Plugin.** Runs MediaPipe directly in the application memory. | Android, iOS |
| **`StrategyJoyconHID`** | `aerobeat-input-joycon-hid` | **Raw Bluetooth.** Connects directly to JoyCons to read high-speed Gyro/Accel data. | Windows, Linux, Android |
| **`StrategyKeyboard`** | `aerobeat-input-keyboard` | **Godot Native.** Maps WASD/Arrow keys to specific lanes (Virtual Presence). | All |
| **`StrategyMouse`** | `aerobeat-input-mouse` | **Godot Native.** Maps cursor X/Y to viewport coordinates. | Desktop / Web |
| **`StrategyTouch`** | `aerobeat-input-touch` | **Godot Native.** Maps touchscreen taps to viewport coordinates. | Mobile / Tablet |
| **`StrategyGamepad`** | `aerobeat-input-gamepad` | **Godot Native.** Standard XInput (Xbox/PS5) stick mapping. | All |

### 3.1.1 Strategy Grouping Rationale
We enforce a **One-Repo-Per-Device-Type** policy, even for standard Godot inputs.

**The Logic: Granularity & Quirks.**

1.  **Isolation of Quirks:**
    * While Godot handles generic Gamepads well, specific controllers (like DDR Dance Pads or Flight Sticks) often report as generic gamepads but require specific axis remapping or deadzone logic.
    * By isolating `aerobeat-input-gamepad`, we can implement complex remapping strategies without polluting the clean logic of `aerobeat-input-keyboard`.

2.  **The "Driver" Tier (`input-mediapipe-*`, `input-joycon`):**
    * These inputs require **Heavy External Dependencies** (Python Environments, Android .aar Libraries, GDExtensions).
    * **Isolation is Safety:** By keeping the Python CV stack in its own repo, we ensure that a Mobile developer never has to download a 200MB Python environment they can't use. Likewise, a PC developer doesn't need to compile Android Java code just to fix a keyboard bug.

**Normalization Flow:**

1.  **Raw Data:** Strategy receives device-specific data (e.g., MediaPipe Landmark `x: 0.54, y: 0.21, z: -0.1`).
2.  **Adaptation:** Strategy applies technology-specific offsets (e.g., flipping Y axis for OpenCV).
3.  **Delivery:** Strategy exposes `get_left_hand_transform()` to the Game Loop.

### 3.2 State Management & Multiplayer Strategy
To support multiplayer without refactoring core logic, we strictly separate **Immutable Context** from **Mutable State**.

#### 3.2.1 The Session Context (Immutable)

* **Class:** `AeroSessionContext` (Core).
* **Role:** Defines the "Rules of the Round" (Song ID, Difficulty, Modifiers, Random Seed).
* **Sync:** Sent **Once** by the Host before the round starts.
* **Rule:** Features **READ** this to configure themselves. They **NEVER** modify it.

#### 3.2.2 The User State (Mutable / Replicated)

* **Class:** `AeroUserState` (Core).
* **Role:** Holds real-time player data (Score, Combo, Health, Current Input Pose).
* **Authority:** The **Local Client** is the authority on their own score/hits (Client-Side Prediction).
* **Replication:**
    * **High Frequency (Unreliable):** Avatar Pose (Head/Hands) for visual representation.
    * **Event Based (Reliable):** Score updates, Combo breaks, Health changes.
* **Rule:** Features write to their Local `AeroUserState`. The Assembly handles replicating this object to other peers.

#### 3.2.3 The "Remote Athlete" Pattern

Multiplayer opponents are visualized as "Remote Athletes" (Avatars).

1.  **Local Athlete:** Input -> Logic -> `AeroUserState` (Local).
2.  **Remote Athlete:** Network -> `AeroUserState` (Remote) -> Avatar Visualizer.
3.  **Constraint:** Gameplay Logic (`aerobeat-feature-*`) must accept a `target_user_state` in its setup. It does not assume it is always driving the main UI.

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

### 3.4.4 UI Dependency Rules

To ensure UI repositories remain lightweight and fast to test, we enforce the following dependency limits:

| Dependency Type | Repository | Status | Logic |
| :--- | :--- | :--- | :--- |
| **Contract Hub** | `aerobeat-core` | **Required** | Needed for `AeroMenuProvider` interface. |
| **Component Kit** | `aerobeat-ui-kit` | **Required** | Source of all buttons, sliders, and standard widgets. |
| **Shared Assets** | `aerobeat-asset-common` | **Allowed** | Fonts, Logos, and Global Icons only. |
| **Vendor Tools** | `aerobeat-vendor` | **Dev-Only** | Tween libs or UI helpers. In Prod, these are Peer Dependencies provided by Assembly. |
| **Game Content** | `aerobeat-asset-*` | **FORBIDDEN** | UI must never depend on specific Level/Env packs. Use Mock Data for testing. |

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