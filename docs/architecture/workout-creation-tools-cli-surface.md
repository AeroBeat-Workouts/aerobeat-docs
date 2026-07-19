# Workout Creation Tools CLI Surface

This document defines the current canonical CLI surface for the AeroBeat **manual-authored workout-package** creation tools repo.

> **Scope note:** these commands describe the authored-package lane. They are not the default imported-player contract, so coaching- and environment-heavy workflow surfaces here should be read as authored-package tooling rather than universal AeroBeat content requirements.

It extends the locked product and repo direction already captured in:

- `docs/architecture/workout-creation-tools-architecture.md`
- `docs/architecture/content-repo-shapes.md`
- `docs/architecture/content-lane-implementation-phases.md`
- `docs/architecture/workout-package-storage-and-discovery.md`

The goal of this document is to make the first CLI slice actionable without prematurely freezing low-level implementation details.

## Purpose

The workout creation tools repo needs a **headless-first** surface that creators, CI, automation, and future GUI/editor flows can all rely on.

That CLI surface exists to support the package-authoring workflows already locked for the product:

- validate authored records and complete workout packages
- inspect package structure and resolved relationships
- repair safe structural/content problems through explicit fix flows
- migrate authored records between approved schema/layout versions
- package validated content into distributable outputs
- import approved source media and external authoring inputs into canonical package form

## Locked CLI direction

### Separate public tools early

The locked direction is to keep **separate public CLI tools early**, one per authored YAML domain or package-level workflow surface, rather than collapsing everything into one large primary CLI with a deep subcommand tree.

That means the public surface should stay visibly split across the current package domains:

- `workout`
- `song`
- `chart`
- `set`
- `coach-config`
- `environment`

The exact executable names may evolve, but the domain split should remain explicit.

## Public tool set

### Package-orchestrator tool

The `workout` tool is the package-wide orchestrator because `workout.yaml` is the package root and owns the ordered `setId` list.

Its responsibilities include:

- package-wide validation orchestration
- package-wide repair orchestration
- package-wide migration orchestration when the whole package must move together
- package-wide packaging/build entrypoints
- package-home inspection of overall health, references, and topology
- routing package import workflows that affect package-level structure or multiple domains

### Domain tools

The other public tools are domain-specific surfaces for authored records that live under the package root:

- `song`
- `chart`
- `set`
- `coach-config`
- `environment`

Their primary job is to own domain-local workflows without pretending to be full-package authority.

## Canonical executable naming direction

The repo should ship separate executables with names that make the split obvious.

Current canonical naming direction:

- `aerobeat-workout`
- `aerobeat-song`
- `aerobeat-chart`
- `aerobeat-set`
- `aerobeat-coach-config`
- `aerobeat-environment`

This document does **not** lock packaging/distribution details such as whether these are standalone wrappers, symlinked launchers, or thin entry scripts over a shared binary/runtime. It only locks the **public CLI surface split**.

## Shared rules across all CLI tools

### Command categories

The minimum durable workflow categories across the repo are:

- `validate`
- `fix`
- `inspect`
- `migrate`
- `package`
- `import`

Not every category belongs equally on every domain tool. The surface should stay honest about which commands are domain-local and which are package-level orchestration.

### Validation rule

Plain validation must **report problems, not silently mutate content**.

If a package or record is invalid:

- validation should hard-error
- output should explain the problem in creator-friendly language
- machine-readable output should also be available for CI/automation
- fixable issues should direct the user toward explicit `fix` flows

### Fix rule

Repair is always explicit.

- broad repair should use `fix`
- narrower repair entrypoints may use more specific forms such as `fix-ids`, `fix-layout`, or similar names when justified
- validation must not auto-run repair as a hidden side effect

### Accepted-vs-stored format rule

Import-oriented commands must preserve the locked distinction between:

- accepted source/import formats
- stored canonical package formats

That means import flows may accept broader source media types, but package storage must still converge on the locked canonical directions where applicable:

- song audio stored as `.ogg`
- coaching audio stored as `.ogg`
- coaching video stored as `.ogv`
- environment video stored as `.ogv`
- images stored as `.png`
- 3D environments stored as vanilla `.glb`

### Media normalization rule

When import or replacement commands handle media, they should route through the shared FFmpeg-backed normalization workflow where relevant before updating package references.

### Output rule

Each public CLI tool should support at least:

- human-readable terminal output
- structured JSON output for automation

The document does not lock exact flags, but a conventional form such as `--format text|json` or `--json` is expected.

## Package-level vs domain-level authority

### `workout validate` is the package-wide validator

The central validation boundary is locked:

- `aerobeat-workout validate` performs full package validation
- it walks `workout.yaml`, ordered `setId` values, and the referenced song/chart/environment/coach-config records
- it verifies package topology, cross-record id integrity, and package-level rules
- it may call the lower-level validators for referenced records internally

### Domain validation is not secretly package validation

The domain tools must stay narrower:

- `aerobeat-song validate` validates song-record shape, song-local rules, and directly referenced file existence relevant to the song domain
- `aerobeat-chart validate` validates chart-record shape and chart-local rules
- `aerobeat-set validate` validates set-record shape and direct set-local reference integrity
- `aerobeat-coach-config validate` validates the workout package's single coaching domain record
- `aerobeat-environment validate` validates environment-record shape and directly referenced environment media

Those commands may be used independently during authoring, but they do not imply whole-package health.

## Baseline command surface by tool

## `aerobeat-workout`

### Purpose

Package-home surface for complete workout package workflows.

### Baseline commands

- `validate <workout-path-or-package-dir>`
  - run package-wide validation
  - resolve and validate referenced sets, songs, charts, coach config, environments, and package layout rules
- `fix <workout-path-or-package-dir>`
  - run package-wide safe structural/content repair after explicit user request
- `inspect <workout-path-or-package-dir>`
  - show package metadata, ordered sets, high-level health, schema/tool provenance, and unresolved reference summaries
- `migrate <workout-path-or-package-dir> --target <schema-or-tool-version>`
  - run package-wide migration when coordinated changes must happen across package records
- `package <workout-path-or-package-dir> --output <dir>`
  - produce the distributable package artifact(s)
- `import <package-dir> ...`
  - package-level import flows only when they create or update package-wide structure, bootstrap a package, or coordinate multiple domain changes

### Clearly justified import-oriented commands

The package-level tool may own commands such as:

- `import package-shell <dir>`
  - bootstrap a new package folder with canonical subfolders and starter files
- `import workout-metadata <source> <package-dir>`
  - populate package-home metadata from an approved source when that workflow proves useful

This tool should **not** absorb every import case by default. Slot- and record-specific imports should stay on the domain tools when that keeps ownership cleaner.

## `aerobeat-song`

### Purpose

Own song-record authoring operations and canonical song-audio slot workflows.

### Baseline commands

- `validate <song-yaml>`
- `fix <song-yaml>`
- `inspect <song-yaml>`
- `migrate <song-yaml> --target <schema-or-tool-version>`
- `import audio <source-file> --record <song-yaml>`

### Notes

- `import audio` should validate the source for song-audio use, normalize it into canonical stored `.ogg`, place it into the package media location, rename it to the normalized uid-suffixed pattern, update YAML references, and remove the superseded slotted asset on replacement.
- `package` is not a baseline `song` command because packaging is a package-level concern.

## `aerobeat-chart`

### Purpose

Own chart-record validation, migration, inspection, and import/conversion workflows for chart-authored data.

### Baseline commands

- `validate <chart-yaml>`
- `fix <chart-yaml>`
- `inspect <chart-yaml>`
- `migrate <chart-yaml> --target <schema-or-tool-version>`
- `import <external-chart-source> --record <chart-yaml>`

### Notes

- Import here is justified because external chart conversion is a chart-domain workflow.
- `package` is not a baseline `chart` command.
- Future chart testing helpers may exist later, but they are not locked as day-one baseline CLI surface in this document.

## `aerobeat-set`

### Purpose

Own set-record shape, exact package-local composition wiring, and structural repair of set-local references.

### Baseline commands

- `validate <set-yaml>`
- `fix <set-yaml>`
- `inspect <set-yaml>`
- `migrate <set-yaml> --target <schema-or-tool-version>`

### Notes

- A set record links `songId`, `chartId`, `environmentId`, and optional `coachingOverlayId`.
- No baseline `package` command belongs here.
- No separate baseline import command is required unless a real external source format for set composition emerges.

## `aerobeat-coach-config`

### Purpose

Own the workout package's single coaching-domain record and the workflow around coaching media slots.

### Baseline commands

- `validate <coach-config-yaml>`
- `fix <coach-config-yaml>`
- `inspect <coach-config-yaml>`
- `migrate <coach-config-yaml> --target <schema-or-tool-version>`
- `import warmup-video <source-file> --record <coach-config-yaml>`
- `import cooldown-video <source-file> --record <coach-config-yaml>`
- `import overlay-audio <source-file> --record <coach-config-yaml> --overlay-id <id>`

### Notes

- Video imports should normalize accepted source video into canonical stored `.ogv`.
- Overlay audio imports should normalize accepted source audio into canonical stored `.ogg`.
- The tool should preserve the locked optional-all-or-nothing coaching model already documented elsewhere.

## `aerobeat-environment`

### Purpose

Own environment-record validation, inspection, migration, and environment-media import helpers.

### Baseline commands

- `validate <environment-yaml>`
- `fix <environment-yaml>`
- `inspect <environment-yaml>`
- `migrate <environment-yaml> --target <schema-or-tool-version>`
- `import background-image <source-file> --record <environment-yaml>`
- `import background-video <source-file> --record <environment-yaml>`
- `import glb <source-file> --record <environment-yaml>`

### Notes

- Image imports should support the bounded crop/fit workflow already described in the architecture direction before canonical `.png` storage.
- Video imports should normalize to canonical stored `.ogv`.
- 3D environment imports should preserve the current locked vanilla `.glb` storage direction rather than reopening Draco/KTX2 work.

## Public CLI boundary vs shared internal libraries

### What is public

The public surface of the repo is the set of creator-facing/automation-facing CLI tools and their commands.

These public tools own:

- argument parsing and command routing
- terminal and JSON presentation
- exit codes
- user confirmation prompts where needed
- stable workflow naming visible to creators and CI

### What stays internal

The repo should also keep a shared internal workflow layer that is **not** treated as the public CLI contract.

That internal layer should own reusable services such as:

- validation services
- fix/repair services
- migration services
- package assembly services
- import and normalization services
- package graph loading and reference resolution
- record read/write helpers
- file replacement and canonical naming helpers
- diagnostics/result DTO mapping

### Why this boundary matters

This keeps the repo aligned with the already-locked rule that CLI and GUI/editor flows should call the same underlying services where possible.

The public CLI tools are separate because the workflow surfaces are separate.
The implementation should still reuse shared services so the repo does not grow six unrelated repair engines.

## Recommended internal shape

A practical first-pass internal split is:

- `cli/` or equivalent launchers for each public tool
- `services/validation/`
- `services/fix/`
- `services/migration/`
- `services/packaging/`
- `services/import/`
- `services/package_graph/`
- `services/io/`
- `mappers/` or `formatters/` for terminal/JSON output adaptation

The exact folders may change, but the architectural boundary should remain:

- **public tool surfaces are separate**
- **shared workflow implementation is reused internally**

## Exit-code and automation expectations

Each tool should be safe for CI and scripting.

Baseline expectations:

- success exits non-zero only on actual failure
- validation failures return a failing exit code
- malformed CLI usage returns a distinct failing exit code
- `inspect` can be consumed by humans and JSON-based automation
- package-wide workflows should emit enough machine-readable detail for future editor integration and CI summary generation

This document does not lock a full numeric exit-code matrix yet.

## Non-goals for this slice

This CLI surface spec does **not** promise:

- one universal `aerobeat` CLI hiding the domain split
- full-package validation from every domain validator
- auto-repair during plain validation
- GUI/editor command parity in day-one syntax
- broad media-production tooling beyond bounded import/normalization workflows
- low-level parser/runtime implementation details
- current-scope KTX2 texture optimization or Draco-compressed GLB pipelines

## Recommended implementation posture

Implementation should proceed in this order:

1. stand up the shared internal service layer for validation, fix, migration, import, and packaging
2. ship `aerobeat-workout validate` first so package-wide orchestration is real early
3. ship the domain-local `validate` and `inspect` commands next
4. add explicit `fix` flows rather than hidden repair behavior
5. add import commands for song audio, coaching media, environment media, and chart conversion
6. add migration and packaging flows once the base package graph and canonical I/O are stable

That order preserves the most important locked boundary: the workout creation product is one repo and one product, but its CLI should still expose **separate domain tools with a package-wide workout orchestrator surface**.
