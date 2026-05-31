# Directory Structure Reference

AeroBeat uses domain-specific core repos instead of one universal hub repo. Each core repo owns the canonical shared contracts for one architecture lane.

## A. Input Core (`aerobeat-input-core`)

```text
aerobeat-input-core/
├── interfaces/         # Input provider contracts and runtime-facing abstractions
├── data_types/         # Normalized input payloads and shared provider data types
├── globals/            # Shared input enums, constants, and signals
└── utils/              # Small input-focused helpers
```

## B. Feature Core (`aerobeat-feature-core`)

```text
aerobeat-feature-core/
├── interfaces/         # Gameplay-mode and runtime-rule contracts
├── data_types/         # Shared scoring, spawn, hit, and lifecycle types
├── validators/         # Feature-facing validation result types and hooks
└── globals/            # Shared feature enums and constants
```

`aerobeat-feature-core` consumes content contracts but does not own them. Feature repos interpret authored content over time; they do not define the durable content primitives.

## C. Content Core (`aerobeat-content-core`)

```text
aerobeat-content-core/
├── interfaces/
│   ├── chart_loader.gd
│   ├── content_registry.gd
│   ├── content_migration.gd
│   └── workout_resolution.gd
├── data_types/
│   ├── song.gd
│   ├── set.gd
│   ├── chart.gd
│   ├── workout.gd
│   ├── chart_envelope.gd
│   └── content_package_manifest.gd
├── validators/
│   └── content_validation_result.gd
└── globals/
    └── aero_content_schema.gd
```

`Song`, `Chart`, `Set`, and `Workout` live in `aerobeat-content-core`. Shared chart-envelope fields, content-package manifest contracts, registry/query interfaces, workout-resolution contracts, schema-version rules, migration interfaces, and cross-tool/runtime validation types also live there.

For the more opinionated day-one shape of both `aerobeat-content-core` and the first concrete authoring repo, see [Content Repo Shapes](content-repo-shapes.md).

## D. Asset Core (`aerobeat-asset-core`)

```text
aerobeat-asset-core/
├── interfaces/         # Asset-pack, avatar, cosmetic, and environment contracts
├── data_types/         # Shared asset descriptors and resource definitions
├── validators/         # Asset safety and compatibility validation types
└── globals/            # Shared asset enums, tags, and constants
```

Asset-side contracts such as avatars, cosmetics, environments, and shared asset definitions live in `aerobeat-asset-core`, not in feature repos and not in a catch-all universal core.

## E. UI Core (`aerobeat-ui-core`)

```text
aerobeat-ui-core/
├── scripts/
│   ├── base/
│   │   ├── aero_button_base.gd
│   │   └── aero_view_base.gd
│   └── utils/
└── globals/
```

## F. Tool Core (`aerobeat-tool-core`)

```text
aerobeat-tool-core/
├── interfaces/         # Shared tool/backend/settings contracts
├── data_types/         # Tool-side models and DTOs
├── validators/         # Tool-side validation and import/export result types
└── globals/            # Shared tool enums and constants
```

Concrete authoring tools do not live under `aerobeat-content-*`. They live under `aerobeat-tool-*` and depend on `aerobeat-content-core` for durable content contracts. Any interactive/editor UX in those repos should sit on top of the same services that power a headless/CLI surface.

Concrete content-consuming visuals also do not live in `aerobeat-content-core`. 2D lanes, 3D portals, and similar runtime presentation systems belong in `aerobeat-feature-*` repos because they are feature/runtime implementations, not durable authored-content contracts.

## G. Environment family repo examples

The `aerobeat-environment-*` family is a concrete package family, not a replacement for the six core lanes. Shared environment contracts still live in `aerobeat-asset-core`; the environment-family repos package reusable internal environments and narrowly scoped environment-loading/runtime helpers on top of that foundation.

### Internal environment package repo (`aerobeat-environment-core`)

```text
aerobeat-environment-core/
├── assets/
│   ├── environments/   # Internal environment scenes/resources
│   ├── lighting/       # Lighting rigs, sky/fog/material helpers
│   └── reactive/       # Optional reactive presentation resources
├── .testbed/
│   ├── addons.jsonc
│   ├── project.godot
│   └── tests/
├── plugin.cfg
├── LICENSE.md
└── README.md
```

`aerobeat-environment-core` is the baseline internal environment package shape. It should stay dependency-light, build on `aerobeat-asset-core`, and avoid pretending that generic environment content itself defines a new platform-wide core lane.

### Runtime environment loader repo (`aerobeat-environment-loader`)

```text
aerobeat-environment-loader/
├── src/
│   ├── autoload/      # Repo-specific environment loader singleton/autoload entrypoint
│   ├── bridges/       # Workout/package environment bridge helpers
│   └── parsers/       # Lightweight manifest/YAML parsing helpers
├── .testbed/
│   ├── addons.jsonc
│   ├── assets/
│   ├── fixtures/
│   ├── scenes/
│   ├── scripts/
│   ├── src/
│   └── tests/
├── plugin.cfg
├── LICENSE.md
└── README.md
```

`aerobeat-environment-loader` is the generic environment-fulfillment wrapper for the official package-facing environment types `image_background`, `video_background`, `glb_environment`, and `splat`. It should keep adjacent dependencies explicit rather than inheriting a fake universal asset/environment bundle.

### Specialized splat runtime repo (`aerobeat-environment-gaussian-splat`)

```text
aerobeat-environment-gaussian-splat/
├── src/
│   ├── runtime/       # Splat runtime + background load/read helpers
│   └── adapters/      # Loader-facing fulfillment adapters when the repo exposes them
├── addons/            # Optional installable addon payload, if the repo ships one
├── .testbed/
│   ├── addons.jsonc
│   ├── assets/
│   ├── scenes/
│   ├── scripts/
│   ├── src/
│   └── tests/
├── plugin.cfg
├── LICENSE.md
└── README.md
```

`aerobeat-environment-gaussian-splat` is the specialized runtime wrapper for the official `splat` environment type. That type is now package-facing, but it remains the controlled advanced lane rather than the broad default creator path. Downstream repos should consume this package for splat-specific support rather than talking to third-party decoders directly.

## H. Spatial UI family reference

### Spatial UI core (`aerobeat-spatial-ui-core`)

```text
aerobeat-spatial-ui-core/
├── src/
│   └── helpers/
│       ├── aero_spatial_ui_core_manifest.gd
│       ├── policies/
│       │   └── aero_spatial_hover_capture_policy.gd
│       ├── providers/
│       │   ├── aero_spatial_projection_helper.gd
│       │   ├── aero_spatial_rect_target_resolver.gd
│       │   └── aero_spatial_target_resolver_base.gd
│       └── surfaces/
│           ├── aero_spatial_surface_descriptor.gd
│           └── aero_spatial_target_resolution_result.gd
```

`aerobeat-spatial-ui-core` is a shared helper layer for spatial/world UI adapters. It is not the owner of the canonical UI interaction contract, the native 2D bridge, or concrete mouse, touch, or XR extraction.

### Spatial UI provider (`aerobeat-spatial-ui-mouse`)

```text
aerobeat-spatial-ui-mouse/
├── src/
│   └── providers/
│       └── mouse/
│           ├── aero_spatial_ui_mouse_provider.gd
│           ├── aero_spatial_ui_mouse_provider_config.gd
│           └── aero_spatial_ui_mouse_runtime_boundary.gd
```

`aerobeat-spatial-ui-mouse` is the first concrete packaged mouse provider lane. Future touch and XR packages should follow the same pattern in their own repos rather than being folded into this one.

## I. Concrete implementation repo examples

### Input provider repo (`aerobeat-input-mediapipe-python`)

```text
aerobeat-input-mediapipe-python/
├── python_mediapipe/   # CV sidecar code
├── src/
│   ├── config/         # Provider/configuration resources
│   ├── process/        # Sidecar process integration
│   ├── providers/      # Concrete input-provider implementations
│   ├── server/         # Local transport / bridge server code
│   └── strategies/     # Technology-specific interpretation logic
├── .testbed/           # Ignored local dev project
├── tests/
└── plugin.cfg
```

### Tool authoring repo (`aerobeat-tool-content-authoring`)

```text
aerobeat-tool-content-authoring/
├── interfaces/         # Tool-facing service interfaces shared by CLI and editor surfaces
├── services/           # Validation, migration, packaging, import/export workflows
├── cli/                # Headless entrypoints / command wiring
├── editor/             # Optional interactive/editor UX layered on the same services
├── tests/
└── plugin.cfg
```

### UI kit repo (`aerobeat-ui-kit-community`)

```text
aerobeat-ui-kit-community/
├── atoms/
│   ├── aero_button/
│   │   ├── AeroButton.tscn       # Extends AeroButtonBase
│   │   └── AeroButton_Test.tscn
│   └── aero_slider/
├── molecules/
│   ├── song_card/
│   │   ├── SongCard.tscn         # Uses AeroButton + AeroLabel
│   │   └── SongCard_Test.tscn
└── sync_manifest.json
```

## J. Assembly composition rule

Assembly repos such as `aerobeat-assembly-community` compose only the core repos and concrete repos they actually need via GodotEnv. They do not inherit the entire platform by default.
