# AeroBeat Remaining Package Decisions + Wider Docs Sweep

**Date:** 2026-04-25  
**Status:** In Progress  
**Agent:** Chip 🐱‍💻

---

## Goal

Make hard calls on the remaining open package-system questions, then propagate those decisions across the wider AeroBeat documentation surfaces so the polyrepo docs story stays aligned before implementation planning resumes.

---

## Overview

The prior package-schema/storage pass succeeded: the YAML contracts, `workouts.db`, and workout-local leaderboard cache story are now documented and have passed QA and audit in `aerobeat-docs`. The next job is to close the remaining design gaps while the system is still easy to reason about, then make sure the wider AeroBeat docs ecosystem does not drift away from the newly locked package model.

This is two linked phases. First, we pressure-test and decide the remaining open questions: the v1 `assetType` enum set, whether the downloadable online catalog SQLite should match or diverge from local `workouts.db`, whether signing/integrity metadata belongs in the near-term package contract, and whether any other unresolved contract edges need an explicit decision now rather than later. Second, after those calls are locked, we run a broader cross-repo docs sweep so older docs in the various AeroBeat repos stop carrying stale terminology or contradictory package assumptions.

This coordination plan belongs in `aerobeat-docs` because the docs repo is still the current architecture review surface and is the natural parent for the broader documentation alignment work. Repo-specific cleanup work can then fan out into the owning repos as needed.

---

## REFERENCES

| ID | Description | Path |
| --- | --- | --- |
| `REF-01` | Package schema + SQLite definition plan that just passed QA/audit | `projects/aerobeat/aerobeat-docs/.plans/2026-04-25-aerobeat-package-schema-and-sqlite-definition.md` |
| `REF-02` | Current package/storage contract doc | `projects/aerobeat/aerobeat-docs/docs/architecture/workout-package-storage-and-discovery.md` |
| `REF-03` | Current content model doc | `projects/aerobeat/aerobeat-docs/docs/architecture/content-model.md` |
| `REF-04` | Current glossary definitions | `projects/aerobeat/aerobeat-docs/docs/gdd/glossary/terms.md` |
| `REF-05` | Prior memory thread on storage/discovery direction and online SQLite idea | `memory/2026-04-24-workout-schema.md#L637-L703` |
| `REF-06` | Current content-core definition-phase plan lineage | `projects/aerobeat/aerobeat-content-core/.plans/2026-04-23-aerobeat-content-core-first-implementation-slice.md` |

---

## Tasks

### Task 1: Lock the remaining package-system decisions

**Bead ID:** `aerobeat-docs-3i9`  
**SubAgent:** `primary` (for `research`)  
**Role:** `research`  
**References:** `REF-01`, `REF-02`, `REF-03`, `REF-04`, `REF-05`, `REF-06`  
**Prompt:** Review the remaining open package-system questions and propose hard decisions for v1. Focus on: exact `assetType` enum direction, whether the downloaded online catalog SQLite should match or intentionally diverge from local `workouts.db`, whether signing/integrity metadata belongs in the near-term package contract, and any other unresolved package-contract edges that should be locked now instead of drifting.

**Folders Created/Deleted/Modified:**
- `docs/architecture/`
- `.plans/`

**Files Created/Deleted/Modified:**
- `docs/architecture/workout-package-storage-and-discovery.md`
- `.plans/2026-04-25-aerobeat-remaining-package-decisions-and-docs-sweep.md`

**Status:** ✅ Complete

**Results:** Locked the remaining v1 package decisions directly into the canonical docs. Final calls: (1) `assetType` is now a strict v1 enum with six values — `gloves`, `targets`, `obstacles`, `trails`, `coach_avatar`, `coach_voice` — with only the first four allowed in workout-entry `assetSelections`; (2) the downloaded online catalog SQLite should intentionally diverge from local `workouts.db` and be treated as a future sibling DB rather than an exact mirror; (3) signing/integrity metadata is explicitly deferred from the v1 authored package contract; and (4) package validation should reject unknown asset types and continue to reject cross-package dependencies/inheritance so the self-contained package philosophy stays sharp. These decisions were written into `REF-02`, aligned with `REF-03`, and terminology support was added in `REF-04`.

---

### Task 2: Update core docs with the newly locked decisions

**Bead ID:** `aerobeat-docs-2ij`  
**SubAgent:** `primary` (for `coder`)  
**Role:** `coder`  
**References:** `REF-01`, `REF-02`, `REF-03`, `REF-04`  
**Prompt:** Once Derrick approves the remaining hard calls, update the core package/content/glossary docs in `aerobeat-docs` so the canonical review surfaces are current.

**Folders Created/Deleted/Modified:**
- `docs/architecture/`
- `docs/gdd/glossary/`
- `.plans/`

**Files Created/Deleted/Modified:**
- `docs/architecture/workout-package-storage-and-discovery.md`
- `docs/architecture/content-model.md`
- `docs/gdd/glossary/terms.md`
- `.plans/2026-04-25-aerobeat-remaining-package-decisions-and-docs-sweep.md`

**Status:** ✅ Complete

**Results:** Updated the core docs surfaces to reflect the newly locked decisions. `docs/architecture/workout-package-storage-and-discovery.md` now records the strict v1 `assetType` enum, the local-vs-remote SQLite divergence rule, the explicit deferral of signing/integrity metadata, and the related validation expectations. `docs/architecture/content-model.md` now aligns the workout/package narrative with the locked asset-type split between entry-selectable gameplay assets and coach-config support assets. `docs/gdd/glossary/terms.md` now defines `Asset Type` and `Catalog DB` so downstream docs can reuse the same vocabulary.

---

### Task 3: Audit the wider AeroBeat docs surfaces across repos

**Bead ID:** `aerobeat-docs-8wr`  
**SubAgent:** `primary` (for `research`)  
**Role:** `research`  
**References:** `REF-01`, `REF-02`, `REF-03`, `REF-04`, `REF-06`  
**Prompt:** Search the broader AeroBeat polyrepo docs surfaces for stale package terminology, old `Chart Variant` wording, old coach/background ownership assumptions, or contradictory content-package assumptions. Produce an explicit cross-repo cleanup list grouped by owning repo and file path.

**Folders Created/Deleted/Modified:**
- repo-local docs folders across the owning AeroBeat repos
- `.plans/`

**Files Created/Deleted/Modified:**
- likely this plan file first
- then repo-specific docs files after cleanup planning is approved

**Status:** ✅ Complete

**Results:** Completed a targeted wider-docs audit across the AeroBeat polyrepo using `grep -RIn` over repo `README.md`, docs markdown, template docs, and plan-adjacent architecture surfaces. The audit found two main drift clusters: (1) live product/docs surfaces still carrying pre-lock package vocabulary (`chart-variant`, `Coaching Pack`, `.pck`-centric packaging, `portals` as a selectable skin asset type, warm-up/cool-down media implied as workout-level coaching selections), and (2) many repo README/template surfaces still describing `aerobeat-core` as the active shared foundation even though the current architecture is lane-based and the old universal-hub wording is explicitly deprecated. Cleanup inventory below.

**Cleanup inventory by owning repo:**

- `aerobeat-docs`
  - `docs/gdd/user-content/community-creations.md`
    - Stale: still says `chart-variant` difficulty, treats skins as covering `portals` and `gloves / bats`, and describes a separate `Coaching Pack` with warm-up/cool-down media and per-song overlays.
    - Update to: use `Chart` terminology, align selectable asset types to `gloves`, `targets`, `obstacles`, `trails`, and describe coaching through the package’s single `coaches/coach-config.yaml` plus `coach_avatar` / `coach_voice` assets rather than a separate per-workout coaching-pack concept.
  - `docs/index.md`
    - Stale: still tells UGC creators to pack assets into `.pck` files and advertises `Skins SDK` / `Avatars SDK` / `Environment SDK` as the entrypoint language.
    - Update to: describe authored workout/content packages in the current package-system vocabulary; if distributable bundles are still `.pck` later in the pipeline, distinguish distribution artifacts from the authored package contract.
  - `docs/guides/coaching.md`
    - Stale: centered on a standalone `Coaching Pack` concept with warm-up/cool-down media.
    - Update to: either mark as exploratory/historical or rewrite around the locked workout package model where coach configuration lives in `coaches/coach-config.yaml` and coach media uses `coach_avatar` / `coach_voice` asset references.
  - `docs/guides/feature_development.md`
    - Stale/confusing: repeatedly says artists "inherit" feature scenes to create skins/environments.
    - Update to: distinguish Godot scene inheritance for runtime/view contracts from the package-system rule that workout/content packages do not inherit/patch other packages.
  - `docs/architecture/cloud_baker.md`
    - Potential contradiction: still frames the system around uploaded `.pck` or raw files and says the baker signs the package with a private key.
    - Update to: clarify this is a future distribution/build pipeline concern, not part of the v1 authored package contract; explicitly separate artifact signing from authored-package YAML semantics.
  - `docs/architecture/content-lane-implementation-phases.md`
    - Stale term: says `chart-variant` in the phase-1 deliverables list.
    - Update to: replace with `Chart` / routine-chart-workout wording that matches the current model.
  - `templates/README.md`
    - Stale: `Project Location` still shows `.testbed/` for package repos even though current template READMEs describe repo-root package boundaries with `.testbed/` only as the hidden workbench.
    - Update to: rename the column or values so it clearly distinguishes package boundary (`/`) from dev/test workbench (`.testbed/`).

- `aerobeat-template-skin`
  - `README.md`
    - Stale: still depends on `aerobeat-core` and only documents `gloves`, `targets`, and `obstacles` under `assets/`.
    - Update to: use the lane-specific core repo name/contract and decide whether `trails` should be documented here so the template matches the locked v1 asset-type set.

- `aerobeat-template-avatar`
  - `README.md`
    - Stale: still names `aerobeat-core` as the required foundation.
    - Update to: point at the current asset-lane/shared-contract dependency (`aerobeat-asset-core` or the correct lane-specific contract) instead of the deprecated universal-hub name.

- `aerobeat-template-cosmetic`
  - `README.md`
    - Stale: still names `aerobeat-core` as the required foundation.
    - Update to: point at the correct lane-specific asset/shared-contract repo.

- `aerobeat-template-environment`
  - `README.md`
    - Stale: still names `aerobeat-core` as the required foundation.
    - Update to: point at `aerobeat-asset-core` / current environment contract language, matching the docs template source.

- `aerobeat-template-asset`
  - `README.md`
    - Stale: still names `aerobeat-core` as the required foundation.
    - Update to: point at the correct asset-lane foundation or explicitly document this template as internal/system-only if it intentionally sits outside the public workout-package model.

- `aerobeat-asset-prototypes`
  - `README.md`
    - Stale: still names `aerobeat-core` as the required foundation.
    - Update to: point at the current asset-lane/shared-resource contract and clarify how this repo relates to the newer package/content vocabulary.

- `aerobeat-assembly-community`
  - `README.md`
    - Stale: still presents `aerobeat-core` as the pinned foundation.
    - Update to: reflect the current lane-based dependency story and, if this assembly intentionally still consumes the renamed predecessor, call that out as transitional rather than normative architecture language.

- `aerobeat-template-assembly`
  - `README.md`
    - Stale: still presents `aerobeat-core` as the baseline assembly foundation.
    - Update to: align the template with the lane-based core naming and dependency guidance.

- `aerobeat-template-feature`
  - `README.md`
    - Stale: still presents `aerobeat-core` as the required dependency.
    - Update to: use `aerobeat-feature-core` plus any adjacent shared contracts actually required.

- `aerobeat-feature-boxing`
  - `README.md`
    - Stale: still says the workbench installs tagged `aerobeat-core` and pins `aerobeat-core` in validation notes.
    - Update to: use the current feature-lane dependency naming.

- `aerobeat-feature-dance`
  - `README.md`
    - Stale: still presents `aerobeat-core` as required.
    - Update to: use `aerobeat-feature-core` / current lane-specific dependency wording.

- `aerobeat-feature-flow`
  - `README.md`
    - Stale: still presents `aerobeat-core` as required.
    - Update to: use `aerobeat-feature-core` / current lane-specific dependency wording.

- `aerobeat-feature-step`
  - `README.md`
    - Stale: still presents `aerobeat-core` as required.
    - Update to: use `aerobeat-feature-core` / current lane-specific dependency wording.

- `aerobeat-template-input`
  - `README.md`
    - Stale: still presents `aerobeat-core` as required.
    - Update to: use `aerobeat-input-core`.

- `aerobeat-input-gamepad`
  - `README.md`
    - Stale: still presents `aerobeat-core` as required.
    - Update to: use `aerobeat-input-core`.

- `aerobeat-input-joycon-hid`
  - `README.md`
    - Stale: still presents `aerobeat-core` as required.
    - Update to: use `aerobeat-input-core`.

- `aerobeat-input-keyboard`
  - `README.md`
    - Stale: still presents `aerobeat-core` as required.
    - Update to: use `aerobeat-input-core`.

- `aerobeat-input-mediapipe-native`
  - `README.md`
    - Stale: still presents `aerobeat-core` as the Godot-side contract dependency.
    - Update to: use `aerobeat-input-core` and keep the `src`-bridge note if still true.

- `aerobeat-input-mouse`
  - `README.md`
    - Stale: still presents `aerobeat-core` as required.
    - Update to: use `aerobeat-input-core`.

- `aerobeat-input-touch`
  - `README.md`
    - Stale: still presents `aerobeat-core` as required.
    - Update to: use `aerobeat-input-core`.

- `aerobeat-input-xr`
  - `README.md`
    - Stale: still presents `aerobeat-core` as required.
    - Update to: use `aerobeat-input-core`.

- `aerobeat-template-tool`
  - `README.md`
    - Stale: still presents `aerobeat-core` as required.
    - Update to: use `aerobeat-tool-core` (plus any adjacent shared contracts as needed).

- `aerobeat-tool-api`
  - `README.md`
    - Stale: still presents `aerobeat-core` as required.
    - Update to: use `aerobeat-tool-core` / current lane-specific dependency wording.

- `aerobeat-tool-settings`
  - `README.md`
    - Stale: still presents `aerobeat-core` as required.
    - Update to: use `aerobeat-tool-core` / current lane-specific dependency wording.

- `aerobeat-template-ui-kit`
  - `README.md`
    - Stale: still presents `aerobeat-core` as a required foundation alongside `aerobeat-ui-core`.
    - Update to: remove deprecated universal-hub wording and document only the lane-specific UI/input/content deps actually needed.

- `aerobeat-ui-kit-community`
  - `README.md`
    - Stale: still says the workbench installs tagged `aerobeat-core` plus `aerobeat-ui-core`.
    - Update to: align to the lane-based dependency story.

- `aerobeat-template-ui-shell`
  - `README.md`
    - Stale: still presents `aerobeat-core` as the required foundation.
    - Update to: align with the lane-based core split and current UI shell dependency language.

- `aerobeat-ui-shell-desktop-community`
  - `README.md`
    - Stale: still presents `aerobeat-core` as the required foundation.
    - Update to: align with the lane-based core split.

- `aerobeat-ui-shell-mobile-community`
  - `README.md`
    - Stale: still presents `aerobeat-core` as the required foundation.
    - Update to: align with the lane-based core split.

- `aerobeat-ui-shell-web-community`
  - `README.md`
    - Stale: still presents `aerobeat-core` as the required foundation.
    - Update to: align with the lane-based core split.

- `aerobeat-ui-shell-xr-community`
  - `README.md`
    - Stale: still presents `aerobeat-core` as the required foundation.
    - Update to: align with the lane-based core split.

---

### Task 4: Land the cross-repo docs cleanup pass

**Bead ID:** `aerobeat-docs-vfv`  
**SubAgent:** `primary` (for `coder` → `qa` → `auditor`)  
**Role:** `coder` / `qa` / `auditor`  
**References:** `REF-01`, `REF-02`, `REF-03`, `REF-04`  
**Prompt:** Apply the approved cleanup list in the owning repos, then run the normal coder → QA → auditor loop so the broader AeroBeat docs set matches the current package-system contract.

**Folders Created/Deleted/Modified:**
- multiple AeroBeat repos as dictated by the cleanup inventory
- `.plans/`

**Files Created/Deleted/Modified:**
- repo-specific docs files to be determined by the audit
- this plan file

**Status:** ✅ Coder complete / ⏳ QA and auditor pending

**Results:** Applied the approved coder-side cleanup pass across `aerobeat-docs` plus the inventoried README surfaces in the wider AeroBeat repo family. Batch 1 semantic fixes rewrote the highest-priority contradictory docs in `aerobeat-docs`: `docs/gdd/user-content/community-creations.md` now uses `Chart` terminology and the locked package/asset/coaching model; `docs/index.md` now points contributors at authored package contracts instead of `.pck`-as-source language; `docs/guides/coaching.md` now frames coaching as the package’s single `coaches/coach-config.yaml` domain rather than a standalone coaching-pack product; `templates/README.md` now distinguishes repo-root package boundaries from `.testbed/` workbench projects; and related contradiction cleanup landed in `docs/gdd/user-content/overview.md`, `docs/guides/feature_development.md`, `docs/architecture/cloud_baker.md`, and `docs/architecture/content-lane-implementation-phases.md`. Batch 2 normalized README wording across the inventoried repos so they no longer present stale `aerobeat-core` hub language as canonical architecture. Where the live repo manifests still pin transition-era `aerobeat-core` keys, the READMEs now call that out explicitly as bootstrap-state drift/transitional truth instead of pretending the dependency contract has already been fully renamed. Validation completed with targeted `git diff --check` passes across every touched file plus grep sanity checks for the active-doc contradiction terms; a repo-local MkDocs build could not be rerun in this environment because `python3 -m mkdocs build` failed with `No module named mkdocs`. Commits were made in each touched owning repo. QA and independent audit are still pending by design.

---

## Decisions Locked In This Pass

1. `assetType` is a strict v1 enum, not a freeform string. The locked values are `gloves`, `targets`, `obstacles`, `trails`, `coach_avatar`, and `coach_voice`.
2. Only `gloves`, `targets`, `obstacles`, and `trails` are workout-entry-selectable asset types. Coach asset types are referenced from `coaches/coach-config.yaml`.
3. A downloaded online catalog SQLite should intentionally diverge from local `workouts.db`; reuse logical browse vocabulary where useful, but keep it as a sibling remote/distribution DB rather than an exact mirror of install/path state.
4. Signing/integrity metadata is explicitly deferred from the v1 authored package contract. Distribution hardening can add that later as a separate concern.
5. Unknown asset types should fail package validation, and v1 continues to reject cross-package inheritance/dependency behavior so packages remain self-contained units.
6. First-party/built-in content remains conceptually under the same package system, not a special contract path.

---

## Final Results

**Status:** ⚠️ Coder complete; QA/audit still pending

**What We Built:** Completed the hard-call decision pass, the core-docs update pass inside `aerobeat-docs`, the wider cross-repo audit inventory, and the coder-side cleanup/application pass in the owning repos. The active docs now align to the locked v1 package decisions around `Chart` terminology, the single `coaches/coach-config.yaml` coaching domain, strict v1 asset-type direction, discoverability in `workouts.db` rather than package YAML, self-contained v1 packages, and duplication/forking instead of inheritance/patching. The wider README pass no longer presents stale `aerobeat-core` hub wording as canonical architecture; where the underlying manifests still pin transition-era `aerobeat-core` keys, the READMEs now label that state explicitly as transitional/bootstrap drift instead of treating it as the normative lane story.

**Reference Check:** `REF-02`, `REF-03`, and `REF-04` remain the truth source for the package/coaching/asset/discovery model, and the Task 4 cleanup pass propagated that wording into the highest-priority active docs plus the inventoried README surfaces. The final coder pass stayed consistent with the earlier definition-phase lineage in `REF-01` and `REF-06` while deliberately avoiding unsupported claims about repo dependencies that have not yet been migrated in their manifests.

**Commits:**
- `7932e0b` - Lock remaining AeroBeat package doc decisions
- `afd1678` - Align package docs with locked v1 contract
- `ae3e26b` - Normalize README lane dependency wording (`aerobeat-assembly-community`)
- `6ce6699` - Normalize README lane dependency wording (`aerobeat-asset-prototypes`)
- `e489e32` - Normalize README lane dependency wording (`aerobeat-feature-boxing`)
- `81dfe67` - Normalize README lane dependency wording (`aerobeat-feature-dance`)
- `e66c281` - Normalize README lane dependency wording (`aerobeat-feature-flow`)
- `eba971f` - Normalize README lane dependency wording (`aerobeat-feature-step`)
- `bac1ea9` - Normalize README lane dependency wording (`aerobeat-input-gamepad`)
- `a1d7d19` - Normalize README lane dependency wording (`aerobeat-input-joycon-hid`)
- `2d4375f` - Normalize README lane dependency wording (`aerobeat-input-keyboard`)
- `9406cc6` - Normalize README lane dependency wording (`aerobeat-input-mediapipe-native`)
- `537752f` - Normalize README lane dependency wording (`aerobeat-input-mouse`)
- `a33dd56` - Normalize README lane dependency wording (`aerobeat-input-touch`)
- `a99d0a8` - Normalize README lane dependency wording (`aerobeat-input-xr`)
- `2dbcf98` - Normalize README lane dependency wording (`aerobeat-template-assembly`)
- `645dc14` - Normalize README lane dependency wording (`aerobeat-template-asset`)
- `8602a72` - Normalize README lane dependency wording (`aerobeat-template-avatar`)
- `9f9b774` - Normalize README lane dependency wording (`aerobeat-template-cosmetic`)
- `d538665` - Normalize README lane dependency wording (`aerobeat-template-environment`)
- `07d7d10` - Normalize README lane dependency wording (`aerobeat-template-feature`)
- `d0a2a86` - Normalize README lane dependency wording (`aerobeat-template-input`)
- `2a3a007` - Normalize README lane dependency wording (`aerobeat-template-skin`)
- `7d95c54` - Normalize README lane dependency wording (`aerobeat-template-tool`)
- `61f1d8c` - Normalize README lane dependency wording (`aerobeat-template-ui-kit`)
- `6013113` - Normalize README lane dependency wording (`aerobeat-template-ui-shell`)
- `c9a1311` - Normalize README lane dependency wording (`aerobeat-tool-api`)
- `d19553b` - Normalize README lane dependency wording (`aerobeat-tool-settings`)
- `2ac6c42` - Normalize README lane dependency wording (`aerobeat-ui-kit-community`)
- `22f0eca` - Normalize README lane dependency wording (`aerobeat-ui-shell-desktop-community`)
- `778896a` - Normalize README lane dependency wording (`aerobeat-ui-shell-mobile-community`)
- `8872fd7` - Normalize README lane dependency wording (`aerobeat-ui-shell-web-community`)
- `f7ef9eb` - Normalize README lane dependency wording (`aerobeat-ui-shell-xr-community`)

**Lessons Learned:** The safest way to keep the package contract coherent was to close the last few ambiguities explicitly instead of leaving them as “we’ll know it when we implement it.” For the wider README sweep, the important discipline was to avoid lying about dependency state: when manifests still use transition-era keys, the README should say so plainly rather than silently rewriting history or inventing a migration that did not actually happen.

---

*Created on 2026-04-25*
