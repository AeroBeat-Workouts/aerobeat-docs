# UI Architecture (Atomic Design)

We utilize a **Multi-Kit Ecosystem** to support White Labeling and distinct platform requirements. We separate **Logic** (ViewModel), **Visuals** (View), and **Layout** (Shell).

### 1. UI Core (`aerobeat-ui-core`)

* **Role:** The Logic Layer (ViewModel). Contains abstract GDScript classes.
* **Content:** `AeroButtonBase`, `AeroSliderBase`. No `.tscn` files.
* **Goal:** Ensures bug fixes in logic propagate to all visual kits.

### 2. UI Kits (`aerobeat-ui-kit-*`)

* **Role:** The Visual Layer (View). Contains pure, stateless visual components.
* **Variants:** `aerobeat-ui-kit-community`, `aerobeat-ui-kit-linkinpark`.
* **Structure:**
    * **Atoms:** Scenes inheriting Core logic (e.g., `AeroButton.tscn` extends `AeroButtonBase`).
    * **Molecules:** Functional groups (e.g., `SongCard`).
    * **Organisms:** Complex sections (e.g., `SongList`).

### 3. UI Shells (`aerobeat-ui-shell-*`)

* **Role:** The Assembler. Defines "Layouts" and "Pages."
* **Variants:** `aerobeat-ui-shell-mobile-community`, `aerobeat-ui-shell-arcade-linkinpark`.
* **License:** **GPLv3** (Contains Application Logic).
* **Responsibility:**
    1.  **Import:** Consumes a specific `aerobeat-ui-kit-*` via the **UI Sync Protocol**.
    2.  **Layout:** Arranges Organisms into usable Screens (`MainMenu`, `GameplayHUD`).
    3.  **Wiring:** Connects component signals to App Logic (`aerobeat-assembly-*`).

### The UI Sync Protocol (Tooling)

Since Godot lacks a native package manager for assets, we enforce consistency via custom tooling.

1.  **The Script:** `./sync_ui_kit` (Python/Bash).
    * Located in the root of every UI Shell repo.
    * **Action:** Pulls the specific version of the target `aerobeat-ui-kit-*` defined in `.kit_version`.
    * **Validation:** Runs the `test_components` command to ensure the imported atoms are compatible with the current project settings.
2.  **The Workflow:**
    * Developers **NEVER** modify `addons/aerobeat-ui-kit-*` inside a Shell repo.
    * Updates are made in the Kit repo, tagged, and then pulled into Shells via the sync script.

### UI Dependency Rules

To ensure UI repositories remain lightweight and fast to test, we enforce the following dependency limits:

| Dependency Type | Repository | Status | Logic |
| :--- | :--- | :--- | :--- |
| **Contract Hub** | `aerobeat-core` | **Required** | Needed for `AeroMenuProvider` interface. |
| **UI Core** | `aerobeat-ui-core` | **Required** | Base logic for all components. |
| **Component Kit** | `aerobeat-ui-kit-*` | **Required** | Source of all buttons, sliders, and standard widgets. |
| **Shared Assets** | `aerobeat-asset-common` | **Allowed** | Fonts, Logos, and Global Icons only. |
| **Vendor Tools** | `aerobeat-vendor-*` | **Dev-Only** | Tween libs or UI helpers. In Prod, these are Peer Dependencies provided by Assembly. |
| **Game Content** | `aerobeat-asset-*` | **FORBIDDEN** | UI must never depend on specific Level/Env packs. Use Mock Data for testing. |

### Theming & Reskinning Strategy

To support "White Label" partners (e.g., a specific Artist edition or Arcade cabinet), we separate **Structure** from **Style** using the Multi-Kit architecture.

1.  **Multi-Kit Architecture:** We do not force a single visual style.
    *   **Community Kit:** Standard flat design.
    *   **Partner Kits:** Bespoke designs (e.g., 3D Vinyl Records for buttons) that inherit the same `AeroButtonBase` logic.
2.  **Shared Logic:** All interaction logic lives in `aerobeat-ui-core`. This ensures that fixing a "double-click bug" in the Core fixes it for every partner kit instantly.
3.  **Shell Swapping:** We create dedicated Shells (e.g., `aerobeat-ui-shell-arcade-linkinpark`) that consume the specific Partner Kit.

### UI Licensing & Assets

*   **UI Core & Kits:** Licensed under **MPL 2.0** (Libraries).
*   **UI Shells:** Licensed under **GPLv3** (Application Logic).
*   **Assets:** Visuals used by the UI (Icons, Fonts) can be stored inside the UI repo if they are specific to that UI, or pulled from `aerobeat-asset-common` if shared.

## 🛡️ Risk Mitigation Features

To address specific risks identified in our strategic plan, the UI must support the following specialized interfaces.

### 1. The Locker Room (Runtime Gizmos)

*   **Risk:** **Avatar Clipping.** Since UGC Avatars vary wildly in shape (e.g., a Skeleton vs. a Sumo Wrestler), standard attachment points for cosmetics (like Hats or Glasses) may clip or float.
*   **Solution:** The "Locker Room" UI must provide a **Runtime Gizmo** overlay.
    *   **Functionality:** When equipping an accessory, the user can enter "Adjust Mode" to translate, rotate, and scale the item relative to the socket.
    *   **Storage:** These offsets are saved in the User Profile against the specific `(AvatarID, CosmeticID)` pair.

### 2. Streamer Mode

*   **Risk:** **Copyright Strikes (DMCA).** Streamers broadcasting gameplay may accidentally play copyrighted UGC music, risking their channels.
*   **Solution:** A global **"Streamer Mode"** toggle in the Settings menu.
    *   **UI Behavior:**
        *   **Audio:** Mutes all UGC audio tracks, replacing them with safe, licensed "Streamer Friendly" silence.
        *   **Visuals:** Hides potentially offensive UGC album art or usernames, replacing them with generic placeholders.
    *   **Implementation:** The UI Shell must bind this toggle to the **`aerobeat-tool-settings`** service, which the Audio Engine listens to.

## 9. Meta-Game UI Flows

To ensure a seamless experience between the "Game Loop" (Workout) and the "Meta Loop" (Progression), we define specific interaction patterns for the Profile and Locker Room.

### A. The Profile Hub (Overlay Pattern)

The Profile is not a separate "Scene" but a **Modal Overlay** accessible from anywhere in the Main Menu.

*   **Trigger:** Clicking the "Profile Badge" (Top-Right HUD).
*   **State:** Pauses the underlying menu interaction but keeps the background visible (dimmed).
*   **Components:**
    *   `ProfileBadge` (Atom): Displays mini-avatar and level.
    *   `ProfileHub` (Organism): The modal window containing stats and settings.

### B. The Locker Room (Scene Transition)
Unlike the Profile, the Locker Room requires a full scene transition to load the high-fidelity 3D environment for the Avatar.

*   **Trigger:** "Edit Avatar" button in Profile Hub or Main Menu.
*   **Transition:** Fade to Black -> Load `LockerRoom.tscn`.
*   **Interaction Model:**
    *   **Preview First:** Clicking an item equips it *visually* but not *logically*.
    *   **Hold-to-Buy:** Purchasing requires a 1.0s hold interaction to prevent accidental WP spending.
    *   **Gizmo Mode:** A dedicated sub-state for adjusting accessory offsets.