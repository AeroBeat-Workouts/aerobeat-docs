# AeroBeat Docs

**Date:** 2026-04-16  
**Status:** In Progress  
**Agent:** Pico 🐱‍🏍

---

## Goal

Add a concise verified local-serve quick start to the AeroBeat docs README, then audit and remove nearly all outdated AI/agentic workflow documentation from `aerobeat-docs` so the repo reflects the current reality of the project.

---

## Overview

The first step is small and concrete: capture the now-verified local serve command in `README.md` as a dead-simple quick how-to so Derrick can reliably boot the docs site without re-deriving the workflow. That keeps the newly restored local docs loop easy to use.

The larger follow-up is a repo-wide content audit focused on AI, agents, orchestration, Gastown, Mayor/Polecat/Refinery role docs, and other agentic workflow notes that no longer match how AeroBeat is actually being built. The goal of that audit is to identify what should be deleted outright, what should be rewritten into neutral architecture/project workflow docs, and what—if anything—should remain. Once the docs repo is cleaned up, the same audit/removal pattern can be applied across the other AeroBeat repositories.

---

## REFERENCES

| ID | Description | Path |
| --- | --- | --- |
| `REF-01` | Current local docs startup instructions | `README.md` |
| `REF-02` | Current docs navigation and AI-orchestration sections | `mkdocs.yml` |
| `REF-03` | AI-orchestration docs subtree and related architecture docs | `docs/ai-orchestration/` |

---

## Tasks

### Task 1: Add a verified quick local-serve how-to to README

**Bead ID:** `oc-zyi`  
**SubAgent:** `coder`  
**References:** `REF-01`  
**Prompt:** Update `README.md` in `aerobeat-docs` to include a concise, verified quick-start section for serving the docs locally on Derrick's machine using the working `serve.sh` flow. Keep it short, practical, and clearly separate from the more detailed manual setup section. Include the bead ID in all status updates, claim it on start, and close it when done.

**Folders Created/Deleted/Modified:**
- `.plans/`

**Files Created/Deleted/Modified:**
- `README.md`
- `.plans/2026-04-16-docs-agentic-audit-and-cleanup.md`

**Status:** ✅ Complete

**Results:** Added a concise verified Linux quick-start to `README.md` centered on `./serve.sh`, documented the correct local URL as `http://127.0.0.1:8000/aerobeat-docs/`, noted what the helper script does automatically, and included an alternate-port example. The subagent also corrected the manual setup URL so it matches the actual served docs path. Validation succeeded with `./serve.sh --dev-addr 127.0.0.1:8001` returning HTTP 200 at the served docs URL. The change was committed and pushed as `e3fd13f` (`docs: add verified local serve quick start`).

---

### Task 2: Audit all AI / agentic / orchestration mentions in the docs repo

**Bead ID:** `oc-iox`  
**SubAgent:** `research`  
**References:** `REF-02`, `REF-03`  
**Prompt:** Perform a repo-wide audit of `aerobeat-docs` for AI, agent, agentic, orchestration, Gastown, Mayor, Polecat, Refinery, workflow-role, and similar content. Produce a removal/rewrite inventory with exact file paths, a brief note on what each file currently says, and a recommendation: remove, rewrite, or keep. Include the bead ID in all status updates, claim it on start, and close it when finished.

**Folders Created/Deleted/Modified:**
- `.plans/`

**Files Created/Deleted/Modified:**
- `.plans/2026-04-16-docs-agentic-audit-and-cleanup.md`

**Status:** ✅ Complete

**Results:** The audit found that the stale coordination content is concentrated in a single legacy cluster centered on `docs/ai-orchestration/`, plus the public nav/homepage entries and a handful of template/script artifacts that still point at Gastown-era Mayor/Polecat/Refinery workflow docs. Recommended removals include the entire `docs/ai-orchestration/` subtree, `scripts/sync_gastown.py`, and `plans/hybrid-gastown-plan.md`. Recommended rewrites include `mkdocs.yml`, `docs/index.md`, `docs/architecture/repository-map.md`, and the template-level `templates/_common/AGENTS.md` / `templates/_common/CLAUDE.md` files so generated repos stop inheriting stale orchestration guidance. The audit also identified content that should likely remain because it is product- or infrastructure-relevant rather than stale coordination material, including `docs/gdd/user-content/policing-content.md`, `docs/architecture/testing.md`, and `docs/architecture/cloud_baker.md`. The practical first cleanup sweep is therefore: remove the AI-orchestration docs, remove the corresponding nav block, rewrite homepage/repository-map/template entrypoints, remove the explicit Gastown sync script, and archive/remove the old hybrid Gastown plan.

---

### Task 3: Remove or rewrite outdated agentic workflow content in the docs repo

**Bead ID:** `oc-l7f`  
**SubAgent:** `coder`  
**References:** `REF-01`, `REF-02`, `REF-03`  
**Prompt:** Based on the audit inventory, remove or rewrite the outdated AI/agentic workflow content in `aerobeat-docs` so the repo matches current AeroBeat reality. Default toward deletion for stale workflow-role docs unless a section is still materially useful and can be rewritten accurately. Update nav/config/docs links as needed, validate the site locally, and commit/push the result by default. Include the bead ID in all status updates, claim it on start, and close it when implementation validation is complete.

**Folders Created/Deleted/Modified:**
- `docs/ai-orchestration/`
- `plans/archive/`
- `.plans/`

**Files Created/Deleted/Modified:**
- `mkdocs.yml`
- `docs/index.md`
- `docs/architecture/repository-map.md`
- `templates/_common/AGENTS.md`
- `templates/_common/CLAUDE.md`
- `docs/ai-orchestration/overview.md`
- `docs/ai-orchestration/instructions.md`
- `docs/ai-orchestration/aerobeat-mayor.md`
- `docs/ai-orchestration/aerobeat-polecat.md`
- `docs/ai-orchestration/aerobeat-refinery.md`
- `docs/ai-orchestration/aerobeat-workflow.md`
- `scripts/sync_gastown.py`
- `plans/hybrid-gastown-plan.md`
- `plans/archive/hybrid-gastown-plan.md`
- `.plans/2026-04-16-docs-agentic-audit-and-cleanup.md`

**Status:** ✅ Complete

**Results:** The implementation sweep removed the stale Gastown-era AI orchestration docs, removed the obsolete sync script, and moved `plans/hybrid-gastown-plan.md` into `plans/archive/` so it no longer lives on the active repo surface. It also rewrote `mkdocs.yml`, `docs/index.md`, `docs/architecture/repository-map.md`, and the template-level `templates/_common/AGENTS.md` / `templates/_common/CLAUDE.md` files into neutral, current-reality wording without inventing a replacement agent system. Validation succeeded with `python3 scripts/create_placeholders.py` and `venv/bin/mkdocs build`, and a post-cleanup grep over the active docs/templates/scripts/plans surface reported no remaining active references to `ai-orchestration`, `AI Orchestration`, `Gastown`, `mayor`, `polecat`, or `refinery`. The changes were committed and pushed as `da20bba` (`Remove stale orchestration docs`).

---

### Task 4: QA the cleaned docs repo and confirm local serve still works

**Bead ID:** `oc-a6w`  
**SubAgent:** `qa`  
**References:** `REF-01`, `REF-02`, `REF-03`  
**Prompt:** Independently verify that the cleaned docs repo still builds and serves locally, and that outdated AI/agentic workflow content was actually removed or accurately rewritten per the audit inventory. Confirm no obvious broken nav links remain from removals. Include the bead ID in all status updates, claim it on start, and close it when QA is complete.

**Folders Created/Deleted/Modified:**
- `.plans/`

**Files Created/Deleted/Modified:**
- `.plans/2026-04-16-docs-agentic-audit-and-cleanup.md`

**Status:** ✅ Complete

**Results:** QA independently verified that both the README quick-start commit (`e3fd13f`) and the cleanup commit (`da20bba`) are present, that `docs/ai-orchestration/` is gone, that the old orchestration nav block was removed from `mkdocs.yml`, and that the homepage, repository map, and shared template instructions were rewritten away from the stale Gastown model. QA also confirmed that `plans/hybrid-gastown-plan.md` now lives under `plans/archive/`. Local validation passed with `mkdocs build` and `./serve.sh --dev-addr 127.0.0.1:8001`, which returned HTTP 200 at `http://127.0.0.1:8001/aerobeat-docs/` with the expected page title. The only issue found was environmental rather than repo-local: port `8000` was already in use on the host during QA, so the default serve port may need to be overridden when occupied. QA found no stale orchestration references remaining on the active repo surface and no obvious nav/link regressions caused by the removals.

---

### Task 5: Audit completion and propose the cross-repo cleanup rollout

**Bead ID:** `oc-i3u`  
**SubAgent:** `auditor`  
**References:** `REF-01`, `REF-02`, `REF-03`  
**Prompt:** Perform an independent audit of the docs cleanup. Confirm the repo now reflects current reality, the removals/rewrites were justified, and the local docs workflow still works. Also propose a practical next-step rollout for applying the same AI/agentic cleanup pattern across the rest of the AeroBeat repos. Include the bead ID in all status updates, claim it on start, and close it only if the work truly passes audit.

**Folders Created/Deleted/Modified:**
- `.plans/`

**Files Created/Deleted/Modified:**
- `.plans/2026-04-16-docs-agentic-audit-and-cleanup.md`

**Status:** ⏳ Pending

**Results:** Pending.

---

## Final Results

**Status:** ⏳ Pending

**What We Built:** Pending.

**Reference Check:** Pending.

**Commits:**
- Pending.

**Lessons Learned:** Pending.

---

*Completed on Pending*
