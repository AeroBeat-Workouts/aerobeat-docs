# AeroBeat Phase 1 — UID Hygiene Retry

**Date:** 2026-04-17
**Status:** In Progress
**Agent:** Pico 🐱‍🏍

---

## Goal

Codify the first-party `.uid` release rule for GodotEnv consumption, fix any missing committed `.uid` files in the affected Phase 1 repos, and rerun the failed `aerobeat-ui-kit-community` audit on the corrected architecture assumptions.

---

## Overview

The follow-up research resolved the open architecture question behind the failed `aerobeat-ui-kit-community` audit. Repo-root import remains intentional for first-party AeroBeat repos, and dot-prefixed folders are acceptable because Godot hides them. That means the prior audit concern about repo-root package breadth was based on a stricter boundary assumption than Derrick intends.

The real remaining technical concern is installed-addon dirtiness caused by Godot-generated `.uid` files. Upstream GodotEnv currently treats dirty installed addons as immutable and blocks reinstall, and official Godot guidance says `.uid` files should be committed to version control. For AeroBeat, that means first-party repos need to ship required `.uid` files in the tagged source before assembly repos import them through GodotEnv.

This retry phase therefore has three jobs: update the contract/docs to reflect the clarified rule, patch the affected Phase 1 source repo(s) so required `.uid` files are committed, and then rerun the previously failed `aerobeat-ui-kit-community` audit using the corrected rule set.

---

## REFERENCES

| ID | Description | Path |
| --- | --- | --- |
| `REF-01` | Phase 0 GodotEnv convention contract | `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-docs/docs/architecture/godotenv-convention-contract.md` |
| `REF-02` | Phase 1 execution packet | `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-docs/docs/architecture/godotenv-phase-1-execution-packet.md` |
| `REF-03` | GodotEnv installed addon dirtiness research memo | `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-docs/docs/architecture/godotenv-installed-addon-dirtiness-research.md` |
| `REF-04` | Current Phase 1 foundations execution plan | `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-docs/.plans/2026-04-17-aerobeat-phase-1-foundations-execution.md` |
| `REF-05` | Affected repo: aerobeat-ui-core | `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-ui-core` |
| `REF-06` | Affected repo: aerobeat-ui-kit-community | `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-ui-kit-community` |
| `REF-07` | Derrick clarification: repo-root import is intentional; source repos own committed `.uid` files before tagging | `webchat conversation 2026-04-17` |

---

## Tasks

### Task 1: Codify repo-root import + committed `.uid` rule in the docs contract

**Bead ID:** `oc-p1c`
**SubAgent:** `coder` → `qa` → `auditor`
**References:** `REF-01`, `REF-02`, `REF-03`, `REF-07`
**Prompt:** Update the Phase 0/1 docs so they explicitly state that first-party AeroBeat repos are intentionally consumed from repo root unless documented otherwise, dot-prefixed folders are acceptable because Godot hides them, and first-party repos must commit required Godot-generated `.uid` files before tagging releases intended for GodotEnv consumption.

**Folders Created/Deleted/Modified:**
- `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-docs/docs/architecture/`
- `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-docs/.plans/`

**Files Created/Deleted/Modified:**
- relevant docs under `docs/architecture/`
- `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-docs/.plans/2026-04-17-aerobeat-phase-1-uid-hygiene-retry.md`

**Status:** ✅ Complete

**Results:** Updated `godotenv-convention-contract.md`, `godotenv-phase-1-execution-packet.md`, and `godotenv-installed-addon-dirtiness-research.md` to codify repo-root import as the first-party default, accept dot-prefixed folders in imported payloads because Godot hides them, require committed Godot-generated `.uid` files before release tags intended for GodotEnv consumption, and restate installed addons as immutable/disposable payloads. Ready for QA/audit handoff against `REF-01`, `REF-02`, `REF-03`, and `REF-07`.

---

### Task 2: Fix missing committed `.uid` files in affected Phase 1 repos

**Bead ID:** `oc-8kj`
**SubAgent:** `coder` → `qa` → `auditor`
**References:** `REF-03`, `REF-05`, `REF-07`
**Prompt:** Inspect the current Phase 1 repos for missing required first-party `.uid` files that can make GodotEnv-installed addons dirty after import. Patch the affected repo(s), commit the generated `.uid` files upstream, retag if needed, and verify reinstall predictability improves accordingly.

**Folders Created/Deleted/Modified:**
- `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-ui-core/`
- other affected Phase 1 repos only if evidence shows they also need `.uid` hygiene fixes

**Files Created/Deleted/Modified:**
- required tracked `.uid` files in affected first-party repos
- tag metadata as needed

**Status:** ⏳ Pending

**Results:** Pending.

---

### Task 3: Rerun `aerobeat-ui-kit-community` audit on corrected assumptions

**Bead ID:** `oc-8ak`
**SubAgent:** `auditor`
**References:** `REF-01`, `REF-02`, `REF-03`, `REF-04`, `REF-06`, `REF-07`
**Prompt:** Re-audit `aerobeat-ui-kit-community` using the clarified rule that repo-root import is intentional and dotfolders are acceptable, while checking that first-party installed dependencies now remain clean because required `.uid` files ship upstream. Decide whether the original bead can be closed and whether Phase 1 may advance to the cross-repo audit.

**Folders Created/Deleted/Modified:**
- coordination docs/plan updates as needed

**Files Created/Deleted/Modified:**
- this plan and relevant notes/docs as needed

**Status:** ⏳ Pending

**Results:** Pending.

---

## Final Results

**Status:** ⏳ Pending

**What We Built:** Pending docs clarification, `.uid` hygiene fix, and re-audit.

**Reference Check:** Pending.

**Commits:**
- Pending

**Lessons Learned:** Pending.

---

*Completed on Pending*
