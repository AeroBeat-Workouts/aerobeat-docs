# Workout Package Storage and Discovery

This document defines the current canonical direction for how AeroBeat workout packages are authored, stored on disk, discovered at runtime, and indexed for browsing.

The package system is grounded in these locked decisions:

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
- `sets/` is the package's single source of truth for workout composition
- `workout.yaml` owns package metadata plus the ordered list of `setId` values, not the full composition payload inline
- `sets/*.yaml` link song/chart/environment/assets/coaching overlay ids together using ids, not paths
- `songs/*.yaml` do not link to charts/sets/workouts
- `charts/*.yaml` do not link to songs/sets/workouts
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

The durable package hierarchy is now:

- **Song**
  - reusable audio/timing identity
- **Chart**
  - one exact playable difficulty slice
- **Set**
  - one package-local composition record linking exact ids
- **Workout**
  - the workout/package root that orders authored sets

Related package-local domains also include:

- **Coach Config**
  - the workout-level coaching/media registry for that package
- **Environment**
  - a reusable environment record authorable inside the package
- **Asset**
  - a reusable per-type asset record authorable inside the package

All primary ids are UIDs and follow the same naming rule where applicable:

- `songId`, `songName`
- `chartId`, `chartName`
- `setId`, `setName`
- `workoutId`, `workoutName`
- `coachConfigId`, `coachConfigName`
- `environmentId`, `environmentName`
- `assetId`, `assetName`

## Authority split: authored package vs derived indexes/caches

AeroBeat intentionally splits authority across three layers.

### 1. Package YAML = durable authored truth

The package YAML files are the canonical authored content payload.

They own:

- workout set definition through `sets/*.yaml`
- songs, charts, sets
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
        ├── charts/
        │   └── <chart-id>.yaml
        ├── sets/
        │   └── <set-id>.yaml
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
2. `songs/`, `charts/`, `sets/`, `coaches/`, `environments/`, and `assets/` are distinct content-domain folders.
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

Exception: the minimal disabled sentinel form of `coaches/coach-config.yaml` may be exactly `enabled: false` without the usual provenance block. Once coaching is enabled, coach-config returns to the normal authored-record rule and should carry the same schema/provenance fields as the other YAML records.

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

`workout.yaml` combines package manifest metadata and workout-level ordering.

#### Owns

- package identity/version metadata
- workout identity/description
- package-local default coach config reference
- ordered workout set ids
- package-level preview metadata

#### Must not own

- inlined set composition payloads
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
setOrder:
  - uid
  - uid
```

#### Notes

- `setOrder` resolves to exact `setId` values; it does not use loose song/feature/difficulty matching.
- Full composition details live in `sets/*.yaml`, not in `workout.yaml`.
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
- set/workout composition links
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
  licenseType: creator_noncommercial
  streamingSafe: true
  aiAssisted: false
audio:
  filePath: media/audio/song.ogg
  durationMs: 180000
  previewStartMs: 30000
timing:
  anchorMs: 0
  tempoSegments:
    - startBeat: 0
      bpm: 128
  stopSegments: []
  timeSignatureSegments:
    - startBeat: 0
      numerator: 4
      denominator: 4
metadata:
  explicit: false
  language: en
  genres:
    - edm
```

#### Notes

- `songs/*.yaml` should not point to charts, sets, or workouts.
- `licensing` belongs on the song because the audio asset is the reusable source.
- `songs/*.yaml` own the canonical reusable timing truth for the package.
- `timing.anchorMs` is the canonical beat-zero anchor in integer milliseconds.
- `timing.tempoSegments` is the only approved tempo-map form; do not add a parallel `timing.bpm` shortcut.
- `timing.stopSegments` are explicit deterministic timing-map holds.
- `timing.timeSignatureSegments` declare canonical musical meter plus recommended authoring guidance; chart/gameplay-mode-specific snap behavior remains separate later contract work.

### `charts/<chart-id>.yaml`

#### Owns

- chart identity
- gameplay `feature`
- exact difficulty slice
- boxing beat payloads aligned to song-owned timing
- flow beat payloads aligned to song-owned timing
- any future cross-feature chart fields that are explicitly promoted into the shared contract later

#### Must not own

- song references
- set references
- environment/asset selections
- browse/discovery state

#### Canonical boxing field direction for this pass

```yaml
schemaId: aerobeat.chart.boxing.v1
schemaVersion: 1
recordVersion: 1
createdByTool: aerobeat-tool-content-authoring
createdByToolVersion: 0.1.0
createdAt: 2026-04-25T19:00:00Z
updatedAt: 2026-04-29T09:40:00Z
chartId: uid
chartName: string
feature: boxing
difficulty: medium
beats:
  - start: 8.0
    type: jab
  - start: 12.0
    type: cross
  - start: 16.0
    end: 17.0
    type: guard
    portal: 0
```

#### Notes

- `charts/*.yaml` are intentionally reusable exact playable slices.
- For boxing authoring in this pass, use `feature`, not `mode`.
- Boxing authored entries live under `beats`, not `events`.
- Each boxing beat has required float `start`, optional inclusive float `end`, required concrete `type`, and optional integer `portal` in `0-11` defaulting to `0`.
- Boxing charts do not author `zone`, symbolic portal strings, nested subtype payloads, or old boxing timing fields such as `holdMs` / `durationMs`.
- They do not contain `songId`, `setId`, or older routine linkage fields.
- Set files provide the package-local wiring from chart ids to song/environment/coaching choices.

#### Canonical flow field direction for this pass

```yaml
schemaId: aerobeat.chart.flow.v1
schemaVersion: 1
recordVersion: 1
createdByTool: aerobeat-tool-content-authoring
createdByToolVersion: 0.1.0
createdAt: 2026-04-29T16:00:00Z
updatedAt: 2026-04-29T16:00:00Z
chartId: uid
chartName: string
feature: flow
difficulty: medium
beats:
  - start: 8.0
    type: swing_left
    portal: 0
    placement: 2
    direction: 3
  - start: 9.0
    type: trail_right
    portal: 1
    placement: 4
  - start: 10.0
    type: reward_left
    placement: 12
  - start: 12.0
    end: 13.0
    type: squat
```

#### Notes

- For Flow authoring in this pass, use `feature`, not `mode`.
- Flow authored entries live under `beats`, not `events`.
- Each Flow beat has required float `start`, optional inclusive float `end`, required concrete `type`, optional integer `portal` in `0-11`, optional integer `placement` in `0-12`, and optional integer `direction` in `0-11`.
- `portal` means origin/presentation source, `placement` means where around the athlete the beat passes, and `direction` means swing/follow-through guidance.
- `swing_left`, `swing_right`, `trail_left`, `trail_right`, `warn_left`, and `warn_right` support both `placement` and `direction`.
- `reward_left` and `reward_right` support `placement` only.
- `squat`, `lean_left`, `lean_right`, `knee_left`, `knee_right`, `leg_lift_left`, `leg_lift_right`, and `run_in_place` support neither `placement` nor `direction`.
- For `swing_*`, `trail_*`, and `warn_*`, omitted `direction` inherits from `placement`.
- This document's inline examples focus on Boxing and Flow, but the shared chart direction now also includes the first-pass Dance shape: flat `beats` with required `start` + `type`, optional inclusive `end`, and optional boolean `gold`.
- Step payload details remain follow-up work.

### `sets/<set-id>.yaml`

#### Owns

- set identity
- exact package-local composition links for one playable slice
- selected song/chart/environment ids
- selected asset ids keyed by asset type
- optional coaching overlay id

#### Must not own

- global workout ordering
- song licensing/timing truth
- chart event payloads
- raw file paths for linked song/chart/environment/asset/coaching content

#### Canonical field direction

```yaml
schemaId: aerobeat.set.v1
schemaVersion: 1
recordVersion: 1
createdByTool: aerobeat-tool-content-authoring
createdByToolVersion: 0.1.0
createdAt: 2026-04-25T19:00:00Z
updatedAt: 2026-04-25T19:20:00Z
setId: uid
setName: string
songId: uid
chartId: uid
environmentId: uid
coachingOverlayId: uid
assetSelections:
  gloves: uid
  targets: uid
  obstacles: uid
  trails: uid
```

#### Notes

- This is the package's **single source of truth** for workout composition.
- The set record links ids only. It does not duplicate media paths that already live in the referenced records.
- `coachingOverlayId` is optional because coaching can be disabled package-wide.
- If coaching is enabled, validators should require a valid referenced overlay id for every set.

### `coaches/coach-config.yaml`

There is exactly one coach-config YAML per workout package. Coaching is optional all-or-nothing: disabled coaching uses `enabled: false`; enabled coaching owns the workout's roster and coaching media registry.

#### Enabled coaching canonical field direction

```yaml
schemaId: aerobeat.coach-config.v1
schemaVersion: 1
recordVersion: 1
createdByTool: aerobeat-tool-content-authoring
createdByToolVersion: 0.1.0
createdAt: 2026-04-25T19:00:00Z
updatedAt: 2026-04-25T19:20:00Z
enabled: true
coachConfigId: coach-config
coachConfigName: string
featuredCoaches:
  - coachId: uid
    coachName: string
warmupVideo:
  mediaId: uid
  path: media/coaching/warmup.mp4
cooldownVideo:
  mediaId: uid
  path: media/coaching/cooldown.mp4
overlayAudio:
  - overlayId: uid
    coachId: uid
    mediaId: uid
    path: media/coaching/set-overlay.ogg
```

#### Disabled coaching canonical field direction

```yaml
enabled: false
```

#### Notes

- `coach-config.yaml` acts as a reusable coaching media/roster registry for the package.
- The disabled sentinel exception is intentionally tiny: `enabled: false` may stand alone without the normal schema/provenance block.
- It does not map overlays directly to `setId`; set files choose overlays by `coachingOverlayId`.
- Enabled coaching requires one warmup video and one cooldown video for the package.
- Enabled coaching may define multiple featured coaches and multiple overlay audio records.

### `environments/<environment-id>.yaml`

Environment records remain reusable package-local presentation records. They own environment identity plus resource references needed to load the environment, and they follow the shared authored-record schema/provenance field block described above.

### `assets/<asset-id>.yaml`

Asset records remain reusable package-local gameplay-facing asset records. They own asset identity, asset type, and the resource path for the asset payload, and they follow the shared authored-record schema/provenance field block described above.

## Validation rules

At minimum, package validators should enforce:

1. Exactly one `workout.yaml` exists at the package root.
2. Every `setOrder[*]` value must resolve to one file in `sets/`.
3. Each set must reference exactly one song in `songs/`.
4. Each set must reference exactly one chart in `charts/`.
5. Each set must reference exactly one environment in `environments/`.
6. Every referenced asset id must exist in `assets/` and its `assetType` must match the key used in `assetSelections`.
7. The single coach-config file may define multiple coaches.
8. If coaching is disabled, set files must not require `coachingOverlayId`.
9. If coaching is enabled, coach-config must include one warmup video, one cooldown video, and every set must reference exactly one valid overlay audio record by `coachingOverlayId`.
10. `songs/*.yaml` must not link to charts/sets/workouts.
11. `charts/*.yaml` must not link to songs/sets/workouts.
12. All package-local media/resource paths referenced by authored records must exist.
13. `leaderboard-cache.db` must be treated as disposable and must not be required for package validity.

## Discovery/indexing direction for `workouts.db`

`workouts.db` is derived data for browse/search/install workflows.

The shared catalog core tables should continue to summarize package data such as:

- workout identity and description
- features present in the workout (derived from referenced chart records)
- difficulties present in the workout (derived from referenced chart records)
- songs present in the workout (derived from referenced set -> song links)
- coaches present in the workout (derived from coach-config when enabled)
- genres present in the workout (derived from referenced songs)

The local installed-workout DB uses the core tables plus `workout_local`.
A future remote/distribution catalog snapshot should reuse the same core tables plus `workout_remote`.

## Runtime loading direction

A typical runtime/package loader should do this:

1. Discover package roots and parse `workout.yaml`.
2. Read `setOrder` to determine authored workout sequencing.
3. Load the referenced `sets/*.yaml` files.
4. From those set records, resolve the needed songs, charts, environments, assets, and optional coaching overlays.
5. Load `coaches/coach-config.yaml` if `coachConfigId` is present and coaching is enabled.
6. Build derived browse/cache state separately from authored package loading.

This ordering makes the workout root light, keeps composition authoritative in `sets/`, and prevents songs/charts from accumulating outward package-linkage responsibilities.

## What should be checked into source control

Check in:

- `workout.yaml`
- all authored YAML records under `songs/`, `charts/`, `sets/`, `coaches/`, `environments/`, and `assets/`
- required package-local media placeholders or authored media
- example SQL schema docs used for teaching the browse/cache split

Do not treat as authored truth:

- derived browse indexes regenerated from packages
- disposable local leaderboard cache content
- athlete/profile-specific overrides

## Summary

The durable workout-package contract is now set-centered:

- `songs/` own reusable music/licensing truth plus the package's canonical timing map (`anchorMs`, `tempoSegments`, `stopSegments`, `timeSignatureSegments`)
- `charts/` own exact playable authored payloads plus feature/difficulty semantics
- `sets/` own package-local composition wiring through ids only
- `workout.yaml` owns package metadata plus ordered `setId` references
- `coaches/coach-config.yaml` owns the package's coaching roster/media registry
- `workouts.db` and `leaderboard-cache.db` remain derived/supporting storage, not authored source of truth
