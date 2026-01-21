# Repository Topology

We adhere to a strict **7-Tier** repository structure. Dependencies are categorized to ensure modularity and prevent circular references.

| Tier | Repo Name | Role | Required Deps | Allowed Deps | Dev-Only / Peer Deps | License |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **Assembly** | `aerobeat-assembly-*` | **The Product.** Specific editions (Community, Arcade). | All Active Packages | All Assets | Test Frameworks (Gut) | **GPLv3** |
| **Core** | `aerobeat-core` | **The Hub.** Interfaces, Data Types, Global Constants. | **None** | **None** | Unit Test Tools | **MPL 2.0** |
| **UI Core** | `aerobeat-ui-core` | **UI Logic.** Base classes (ViewModel) for components. | `aerobeat-core` | **None** | Unit Test Tools | **MPL 2.0** |
| **Input** | `aerobeat-input-*` | **Hardware Drivers.** (Camera, VR, Watch). | `aerobeat-core` | Vendor SDKs | Testbed Scaffolding | **MPL 2.0** |
| **UI Kit** | `aerobeat-ui-kit-*` | **Visual Library.** Themed scenes inheriting UI Core logic. | `aerobeat-ui-core` | `aerobeat-asset-common` | Testbed Scaffolding | **MPL 2.0** |
| **UI Shell** | `aerobeat-ui-shell-*` | **Interaction Layer.** Platform-specific screens. | `aerobeat-ui-kit-*` | `aerobeat-asset-common`<br>(Local Assets) | Vendor Tools (Tweeners)<br>Mock Data | **GPLv3** |
| **Feature** | `aerobeat-feature-*` | **Gameplay Logic.** Pure mechanics (Boxing, Flow). | `aerobeat-core` | Vendor Utils | Testbed Scaffolding | **GPLv3** |
| **Asset** | `aerobeat-asset-*` | **Content.** Skins, Songs, Environments. | `aerobeat-core` | **One** Feature (Inheritance) | **None** | **CC BY-NC 4.0** |
| **Docs** | `aerobeat-docs` | **Manual.** Documentation Website. | **None** | **None** | MkDocs Plugins | **CC BY-NC 4.0** |
| **Vendor** | `aerobeat-vendor` | **3rd Party Tools.** Utilities and Helpers. | **None** | **None** | *(As Upstream)* | *(As Upstream)* |

### Dependency Definitions

* **Required Dependencies:** The code will not compile without these. They must be present in `addons/`.
* **Allowed Dependencies:** You may link to these if needed (e.g., using the Official Font from `asset-common`), but they are not strictly mandatory for logic.
* **Dev-Only / Peer Dependencies:** Tools used for testing (like `Gut` or `Tween` libraries). In Production, these are provided by the Host Assembly. In Development, they are cloned via `setup_dev`.

### The UI Tier Strategy (MVVM)

We do not have a "Default UI." The Assembly defines **UI Contracts** (`AeroMenuProvider`), and the UI Tier implements them.

* **`aerobeat-ui-shell-mobile-community`**: 2D Touch-based interface (Scrolls, Taps).
* **`aerobeat-ui-shell-pc-community`**: Mouse/Keyboard interface (Hover states, Keybinds).
* **`aerobeat-ui-shell-vr-community`**: Spatial interface (Laser pointers, World-Space Canvas).

### Repository List (v0.0.1)

* **`aerobeat-assembly-community`**: The standard PC/Mobile release. Contains the Main Menu, Login Flow, and Playlist Browser.
* **`aerobeat-core`**: The unified hub for Contracts (`AeroInputStrategy`), Signals (`AeroEvents`), Constants (`AeroConst`), and Data Types.
* **`aerobeat-input-mediapipe-python`**: Tracks body movement using MediaPipe camera events, then passes them via UDP listeners.
* **`aerobeat-feature-boxing`**: The Boxing gameplay loop, hit detection, and choreography parser.
* **`aerobeat-asset-prototypes`**: Grey-box environments and dummy targets.