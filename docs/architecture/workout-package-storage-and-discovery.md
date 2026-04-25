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
- that coach-config YAML may describe multiple featured coaches
- alternate versions are created by **duplication/forking**, not inheritance or patch layering across workout packages
- `environments/` and `assets/` are distinct content domains with their own YAML files
- each workout entry chooses one environment and one asset per asset type
- runtime may still unload/load on each song transition even when consecutive entries reuse the same ids
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
  - the programmed session that selects exact chart ids and owns workout-level coaching/package metadata

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

- workout/session definition
- songs, routines, charts
- workout-local coach configuration
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

It is derived from installed packages and may also be used for downloaded catalog snapshots, but it is not the authored truth.

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

`workout.yaml` combines package manifest metadata and workout-level session data.

#### Owns

- package identity/version metadata
- workout identity/description
- package-local default coach config reference
- ordered session entries
- workout-level media and transition settings
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
  thumbnailPath: media/art/thumb.png
session:
  warmupMedia:
    - mediaId: warmup-intro
      mediaType: video
      path: media/coaching/warmup-intro.mp4
  cooldownMedia:
    - mediaId: cooldown-outro
      mediaType: video
      path: media/coaching/cooldown-outro.mp4
  defaultTransition:
    crossfadeMs: 0
    allowRuntimeUnloadReload: true
  entries:
    - entryId: uid
      order: 1
      chartId: uid
      routineId: uid
      songId: uid
      environmentId: uid
      assetSelections:
        gloves: uid
        targets: uid
        obstacles: uid
      transition:
        allowRuntimeUnloadReload: true
      coachingOverlayIds:
        - uid
packageContents:
  songs:
    - uid
  routines:
    - uid
  charts:
    - uid
  environments:
    - uid
  assets:
    - uid
  coachConfigs:
    - coach-config
submission:
  stripCacheDirectories: true
  ignoreLeaderboardCache: true
```

#### Notes

- `packageContents` is an authored manifest of included logical records, not a search index.
- `session.entries` resolve to exact ids; they do not use loose song/mode/difficulty matching.
- Each entry chooses exactly one `environmentId`.
- `assetSelections` is a keyed map by asset type. Current direction is **one selected asset per asset type per entry**.
- If two consecutive entries reference the same `environmentId` or asset ids, runtime may still unload/reload them at the transition boundary.
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
tags:
  - boxing
  - cardio
```

### `routines/<routine-id>.yaml`

#### Owns

- one song interpreted through one gameplay mode
- routine identity and authorship
- references to its chart ids

#### Must not own

- workout sequencing
- environment/asset selections for a workout entry
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

There is exactly one coach-config YAML per workout package.

It may describe one or more featured coaches, but the package owns only one workout-level coaching config domain.

#### Owns

- workout-level coach configuration
- featured coach roster used by the package
- media/overlay references for coaching moments
- package-local mappings from workout/chart moments to coaching assets

#### Must not own

- discoverability/catalog state
- player-specific preferences
- reusable cross-package inheritance rules

#### Canonical field direction

```yaml
schemaId: aerobeat.coach-config.v1
schemaVersion: 1
recordVersion: 1
coachConfigId: coach-config
coachConfigName: string
defaultCoachId: uid
featuredCoaches:
  - coachId: uid
    coachName: string
    avatarAssetId: uid
    voiceAssetId: uid
    introVideoPath: media/coaching/coach-a-intro.mp4
overlays:
  - overlayId: uid
    trigger:
      chartId: uid
      eventKey: intro
    coachId: uid
    mediaType: video
    path: media/coaching/coach-a-cue.mp4
```

### `environments/<environment-id>.yaml`

#### Owns

- package-local environment identity
- environment scene/art/lighting references
- authored environment metadata needed to load the environment in playback

#### Must not own

- workout entry order
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
- `coach_avatar`
- `coach_voice`

Direction notes:

- `gloves`, `targets`, `obstacles`, and `trails` are the **entry-selectable gameplay-facing asset types** referenced from `session.entries[*].assetSelections`.
- `coach_avatar` and `coach_voice` are **coach-config-referenced support asset types**. They exist so coach media/resources can still live under the same package asset system without inventing a separate asset contract.
- v1 should **not** introduce broader freeform categories such as `misc`, `custom`, or implementation-specific plugin types. If AeroBeat later needs more asset families, add them through a deliberate schema revision rather than string drift.
- Missing entry selections mean “use runtime/default presentation behavior for that asset type,” not inheritance from another package.

## Relationship and reference rules

1. `workout.yaml` is the package root and authoritative session manifest.
2. `session.entries[*].chartId` must reference a chart in `charts/`.
3. Each chart must reference exactly one routine in `routines/`.
4. Each routine must reference exactly one song in `songs/`.
5. Each session entry must choose exactly one environment id.
6. Each session entry may choose zero or one asset id for each entry-selectable asset type; it must not choose multiple assets for the same asset type in the same entry.
7. `coach_avatar` and `coach_voice` assets are referenced from `coaches/coach-config.yaml`, not from workout entry asset-selection maps.
8. The single coach-config file may define multiple coaches and overlays referenced by session entries.
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

AeroBeat currently needs two SQLite shapes:

1. a root `workouts.db` catalog/index database
2. a package-local `leaderboard-cache.db` database

## `workouts.db` v1 direction

`workouts.db` lives at the workouts root and indexes installed packages for browse/search/filter/discovery.

### Responsibilities

- discover installed workouts quickly
- expose denormalized browse metadata without reparsing all YAML files
- track install/update/indexing state
- support local client browse/filter views
- feed the local installed-workout browse surface only

### Must not become

- the only source of package truth
- the place where authored chart/song/workout semantics originate
- the authoritative leaderboard store
- the exact schema for a downloaded online catalog snapshot

### Minimum v1 tables

#### `workouts`

One row per installed workout package.

Suggested columns:

- `workout_id TEXT PRIMARY KEY`
- `workout_name TEXT NOT NULL`
- `description TEXT`
- `package_version TEXT NOT NULL`
- `schema_version INTEGER NOT NULL`
- `created_by_tool TEXT`
- `created_by_tool_version TEXT`
- `coach_config_id TEXT`
- `default_coach_name TEXT`
- `workout_yaml_path TEXT NOT NULL`
- `package_root_path TEXT NOT NULL`
- `cover_art_path TEXT`
- `installed_at TEXT NOT NULL`
- `indexed_at TEXT NOT NULL`
- `updated_at TEXT`
- `is_installed INTEGER NOT NULL DEFAULT 1`
- `is_valid INTEGER NOT NULL DEFAULT 1`
- `validation_error TEXT`

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

#### `workout_songs`

A lightweight denormalized song summary per installed workout.

- `workout_id TEXT NOT NULL`
- `song_id TEXT NOT NULL`
- `song_name TEXT NOT NULL`
- `artist_name TEXT`
- `duration_ms INTEGER`
- `PRIMARY KEY (workout_id, song_id)`

#### `workout_assets`

Optional but useful summary table for moderation/debug/search by asset usage.

- `workout_id TEXT NOT NULL`
- `entry_id TEXT NOT NULL`
- `asset_type TEXT NOT NULL`
- `asset_id TEXT NOT NULL`
- `PRIMARY KEY (workout_id, entry_id, asset_type)`

### Indexing notes

- `workouts.db` stores duplicated browse metadata on purpose.
- If YAML and `workouts.db` disagree, YAML plus package validation is the truth source; the index should be rebuilt.
- A workout may remain locally installed/playable even if future remote catalog state would make it undiscoverable online.

### Locked online catalog direction

A downloaded online catalog SQLite should **intentionally diverge** from local `workouts.db` rather than mirror it byte-for-byte.

Why:

- local `workouts.db` is about **installed package state**, filesystem paths, validation results, and fast local resolution into `workout.yaml`
- an online catalog snapshot is about **remote discoverability/distribution metadata**, not local install state
- forcing both concerns into one exact schema would either pollute the local index with remote-only concerns or pollute the remote snapshot with meaningless local path/install columns

The recommended v1 direction is:

- keep `workouts.db` as the local installed index only
- if/when AeroBeat ships a downloaded catalog snapshot, treat it as a sibling DB such as `catalog.db`
- let `catalog.db` reuse the **same logical browse vocabulary** where helpful (`workouts`, tags, modes, difficulties, song summaries), but give it its own columns for remote concerns such as package source, download URL, file size, content hash, publication/moderation state, and remote timestamps
- do not require `workout_yaml_path`, `package_root_path`, `installed_at`, `indexed_at`, `is_installed`, `is_valid`, or `validation_error` in the online catalog DB

This preserves a clean authority split: authored truth in package YAML, local discoverability in `workouts.db`, remote discoverability/distribution in a future sibling catalog DB.

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
- referenced songs/routines/charts/environments/assets exist
- package-local media paths exist
- ids are unique and references are coherent
- each session entry has one environment and at most one asset per entry-selectable asset type

### Index validation

Check:

- `workouts.db` rows reflect current installed packages
- denormalized metadata matches current YAML-derived values
- invalid packages are flagged rather than silently indexed as healthy
- no remote-catalog-only fields or assumptions have leaked into the local installed index contract

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
2. the future remote catalog schema beyond the now-locked rule that it should be a sibling DB rather than an exact mirror of local `workouts.db`
3. any package signing, trust chain, embedded signature, or distribution-integrity manifest inside authored package YAML
4. future moderation/ranking/distribution tables for remote catalog workflows
5. richer asset families beyond the locked v1 `assetType` enum

## Current recommendation

For the first implementation-oriented package/storage pass, AeroBeat should proceed assuming:

- authored truth lives in package YAML
- discoverability for installed workouts lives in local `workouts.db` only
- any future downloaded online catalog SQLite should be a sibling remote-catalog DB, not an exact mirror of local `workouts.db`
- leaderboard browsing cache lives in package-local `leaderboard-cache.db` only
- packages are self-contained and duplication/fork-based rather than inheritance-based
- `coaches/`, `environments/`, and `assets/` are first-class content domains
- `assetType` is a strict v1 enum: `gloves`, `targets`, `obstacles`, `trails`, `coach_avatar`, `coach_voice`
- each session entry resolves exact chart/routine/song ids plus one environment and at most one selected asset per entry-selectable asset type
- package signing/integrity metadata is explicitly deferred from the v1 authored package contract
- runtime may still do per-entry unload/reload even when ids repeat
- first-party and community packages share the same conceptual system

That is the cleanest v1 contract that matches the current AeroBeat decisions and is concrete enough to guide implementation.