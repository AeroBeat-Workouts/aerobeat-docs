# AeroBeat Content Contracts and Repo Boundaries

**Date:** 2026-04-20  
**Status:** In Progress  
**Agent:** Chip 🐱‍💻

---

## Goal

Decide where the canonical data shapes and contracts for `Song`, `Routine`, `Chart Variant`, and `Workout` should live in the AeroBeat repo topology, then update `aerobeat-docs` with the resulting architecture and repository-boundary decisions.

---

## Overview

Earlier in this session we locked the content model itself: `Song -> Routine -> Chart Variant -> Workout`. What is still missing is the repo-level home for those shapes. Right now the docs say what those primitives are, but the current repo map does not yet make it obvious where the canonical contracts, shared resource classes, schemas, validators, and content-loading boundaries should live.

The current repo inventory suggests `aerobeat-core` is the most obvious existing candidate because it is already described as the hub for interfaces, enums, constants, and shared low-level utilities. But the live repo state also shows that `aerobeat-core` is currently very input-centric and has not yet grown into the broader cross-domain contract layer the docs imply. That means we need to decide whether to (a) expand `aerobeat-core` to own these content contracts, or (b) introduce a new repo category dedicated to content contracts / content data types so we do not overload core with unrelated responsibilities.

This plan should answer at least these architecture questions: whether `Song`, `Routine`, `Chart Variant`, and `Workout` belong in `aerobeat-core`; whether the current repo categories are sufficient; whether we need a new repo category such as a content-contracts/content-model repo; and how feature repos, tools, API clients, assemblies, and UI repos should depend on those shared definitions.

---

## REFERENCES

| ID | Description | Path |
| --- | --- | --- |
| `REF-01` | Current repo map | `docs/architecture/repository-map.md` |
| `REF-02` | Current repo structure reference | `docs/architecture/repo-structure-reference.md` |
| `REF-03` | Current content model canon | `docs/architecture/content-model.md` |
| `REF-04` | Current architecture overview | `docs/architecture/overview.md` |
| `REF-05` | Live `aerobeat-core` repo shape | `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-core` |

---

## Current Observations

### Existing likely home

`aerobeat-core` is the current best-fit existing repo because the docs already position it as the hub for shared contracts and shared types.

### Current mismatch

The live `aerobeat-core` repo is currently much narrower than the docs imply:
- current files are heavily input-focused
- `src/interfaces/` exists, but there is no visible content-contract/data-type layer yet
- the docs still mention a broader `contracts/`, `data_types/`, `globals/`, and `utils/` shape that the live repo has not fully grown into

### Likely architecture pressure

The content primitives are cross-cutting and are likely needed by:
- feature repos (`boxing`, `dance`, `flow`, `step`)
- tool repos (authoring, settings, backend API)
- assemblies
- UI shells / UI core
- backend/API integration docs and clients

So wherever these shapes live, they need to be stable, dependency-light, and clearly canonical.

---

## Working Direction (Draft)

### Preliminary recommendation

**Updated recommendation from discussion:** replace the ambiguous `aerobeat-core` concept with a family of domain-specific `*-core` repos that each own the contracts for one polyrepo lane.

Proposed core repos:
1. `aerobeat-input-core`
2. `aerobeat-feature-core`
3. `aerobeat-content-core`
4. `aerobeat-asset-core`
5. `aerobeat-ui-core`
6. `aerobeat-tool-core`

This better matches the current polyrepo split, mirrors the already-existing `aerobeat-ui-core` naming, and makes contract ownership obvious.

### Why this direction is stronger

- the current `aerobeat-core` name is too broad and is already trending toward a smell because it suggests a universal hub while the actual architecture is lane-based
- `Song`, `Routine`, `Chart Variant`, and `Workout` are not input contracts; they fit much more naturally under **feature contracts** than under an input-oriented core
- matching `input-core`, `feature-core`, `ui-core`, and `tool-core` gives each lane one obvious place for its shared contracts and shared base types
- non-core repos then fill in those contracts cleanly:
  - input repos implement input contracts
  - feature repos implement feature/runtime/chart-mode contracts
  - UI kits/shells consume UI core contracts
  - tools consume tool core contracts
- assembly repos can compose exactly the cores and concrete repos they need via GodotEnv, which keeps build scope tight and avoids dragging irrelevant functionality into every assembly

### Updated ownership direction

Under this model:
- `aerobeat-input-core` owns shared input abstractions and provider contracts
- `aerobeat-feature-core` owns shared gameplay-mode/runtime contracts that interpret authored content and athlete actions over time
- `aerobeat-content-core` owns the durable authored-content contracts shared across runtime and tooling, including `Song`, `Routine`, `Chart Variant`, `Workout`, and the shared chart envelope
- `aerobeat-asset-core` owns shared asset/art contracts such as avatars, cosmetics, environments, and other non-feature-specific asset-side resource definitions
- `aerobeat-ui-core` continues owning shared UI abstractions
- `aerobeat-tool-core` owns shared tool/backend/settings-side contracts

That implies the `Song`, `Routine`, `Chart Variant`, and `Workout` shapes should live in **`aerobeat-content-core`**, not in `aerobeat-feature-core` and not in a catch-all `aerobeat-core`.

### Migration implication

This likely means the docs should stop treating `aerobeat-core` as the long-term universal hub and instead document either:
- a rename/split from current `aerobeat-core` toward `aerobeat-input-core`, plus creation of the missing sibling cores, or
- a transition state where current `aerobeat-core` is explicitly temporary and scoped to input/core-runtime concerns until the full four-core structure exists

---

## Key Questions To Resolve

1. Should `Song`, `Routine`, `Chart Variant`, and `Workout` live in `aerobeat-core`?
2. If yes, what exact folder/category structure should `aerobeat-core` expose for them?
3. If no, what new repo category should be introduced, and why is it better than expanding core?
4. How should feature repos depend on the shared content shapes without duplicating mode-specific schema logic?
5. Which parts belong in shared cross-mode contracts versus mode-specific repos like `aerobeat-feature-boxing`?
6. Do we want file/resource definitions only in the shared repo, or also validators/loaders there?

---

## Candidate Repo-Boundary Model (Draft)

### Option A — Six-core architecture (current favorite)

Domain-specific cores own the shared contracts for their lane:

- `aerobeat-input-core`
  - input provider contracts
  - shared input-facing enums/data structures
  - input-manager/runtime abstractions
- `aerobeat-feature-core`
  - shared gameplay-mode/runtime contracts
  - scoring / hit / spawn / mode-lifecycle contracts
  - mode-specific parser/validator interfaces
  - feature-facing stable runtime APIs
- `aerobeat-content-core`
  - `Song`, `Routine`, `Chart Variant`, `Workout`
  - shared chart envelope
  - shared content registry/loader interfaces
  - cross-mode content ids, metadata, and validation types
  - workout/session sequencing contracts used by both tools and runtime
- `aerobeat-asset-core`
  - shared asset/art-side contracts
  - avatars, cosmetics, environments, generic asset-pack resource definitions
  - shared skeleton/socket/reactivity/asset validation contracts where they are cross-feature
- `aerobeat-ui-core`
  - shared UI abstractions, bases, signals, enums, and contracts
- `aerobeat-tool-core`
  - shared tool/backend/settings contracts and common tool-side models

Concrete repos then implement/fill those contracts:
- input repos implement `aerobeat-input-core`
- feature repos implement `aerobeat-feature-core`
- authored content and playback tooling consume `aerobeat-content-core`
- asset repos consume `aerobeat-asset-core`
- UI kits/shells consume `aerobeat-ui-core`
- tools consume `aerobeat-tool-core`

Assembly repos compose only the cores and concrete repos they need via GodotEnv.

Possible shape for the content lane:

```text
aerobeat-content-core/
  src/
    interfaces/
      chart_loader.gd
      content_registry.gd
      workout_player.gd
    data_types/
      song.gd
      routine.gd
      chart_variant.gd
      workout.gd
      chart_envelope.gd
    validators/
      content_validation_result.gd
    globals/
      aero_content_schema.gd
```

### Option B — Keep `aerobeat-core` as a universal hub

This is now the weaker option.

It would keep all shared contracts under one broad `aerobeat-core`, but that blurs domain boundaries and conflicts with the clearer lane-based naming already implied by `aerobeat-ui-core`.

### Option C — Partial split / transition state

- rename current `aerobeat-core` to `aerobeat-input-core`
- create `aerobeat-feature-core` for gameplay-mode/runtime contracts
- create `aerobeat-content-core` for shared authored-content contracts
- create `aerobeat-asset-core` for asset/art-side contracts
- create `aerobeat-tool-core` if it does not yet exist
- keep `aerobeat-ui-core` as-is

This is probably the most realistic implementation path even if Option A is the desired end state.

---

## Tasks

### Task 1: Audit current repo topology versus the content-model decision

**Bead ID:** `Pending`  
**SubAgent:** `research`  
**References:** `REF-01`, `REF-02`, `REF-03`, `REF-04`, `REF-05`  
**Prompt:** Read the current repo map, structure docs, content-model docs, and inspect the live `aerobeat-core` repo. Summarize the current mismatch between documented architecture and actual repo ownership for `Song`, `Routine`, `Chart Variant`, and `Workout`. Identify the strongest repo-boundary options.

**Folders Created/Deleted/Modified:**
- `docs/architecture/`

**Files Created/Deleted/Modified:**
- None expected during research

**Status:** ⏳ Pending

**Results:** Pending discussion confirmation.

---

### Task 2: Choose the repo ownership model for shared content contracts

**Bead ID:** `aerobeat-docs-dct`  
**SubAgent:** `primary`  
**References:** `REF-01`, `REF-02`, `REF-03`, `REF-04`, `REF-05`  
**Prompt:** Based on the approved direction, define where `Song`, `Routine`, `Chart Variant`, `Workout`, the shared chart envelope, and common validation/loading contracts should live. Make the ownership boundaries explicit between core, feature repos, tools, and any new repo category if needed.

**Folders Created/Deleted/Modified:**
- `docs/architecture/`

**Files Created/Deleted/Modified:**
- `docs/architecture/repository-map.md`
- `docs/architecture/repo-structure-reference.md`
- `docs/architecture/overview.md`
- `docs/architecture/content-model.md`
- `docs/architecture/workflow.md`
- `docs/architecture/topology.md`
- `docs/architecture/input.md`

**Status:** ✅ Complete

**Results:** Documented the six-core lane architecture as the canonical repo model, added explicit GitHub links for all six core repos, made `aerobeat-content-core` the declared owner of `Song`, `Routine`, `Chart Variant`, `Workout`, and the shared chart envelope, made `aerobeat-feature-core` explicitly consume content contracts instead of owning them, made `aerobeat-asset-core` the owner of avatars/cosmetics/environments/shared asset-side definitions, and updated the assembly/dependency wording so `aerobeat-assembly-community` composes only the cores and concrete repos it needs via GodotEnv. Also updated adjacent architecture references (`topology.md`, `input.md`) so they do not continue pointing at the old universal `aerobeat-core` hub model.

---

### Task 3: Audit the six-core docs update and repo links

**Bead ID:** `aerobeat-docs-q2n`  
**SubAgent:** `auditor`  
**References:** `REF-01`, `REF-02`, `REF-03`, `REF-04`  
**Prompt:** Independently audit the updated `aerobeat-docs` content. Verify that the docs consistently describe the six-core architecture, make `aerobeat-content-core` the home for `Song`, `Routine`, `Chart Variant`, and `Workout`, make `aerobeat-asset-core` explicit for asset-side contracts, and include correct repo links/ownership wording for the now-documented core repos.

**Folders Created/Deleted/Modified:**
- `docs/architecture/`

**Files Created/Deleted/Modified:**
- TBD from the chosen direction

**Status:** ⏳ Pending

**Results:** Pending discussion confirmation.

---

### Follow-up: Map template categories to required core repos

**Bead ID:** `aerobeat-docs-gmp`  
**SubAgent:** `research`  
**References:** `REF-01`, `REF-02`, `REF-03`, `REF-04`, `REF-05`  
**Prompt:** Audit the existing AeroBeat template categories and current docs to determine which template families imply their own domain-specific `*-core` contract repos. Specifically pressure-test whether asset/avatar/cosmetic/environment/skin templates are already fully covered by input-core, feature-core, ui-core, and tool-core, or whether they imply an additional art/content lane with its own core contracts.

**Folders Created/Deleted/Modified:**
- `docs/architecture/`
- `docs/guides/`
- `docs/gdd/`

**Files Created/Deleted/Modified:**
- None expected during research

**Status:** ⏳ Pending

**Results:** Not started.

---

## Final Results

**Status:** ⏳ Pending

**What We Built:** Pending discussion and execution.

**Reference Check:** Pending.

**Commits:**
- Pending

**Lessons Learned:** Pending.

---

*Completed on Pending*
