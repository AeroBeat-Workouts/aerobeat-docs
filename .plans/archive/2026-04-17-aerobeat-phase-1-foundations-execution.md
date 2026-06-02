# AeroBeat Phase 1 — Foundations Execution

**Date:** 2026-04-17  
**Status:** Complete  
**Agent:** Pico 🐱‍🏍

---

## Goal

Execute Phase 1 of the AeroBeat GodotEnv migration by normalizing the foundational repo chain: `aerobeat-core`, `aerobeat-ui-core`, and `aerobeat-ui-kit-community`.

---

## Overview

Phase 0 is complete and approved. The GodotEnv convention contract, clean-break retirement policy, and Phase 1 execution packet are now the operating rules for implementation. This phase is the first real code/docs migration wave and establishes the foundation every later repo migration will rely on.

The work proceeds in strict dependency order. `aerobeat-core` goes first as the lowest-level contract repo. `aerobeat-ui-core` follows once core is normalized and tagged against the new flow. `aerobeat-ui-kit-community` comes third as the first real downstream consumer proving the new foundational chain is usable in practice. This phase is a clean break: no temporary wrappers, no dual-system retention, and no old setup scripts surviving in migrated repos.

This plan coordinates cross-repo execution from `aerobeat-docs`, but the implementation work itself belongs in the owning repos. Each repo gets its own execution bead(s), and each implementation passes through the coder → QA → auditor loop before the phase moves forward.

---

## REFERENCES

| ID | Description | Path |
| --- | --- | --- |
| `REF-01` | Phase 0 convention contract | `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-docs/docs/architecture/godotenv-convention-contract.md` |
| `REF-02` | Clean-break retirement policy | `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-docs/docs/architecture/godotenv-clean-break-removal-policy.md` |
| `REF-03` | Phase 1 execution packet | `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-docs/docs/architecture/godotenv-phase-1-execution-packet.md` |
| `REF-04` | Foundational repo: aerobeat-core | `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-core` |
| `REF-05` | Foundational repo: aerobeat-ui-core | `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-ui-core` |
| `REF-06` | Foundational repo: aerobeat-ui-kit-community | `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-ui-kit-community` |

---

## Tasks

### Task 1: Normalize `aerobeat-core`

**Bead ID:** `oc-f9l`  
**SubAgent:** `coder` → `qa` → `auditor`  
**References:** `REF-01`, `REF-02`, `REF-03`, `REF-04`  
**Prompt:** Normalize `aerobeat-core` to the Phase 0 GodotEnv contract. Add `.testbed/addons.jsonc`, update ignore rules/docs, verify the repo can be restored/validated from the new flow, remove any obsolete dependency bootstrap artifacts if present, and prepare/cut the initial SemVer-style tag required by Phase 1.

**Folders Created/Deleted/Modified:**
- `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-core/.testbed/`

**Files Created/Deleted/Modified:**
- `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-core/.testbed/addons.jsonc`
- repo docs / ignore files / tag metadata as needed

**Status:** ✅ Complete

**Results:** `aerobeat-core` now uses the canonical Phase 1 package/foundation layout with `.testbed/addons.jsonc`, GodotEnv ignore hygiene, and direct README guidance. The release contract was tagged at `v0.1.0` on commit `04a396d`; current `main` is one cleanup commit ahead (`87fe4ed`, removal of stray `AGENTS.md`) without changing the consumed release payload.

---

### Task 2: Normalize `aerobeat-ui-core`

**Bead ID:** `oc-csf`  
**SubAgent:** `coder` → `qa` → `auditor`  
**References:** `REF-01`, `REF-02`, `REF-03`, `REF-05`  
**Prompt:** Normalize `aerobeat-ui-core` to the Phase 0 GodotEnv contract after `aerobeat-core` is complete. Add `.testbed/addons.jsonc`, encode any required dependency on tagged `aerobeat-core`, update ignore rules/docs, verify restore/validation from the new flow, and prepare/cut the initial SemVer-style tag required by Phase 1.

**Folders Created/Deleted/Modified:**
- `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-ui-core/.testbed/`

**Files Created/Deleted/Modified:**
- `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-ui-core/.testbed/addons.jsonc`
- repo docs / ignore files / tag metadata as needed

**Status:** ✅ Complete

**Results:** `aerobeat-ui-core` now pins tagged `aerobeat-core` in `.testbed/addons.jsonc`, ships the required committed `.uid` files for GodotEnv installs, and documents the new flow directly. The corrective release tag is `v0.1.1` on commit `143852f`, and restore/import/GUT validation now passes cleanly against the tagged core dependency.

---

### Task 3: Normalize `aerobeat-ui-kit-community`

**Bead ID:** `oc-4jh`  
**SubAgent:** `coder` → `qa` → `auditor`  
**References:** `REF-01`, `REF-02`, `REF-03`, `REF-06`  
**Prompt:** Normalize `aerobeat-ui-kit-community` to the Phase 0 GodotEnv contract after the foundational chain is tagged. Add `.testbed/addons.jsonc`, remove `setup_dev.py`, update ignore rules/docs, verify restore/validation against tagged `aerobeat-core` and `aerobeat-ui-core`, and prepare/cut the initial SemVer-style tag required by Phase 1.

**Folders Created/Deleted/Modified:**
- `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-ui-kit-community/.testbed/`

**Files Created/Deleted/Modified:**
- `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-ui-kit-community/.testbed/addons.jsonc`
- `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-ui-kit-community/setup_dev.py` (expected deletion)
- repo docs / ignore files / tag metadata as needed

**Status:** ✅ Complete

**Results:** `aerobeat-ui-kit-community` completed the clean-break migration: `.testbed/addons.jsonc` is the only committed dependency contract, `setup_dev.py` is gone, no `.kit_version` survives, and the repo now pins `aerobeat-core v0.1.0` plus `aerobeat-ui-core v0.1.1`. The retry validation/release state is tagged at `v0.1.1` on commit `de6b933`.

---

### Task 4: Cross-repo Phase 1 audit

**Bead ID:** `oc-bny`  
**SubAgent:** `auditor`  
**References:** `REF-01`, `REF-02`, `REF-03`, `REF-04`, `REF-05`, `REF-06`  
**Prompt:** Audit the completed Phase 1 chain (`aerobeat-core`, `aerobeat-ui-core`, `aerobeat-ui-kit-community`) against the Phase 0 contract and Phase 1 packet. Verify manifest placement, clean-break removals, docs parity, release tags, and that the UI kit consumes the normalized tagged foundation chain correctly.

**Folders Created/Deleted/Modified:**
- coordination docs/plan updates as needed

**Files Created/Deleted/Modified:**
- this plan file and any repo-local validation notes as needed

**Status:** ✅ Complete

**Results:** Audited the coherent Phase 1 release chain as `aerobeat-core v0.1.0` -> `aerobeat-ui-core v0.1.1` -> `aerobeat-ui-kit-community v0.1.1`. Verified canonical manifest placement/shape, clean-break removal of parallel dependency systems, ignore/cache hygiene, docs parity, SemVer tag usage, repo-root `subfolder: "/"` imports, committed first-party `.uid` expectations, dependency boundaries, repeated `godotenv addons install` idempotency, post-import cleanliness, and headless GUT passes across all three repos. Phase 1 foundations are ready to advance.

---

## Final Results

**Status:** ✅ Complete

**What We Built:** A coherent Phase 1 foundational GodotEnv chain for `aerobeat-core`, `aerobeat-ui-core`, and `aerobeat-ui-kit-community`, with canonical `.testbed/addons.jsonc` manifests, clean-break dependency management, tagged releases, committed first-party `.uid` hygiene, and passing restore/import/test validation.

**Reference Check:** `REF-01`, `REF-02`, and `REF-03` matched the implemented repo states in `REF-04`, `REF-05`, and `REF-06`. No blocking deviations remained after the UID-hygiene retry.

**Commits:**
- `04a396d` - Normalize aerobeat-core for GodotEnv phase 1 (`v0.1.0`)
- `143852f` - Commit plugin UID for GodotEnv installs (`v0.1.1`)
- `de6b933` - Retry Phase 1 UI kit against aerobeat-ui-core v0.1.1 (`v0.1.1`)

**Lessons Learned:** For AeroBeat’s GodotEnv workflow, release readiness depends on both manifest/tag discipline and source-level `.uid` hygiene so installed addons remain immutable and clean after restore/import.

---

*Completed on 2026-04-17*
