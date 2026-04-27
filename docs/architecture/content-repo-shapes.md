# Content Repo Shapes: `aerobeat-content-core` and `aerobeat-tool-content-authoring`

This document turns the approved Content-lane architecture into concrete **day-one repo recommendations** for the first two repos in the lane:

1. [`aerobeat-content-core`](https://github.com/AeroBeat-Workouts/aerobeat-content-core) as the canonical owner of durable authored-content contracts
2. `aerobeat-tool-content-authoring` as the first concrete Tool-lane product that authors, validates, migrates, packages, and inspects that content

The goal is not to over-design a future platform. The goal is to make repo creation safe by defining what belongs in each repo on day one, what explicitly stays out, and how CLI/headless and optional editor UX share one service layer.

## Architecture position

These repo shapes assume the six-core model already documented elsewhere:

- `aerobeat-content-core` owns the durable content language: `Song`, `Set`, `Chart`, `Workout`, shared chart-envelope contracts, ids, manifests, schema/version rules, shared validators, registry/query interfaces, and workout resolution contracts.
- `aerobeat-tool-core` owns shared tool-side operational models, progress/result DTOs, and other tool-common contracts.
- `aerobeat-tool-content-authoring` is a concrete Tool-lane product built on top of `aerobeat-content-core` and `aerobeat-tool-core`.
- `aerobeat-feature-core` and concrete `aerobeat-feature-*` repos consume content contracts and own runtime interpretation, scoring, spawning, and presentation systems such as 2D lanes and 3D portals.

If a repo shape below conflicts with that ownership model, the ownership model wins.

## Day-one recommendation: `aerobeat-content-core`

### Purpose

`aerobeat-content-core` should be created as a **dependency-light contract repo**. It is the durable source of truth for authored content shapes shared by runtime, tools, tests, and packages.

It should answer: "What is valid AeroBeat content?" not "How does the user author it?" and not "How does the runtime render or score it?"

### Day-one directory shape

```text
aerobeat-content-core/
├── interfaces/
│   ├── chart_loader.gd
│   ├── content_registry.gd
│   ├── content_migration.gd
│   └── workout_resolution.gd
├── data_types/
│   ├── content_id.gd
│   ├── song.gd
│   ├── set.gd
│   ├── chart.gd
│   ├── workout.gd
│   ├── chart_envelope.gd
│   ├── content_package_manifest.gd
│   ├── content_reference.gd
│   └── content_query.gd
├── validators/
│   ├── content_validation_result.gd
│   ├── content_validation_issue.gd
│   └── content_package_validator.gd
├── globals/
│   ├── aero_content_schema.gd
│   ├── content_mode.gd
│   ├── content_difficulty.gd
│   └── interaction_family.gd
├── fixtures/
│   ├── package_minimal_boxing/
│   │   ├── manifest.json
│   │   ├── songs/song-demo.json
│   │   ├── sets/song-demo-opening-round.json
│   │   ├── charts/song-demo-boxing-medium.json
│   │   └── workouts/demo-workout.json
│   └── invalid_missing_song_ref/
├── tests/
│   ├── test_content_manifest_contract.gd
│   ├── test_content_reference_validation.gd
│   └── test_workout_resolution_contract.gd
├── plugin.cfg
├── LICENSE.md
├── README.md
└── addons.jsonc
```

The exact filenames can evolve, but the **shape categories should not**: contracts in `interfaces/`, durable records in `data_types/`, shared structural validation in `validators/`, stable enums/constants in `globals/`, and canonical examples in `fixtures/` + `tests/`.

### Day-one core files and what they mean

#### Durable record contracts

- `data_types/song.gd`
  - canonical `Song` contract
  - audio/timing authority, metadata, licensing references, global tags
- `data_types/set.gd`
  - canonical `Set` contract
  - package-local composition links for one exact playable slice, including song/chart/environment selections and optional coaching overlay or asset selections
- `data_types/chart.gd`
  - canonical `Chart` contract
  - difficulty, interaction family, input-profile compatibility fields, event stream envelope
- `data_types/workout.gd`
  - canonical `Workout` contract
  - session sequencing through ordered `setId` references plus workout-level metadata
- `data_types/chart_envelope.gd`
  - shared top-level chart shape used by all modes
- `data_types/content_package_manifest.gd`
  - package boundary contract for distribution/import/indexing

#### Support contracts

- `data_types/content_id.gd`
  - stable typed ids and/or helper structure for `songId`, `setId`, `chartId`, `workoutId`, `packageId`
- `data_types/content_reference.gd`
  - explicit reference object shape used across packages, workouts, manifests, and registry results
- `data_types/content_query.gd`
  - query/filter/result-key shape used by registry lookup contracts

#### Interfaces

- `interfaces/chart_loader.gd`
  - defines how a consumer asks for chart content by id/path/reference
  - should return shared contracts, not feature-local runtime objects
- `interfaces/content_registry.gd`
  - defines query and lookup semantics for songs, sets, charts, workouts, and resources
  - should describe the interface, not storage or network implementation
- `interfaces/content_migration.gd`
  - defines migration contract and migration report/result semantics
- `interfaces/workout_resolution.gd`
  - resolves workout steps into a concrete playable chart selection without owning runtime playback

#### Shared structural validation

- `validators/content_validation_result.gd`
  - stable validation report shape consumable by tools, runtime, tests, and CI
- `validators/content_validation_issue.gd`
  - issue category, severity, path/reference, and machine-readable code contract
- `validators/content_package_validator.gd`
  - shared structural validator for ids, references, required fields, manifest integrity, and workout resolution legality

#### Global enums/constants

- `globals/aero_content_schema.gd`
  - schema ids, schema families, version constants, and compatibility helpers
- `globals/content_mode.gd`
  - stable mode ids such as `boxing`, `dance`, `step`, `flow`
- `globals/content_difficulty.gd`
  - canonical difficulty vocabulary
- `globals/interaction_family.gd`
  - stable interaction-family vocabulary such as `gesture_2d`, `tracked_6dof`, `hybrid`

#### Example resources and tests

- `fixtures/package_minimal_boxing/*`
  - one tiny but real package proving the contract works end-to-end for a single set/chart/workout path
- `fixtures/invalid_missing_song_ref/*`
  - one intentionally broken package for validator regression coverage
- `tests/*`
  - contract tests proving ids, references, manifest rules, and workout resolution semantics

### Day-one ownership boundaries

`aerobeat-content-core` should own:

- canonical content records
- shared chart envelope
- content ids, references, and manifest primitives
- registry/query interfaces and lookup semantics
- schema/version identifiers and migration interfaces
- shared structural validation contracts and validators
- canonical fixtures and contract tests for the shared content language

`aerobeat-content-core` should depend on:

- no other AeroBeat core repo by default
- only vendor/test dependencies needed to run contract tests

`aerobeat-content-core` must not own:

- editor UX
- CLI command parsing or terminal presentation
- backend upload/download workflow state
- import adapters for third-party file formats
- feature scoring rules
- mode-specific semantic validation that belongs in feature repos
- 2D lane renderers, 3D portal systems, spawn systems, or any other content-consuming runtime visuals
- Godot scenes whose main job is authoring UI or runtime presentation

### Day-one non-goals for `aerobeat-content-core`

Do **not** try to ship all future content infrastructure in the first cut.

Explicit non-goals:

- no registry server or hosted catalog service
- no validator SaaS or background worker service
- no moderation/publishing pipeline
- no web upload flow
- no mode-specific editor plugins
- no cloud sync/index implementation
- no package installer UI
- no runtime caching/streaming optimization layer
- no replacement for feature-local payload semantics

The first repo should be boring in the best way: stable contracts, clean tests, and small fixtures.

## Day-one recommendation: `aerobeat-tool-content-authoring`

### Purpose

`aerobeat-tool-content-authoring` should be the first concrete Tool-lane repo for **authoring and operating on canonical content**.

It is not the owner of the content schema. It is the owner of the workflows that humans and automation use to create, inspect, validate, migrate, package, and transform content that already conforms to `aerobeat-content-core`.

### Day-one directory shape

```text
aerobeat-tool-content-authoring/
├── interfaces/
│   ├── authoring_service.gd
│   ├── package_build_service.gd
│   └── import_export_service.gd
├── services/
│   ├── authoring/
│   │   ├── set_authoring_service.gd
│   │   ├── workout_authoring_service.gd
│   │   └── chart_authoring_service.gd
│   ├── validation/
│   │   ├── validate_package_service.gd
│   │   └── validate_chart_service.gd
│   ├── migration/
│   │   └── migrate_content_service.gd
│   ├── packaging/
│   │   └── build_content_package_service.gd
│   ├── importers/
│   │   ├── audio_metadata_import_service.gd
│   │   └── external_chart_import_service.gd
│   └── registry/
│       └── refresh_content_index_service.gd
├── cli/
│   ├── main.gd
│   ├── commands/
│   │   ├── validate_command.gd
│   │   ├── migrate_command.gd
│   │   ├── package_command.gd
│   │   ├── import_command.gd
│   │   └── inspect_command.gd
│   └── formatters/
│       ├── plain_text_output.gd
│       └── json_output.gd
├── editor/
│   ├── plugins/
│   │   └── content_authoring_plugin.gd
│   ├── docks/
│   ├── inspectors/
│   └── view_models/
├── mappers/
│   ├── content_error_mapper.gd
│   └── validation_report_mapper.gd
├── tests/
│   ├── test_validate_command.gd
│   ├── test_build_content_package_service.gd
│   └── test_editor_uses_shared_services.gd
├── plugin.cfg
├── LICENSE.md
├── README.md
└── addons.jsonc
```

This repo shape intentionally separates **service logic** from **entrypoint surfaces**.

- `services/` is the canonical workflow layer.
- `cli/` is one thin headless surface over those services.
- `editor/` is an optional interactive surface over those same services.

### Shared-service rule: one workflow layer, many entrypoints

This is the most important Tool-lane rule for this repo:

> CLI/headless and editor/interactive workflows should call the same service layer.

That means:

- `cli/commands/validate_command.gd` should call `services/validation/validate_package_service.gd`
- an editor dock "Validate Package" action should call that same validation service
- `cli/commands/migrate_command.gd` and any editor migration wizard should both call `services/migration/migrate_content_service.gd`
- package building from CI should call the same `services/packaging/build_content_package_service.gd` used by any desktop packaging UI

The service layer should accept and return stable DTOs/contracts from `aerobeat-content-core` and `aerobeat-tool-core`, not editor widget state.

### Day-one core files and what they mean

#### Interfaces

- `interfaces/authoring_service.gd`
  - common service boundary for creating/updating canonical content records
- `interfaces/package_build_service.gd`
  - package assembly interface used by both automation and UI
- `interfaces/import_export_service.gd`
  - import/export contract for external format adapters

#### Services

- `services/authoring/set_authoring_service.gd`
  - create/update set records from tool actions while preserving package-local composition rules
- `services/authoring/workout_authoring_service.gd`
  - create/update workout records
- `services/authoring/chart_authoring_service.gd`
  - create/update charts while preserving canonical ids/reference rules
- `services/validation/validate_package_service.gd`
  - run shared structural validation and return normalized reports
- `services/validation/validate_chart_service.gd`
  - focused validation path for a single chart/package slice
- `services/migration/migrate_content_service.gd`
  - apply approved schema migrations and emit migration results/reports
- `services/packaging/build_content_package_service.gd`
  - assemble canonical package outputs from authored records/resources
- `services/importers/audio_metadata_import_service.gd`
  - import audio metadata into canonical `Song` fields
- `services/importers/external_chart_import_service.gd`
  - translate external chart source formats into canonical content-core records
- `services/registry/refresh_content_index_service.gd`
  - rebuild or refresh a local tool-side index/cache while respecting content-core registry semantics

#### CLI/headless surface

- `cli/main.gd`
  - single command entrypoint for headless usage
- `cli/commands/validate_command.gd`
  - validate package/path/id and emit text or JSON
- `cli/commands/migrate_command.gd`
  - run migrations non-interactively
- `cli/commands/package_command.gd`
  - build package artifacts in CI or local automation
- `cli/commands/import_command.gd`
  - import approved external source material into canonical records
- `cli/commands/inspect_command.gd`
  - inspect manifests/records/ids without GUI requirements

#### Optional editor surface

- `editor/plugins/content_authoring_plugin.gd`
  - plugin bootstrap only
- `editor/docks/*`
  - views for charts/sets/workouts/package inspection
- `editor/inspectors/*`
  - record inspectors/editors
- `editor/view_models/*`
  - UI-facing state that adapts service DTOs for presentation

Editor code should orchestrate services and present results. It should not become a second schema or validation engine.

### Day-one ownership boundaries

`aerobeat-tool-content-authoring` should own:

- concrete authoring workflows
- CLI/headless command wiring
- optional editor UX
- import/export adapters
- package-building workflows
- local indexing/inspection helpers for tool usage
- mapping shared validation/migration results into user-facing diagnostics

`aerobeat-tool-content-authoring` should depend on:

- `aerobeat-content-core` for durable content contracts, ids, manifests, validators, and workout resolution interfaces
- `aerobeat-tool-core` for tool-common DTOs, progress models, operation-state contracts, and shared tool-side interfaces
- possibly concrete `aerobeat-feature-*` repos later for mode-specific authoring helpers, but not on day one unless a real use case requires it

`aerobeat-tool-content-authoring` must not own:

- canonical definitions of `Song`, `Set`, `Chart`, or `Workout`
- the shared chart envelope contract
- feature runtime visuals such as 2D lanes or 3D portals
- gameplay scoring/runtime execution logic
- backend moderation queue state unless that work is explicitly split into another tool repo or shared tool-core model

### Day-one non-goals for `aerobeat-tool-content-authoring`

Explicit non-goals:

- no requirement for editor UX before the repo is useful
- no separate ingestion-only repo yet
- no hosted web service requirement
- no replacement of `aerobeat-tool-core`
- no feature/runtime rendering system
- no ownership transfer of schema definitions out of `aerobeat-content-core`
- no assumption that all future authoring needs belong in one forever-repo

The first cut should be **headless-capable immediately** and **editor-capable optionally**.

## Recommended first command surface for the tool repo

To keep the headless requirement real, day one should include a minimal command surface such as:

- `validate <path-or-package-id>`
- `migrate <path> --target-schema <schema>`
- `package build <source> --output <dir>`
- `import audio-metadata <audio-file> --out <song-record>`
- `inspect manifest <path>`
- `inspect workout <workout-id-or-path>`

The exact CLI syntax can vary, but these workflow categories should exist quickly so CI, automation, and non-GUI contributors can use the repo without waiting for editor UX.

## Dependency and ownership summary

### `aerobeat-content-core`

- **Depends on:** no other AeroBeat core repo by default
- **Owned concerns:** durable content contracts and shared structural rules
- **Must not own:** authoring UX, import pipelines, runtime visuals, scoring/runtime behavior

### `aerobeat-tool-content-authoring`

- **Depends on:** `aerobeat-content-core`, `aerobeat-tool-core`
- **Owned concerns:** authoring, validation orchestration, migration workflows, packaging, import/export, inspection, CLI/headless surface, optional editor UX
- **Must not own:** canonical content schema, runtime presentation systems, feature scoring/runtime rules

## Concrete split to preserve on day one

If a new file is being proposed, the routing rule should be:

- Put it in `aerobeat-content-core` when it defines the durable meaning of content shared across runtime and tools.
- Put it in `aerobeat-tool-content-authoring` when it defines a workflow that creates, edits, validates, migrates, packages, imports, or inspects that content.
- Put it in `aerobeat-feature-*` when it is a runtime consumer or visualizer of content, including 2D lanes, 3D portals, spawn systems, scoring flow, or view realization.

That split is what keeps the first repos from collapsing back into a blob.

## Repo-creation recommendation

The docs are now concrete enough to support this sequence:

1. create/stand up `aerobeat-content-core` with the day-one contract shape above
2. land fixtures and contract tests there before building bigger tooling
3. create `aerobeat-tool-content-authoring` with a shared service layer and a minimal CLI/headless surface
4. add optional editor UX only as a thin layer on top of those services

That is the smallest clean shape that matches the approved architecture and keeps ownership aligned with the six-core model.
