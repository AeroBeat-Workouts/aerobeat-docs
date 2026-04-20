# Content Lane Implementation Phases

This document turns the approved Content lane architecture into a practical delivery sequence.

It assumes the six-core lane model already decided in the architecture docs:

- `aerobeat-content-core` owns durable authored-content contracts
- `aerobeat-feature-core` and concrete feature repos consume those contracts at runtime
- `aerobeat-tool-core` and concrete tool repos consume the same contracts for authoring, validation, and ingestion flows

The goal is to avoid collapsing contracts, authoring tools, importers, registries, and gameplay runtime into one repo or one implementation pass.

## Planning rules

1. **Contracts first, tooling second, runtime integration third.**
2. **`aerobeat-content-core` owns canonical shapes; tool repos do not redefine them.**
3. **Mode-specific validation may extend the system, but cross-mode content validation starts in the shared content lane.**
4. **Do not create a new repo until one repo would otherwise hold two distinct ownership domains or release cadences.**
5. **Runtime repos consume validated content contracts; they should not become the source of truth for package structure or schema rules.**

## Phase 1 — Docs and contract decisions

### Goal
Freeze the architecture and vocabulary well enough that implementation repos can be created without re-litigating the model.

### Deliverables
- canonical docs for `Song`, `Routine`, `Chart Variant`, and `Workout`
- explicit ownership language for `aerobeat-content-core`, `aerobeat-feature-core`, and `aerobeat-tool-core`
- documented shared chart envelope and interaction-family targeting rules
- documented package/file relationship for song, routine, chart-variant, and workout artifacts
- documented decision on what belongs to content contracts vs tool workflows vs runtime interpretation

### Required decisions before code starts
- canonical ids/references for song, routine, chart variant, and workout
- minimum chart envelope fields
- which presentation hints are durable content fields versus runtime-only concerns
- whether workouts default to routine+difficulty selection or exact chart ids
- which validation responsibilities are shared across all content versus delegated to feature repos

### Exit criteria
- docs no longer describe a universal core hub
- content ownership is consistent across overview, topology, repo-map, workflow, and content-model docs
- the content package boundary is clear enough to generate fixtures and tests in `aerobeat-content-core`

## Phase 2 — Shared `aerobeat-content-core` contract implementation

### Goal
Stand up the dependency-light shared repo that owns the content model and loader-facing contracts.

### `aerobeat-content-core` should contain
- data/resource contracts for `Song`, `Routine`, `Chart Variant`, and `Workout`
- shared chart-envelope types
- content references, ids, metadata, and manifest primitives
- loader/registry interfaces used by both runtime and tools
- shared content validation result types
- workout selection/sequencing contracts that are mode-agnostic
- fixtures and contract tests for canonical example content

### `aerobeat-content-core` should not contain
- gameplay scoring rules
- device/provider implementation details
- editor UI
- ingestion-side API clients or service orchestration
- mode-specific runtime systems that belong in feature repos

### Recommended repository action
- **Create `aerobeat-content-core` immediately** if it does not already exist. This repo is justified by the six-core model and is the canonical owner of the lane.

### Exit criteria
- a consumer can load the shared contract layer without depending on a specific feature repo
- content fixtures exist for at least one routine and one workout path
- feature and tool repos can import the same content contracts without duplicating types

## Phase 3 — Validation, registry, and schema-version foundations

### Goal
Add the machinery that makes content safe to evolve and safe to consume.

### Shared responsibilities that still belong in the content lane
- schema-version fields and compatibility policy
- manifest/package primitives
- content registry interfaces and lookup keys
- shared validation categories such as missing references, malformed timing blocks, invalid metadata, and unsupported interaction-family declarations
- migration surface definitions for forward/backward compatibility where feasible

### Split of responsibility
- **`aerobeat-content-core` owns** validation result models, manifest/registry contracts, schema/version identifiers, and shared validators for cross-mode structural integrity.
- **`aerobeat-feature-core` / feature repos own** mode-specific semantic validation, such as whether Boxing events are legal for Boxing rules.
- **`aerobeat-tool-core` / tool repos own** validator orchestration UX, batch import flows, editor diagnostics presentation, and external system hooks.

### Recommended repository action
- **Do not create a separate validation repo yet.** Keep validation contracts and cross-mode structural validators in `aerobeat-content-core` until there is real pressure for a separately deployable validator service.
- **Do not create a separate registry service repo yet.** First define registry interfaces and local/package-backed lookup behavior in shared contracts.

### Exit criteria
- every content artifact declares a schema/version path
- registry lookup rules are documented and testable
- contract tests can distinguish shared structural failures from feature-specific semantic failures

## Phase 4 — Tool-core, authoring, and ingestion implementation

### Goal
Build tooling against the stabilized content contracts instead of inventing tool-local schemas.

### `aerobeat-tool-core` responsibilities in this phase
- tool-side models for import jobs, validation sessions, persistence/settings needed by tools
- stable interfaces for tool workflows that operate on content-core contracts
- shared diagnostics/result plumbing used by authoring or ingestion apps

### Concrete tool work expected after `content-core` stabilizes
- chart/routine authoring flows
- workout authoring flows
- import/ingestion flows from source audio/metadata/chart sources
- validation runners used by CLI/editor tooling

### Recommended repository actions
Create concrete tool repos only when ownership or release cadence becomes distinct:

1. **Likely next repo:** `aerobeat-tool-content-authoring`
   - justified once there is enough editing workflow to warrant its own release surface
   - should consume `aerobeat-content-core` and `aerobeat-tool-core`
2. **Likely later repo:** `aerobeat-tool-content-ingestion`
   - justified only when import/conversion pipelines become substantial enough to stand apart from authoring
   - should not become the canonical owner of schema definitions
3. **Optional later split:** dedicated workout/choreography editor repo
   - only justified if workout programming diverges materially from chart authoring

### Not yet justified
- separate validator SaaS/service repo
- separate registry backend repo
- separate workout-only repo before there is clear workflow divergence

### Exit criteria
- at least one tool path can author or edit a routine/chart using only shared contracts
- ingestion can emit canonical content artifacts without hand-written post-fixups in runtime repos
- tool diagnostics map cleanly back to shared schema/validator results

## Phase 5 — Playback and runtime integration

### Goal
Connect the approved content contracts to live feature/runtime behavior without moving ownership out of the content lane.

### Runtime integration responsibilities
- `aerobeat-feature-core` defines how gameplay systems consume chart events, scoring windows, and runtime interpretation rules
- concrete `aerobeat-feature-*` repos implement mode-specific loaders/adapters on top of shared chart envelopes and mode payloads
- assemblies compose the necessary cores and concrete repos through GodotEnv
- runtime selection logic resolves workout → routine/chart selection using content-core references and validated manifests

### Important constraint
Playback integration should consume the schema/version and registry contracts from the content lane. Runtime repos may cache, adapt, or optimize content, but they should not quietly fork the canonical content model.

### Recommended repository action
- **No new content repo is required for playback integration.** This work belongs in `aerobeat-feature-core`, concrete feature repos, and assembly repos already documented.

### Exit criteria
- one end-to-end path can load validated content artifacts into a feature runtime
- workout selection can resolve into a concrete playable chart path
- runtime errors can be traced back to shared content ids/manifests rather than ad hoc feature-local assumptions

## Recommended repo creation order

Create repos only when their ownership is already clear from the phase plan:

1. **`aerobeat-content-core`** — required now; canonical lane owner
2. **`aerobeat-tool-content-authoring`** — next likely concrete tool repo once contract implementation exists
3. **`aerobeat-tool-content-ingestion`** — only after import/conversion workflows become distinct enough
4. **Optional dedicated workout/choreography tool repo** — only if authoring workflows diverge enough to justify the split

## Recommended implementation sequence summary

1. finish docs and contract decisions in `aerobeat-docs`
2. create/stand up `aerobeat-content-core`
3. add shared schema-version, manifest, registry, and structural validation foundations there
4. wire `aerobeat-tool-core` and the first concrete authoring workflow against those shared contracts
5. add ingestion only when it is materially different from authoring
6. integrate playback/runtime in `aerobeat-feature-core` and feature repos using the same validated content contracts

That sequence keeps ownership aligned with the six-core architecture and avoids the common failure mode where tools or feature runtimes become the accidental source of truth for authored content.
