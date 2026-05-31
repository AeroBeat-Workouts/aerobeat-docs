# Development Workflow

## Repository templates

To ensure license compliance and correct file structure, always start new repositories from the canonical `aerobeat-template-*` GitHub template repositories documented in `templates/README.md`.

`aerobeat-docs/templates/` is now a docs-only link directory. It should explain which template to use and what cleanup is mandatory after clone, but it must not ship runnable template payloads.

Immediately after cloning any template, rename placeholder files, classes, autoloads, and stale identifiers before treating the clone as real runtime code. In the tool lane, that specifically includes removing placeholder names such as `AeroToolManager`.

Examples:

* **Assembly / Feature / UI Shell:** GPLv3
* **Input Core / Feature Core / Content Core / Asset Core / UI Core / Tool Core / Input / Tool / UI Kit / Spatial UI package:** MPL 2.0
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
* **Environment repos** use the `aerobeat-environment-*` family for reusable internal environment packages and runtime loading helpers. `aerobeat-environment-core` is a concrete internal environment package baseline built on [`aerobeat-asset-core`](https://github.com/AeroBeat-Workouts/aerobeat-asset-core), while specialized runtime helpers such as `aerobeat-environment-loader` and `aerobeat-environment-gaussian-splat` should keep their adjacent dependencies explicit instead of implying a new universal core lane.
* **UI kits and shells** depend on [`aerobeat-ui-core`](https://github.com/AeroBeat-Workouts/aerobeat-ui-core) plus any concrete UI kits/assets they need.
* **Spatial UI repos** depend on the smallest honest package chain: `aerobeat-input-core` for the canonical UI interaction contract / native 2D bridge path, `aerobeat-spatial-ui-core` for shared helper-layer code, and only the concrete `aerobeat-spatial-ui-*` provider packages actually needed by the consumer.
* **Asset repos** depend on [`aerobeat-asset-core`](https://github.com/AeroBeat-Workouts/aerobeat-asset-core).

### Packaged spatial UI resolver flow

The spatial UI lane should be installed and resolved as packages, not improvised inside one proof host:

1. consumer shell or assembly installs `aerobeat-input-core`, any needed UI kit/contracts, `aerobeat-spatial-ui-core`, and an optional concrete `aerobeat-spatial-ui-*` provider through GodotEnv
2. `aerobeat-spatial-ui-core` contributes the packaged helper layer the provider reuses
3. the concrete provider publishes into the canonical `aerobeat-input-core` UI interaction contract / native bridge path
4. the shell wires the resolved interaction output into its menus/widgets
5. future touch or XR support should arrive as their own provider packages, not as hidden branches inside the mouse lane

This keeps provider ownership explicit and keeps future extraction work auditable.

## The `.testbed` pattern

To develop package repos in isolation:

1. Package repos contain an ignored `.testbed/` folder.
2. Developers restore dependencies in `.testbed/` through GodotEnv.
3. Developers work inside `.testbed/project.godot` for local validation.

`.testbed` is a local dev surface. Canonical shared contracts stay in the owning repo, especially the six core repos.

## Content ownership workflow

When creating or updating playable content contracts:

1. Put `Song`, `Chart`, `Set`, `Workout`, shared chart-envelope changes, package-manifest contracts, registry/query interfaces, and shared schema-version or migration contracts in [`aerobeat-content-core`](https://github.com/AeroBeat-Workouts/aerobeat-content-core).
2. Put gameplay-mode/runtime rule changes and mode-specific payload validation in [`aerobeat-feature-core`](https://github.com/AeroBeat-Workouts/aerobeat-feature-core) or a concrete `aerobeat-feature-*` repo.
3. Put import/export jobs, ingestion flows, publishing workflows, and other tool-side operational models in [`aerobeat-tool-core`](https://github.com/AeroBeat-Workouts/aerobeat-tool-core) or a concrete `aerobeat-tool-*` repo. Treat headless/CLI execution for validation, migration, packaging, import/export, and automation-friendly authoring tasks as a first-class requirement, not a later convenience.
4. Put asset-side shared definitions for avatars, cosmetics, environments, and similar reusable assets in [`aerobeat-asset-core`](https://github.com/AeroBeat-Workouts/aerobeat-asset-core).
5. Put concrete internal environment packages and reusable environment-scene/resource bundles in the `aerobeat-environment-*` family. Use `aerobeat-environment-core` as the baseline internal environment package shape, and keep any runtime loader/helper repos such as `aerobeat-environment-loader` or `aerobeat-environment-gaussian-splat` narrowly scoped to environment fulfillment rather than treating them as broad asset-lane replacements.
6. Put 2D lanes, 3D portals, and other content-consuming runtime visuals in [`aerobeat-feature-core`](https://github.com/AeroBeat-Workouts/aerobeat-feature-core) or a concrete `aerobeat-feature-*` repo, even when they consume presentation hints defined by content contracts.
7. Update assemblies to consume only the packages they need through GodotEnv.

## Asset pipeline

* **Inheritance:** Artists inherit feature or UI-facing template scenes/resources as appropriate for the package they are building.
* **Skins:** Must depend on **one** feature lane.
* **Avatars / Cosmetics / Environments:** Shared asset-side contracts come from `aerobeat-asset-core`.

## Versioning (`plugin.cfg`)

All modular repositories (features, inputs, UI kits, spatial UI providers, tools, and reusable asset packages) must contain a `plugin.cfg` manifest. When releasing updates:

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
