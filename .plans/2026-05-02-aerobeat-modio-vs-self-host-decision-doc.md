# AeroBeat mod.io vs Self-Hosted UGC Decision Doc

**Date:** 2026-05-02  
**Status:** In Progress  
**Agent:** Chip 🐱‍💻

---

## Goal

Create a source-of-truth AeroBeat documentation page that evaluates mod.io versus self-hosted UGC distribution, explains the tradeoffs in plain engineering terms, and records a recommended near-term direction suitable for Steam/mobile release planning.

---

## Overview

Derrick wants a concrete written decision aid for the AeroBeat docs repo so the team can reason about whether to use mod.io as the outer UGC/distribution shell instead of fully self-hosting community content. The key framing is not just storage or convenience; it is platform safety, moderation surface area, auth/account complexity, and how much of the risky UGC perimeter AeroBeat should own directly during the early release phase.

This plan keeps the core AeroBeat content/import model first-party while evaluating whether distribution, auth integration, and community-facing UGC workflows should be buffered through mod.io. The deliverable should be a docs page that is useful both as an internal decision memo and as future architecture guidance, without coupling AeroBeat's durable package semantics to any one vendor.

---

## REFERENCES

| ID | Description | Path |
| --- | --- | --- |
| `REF-01` | Active plan for this decision doc | `.plans/2026-05-02-aerobeat-modio-vs-self-host-decision-doc.md` |
| `REF-02` | Existing UGC/modding architecture doc | `docs/architecture/ugc_modding.md` |
| `REF-03` | Existing backend API security framing | `docs/architecture/backend_api.md` |
| `REF-04` | Existing cloud baker validation framing | `docs/architecture/cloud_baker.md` |
| `REF-05` | Existing release/store guidance | `docs/gdd/releases/digital-stores-and-arcades.md` |
| `REF-06` | New target document | `docs/architecture/ugc-distribution-strategy.md` |
| `REF-07` | Docs navigation file | `mkdocs.yml` |

---

## Tasks

### Task 1: Research and structure the decision memo

**Bead ID:** `aerobeat-docs-9i83`  
**SubAgent:** `primary`  
**Role:** `research`  
**References:** `REF-01`, `REF-02`, `REF-03`, `REF-04`, `REF-05`, `REF-06`  
**Prompt:** In `aerobeat-docs`, claim bead `aerobeat-docs-9i83` on start. Research how a mod.io-based UGC approach changes the tradeoffs versus fully self-hosting for AeroBeat, especially around Steam/mobile readiness, auth/account burden, moderation/takedown surface, package safety, and vendor lock-in. Produce an execution-ready outline for a docs page at `docs/architecture/ugc-distribution-strategy.md`. Do not edit files. Close the bead with a concise notes summary when done.

**Folders Created/Deleted/Modified:**
- `.plans/`

**Files Created/Deleted/Modified:**
- `.plans/2026-05-02-aerobeat-modio-vs-self-host-decision-doc.md`

**Status:** ✅ Complete

**Results:** Research pass completed. Recommended thesis: AeroBeat should keep package contract, validation, bake/signing authority, and runtime trust boundaries first-party while treating any third-party UGC provider as an optional distribution/community shell rather than the source of truth. The outline emphasized Steam/mobile implications, reduced auth/community-ops burden, shared moderation responsibility, explicit distinction between distribution trust and runtime trust, and a phased hybrid approach that preserves vendor-neutral package semantics.

---

### Task 2: Author the docs page and wire it into nav

**Bead ID:** `aerobeat-docs-k9jq`  
**SubAgent:** `primary`  
**Role:** `coder`  
**References:** `REF-01`, `REF-02`, `REF-03`, `REF-04`, `REF-05`, `REF-06`, `REF-07`  
**Prompt:** In `aerobeat-docs`, claim bead `aerobeat-docs-k9jq` on start. Author `docs/architecture/ugc-distribution-strategy.md` and update `mkdocs.yml` so the new page appears in the Architecture section. The doc should cover: problem framing, mod.io benefits, mod.io limitations, self-hosting benefits, self-hosting costs, auth/backend scope, Steam/mobile implications, recommended AeroBeat phased approach, and safety red lines for package ingestion. Keep the recommendation opinionated but vendor-decoupled. Run `mkdocs build --clean` before handoff. Commit and push by default unless blocked. Close the bead with validation details.

**Folders Created/Deleted/Modified:**
- `docs/architecture/`

**Files Created/Deleted/Modified:**
- `docs/architecture/ugc-distribution-strategy.md`
- `mkdocs.yml`
- `.plans/2026-05-02-aerobeat-modio-vs-self-host-decision-doc.md`

**Status:** ✅ Complete

**Results:** Authored `docs/architecture/ugc-distribution-strategy.md` with a vendor-decoupled recommendation that keeps AeroBeat package semantics, validation, bake/signing authority, and runtime trust first-party while treating mod.io-style services as optional distribution/community shells. Updated `mkdocs.yml` so the page appears in the Architecture nav. Validation succeeded with `source venv/bin/activate && mkdocs build --clean`; `mkdocs` was not on PATH directly, so the repo virtualenv was used. MkDocs reported only pre-existing warnings about pages not included in nav elsewhere in the repo.

---

### Task 3: QA the new decision doc in rendered/docs form

**Bead ID:** `aerobeat-docs-uub5`  
**SubAgent:** `primary`  
**Role:** `qa`  
**References:** `REF-01`, `REF-05`, `REF-06`, `REF-07`  
**Prompt:** In `aerobeat-docs`, claim bead `aerobeat-docs-uub5` on start. Independently verify the new UGC distribution strategy doc for clarity, consistency with current AeroBeat scope, and fit with the docs navigation/build. Confirm it clearly explains the mod.io vs self-host tradeoff, does not overclaim store compliance, and preserves the principle that AeroBeat owns package validation even if a third party handles distribution. Run any repo-local validation needed. Close the bead with pass/fail findings.

**Folders Created/Deleted/Modified:**
- `docs/architecture/`

**Files Created/Deleted/Modified:**
- `docs/architecture/ugc-distribution-strategy.md`
- `mkdocs.yml`
- `.plans/2026-05-02-aerobeat-modio-vs-self-host-decision-doc.md`

**Status:** ⏳ Pending

**Results:** Pending.

---

### Task 4: Audit the final doc as a truth-check

**Bead ID:** `aerobeat-docs-28ux`  
**SubAgent:** `primary`  
**Role:** `auditor`  
**References:** `REF-01`, `REF-02`, `REF-03`, `REF-04`, `REF-05`, `REF-06`, `REF-07`  
**Prompt:** In `aerobeat-docs`, claim bead `aerobeat-docs-28ux` on start. Perform an independent truth-check of the final mod.io vs self-hosted UGC decision doc against the plan, adjacent architecture docs, and the intended AeroBeat release framing. Confirm the recommendation is technically coherent, scoped for current AeroBeat priorities, and not silently coupling core content semantics to mod.io. Close the bead only if the work is actually done; otherwise document the gaps.

**Folders Created/Deleted/Modified:**
- `docs/architecture/`

**Files Created/Deleted/Modified:**
- `docs/architecture/ugc-distribution-strategy.md`
- `mkdocs.yml`
- `.plans/2026-05-02-aerobeat-modio-vs-self-host-decision-doc.md`

**Status:** ⏳ Pending

**Results:** Pending.

---

## Final Results

**Status:** ⏳ In Progress

**What We Built:** Coder pass completed: added `docs/architecture/ugc-distribution-strategy.md` and linked it into the Architecture nav in `mkdocs.yml`. The new page explains why the decision exists, separates distribution trust from runtime trust, compares third-party-shell and fully self-hosted approaches, covers auth/moderation/storefront implications, and recommends a phased hybrid strategy that preserves vendor-neutral package semantics.

**Reference Check:** Coder pass aligns with `REF-02`, `REF-03`, and `REF-04` by keeping package validation, bake/signing, and runtime trust first-party; aligns with `REF-05` by keeping Steam/mobile/store language soft and planning-oriented rather than claiming compliance guarantees.

**Commits:**
- `1729818` - docs: add UGC distribution strategy

**Lessons Learned:** Repo-local validation depends on the checked-in virtualenv here; `mkdocs` was unavailable on PATH, but the required build succeeded from `venv`.

---

*Completed on 2026-05-02*
