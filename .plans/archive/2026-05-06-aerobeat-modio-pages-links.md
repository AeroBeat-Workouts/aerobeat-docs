# AeroBeat mod.io Page Links in UGC Docs

**Date:** 2026-05-06  
**Status:** Stale  
**Agent:** Chip 🐱‍💻

---

## Goal

Document the canonical AeroBeat mod.io test and live page URLs alongside the existing UGC/mod.io architecture docs so the team has a durable reference to both storefront surfaces.

---

## Overview

AeroBeat now has two concrete mod.io surfaces worth tracking in docs: the sandbox game page on `test.mod.io` and the live/public-path page on `mod.io`. Linking to those pages is safe because access still depends on mod.io-side visibility/team membership rather than the docs themselves leaking credentials or admin controls.

This slice should stay small and explicit. We are not documenting secrets or operational keys here; we are only adding durable URLs near the existing UGC/mod.io strategy material so future development, QA, and content-ops work can quickly find the right storefront surfaces.

The most likely fit is the existing UGC/mod.io architecture cluster, especially the docs that already frame mod.io as AeroBeat's current outer shell. The final wording should make it obvious which page is the sandbox/dev lane and which page is the live lane.

---

## REFERENCES

| ID | Description | Path |
| --- | --- | --- |
| `REF-01` | UGC distribution strategy | `docs/architecture/ugc-distribution-strategy.md` |
| `REF-02` | UGC hybrid integration architecture | `docs/architecture/ugc-hybrid-integration-architecture.md` |
| `REF-03` | UGC API manager topology | `docs/architecture/ugc-api-manager-topology.md` |
| `REF-04` | mod.io tag mapping | `docs/architecture/modio-tag-mapping.md` |
| `REF-05` | Docs navigation | `mkdocs.yml` |

---

## Tasks

### Task 1: Add the canonical AeroBeat mod.io test/live page links to docs

**Bead ID:** `aerobeat-docs-a8n4`  
**SubAgent:** `primary`  
**Role:** `coder`  
**References:** `REF-01` through `REF-05`  
**Prompt:** In `aerobeat-docs`, claim bead `aerobeat-docs-a8n4` on start. Add the canonical AeroBeat mod.io page URLs to the most appropriate existing UGC/mod.io documentation page(s), making it clear which URL is the sandbox/test server page and which is the live page. Keep the change small, safe, and documentation-only. Run `source venv/bin/activate && mkdocs build --clean`, update this active plan with exact files/results, commit and push by default, then close the bead.

**Folders Created/Deleted/Modified:**
- `.plans/`
- `docs/architecture/`

**Files Created/Deleted/Modified:**
- `.plans/2026-05-06-aerobeat-modio-pages-links.md`
- `docs/architecture/ugc-distribution-strategy.md`
- `docs/architecture/ugc-hybrid-integration-architecture.md`

**Status:** ✅ Complete

**Results:** Added the canonical mod.io URLs to the two most relevant existing UGC/mod.io architecture docs: `REF-01` now lists the sandbox/test page and live page directly under the current chosen mod.io shell section, and `REF-02` now lists the same URLs near the architecture scope framing so the shell has a concrete provider reference. The wording explicitly labels `https://test.mod.io/g/aerobeat` as the sandbox/test page and `https://mod.io/g/aerobeat` as the live page. Validation: `source venv/bin/activate && mkdocs build --clean` completed successfully; MkDocs reported a third-party warning about future framework/plugin risk plus pre-existing nav omissions, but the docs build finished cleanly in 2.39 seconds. Commit: `0ad1919` (`docs: add AeroBeat mod.io page links`).

---

### Task 2: QA the docs link update

**Bead ID:** `aerobeat-docs-0u3k`  
**SubAgent:** `primary`  
**Role:** `qa`  
**References:** `REF-01` through `REF-05`  
**Prompt:** In `aerobeat-docs`, claim bead `aerobeat-docs-0u3k` on start. Independently verify that the new mod.io test/live links are placed in the right UGC docs context, accurately labeled, safe to publish, and that the docs build still passes. Make only minimum necessary fixes, rerun `source venv/bin/activate && mkdocs build --clean`, update the active plan with findings, and close the bead.

**Folders Created/Deleted/Modified:**
- `.plans/`
- docs paths only if a minimal fix is required

**Files Created/Deleted/Modified:**
- `.plans/2026-05-06-aerobeat-modio-pages-links.md`
- docs file(s) only if a minimal fix is required

**Status:** ⏳ Pending

**Results:** Pending.

---

### Task 3: Audit the docs link update

**Bead ID:** `aerobeat-docs-0ik4`  
**SubAgent:** `primary`  
**Role:** `auditor`  
**References:** `REF-01` through `REF-05`  
**Prompt:** In `aerobeat-docs`, claim bead `aerobeat-docs-0ik4` on start. Perform an independent truth-check of the new mod.io test/live link documentation against the active plan and adjacent UGC/mod.io docs. Confirm the final docs remain technically coherent, clearly labeled, and safe. Rerun `source venv/bin/activate && mkdocs build --clean`, update the active plan with the audit result, and close the bead only if the work is actually done.

**Folders Created/Deleted/Modified:**
- `.plans/`

**Files Created/Deleted/Modified:**
- `.plans/2026-05-06-aerobeat-modio-pages-links.md`
- docs file(s) only if a minimum necessary audit fix is required

**Status:** ⏳ Pending

**Results:** Pending.

---

## Final Results

**Status:** ⏳ Pending

**What We Built:** Pending.

**Reference Check:** Pending.

**Commits:**
- None yet.

**Lessons Learned:** Pending.

---

*Drafted on 2026-05-06*