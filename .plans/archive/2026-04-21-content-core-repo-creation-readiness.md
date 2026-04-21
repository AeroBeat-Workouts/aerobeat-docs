# AeroBeat Content-Core Repo Creation Readiness

**Date:** 2026-04-21
**Status:** In Progress
**Agent:** Chip 🐱‍💻

---

## Goal

Finalize the remaining architecture decisions around `aerobeat-content-core` so we can decide whether the docs are sufficiently settled to create the repo and begin standing up its first canonical contract surfaces.

---

## Overview

Yesterday's work in `aerobeat-docs` established the durable Content-lane ownership model and documented the core capability surface for authored content. The docs now firmly place `Song`, `Routine`, `Chart Variant`, and `Workout` in `aerobeat-content-core`, with layered validation, manifest/package boundaries, registry/query semantics, and a clear split between Content, Feature, and Tool responsibilities.

What remains before repo creation is the "last mile" architecture pass: tighten any unresolved decision points that would otherwise cause churn immediately after the repo is created. In practice that likely means confirming the minimal initial contract/file layout, deciding which interfaces belong in the first repo cut versus later phases, clarifying what constitutes the MVP surface for `aerobeat-content-core`, and identifying whether any tool-side authoring concerns still need to be explicitly excluded from the initial repo.

This plan is intentionally about **repo-creation readiness**, not broad new architecture invention. The goal is to use the architecture already landed in `aerobeat-docs` to produce a concrete go/no-go recommendation and, if we are ready, define the exact first implementation slice for the new content repo.

A new requirement from Derrick is now in scope as part of those boundaries: content tooling should support a **headless** surface in addition to any interactive/editor UX, so CLI-driven content actions (validation, migration, packaging, import/export, registry/index tasks, and other automation-friendly flows) can be invoked without depending on a GUI.

---

## REFERENCES

| ID | Description | Path |
| --- | --- | --- |
| `REF-01` | Content lane architecture/capabilities plan | `.plans/2026-04-20-content-lane-architecture-and-capabilities.md` |
| `REF-02` | Content contracts / repo boundaries plan | `.plans/2026-04-20-content-contracts-and-repo-boundaries.md` |
| `REF-03` | Content model canon | `docs/architecture/content-model.md` |
| `REF-04` | Content lane phased implementation doc | `docs/architecture/content-lane-implementation-phases.md` |
| `REF-05` | Repo structure reference | `docs/architecture/repo-structure-reference.md` |
| `REF-06` | Architecture overview | `docs/architecture/overview.md` |
| `REF-07` | Repository map | `docs/architecture/repository-map.md` |

---

## Questions This Plan Must Answer

1. Are there still unresolved architecture decisions that would make immediate `aerobeat-content-core` creation premature?
2. What is the minimum viable first surface for `aerobeat-content-core`?
3. Which file/resource/schema/interface shapes belong in the initial repo creation slice versus later phases?
4. What must be explicitly left out of the initial repo to avoid bleeding Tool, UI, Asset, or Feature ownership into Content?
5. Should authoring products live under `aerobeat-tool-*` while depending on `aerobeat-content-core`, or should any of them instead be treated as `aerobeat-content-*` repos?
6. How should headless content-tool functionality be modeled so CLI-driven automation can use the same canonical content/tool contracts without depending on GUI-only flows?
7. Where should content-consuming visual/runtime implementations such as 2D lanes and 3D portals live, and what is their dependency relationship to `aerobeat-content-core`?
8. What should the exact next repo-creation step be if the docs are ready?

---

## Draft Execution Shape

### Task 1: Re-audit unresolved architecture questions for content-core creation

**Bead ID:** `aerobeat-docs-qoh`
**SubAgent:** `primary`
**Role:** `research`
**References:** `REF-01`, `REF-02`, `REF-03`, `REF-04`, `REF-05`, `REF-06`, `REF-07`
**Prompt:** Re-read the existing content-lane architecture package and identify the remaining decisions that still matter before creating `aerobeat-content-core`. Focus only on repo-creation readiness, MVP surface area, and ownership boundaries that could cause immediate churn if left fuzzy.

**Folders Created/Deleted/Modified:**
- `docs/architecture/`
- `.plans/`

**Files Created/Deleted/Modified:**
- `docs/architecture/content-model.md`
- `docs/architecture/content-lane-implementation-phases.md`
- `docs/architecture/repository-map.md`
- `docs/architecture/repo-structure-reference.md`
- `docs/architecture/workflow.md`
- `.plans/2026-04-21-content-core-repo-creation-readiness.md`

**Status:** ✅ Complete

**Results:** Re-audited the existing content-lane architecture package and found the remaining churn-risk was not the core `Song` / `Routine` / `Chart Variant` / `Workout` model itself; it was the repo-boundary language around the first concrete tool repo and around runtime visuals that consume content. Updated the canon to make three decisions explicit across the architecture package: (1) concrete authoring products belong in `aerobeat-tool-*` repos rather than under `aerobeat-content-*`; (2) core content-tool operations such as validation, migration, packaging, import/export, and registry/index work must be available through a headless/CLI surface in addition to any interactive/editor UX; and (3) 2D lanes, 3D portals, and other content-consuming runtime visuals belong in `aerobeat-feature-*` repos, not in `aerobeat-content-core`.

The docs now read as repo-creation-ready for `aerobeat-content-core`: the MVP content-core surface stays focused on durable contracts, manifests, ids, registry/query interfaces, migration contracts, structural validation, and workout resolution, while authoring UX remains in the Tool lane and view/runtime realization remains in the Feature lane. This should materially reduce immediate churn when creating `aerobeat-content-core` and the first concrete authoring tool repo.

---

### Task 2: Define the initial `aerobeat-content-core` MVP contract surface

**Bead ID:** `aerobeat-docs-5qe`
**SubAgent:** `primary`
**Role:** `coder`
**References:** `REF-01`, `REF-02`, `REF-03`, `REF-04`, `REF-05`, `REF-06`, `REF-07`
**Prompt:** Convert the approved Content-lane architecture into a concrete initial repo recommendation for `aerobeat-content-core`, including the first directories/files/interfaces/contracts that should exist on day one, the explicit non-goals that should stay out of the initial repo, and the lane-correct split between interactive content authoring UX and headless/CLI content-tool functionality.

**Folders Created/Deleted/Modified:**
- `docs/architecture/`
- `.plans/`

**Files Created/Deleted/Modified:**
- `docs/architecture/content-repo-shapes.md`
- `docs/architecture/repo-structure-reference.md`
- `docs/index.md`
- `mkdocs.yml`
- `.plans/2026-04-21-content-core-repo-creation-readiness.md`

**Status:** ✅ Complete

**Results:** Added a new canonical architecture doc, `docs/architecture/content-repo-shapes.md`, that turns the approved content-lane architecture into concrete day-one repo recommendations for both `aerobeat-content-core` and `aerobeat-tool-content-authoring`. The new doc defines the initial directory shapes, first files/interfaces/contracts, fixture/test expectations, dependency boundaries, and explicit non-goals for both repos. It also makes the headless-first tool rule concrete by requiring one shared service layer used by both CLI/headless entrypoints and any optional editor UX.

To make the new guidance part of the live docs package rather than an orphan page, I linked it from `docs/architecture/repo-structure-reference.md`, added it to the Architecture nav in `mkdocs.yml`, and surfaced it from `docs/index.md` alongside the content-model entry point. The resulting package stays consistent with the six-core ownership model: `aerobeat-content-core` remains the owner of durable content contracts and shared structural rules; `aerobeat-tool-content-authoring` is documented as a Tool-lane workflow repo that depends on `aerobeat-content-core` and `aerobeat-tool-core`; and 2D lanes / 3D portals remain explicitly out of both repos and in `aerobeat-feature-*` repos.

---

### Task 3: Audit the go/no-go recommendation for repo creation

**Bead ID:** `aerobeat-docs-7li`
**SubAgent:** `primary`
**Role:** `auditor`
**References:** `REF-01`, `REF-02`, `REF-03`, `REF-04`, `REF-05`, `REF-06`, `REF-07`
**Prompt:** Independently verify whether the documented architecture is ready for `aerobeat-content-core` creation. Confirm the proposed MVP surface stays lane-correct, avoids tool/feature leakage, and is concrete enough to support the first implementation pass without immediate architectural backtracking.

**Folders Created/Deleted/Modified:**
- `docs/architecture/`
- `.plans/`

**Files Created/Deleted/Modified:**
- `.plans/2026-04-21-content-core-repo-creation-readiness.md`

**Status:** ✅ Complete

**Results:** Audit passed. I reviewed the changed architecture/docs package against the repo-creation-readiness question and found the lane boundaries internally consistent across the main content docs, implementation-phasing guidance, repository map, workflow guidance, repo-structure reference, docs landing page, and MkDocs nav. The package consistently keeps durable authored-content ownership in `aerobeat-content-core`; consistently routes authoring workflows, validation/migration/packaging/import/export operations, and headless/CLI tooling into Tool-lane repos; and consistently keeps 2D lanes, 3D portals, and other content-consuming runtime visuals in Feature-lane repos.

The new `docs/architecture/content-repo-shapes.md` recommendation is practical for day one: `aerobeat-content-core` stays dependency-light and contract-focused, while `aerobeat-tool-content-authoring` is explicitly modeled as a concrete Tool-lane repo with a shared service layer used by both CLI/headless and optional editor surfaces. I did not find contradictions, ownership leaks, or nav/doc integration issues in the audited scope. Validation also passed: `git diff --stat` matched the expected docs footprint, and `git diff --check` returned clean.

---

## Final Results

**Status:** ✅ Complete

**What We Built:** Finalized and independently audited the repo-creation-readiness docs package for `aerobeat-content-core`. The resulting documentation now gives a concrete, lane-correct day-one recommendation for both `aerobeat-content-core` and the first concrete Tool-lane authoring repo, with explicit headless-tooling and runtime-visual ownership rules.

**Reference Check:** `REF-03`, `REF-04`, `REF-05`, `REF-07` satisfied directly in the audited docs; the resulting package also remains aligned with the broader architecture framing in `REF-06`. No deliberate deviations were found in the audited scope.

**Commits:**
- Pending

**Lessons Learned:** The remaining churn risk was not the content model itself; it was boundary language. Making Tool-lane authoring ownership, headless-first tooling, and Feature-lane runtime-visual ownership explicit removed the main repo-creation ambiguity.

---

*Planned on 2026-04-21*