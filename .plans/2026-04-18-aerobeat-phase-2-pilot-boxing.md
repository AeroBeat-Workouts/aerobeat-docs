# AeroBeat Phase 2 — Pilot Package Family (`aerobeat-feature-boxing`)

**Date:** 2026-04-18  
**Status:** In Progress  
**Agent:** Pico 🐱‍🏍

**Pinned Godot Version:** `4.6.2` (from `/home/derrick/.openclaw/.env`)

---

## Goal

Start the next AeroBeat GodotEnv migration wave by migrating one simple package family end-to-end, using `aerobeat-feature-boxing` as the pilot repo.

---

## Overview

Phase 1 is complete: the foundational chain (`aerobeat-core` → `aerobeat-ui-core` → `aerobeat-ui-kit-community`) is normalized, tagged, and audited. The follow-on research also clarified the installed-addon dirtiness policy: AeroBeat should treat installed addons as immutable and fix `.uid` churn at the source rather than adding local wrapper complexity.

That makes the next sensible step a Phase 2 pilot in a low-risk package repo. The migration audit already identified `aerobeat-feature-boxing` as the best first candidate because it is simple enough to validate the standard package-repo `.testbed` flow without immediately dragging in the UI-shell special case. This plan keeps scope narrow but now includes one explicit cross-cutting requirement from Derrick: all AeroBeat repos must converge on the pinned Godot version from `/home/derrick/.openclaw/.env` (`4.6.2`) instead of carrying older version references.

Because `aerobeat-feature-boxing` is the repo Derrick expects to resume direct feature work in after the migration wave, validation here must go beyond just restore/import success. The pilot should leave the `.testbed/` Godot project as the canonical place to open the repo, reproduce bugs, and continue day-to-day boxing feature development once the family-wide migration is done.

After review, Derrick explicitly changed the test-layout direction: package repos should treat repo root more like a published/dist boundary, so repo unit tests should no longer live at root `test/`. Instead, the migration should move unit tests under `.testbed/tests/`, and any existing workbench scene folder currently named `.testbed/test/` should be renamed to `.testbed/scenes/`. That user decision supersedes the earlier boxing pilot packet assumption that root tests would stay in place behind a `.testbed/test -> ../test` link.

This is still coordination work owned by `aerobeat-docs`, while implementation and validation happen in the pilot repo through the normal coder → QA → auditor loop. The Godot-version alignment work may touch multiple AeroBeat repos, but it should still be tracked explicitly inside this coordination plan rather than being left as an implied cleanup.

---

## REFERENCES

| ID | Description | Path |
| --- | --- | --- |
| `REF-01` | Migration audit with Phase 2 recommendation | `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-docs/docs/architecture/godotenv-migration-audit.md` |
| `REF-02` | Phase 0 convention contract | `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-docs/docs/architecture/godotenv-convention-contract.md` |
| `REF-03` | Clean-break retirement policy | `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-docs/docs/architecture/godotenv-clean-break-removal-policy.md` |
| `REF-04` | Completed Phase 1 execution record | `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-docs/.plans/2026-04-17-aerobeat-phase-1-foundations-execution.md` |
| `REF-05` | Installed-addon dirtiness research and recommendation | `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-docs/docs/architecture/godotenv-installed-addon-dirtiness-research.md` |
| `REF-06` | Pilot repo | `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-feature-boxing` |
| `REF-07` | Pinned OpenClaw toolchain versions, including Godot | `/home/derrick/.openclaw/.env` |

---

## Tasks

### Task 1: Audit AeroBeat Godot version references against the pinned OpenClaw version

**Bead ID:** `oc-d5q`  
**SubAgent:** `research`  
**References:** `REF-01`, `REF-04`, `REF-06`, `REF-07`  
**Prompt:** Audit AeroBeat repos for explicit Godot version references and compare them to the pinned OpenClaw Godot version in `/home/derrick/.openclaw/.env` (`4.6.2`). Produce a repo-by-repo mismatch list, identify which references are documentation-only versus operational/tooling-critical, and recommend the smallest safe normalization sequence.

**Folders Created/Deleted/Modified:**
- `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-docs/.plans/`
- `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-docs/docs/architecture/`

**Files Created/Deleted/Modified:**
- this plan file
- `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-docs/docs/architecture/godot-version-audit-2026-04-18.md`

**Status:** ✅ Complete

**Results:** Completed the repo-family Godot version audit and recorded it in `docs/architecture/godot-version-audit-2026-04-18.md`. Findings: 31 product repos still carry `config/features=PackedStringArray("4.2", ...)` in their primary Godot project file; 3 product repos already carry `4.6`; and `aerobeat-docs/templates/` still stamp 11 template project files with `4.2`, which would reintroduce drift after repo fixes. The audit also identified human-facing/tooling references that still say `Godot 4.6` instead of the exact pinned OpenClaw toolchain `4.6.2 stable standard`, and recommended the smallest safe normalization order: define the policy once, fix templates first, then the pilot repo, then batch the rest. See the audit doc for the exact repo/file inventory.

---

### Task 2: Define the Phase 2 pilot execution packet for `aerobeat-feature-boxing`

**Bead ID:** `oc-a3t`  
**SubAgent:** `research`  
**References:** `REF-01`, `REF-02`, `REF-03`, `REF-04`, `REF-05`, `REF-06`, `REF-07`  
**Prompt:** Review the current `aerobeat-feature-boxing` repo against the completed Phase 1 foundation chain, the documented migration rules, and the pinned Godot version in `/home/derrick/.openclaw/.env`. Produce an execution-ready packet describing exactly what must change for the repo to adopt the canonical `.testbed/addons.jsonc` flow, what legacy bootstrap/setup artifacts must be removed, what dependency/tag references it should consume, what Godot-version references must be updated, and how validation should be run directly from the `.testbed/` Godot project as the future day-to-day boxing bugfinding environment.

**Folders Created/Deleted/Modified:**
- `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-docs/.plans/`
- `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-docs/docs/architecture/`

**Files Created/Deleted/Modified:**
- this plan file
- `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-docs/docs/architecture/godotenv-phase-2-pilot-boxing-packet-2026-04-18.md`

**Status:** ✅ Complete

**Results:** Completed the execution-ready pilot packet and recorded it in `docs/architecture/godotenv-phase-2-pilot-boxing-packet-2026-04-18.md`. The packet confirms that `aerobeat-feature-boxing` is still on the legacy template-era flow (`setup_dev.py`, template README text, stale `.gitignore`, `4.2` testbed marker, and submodule-era CI), and it originally specified a `.testbed/test -> ../test` bridge. After Derrick's follow-up repo-layout decision, the packet was amended so the approved migration shape is now: add `.testbed/addons.jsonc`, move repo unit tests into `.testbed/tests/`, use `.testbed/scenes/` for any future workbench scene content, update README/ignore/CI to the GodotEnv testbed flow, change `.testbed/project.godot` from `4.2` to `4.6`, and delete `setup_dev.py` in the same change. The packet also locks the initial dependency contract for the pilot (`aerobeat-core` via SSH at `v0.1.0`, `gut` via SSH at `main` with `subfolder: "/addons/gut"`), standardizes validation on direct `.testbed/` restore/import/test commands with GUT targeting `res://tests`, and calls out separable follow-on work for template cleanup, package-family rollout, and Boxing repo-shape cleanup.

---

### Task 3: Normalize repo version references and migrate `aerobeat-feature-boxing` to the Phase 2 pilot flow

**Bead ID:** `oc-81o`  
**SubAgent:** `coder`  
**References:** `REF-02`, `REF-03`, `REF-05`, `REF-06`, `REF-07`  
**Prompt:** Implement the approved Phase 2 pilot packet, amended by Derrick's repo-layout decision. In `aerobeat-feature-boxing`, add the canonical `.testbed/addons.jsonc` manifest, remove superseded setup/bootstrap machinery, move repo unit tests from root `test/` into `.testbed/tests/`, rename any workbench scene/content folder currently named `.testbed/test/` to `.testbed/scenes/`, update repo docs/ignore hygiene, align all repo-local Godot version references to the pinned `4.6.2` value from `/home/derrick/.openclaw/.env`, and verify the repo consumes the tagged foundational chain cleanly under the GodotEnv workflow. Apply the same test-layout rule to other AeroBeat repos in approved scope when they contain the old pattern, with explicit bead linkage.

**Folders Created/Deleted/Modified:**
- `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-feature-boxing/.testbed/`
- other AeroBeat repo folders only if explicitly included by the approved audit packet

**Files Created/Deleted/Modified:**
- repo manifest / setup / docs / ignore files as needed in `aerobeat-feature-boxing`
- Godot version reference files in any approved repo scope

**Status:** ✅ Complete

**Results:** Implemented the boxing pilot migration in `aerobeat-feature-boxing` and updated the coordination artifacts to match the final approved layout. In the pilot repo, added `.testbed/addons.jsonc` with `aerobeat-core@v0.1.0` and `gut@main` over SSH, deleted `setup_dev.py`, moved the example unit test from root `test/` into `.testbed/tests/test_example.gd`, updated README/CI/ignore rules to the GodotEnv flow, changed `.testbed/project.godot` from `4.2` to `4.6`, and standardized local/CI GUT runs on `res://tests` under the hidden `.testbed/` workbench. Because Derrick's repo-layout decision superseded the earlier symlink plan, the architecture packet was amended to remove the obsolete `.testbed/test -> ../test` design and document `.testbed/tests/` plus optional `.testbed/scenes/` instead. Local validation completed successfully with `godotenv addons install`, `godot --headless --path .testbed --import`, and `godot --headless --path .testbed --script addons/gut/gut_cmdln.gd -gdir=res://tests -ginclude_subdirs -gexit`, all on Godot `4.6.2 stable standard`. No additional repo beyond the approved boxing/doc scope was modified.

---

### Task 4: QA the pilot repo end-to-end from the `.testbed` Godot project

**Bead ID:** `oc-6xa`  
**SubAgent:** `qa`  
**References:** `REF-02`, `REF-03`, `REF-05`, `REF-06`, `REF-07`  
**Prompt:** Verify `aerobeat-feature-boxing` end-to-end as a GodotEnv consumer after migration. Use the `.testbed/` Godot project as the primary validation surface, confirm clean restore/import behavior, confirm no dirty installed-addon surprises beyond the documented policy, confirm the repo is ready for future direct boxing bugfinding work inside `.testbed/`, and confirm the new test layout works as intended: repo unit tests live under `.testbed/tests/` while any interactive/workbench scenes live under `.testbed/scenes/`. Run the highest-fidelity repo validation available.

**Folders Created/Deleted/Modified:**
- validation artifacts only if needed

**Files Created/Deleted/Modified:**
- validation notes as needed

**Status:** ⏳ Pending

**Results:** Pending.

---

### Task 5: Audit the pilot and record the repeatable pattern

**Bead ID:** `oc-z55`  
**SubAgent:** `auditor`  
**References:** `REF-01`, `REF-02`, `REF-03`, `REF-04`, `REF-05`, `REF-06`, `REF-07`  
**Prompt:** Independently audit the completed `aerobeat-feature-boxing` migration against the AeroBeat migration rules, the pinned Godot version requirement, and the Phase 2 pilot objective. Verify that `.testbed/` is the correct direct-development/debugging surface for future boxing work. If it passes, record the reusable migration pattern and any corrections needed before rolling the same flow into other package repos.

**Folders Created/Deleted/Modified:**
- `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-docs/docs/architecture/`

**Files Created/Deleted/Modified:**
- pilot audit / follow-up notes as needed

**Status:** ⏳ Pending

**Results:** Pending.

---

## Final Results

**Status:** ⏳ Pending

**What We Built:** Pending.

**Reference Check:** Pending.

**Commits:**
- Pending

**Lessons Learned:** Pending.

---

*Completed on Pending*
