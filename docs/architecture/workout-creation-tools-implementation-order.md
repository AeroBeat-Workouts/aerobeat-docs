# Workout Creation Tools Implementation Order

This document defines the current canonical **implementation order** for the AeroBeat workout creation tools repo.

It builds on the already-locked decisions in:

- `docs/architecture/workout-creation-tools-architecture.md`
- `docs/architecture/workout-creation-tools-import-format-matrix.md`
- `docs/architecture/workout-creation-tools-cli-surface.md`
- `docs/architecture/content-repo-shapes.md`
- `docs/architecture/content-lane-implementation-phases.md`
- `docs/architecture/workout-package-storage-and-discovery.md`

The goal is to give the repo a safe staged path from nothing to a usable workout-package authoring product without front-loading Penpot-driven GUI work or the heavyweight chart editor.

## Purpose

This is a milestone-ordering document, not a sprint plan.

It exists to answer:

- what should be implemented first
- what each stage depends on
- why that order is safe
- which slices can start before GUI design is finalized
- where the chart editor belongs relative to the rest of the product

It does **not** reopen the already-locked architecture, CLI split, package storage rules, accepted-import-format matrix, or optimization deferrals.

## Ordering rules

The implementation order should preserve the following rules throughout the repo build-out:

1. **Package contracts stay upstream.** The workout creation tools repo consumes durable content/package contracts rather than redefining them locally.
2. **Headless foundations come before GUI scenes.** Validation, package graph loading, import normalization, repair, migration, and packaging should exist as reusable services before scene work depends on them.
3. **Package-wide orchestration comes early.** `workout`-level package validation and package-home workflows should be real before domain scenes or import helpers try to act authoritative.
4. **Simple form workflows come before specialized timeline editing.** The chart editor is the heavyweight slice and should follow the lower-risk package, record, and media-foundation milestones.
5. **Penpot is a dependency for polished GUI implementation, not for starting the repo.** Early repo work should progress through shared services, CLI surfaces, package-shell scaffolding, and import/validation foundations before detailed scene implementation begins.
6. **Deferred optimization work stays deferred.** KTX2, Draco, and broader runtime-asset optimization are not milestone gates for this first implementation order.

## Recommended milestone sequence

## Milestone 1 — Repo skeleton and shared workflow foundations

### Goal

Stand up the workout creation tools repo with the internal seams needed by both CLI and future GUI surfaces.

### Primary work

- create the concrete workout creation tools repo and baseline project structure
- wire dependencies on `aerobeat-content-core` and `aerobeat-tool-core`
- create the shared internal service areas already implied by the CLI surface spec:
  - package graph / record loading
  - validation
  - fix / repair
  - migration
  - import / normalization
  - packaging
  - I/O and canonical filename helpers
- establish terminal and JSON result DTO mapping for future CLI commands
- make `ffmpeg` integration a first-class dependency of the import/normalization layer

### Why this comes first

Everything else depends on this layer. It is the cleanest way to keep the repo aligned with the locked rule that CLI and GUI flows should reuse the same workflow services.

### Dependencies

- the already-locked architecture and CLI surface decisions
- stable content/package contracts from the content lane

### Exit criteria

- the repo can load package content through shared services
- the repo has stable internal seams for validation/import/fix/packaging work
- the repo is not forced to invent GUI-only logic later

## Milestone 2 — Package shell, package graph, and `workout` package validation

### Goal

Make the package root real early by shipping the package-home orchestration behavior before domain-specific convenience work grows around it.

### Primary work

- implement package-shell bootstrap behavior such as `workout import package-shell` or equivalent package initialization flow
- implement package graph loading rooted at `workout.yaml`
- ship `aerobeat-workout validate` as the first durable public command
- validate package topology, ordered `setId` wiring, domain record discovery, required folders, and package-local reference integrity
- implement `aerobeat-workout inspect` so package health and topology are visible early

### Why this comes second

The workout tool is the package-wide orchestrator in the locked architecture. Shipping this early establishes the real authority boundary before the team spends time on domain-local helpers.

It also gives future authors and CI a truthful package-level entrypoint before any GUI exists.

### Dependencies

- milestone 1 shared package graph and validation foundations
- package storage/discovery rules

### Exit criteria

- a package can be bootstrapped and inspected headlessly
- package-wide validation exists and fails clearly on broken structure/reference issues
- package-home orchestration is established as the top-level workflow

## Milestone 3 — Domain-local validate and inspect surfaces

### Goal

Add the low-risk domain tools that make authoring and debugging practical without pretending to replace package-wide validation.

### Primary work

- ship domain-local `validate` and `inspect` commands for:
  - `song`
  - `chart`
  - `set`
  - `coach-config`
  - `environment`
- enforce the locked validation boundary that domain validation is domain-local, not full-package authority
- return human-readable and structured JSON diagnostics consistently across the tool set
- ensure direct file-existence and record-shape checks are reliable per domain

### Why this comes third

Once package-wide validation exists, domain tools become safe productivity multipliers. They help authors iterate quickly without weakening the package-root authority model.

This milestone is still headless-first, low-risk, and useful even while GUI planning and Penpot work are incomplete.

### Dependencies

- milestone 2 package graph behavior
- shared validation/result plumbing from milestone 1

### Exit criteria

- each YAML domain has a usable headless validation/inspection path
- the separate-tool public surface is real and testable
- package-wide versus domain-local validation boundaries are clear in behavior, not just docs

## Milestone 4 — Explicit repair and migration flows

### Goal

Make invalid or out-of-date packages recoverable through intentional workflows rather than hidden mutation.

### Primary work

- implement `fix` flows beginning with package-wide `aerobeat-workout fix`
- add targeted `fix-*` flows only where specific repair classes justify them
- implement migration flows for package and domain records where schema/layout upgrades are approved
- ensure validation hard-errors on fixable problems and points users toward explicit repair
- shape outputs so future GUI confirmation dialogs can delegate to the same repair/migration services

### Why this comes here

Repair and migration need the package graph and validators to be trustworthy first. They should also land before rich import and scene work, because import and GUI editing become much safer when the repo already knows how to handle stale or structurally invalid content honestly.

### Dependencies

- milestone 2 package-wide validation
- milestone 3 domain-local diagnostics

### Exit criteria

- the repo can explicitly repair known safe structural/content issues
- out-of-date packages have a migration path
- GUI work later can call real repair/migration services instead of inventing ad hoc mutation logic

## Milestone 5 — Slot-aware media import and canonicalization

### Goal

Ship the practical authoring workflows that turn creator-side media into valid package-local assets and updated YAML references.

### Primary work

- implement slot-aware import flows aligned with the import matrix:
  - song audio
  - coaching overlay audio
  - coaching warm-up video
  - coaching cool-down video
  - environment background image
  - environment background video
  - environment GLB
  - package/workout art image where applicable
- normalize accepted source formats into canonical stored package formats
- copy into canonical package folders
- apply normalized uid-suffixed filenames
- update YAML references
- delete superseded slotted package assets when replacing existing media
- support the bounded image crop/resize flow before canonical `.png` storage where needed

### Why this comes before GUI scenes

Import is one of the highest-value product workflows and does not require scene design to start. It is also a major shared-service dependency for both CLI and GUI.

Landing import foundations before scene implementation keeps the future GUI thinner and prevents scene work from owning bespoke file normalization behavior.

### Dependencies

- milestone 1 import/normalization service seams
- milestone 4 repair/migration behavior for honest handling of stale content
- the locked import-format matrix

### Exit criteria

- authors can headlessly import the major package media slots into canonical package form
- replacement flows remove old slotted assets correctly
- future GUI media pickers can delegate to stable import services

## Milestone 6 — Packaging/build workflows and CI-ready headless product

### Goal

Reach the first complete non-GUI product slice: a repo that can bootstrap, inspect, validate, fix, migrate, import, and package a workout.

### Primary work

- implement `aerobeat-workout package`
- ensure packaged output is built only from validated canonical package content
- add CI-friendly automation coverage for the main headless workflows
- add practical fixtures/examples proving end-to-end package authoring and packaging
- tighten exit codes and structured output for scripting/editor integration

### Why this milestone matters

This is the first point where the repo is a coherent authoring product even with no Godot scene implementation. It de-risks the rest of the roadmap by proving the package and workflow foundations are sound.

### Dependencies

- milestones 2 through 5

### Exit criteria

- the repo can complete the baseline headless workflow categories documented in the CLI surface spec
- package assembly is real and automatable
- the non-GUI product is already useful to creators and CI

## Milestone 7 — Penpot-informed package-home and simple form scenes

### Goal

Begin GUI implementation only after the headless core exists and Penpot has supplied the first-pass screen/design direction.

### Primary work

- finalize Penpot designs for the package-home flow and the simpler YAML scenes
- implement the `workout.yaml` package-home scene first
- wire package-home actions to the already-shipped shared services for:
  - package validation
  - inspect/health display
  - fix/repair confirmation flow
  - migration
  - packaging
  - navigation into domain editors
- implement the simpler form-oriented scenes next:
  - `song`
  - `set`
  - `coach-config`
  - `environment`
- keep these scenes focused on form editing, validation messaging, media-slot flows, preview where appropriate, and relationship navigation

### Why the GUI starts here

By this point the underlying repo already knows how to validate, repair, import, and package content. That means GUI work can concentrate on user experience rather than inventing core behavior.

This is also the right point to depend on Penpot, because the remaining work is now truly scene and interaction design rather than foundational product logic.

### Dependencies

- milestone 6 headless-complete foundation
- Penpot designs for package-home and simple forms

### Exit criteria

- package-home GUI exists on top of real package services
- the simple non-chart YAML scenes can edit and validate against shared logic
- GUI repair uses explicit confirmation and delegates to package-wide fix flows

## Milestone 8 — Chart editor scene and chart-specific high-complexity workflows

### Goal

Build the heavyweight specialized chart-authoring slice after the repo already supports the rest of the package lifecycle.

### Primary work

- implement the dedicated chart editor scene
- support chosen-audio chart creation flow
- add waveform/timeline scrubbing and beat placement
- add preview/playback behavior
- add chart-local validation and repair handoff using shared services
- begin chart-specific import/conversion flows as needed by the locked CLI surface
- leave future quick-test launch from selected timeline points as a chart-scene extension once the base editor is stable

### Why this is later

The chart editor is the most specialized and interaction-heavy part of the product. Front-loading it would delay the broader package-authoring value while core package/import/validation architecture is still settling.

Putting it after the simpler scenes preserves the locked product truth: workout creation is a full-package product, and chart editing is one heavyweight slice inside it, not the only thing that matters.

### Dependencies

- milestone 5 media import foundations
- milestone 7 GUI framework and shared scene/service patterns
- package-home and supporting record editors already working

### Exit criteria

- creators can author and edit charts inside the dedicated chart scene
- the chart editor reuses the repo's shared validation/import/repair foundations instead of bypassing them
- chart work no longer blocks the rest of the tool repo from being useful

## Milestone 9 — Embedded assembly integration via GodotEnv

### Goal

Expose the workout creation tools inside `aerobeat-assembly-community` as an embedded mode after the standalone product path is already solid.

### Primary work

- integrate the tool repo into the assembly through GodotEnv
- support entry into the tool mode from the main shell
- support clean navigation back to the main shell
- validate that embedded use still calls the same shared tool services and scenes
- keep ownership, testing, and release boundaries with the separate tool repo intact

### Why this is last

Embedded access is valuable, but it is a distribution/UX integration layer, not the repo's architectural foundation. The tool should already be coherent before it is embedded elsewhere.

### Dependencies

- milestone 7 basic GUI product
- milestone 8 chart editor for near-complete in-tool authoring coverage
- stable GodotEnv integration path

### Exit criteria

- the tool can run as an embedded mode without becoming owned by the assembly repo
- navigation into and out of the tool mode is real
- standalone and embedded usage share the same implementation foundations

## Dependency summary

The safe dependency chain is:

1. shared services and repo skeleton
2. package graph and package-wide `workout` orchestration
3. domain-local validate/inspect
4. explicit repair and migration
5. slot-aware media import/canonicalization
6. packaging/build and CI-ready headless completeness
7. Penpot-informed package-home and simple form scenes
8. chart editor scene
9. embedded assembly integration

The key ordering truth is that **the repo should become a useful headless workout-package authoring product before Godot scene implementation begins**.

## What should not gate early progress

The following should **not** block milestones 1 through 6:

- final Penpot GUI screens
- chart editor scene design details
- assembly embedding work
- KTX2 texture pipelines
- Draco-compressed GLB
- broader media-production/editor ambitions outside bounded package authoring

Those are either later-slice dependencies or explicitly deferred scope.

## Practical rationale

This order is recommended because it creates value early while keeping architecture honest:

- it proves the package-root and CLI authority boundaries first
- it gives CI and automation a real product surface early
- it makes GUI work thinner by pushing scene implementation onto already-real services
- it keeps import/validation/package rules centralized instead of scattering them across scenes
- it delays the highest-complexity chart UX until the rest of the package product is already stable
- it preserves the separate-repo, shared-service, embedded-later direction already locked elsewhere

## Non-goals of this implementation-order doc

This document does **not** define:

- detailed sprint planning
- exact staffing or ownership per milestone
- exact command syntax beyond what the CLI surface spec already covers
- exact Penpot screen layouts
- optimization roadmap work beyond noting that it remains deferred
- a requirement to finish the chart editor before the repo becomes useful

## Canonical summary

If the team needs a short version, the canonical implementation order is:

1. **shared repo foundations**
2. **package-root workout validation/inspect/bootstrap**
3. **domain-local validate/inspect tools**
4. **explicit fix and migration flows**
5. **slot-aware media import and canonicalization**
6. **package/build workflows for a headless-complete product**
7. **Penpot-informed package-home and simple form scenes**
8. **dedicated chart editor scene**
9. **embedded assembly integration via GodotEnv**

That is the safest staged path that matches the current locked architecture and keeps the chart editor in its proper place as a later heavyweight slice rather than the repo's starting point.
