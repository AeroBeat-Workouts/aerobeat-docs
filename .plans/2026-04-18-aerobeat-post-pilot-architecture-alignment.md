# AeroBeat Post-Pilot Architecture Alignment

**Date:** 2026-04-18  
**Status:** In Progress  
**Agent:** Pico 🐱‍🏍

**Pinned Godot Version:** `4.6.2 stable standard` (from `/home/derrick/.openclaw/.env`)

---

## Goal

Propagate the finalized post-pilot AeroBeat architecture decisions across templates, docs, and the broader package repo family so every AeroBeat repo aligns with the updated GodotEnv layout and pinned Godot version policy.

---

## Overview

The `aerobeat-feature-boxing` pilot is complete and audited. That pilot locked in two important architecture decisions that now need to be rolled out beyond the single repo: package repos should treat repo root more like a published/dist boundary, and repo-local unit tests should therefore live under `.testbed/tests/` rather than root `test/`. It also confirmed the Godot version normalization rule: `project.godot` feature markers should use `4.6`, while human-facing docs/tooling should reference the exact pinned OpenClaw toolchain `4.6.2 stable standard`.

The immediate non-blockers surfaced by QA/audit are now the next execution scope: stale template assumptions in `aerobeat-docs`, broader package-repo drift still using the old test-layout and old Godot feature markers, and documentation that still describes superseded paths or commands. This plan treats the boxing pilot as the reference implementation and rolls that architecture through the family in a controlled sequence.

This work remains coordination-owned by `aerobeat-docs`, but repo-local changes belong in the repos they touch. The execution should stay structured: first normalize the architecture docs/templates, then update the broader package family, then perform a cross-repo audit to verify alignment rather than assuming it.

---

## REFERENCES

| ID | Description | Path |
| --- | --- | --- |
| `REF-01` | Completed boxing pilot execution record | `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-docs/.plans/2026-04-18-aerobeat-phase-2-pilot-boxing.md` |
| `REF-02` | Boxing pilot architecture packet | `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-docs/docs/architecture/godotenv-phase-2-pilot-boxing-packet-2026-04-18.md` |
| `REF-03` | Godot version audit | `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-docs/docs/architecture/godot-version-audit-2026-04-18.md` |
| `REF-04` | GodotEnv convention contract | `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-docs/docs/architecture/godotenv-convention-contract.md` |
| `REF-05` | GodotEnv clean-break removal policy | `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-docs/docs/architecture/godotenv-clean-break-removal-policy.md` |
| `REF-06` | AeroBeat repo family root | `/home/derrick/.openclaw/workspace/projects/aerobeat` |
| `REF-07` | Pinned OpenClaw toolchain versions | `/home/derrick/.openclaw/.env` |

---

## Tasks

### Task 1: Codify the finalized post-pilot architecture in docs and templates

**Bead ID:** `oc-zt5`  
**SubAgent:** `research` → `coder`  
**References:** `REF-01`, `REF-02`, `REF-03`, `REF-04`, `REF-05`, `REF-07`  
**Prompt:** Update AeroBeat architecture docs and template sources so they reflect the finalized post-pilot rules: package repo unit tests live in `.testbed/tests/`, any workbench/manual scenes use `.testbed/scenes/`, root `test/` is no longer canonical for package repos, `project.godot` feature markers normalize to `4.6`, and human-facing docs/tooling normalize to `Godot 4.6.2 stable standard`.

**Folders Created/Deleted/Modified:**
- `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-docs/docs/architecture/`
- `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-docs/templates/`

**Files Created/Deleted/Modified:**
- architecture docs / template `project.godot` files / template README or workflow files as needed

**Status:** ✅ Complete

**Results:** Updated the architecture docs and template sources to codify the post-pilot package layout. Package templates now point repo-local tests at `.testbed/tests/`, reserve `.testbed/scenes/` for future manual/workbench content, normalize template `project.godot` markers from `4.2` to `4.6`, and pin touched human-facing tooling/docs to `Godot 4.6.2 stable standard`. Template CI for package repos now targets `res://tests` instead of legacy `res://test/unit`. Remaining broader repo-family rollout work stays in `oc-qqn`.

---

### Task 2: Roll the approved package-repo architecture updates across the AeroBeat family

**Bead ID:** `oc-qqn`  
**SubAgent:** `coder`  
**References:** `REF-01`, `REF-02`, `REF-03`, `REF-04`, `REF-05`, `REF-06`, `REF-07`  
**Prompt:** Apply the approved post-pilot architecture updates across the broader AeroBeat package repo family. Update repo-local Godot project markers from `4.2` to `4.6` where required, normalize touched human-facing docs/tooling to `Godot 4.6.2 stable standard`, and migrate legacy package test layout/content away from root `test/` / `.testbed/test` to `.testbed/tests/` and `.testbed/scenes/` where that old pattern exists and is in scope.

**Folders Created/Deleted/Modified:**
- affected repo-local `.testbed/` folders across the AeroBeat package family
- affected repo roots across the AeroBeat package family

**Files Created/Deleted/Modified:**
- repo-local `project.godot`, README, CI, ignore, tests, and related files as needed in affected repos

**Status:** ✅ Complete

**Results:** Completed the straight-through package-family rollout across the broader non-assembly AeroBeat repo set. Landed repo-local alignment in `aerobeat-core`, `aerobeat-ui-core`, `aerobeat-ui-kit-community`, `aerobeat-feature-dance`, `aerobeat-feature-flow`, `aerobeat-feature-step`, `aerobeat-input-gamepad`, `aerobeat-input-joycon-hid`, `aerobeat-input-keyboard`, `aerobeat-input-mediapipe-native`, `aerobeat-input-mouse`, `aerobeat-input-touch`, `aerobeat-input-xr`, `aerobeat-tool-api`, `aerobeat-tool-settings`, `aerobeat-ui-shell-desktop-community`, `aerobeat-ui-shell-mobile-community`, `aerobeat-ui-shell-web-community`, `aerobeat-ui-shell-xr-community`, `aerobeat-template-feature`, `aerobeat-template-input`, `aerobeat-template-tool`, `aerobeat-template-ui-kit`, `aerobeat-template-ui-shell`, `aerobeat-asset-prototypes`, `aerobeat-template-asset`, `aerobeat-template-avatar`, `aerobeat-template-cosmetic`, `aerobeat-template-environment`, and `aerobeat-template-skin` (refs `REF-01` through `REF-07`). The rollout normalized touched `.testbed/project.godot` files to `4.6`, moved straightforward root `test/` suites into `.testbed/tests/`, removed tracked `.testbed/test` symlink expectations where they still existed, split `aerobeat-core`’s manual workbench scene content into `.testbed/scenes/`, and updated touched README / setup / CI references to the new `.testbed/tests` + `Godot 4.6.2 stable standard` wording where exact version text was present. Validation for this rollout included a repo-shape audit script across all touched repos confirming no remaining root `test/` or `.testbed/test` in the aligned set, workflow/path checks for `res://tests` plus `4.6.2`, and representative import/bootstrap smoke checks in `aerobeat-core` and `aerobeat-feature-dance`. Commits were pushed to `main` over SSH in each touched repo. Intentional follow-on drift left for separate work/audit: assembly repos (`aerobeat-assembly-community`, `aerobeat-template-assembly`) were not force-fit into the package rules; `aerobeat-feature-boxing` was already aligned; `aerobeat-input-mediapipe-python` still needs dedicated follow-on because it has larger sidecar/manual-scene/testbed complexity and a real `.testbed/test` workbench tree that should be migrated deliberately rather than bulk-rewritten; docs-template source trees under `aerobeat-docs/templates/` still carry their own source-side legacy files and are tracked separately by Task 1 / final audit rather than this repo-family pass.

---

### Task 3: Verify full AeroBeat alignment against the updated architecture and Godot version policy

**Bead ID:** `oc-3mf`  
**SubAgent:** `auditor`  
**References:** `REF-01`, `REF-02`, `REF-03`, `REF-04`, `REF-05`, `REF-06`, `REF-07`  
**Prompt:** Independently audit the AeroBeat repo family after rollout. Verify that templates, docs, and package repos align with the finalized architecture decisions and Godot version policy, and report any remaining drift explicitly. The audit should confirm both the `.testbed/tests` / `.testbed/scenes` architecture and the `4.6` / `4.6.2 stable standard` version split.

**Folders Created/Deleted/Modified:**
- coordination docs/plan updates as needed

**Files Created/Deleted/Modified:**
- final audit notes / plan updates as needed

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
