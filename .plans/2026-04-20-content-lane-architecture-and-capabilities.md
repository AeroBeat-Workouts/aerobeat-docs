# AeroBeat Content Lane Architecture and Capabilities

**Date:** 2026-04-20  
**Status:** In Progress  
**Agent:** Chip 🐱‍💻

---

## Goal

Define the architecture, contracts, responsibilities, and phased execution plan for the AeroBeat **Content** lane so AeroBeat can author, validate, store, load, and play music content and beat charts cleanly across tooling and runtime.

---

## Overview

Derrick assigned Chip to own the **Content** lane while Pico works on the Input lane. At this stage, the focus is primarily architecture docs and planning rather than immediate deep implementation. That means the first responsibility is to make the Content lane legible: what `aerobeat-content-core` owns, what belongs in tools versus runtime versus asset repos, and what capabilities the platform needs in order to read/write/play authored music content safely and consistently.

The critical content primitives are already established in the docs: `Song`, `Routine`, `Chart Variant`, and `Workout`. What is still missing is the end-to-end content capability model around them: file/resource contracts, content registries, chart envelopes, versioning rules, validation, import/export flows, workout sequencing, and how authored content is consumed by gameplay features during playback.

This plan should therefore produce a practical architecture roadmap for the Content lane. It should document the responsibilities of `aerobeat-content-core`, identify which later repos likely belong under Content or Tool ownership, and break the work into phases so implementation can start without collapsing contracts, tools, and runtime playback into one blob.

---

## REFERENCES

| ID | Description | Path |
| --- | --- | --- |
| `REF-01` | Six-core architecture ownership doc | `docs/architecture/overview.md` |
| `REF-02` | Repo map | `docs/architecture/repository-map.md` |
| `REF-03` | Content model canon | `docs/architecture/content-model.md` |
| `REF-04` | Repo-boundary planning doc | `.plans/2026-04-20-content-contracts-and-repo-boundaries.md` |
| `REF-05` | Beat chart / workout architecture plan | `.plans/2026-04-20-beat-chart-workout-architecture.md` |

---

## Questions This Plan Must Answer

1. What exactly does `aerobeat-content-core` own?
2. Which capabilities are runtime-facing versus tool-facing versus shared?
3. What file/resource/schema contracts are required to represent `Song`, `Routine`, `Chart Variant`, and `Workout`?
4. How should validation work across authoring tools and gameplay runtime?
5. What additional repos are likely needed later under the Content or Tool lanes?
6. What should the phased implementation path be, starting with docs and planning?

---

## Draft Scope For The Content Lane

### `aerobeat-content-core` likely owns
- canonical data/resource contracts for `Song`, `Routine`, `Chart Variant`, and `Workout`
- shared chart envelope contracts
- content ids / references / manifests
- content registry and lookup interfaces
- content validation result types and shared validation rules
- workout sequencing / selection contracts
- content versioning / schema-version rules
- shared import/export contract surfaces used by tools and runtime

### likely not owned by Content lane
- raw device interpretation → Input lane
- gameplay-mode scoring/spawning/hit interpretation → Feature lane
- avatars/cosmetics/environments/art-side resource contracts → Asset lane
- main app/platform interaction surfaces → UI lane
- backend/settings/service integrations that are not fundamentally content contracts → Tool lane

### likely adjacent future repos
Potential future repos to pressure-test later:
- content authoring tool repo(s)
- content validation tool/service repo(s)
- content ingestion/import repo(s)
- maybe a dedicated workout/choreography editor surface under Tool lane

---

## Phased Direction

### Phase 1 — Architecture
- define ownership boundaries
- define contracts and vocabulary
- define content capability matrix
- define planned repo topology for Content-related work

### Phase 2 — Contract design
- define resource/file/schema shapes
- define versioning and validation strategy
- define runtime/tooling interfaces

### Phase 3 — Tooling and runtime plan
- authoring flow
- validation flow
- import/export flow
- playback/workout sequencing flow

### Phase 4 — Repo creation recommendations
- recommend which new repos to create under content-core/tool-core once docs are approved

---

## Tasks

### Task 1: Audit current docs for the full Content lane surface area

**Bead ID:** `aerobeat-docs-njb`  
**SubAgent:** `research`  
**References:** `REF-01`, `REF-02`, `REF-03`, `REF-04`, `REF-05`  
**Prompt:** Re-read the current six-core architecture docs plus the beat chart/workout planning docs and summarize the current documented responsibilities, gaps, and unresolved questions for the Content lane.

**Folders Created/Deleted/Modified:**
- `docs/architecture/`
- `.plans/`

**Files Created/Deleted/Modified:**
- `.plans/2026-04-20-content-lane-architecture-and-capabilities.md`

**Status:** ✅ Complete

**Results:** Research pass complete across `overview.md`, `repository-map.md`, `content-model.md`, and the adjacent planning docs. Current documented Content-lane ownership is already fairly clear: `aerobeat-content-core` owns the durable authored-content contracts (`Song`, `Routine`, `Chart Variant`, `Workout`), the shared chart envelope, content ids/references/metadata, content loading + validation interfaces, interaction-family/device-compatibility fields, and workout/session sequencing contracts consumed by both tools and runtime. The surrounding docs also make several boundary decisions explicit: feature repos interpret content and athlete actions over time but do not own the durable content primitives; tool repos consume the same contracts for authoring/validation/import flows; assemblies compose the needed cores; charts target interaction families rather than raw devices; and view modes are mostly runtime/presentation concerns with authored hints rather than separate content silos.

The main gap is that the docs describe the canonical primitives and repo ownership more clearly than they describe the **capability surface** of the Content lane. We still need a deliberate capability model for registry/discovery, manifest/package boundaries, file/resource layout, schema/version migration rules, validation layering, import/export/ingestion flows, and runtime loading/playback handoff responsibilities. The existing docs mention loader/validation interfaces and workout sequencing contracts, but they do not yet spell out which responsibilities belong in `content-core` versus future tool repos or concrete gameplay repos.

The main unresolved questions to carry into the next pass are: (1) what the minimal canonical file/package structure is for songs/routines/chart variants/workouts; (2) whether registry/manifest/versioning live entirely in `content-core` or split between content-core contracts and tool-core implementations; (3) how validation is layered between cross-mode shared validation and mode-specific feature validation; (4) how import/export and ingestion pipelines should be divided between content and tool ownership; (5) whether workout references should default to `routine + difficulty` or exact `chartId`; and (6) how much authored presentation data is allowed before view/runtime concerns start leaking back into durable content contracts. This gives the next pass a clear job: turn the already-decided content primitives + boundaries into an explicit capability matrix and phased repo/tooling plan.

---

### Task 2: Define the Content lane capability model

**Bead ID:** `aerobeat-docs-mkg`  
**SubAgent:** `primary`  
**References:** `REF-01`, `REF-02`, `REF-03`, `REF-04`, `REF-05`  
**Prompt:** Define the full capability model for the Content lane: authored data contracts, validation, registries, import/export, workout sequencing, runtime consumption boundaries, and the split between content-core and tool-core responsibilities.

**Folders Created/Deleted/Modified:**
- `docs/architecture/`

**Files Created/Deleted/Modified:**
- `docs/architecture/content-model.md`
- `docs/architecture/repo-structure-reference.md`
- `docs/architecture/workflow.md`

**Status:** ✅ Complete

**Results:** Defined the missing Content-lane capability surface directly in the architecture docs. `docs/architecture/content-model.md` now makes the lane-specific decisions explicit instead of leaving them implicit: AeroBeat packages authored content as a manifest-backed **content package** whose durable records remain `Song`, `Routine`, `Chart Variant`, and `Workout`; package distribution/import/indexing is separate from record-level authoring/runtime selection; and binary media stays as referenced resources rather than replacing the structured contracts. The doc now also fixes the registry/discovery split: `aerobeat-content-core` owns package-manifest shape, ids/reference rules, registry query semantics, duplicate/missing-reference rules, and the meaning of content lookup, while concrete tools/runtime own scanning, remote catalog fetches, cache/index persistence, and install/update state.

The capability model now makes versioning, migration, and validation layering firm. Package and record schemas both version explicitly; breaking schema changes require a new version; unknown breaking versions are rejected unless a registered migration path exists. `aerobeat-content-core` owns schema identifiers, migration interfaces, and canonical migration/validation report types; `aerobeat-tool-core` owns author-facing migration workflows, batch upgrade jobs, and other operational tooling around those contracts; and feature repos may provide mode-specific payload migrations only through the shared interfaces. Validation is now documented as three layers: shared package/reference validation in content-core, mode-specific payload validation in feature repos, and environment/publish/import validation in tool/runtime layers.

The docs now also lock the remaining boundaries the research pass called out. Import/export/ingestion mechanics are explicitly tool responsibilities even when they land on shared DTO shapes from `aerobeat-content-core`. Workout sequencing stops at authored session intent and a chart-resolution handoff contract; feature/runtime begins at spawning, scoring, runtime assists, rendering, and fail/retry behavior. `docs/architecture/repo-structure-reference.md` and `docs/architecture/workflow.md` were updated to reflect the same decisions in repo-shape and workflow language, including content-package manifests, migration/workout-resolution interfaces, and the explicit split between content-core, feature-core, and tool-core responsibilities.

---

### Task 3: Produce a phased implementation/repo plan for Content ownership

**Bead ID:** `aerobeat-docs-m70`  
**SubAgent:** `primary`  
**References:** `REF-01`, `REF-02`, `REF-03`, `REF-04`, `REF-05`  
**Prompt:** Turn the Content lane architecture into a phased implementation plan, including likely future repos under content/tool ownership and the sequence for standing them up after the docs are approved.

**Folders Created/Deleted/Modified:**
- `docs/architecture/`
- `.plans/`

**Files Created/Deleted/Modified:**
- `docs/architecture/content-lane-implementation-phases.md`
- `.plans/2026-04-20-content-lane-architecture-and-capabilities.md`

**Status:** ✅ Complete

**Results:** Added `docs/architecture/content-lane-implementation-phases.md` to turn the approved Content-lane architecture into a dependency-aware execution plan. The phased plan is intentionally practical: Phase 1 finishes docs/contract decisions in `aerobeat-docs`; Phase 2 stands up `aerobeat-content-core` as the canonical owner of the durable content contracts; Phase 3 adds shared schema-version, manifest/registry, and cross-mode structural validation foundations in the content lane while leaving mode-specific semantic validation to `aerobeat-feature-core` and concrete feature repos; Phase 4 wires `aerobeat-tool-core` plus concrete authoring/ingestion workflows against those shared contracts without letting tool repos become schema owners; and Phase 5 integrates playback/runtime consumption in feature repos and assemblies using the same validated manifests and ids. Repo recommendations were kept conservative: create `aerobeat-content-core` now because the six-core model already justifies it; expect a concrete `aerobeat-tool-content-authoring` repo next once contract implementation exists; defer `aerobeat-tool-content-ingestion`, validator-service, registry-service, and any workout-only tool split until distinct ownership or release pressure actually appears.

---

### Task 4: Audit Content lane architecture and phased plan docs

**Bead ID:** `aerobeat-docs-cvh`  
**SubAgent:** `auditor`  
**References:** `REF-01`, `REF-02`, `REF-03`, `REF-04`, `REF-05`  
**Prompt:** Independently verify that the new Content lane docs are coherent, scoped correctly, and aligned with the six-core ownership model. Confirm that content-core owns the durable content contracts, that feature/tool boundaries are clear, and that the phased repo recommendations make sense.

**Folders Created/Deleted/Modified:**
- `docs/architecture/`
- `.plans/`

**Files Created/Deleted/Modified:**
- None expected from audit beyond plan updates

**Status:** ⏳ Pending

**Results:** Not started.

---

## Final Results

**Status:** ⏳ Pending

**What We Built:** Pending execution.

**Reference Check:** Pending.

**Commits:**
- Pending

**Lessons Learned:** Pending.

---

*Completed on Pending*
