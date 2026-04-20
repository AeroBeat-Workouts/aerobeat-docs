# Sync AeroBeat Workspace and Docs to `aerobeat-input-core`

**Date:** 2026-04-20  
**Status:** In Progress  
**Agent:** Chip 🐱‍💻

---

## Goal

Update the AeroBeat docs and local `/home/derrick/.openclaw/workspace/projects/aerobeat` workspace so the old `aerobeat-core` name is replaced by `aerobeat-input-core`, the newly created core repos exist locally, and repo links/docs are brought into sync with the new six-core architecture.

---

## Overview

The six-core architecture is now documented and the GitHub repos exist, but the broader docs set and local workspace are still partially in a transition state. Some docs still reference `aerobeat-core` as if it were the current canonical repo, some older architecture/migration/testing/licensing pages still point to the old repo URL, and the local checkout directory still appears to be named `aerobeat-core` instead of `aerobeat-input-core`.

This plan treats the work as both a documentation sync and a local workspace normalization pass. The docs need to reflect the real repo names and link targets now that the repos actually exist. The local workspace should also match the architecture, which means renaming the existing local checkout to `aerobeat-input-core` and cloning any newly created core repos that do not yet exist locally.

The most important constraint is to avoid accidental drift between documentation and reality. That means the verification step should check both docs text and actual repo presence/remote URLs in the local `/aerobeat/` folder, then record any remaining exceptions precisely.

---

## REFERENCES

| ID | Description | Path |
| --- | --- | --- |
| `REF-01` | Six-core architecture plan | `.plans/2026-04-20-content-contracts-and-repo-boundaries.md` |
| `REF-02` | Current repo map | `docs/architecture/repository-map.md` |
| `REF-03` | Current workflow docs | `docs/architecture/workflow.md` |
| `REF-04` | Local AeroBeat workspace root | `/home/derrick/.openclaw/workspace/projects/aerobeat` |
| `REF-05` | New canonical input-core repo URL | `https://github.com/AeroBeat-Workouts/aerobeat-input-core` |
| `REF-06` | New canonical feature-core repo URL | `https://github.com/AeroBeat-Workouts/aerobeat-feature-core` |
| `REF-07` | New canonical content-core repo URL | `https://github.com/AeroBeat-Workouts/aerobeat-content-core` |
| `REF-08` | New canonical asset-core repo URL | `https://github.com/AeroBeat-Workouts/aerobeat-asset-core` |
| `REF-09` | New canonical ui-core repo URL | `https://github.com/AeroBeat-Workouts/aerobeat-ui-core` |
| `REF-10` | New canonical tool-core repo URL | `https://github.com/AeroBeat-Workouts/aerobeat-tool-core` |

---

## Tasks

### Task 1: Inventory stale `aerobeat-core` references and local repo state

**Bead ID:** `aerobeat-docs-clk`  
**SubAgent:** `research`  
**References:** `REF-01`, `REF-02`, `REF-03`, `REF-04`, `REF-05`, `REF-06`, `REF-07`, `REF-08`, `REF-09`, `REF-10`  
**Prompt:** Audit the full `aerobeat-docs` repo for remaining stale references to `aerobeat-core` and inspect the local `/home/derrick/.openclaw/workspace/projects/aerobeat` folder for current repo names and remotes. Produce an exact list of docs/files that need updating plus which new core repos are missing locally.

**Folders Created/Deleted/Modified:**
- `docs/`
- `/home/derrick/.openclaw/workspace/projects/aerobeat/`

**Files Created/Deleted/Modified:**
- None expected during inventory

**Status:** ✅ Complete

**Results:** Inventory completed. Live repo audit found `aerobeat-core` references in 41 actionable docs/template/tooling files (plus one `.beads/interactions.jsonl` history record and 9 historical plan files that should not drive the edit pass). Actionable stale files: `publish.yml`; `scripts/create_placeholders.py`; template docs/setup sources under `templates/{feature,assembly,cosmetics,input,ui-shell,tool,environments,avatars,skins,asset,ui-kit}/`; user-facing docs `docs/index.md`, `docs/guides/contributing_workflow.md`, `docs/guides/feature_development.md`, `docs/api/core/index.md`; and architecture/licensing docs `docs/architecture/{godotenv-convention-contract.md,package-dependency-research.md,godot-version-audit-2026-04-18.md,godotenv-migration-audit.md,testing.md,godotenv-phase-2-pilot-boxing-packet-2026-04-18.md,godotenv-phase-1-execution-packet.md,ugc_modding.md,ui-ux.md,overview.md,workflow.md}` plus `docs/licensing/{engineers.md,index.md}`. Some of those are intentional historical/audit docs that may need transition wording instead of blind rename, but they are the exact live-file stale list. The repo already contains new six-core architecture docs (`docs/architecture/repository-map.md`, `topology.md`, `repo-structure-reference.md`, `content-model.md`, `workflow.md`, `overview.md`, `input.md`), so the next doc pass should align older workflow/testing/licensing/template/setup surfaces to that model and repoint old `https://github.com/AeroBeat-Workouts/aerobeat-core(.git)` URLs to the appropriate new canonical repos (`input`, `feature`, `content`, `asset`, `ui`, `tool`) case-by-case. Local workspace inventory under `REF-04`: current top-level dirs are `aerobeat-assembly-community`, `aerobeat-asset-prototypes`, `aerobeat-core`, `aerobeat-docs`, `aerobeat-feature-boxing`, `aerobeat-feature-dance`, `aerobeat-feature-flow`, `aerobeat-feature-step`, `aerobeat-input-gamepad`, `aerobeat-input-joycon-hid`, `aerobeat-input-keyboard`, `aerobeat-input-mediapipe-native`, `aerobeat-input-mediapipe-python`, `aerobeat-input-mouse`, `aerobeat-input-touch`, `aerobeat-input-xr`, `aerobeat-template-assembly`, `aerobeat-template-asset`, `aerobeat-template-avatar`, `aerobeat-template-cosmetic`, `aerobeat-template-environment`, `aerobeat-template-feature`, `aerobeat-template-input`, `aerobeat-template-skin`, `aerobeat-template-tool`, `aerobeat-template-ui-kit`, `aerobeat-template-ui-shell`, `aerobeat-tool-api`, `aerobeat-tool-settings`, `aerobeat-ui-core`, `aerobeat-ui-kit-community`, `aerobeat-ui-shell-desktop-community`, `aerobeat-ui-shell-mobile-community`, `aerobeat-ui-shell-web-community`, `aerobeat-ui-shell-xr-community`, and `.github`. Present locally: `aerobeat-core`, `aerobeat-ui-core`, `aerobeat-docs`. Missing locally: `aerobeat-input-core`, `aerobeat-feature-core`, `aerobeat-content-core`, `aerobeat-asset-core`, `aerobeat-tool-core`. Current remotes: `aerobeat-core -> git@github.com:AeroBeat-Workouts/aerobeat-core.git`; `aerobeat-ui-core -> git@github.com:AeroBeat-Workouts/aerobeat-ui-core.git`; `aerobeat-docs -> git@github.com:AeroBeat-Workouts/aerobeat-docs.git`.

---

### Task 2: Update docs to the new repo names and links

**Bead ID:** `aerobeat-docs-o27`  
**SubAgent:** `primary`  
**References:** `REF-01`, `REF-02`, `REF-03`, `REF-05`, `REF-06`, `REF-07`, `REF-08`, `REF-09`, `REF-10`  
**Prompt:** Replace stale `aerobeat-core` references with `aerobeat-input-core` where appropriate, update repo URLs to the new canonical URLs, and ensure docs that describe dependencies/core lanes reflect the current six-core model consistently.

**Folders Created/Deleted/Modified:**
- `docs/`
- `templates/`
- `scripts/`

**Files Created/Deleted/Modified:**
- `publish.yml`
- `scripts/create_placeholders.py`
- `docs/index.md`
- `docs/guides/contributing_workflow.md`
- `docs/guides/feature_development.md`
- `docs/api/core/index.md`
- `docs/architecture/godotenv-convention-contract.md`
- `docs/architecture/package-dependency-research.md`
- `docs/architecture/godot-version-audit-2026-04-18.md`
- `docs/architecture/godotenv-migration-audit.md`
- `docs/architecture/testing.md`
- `docs/architecture/godotenv-phase-2-pilot-boxing-packet-2026-04-18.md`
- `docs/architecture/godotenv-phase-1-execution-packet.md`
- `docs/architecture/ugc_modding.md`
- `docs/architecture/ui-ux.md`
- `docs/architecture/overview.md`
- `docs/architecture/workflow.md`
- `docs/licensing/engineers.md`
- `docs/licensing/index.md`
- `templates/feature/README.md`
- `templates/feature/setup_dev.py`
- `templates/assembly/README.md`
- `templates/assembly/setup_dev.py`
- `templates/cosmetics/README.md`
- `templates/cosmetics/setup_dev.py`
- `templates/input/README.md`
- `templates/input/setup_dev.py`
- `templates/ui-shell/README.md`
- `templates/ui-shell/setup_dev.py`
- `templates/tool/README.md`
- `templates/tool/setup_dev.py`
- `templates/environments/README.md`
- `templates/environments/setup_dev.py`
- `templates/avatars/README.md`
- `templates/avatars/setup_dev.py`
- `templates/skins/README.md`
- `templates/skins/setup_dev.py`
- `templates/asset/setup_dev.py`
- `templates/ui-kit/setup_dev.py`

**Status:** ✅ Complete

**Results:** Normalized the live docs/template/tooling surfaces that were still treating `aerobeat-core` as a current canonical repo. Repo-link/tooling updates now point the generated core API docs and placeholder content at `aerobeat-input-core` (`REF-05`). Contributor-facing docs now describe the lane-based six-core model instead of a hub-and-spoke `aerobeat-core` world, with feature guidance updated to reference `aerobeat-feature-core` and testing/licensing pages updated to enumerate the modern core lanes (`REF-01`, `REF-02`, `REF-03`). Template READMEs and `setup_dev.py` files were normalized by repo category so they pull the correct lane core(s): input -> `aerobeat-input-core`; feature -> `aerobeat-feature-core` + `aerobeat-content-core`; tool -> `aerobeat-tool-core`; asset/avatar/cosmetic/environment/skin -> `aerobeat-asset-core`; UI kit/shell -> `aerobeat-ui-core` with adjacent-core wording only where appropriate; assembly -> six-core/as-needed dependency wording instead of a universal core dependency (`REF-01`, `REF-02`). Historical audit/packet docs were kept truthful but now carry explicit transition notes so remaining `aerobeat-core` mentions are clearly framed as pre-rename/historical references rather than current guidance.

---

### Task 3: Rename local checkout and clone missing core repos

**Bead ID:** `aerobeat-docs-4pq`  
**SubAgent:** `primary`  
**References:** `REF-04`, `REF-05`, `REF-06`, `REF-07`, `REF-08`, `REF-09`, `REF-10`  
**Prompt:** In `/home/derrick/.openclaw/workspace/projects/aerobeat`, rename the existing local `aerobeat-core` checkout to `aerobeat-input-core` if needed, verify its remote matches the renamed repo, and clone any missing new core repos so the local workspace mirrors the documented architecture.

**Folders Created/Deleted/Modified:**
- `/home/derrick/.openclaw/workspace/projects/aerobeat/`

**Files Created/Deleted/Modified:**
- Repo metadata and working trees for the local core repos

**Status:** ✅ Complete

**Results:** Completed in `REF-04`. Renamed the existing local `aerobeat-core` checkout directory to `aerobeat-input-core` and updated its `origin` remote from `git@github.com:AeroBeat-Workouts/aerobeat-core.git` to `git@github.com:AeroBeat-Workouts/aerobeat-input-core.git` so the local checkout name and remote now match the new canonical input-core repo (`REF-05`). Cloned the four missing core repos into the workspace: `aerobeat-feature-core` (`REF-06`), `aerobeat-content-core` (`REF-07`), `aerobeat-asset-core` (`REF-08`), and `aerobeat-tool-core` (`REF-10`). Verified final local six-core repo set and `origin` remotes as: `aerobeat-input-core -> git@github.com:AeroBeat-Workouts/aerobeat-input-core.git`, `aerobeat-ui-core -> git@github.com:AeroBeat-Workouts/aerobeat-ui-core.git`, `aerobeat-feature-core -> git@github.com:AeroBeat-Workouts/aerobeat-feature-core.git`, `aerobeat-content-core -> git@github.com:AeroBeat-Workouts/aerobeat-content-core.git`, `aerobeat-asset-core -> git@github.com:AeroBeat-Workouts/aerobeat-asset-core.git`, and `aerobeat-tool-core -> git@github.com:AeroBeat-Workouts/aerobeat-tool-core.git`. No git history was rewritten; only the folder rename, remote retarget, and new clones were performed.

---

### Task 4: Audit docs links and local repo sync

**Bead ID:** `aerobeat-docs-6pp`  
**SubAgent:** `auditor`  
**References:** `REF-01`, `REF-04`, `REF-05`, `REF-06`, `REF-07`, `REF-08`, `REF-09`, `REF-10`  
**Prompt:** Independently verify that the docs now reference the correct repo names/links and that the local `/aerobeat/` workspace contains the expected core repos with correct names/remotes. Report any remaining stale links or local mismatches precisely.

**Folders Created/Deleted/Modified:**
- `docs/`
- `/home/derrick/.openclaw/workspace/projects/aerobeat/`

**Files Created/Deleted/Modified:**
- None expected from audit beyond plan updates

**Status:** ✅ Complete

**Results:** Independent audit passed. Checked live docs, template READMEs/setup scripts, publishing/tooling surfaces, and the local AeroBeat workspace against `REF-01` and `REF-04` through `REF-10`. Verified the six-core architecture is documented coherently in `docs/architecture/{repository-map.md,topology.md,overview.md,workflow.md}` and that contributor-facing entry points (`docs/index.md`, `docs/guides/contributing_workflow.md`, `docs/guides/feature_development.md`, `docs/api/core/index.md`, `docs/licensing/index.md`) now point readers at the lane-specific cores instead of treating `aerobeat-core` as the current canonical hub. Template surfaces checked clean as well (`templates/{feature,assembly,cosmetics,input,ui-shell,tool,environments,avatars,skins}/README.md` plus setup scripts including `templates/{feature,assembly,asset,avatars,cosmetics,environments,input,skins,tool,ui-kit,ui-shell}/setup_dev.py`), and publishing/tooling now targets `aerobeat-input-core` / the appropriate lane repos (`publish.yml`, `scripts/create_placeholders.py`). Remaining `aerobeat-core` mentions are confined to explicitly transition-labeled historical audit/packet docs, which now frame the old name as historical context rather than live guidance; one such historical packet still contains the old SSH repo URL (`docs/architecture/godotenv-phase-2-pilot-boxing-packet-2026-04-18.md`), but it is not presented as current canonical guidance, so this is a documented non-blocking historical exception rather than an audit failure. Local workspace audit in `REF-04` also passed: present folders and origin remotes are `aerobeat-input-core -> git@github.com:AeroBeat-Workouts/aerobeat-input-core.git`, `aerobeat-feature-core -> git@github.com:AeroBeat-Workouts/aerobeat-feature-core.git`, `aerobeat-content-core -> git@github.com:AeroBeat-Workouts/aerobeat-content-core.git`, `aerobeat-asset-core -> git@github.com:AeroBeat-Workouts/aerobeat-asset-core.git`, `aerobeat-ui-core -> git@github.com:AeroBeat-Workouts/aerobeat-ui-core.git`, and `aerobeat-tool-core -> git@github.com:AeroBeat-Workouts/aerobeat-tool-core.git`. No local naming or remote mismatches found.

---

## Final Results

**Status:** ✅ Complete

**What We Built:** Synced the docs and local AeroBeat workspace to the six-core model by replacing live canonical `aerobeat-core` guidance with lane-specific core repo guidance, updating repo links/tooling surfaces, renaming the local input-core checkout, and cloning the missing core repos so the local workspace now matches the documented architecture.

**Reference Check:** `REF-01` satisfied by the final architecture/workflow/docs audit; `REF-04` through `REF-10` satisfied by direct verification of local folder names and `origin` remotes. Historical packet/audit docs still contain some transition-era `aerobeat-core` references, but they are explicitly labeled as historical context rather than live canonical guidance, so no blocking mismatch remains.

**Commits:**
- `680bb919` - `docs: sync templates and links to six-core repos`

**Lessons Learned:** When repo renames land alongside architecture splits, the final audit needs to check not just the obvious live docs but also generator/template surfaces and the real local workspace remotes; otherwise stale canonical guidance lingers in places contributors actually copy from.

---

*Completed on 2026-04-20*
