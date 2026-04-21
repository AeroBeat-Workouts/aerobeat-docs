# Development Workflow

## Repository templates

To ensure license compliance and correct file structure, always start new repositories using the templates found in `aerobeat-docs/templates/`.

Examples:

* **Assembly / Feature / UI Shell:** GPLv3
* **Input Core / Feature Core / Content Core / Asset Core / UI Core / Tool Core / Input / Tool / UI Kit:** MPL 2.0
* **Skins / Avatars / Cosmetics / Environments:** CC BY-NC 4.0

## Dependency management

AeroBeat uses **GodotEnv** as the dependency composition contract.

* **Core rule:** every repo declares only the core repos and concrete packages it actually needs.
* **Assembly rule:** `aerobeat-assembly-community` and other `aerobeat-assembly-*` repos compose only the required cores and concrete repos through GodotEnv.
* **No universal hub rule:** do not model the platform around one catch-all `aerobeat-core` dependency; use the lane-specific cores instead, starting with `aerobeat-input-core` for shared input contracts.

### Typical dependency shape

* **Input repos** depend on [`aerobeat-input-core`](https://github.com/AeroBeat-Workouts/aerobeat-input-core).
* **Feature repos** depend on [`aerobeat-feature-core`](https://github.com/AeroBeat-Workouts/aerobeat-feature-core) and consume [`aerobeat-content-core`](https://github.com/AeroBeat-Workouts/aerobeat-content-core).
* **Tool repos** depend on [`aerobeat-tool-core`](https://github.com/AeroBeat-Workouts/aerobeat-tool-core) and consume content and asset contracts as needed. Concrete authoring products should use the `aerobeat-tool-*` naming family and expose core content operations through a headless/CLI surface even when they also ship an interactive editor.
* **UI kits and shells** depend on [`aerobeat-ui-core`](https://github.com/AeroBeat-Workouts/aerobeat-ui-core) plus any concrete UI kits/assets they need.
* **Asset repos** depend on [`aerobeat-asset-core`](https://github.com/AeroBeat-Workouts/aerobeat-asset-core).

## The `.testbed` pattern

To develop package repos in isolation:

1. Package repos contain an ignored `.testbed/` folder.
2. Developers restore dependencies in `.testbed/` through GodotEnv.
3. Developers work inside `.testbed/project.godot` for local validation.

`.testbed` is a local dev surface. Canonical shared contracts stay in the owning repo, especially the six core repos.

## Content ownership workflow

When creating or updating playable content contracts:

1. Put `Song`, `Routine`, `Chart Variant`, `Workout`, shared chart-envelope changes, package-manifest contracts, registry/query interfaces, and shared schema-version or migration contracts in [`aerobeat-content-core`](https://github.com/AeroBeat-Workouts/aerobeat-content-core).
2. Put gameplay-mode/runtime rule changes and mode-specific payload validation in [`aerobeat-feature-core`](https://github.com/AeroBeat-Workouts/aerobeat-feature-core) or a concrete `aerobeat-feature-*` repo.
3. Put import/export jobs, ingestion flows, publishing workflows, and other tool-side operational models in [`aerobeat-tool-core`](https://github.com/AeroBeat-Workouts/aerobeat-tool-core) or a concrete `aerobeat-tool-*` repo. Treat headless/CLI execution for validation, migration, packaging, import/export, and automation-friendly authoring tasks as a first-class requirement, not a later convenience.
4. Put asset-side shared definitions for avatars, cosmetics, environments, and similar reusable assets in [`aerobeat-asset-core`](https://github.com/AeroBeat-Workouts/aerobeat-asset-core).
5. Put 2D lanes, 3D portals, and other content-consuming runtime visuals in [`aerobeat-feature-core`](https://github.com/AeroBeat-Workouts/aerobeat-feature-core) or a concrete `aerobeat-feature-*` repo, even when they consume presentation hints defined by content contracts.
6. Update assemblies to consume only the packages they need through GodotEnv.

## Asset pipeline

* **Inheritance:** Artists inherit feature or UI-facing template scenes/resources as appropriate for the package they are building.
* **Skins:** Must depend on **one** feature lane.
* **Avatars / Cosmetics / Environments:** Shared asset-side contracts come from `aerobeat-asset-core`.

## Versioning (`plugin.cfg`)

All modular repositories (features, inputs, UI kits, tools, and reusable asset packages) must contain a `plugin.cfg` manifest. When releasing updates:

1. **Open `plugin.cfg`:** Located at the repository root.
2. **Update version:** Increment the `version="x.y.z"` field following Semantic Versioning.
3. **Git tag:** Create a git tag matching this version (for example `v1.2.0`). This allows assemblies and shells to lock dependencies to stable releases via GodotEnv.

---

## Internal assets & UGC strategy

### Internal policy

Scripts (`.gd`) and shaders (`.gdshader`) are permitted in internally developed asset repos.

### Community content policy

Scripts are strictly banned in community packages to prevent RCE.

* **Method:** Data-driven injection.
* **Flow:** The game spawns the logic entity from the relevant feature repo. The loader reads resource data from content and asset packages and applies it at runtime.
* **Validation:** The asset loader rejects any imported package containing text resources with `script/source` references.
