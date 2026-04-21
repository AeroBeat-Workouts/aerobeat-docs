# AeroBeat LICENSE.md Normalization

**Date:** 2026-04-21
**Status:** Draft
**Agent:** Chip 🐱‍💻

---

## Goal

Normalize AeroBeat repo license filenames so repos use `LICENSE.md` consistently instead of a mix of `LICENSE` and `LICENSE.md`.

---

## Overview

AeroBeat templates already lean toward `LICENSE.md`, and recent architecture/docs work has also been using `LICENSE.md` as the convention. However, the repo family still appears to contain a mixture of `LICENSE` and `LICENSE.md`. That creates needless inconsistency in scaffolding, docs examples, and cross-repo hygiene.

This task belongs with the standards/docs lane first because the convention should be confirmed in the canonical docs and templates before any broad repo sweep changes are made. After that, the family-wide normalization can be executed in a controlled pass.

A quick inventory already suggests the sweep is smaller than expected: most AeroBeat repos already use `LICENSE.md`, and the only obvious mixed case in the current workspace scan is `aerobeat-ui-kit-community`, which contains both `LICENSE` and `LICENSE.md`. That means the work should likely focus on: (1) confirming there are no hidden exceptions, (2) removing any duplicate plain `LICENSE` files where an equivalent `LICENSE.md` already exists, and (3) tightening any docs/examples that still imply bare `LICENSE` instead of the canonical `LICENSE.md` convention.

---

## REFERENCES

| ID | Description | Path |
| --- | --- | --- |
| `REF-01` | AeroBeat workflow doc | `docs/architecture/workflow.md` |
| `REF-02` | Directory structure reference | `docs/architecture/repo-structure-reference.md` |
| `REF-03` | AeroBeat templates root | `templates/` |

---

## Tasks

### Task 1: Audit current license filename convention across AeroBeat repos

**Bead ID:** `aerobeat-docs-bd0`
**SubAgent:** `primary`
**Role:** `research`
**References:** `REF-01`, `REF-02`, `REF-03`
**Prompt:** Audit the AeroBeat repo family for `LICENSE` versus `LICENSE.md`, confirm the canonical intended convention from docs/templates, identify every repo that still has a plain `LICENSE` file, and recommend the exact migration scope and safety considerations.

**Folders Created/Deleted/Modified:**
- `.plans/`
- `docs/architecture/`
- `templates/`

**Files Created/Deleted/Modified:**
- `.plans/2026-04-21-license-md-normalization.md`

**Status:** ✅ Complete

**Results:** Completed a shell-backed inventory across `/home/derrick/.openclaw/workspace/projects/aerobeat` and found exactly one plain `LICENSE` file anywhere in the repo family: `aerobeat-ui-kit-community/LICENSE`. That repo also already contains `LICENSE.md`, and every other AeroBeat repo root in the workspace is already normalized to `LICENSE.md` only. The plain `LICENSE` is **not** byte-identical to `LICENSE.md`: `LICENSE.md` matches the canonical template file at `aerobeat-docs/templates/ui-kit/LICENSE.md`, while the plain `LICENSE` is an older/different MPL 2.0 text variant. Canonical convention evidence: the active template files present in `templates/` use `LICENSE.md` (for example `_common/`, `assembly/`, `feature/`, `input/`, `tool/`, `ui-kit/`, and `ui-shell/`), the recent architecture packet lists `LICENSE.md` as a tracked repo-root file, and `scripts/sync_templates.ps1` explicitly removes a duplicate plain `LICENSE` when both `LICENSE` and `LICENSE.md` exist. Safety caveat: some docs/template prose still mention bare `LICENSE` (`docs/architecture/content-repo-shapes.md`, `templates/README.md`, and `templates/asset/README.md`), so the coder pass should treat those as stale references to update if they are meant to describe the canonical convention. Recommended migration scope: normalize `aerobeat-ui-kit-community` first, but do not blindly delete the plain `LICENSE` without deciding whether to preserve its older MPL wording somewhere in history or replace it deliberately with the template-backed `LICENSE.md` as the source of truth.

---

### Task 2: Normalize remaining plain `LICENSE` files to `LICENSE.md`

**Bead ID:** `aerobeat-docs-h9g`
**SubAgent:** `primary`
**Role:** `coder`
**References:** `REF-01`, `REF-02`, `REF-03`
**Prompt:** For every remaining AeroBeat repo that still uses a plain `LICENSE` file while an equivalent `LICENSE.md` convention is intended, convert it safely to the equivalent `LICENSE.md` form, preserve content, and update any repo-local references if needed.

**Folders Created/Deleted/Modified:**
- `docs/architecture/`
- `templates/`
- `../aerobeat-ui-kit-community/`

**Files Created/Deleted/Modified:**
- `docs/architecture/content-repo-shapes.md`
- `templates/README.md`
- `templates/asset/README.md`
- `../aerobeat-ui-kit-community/LICENSE`

**Status:** ✅ Complete

**Results:** Removed the last remaining plain `LICENSE` file from the AeroBeat workspace at `../aerobeat-ui-kit-community/LICENSE` after confirming that repo already had a canonical `LICENSE.md`, that `LICENSE.md` matched the `templates/ui-kit/LICENSE.md` template, and that the ui-kit repo had no internal references depending on the bare filename. Updated the stale docs/template references identified by the audit so they now point to `LICENSE.md`: the two repo-tree examples in `docs/architecture/content-repo-shapes.md`, the Asset row in `templates/README.md`, and the license bullet in `templates/asset/README.md`. Post-change inventory across `/home/derrick/.openclaw/workspace/projects/aerobeat` shows no remaining plain `LICENSE` files; only `LICENSE.md` files remain. Validation run: refreshed license inventory, checked repo diffs with `git diff --stat`, and ran `git diff --check` in both `aerobeat-docs` and `aerobeat-ui-kit-community`. The removed plain `LICENSE` had older MPL 2.0 wording than the canonical template-backed `LICENSE.md`, so the final state intentionally standardizes on `LICENSE.md` as the source of truth rather than preserving both variants in the working tree.

---

### Task 3: Audit the normalization sweep and document the final convention

**Bead ID:** `aerobeat-docs-kp8`
**SubAgent:** `primary`
**Role:** `auditor`
**References:** `REF-01`, `REF-02`, `REF-03`
**Prompt:** Independently verify that the AeroBeat repo family consistently uses `LICENSE.md`, that no unintended content changes were introduced during the rename sweep, and that the canonical docs/templates match the final convention.

**Folders Created/Deleted/Modified:**
- `.plans/`
- AeroBeat repo roots as needed
- `docs/architecture/`

**Files Created/Deleted/Modified:**
- `.plans/2026-04-21-license-md-normalization.md`

**Status:** ✅ Complete

**Results:** Independent audit passed. Re-ran a workspace-wide inventory with `find /home/derrick/.openclaw/workspace/projects/aerobeat -type f -name LICENSE` and `-name LICENSE.md` and confirmed there are now zero plain `LICENSE` files anywhere under the AeroBeat workspace while all expected repo-root/template `LICENSE.md` files remain present. Reviewed the touched docs/template files and confirmed they now consistently point to `LICENSE.md`: `docs/architecture/content-repo-shapes.md` shows `LICENSE.md` in both repo-tree examples, `templates/README.md` now lists `LICENSE.md` for the Asset template, and `templates/asset/README.md` now documents `LICENSE.md` in the structure section. Audited `aerobeat-ui-kit-community` directly: `LICENSE.md` is still present, byte-identical to `aerobeat-docs/templates/ui-kit/LICENSE.md`, the only repo-local change is deletion of the duplicate plain `LICENSE`, and `git show HEAD:LICENSE` confirms the removed file was an older MPL 2.0 wording/format variant rather than unique project-specific content. Validation findings: `git diff --check` is clean in both `aerobeat-docs` and `aerobeat-ui-kit-community`; `git diff --stat` in `aerobeat-ui-kit-community` shows only `D LICENSE`; the touched docs/template refs are internally consistent; and the audited scope shows no stale bare-`LICENSE` references beyond incidental mentions inside legal license text itself. Caveat noted for orchestrator context: `aerobeat-docs` also has unrelated in-progress doc edits outside this sweep, so the audit conclusion here is scoped to the license-normalization files and inventory requested for this bead.

---

## Final Results

**Status:** ✅ Complete

**What We Built:** Verified that the AeroBeat workspace license convention is now consistently `LICENSE.md`, that the final plain `LICENSE` duplication in `aerobeat-ui-kit-community` was removed intentionally, and that the related docs/templates in the audited scope now point to `LICENSE.md` consistently.

**Reference Check:** `REF-01`, `REF-02`, and `REF-03` are satisfied within the audited scope. The repo-shape docs/templates align with the `LICENSE.md` convention, and the ui-kit repo normalization matches the template-backed MPL source of truth.

**Commits:**
- Pending in working tree; no commit was created as part of this audit pass.

**Lessons Learned:** When normalizing filename conventions across a repo family, re-check both the file inventory and the human-facing docs/examples; stale prose references can outlive the filesystem cleanup even when the template files are already standardized.

---

*Planned on 2026-04-21*
