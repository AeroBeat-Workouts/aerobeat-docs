# AeroBeat Documentation Downscope Audit

**Date:** 2026-05-01  
**Status:** In Progress  
**Agent:** Chip 🐱‍💻

---

## Goal

Audit `aerobeat-docs` against Derrick's new AeroBeat scope decisions, produce a clean cut/defer/keep matrix for the documentation set, then use that result to drive the later wider polyrepo cleanup pass.

---

## Overview

Derrick has downscoped AeroBeat v1 around a tighter commercial and implementation thesis: the primary experience is now camera-driven 2D `boxing` + `flow`, with PC community release first, mobile second, and VR as a later platform slice. `dance` and `step` are being removed from scope entirely, and most non-camera gameplay input repos are no longer official v1 targets.

The first slice of work is a full documentation-repo audit. That audit needs to do two things at once: (1) apply the explicit scope changes Derrick already named, and (2) surface any additional documented systems/features that still need a keep / post-v1 / cut decision. The output of this slice should be a prioritized actionable list plus the concrete doc files/sections that need edits or removal.

A second slice will follow later for the broader AeroBeat polyrepo, but this plan deliberately starts in `aerobeat-docs` so we can lock the new source-of-truth before touching dependent repos.

---

## REFERENCES

| ID | Description | Path |
| --- | --- | --- |
| `REF-01` | Active plan for this downscope and documentation audit | `.plans/2026-05-01-aerobeat-downscope-audit.md` |
| `REF-02` | AeroBeat docs repo to audit | `.` |

---

## Tasks

### Task 1: Summarize the new scope cuts and retained direction

**Bead ID:** `N/A`  
**SubAgent:** `primary`  
**Role:** `research`  
**References:** `REF-01`  
**Prompt:** Summarize Derrick's 2026-05-01 AeroBeat downscope decisions into a concise structured bullet list for planning use. No repo edits. Call out explicit cuts, retained v1 scope, deferred/post-v1 items, and any market/release-strategy rationale that should influence later audit decisions.

**Folders Created/Deleted/Modified:**
- `.plans/`

**Files Created/Deleted/Modified:**
- `.plans/2026-05-01-aerobeat-downscope-audit.md`

**Status:** ✅ Complete

**Results:** Captured Derrick's approved downscope summary in the active plan and session reply. Key locked direction: remove `dance` and `step`; keep `boxing` and `flow`; remove workout-package `assets`; retain workout-package `environment`; make `camera` the only official gameplay input for v1; treat `coaching` as de-prioritized but still valid package/domain work, not part of today's revisitation.

---

### Task 2: Audit `aerobeat-docs` for scope conflicts and missing decisions

**Bead ID:** `aerobeat-docs-7hy5`  
**SubAgent:** `primary`  
**Role:** `research`  
**References:** `REF-01`, `REF-02`  
**Prompt:** Audit the full `aerobeat-docs` repo against Derrick's current scope direction. Claim the bead on start. Identify docs that conflict with the new cuts (`dance`, `step`, non-camera official inputs, workout-package `assets` concept) and also identify any additional documented functionality that still needs an explicit classification: keep for v1, move to post-v1, or cut entirely. Produce a file-by-file audit summary with recommended action per item; do not edit files yet.

**Folders Created/Deleted/Modified:**
- `docs/`

**Files Created/Deleted/Modified:**
- `docs/**`

**Status:** ✅ Complete

**Results:** Completed a full `aerobeat-docs` audit against the new downscoped product direction. Main findings: the docs still present AeroBeat as a broad multi-input, multi-mode platform; `dance` and `step` remain exposed as active gameplay surfaces; non-camera gameplay inputs remain documented as first-class official support; the canonical workout-package docs/example still teach the removed `assets` package concept; and release/platform messaging still implies broader PC/mobile/VR parity than the newly locked sequencing. The audit also surfaced additional docs needing explicit v1/post-v1/cut classification before cleanup edits begin.

---

### Task 3: Turn the audit into a concrete docs action list

**Bead ID:** `aerobeat-docs-r0xv`  
**SubAgent:** `primary`  
**Role:** `research`  
**References:** `REF-01`, `REF-02`  
**Prompt:** Convert the docs audit into an execution-ready action list grouped by: delete, rewrite, narrow wording, defer to post-v1, and needs Derrick decision. Include the affected files and the rationale tied back to the new product scope.

**Folders Created/Deleted/Modified:**
- `.plans/`

**Files Created/Deleted/Modified:**
- `.plans/2026-05-01-aerobeat-downscope-audit.md`

**Status:** ✅ Complete

**Results:** Converted the completed docs audit into an execution-ready cleanup list grouped by delete/rewrite/narrow/defer/decision-needed. The resulting action set identifies the highest blast-radius surfaces first (`mkdocs.yml`, top-level concept/overview pages, canonical workout-package docs, glossary, release docs, and the demo package), then sequences the feature/input/package cleanup work so the later coder pass can remove stale pages and examples without leaving contradictory source-of-truth docs behind.

---

### Task 4: Execute the approved `aerobeat-docs` cleanup

**Bead ID:** `aerobeat-docs-ttiu`  
**SubAgent:** `primary`  
**Role:** `coder`  
**References:** `REF-01`, `REF-02`  
**Prompt:** After Derrick approves the action list, apply the documentation cleanup in `aerobeat-docs`. Claim the bead on start. Update or remove docs to match the locked scope. Commit and push by default unless explicitly told otherwise.

**Folders Created/Deleted/Modified:**
- `docs/`
- `.plans/`

**Files Created/Deleted/Modified:**
- `docs/**`
- `.plans/2026-05-01-aerobeat-downscope-audit.md`

**Status:** ✅ Complete

**Results:** Derrick approved the action list and supplied final decision packet: non-camera input docs stay but are future-labeled; VR docs stay but are future-labeled; old package asset customization docs should be deleted and future customization should point toward controlled avatar/cosmetics unlocks via workout points; app-store/mobile UGC constraints should stay soft for now pending further research. Coder pass applied the required deletions, rewrote the top-level scope/package/input/release docs around Boxing + Flow + camera-first v1, removed package-asset examples from the canonical workout package fixture, updated related gameplay/guides/repo-map wording, and confirmed the docs site still builds after the link/nav cleanup.

---

### Task 5: QA and audit the docs cleanup

**Bead ID:** `aerobeat-docs-fxu2` (QA), `aerobeat-docs-k1j0` (Auditor)  
**SubAgent:** `primary`  
**Role:** `qa` then `auditor`  
**References:** `REF-01`, `REF-02`  
**Prompt:** Independently verify that `aerobeat-docs` reflects the approved scope: boxing + flow retained, camera as the only official gameplay input for v1, workout-package `environment` retained, workout-package `assets` concept removed, coaching treated as de-prioritized/v1.1 candidate, and removed feature/input repos no longer represented as v1 scope. Audit for accidental contradictions or stale references.

**Folders Created/Deleted/Modified:**
- `docs/`
- `.plans/`

**Files Created/Deleted/Modified:**
- `docs/**`
- `.plans/2026-05-01-aerobeat-downscope-audit.md`

**Status:** ⏳ Pending

**Results:** QA and auditor beads created and staged behind the coder pass.

---

## Final Results

**Status:** ⚠️ Partial

**What We Built:** Draft plan created for the AeroBeat downscope audit and documentation-first cleanup sequence.

**Reference Check:** Planning only so far; no repo audit or cleanup completed yet.

**Commits:**
- None yet.

**Lessons Learned:** Start with docs as the source of truth, then fan out to the wider polyrepo once the new product scope is locked in writing.

---

*Completed on 2026-05-01*