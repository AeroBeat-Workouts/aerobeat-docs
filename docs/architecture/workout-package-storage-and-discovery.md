# Workout Package Storage and Discovery

This document defines the current canonical direction for how AeroBeat workout packages are authored, stored on disk, discovered at runtime, and indexed for browsing.

It turns the earlier 2026-04-23 storage draft into a more implementation-guiding contract.

The package system is grounded in these now-locked decisions:

- workout packages are **self-contained**
- YAML is the **authored durable format**
- discoverability lives in **`workouts.db` only**, not in package YAML
- the package contains everything required to play the workout for validation/runtime purposes
- leaderboard data is stored only as a **local per-workout cache**, is **non-authoritative**, and is **ignored/removed during submission/upload**
- each package has one `coaches/` folder containing exactly one coach-config YAML file
- coaching is optional all-or-nothing: disabled uses `enabled: false`, enabled requires the full roster/media contract
- enabled coach-config may describe multiple featured coaches
- alternate versions are created by **duplication/forking**, not inheritance or patch layering across workout packages
- `environments/` and `assets/` are distinct content domains with their own YAML files
- each workout set chooses one environment and at most one asset per gameplay-facing asset type
- runtime may still unload/load between sets even when consecutive sets reuse the same ids
- official first-party assets/environments are future content under the same system, not a special-case path

## Design goals

The storage and discovery system should optimize for:

- **clarity** — creators and engineers can inspect a package on disk and understand it quickly
- **debuggability** — broken references are visible as broken package-local files or ids
- **portability** — packages can be copied, archived, validated, and reinstalled as self-contained units
- **symmetry** — first-party and community-authored workouts use the same conceptual package system
- **runtime friendliness** — browse/search should use SQLite rather than reparsing every YAML file for every query
- **durable authorship** — YAML remains the canonical human-authored source, while indexes/caches are derived data

## Core content model recap

The durable content hierarchy remains:

- **Song**
  - reusable audio/timing identity
- **Routine**
  - one song interpreted through one gameplay mode
- **Chart**
  - one exact playable difficulty slice of a routine
- **Workout**
  - the programmed set plan that selects exact chart ids and owns workout-level coaching/package metadata

Related package-local domains now also include:

- **Coach Config**
  - the workout-level coaching/media definition file for that package
- **Environment**
  - a reusable environment record authorable inside the package
- **Asset**
  - a reusable per-type asset record authorable inside the package

All primary ids are UIDs and follow the same naming rule where applicable:

- `songId`, `songName`
- `routineId`, `routineName`
- `chartId`, `chartName`
- `workoutId`, `workoutName`
- `coachConfigId`, `coachConfigName`
- `environmentId`, `environmentName`
- `assetId`, `assetName`

## Authority split: authored package vs derived indexes/caches

AeroBeat intentionally splits authority across three layers.

### 1. Package YAML = durable authored truth

The package YAML files are the canonical authored content payload.

They own:

- workout set definition
- songs, routines, charts
- workout-local coach configuration, including optional all-or-nothing coaching media
- package-local environments/assets
- package-local resource references
- schema/package/tool version metadata

They do **not** own:

- discoverability/search indexing
- athlete/device-specific calibration or profile overrides
- authoritative score history
- player-wide social/profile state

### 2. `workouts.db` = install/discovery catalog index

`workouts.db` exists to power local browsing, filtering, moderation surfaces, and install-state lookups.

It is derived from package/authored data, is not the authored truth, and is the local installed-workout instance of AeroBeat's shared catalog schema. A future remote catalog snapshot should reuse the same core tables rather than inventing a divergent browse contract.

### 3. `leaderboard-cache.db` = local disposable score-browsing cache

The leaderboard cache database is strictly a local convenience cache for viewing leaderboard snapshots for a specific workout.

It is:

- non-authoritative
- safe to rebuild or delete
- excluded from canonical package submission payloads
- ignored or stripped during upload/submission validation

Server APIs remain authoritative for score submission, anti-cheat enforcement, and player-wide leaderboard/profile state.

## Canonical on-disk layout

```text
aerobeat-workouts/
├── workouts.db
└── workouts/
    └── <workout-id>/
        ├── workout.yaml
        ├── songs/
        │   └── <song-id>.yaml
        ├── routines/
        │   └── <routine-id>.yaml
        ├── charts/
        │   └── <chart-id>.yaml
        ├── coaches/
        │   └── coach-config.yaml
        ├── environments/
        │   └── <environment-id>.yaml
        ├── assets/
        │   └── <asset-id>.yaml
        ├── media/
        │   ├── audio/
        │   ├── video/
        │   ├── art/
        │   ├── coaching/
        │   ├── scenes/
        │   └── assets/
        └── cache/
            └── leaderboard-cache.db
```

### Layout rules

1. The package root contains exactly one `workout.yaml`.
2. `songs/`, `routines/`, `charts/`, `coaches/`, `environments/`, and `assets/` are distinct content-domain folders.
3. `coaches/` contains exactly one YAML file for the workout-level coach config domain.
4. Media/resource references should resolve inside the package folder.
5. `cache/` contains only disposable derived data and must not be treated as authored package content.
6. Submission/export validators may omit `cache/` entirely from canonical package payload generation.

## Package-wide shared field direction

Every authored YAML record should carry a small set of predictable contract fields.

### Required shared fields for all authored YAML records

- `schemaId` — explicit schema identifier such as `aerobeat.song.v1`
- `schemaVersion` — version of the record contract
- `recordVersion` — revision of this authored record
- primary id/name fields for that record type
- `createdByTool` — tool id/name that produced the record
- `createdByToolVersion` — tool version
- `createdAt`
- `updatedAt`

### Recommended shared optional metadata

- `authorId`
- `authorName`
- `tags`
- `notes`
- `source`

These shared fields are about traceability and migration support, not discoverability. Search-facing denormalization belongs in `workouts.db`.

## Canonical YAML schema direction

The sections below define the current v1 field direction. They are intended as implementation-guiding contracts, not strict serialization code yet.

### `workout.yaml`

`workout.yaml` combines package manifest metadata and workout-level set data.

#### Owns

- package identity/version metadata
- workout identity/description
- package-local default coach config reference
- ordered workout sets
- package-level resource ownership declarations that are part of authored playback

#### Must not own

- discovery/search ranking fields
- global catalog visibility state
- authoritative leaderboard state
- athlete/device overrides

#### Canonical field direction

```yaml
schemaId: aerobeat.workout-package.v1
schemaVersion: 1
recordVersion: 3
workoutId: uid
workoutName: string
description: string
packageVersion: 1.2.0
createdByTool: aerobeat-tool-content-authoring
createdByToolVersion: 0.1.0
createdAt: 2026-04-25T19:00:00Z
updatedAt: 2026-04-25T19:20:00Z
authorId: uid
authorName: string
coachConfigId: coach-config
preview:
  coverArtPath: media/art/cover.png
sets:
  - setId: uid
    chartId: uid
    routineId: uid
    songId: uid
    environmentId: uid
    assetSelections:
      gloves: uid
      targets: uid
      obstacles: uid
```

#### Notes

- `sets` resolve to exact ids; they do not use loose song/mode/difficulty matching.
- Each set chooses exactly one `environmentId`.
- `assetSelections` is a keyed map by asset type. Current direction is **one selected asset per asset type per set**.
- If two consecutive sets reference the same `environmentId` or asset ids, runtime may still unload/reload them at the fixed between-set boundary. Packages do not author alternate transition behavior.
- Total runtime should still be derived from referenced media/song durations rather than stored as a manual authoritative duration field.

### `songs/<song-id>.yaml`

#### Owns

- reusable song identity
- music/timing authority
- song-level credits and licensing metadata
- references to audio and other song-local playback media

#### Must not own

- gameplay mode definitions
- chart event payloads
- athlete/device calibration offsets
- discovery/catalog state

#### Canonical field direction

```yaml
schemaId: aerobeat.song.v1
schemaVersion: 1
recordVersion: 1
songId: uid
songName: string
createdByTool: aerobeat-tool-content-authoring
createdByToolVersion: 0.1.0
createdAt: 2026-04-25T19:00:00Z
updatedAt: 2026-04-25T19:00:00Z
artist:
  displayName: string
credits:
  composer: string
  publisher: string
licensing:
  licenseType: string
  usageRights: []
audio:
  filePath: media/audio/song.ogg
  durationMs: 123456
  previewStartMs: 30000
timing:
  bpm: 128
  beatGrid:
    resolution: 16
    anchors: []
metadata:
  explicit: false
  language: en
  genres:
    - edm
    - pop
tags:
  - boxing
  - cardio
```

Genre note: use only the locked normalized lowercase enum. Workout browse genres are derived as the union of the referenced songs' authored genres rather than being invented separately at the workout layer.


### `routines/<routine-id>.yaml`

#### Owns

- one song interpreted through one gameplay mode
- routine identity and authorship
- references to its chart ids

#### Must not own

- workout sequencing
- environment/asset selections for a workout set
- score cache/discoverability state

#### Canonical field direction

```yaml
schemaId: aerobeat.routine.v1
schemaVersion: 1
recordVersion: 1
routineId: uid
routineName: string
songId: uid
mode: boxing
authorId: uid
authorName: string
chartIds:
  - uid
tags:
  - beginner-friendly
```

### `charts/<chart-id>.yaml`

#### Owns

- one exact playable difficulty slice
- chart-to-routine linkage
- chart-local event payload and compatibility declarations

#### Must not own

- discoverability/catalog state
- workout-level environment/asset selections
- mode-global tuning better owned by feature/runtime rules

#### Canonical field direction

```yaml
schemaId: aerobeat.chart.boxing.v1
schemaVersion: 1
recordVersion: 2
chartId: uid
chartName: string
routineId: uid
songId: uid
mode: boxing
difficulty: medium
interactionFamily: gesture_2d
supportedInputProfiles:
  - mediapipe_camera
validatedInputProfiles:
  - mediapipe_camera
timing:
  resolution: 16
presentationHints:
  preferredViews:
    - portal
scoringHints:
  comboModel: standard
events: []
```

### `coaches/coach-config.yaml`

There is exactly one coach-config YAML per workout package. Coaching is optional all-or-nothing: disabled coaching uses `enabled: false`; enabled coaching owns the workout's roster and coaching media references.

#### Owns

- workout-level coach configuration
- optional all-or-nothing coaching enablement
- featured coach roster used by the package
- required warmup/cooldown media references when coaching is enabled
- exactly one overlay audio reference per workout set when coaching is enabled

#### Must not own

- discoverability/catalog state
- player-specific preferences
- reusable cross-package inheritance rules

#### Canonical field direction

```yaml
enabled: true
coachConfigId: coach-config
coachConfigName: string
featuredCoaches:
  - coachId: uid
    coachName: string
warmupVideo:
  mediaId: warmup-intro
  path: media/coaching/warmup-intro.mp4
cooldownVideo:
  mediaId: cooldown-outro
  path: media/coaching/cooldown-outro.mp4
setOverlayAudio:
  - setId: uid
    coachId: uid
    mediaId: overlay-a
    path: media/coaching/coach-a-cue.ogg
```

### `environments/<environment-id>.yaml`

#### Owns

- package-local environment identity
- environment scene/art/lighting references
- authored environment metadata needed to load the environment in playback

#### Must not own

- workout set order
- chart content
- special first-party-only semantics

#### Canonical field direction

```yaml
schemaId: aerobeat.environment.v1
schemaVersion: 1
recordVersion: 1
environmentId: uid
environmentName: string
scenePath: media/scenes/neon-gym.tscn
lightingProfile: neon-night
fogProfile: light-haze
tags:
  - cyber
  - studio
```

### `assets/<asset-id>.yaml`

Assets are reusable package-local records for typed runtime-presented content. For v1, AeroBeat keeps `assetType` intentionally small and closed so package validation, entry selection, and runtime binding stay boring and predictable.

#### Owns

- asset identity and asset type
- package-local resource references
- metadata needed to bind the asset in playback

#### Must not own

- workout sequencing
- discovery state
- cross-package inheritance behavior

#### Canonical field direction

```yaml
schemaId: aerobeat.asset.v1
schemaVersion: 1
recordVersion: 1
assetId: uid
assetName: string
assetType: gloves
resourcePath: media/assets/gloves/neon-gloves.glb
thumbnailPath: media/art/neon-gloves-thumb.png
metadata:
  palette: neon-pink
  style: arcade
tags:
  - neon
```

#### Locked v1 `assetType` direction

`assetType` is a **strict v1 enum**, not an open-ended freeform string. Unknown values should fail package validation rather than being silently accepted.

The locked v1 enum is:

- `gloves`
- `targets`
- `obstacles`
- `trails`

Direction notes:

- `gloves`, `targets`, `obstacles`, and `trails` are the **set-selectable gameplay-facing asset types** referenced from `sets[*].assetSelections`.
- v1 should **not** introduce broader freeform categories such as `misc`, `custom`, or implementation-specific plugin types. If AeroBeat later needs more asset families, add them through a deliberate schema revision rather than string drift.
- Missing set selections mean “use runtime/default presentation behavior for that asset type,” not inheritance from another package.

## Relationship and reference rules

1. `workout.yaml` is the package root and authoritative set manifest.
2. `sets[*].chartId` must reference a chart in `charts/`.
3. Each chart must reference exactly one routine in `routines/`.
4. Each routine must reference exactly one song in `songs/`.
5. Each workout set must choose exactly one environment id.
6. Each workout set may choose zero or one asset id for each set-selectable asset type; it must not choose multiple assets for the same asset type in the same set.
7. The single coach-config file may define multiple coaches.
8. If coaching is enabled, coach-config must include one warmup video, one cooldown video, and exactly one overlay audio clip for every `sets[*].setId`.
9. Package-local references should remain package-local for v1 self-contained validation.
10. Package validation should reject unknown `assetType` values rather than downgrading them to generic assets.
11. Alternate versions of content are created by copying/forking package contents into a new package revision rather than layering patches across packages.

## What intentionally stays out of package YAML

The following are intentionally **not** authored into the package YAML contracts:

- search ranking
- catalog moderation state
- install state
- download state
- local favorite/bookmark state
- player progression
- player calibration or device offsets
- authoritative leaderboard submissions/history
- player-wide stats caches
- cross-package inheritance or patch instructions
- package signing, signature chains, or embedded trust-policy metadata
- checksum/integrity manifests intended for distribution security rather than authored playback semantics

These belong in runtime profile state, service state, moderation/catalog systems, disposable local caches, or a later distribution-hardening layer.

## Canonical SQLite direction

AeroBeat currently needs two SQLite schema families:

1. a shared workout catalog schema used by both local and remote browse databases
2. a package-local `leaderboard-cache.db` database

## Shared workout catalog schema v1 direction

AeroBeat's browse/discovery model is now locked to a **shared core schema** across local and remote catalog databases.

In plain language:

- local `workouts.db` and a future remote catalog snapshot may still be different database files
- but they should speak the same core browse language
- local-only install/path/validation state belongs in `workout_local`
- remote-only preview/distribution browse state belongs in `workout_remote`

That keeps authored truth in YAML while avoiding two different catalog contracts for the same browse concepts.

### Responsibilities

- discover workouts quickly without reparsing all YAML files
- expose denormalized browse metadata for search/filter surfaces
- keep shared browse concepts in shared core tables
- attach local-only install/indexing state through `workout_local`
- attach remote-only preview/distribution state through `workout_remote`

### Must not become

- the only source of package truth
- the place where authored chart/song/workout semantics originate
- the authoritative leaderboard store
- a validator that invents missing authored metadata

### Shared core v1 tables

#### `workouts`

One row per workout known to the catalog.

Suggested columns:

- `workout_id TEXT PRIMARY KEY`
- `workout_name TEXT NOT NULL`
- `description TEXT`
- `package_version TEXT NOT NULL`
- `schema_version INTEGER NOT NULL`
- `created_by_tool TEXT`
- `created_by_tool_version TEXT`
- `coach_config_id TEXT`
- `duration_ms INTEGER`

Notes:

- `duration_ms` is a shared browse field on the workout itself.
- `default_coach_name` is removed from the shared contract.
- shared-core cover art path fields are removed; remote preview image handling belongs in `workout_remote`.

#### `workout_tags`

Normalized tags for filter/search.

- `workout_id TEXT NOT NULL`
- `tag TEXT NOT NULL`
- `PRIMARY KEY (workout_id, tag)`

#### `workout_modes`

Summarized mode availability for browse filters.

- `workout_id TEXT NOT NULL`
- `mode TEXT NOT NULL`
- `PRIMARY KEY (workout_id, mode)`

#### `workout_difficulties`

Summarized difficulty availability for browse filters.

- `workout_id TEXT NOT NULL`
- `difficulty TEXT NOT NULL`
- `PRIMARY KEY (workout_id, difficulty)`

Locked values:

- `easy`
- `medium`
- `hard`
- `pro`

#### `workout_songs`

A lightweight denormalized song summary per workout.

- `workout_id TEXT NOT NULL`
- `song_id TEXT NOT NULL`
- `song_name TEXT NOT NULL`
- `artist_name TEXT`
- `duration_ms INTEGER`
- `PRIMARY KEY (workout_id, song_id)`

#### `workout_coaches`

Summarized coach roster rows derived from `coaches/coach-config.yaml`.

- `workout_id TEXT NOT NULL`
- `coach_id TEXT NOT NULL`
- `coach_name TEXT NOT NULL`
- `PRIMARY KEY (workout_id, coach_id)`

Rule:

- if coaching is disabled, `workout_coaches` must contain zero rows for that workout

#### `workout_genres`

Browse genres derived from the workout's referenced songs.

- `workout_id TEXT NOT NULL`
- `genre TEXT NOT NULL`
- `PRIMARY KEY (workout_id, genre)`

Locked values:

- `pop`, `rock`, `hip_hop`, `r_and_b`, `edm`, `country`, `latin`, `jazz`, `blues`, `funk`, `soul`, `reggae`, `folk`, `classical`, `metal`, `punk`, `world`, `soundtrack`, `holiday`, `game`, `chiptune`, `anime`

Rules:

- genres come from authored song metadata; validators/indexers must not invent them
- a workout's browse genres are the union of the genres on its referenced songs

### Companion tables

#### `workout_local`

Local installed-workout state that should not pollute the shared core tables.

Suggested columns:

- `workout_id TEXT PRIMARY KEY`
- `workout_yaml_path TEXT NOT NULL`
- `package_root_path TEXT NOT NULL`
- `installed_at TEXT NOT NULL`
- `indexed_at TEXT NOT NULL`
- `updated_at TEXT`
- `is_installed INTEGER NOT NULL DEFAULT 1`
- `is_valid INTEGER NOT NULL DEFAULT 1`
- `validation_error TEXT`

#### `workout_remote`

Remote/distribution browse state that should not pollute the shared core tables.

Suggested columns:

- `workout_id TEXT PRIMARY KEY`
- `preview_image_strategy TEXT NOT NULL`
- `preview_image_url TEXT`

Locked `preview_image_strategy` values:

- `direct_url`
- `api_resolve`

Rules:

- `direct_url` requires `preview_image_url`
- `api_resolve` may leave `preview_image_url` null

### Indexing notes

- catalog databases store duplicated browse metadata on purpose
- if YAML and catalog rows disagree, YAML plus package validation is the truth source; the catalog should be rebuilt/refreshed
- a workout may remain locally installed/playable even if future remote catalog state would make it undiscoverable online
- removing `workout_assets` from the core contract is intentional; asset usage is not part of the approved shared browse schema

### Local vs remote file layout direction

The shared schema does **not** require local and remote catalogs to be the same physical file.

The approved direction is:

- local browse/install state may live in `workouts.db` using the shared core tables plus `workout_local`
- a future downloaded or bundled remote catalog snapshot may live in a separate DB file such as `catalog.db` using the same shared core tables plus `workout_remote`
- both sides should keep the same meanings for shared tables like `workouts`, `workout_tags`, `workout_modes`, `workout_difficulties`, `workout_songs`, `workout_coaches`, and `workout_genres`

This preserves a clean authority split: authored truth in package YAML, shared browse vocabulary in the catalog core, local install state in `workout_local`, and remote preview/distribution state in `workout_remote`.

## Per-workout `leaderboard-cache.db` v1 direction

Each installed workout package may have a local leaderboard cache at `cache/leaderboard-cache.db`.

### Responsibilities

- cache recent leaderboard snapshots for that workout
- support local browsing when the player opens that workout’s leaderboard UI
- keep last-sync metadata for refresh logic

### Non-goals

- no authority over score validity
- no upload/submission ownership
- no player-wide stats authority
- no requirement to ship with or survive package submission/export

### Minimum v1 tables

#### `cache_meta`

- `cache_key TEXT PRIMARY KEY`
- `cache_value TEXT NOT NULL`

Expected keys include:

- `workout_id`
- `source_region`
- `last_synced_at`
- `etag`
- `api_schema_version`

#### `leaderboard_entries`

- `leaderboard_scope TEXT NOT NULL`
- `rank INTEGER NOT NULL`
- `score_id TEXT NOT NULL`
- `player_id TEXT NOT NULL`
- `player_name TEXT NOT NULL`
- `score INTEGER NOT NULL`
- `performance_time_ms INTEGER`
- `achieved_at TEXT NOT NULL`
- `difficulty TEXT`
- `mode TEXT`
- `input_profile TEXT`
- `is_local_player INTEGER NOT NULL DEFAULT 0`
- `PRIMARY KEY (leaderboard_scope, rank, score_id)`

#### `leaderboard_sync_runs`

- `sync_run_id TEXT PRIMARY KEY`
- `requested_at TEXT NOT NULL`
- `completed_at TEXT`
- `status TEXT NOT NULL`
- `response_code INTEGER`
- `error_text TEXT`

### Cache rules

1. Deleting `leaderboard-cache.db` must be safe.
2. Rebuilding it from server data must be safe.
3. Package submission/export must ignore it or strip it.
4. Validation should fail only if a supposedly submission-clean payload incorrectly includes cache data where it should not.
5. Runtime may create the cache lazily the first time leaderboard data is requested.

## Godot/runtime discovery flow

1. Runtime opens `workouts.db`.
2. Browse/search/filter queries use index tables, not raw YAML parsing.
3. Selecting a workout resolves `workout_yaml_path` and `package_root_path`.
4. Runtime loads `workout.yaml`, then referenced songs/routines/charts/coaches/environments/assets.
5. Runtime validates reference integrity and package-local resources before play.
6. Optional leaderboard UI reads or refreshes `cache/leaderboard-cache.db` for that installed workout.

## Install, update, remove, and submission flow

### Install

1. Copy the self-contained package into `workouts/<workout-id>/`.
2. Validate folder shape, YAML parsing, ids, and resource references.
3. Rebuild that package’s index rows in `workouts.db`.
4. Create no leaderboard cache until needed, or initialize an empty one lazily.

### Update

1. Replace package contents with the new package revision.
2. Revalidate.
3. Refresh `workouts.db` rows.
4. Preserve or invalidate `leaderboard-cache.db` according to cache version/source rules; it remains disposable either way.

### Remove

1. Delete the package folder.
2. Delete its `workouts.db` rows.
3. Discard any package-local cache data with it.

### Submission/export

1. Validate the authored package payload only.
2. Ignore or strip `cache/` and any disposable local runtime artifacts.
3. Reject packages that rely on non-package-local dependencies for v1 self-contained validation.
4. Submit only the canonical authored content/resources needed to reconstruct the workout package.

## Validation direction

### Package validation

Check:

- required folders/files exist
- `workout.yaml` exists and parses
- exactly one coach-config YAML exists under `coaches/`
- if coach-config says `enabled: false`, it does not also carry dormant roster/media sections
- if coach-config says `enabled: true`, it includes the coach roster, warmup video, cooldown video, and exactly one overlay audio record for every workout set `setId`
- referenced songs/routines/charts/environments/assets exist
- referenced package-local media paths exist on disk
- ids are unique and references are coherent
- each workout set has one environment and at most one asset per set-selectable asset type

### Index validation

Check:

- `workouts.db` rows reflect current installed packages
- denormalized metadata matches current YAML-derived values
- invalid packages are flagged rather than silently indexed as healthy
- shared core rows match YAML-derived browse metadata
- `workout_local` owns local install/path/validation state
- `workout_remote` owns remote preview-image strategy metadata when a remote catalog snapshot is present
- difficulty and genre rows stay inside the approved locked enums

### Submission validation

Check:

- only authored package content is included
- disposable cache artifacts are omitted
- leaderboard cache is ignored/removed
- no cross-package inheritance/patch dependency is required
- no signing/integrity metadata is required or inferred as part of the v1 authored package contract

## Explicit near-term deferrals

These are consciously deferred rather than undefined:

1. the exact environment rendering contract beyond package-local identity/resource fields
2. any additional remote-only distribution tables beyond the now-locked `workout_remote` preview-image contract
3. any package signing, trust chain, embedded signature, or distribution-integrity manifest inside authored package YAML
4. future moderation/ranking/distribution tables beyond the current shared-core-plus-companion catalog model
5. richer asset families beyond the locked v1 `assetType` enum

## Example package and schema files

If you want to inspect the current contract as a concrete folder instead of only prose, use the docs example package:

- [Demo Workout Package Guide](../guides/demo_workout_package.md)
- [Example package overview](../examples/workout-packages/overview.md)
- [Demo package root `workout.yaml`](../examples/workout-packages/demo-neon-boxing-bootcamp/workout.yaml)
- [Example `workouts.db` schema](../examples/workout-packages/demo-neon-boxing-bootcamp/sql/workouts.db.schema.sql)
- [Example `leaderboard-cache.db` schema](../examples/workout-packages/demo-neon-boxing-bootcamp/sql/leaderboard-cache.db.schema.sql)

These files are the docs repo's canonical onboarding example for the locked v1 package contract.

## Current recommendation

For the first implementation-oriented package/storage pass, AeroBeat should proceed assuming:

- authored truth lives in package YAML
- discoverability for installed workouts lives in the local `workouts.db` instance of the shared catalog schema
- local and remote catalog databases should share the same core browse schema, with `workout_local` for local-only state and `workout_remote` for remote-only state
- leaderboard browsing cache lives in package-local `leaderboard-cache.db` only
- packages are self-contained and duplication/fork-based rather than inheritance-based
- `coaches/`, `environments/`, and `assets/` are first-class content domains
- `assetType` is a strict v1 enum: `gloves`, `targets`, `obstacles`, `trails`
- each workout set resolves exact chart/routine/song ids plus one environment and at most one selected asset per set-selectable asset type
- package signing/integrity metadata is explicitly deferred from the v1 authored package contract
- runtime may still do between-set unload/reload even when ids repeat
- first-party and community packages share the same conceptual system

That is the cleanest v1 contract that matches the current AeroBeat decisions and is concrete enough to guide implementation.