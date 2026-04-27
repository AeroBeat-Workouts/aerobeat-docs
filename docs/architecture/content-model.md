# Content Model: Songs, Routines, Charts, and Workouts

AeroBeat content is authored as a layered model rather than a single flat chart blob or a set of unrelated per-mode file formats.

The durable hierarchy is:

- **Song**
  - **Routine**
    - **Chart**
- **Workout**
  - ordered selections of exact chart UIDs

This structure keeps audio and licensing metadata reusable at the song layer, keeps gameplay-mode semantics at the routine layer, keeps difficulty-specific authored event streams at the chart layer, keeps workout set programming at the workout layer, and keeps optional coaching media/config in the package’s single coach-config domain.

## Current schema direction

As of 2026-04-23, the current naming and shape direction is:

- Use consistent `*Id` + `*Name` fields across the core records where applicable:
  - `songId`, `songName`
  - `routineId`, `routineName`
  - `chartId`, `chartName`
  - `workoutId`, `workoutName`
- All primary ids are UIDs.
- `Routine` means one `Song` interpreted through one gameplay `mode`.
- `Chart` is the durable term for one concrete playable difficulty slice.
- Workouts resolve to exact referenced UIDs rather than loose song/mode/difficulty selectors.
- Athlete/device-specific timing calibration such as song offset does not belong in durable content data; it belongs in athlete/profile/device state.
- Workout coaching is owned by the package’s single `coaches/coach-config.yaml`; enabled coaching requires roster + warmup + cooldown + exactly one overlay audio clip per workout set keyed by `setId`.

## Canonical ownership

The canonical contracts for `Song`, `Routine`, `Chart`, `Workout`, the shared chart envelope, and shared content loading / validation interfaces live in [`aerobeat-content-core`](https://github.com/AeroBeat-Workouts/aerobeat-content-core).

[`aerobeat-feature-core`](https://github.com/AeroBeat-Workouts/aerobeat-feature-core) consumes those contracts to define gameplay-mode/runtime rules. It does not own the durable content primitives.

[`aerobeat-tool-core`](https://github.com/AeroBeat-Workouts/aerobeat-tool-core) and tool repos consume the same content contracts so authoring, validation, ingestion, and runtime all speak the same content language.

Concrete authoring products belong under the `aerobeat-tool-*` family, not under `aerobeat-content-*`. `aerobeat-content-core` owns the durable content language; concrete tool repos own the author-facing workflows that create, edit, validate, migrate, package, import, and publish that content.

## Why AeroBeat needs `Routine`

`Routine` is the missing primitive between `Song` and `Workout`.

A `Song` alone is too low-level. It knows about the audio timeline, credits, and metadata, but it does not know whether the athlete is boxing, stepping, dancing, or flowing.

A `Workout` is too high-level. It is a program that assembles multiple playable items into a training session, possibly with an optional coaching pass via the package’s coach-config domain and non-song media.

`Routine` is the correct place for:

- the gameplay mode for a song
- the mode-specific authored vocabulary
- validation rules for that mode
- presentation defaults
- a grouped set of difficulty variants for the same song + mode

Examples:

- one song can have a **Boxing Routine** and a **Dance Routine**
- a Boxing Routine can have **Easy**, **Medium**, **Hard**, and **Pro** charts
- a Workout can pick the Medium Boxing chart from one song and the Hard Dance chart from another

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
- song-level timing authority such as `timing.bpm`
- descriptive metadata such as `metadata.explicit`, BCP 47 `metadata.language` values, and locked-enum `metadata.genres`

It does **not** own gameplay-mode-specific note data, athlete/device-specific timing offsets, or freeform song `tags` in the current v1 contract.

### 2. Routine

A `Routine` is the authored gameplay package for one `Song` interpreted through one gameplay mode.

It stays intentionally lean and owns fields such as:

- `routineId`
- `routineName`
- `songId`
- `mode` such as `boxing`, `dance`, `step`, or `flow`
- `authorId`
- `authorName`
- `charts` as referenced chart UIDs

A routine is where AeroBeat says, “this is the boxing choreography for this song,” not just “this song exists.”

### 3. Chart

A `Chart` is one concrete playable authored sequence.

It owns fields such as:

- `chartId`
- `chartName`
- `routineId`
- difficulty
- interaction family target
- optional supported / validated input profiles
- timing-aligned event stream
- optional presentation hints needed to render the chart well only when those hints are truly part of durable content

A chart represents **one playable difficulty / compatibility slice**, not an all-difficulties megafile.

Mode-global tuning such as hit windows should not live in authored chart data. Those belong in feature/mode rules rather than in each chart record.

#### Why difficulty belongs here

AeroBeat does not store all difficulties as peer event arrays inside one giant chart by default.

Separate charts give us:

- cleaner diffs and version control
- easier validation
- easier tooling
- fewer edit collisions between contributors
- room for alternate compatibility slices later without forking the whole routine

### 4. Workout

A `Workout` is a training program.

It owns fields such as:

- `workoutId`
- `workoutName`
- `description`
- `coachConfigId` referencing the package’s single coach-config domain
- ordered list of exact chart UID selections as workout sets
- per-set environment selection
- per-set asset selections with at most one asset per set-selectable asset type

When coaching is enabled, the package’s single coach-config domain owns the coach roster, warmup video, cooldown video, and exactly one overlay audio clip per workout set keyed by `setId`. `workout.yaml` points at coach-config but does not own those media references directly.

The locked v1 `assetType` enum is intentionally narrow: `gloves`, `targets`, `obstacles`, and `trails`. Those are the gameplay-facing asset types that belong in per-set asset selections. AeroBeat owns a single fixed between-set runtime/UI flow rather than authoring per-set transition behavior in the package.

Workout runtime length is derived from the referenced content rather than stored as a separate authored duration field.

## Shared chart envelope

AeroBeat uses **one shared chart envelope** across gameplay modes, with **mode-specific payloads** inside it.

This keeps tooling, loading, validation, and runtime contracts coherent without pretending that Boxing and Step are authored with the exact same event vocabulary.

The shared chart envelope is owned by `aerobeat-content-core` because it is part of the durable authored-content contract. Feature repos consume it and interpret it.

### Shared fields

All charts expose a common envelope containing fields such as:

- `schema`
- `chartId`
- `songId`
- `routineId`
- `mode`
- `difficulty`
- `interactionFamily`
- `supportedInputProfiles`
- `validatedInputProfiles`
- `timing`
- `presentation`
- `scoring`
- `events`
- `metadata`

### Mode-specific payloads

The meaning of `events` depends on the routine mode.

Examples:

- **Boxing:** strike, guard, obstacle, stance, knee, rotation cue
- **Dance:** limb pose, direction, hold, travel, formation cue
- **Step:** pad lane, hold, jump, mine, modifier
- **Flow:** saber-style cut direction, lane, obstacle, path, gesture hold

The loader contract is shared. The event schema is not identical across all modes.

That is the correct compromise.

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

### Input profile fields

Use profile fields to express compatibility without making the profile the primary content target.

- `interactionFamily` = what movement semantics the chart expects
- `supportedInputProfiles` = profiles the chart is intended to run on
- `validatedInputProfiles` = profiles that have actually been tested and approved

For example, a Boxing chart targets `gesture_2d`, supports `mediapipe_camera`, `keyboard_debug`, and `gamepad_virtual_presence`, but only marks `mediapipe_camera` as validated initially.

## View modes belong mostly to runtime presentation

View modes such as Portal View, Track View, 3-Portal View, and 360-Portal View are treated primarily as **presentation and runtime interpretation concerns**, not as separate chart families.

Charts include presentation hints such as:

- preferred views
- preferred portal layout
- mirror-camera mode preference
- travel-time or approach hints where authoring truly depends on them

The same authored event stream remains portable across views by default.

### Authoring rule

Author the athlete interaction first.

Then let the runtime render that interaction as:

- 3D incoming portal targets
- 2D track lanes
- folded 360-to-front fallback layouts
- multi-portal or simplified mobile representations

If a future mode truly requires view-specific authored data that cannot be derived, add that as an extension field rather than replacing the content hierarchy.

### Runtime-visual ownership rule

Content may declare portable presentation hints, but concrete visual realizations of those hints stay out of the content lane. 2D lane renderers, 3D portal implementations, multi-portal layouts, world-space spawn systems, and other content-consuming runtime visuals belong in `aerobeat-feature-core` or concrete `aerobeat-feature-*` repos. They may depend on `aerobeat-content-core`, but they do not move into it.

## Recommended file / package relationship

At the docs level, AeroBeat treats these as distinct assets even if implementation details evolve later:

- one `Song` record
- one or more `Routine` records under that song
- one chart file or record per `Chart`
- one `Workout` file or record assembling selections

That yields small, reviewable, reusable units.

## Content package boundary

AeroBeat packages authored content as a **self-contained workout package** with one root `workout.yaml`, typed YAML records in domain folders, package-local resources, and optional disposable local caches.

The package boundary is the unit of distribution, import, install, indexing, validation, and compatibility review.
The individual `Song`, `Routine`, `Chart`, `Workout`, `Coach Config`, `Environment`, and `Asset` records inside that package remain the unit of authoring, validation, and runtime selection.

### Package responsibilities

A content package owns:

- package id / workout id
- package version
- package-level author / attribution metadata
- typed records for contained songs, routines, charts, workout set plan data, coach config, environments, and assets
- references to the binary resources required by those records, such as audio, thumbnails, coaching clips, preview art, scenes, and runtime assets
- package-level schema/tool version metadata needed for parsing and migration

### Package rules

1. A workout package is self-contained for v1 validation and playback.
2. A package may contain one or more songs.
3. A routine must reference a song that exists in the same package.
4. A chart must reference exactly one routine in the same package.
5. A workout set resolves to exact ids rather than loose lookup selectors.
6. Each workout package contains exactly one `coaches/` folder with exactly one coach-config YAML file.
7. Coaching is optional all-or-nothing: disabled coaching uses `enabled: false`, while enabled coaching must provide the full roster/media contract.
8. Enabled coaching owns the warmup video, cooldown video, and exactly one overlay audio clip per workout set keyed by `setId`.
9. `environments/` and `assets/` are distinct first-class content folders with their own YAML records.
10. Each workout set chooses exactly one environment and at most one asset per set-selectable asset type.
11. `assetType` is a strict v1 enum rather than a freeform string; unknown values should fail package validation.
12. Binary media stays as referenced resources inside the package; the canonical authored contracts stay in structured content records.
13. Alternate versions are created by duplication/forking, not inheritance or patch layering across workout packages.

## Authored data contract boundaries

The durable authored contract is split across four levels:

### Song contract

The `Song` contract is responsible for reusable music identity and timing authority.
It must remain free of mode-specific gameplay data.

### Routine contract

The `Routine` contract is responsible for the mode-specific authored package for one song.
It is the boundary where AeroBeat commits to the gameplay family, authoring vocabulary, validation profile, and default presentation intent.

### Chart contract

The `Chart` contract is responsible for one exact playable authored sequence.
It is the boundary for difficulty, interaction family, validated compatibility, scoring envelope, and the timed event stream.

### Workout contract

The `Workout` contract is responsible for set composition.
It sequences playable selections and coaching/program flow, but it does not redefine the underlying chart semantics or author between-set transition behavior.

## Registry and discovery responsibilities

AeroBeat separates **registry contracts** from **registry implementations**.

### `aerobeat-content-core` owns

- content identity fields and reference rules
- package-manifest contract shape
- registry query/result interfaces
- lookup semantics for songs, routines, charts, workouts, and resource references
- stable rules for duplicate ids, missing references, package precedence, and disabled/hidden content states

### concrete tools/runtime own

- filesystem scanning
- remote catalog fetches
- cache persistence
- user-library indexing
- install/uninstall state
- download/update policy

The important split is simple: `aerobeat-content-core` defines **what a registry means**; tools and app/runtime code decide **how a registry is populated and persisted**.

## Schema versioning and migration

AeroBeat versioning is explicit at both the package and record levels.

### Versioning rules

- every package declares a package version
- every structured content record declares its schema id/version
- schema evolution is append-only until a deliberate breaking revision is published
- breaking schema changes require a new schema version rather than silent reinterpretation
- loaders must reject unknown breaking schema versions unless a registered migration path exists

### Migration ownership

`aerobeat-content-core` owns:

- schema identifiers
- compatibility classification
- migration interface contracts
- canonical migration result/report types
- the rule that migrations must be explicit, traceable, and loss-aware

`aerobeat-tool-core` and concrete tooling own:

- author-facing migration workflows
- upgrade preview UX
- batch migration commands
- import-time auto-upgrade policies where approved

Feature repos may provide mode-specific event-schema migrations for their own payload families, but they do so through the shared migration interfaces rather than inventing a parallel migration system.

## Validation layering

AeroBeat uses layered validation instead of one giant validator.

### Layer 1: package/reference validation

Shared validation in `aerobeat-content-core` checks:

- schema presence and version legality
- id uniqueness and reference integrity
- required field presence
- timing-envelope shape
- package/resource reference existence
- workout set reference legality
- interaction-family field validity

### Layer 2: mode-specific content validation

Feature repos validate the mode-specific payload semantics, for example:

- boxing event vocabulary legality
- dance formation constraints
- step lane/rule constraints
- flow cut/path constraints

### Layer 3: tool/runtime compatibility validation

Tool and runtime layers validate environment-specific concerns, for example:

- missing imported files on disk
- unsupported codecs or oversized assets
- target-platform packaging rules
- publish/upload policy checks

A chart is not considered fully valid just because one layer passed. The shared layer proves the content contract is structurally coherent. The feature layer proves the gameplay payload is meaningful. The tool/runtime layer proves the content is usable in the current environment.

## Import, export, and ingestion boundaries

AeroBeat keeps canonical content contracts separate from ingestion mechanics.

`aerobeat-content-core` owns:

- canonical import/export DTO (Data Transfer Object) contracts where shared interchange is required
- normalized validation/migration reports
- package manifest and content record shapes
- stable ids/reference rules that ingestion must preserve

`aerobeat-tool-core` and concrete tool repos own:

- external file format adapters
- authoring-tool importers/exporters
- batch ingest jobs
- backend upload/download workflows
- moderation/publishing workflow state

That means CSV import, editor project conversion, web upload, and cloud catalog ingestion are all tool responsibilities. The resulting durable records still have to land on the same `Song` / `Routine` / `Chart` / `Workout` contracts owned by `aerobeat-content-core`.

### Headless tooling rule

Content tooling must not require a GUI in order to perform core content operations. Validation, migration, packaging, import/export, registry/index maintenance, fixture generation, and other automation-friendly actions should be exposed through a headless/CLI surface in the Tool lane, even if the same repo also ships an interactive editor or richer desktop UX. Interactive tooling can layer on top of the same contracts and services, but headless execution is a first-class requirement rather than an afterthought.

## Workout sequencing and playback handoff

The workout contract ends at **set sequencing intent**.
The feature/runtime contract begins at **playback execution and athlete interpretation**.

### `aerobeat-content-core` owns

- workout set ordering
- routine/chart selection references
- optional difficulty-resolution rules when the workout references a routine rather than an exact chart
- the fixed between-set handoff metadata implied by the root contract
- workout-level timing and coaching-sequence metadata
- the handoff contract that resolves a workout set into a concrete playable chart selection plus any attached set metadata

### feature/runtime owns

- spawning gameplay objects from the resolved chart
- hit/scoring interpretation during play
- dynamic difficulty or assist behavior at runtime
- view rendering and presentation realization
- pause/retry/fail/recovery behavior

In other words, Content decides **what should be played next** and resolves the authored selection boundary. Feature/runtime decides **how that resolved selection is actually performed on-screen and scored in motion**.

## Explicit split: `content-core` vs `tool-core`

### `aerobeat-content-core`

Owns the durable shared language of authored content:

- canonical content records
- shared chart envelope
- package-manifest contract
- registry/loader/query interfaces
- schema ids/version rules
- shared validation contracts and result types
- workout sequencing contracts
- migration interface contracts

### `aerobeat-tool-core`

Owns shared tool-side operational models around that content:

- editor/backend/settings-facing DTOs (Data Transfer Objects) that are not themselves durable authored content
- import/export job/result models
- publishing/moderation workflow models
- batch validation/migration job models
- tool-side status/progress/error surfaces
- service interfaces usable by both interactive/editor UX and headless/CLI entrypoints

Concrete tool products live in `aerobeat-tool-*` repos. A chart editor, workout planner, package builder, validation runner, or ingestion utility is a Tool-lane product even when it is primarily used for content authoring.

### non-goals

- `aerobeat-content-core` does not own editor UX, upload workflows, or backend queue state.
- `aerobeat-tool-core` does not redefine `Song`, `Routine`, `Chart`, `Workout`, or the shared chart envelope.
- feature repos do not replace the shared content contracts with mode-local durable content roots.

## Minimal shared chart envelope example

```json
{
  "schema": "aerobeat.chart.boxing.v1",
  "chartId": "boxing-song123-medium-gesture",
  "songId": "song123",
  "routineId": "song123-boxing",
  "mode": "boxing",
  "difficulty": "medium",
  "interactionFamily": "gesture_2d",
  "supportedInputProfiles": ["mediapipe_camera"],
  "validatedInputProfiles": ["mediapipe_camera"],
  "timing": {
    "offsetMs": 0,
    "resolution": 16
  },
  "presentation": {
    "preferredViews": ["portal", "track"],
    "portalMode": "front_3_portal",
    "mirrorCamera": true
  },
  "scoring": {
    "comboModel": "standard"
  },
  "events": [],
  "metadata": {
    "tags": ["cardio", "boxing"]
  }
}
```

## Opinionated rules

To keep the ecosystem coherent, AeroBeat follows these rules:

1. **One song can power many routines.** Do not duplicate song metadata per mode.
2. **One routine equals one song interpreted through one mode.** Do not mix Boxing and Dance inside a single routine.
3. **One chart equals one playable sequence.** Keep each difficulty / compatibility slice distinct.
4. **Charts target interaction families first.** Devices are compatibility notes, not the root abstraction.
5. **View modes are render strategies first.** Do not create separate content silos for portal vs track unless a future mode proves it is necessary.
6. **Mode-specific event vocabularies are allowed.** The chart envelope is shared; the authored payload is not forced into fake universality.
7. **Content ownership stays in `aerobeat-content-core`.** Feature, tool, UI, and assembly repos consume these contracts; they do not redefine them.

## First shipping recommendation

For the first shipping slice, AeroBeat standardizes on:

- `Song` as the reusable music source
- `Routine` as the missing gameplay package primitive
- `Chart` as the single playable difficulty artifact
- `Workout` as the set/program container
- a shared chart envelope with mode-specific event payloads
- `gesture_2d` as the first target interaction family for Boxing + MediaPipe

That gives Boxing + Camera Tracking a practical v1 format now while preserving room for XR, JoyCons, keyboard fallback, and future gameplay families later.
