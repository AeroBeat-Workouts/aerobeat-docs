# Repository Topology

AeroBeat adheres to a strict **15-Tier** repository structure. Dependencies are categorized to ensure modularity and prevent circular references.

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
| **Asset** | `aerobeat-asset-*` | **System Assets.** Internal assets attached to an assembly, not part of the UGC system. | `aerobeat-core` | **None** | **None** | **CC BY-NC 4.0** |
| **Docs** | `aerobeat-docs` | **Manual.** Documentation Website. | **None** | **None** | MkDocs Plugins | **CC BY-NC 4.0** |
| **Vendor** | `aerobeat-vendor` | **3rd Party Tools.** Utilities and Helpers. | **None** | **None** | *(As Upstream)* | *(As Upstream)* |

### Dependency Definitions

* **Required Dependencies:** The code will not compile without these. They must be present in `addons/`.
* **Allowed Dependencies:** You may link to these if needed, but they are not strictly mandatory.
* **Dev-Only / Peer Dependencies:** Tools used for testing (like `Gut` or `Tween` libraries). In Production, these are provided by the Host Assembly. In Development, they are cloned via the `setup_dev.py` script at the root of each repository / rig.