# AeroBeat Family Shape Audit

**Date:** 2026-04-20  
**Status:** Complete  
**Agent:** Pico 🐱‍🏍

---

## Goal

Audit the full AeroBeat repo family for residual shape mismatches from the recent GodotEnv/package-architecture refactor, identify every repo that still violates the intended structure, and then fix those issues repo-by-repo.

---

## Overview

Derrick spotted an obvious residual issue in `aerobeat-input-keyboard`: dummy `addons` and `.addons` folders sitting at repo root. That strongly suggests the recent refactor did not land cleanly everywhere, and we should stop treating the current family as uniformly migrated. The right move now is a full family-wide audit against the intended AeroBeat shape, followed by targeted cleanup work in each repo that still diverges.

This is cross-repo coordination work, so the plan lives in `aerobeat-docs` as the family coordination repo. The audit needs to be explicit about what “intended shape” means for each class of repo under the GodotEnv direction — package/foundation/input/UI-shell style repos vs assembly repos — so we do not “fix” repos into the wrong template. After the audit, each affected repo should get its own bead-backed cleanup task rather than silently bundling many unrelated fixes into one vague pass.

---

## REFERENCES

| ID | Description | Path |
| --- | --- | --- |
| `REF-01` | Derrick’s instruction for a full AeroBeat audit and the `aerobeat-input-keyboard` residual issue example | current session notes (2026-04-20 11:22 EDT) |
| `REF-02` | Prior AeroBeat family cleanup work and GodotEnv direction | `memory/2026-04-16.md`, `memory/2026-04-17.md` |
| `REF-03` | AeroBeat package/integration architecture guidance | `projects/aerobeat/aerobeat-input-mediapipe-python/.plans/INTEGRATION-ARCHITECTURE.md` |
| `REF-04` | Current AeroBeat repo family on disk | `/home/derrick/.openclaw/workspace/projects/aerobeat/` |
| `REF-05` | Existing family coordination home | `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-docs/` |

---

## Tasks

### Task 1: Audit the AeroBeat repo family against the intended shape

**Bead ID:** `oc-wbq`  
**SubAgent:** `research`  
**References:** `REF-01`, `REF-02`, `REF-03`, `REF-04`, `REF-05`  
**Prompt:** Audit the full AeroBeat repo family and identify which repos still do not match the intended shape after the recent refactor. Use Derrick’s `aerobeat-input-keyboard` dummy `addons` / `.addons` folders as one concrete audit target, but inspect the family broadly for the same class of residual issue and any other shape mismatches against the intended GodotEnv/package architecture. Produce a repo-by-repo findings map that distinguishes repo class, observed mismatch, severity, and suggested cleanup scope. Do not edit files yet.

**Folders Created/Deleted/Modified:**
- `.plans/`

**Files Created/Deleted/Modified:**
- `.plans/2026-04-20-aerobeat-family-shape-audit.md`

**Status:** ✅ Complete

**Results:** Audit confirmed a single repeated cleanup class across 12 package-class repos: stray root-level `addons/` and `.addons/` directories still exist even though these repos now use `.testbed/addons/` and `.testbed/.addons/` as the canonical workbench/install locations. The affected concrete repos are `aerobeat-feature-step`, `aerobeat-input-gamepad`, `aerobeat-input-joycon-hid`, `aerobeat-input-keyboard`, `aerobeat-input-mouse`, `aerobeat-input-touch`, `aerobeat-input-xr`, `aerobeat-tool-api`, and `aerobeat-tool-settings`; the affected template repos are `aerobeat-template-feature`, `aerobeat-template-input`, and `aerobeat-template-tool`. Assembly repos were intentionally not included in this cleanup class because their root-level addon layout follows different rules and should not be force-fit into the package cleanup. First execution wave should target the 9 concrete repos, with the 3 template repos held for the second wave after the concrete pass is proven clean.

---

### Task 2: Create repo-local cleanup beads and update the plan with the cleanup map

**Bead ID:** `oc-xph`  
**SubAgent:** `primary`  
**References:** `REF-01`, `REF-02`, `REF-04`, `REF-05`  
**Prompt:** Using the audit findings, create the needed repo-local cleanup beads in the appropriate owning repos (or coordination beads where appropriate), link them back into the plan, and turn the findings into an executable cleanup map. Do not implement repo changes yet; just set the execution structure cleanly.

**Folders Created/Deleted/Modified:**
- `.plans/`

**Files Created/Deleted/Modified:**
- `.plans/2026-04-20-aerobeat-family-shape-audit.md`

**Status:** ✅ Complete

**Results:** Initialized repo-local Beads state in each affected owning repo so the cleanup work can stay with the repo that owns it instead of being hidden in one coordination issue. Created one repo-local cleanup bead per affected repo, each scoped narrowly to removing stray root `addons/` and `.addons/` while preserving `.testbed/addons/` and `.testbed/.addons/`.

#### Executable cleanup map

**Wave 1 — concrete repos (run first):**
- `aerobeat-feature-step` — bead `oc-gym`
- `aerobeat-input-gamepad` — bead `oc-82p`
- `aerobeat-input-joycon-hid` — bead `oc-db0`
- `aerobeat-input-keyboard` — bead `oc-fzj`
- `aerobeat-input-mouse` — bead `oc-l9g`
- `aerobeat-input-touch` — bead `oc-4dy`
- `aerobeat-input-xr` — bead `oc-dt2`
- `aerobeat-tool-api` — bead `oc-91o`
- `aerobeat-tool-settings` — bead `oc-x9i`

**Wave 2 — templates (after the concrete pass):**
- `aerobeat-template-feature` — bead `oc-aqr`
- `aerobeat-template-input` — bead `oc-0s0`
- `aerobeat-template-tool` — bead `oc-e5t`

**Coordination notes:**
- No extra cross-repo coordination bead was needed beyond `aerobeat-docs` task `oc-xph`; the work decomposes cleanly into repo-local owning-repo beads.
- None of the 12 affected repos had Beads initialized yet, so Task 2 initialized repo-local `.beads/` state in each one to keep execution ownership local and explicit.
- The intended cleanup remains intentionally narrow: delete only the stray root package leftovers, do not touch assembly repos, and do not remove valid `.testbed/` addon caches/install locations.

---

### Task 3: Execute the highest-priority repo cleanup passes

**Bead ID:** `oc-hq8`  
**SubAgent:** `coder`  
**References:** `REF-01`, `REF-02`, `REF-03`, `REF-04`  
**Prompt:** Starting with Wave 1 from the cleanup map, implement the needed repo-local cleanup in `aerobeat-feature-step` (`oc-gym`), `aerobeat-input-gamepad` (`oc-82p`), `aerobeat-input-joycon-hid` (`oc-db0`), `aerobeat-input-keyboard` (`oc-fzj`), `aerobeat-input-mouse` (`oc-l9g`), `aerobeat-input-touch` (`oc-4dy`), `aerobeat-input-xr` (`oc-dt2`), `aerobeat-tool-api` (`oc-91o`), and `aerobeat-tool-settings` (`oc-x9i`). Remove only stray root `addons/` and `.addons/` from these package-class repos, preserve `.testbed/addons/` and `.testbed/.addons/`, and avoid broadening scope beyond this shape fix. Wave 2 template repos should wait until the concrete pass is complete.

**Folders Created/Deleted/Modified:**
- Repo-local root `addons/` and `.addons/` directories in the Wave 1 repos above

**Files Created/Deleted/Modified:**
- Repo-local `.beads/` state and any repo-local cleanup artifacts required by the implementation pass

**Status:** ✅ Complete

**Results:** Cleanup execution completed across both waves. Wave 1 covered the 9 concrete repos: `aerobeat-feature-step` (`oc-gym`), `aerobeat-input-gamepad` (`oc-82p`), `aerobeat-input-joycon-hid` (`oc-db0`), `aerobeat-input-keyboard` (`oc-fzj`), `aerobeat-input-mouse` (`oc-l9g`), `aerobeat-input-touch` (`oc-4dy`), `aerobeat-input-xr` (`oc-dt2`), `aerobeat-tool-api` (`oc-91o`), and `aerobeat-tool-settings` (`oc-x9i`). Wave 2 then covered the 3 template repos: `aerobeat-template-feature` (`oc-aqr`), `aerobeat-template-input` (`oc-0s0`), and `aerobeat-template-tool` (`oc-e5t`). In every repo, the targeted root `addons/` and root `.addons/` directories were confirmed to be empty residual package-class leftovers before removal. The cleanup deliberately preserved `.testbed/addons.jsonc`, `.testbed/addons/`, and `.testbed/.addons/` state in each repo. Because the stale root directories were untracked empty folders rather than tracked repo content, the work produced no Git diff and therefore no repo commits or pushes were possible without artificially broadening scope. All 12 repo-local beads were completed and closed after verifying that the targeted leftovers were removed and that the intended `.testbed` addon state remained intact.

---

### Task 4: QA and independent audit of the cleanup wave

**Bead ID:** `oc-bs0`  
**SubAgent:** `qa` + `auditor`  
**References:** `REF-01`, `REF-02`, `REF-03`, `REF-04`  
**Prompt:** Independently verify the cleanup wave and then audit whether the targeted repos now match the intended shape. Confirm whether any residual family-wide mismatches remain after the first pass.

**Folders Created/Deleted/Modified:**
- `.plans/`

**Files Created/Deleted/Modified:**
- `.plans/2026-04-20-aerobeat-family-shape-audit.md`

**Status:** ✅ Complete

**Results:** Final QA/audit verified the full 12-repo cleanup set, not just Wave 1. Across `aerobeat-feature-step`, `aerobeat-input-gamepad`, `aerobeat-input-joycon-hid`, `aerobeat-input-keyboard`, `aerobeat-input-mouse`, `aerobeat-input-touch`, `aerobeat-input-xr`, `aerobeat-tool-api`, `aerobeat-tool-settings`, `aerobeat-template-feature`, `aerobeat-template-input`, and `aerobeat-template-tool`, root `addons/` and root `.addons/` are now absent, while `.testbed/addons.jsonc`, `.testbed/addons/`, and `.testbed/.addons/` all remain present. `git status --short` is clean in every repo, `git ls-files` confirms there were no tracked root `addons` / `.addons` paths in this cleanup class, and `git log --all -- addons .addons` returned no path history for those root directories in the affected repos. That truth-check confirms the unusual but valid outcome from both cleanup waves: deleting empty untracked residual directories yields no Git diff, so no commit or push was available without broadening scope. The original audit target is now fully resolved family-wide for the identified cleanup class; no residual root `addons/` / `.addons/` package-class leftovers remain in the affected repos.

---

## Final Results

**Status:** ✅ Complete

**What We Built:** Completed the family coordination audit, execution map, Wave 1 concrete cleanup, Wave 2 template cleanup, and final independent QA/audit verification for the full 12-repo affected set. The identified residual issue — stray root `addons/` and `.addons/` directories in package-class repos that should only use `.testbed` addon locations — has now been removed across all affected AeroBeat repos without damaging the canonical `.testbed` addon layout.

**Reference Check:** `REF-01` satisfied by explicitly auditing the residual keyboard example and then resolving the same cleanup class across all affected repos. `REF-02` and `REF-03` satisfied by preserving the GodotEnv/package convention of `.testbed/addons/` and `.testbed/.addons/` as the valid workbench/install locations while removing the stale root leftovers. `REF-04` satisfied by direct repo-by-repo verification on disk and in Git state across both waves.

**Commits:**
- None for the repo-local cleanup itself; the verified explanation is that the removed root directories were untracked empty leftovers, so Git had no content change to record.
- `Pending local commit` - Add completed AeroBeat family shape audit plan

**Lessons Learned:** Cross-repo shape cleanups can be real even when they produce no commit history; the reliable truth source is repo shape plus Git tracking state, not commit presence. The two-wave approach was still useful because it let the concrete repos prove the pattern before the templates were cleaned. For this cleanup class, the highest-value audit check was verifying both absence on disk and absence from Git history/tracking, not waiting for commits that could never exist.

---

*Completed on 2026-04-20*
