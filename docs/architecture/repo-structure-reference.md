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
│   ├── routine.gd
│   ├── chart_variant.gd
│   ├── workout.gd
│   ├── chart_envelope.gd
│   └── content_package_manifest.gd
├── validators/
│   └── content_validation_result.gd
└── globals/
    └── aero_content_schema.gd
```

`Song`, `Routine`, `Chart Variant`, and `Workout` live in `aerobeat-content-core`. Shared chart-envelope fields, content-package manifest contracts, registry/query interfaces, workout-resolution contracts, schema-version rules, migration interfaces, and cross-tool/runtime validation types also live there.

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

## G. Concrete implementation repo examples

### Input provider repo (`aerobeat-input-mediapipe-python`)

```text
aerobeat-input-mediapipe-python/
├── python_mediapipe/   # CV sidecar code
├── scripts/
│   ├── strategies/     # Technology-specific provider logic
│   └── input_manager.gd
├── .testbed/           # Ignored local dev project
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

## H. Assembly composition rule

Assembly repos such as `aerobeat-assembly-community` compose only the core repos and concrete repos they actually need via GodotEnv. They do not inherit the entire platform by default.
