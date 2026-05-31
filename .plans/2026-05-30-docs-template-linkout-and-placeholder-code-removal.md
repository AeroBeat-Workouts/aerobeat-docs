# AeroBeat Docs Template Linkout and Placeholder Code Removal

**Date:** 2026-05-30  
**Status:** Complete  
**Last Updated:** 2026-05-30 20:31 EDT  
**Blocked Reason:** None  
**Agent:** `chip`

---

## Goal

Refactor `aerobeat-docs` so it stops shipping real template code payloads such as `templates/tool/src/AeroToolManager.gd`, and instead links to the canonical GitHub template repos while documenting the mandatory post-clone cleanup steps for stale class names and placeholder manager identities.

---

## Overview

The audit wave showed that `aerobeat-docs` currently contains a real tracked template payload under `templates/tool/`, including a real `class_name AeroToolManager` declaration. That is explainable — the docs repo is currently acting as a documentation-plus-template container — but it is no longer the shape we want. It creates noisy scanner results, blurs ownership between docs and template repos, and leaves real placeholder code inside a repo that should be documentation-first.

The target state is simpler: template code lives only in the owning `aerobeat-template-*` repos, while `aerobeat-docs` links out to those GitHub pages and clearly warns that the very first step after cloning a template is to rename placeholder files/classes/autoloads so stale names like `AeroToolManager` do not survive and create class-name clashes. The docs should keep the guidance, not the runnable placeholder payload.

This plan should also truth-check whether any other docs-hosted template payloads besides the tool template need to be removed or replaced with linkouts. The implementation should update the docs, remove the real code payloads from `aerobeat-docs`, and then run a follow-up scan or targeted verification to prove the docs repo no longer contributes a real `AeroToolManager` declaration.

---

## REFERENCES

| ID | Description | Path |
| --- | --- | --- |
| `REF-01` | Current docs-hosted tool template payload and placeholder manager | `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-docs/templates/tool/` |
| `REF-02` | Current docs guidance that already discusses post-clone rename of `AeroToolManager` | `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-docs/docs/architecture/ugc-api-manager-topology.md` |
| `REF-03` | Canonical owning template repo expected to remain the real code owner | `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-template-tool/` |
| `REF-04` | Recent docs/template fallout commits and naming-wave memory | `Source: memory/2026-05-30.md#L14-L24` |

---

## Tasks

### Task 1: Audit docs-hosted template payloads and link targets

**Bead ID:** `aerobeat-docs-irrc`  
**SubAgent:** `primary` (for `research`)  
**Role:** `research`  
**References:** `REF-01`, `REF-02`, `REF-03`  
**Prompt:** Audit `aerobeat-docs` for any docs-hosted template payloads that contain real runnable code or real `class_name` declarations, starting with `templates/tool/`. Produce a short inventory of what should be removed from docs and what GitHub template repo URL each section should link to instead. Claim the bead on start. Do not edit files.

**Folders Created/Deleted/Modified:**
- None

**Files Created/Deleted/Modified:**
- None

**Status:** ✅ Complete

**Results:** Completed via bead `aerobeat-docs-irrc`. Inventory artifact saved to `/home/derrick/.openclaw/workspace/.temp/aerobeat-docs-template-payload-audit-2026-05-30.md`. `templates/tool/` is the clearest removal target because it contains real runnable payload including `src/AeroToolManager.gd`, a real `class_name AeroToolManager`, real GUT tests, bootstrap Python, CI workflows, `.testbed/project.godot`, and `plugin.cfg`. The broader `templates/*` tree also contains runnable scaffolding (setup scripts, workflow YAML, `.testbed` projects, test scripts, sync scripts), but `templates/tool/` was the only docs-hosted template payload in this audit that produced a `class_name` hit.

---

### Task 2: Refactor docs to link out instead of shipping template code

**Bead ID:** `aerobeat-docs-dojq`  
**SubAgent:** `primary` (for `coder`)  
**Role:** `coder`  
**References:** `REF-01`, `REF-02`, `REF-03`, `REF-04`  
**Prompt:** In `aerobeat-docs`, remove the docs-hosted real template code payloads identified in Task 1, replace them with docs that link to the canonical GitHub template repos, and explicitly document the mandatory first-step post-clone cleanup: rename placeholder files/classes/autoloads and eliminate stale class names like `AeroToolManager` before treating a clone as real runtime code. Claim the bead on start, make the repo changes, run repo-local validation relevant to docs, then commit and push by default unless the orchestrator says otherwise.

**Folders Created/Deleted/Modified:**
- `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-docs/templates/`
- `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-docs/docs/`

**Files Created/Deleted/Modified:**
- `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-docs/templates/tool/*`
- `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-docs/docs/architecture/ugc-api-manager-topology.md`
- any docs pages or nav files needed to preserve clear template guidance after linkout

**Status:** ✅ Complete

**Results:** Completed via bead `aerobeat-docs-dojq`. Removed the docs-hosted runnable template payloads from `templates/` across the repo, including `templates/tool/src/AeroToolManager.gd`, testbed projects, tests, workflow files, setup scripts, plugin manifests, and the old sync script. Converted `templates/` into a docs-only linkout surface by rewriting `templates/README.md` as a canonical index of the standalone `aerobeat-template-*` GitHub repos and rewriting each per-template `README.md` to point at the owning GitHub template repo. Preserved and sharpened the post-clone cleanup guidance, explicitly warning that placeholder files/classes/autoloads and stale identifiers like `AeroToolManager` must be renamed immediately after clone and never survive as shipped runtime identity. Updated `README.md`, `docs/architecture/workflow.md`, `docs/architecture/ugc-api-manager-topology.md`, and `docs/architecture/godotenv-convention-contract.md`. Validation passed with `venv/bin/mkdocs build --clean`. Commit `ddc4eba` (`Refactor docs templates into GitHub linkouts`) was pushed to `origin/main`.

---

### Task 3: QA docs flow and targeted collision verification

**Bead ID:** `aerobeat-docs-sb7c`  
**SubAgent:** `primary` (for `qa`)  
**Role:** `qa`  
**References:** `REF-02`, `REF-03`  
**Prompt:** Verify the updated docs still clearly guide a human from docs -> GitHub template repo -> mandatory post-clone rename checklist, and run targeted verification that `aerobeat-docs` no longer contributes a real `AeroToolManager` declaration to the class-name scan surface. Claim the bead on start. Use the highest-fidelity docs validation available, then report exact evidence.

**Folders Created/Deleted/Modified:**
- None

**Files Created/Deleted/Modified:**
- None

**Status:** ✅ Complete

**Results:** Completed via bead `aerobeat-docs-sb7c`. QA verified the docs route clearly guides a human from docs -> canonical GitHub template repo -> mandatory post-clone rename checklist. Evidence cited by QA includes `README.md:82-84`, `templates/README.md:3` and `:7-15`, `templates/tool/README.md:7-14,21,25`, and `docs/architecture/workflow.md:5-9`. Highest-fidelity repo-local validation passed with `.venv-qa/bin/mkdocs build --clean`. Targeted verification confirmed that `AeroToolManager` now exists only in markdown/plans and no longer appears as a real declaration on the class-name scan surface.

---

### Task 4: Audit final state and close the docs cleanup slice

**Bead ID:** `aerobeat-docs-jeyd`  
**SubAgent:** `primary` (for `auditor`)  
**Role:** `auditor`  
**References:** `REF-01`, `REF-02`, `REF-03`, `REF-04`  
**Prompt:** Independently truth-check that `aerobeat-docs` no longer ships real template runtime code, that the docs now link to the canonical template GitHub page(s), and that the mandatory stale-class-name cleanup guidance is explicit. Claim the bead on start and close it only if the docs refactor is actually done.

**Folders Created/Deleted/Modified:**
- None

**Files Created/Deleted/Modified:**
- `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-docs/.plans/2026-05-30-docs-template-linkout-and-placeholder-code-removal.md`

**Status:** ✅ Complete

**Results:** Completed via bead `aerobeat-docs-jeyd`. Independent audit at repo state `ddc4eba` confirmed that `templates/` no longer ships runnable payloads and now contains only `README.md` linkout surfaces, that the docs explicitly link to the canonical GitHub template repos, and that the mandatory stale-name cleanup guidance is explicit and repeated in the right places. Independent checks confirmed `AeroToolManager` now appears only in markdown guidance, not as a real runtime declaration, and a fresh `mkdocs build --clean` succeeded. Minor repo-state note from audit: the plan file itself remained untracked at audit time, which does not invalidate the docs refactor but should be cleaned up if we want the repo fully buttoned up.

---

## Final Results

**Status:** ✅ Complete

**What We Built:** Removed docs-hosted runnable template payloads from `aerobeat-docs` and replaced them with docs-only linkouts to the canonical `aerobeat-template-*` GitHub repos. The refactor deleted the real placeholder tool manager implementation and equivalent runnable scaffolding from the `templates/` tree, rewrote the template README surfaces into GitHub link indices, and sharpened the mandatory post-clone cleanup guidance so stale names like `AeroToolManager` must be renamed immediately after clone.

**Reference Check:**
- `REF-01` was satisfied by removing the current unwanted docs-hosted runtime payload from `templates/tool/`.
- `REF-02` was preserved and sharpened in the surviving docs guidance.
- `REF-03` is now the canonical real code owner linked from the docs.
- `REF-04` stayed aligned with the prior naming-wave guidance already landed.

**Commits:**
- `ddc4eba` - `Refactor docs templates into GitHub linkouts`

**Lessons Learned:**
- Docs can accidentally become runtime ownership surfaces if they carry real template payloads instead of linking to the canonical template repos.
- Placeholder class names are acceptable only at clone-time, never as a durable shipped runtime identity.
- Auditing for `class_name` declarations is a useful backstop when a docs repo starts carrying runnable scaffolding.

---

*Completed on 2026-05-30*
