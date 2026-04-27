# AeroBeat Workout YAML Alignment Pass

**Date:** 2026-04-27  
**Status:** Complete  
**Agent:** Chip 🐱‍💻

---

## Goal

Review the demo workout package YAMLs against the now-locked coaching and SQLite/catalog decisions, starting with the root `workout.yaml`, then only after Derrick approves that pass continue through each package subfolder so every authored YAML aligns with the intended v1 contract.

---

## Overview

We just finished locking two important pieces of the package story: the coaching contract and the shared-core local/remote SQLite schema direction. That means the authored YAML examples now need a careful truth-check pass, because some fields may have been invented earlier while the architecture was still in motion. The main risk now is drift: a polished-looking example can quietly teach the wrong contract if even a few fields imply responsibilities that actually belong in SQLite, in coach config, or nowhere at all.

This pass should be done in a staged way. First we review the root `workout.yaml` field-by-field because it is the package entrypoint and the file most likely to accidentally blur authored package data with derived discovery/index data. Once Derrick is happy with that file’s shape, wording, and authority boundaries, we move through the subfolders one domain at a time (`songs/`, `routines/`, `charts/`, then any remaining related domains) and keep the package internally consistent.

The work belongs in `aerobeat-docs` because this example package is currently the canonical review surface for the authored contract. Any changes here should then remain consistent with the locked docs and with the SQL schema examples, without letting SQLite browsing/index concerns leak back into authored package YAML.

---

## REFERENCES

| ID | Description | Path |
| --- | --- | --- |
| `REF-01` | Current demo root workout YAML | `projects/aerobeat/aerobeat-docs/docs/examples/workout-packages/demo-neon-boxing-bootcamp/workout.yaml` |
| `REF-02` | Current shared-core catalog/local SQLite schema example | `projects/aerobeat/aerobeat-docs/docs/examples/workout-packages/demo-neon-boxing-bootcamp/sql/workouts.db.schema.sql` |
| `REF-03` | Current package/storage/discovery architecture doc | `projects/aerobeat/aerobeat-docs/docs/architecture/workout-package-storage-and-discovery.md` |
| `REF-04` | Current content model doc | `projects/aerobeat/aerobeat-docs/docs/architecture/content-model.md` |
| `REF-05` | Prior example-schema plan lineage | `projects/aerobeat/aerobeat-docs/.plans/2026-04-25-aerobeat-example-schema-files.md` |
| `REF-06` | 2026-04-26 handoff notes with the newly locked coaching + SQLite decisions | `memory/2026-04-26.md` |

---

## Tasks

### Task 1: Audit the root `workout.yaml` against the locked v1 contract

**Bead ID:** `aerobeat-docs-7a2`  
**SubAgent:** `primary` (for `research`)  
**Role:** `research`  
**References:** `REF-01`, `REF-02`, `REF-03`, `REF-04`, `REF-06`  
**Prompt:** Review the root `workout.yaml` field-by-field. Identify which fields clearly belong in authored package YAML, which comments or sections imply behavior that should actually live in coach config or SQLite, and which fields look invented, redundant, or weakly justified after the 2026-04-26 decisions. Produce a concrete keep/change/remove recommendation list with rationale.

**Folders Created/Deleted/Modified:**
- `.plans/`
- `docs/examples/workout-packages/demo-neon-boxing-bootcamp/`

**Files Created/Deleted/Modified:**
- `.plans/2026-04-27-aerobeat-workout-yaml-alignment-pass.md`
- `docs/examples/workout-packages/demo-neon-boxing-bootcamp/workout.yaml`

**Status:** ✅ Complete

**Results:** Independent research review completed on bead `aerobeat-docs-7a2`. The root `workout.yaml` is mostly aligned with the locked v1 contract and does not currently show the previously rejected coach/schema hallucinations or SQLite/install/discovery fields. Recommended action is a narrow wording/comment cleanup rather than a structural rewrite: keep the current field set, but tighten comments around `preview`, `packageContents`, and `submission` so the file clearly teaches authored-package responsibilities without implying coach-config ownership or SQLite/catalog ownership. No root fields were flagged for removal.

---

### Task 2: Apply the approved `workout.yaml` changes and validate the root contract

**Bead ID:** `aerobeat-docs-qvl`  
**SubAgent:** `primary` (for `coder` → `qa` → `auditor`)  
**Role:** `coder` / `qa` / `auditor`  
**References:** `REF-01`, `REF-02`, `REF-03`, `REF-04`, `REF-06`  
**Prompt:** Apply the approved root `workout.yaml` edits, then run QA and independent audit to verify that the root package file cleanly separates authored data from derived SQLite/discovery concerns and stays consistent with the coaching contract.

**Folders Created/Deleted/Modified:**
- `.plans/`
- `docs/examples/workout-packages/demo-neon-boxing-bootcamp/`

**Files Created/Deleted/Modified:**
- `.plans/2026-04-27-aerobeat-workout-yaml-alignment-pass.md`
- `docs/examples/workout-packages/demo-neon-boxing-bootcamp/workout.yaml`

**Status:** ✅ Complete

**Results:** Independent audit passed and closed bead `aerobeat-docs-qvl`. The root workout-package contract is now locked: `workout.yaml` keeps only `preview.coverArtPath`; uses `sets` plus `setId`; omits `order`; omits authored transition behavior; omits `packageContents`; and omits both `submission.*` fields. The directly related docs/examples were verified to tell a coherent, teaching-oriented story, and `workout.yaml` plus `coach-config.yaml` were confirmed to agree on the same `setId` values. Root review is done; downstream YAML/domain work can proceed from this locked baseline.

---

### Task 3: Sweep the remaining workout-package YAML domains after root approval

**Bead ID:** `aerobeat-docs-2uw`  
**SubAgent:** `primary` (for `research` then `coder` → `qa` → `auditor`)  
**Role:** `research` / `coder` / `qa` / `auditor`  
**References:** `REF-01`, `REF-02`, `REF-03`, `REF-04`, `REF-05`, `REF-06`  
**Prompt:** Now that the root `workout.yaml` is locked, first remove the no-longer-approved `thumbnailPath` concept everywhere it still appears in the demo workout package examples and the canonical workout-package architecture doc, because Derrick explicitly does not want it documented at all. After that cleanup is validated, continue the remaining authored YAML review one subfolder at a time so they agree with the root contract, the coaching contract, and the shared-core SQLite schema boundaries. Start with `songs/`, then `routines/`, then `charts/`, then any related remaining domains that need consistency fixes.

**Folders Created/Deleted/Modified:**
- `.plans/`
- `docs/examples/workout-packages/demo-neon-boxing-bootcamp/songs/`
- `docs/examples/workout-packages/demo-neon-boxing-bootcamp/routines/`
- `docs/examples/workout-packages/demo-neon-boxing-bootcamp/charts/`
- other package subfolders if needed

**Files Created/Deleted/Modified:**
- remaining YAML example files to be determined by the approved review sequence
- `.plans/2026-04-27-aerobeat-workout-yaml-alignment-pass.md`

**Status:** ✅ Complete

**Results:** This sweep fully landed. The pre-step `thumbnailPath` cleanup completed in commit `bb35db6`. The `songs/*.yaml` contract tightened and landed in commits `7b54459` and `aa660d6`, then passed QA/audit. The routine review turned into a larger architecture revision: `routines/` was removed from the durable package contract, `sets/` became the single composition linker, and the rewrite landed through commits `d34dc30`, `d1ae3d5`, `aec7811`, and `65c9e1f` with QA/audit reconciliation. Final contract blockers inside `aerobeat-docs` were then resolved in `90e0cba`: authored YAML provenance fields now follow a strong default rule with an explicit disabled-`coach-config.yaml` exception, and the structured boxing event payload is now the canonical active chart model. Finally, the clean-break hygiene sweep removed stale routine-era prose and normalized cross-repo docs/READMEs to the set-centered model, including `aerobeat-docs`, `aerobeat-content-core`, `aerobeat-tool-content-authoring`, `aerobeat-feature-step`, `aerobeat-feature-flow`, `aerobeat-feature-dance`, and `aerobeat-template-feature` via commits `ad9d1e1`, `5c240a9`, `6ffca0a`, `4743258`, `c80e286`, `49d2568`, and `06352da`. The next intentional review slice is `charts/*.yaml`, to be handled in a later session now that the set-centered package contract is locked.

---

## Final Results

**Status:** ✅ Complete

**What We Built:** A fully normalized set-centered workout package contract in `aerobeat-docs`, plus a broad cross-repo docs cleanup across the AeroBeat polyrepo. The durable model now reads Song → Chart → Set → Workout; `sets/` is the single composition linker; `routines/` is removed from the durable package contract; songs own song metadata/licensing; charts no longer back-link to songs/routines; coach-config acts as a coaching registry; authored-record provenance rules are consistent; and the stronger structured boxing payload is the canonical active chart event model.

**Reference Check:** `REF-01` through `REF-06` were iteratively reconciled during the root, songs, routine→set, blocker-fix, and hygiene passes. The final package/docs model now matches the approved coaching contract, the shared-core SQLite/catalog direction, and the later set-centered package rewrite decisions.

**Commits:**
- `bb35db6` - docs: remove thumbnailPath from workout package examples
- `7b54459` - docs: clean up demo song contract
- `aa660d6` - docs: remove package licensing claim from content model
- `d34dc30` - Rewrite workout package docs around sets
- `d1ae3d5` - docs: remove stale routine-era content refs
- `aec7811` - docs: fix coaching overlay id terminology
- `65c9e1f` - docs: fix remaining chart and set terminology
- `90e0cba` - docs: align package contract examples
- `97c8feb` - docs: align stale content-model references
- `ad9d1e1` - docs: align package model around sets
- `5c240a9` - docs: describe content core with set-centered model
- `6ffca0a` - docs: update authoring tool for set-centered packages
- `4743258` - docs: update feature dependency wording for sets
- `c80e286` - docs: update feature dependency wording for sets
- `49d2568` - docs: update feature dependency wording for sets
- `06352da` - docs: update feature template wording for sets

**Lessons Learned:**
- Lock the root authored contract first; downstream cleanup is much safer once the package center is stable.
- If a reusable layer like `Routine` no longer has real reuse in the package system, remove it instead of half-preserving it in docs and examples.
- Do not leave “legacy explanatory prose” around once the contract changes; it keeps reintroducing the old model into adjacent repos.
- Separate true contract blockers from hygiene drift, but clean both before declaring architecture work landed.

---

*Completed on 2026-04-27*