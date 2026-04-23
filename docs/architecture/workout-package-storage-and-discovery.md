# Workout Package Storage and Discovery

This document captures the current draft direction for how AeroBeat workout content should be stored on disk, discovered by Godot at runtime, and indexed for local and online browsing.

It is intentionally grounded in the data-shape decisions made on 2026-04-23:

- the durable content model is `Song -> Routine -> Chart -> Workout`
- naming should stay consistent with `*Id` + `*Name` pairs where applicable
- all primary ids are UIDs
- authored durable records should use YAML rather than JSON so they remain comment-friendly and hand-editable
- workout packages should prefer copied/self-contained content rather than cross-package references
- package layout should use **separate YAML files** rather than one giant monolithic workout file
- `workout.yaml` should carry both workout metadata and manifest/version metadata
- a root `workouts.db` SQLite file should index installed workouts for search and discovery

This is a draft architecture proposal, not a finalized implementation contract.

## Design goals

The storage and discovery system should optimize for:

- **clarity** — easy to understand where content lives
- **debuggability** — easy to inspect broken or incomplete packages by looking at files on disk
- **symmetry** — first-party workouts and UGC workouts should use the same package shape
- **runtime friendliness** — Godot should be able to discover installed content without re-parsing every YAML file on every browse action
- **low-scope iteration** — early online browsing should be possible without requiring a large custom API surface on day one

## Core model recap

The content model being stored is:

- **Song**
  - reusable music/media identity and timing authority
- **Routine**
  - one song interpreted through one gameplay mode
- **Chart**
  - one concrete playable difficulty slice of a routine
- **Workout**
  - the programmed session that selects exact chart UIDs and owns workout-level coaching and package metadata

### Current naming direction

Use consistent naming where applicable:

- `songId`, `songName`
- `routineId`, `routineName`
- `chartId`, `chartName`
- `workoutId`, `workoutName`

## Storage model overview

AeroBeat should treat workout content as **self-contained installed packages on disk**.

Each workout package lives in its own folder under a shared workouts root. The package contains:

- one root `workout.yaml`
- separate YAML files for songs, routines, and charts
- copied media/artifacts required to run the workout

At the root of the workouts install location, AeroBeat also maintains a SQLite index:

- `workouts.db`

The split of responsibilities is:

- **YAML package files** = human-readable portable source of truth for each installed workout package
- **SQLite index** = searchable discovery/index layer for installed packages

## Why YAML

YAML is preferred over JSON for the authored package files because it gives us:

- comments
- easier hand-editing
- easier inspection during debugging
- a friendlier shape for creators and internal iteration

This is especially important because AeroBeat wants first-party and community-authored workouts to share the same packaging model.

## Why copied/self-contained packages

Packages should prefer copied content rather than required external references.

Reasons:

- easier to reason about what is actually installed
- easier to debug broken packages
- easier to move/share/archive/install/uninstall packages
- fewer hidden dependencies
- keeps first-party and UGC structurally identical

For now, package robustness matters more than deduplication.

## Package layout decision: separate files early

AeroBeat is explicitly choosing the **separate-files** path instead of a single giant `workout.yaml`.

Why:

- chart payloads will become large
- keeping chart data inline would make workout files noisy and hard to edit
- Songs, Routines, Charts, and Workouts are already distinct durable concepts
- separate files make validation and diffs easier to reason about

That means:

- `workout.yaml` stays focused on workout/package metadata and workout-owned session data
- `songs/` contains one YAML file per `Song`
- `routines/` contains one YAML file per `Routine`
- `charts/` contains one YAML file per `Chart`

## Proposed on-disk layout

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
        └── media/
            ├── audio/
            ├── video/
            ├── art/
            ├── coaching/
            └── scenes/
```

This keeps the package rule simple:

- the root contains `workout.yaml`
- every other major content family lives in its own subfolder
- those subfolders contain the YAML files and copied artifacts needed by the package

## `workout.yaml` responsibilities

`workout.yaml` should combine two concerns:

1. **Workout data**
2. **Manifest/version metadata**

The current direction is to avoid a separate manifest file unless a future need proves that split useful.

### `workout.yaml` should likely contain

- `workoutId`
- `workoutName`
- `description`
- `coachId`
- `coachName`
- workout-level default background scene selection
- pre-workout / warmup media references
- post-workout / cooldown media references
- ordered workout entries that resolve to exact chart UIDs
- workout-owned coaching overlays keyed to the referenced song/chart UIDs used in the workout
- tags or browse metadata needed as part of the durable workout definition
- version metadata such as:
  - workout/package version
  - schema version
  - creation tool name/version

### Versioning fields to carry

At minimum, the combined workout/manifest file should preserve the distinction between:

- **schema version** — how to interpret the file structure/contracts
- **package version** — which revision of this workout package this is
- **creation tool version** — which authoring/build tool generated the package

That gives AeroBeat enough information to reason about parsing, migration, and support/debugging.

## `Song`, `Routine`, and `Chart` YAML responsibilities

### `songs/<song-id>.yaml`

Owns reusable music/media identity, for example:

- `songId`
- `songName`
- artist/credits/licensing metadata
- audio/media references
- duration
- tempo map / beat grid authority
- tags/metadata

Must not own athlete/device-specific timing offsets.

### `routines/<routine-id>.yaml`

Owns one song interpreted through one gameplay mode, for example:

- `routineId`
- `routineName`
- `songId`
- `mode`
- `authorId`
- `authorName`
- `charts` as exact chart UIDs

`Routine` is intentionally lean.

### `charts/<chart-id>.yaml`

Owns one concrete playable difficulty slice, for example:

- `chartId`
- `chartName`
- `routineId`
- difficulty
- interaction-family compatibility fields where needed
- the authored timed event payload

Mode-global tuning such as hit windows should not be duplicated into each chart file.

## `workouts.db` responsibilities

`workouts.db` should be the runtime-searchable index of installed workouts.

It is **not** the canonical authored source of truth. It exists so Godot can efficiently discover, filter, and browse installed content without reparsing every package YAML on each browse pass.

### `workouts.db` should likely store

- the installed workout id
- the path to `workout.yaml`
- search/display metadata copied or denormalized from `workout.yaml`
- tags and filterable facets
- install/update timestamps
- version metadata needed for compatibility checks or refresh logic
- package presence/install-state information

### Candidate search fields

The exact schema still needs discussion, but likely candidates include:

- `workout_id`
- `workout_name`
- `description`
- `coach_id`
- `coach_name`
- `background_scene_id`
- `package_version`
- `schema_version`
- `creation_tool_version`
- `workout_yaml_path`
- tag summaries or normalized tag rows
- mode summaries
- difficulty summaries
- install timestamps / updated timestamps

A likely future split is:

- one main `workouts` table
- supporting normalized tables for tags, modes, songs, and charts when richer search becomes necessary

## Godot discovery flow

The current intended discovery model is:

1. Godot opens `workouts.db`
2. Godot queries installed workouts for browse/search/filter views
3. Godot resolves a selected workout entry to its `workout.yaml` path
4. Godot loads the package folder and referenced YAML/media files from disk
5. validation/loading resolves the Workout -> Chart -> Routine -> Song relationships for play

This keeps browse/search fast while preserving YAML package transparency.

## Install/update/remove flow

A likely package lifecycle is:

### Install

1. copy a self-contained workout package folder into `aerobeat-workouts/workouts/<workout-id>/`
2. validate the package structure and YAML files
3. update or insert the discovery metadata into `workouts.db`

### Update

1. replace or patch the package folder contents
2. revalidate the package
3. refresh the indexed search metadata in `workouts.db`

### Remove

1. delete the package folder
2. remove its index rows from `workouts.db`

## Local installed index vs online catalog snapshot

There are two related SQLite ideas in play:

### 1. Local installed index

This is the primary day-one use of `workouts.db`.
It describes what is actually installed on the current machine.

### 2. Downloaded online catalog snapshot

AeroBeat may also use the same general SQLite idea as a low-scope online catalog approach:

- download a SQLite snapshot from the server/cloud
- query it locally for browsing/search/filtering
- if a workout is not yet installed, download the package before play

This would provide a simpler path than building a full query API immediately.

### Why this is attractive

- simple to build
- simple local query model
- easy offline-ish browsing after sync
- avoids prematurely building a more complex backend

### Risks / open concerns

- snapshot sync/update semantics still need design
- integrity/versioning/tamper concerns need explicit handling
- large catalogs may eventually outgrow the snapshot model
- personalized/social/live features may still want a more traditional backend later

For now, the snapshot approach looks like a valid low-scope candidate rather than a final forever-architecture commitment.

## Validation direction

The package layout implies layered validation:

### Package-level validation

Check:

- folder shape
- required files exist
- `workout.yaml` exists and is parseable
- referenced `songs/`, `routines/`, `charts/`, and media files exist
- copied artifacts are present and paths stay package-local where required

### Content-level validation

Check:

- `Workout` references valid chart UIDs
- `Chart` references valid routine UIDs
- `Routine` references valid song UIDs
- mode/difficulty/content rules are consistent

### Index validation

Check:

- `workouts.db` reflects current installed packages
- indexed metadata stays in sync with the package YAML files

## Open questions

The following still need definition before implementation:

1. What exact fields are required vs optional in each YAML file?
2. What exact folder paths should media references use inside the package?
3. Should `workout.yaml` embed lightweight summaries of songs/charts for convenience, or should it stay reference-only?
4. What exact SQLite schema should `workouts.db` use on day one?
5. How should install/update/remove handle partially invalid packages?
6. How should the downloaded online-catalog SQLite snapshot be versioned and refreshed?
7. How much metadata should be duplicated into `workouts.db` versus resolved lazily from YAML when opening details?

## Current recommendation

For the first implementation-oriented storage direction, AeroBeat should proceed assuming:

- YAML is the durable authored package format
- packages are self-contained and copied rather than externally referenced
- package data is split across `workout.yaml`, `songs/`, `routines/`, and `charts/`
- `workout.yaml` combines workout metadata and manifest/version metadata
- `workouts.db` is the installed-workout discovery index
- a downloadable SQLite catalog snapshot is a viable low-scope candidate for online browsing later

That is the smallest clean storage/discovery shape that matches the decisions made so far.
