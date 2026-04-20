# Repository Topology

AeroBeat uses a lane-based polyrepo structure. Dependencies are categorized to keep ownership clear and to prevent circular references.

| Tier | Repo Name | Role | Required Deps | Allowed Deps | Dev-Only / Peer Deps | License |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **Assembly** | `aerobeat-assembly-*` | Product assemblies. Compose only the required core repos and concrete packages through GodotEnv. | Exact app/runtime deps only | Exact adjacent packages only | Test frameworks | **GPLv3** |
| **Input Core** | `aerobeat-input-core` | Shared input provider contracts and normalized input-facing types. | **None** | **None** | Unit test tools | **MPL 2.0** |
| **Feature Core** | `aerobeat-feature-core` | Shared gameplay-mode/runtime contracts. Interprets authored content over time. | `aerobeat-content-core` when feature contracts reference durable content types | **None** | Unit test tools | **MPL 2.0** |
| **Content Core** | `aerobeat-content-core` | Durable authored-content contracts: `Song`, `Routine`, `Chart Variant`, `Workout`, shared chart envelope. | **None** | **None** | Unit test tools | **MPL 2.0** |
| **Asset Core** | `aerobeat-asset-core` | Shared asset-side contracts for avatars, cosmetics, environments, and reusable asset definitions. | **None** | **None** | Unit test tools | **MPL 2.0** |
| **UI Core** | `aerobeat-ui-core` | Shared UI abstractions, signals, enums, and base classes. | **None** | `aerobeat-asset-core` when UI contracts reference shared asset definitions | Unit test tools | **MPL 2.0** |
| **Tool Core** | `aerobeat-tool-core` | Shared tool-side contracts for settings, backend/API integration, validation, and import/export flows. | **None** | `aerobeat-content-core`, `aerobeat-asset-core` | Unit test tools | **MPL 2.0** |
| **Input** | `aerobeat-input-*` | Concrete hardware/provider implementations. | `aerobeat-input-core` | Vendor SDKs | Testbed scaffolding | **MPL 2.0** |
| **Feature** | `aerobeat-feature-*` | Concrete gameplay implementations such as Boxing, Dance, Flow, and Step. | `aerobeat-feature-core`, `aerobeat-content-core` | `aerobeat-asset-core`, vendor utils | Testbed scaffolding | **GPLv3** |
| **Tool** | `aerobeat-tool-*` | Concrete services and creator tools. | `aerobeat-tool-core` | `aerobeat-content-core`, `aerobeat-asset-core`, vendor utils | Testbed scaffolding | **MPL 2.0** |
| **UI Kit** | `aerobeat-ui-kit-*` | Visual component libraries that extend UI core logic. | `aerobeat-ui-core` | `aerobeat-asset-core` | Testbed scaffolding | **MPL 2.0** |
| **UI Shell** | `aerobeat-ui-shell-*` | Platform-specific application shells. | `aerobeat-ui-core`, `aerobeat-ui-kit-*` | `aerobeat-asset-core`, `aerobeat-tool-core` | Vendor tools, mock data | **GPLv3** |
| **Skins** | `aerobeat-skins-*` | Gameplay visuals attached to one feature lane. | `aerobeat-feature-*` | `aerobeat-asset-core` | Testbed scaffolding | **CC BY-NC 4.0** |
| **Avatars** | `aerobeat-avatars-*` | Character/content packages. | `aerobeat-asset-core` | **None** | Testbed scaffolding | **CC BY-NC 4.0** |
| **Cosmetics** | `aerobeat-cosmetics-*` | Accessory/content packages. | `aerobeat-asset-core` | **None** | Testbed scaffolding | **CC BY-NC 4.0** |
| **Environments** | `aerobeat-environments-*` | Environment/content packages. | `aerobeat-asset-core` | **None** | Testbed scaffolding | **CC BY-NC 4.0** |
| **Asset** | `aerobeat-asset-*` | Internal or concrete asset packages attached to assemblies or tools. | `aerobeat-asset-core` | **None** | **None** | **CC BY-NC 4.0** |
| **Docs** | `aerobeat-docs` | Documentation website and template source. | **None** | **None** | MkDocs plugins | **CC BY-NC 4.0** |
| **Vendor** | `aerobeat-vendor` | Third-party tools and helpers. | **None** | **None** | *(As upstream)* | *(As upstream)* |

## Dependency definitions

* **Required dependencies:** the repo does not build or validate correctly without them.
* **Allowed dependencies:** adjacent lanes the repo may consume when the contract chain requires them.
* **Dev-only / peer dependencies:** test frameworks, local scaffolding, and repo-local validation tools.

## Ownership rules

* `aerobeat-content-core` owns `Song`, `Routine`, `Chart Variant`, `Workout`, and the shared chart envelope.
* `aerobeat-feature-core` owns gameplay-mode/runtime rules that interpret content; it does not own the durable content contracts.
* `aerobeat-asset-core` owns avatars, cosmetics, environments, and other shared asset-side definitions.
* Assemblies consume only the packages they need through GodotEnv.
* AeroBeat does not document `aerobeat-core` as a universal long-term hub.
