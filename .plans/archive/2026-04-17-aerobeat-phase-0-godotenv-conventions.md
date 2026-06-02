# AeroBeat Phase 0 — GodotEnv Conventions and Foundations Prep

**Date:** 2026-04-17  
**Status:** Complete  
**Agent:** Pico 🐱‍🏍

---

## Goal

Define the exact GodotEnv-era dependency conventions AeroBeat will use, document the rules that govern all later migration phases, and prepare the foundational repo work so Phases 1+ can execute without pausing for fresh approval.

---

## Overview

The audit established that AeroBeat is already package-shaped but still relies on old setup mechanics: `setup_dev.py`, assembly submodules, UI shell kit sync scripts, and docs/templates that teach the obsolete workflow. Before migrating repos, we needed to lock the architecture contract for the new model so the rest of the work could proceed consistently.

Phase 0 stayed in the planning/specification lane. It did not migrate repos. Instead, it turned Derrick's approved defaults into an explicit operating contract: `addons.jsonc` everywhere, `.testbed/addons.jsonc` for package/foundation/UI shell dev harnesses, root `addons.jsonc` for assemblies, `.testbed` retained as the package workbench, clean-break retirement of the old setup flow, and a required final full-family re-audit.

The output set was deliberately kept small and opinionated: one convention contract, one clean-break removal policy, and one Phase 1 execution packet. Together they replace architecture guessing with concrete rules the later migration phases can implement directly.

---

## REFERENCES

| ID | Description | Path |
| --- | --- | --- |
| `REF-01` | Derrick's approval rule for this cleanup: Phase 0 requires confirmation, later phases can proceed without additional approval | `webchat conversation 2026-04-17` |
| `REF-02` | Package dependency research memo | `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-docs/docs/architecture/package-dependency-research.md` |
| `REF-03` | Repo-family audit + migration plan | `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-docs/docs/architecture/godotenv-migration-audit.md` |
| `REF-04` | AeroBeat docs repo | `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-docs` |
| `REF-05` | Foundation repos to prepare for Phase 1 | `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-core`, `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-ui-core`, `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-ui-kit-community` |
| `REF-06` | Final Phase 0 convention contract output | `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-docs/docs/architecture/godotenv-convention-contract.md` |
| `REF-07` | Final clean-break retirement policy output | `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-docs/docs/architecture/godotenv-clean-break-removal-policy.md` |
| `REF-08` | Final Phase 1 execution packet output | `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-docs/docs/architecture/godotenv-phase-1-execution-packet.md` |

---

## Tasks

### Task 1: Define the GodotEnv convention contract

**Bead ID:** `oc-km3`  
**SubAgent:** `research`  
**References:** `REF-01`, `REF-02`, `REF-03`, `REF-04`  
**Prompt:** Produce the authoritative AeroBeat convention spec for GodotEnv dependency management. It must define manifest location rules, naming (`addons.jsonc` vs alternatives), supported dependency modes (`tag`, `branch`, `symlink`), when each mode is allowed, `.testbed` layout expectations, cache/ignore policy, and how package repos, assembly repos, and foundational repos differ.

**Folders Created/Deleted/Modified:**
- `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-docs/.plans/`
- `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-docs/docs/architecture/`

**Files Created/Deleted/Modified:**
- `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-docs/.plans/2026-04-17-aerobeat-phase-0-godotenv-conventions.md`
- `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-docs/docs/architecture/godotenv-convention-contract.md`

**Status:** ✅ Complete

**Results:** Claimed `oc-km3` in the repo-local Beads DB, read the plan first, then used `REF-02` and `REF-03` plus spot checks of `aerobeat-core`, `aerobeat-ui-core`, `aerobeat-ui-kit-community`, `aerobeat-assembly-community`, and the existing shell sync flow to write `REF-06`. The contract locks the canonical manifest locations, names, dependency modes, `.testbed` expectations, repo-type conventions, cache/ignore rules, and the non-negotiable clean-break posture.

---

### Task 2: Define foundational repo responsibilities and release expectations

**Bead ID:** `oc-4eq`  
**SubAgent:** `research`  
**References:** `REF-02`, `REF-03`, `REF-05`  
**Prompt:** Specify the Phase 0 rules for `aerobeat-core`, `aerobeat-ui-core`, and `aerobeat-ui-kit-community`: what contracts they own, how downstream repos should reference them, what release/tag discipline they require, and what must be true before Phase 1 implementation begins.

**Folders Created/Deleted/Modified:**
- `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-docs/docs/architecture/`

**Files Created/Deleted/Modified:**
- `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-docs/docs/architecture/godotenv-convention-contract.md`
- `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-docs/docs/architecture/godotenv-phase-1-execution-packet.md`

**Status:** ✅ Complete

**Results:** Claimed `oc-4eq` and documented the foundational contract directly in `REF-06`, then translated it into execution expectations in `REF-08`. The final spec assigns clear boundaries to `aerobeat-core`, `aerobeat-ui-core`, and `aerobeat-ui-kit-community`, standardizes SemVer-with-`v` tags, requires real release tags instead of branch-only consumption, and sequences Phase 1 as `core -> ui-core -> ui-kit-community`.

---

### Task 3: Define clean-break removal policy for obsolete setup flows

**Bead ID:** `oc-5pl`  
**SubAgent:** `research`  
**References:** `REF-02`, `REF-03`  
**Prompt:** Define the clean-break removal policy for obsolete setup flows (`setup_dev.py`, assembly submodule bootstrap, `sync_ui_kit.py`, `.kit_version`, and related legacy dependency glue). Specify what gets removed outright, what replacement GodotEnv manifests/configs must exist before deletion, and what verification criteria prove the old workflow can be fully retired without temporary wrappers.

**Folders Created/Deleted/Modified:**
- `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-docs/docs/architecture/`

**Files Created/Deleted/Modified:**
- `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-docs/docs/architecture/godotenv-clean-break-removal-policy.md`

**Status:** ✅ Complete

**Results:** Claimed `oc-5pl` and wrote `REF-07` as the explicit clean-break retirement policy. It overrides the earlier audit's temporary-wrapper suggestion, defines replacement artifacts required before deletion, and establishes the four-part proof standard for retirement: clean checkout, branch-switch reliability, no hidden tracked-file mutation, and docs/CI/template parity.

---

### Task 4: Produce the Phase 1 execution packet and final re-audit rule

**Bead ID:** `oc-90e`  
**SubAgent:** `research`  
**References:** `REF-01`, `REF-03`, `REF-05`  
**Prompt:** Convert the approved Phase 0 rules into an execution packet for Phase 1 covering `aerobeat-core`, `aerobeat-ui-core`, and `aerobeat-ui-kit-community`. Include readiness criteria, likely bead breakdown, and an explicit rule that the overall migration closes with a final full-family re-audit.

**Folders Created/Deleted/Modified:**
- `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-docs/docs/architecture/`

**Files Created/Deleted/Modified:**
- `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-docs/docs/architecture/godotenv-phase-1-execution-packet.md`

**Status:** ✅ Complete

**Results:** Claimed `oc-90e` and wrote `REF-08` as the implementation-ready Phase 1 packet. It defines readiness criteria, per-repo outcomes, recommended sequencing, suggested bead structure, completion checklists, and the explicit closeout rule that the overall migration cannot be marked complete until a later full-family re-audit is executed and recorded.

---

## Final Results

**Status:** ✅ Complete

**What We Built:**
- `docs/architecture/godotenv-convention-contract.md` — authoritative Phase 0 dependency-management contract
- `docs/architecture/godotenv-clean-break-removal-policy.md` — authoritative clean-break retirement policy for obsolete setup flows
- `docs/architecture/godotenv-phase-1-execution-packet.md` — implementation-ready Phase 1 packet for `aerobeat-core`, `aerobeat-ui-core`, and `aerobeat-ui-kit-community`

**Reference Check:**
- `REF-01` satisfied: the outputs explicitly treat Phase 0 as the approval gate and later phases as pre-authorized once Phase 0 is landed
- `REF-02` satisfied: the convention contract and execution packet adopt GodotEnv's addon-manifest model, `addons.jsonc`, and the tag/branch/symlink mode split
- `REF-03` satisfied: the package-vs-assembly-vs-shell distinctions, legacy artifact targets, and final family re-audit rule all track the audit findings
- `REF-05` satisfied: the foundational repo responsibilities and sequencing are concrete and implementation-ready

**Commits:**
- Pending in this subagent session

**Lessons Learned:**
- The earlier audit's wrapper-friendly transitional advice had to be explicitly superseded by the later clean-break approval; writing that override down was necessary to avoid future ambiguity.
- The cleanest Phase 0 package was three docs, not one monolith and not many fragments.
- Standardizing first-party addon naming to repo-name keys removes alias drift from the new contract.

---

*Completed on 2026-04-17*
