# GodotEnv Installed Addon Dirtiness Research

**Date:** 2026-04-17  
**Status:** Complete  
**Agent:** Pico 🐱‍🏍

---

## Goal

Research whether GodotEnv already has a documented or built-in solution for installed addon dirtiness caused by generated Godot files (such as `plugin.gd.uid`), and determine the best AeroBeat response if it does not.

---

## Overview

During Phase 1 audit work, the main remaining technical concern was not AeroBeat's repo-root package boundary but the fact that installed dependencies can become dirty after Godot touches them. The concrete example surfaced so far is generated files like `plugin.gd.uid` appearing inside an installed addon, which can interfere with reinstall and branch-switch predictability.

This research needs to answer whether Chickensoft GodotEnv already accounts for this common class of problem. If it does, we should align AeroBeat with that built-in behavior rather than inventing extra tooling. If it does not, we need to evaluate whether the right fallback is a small AeroBeat wrapper around common operations (for example, deleting and reacquiring addons) or some other policy such as ignoring generated files, committing them upstream, or adjusting validation flows.

The deliverable is research and recommendation only. No repo architecture changes or wrapper implementation should happen during this pass.

---

## REFERENCES

| ID | Description | Path |
| --- | --- | --- |
| `REF-01` | Current Phase 1 execution plan | `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-docs/.plans/2026-04-17-aerobeat-phase-1-foundations-execution.md` |
| `REF-02` | GodotEnv convention contract | `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-docs/docs/architecture/godotenv-convention-contract.md` |
| `REF-03` | GodotEnv clean-break removal policy | `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-docs/docs/architecture/godotenv-clean-break-removal-policy.md` |
| `REF-04` | User clarification that repo-root import is intentional and dotfolders are acceptable | `webchat conversation 2026-04-17` |
| `REF-05` | GodotEnv upstream docs/repo | `https://github.com/chickensoft-games/GodotEnv` |

---

## Tasks

### Task 1: Research GodotEnv behavior around dirty installed addons

**Bead ID:** `oc-d55`  
**SubAgent:** `research`  
**References:** `REF-02`, `REF-05`  
**Prompt:** Research GodotEnv docs/source/issues to determine how it handles installed addons becoming dirty after Godot generates files such as `.uid` files. Look for documented behavior, built-in safety checks, force-refresh/reinstall behavior, ignored/generated-file handling, and any known issue discussions.

**Folders Created/Deleted/Modified:**
- `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-docs/.plans/`
- `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-docs/docs/architecture/`

**Files Created/Deleted/Modified:**
- `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-docs/.plans/2026-04-17-godotenv-installed-addon-dirtiness-research.md`
- `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-docs/docs/architecture/godotenv-installed-addon-dirtiness-research.md`

**Status:** ✅ Complete

**Results:** Reviewed upstream GodotEnv README, current source, and relevant upstream issues. Confirmed that GodotEnv protects installed addons by creating temporary git repos inside installed addon directories and refusing reinstall when `git status --porcelain` shows changes, but it does not currently ship ignore handling or a force-refresh path for Godot-generated `.uid` / `.import` churn. Recorded findings in `docs/architecture/godotenv-installed-addon-dirtiness-research.md`.

---

### Task 2: Compare possible AeroBeat responses if GodotEnv does not solve it fully

**Bead ID:** `oc-ryh`  
**SubAgent:** `research`  
**References:** `REF-01`, `REF-02`, `REF-03`, `REF-04`, `REF-05`  
**Prompt:** If GodotEnv does not fully solve installed-addon dirtiness, compare likely AeroBeat responses: rely on GodotEnv behavior, wrapper scripts for delete-and-reacquire flows, commit generated files upstream, ignore/tolerate generated files, or adjust validation/workflow policy. Recommend the least-surprising and lowest-maintenance option.

**Folders Created/Deleted/Modified:**
- `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-docs/docs/architecture/`

**Files Created/Deleted/Modified:**
- `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-docs/docs/architecture/godotenv-installed-addon-dirtiness-research.md`

**Status:** ✅ Complete

**Results:** Compared AeroBeat response options against both upstream behavior and AeroBeat’s clean-break policy. Recommended keeping GodotEnv, treating installed addons as immutable, fixing `.uid` dirtiness at the source by committing generated `.uid` files upstream for first-party or maintained-fork addons, and using manual delete-and-reacquire only as an exception recovery flow rather than introducing wrapper architecture.

---

## Final Results

**Status:** ✅ Complete

**What We Built:** Research memo at `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-docs/docs/architecture/godotenv-installed-addon-dirtiness-research.md` covering upstream GodotEnv behavior, current gaps around dirty installed addons, and an AeroBeat recommendation.

**Reference Check:** `REF-01`, `REF-02`, `REF-03`, `REF-04`, and `REF-05` were reviewed. The recommendation aligns with AeroBeat’s clean-break policy and with upstream evidence that GodotEnv currently treats addon immutability as intentional while official Godot 4.4 guidance expects `.uid` files to be committed.

**Commits:**
- Pending (research/doc update only in working tree)

**Lessons Learned:** The core issue is not repo-root imports or dotfolders. The real sharp edge is the interaction between Godot-generated sidecar files and GodotEnv’s intentional dirty-addon protection. For `.uid` files especially, the least-surprising fix is upstream/fork hygiene rather than more local tooling.

---

*Completed on 2026-04-17*
