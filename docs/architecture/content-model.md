# Content Model: Songs, Charts, Sets, and Workouts

AeroBeat content is authored as a layered model rather than a single flat chart blob or a package full of implicit path wiring.

The durable package hierarchy is now:

- **Song**
- **Chart**
- **Set**
- **Workout**

This structure keeps reusable music truth at the song layer, exact playable authored event streams at the chart layer, package-local composition wiring at the set layer, and package metadata plus set ordering at the workout layer.

Optional coaching still lives in the package's single `coaches/coach-config.yaml` domain, and reusable environments/assets remain first-class package-local content records.

## Current schema direction

As of 2026-04-27, the current naming and shape direction is:

- Use consistent `*Id` + `*Name` fields across the core records where applicable:
  - `songId`, `songName`
  - `chartId`, `chartName`
  - `setId`, `setName`
  - `workoutId`, `workoutName`
- All primary ids are UIDs.
- Authored YAML records should carry shared schema/provenance fields such as `schemaId`, `schemaVersion`, `recordVersion`, `createdByTool`, `createdByToolVersion`, `createdAt`, and `updatedAt`; the one deliberate exception is a disabled `coaches/coach-config.yaml` sentinel that may be only `enabled: false`.
- `Chart` is the durable term for one concrete playable difficulty slice.
- `Set` is the durable package-composition linker. It binds together exact referenced ids for one song, one chart, one environment selection, zero-or-one asset selection per gameplay-facing asset type, and optional coaching overlay media.
- `Workout` resolves to an ordered list of `setId` values. It does not inline full composition details.
- `Song` records do not link to charts, sets, or workouts.
- `Chart` records do not link to songs or sets.
- Athlete/device-specific timing calibration such as song offset does not belong in durable content data; it belongs in athlete/profile/device state.
- Workout coaching is owned by the package's single `coaches/coach-config.yaml`; enabled coaching requires roster + warmup + cooldown + an overlay registry whose records use `overlayId`, while set files reference that registry via `coachingOverlayId`.
- Boxing charts should be documented and exemplified with a flat `beats` list where each beat has `start`, optional inclusive `end`, concrete `type`, and optional integer `portal` (`0-11`) rather than legacy shorthand or nested boxing payload fields.
- Flow charts should use the same flattened `beats` list, with Flow-specific optional `placement` (`0-12`) and `direction` (`0-11`) added only where the selected Flow `type` supports them.

## Canonical ownership

The canonical contracts for `Song`, `Chart`, `Set`, `Workout`, the shared chart envelope, and shared content loading / validation interfaces live in [`aerobeat-content-core`](https://github.com/AeroBeat-Workouts/aerobeat-content-core).

[`aerobeat-feature-core`](https://github.com/AeroBeat-Workouts/aerobeat-feature-core) consumes those contracts to define gameplay-mode/runtime rules. It does not own the durable content primitives.

[`aerobeat-tool-core`](https://github.com/AeroBeat-Workouts/aerobeat-tool-core) and tool repos consume the same content contracts so authoring, validation, ingestion, and runtime all speak the same content language.

Concrete authoring products belong under the `aerobeat-tool-*` family, not under `aerobeat-content-*`. `aerobeat-content-core` owns the durable content language; concrete tool repos own the author-facing workflows that create, edit, validate, migrate, package, import, and publish that content.

## Why AeroBeat needs `Set`

`Set` is the missing durable linker between exact playable authored content and an ordered workout program.

A `Song` alone is too low-level. It knows about the audio timeline, credits, and metadata, but it does not know which chart, environment, assets, or coaching overlay should be used for a specific workout slice.

A `Chart` alone is also too low-level. It owns one exact playable event stream, but it should not be responsible for pointing back to a song record or outward to package-local presentation/coaching choices.

A `Workout` is too high-level to own every composition detail inline. It should describe package metadata plus the intended sequence of set ids.

`Set` is the correct place for:

- the exact song selected for a playable slice
- the exact chart selected for that slice
- the environment selection for that slice
- zero-or-one asset selection per gameplay-facing asset type
- the optional coaching overlay selection for that slice
- any lightweight teaching metadata that belongs to one linked workout slice rather than to the reusable song or chart records

Examples:

- one song can be used by multiple sets across different workouts
- one chart can stay reusable without knowing which song/environment/assets will be paired with it in a specific package
- a workout can pick an easier opener set and a harder finisher set by ordering exact `setId` values

## Core primitives

### 1. Song

A `Song` is the reusable music and timing source.

It owns fields such as:

- `songId`
- `songName`
- artist / credits / licensing metadata
- `licensing.licenseType` from the locked enum (`unknown`, `cc0_public_domain`, `cc_by`, `cc_by_sa`, `cc_by_nd`, `cc_by_nc`, `cc_by_nc_sa`, `cc_by_nc_nd`, `creator_noncommercial`, `creator_commercial`, `licensed_noncommercial`, `licensed_commercial`)
- `licensing.streamingSafe` as a required boolean
- `licensing.aiAssisted` as a required boolean, plus structured AI disclosure fields when that value is `true`
- audio asset references
- duration
- song-level canonical timing truth through `timing.anchorMs`, `timing.tempoSegments`, `timing.stopSegments`, and `timing.timeSignatureSegments`
- descriptive metadata such as `metadata.explicit`, BCP 47 `metadata.language` values, and locked-enum `metadata.genres`

It does **not** own gameplay-mode-specific note data, chart references, set references, workout references, athlete/device-specific timing offsets, or freeform song `tags` in the current v1 contract.

### 2. Chart

A `Chart` is one concrete playable authored sequence.

It owns fields such as:

- `chartId`
- `chartName`
- `feature`
- difficulty
- beat-timed authored content aligned to the song-owned canonical timing truth
- boxing-specific `beats` payloads for the current locked boxing pass
- any future cross-feature chart fields that are explicitly promoted into the shared contract later

A chart represents **one playable difficulty / compatibility slice**, not an all-difficulties megafile.

A chart does **not** point back to a song or forward to a set. That wiring belongs to the set layer.

Feature-global tuning such as hit windows should not live in authored chart data. Those belong in feature rules rather than in each chart record.

#### Why difficulty belongs here

AeroBeat does not store all difficulties as peer event arrays inside one giant chart by default.

Separate charts give us:

- cleaner diffs and version control
- easier validation
- easier tooling
- fewer edit collisions between contributors
- room for alternate compatibility slices later without forking a larger composite record

### 3. Set

A `Set` is one authored workout-composition record.

It owns the exact package-local wiring for one playable slice, including fields such as:

- `setId`
- `setName`
- `songId`
- `chartId`
- `environmentId`
- `assetSelections`
- optional `coachingOverlayId`

`assetSelections` is a keyed map by gameplay-facing asset type. The locked v1 `assetType` enum is intentionally narrow:

- `gloves`
- `targets`
- `obstacles`
- `trails`

A set is intentionally the **single source of truth for workout composition details**. That means the set record owns the id-to-id linking for song/chart/environment/assets/coaching overlay selection instead of duplicating that wiring in `workout.yaml`, song files, or chart files.

### 4. Workout

A `Workout` is a training program package root.

It owns fields such as:

- `workoutId`
- `workoutName`
- `description`
- `coachConfigId` referencing the package's single coach-config domain
- package/version/tool provenance metadata
- preview media metadata
- ordered list of `setId` values

When coaching is enabled, the package's single coach-config domain owns the coach roster, warmup video, cooldown video, and overlay-media registry. `workout.yaml` points at coach-config but does not own those media references directly.

Workout runtime length is derived from the referenced content rather than stored as a separate authored duration field.

## Shared chart envelope

AeroBeat uses **one shared chart envelope** across gameplay features, with **feature-specific payloads** inside it.

This keeps tooling, loading, validation, and runtime contracts coherent without pretending that Boxing and Step are authored with the exact same payload vocabulary.

The shared chart envelope is owned by `aerobeat-content-core` because it is part of the durable authored-content contract. Feature repos consume it and interpret it.

### Shared fields

All charts expose a common envelope containing fields such as:

- `schemaId`
- `chartId`
- `chartName`
- `feature`
- `difficulty`

For the current locked boxing pass, the authored gameplay payload lives under `beats`, not `events`, and each boxing beat uses the flat shape `start` / `end?` / `type` / `portal?`.

### Feature-specific payloads

The meaning of the authored gameplay payload depends on the chart feature.

For **Boxing**, the current locked authored payload is a flat `beats` list using concrete move `type` values such as:

- `jab`, `cross`
- `hook_left`, `hook_right`
- `uppercut_left`, `uppercut_right`
- `guard`
- `orthodox`, `southpaw`
- `squat`, `lean_left`, `lean_right`
- `sidestep_left`, `sidestep_right`
- `knee_left`, `knee_right`
- `leg_lift_left`, `leg_lift_right`
- `run_in_place`

Boxing does **not** author `zone`, symbolic portal strings, nested subtype payloads, or old boxing timing fields such as `holdMs` / `durationMs` in this pass.

For **Flow**, the current locked authored payload is also a flat `beats` list. Each beat uses required `start`, optional inclusive `end`, required `type`, optional integer `portal` (`0-11`), optional integer `placement` (`0-12`), and optional integer `direction` (`0-11`).

The current approved Flow type pool is:

- `swing_left`, `swing_right`
- `trail_left`, `trail_right`
- `warn_left`, `warn_right`
- `reward_left`, `reward_right`
- `squat`, `lean_left`, `lean_right`
- `knee_left`, `knee_right`
- `leg_lift_left`, `leg_lift_right`
- `run_in_place`

Flow field support is intentionally explicit:

- `swing_*`, `trail_*`, and `warn_*` support both `placement` and `direction`
- `reward_*` supports `placement` only
- `squat`, `lean_*`, `knee_*`, `leg_lift_*`, and `run_in_place` support neither

For `swing_*`, `trail_*`, and `warn_*`, omitted `direction` inherits from `placement`.

For **Dance**, the current approved authored payload is also a flat `beats` list. Each beat uses required `start`, optional inclusive `end`, required `type`, and optional boolean `gold`.

Dance field support is intentionally minimal:

- the chart stores the expected move id over time
- `gold` marks authored highlight emphasis only
- scoring logic, classifier/runtime interpretation, coach behavior, pictograms/dance cards, cue systems, and move-performance semantics stay outside the chart row
- `portal`, `placement`, and `direction` are not part of the first-pass Dance payload

Step payload details remain follow-up work. The loader contract is shared, but this document does not try to prematurely force Step's authored vocabulary to match boxing, Flow, or Dance exactly.

## Interaction families, not raw devices

Charts target **interaction semantics**, not raw hardware bindings.

Do **not** author charts directly against devices such as webcam, JoyCon, headset, or keyboard. Those are runtime input strategies and profiles, not durable content primitives.

### Recommended interaction families

- `gesture_2d`
  - camera tracking
  - mouse / touch
  - keyboard / gamepad fallback mappings
  - some JoyCon mappings
- `tracked_6dof`
  - XR controllers
  - tracked hands in world space
- `hybrid`
  - content deliberately authored to adapt across both families with explicit runtime rules

### Why this matters

This preserves AeroBeat's input-agnostic architecture:

- content stays reusable longer
- runtime adapters can map the same authored semantics to multiple devices
- validated compatibility can be recorded without pretending every device behaves identically
- device-specific extensions can be added later without forking the entire content model

### Compatibility metadata remains follow-up work

Use interaction-family thinking to keep charts device-agnostic, but do not treat the current boxing pass as authoring chart fields such as `interactionFamily`, `supportedInputProfiles`, or `validatedInputProfiles`.

Those compatibility/profile details may still be recorded elsewhere in tooling or promoted into a future shared chart contract, but they are not part of the locked flattened boxing authored schema documented above.

## View modes belong mostly to runtime presentation

View modes such as Portal View, Track View, 3-Portal View, and 360-Portal View are treated primarily as **presentation and runtime interpretation concerns**, not as separate chart families.

For the current boxing pass, authored charts should stay portable by expressing only the flattened boxing `beats` payload. Do not teach boxing-specific chart fields for preferred views, portal layouts, mirror-camera preferences, or similar presentation hints here.

### Authoring rule

Author the athlete interaction first.

Then let the runtime render that interaction as:

- 3D incoming portal targets
- 2D track lanes
- folded 360-to-front fallback layouts
- multi-portal or simplified mobile representations

If a future feature truly requires view-specific authored data that cannot be derived, add that as an explicit extension later rather than treating it as part of the current boxing contract.

### Runtime-visual ownership rule

Concrete visual realizations stay out of the current content lane. 2D lane renderers, 3D portal implementations, multi-portal layouts, world-space spawn systems, and other content-consuming runtime visuals belong in `aerobeat-feature-core` or concrete `aerobeat-feature-*` repos. They may depend on `aerobeat-content-core`, but they do not move into it.

## Package-level composition recap

A self-contained workout package now typically contains:

- one `workout.yaml`
- one or more `songs/*.yaml`
- one or more `charts/*.yaml`
- one or more `sets/*.yaml`
- zero or one `coaches/coach-config.yaml`
- zero or more `environments/*.yaml`
- zero or more `assets/*.yaml`

The individual `Song`, `Chart`, `Set`, `Workout`, `Coach Config`, `Environment`, and `Asset` records inside that package remain the unit of authoring, validation, and runtime selection.

## Contract boundaries that matter

### Song contract

The `Song` contract is responsible for reusable audio/media identity, canonical timing truth, and licensing/credit metadata.

It is **not** responsible for:

- mode-specific gameplay packaging
- difficulty selection
- set composition
- environment selection
- coaching overlay selection

### Chart contract

The `Chart` contract is responsible for one exact playable authored sequence for one feature/difficulty slice.

It is **not** responsible for:

- song lookup ownership
- package-local environment or asset selection
- workout ordering
- coaching media registry

### Set contract

The `Set` contract is responsible for exact package-local composition wiring.

It is **not** responsible for:

- global browse/discovery metadata
- reusable song licensing/timing truth
- reusable coaching roster/media registry
- athlete/profile-specific runtime overrides

### Workout contract

The `Workout` contract is responsible for package identity plus the ordered sequence of authored set ids.

It is **not** responsible for:

- inlining the full set composition payload
- owning chart event data
- owning song licensing/timing truth
- owning coaching media paths directly

## Tooling implication

Tools should load package content in this order:

1. `workout.yaml`
2. referenced `sets/*.yaml`
3. referenced `songs/*.yaml`
4. referenced `charts/*.yaml`
5. package `coaches/coach-config.yaml` when present
6. referenced `environments/*.yaml`
7. referenced `assets/*.yaml`

That keeps package-level orchestration explicit while leaving reusable authored records decoupled.

## Durable package contract summary

Keep the package shape explicit and set-centered:

- `songs/*.yaml` are reusable audio/licensing records that also own the canonical timing map through `anchorMs`, `tempoSegments`, `stopSegments`, and `timeSignatureSegments`
- `charts/*.yaml` are reusable exact playable slices
- `sets/*.yaml` are the single source of truth for composition wiring
- `workout.yaml` keeps package/workout metadata plus ordered `setId` references
- `coach-config.yaml` is a coaching media/roster registry that set records can reference through `coachingOverlayId`

That split keeps authored responsibilities cleaner and removes duplicated linkage.
