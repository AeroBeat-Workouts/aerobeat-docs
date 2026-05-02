# AeroBeat mod.io Path Lock-In and API Manager Topology

**Date:** 2026-05-02  
**Status:** In Progress  
**Agent:** Chip 🐱‍💻

---

## Goal

Lock mod.io in as AeroBeat's current outer UGC distribution/community path while preserving AeroBeat's inner package shape, validation, bake/signing, and runtime trust model; then define the repo topology for an AeroBeat-owned API manager layer so product repos never call mod.io REST directly.

---

## Overview

Derrick approved the research direction: mod.io should be the current outer shell for AeroBeat's UGC/community/distribution surface, but the inner AeroBeat content model must remain first-party so authoring, validation, bake/signing, quarantine, and runtime allow/deny behavior keep working exactly as designed.

That means the next work should happen in two slices. First, update `aerobeat-docs` so the documentation stops speaking in hypotheticals and instead records mod.io as the current path, with clear wording that AeroBeat still owns package truth and runtime trust. Second, define the API/repo topology for how the engine talks to UGC services: AeroBeat repos should talk to an AeroBeat-owned API manager singleton, not to mod.io REST calls directly.

My current opinion on the repo shape is:
- **Do not let feature/input/assembly repos call mod.io directly.**
- **Prefer the AeroBeat-facing singleton/API-manager repo to live in the existing `aerobeat-tool-api` lane unless audit shows that lane is the wrong semantic home.**
- **Likely add a provider adapter repo for mod.io-specific REST/auth mapping** rather than mixing vendor-specific code into every consumer.
- **Only add more repos if workflow orchestration truly needs it**; avoid unnecessary fragmentation before the interfaces are documented.

---

## REFERENCES

| ID | Description | Path |
| --- | --- | --- |
| `REF-01` | Active plan for this mod.io lock-in and API topology work | `.plans/2026-05-02-aerobeat-modio-path-and-api-manager-topology.md` |
| `REF-02` | Current UGC distribution strategy | `docs/architecture/ugc-distribution-strategy.md` |
| `REF-03` | Current executive summary | `docs/architecture/ugc-distribution-executive-summary.md` |
| `REF-04` | Current hybrid integration architecture | `docs/architecture/ugc-hybrid-integration-architecture.md` |
| `REF-05` | Current repository map | `docs/architecture/repository-map.md` |
| `REF-06` | Existing UGC/modding architecture | `docs/architecture/ugc_modding.md` |
| `REF-07` | Existing cloud baker architecture | `docs/architecture/cloud_baker.md` |
| `REF-08` | Existing backend API framing | `docs/architecture/backend_api.md` |
| `REF-09` | Existing tool/API repo lane | `../aerobeat-tool-api` |

---

## Tasks

### Task 1: Update docs to lock mod.io as the current outer-shell path

**Bead ID:** `aerobeat-docs-2vpm`  
**SubAgent:** `primary`  
**Role:** `coder`  
**References:** `REF-01`, `REF-02`, `REF-03`, `REF-04`, `REF-05`, `REF-06`, `REF-07`, `REF-08`  
**Prompt:** In `aerobeat-docs`, claim the assigned bead on start. Update the existing UGC strategy docs so they no longer present mod.io as merely one possible option; instead record it as AeroBeat's current chosen outer-shell path. Preserve the non-negotiable rule that AeroBeat keeps package schema/IDs, validation, bake/signing authority, quarantine, and runtime trust first-party. Keep store/mobile language cautious. Update any adjacent docs that need wording alignment, run `mkdocs build --clean`, update the active plan, commit/push by default, and close the bead with validation details.

**Folders Created/Deleted/Modified:**
- `docs/architecture/`

**Files Created/Deleted/Modified:**
- `docs/architecture/ugc-distribution-strategy.md`
- `docs/architecture/ugc-distribution-executive-summary.md`
- `docs/architecture/ugc-hybrid-integration-architecture.md`
- `docs/architecture/ugc_modding.md`
- `docs/architecture/cloud_baker.md` (reviewed for alignment; no text change needed)
- `docs/architecture/backend_api.md`
- `docs/architecture/repository-map.md`
- `.plans/2026-05-02-aerobeat-modio-path-and-api-manager-topology.md`

**Status:** ✅ Complete

**Results:** Updated the strategy, executive summary, and hybrid architecture docs so mod.io is no longer framed as merely one possible option; it now reads as AeroBeat's current chosen outer community/distribution shell while staying explicitly replaceable. Also aligned `ugc_modding.md` and `backend_api.md` so older docs no longer imply direct-to-AeroBeat-server uploads or vendor-owned runtime truth, and tightened `repository-map.md` to steer API-facing integration through `aerobeat-tool-api` instead of direct product-repo vendor coupling. Preserved the non-negotiable first-party trust boundary throughout: AeroBeat-owned package schema/IDs, validation, bake/signing authority, quarantine/revocation, and runtime allow/deny remain authoritative. Store/mobile wording remained cautious. Validation passed with `source venv/bin/activate && mkdocs build --clean` on 2026-05-02; build emitted only pre-existing nav omissions plus the existing MkDocs ecosystem warning. Committed Task 1 as `4964e47` (`Lock mod.io as current outer UGC shell`).

---

### Task 2: Define the AeroBeat API manager and repo topology

**Bead ID:** `aerobeat-docs-h4nv`  
**SubAgent:** `primary`  
**Role:** `research`  
**References:** `REF-01`, `REF-04`, `REF-05`, `REF-08`, `REF-09`  
**Prompt:** In `aerobeat-docs`, claim the assigned bead on start. Audit the existing repo lanes and propose the cleanest topology for AeroBeat's UGC API stack now that mod.io is the chosen outer shell. Specifically evaluate whether `aerobeat-tool-api` should become the Godot-imported API manager singleton repo, what provider-specific mod.io adapter repo(s) are needed, and whether any separate workflow/domain repo is justified. Produce an execution-ready recommendation with concrete repo names, responsibilities, dependency directions, and anti-patterns to avoid (especially direct mod.io calls from product repos).

**Folders Created/Deleted/Modified:**
- `docs/architecture/`
- `.plans/`

**Files Created/Deleted/Modified:**
- `docs/architecture/ugc-api-manager-topology.md` (new)
- `docs/architecture/repository-map.md`
- `docs/architecture/backend_api.md`
- `mkdocs.yml`
- `.plans/2026-05-02-aerobeat-modio-path-and-api-manager-topology.md`

**Status:** ✅ Complete

**Results:** Added `docs/architecture/ugc-api-manager-topology.md` as the execution-ready recommendation for the UGC API stack. The recommendation lands on `aerobeat-tool-api` as the Godot-imported API manager singleton repo, introduces `aerobeat-vendor-modio` as the one provider adapter repo actually justified now, rejects a separate workflow/domain repo as premature, defines strict dependency directions, and explicitly calls out direct mod.io usage from product repos as an anti-pattern. Also updated `repository-map.md` and `backend_api.md` so the routing guidance and API framing point at the same manager topology, and added the new architecture page to `mkdocs.yml`. Validation passed with `source venv/bin/activate && mkdocs build --clean` on 2026-05-02; build emitted only the pre-existing nav omissions plus the existing MkDocs ecosystem warning.

---

### Task 3: QA and audit the docs/topology decision

**Bead ID:** `aerobeat-docs-lpmx` (QA), `aerobeat-docs-otgy` (Auditor)  
**SubAgent:** `primary`  
**Role:** `qa` then `auditor`  
**References:** `REF-01` through `REF-09`  
**Prompt:** Independently verify that the mod.io lock-in wording and API manager repo-topology recommendation are consistent with AeroBeat's current product scope and architecture. Confirm the docs clearly state mod.io is the current outer path, that AeroBeat-owned package trust stays intact, and that the proposed repo split prevents direct vendor coupling from gameplay/product repos. Make only minimum necessary fixes, rerun validation, update the active plan, commit/push if changes were made, and close with clear pass/fail findings.

**Folders Created/Deleted/Modified:**
- `docs/architecture/`
- `.plans/`

**Files Created/Deleted/Modified:**
- impacted docs under `docs/architecture/`
- `.plans/2026-05-02-aerobeat-modio-path-and-api-manager-topology.md`

**Status:** ✅ Complete

**Results:** QA independently verified that the core docs now consistently present mod.io as AeroBeat's current outer community/distribution shell, preserve AeroBeat-owned package/trust authority, justify `aerobeat-tool-api` as the Godot-imported API manager lane, and keep `aerobeat-vendor-modio` clearly separated as the provider adapter seam. The main wording drift found was in `backend_api.md`, which still over-specified direct S3 upload language in a way that could be read as bypassing the chosen provider-shell framing; that was corrected with the minimum necessary wording so upload targets are now described as brokered direct-upload endpoints compatible with either object storage or provider-backed flows, while keeping AeroBeat IDs and trust records canonical. Re-ran `source venv/bin/activate && mkdocs build --clean`; build passed with only the pre-existing MkDocs ecosystem warning and pre-existing nav omissions. QA fix committed as `1b4fae5` (`Clarify brokered upload wording for mod.io path`). Auditor pass on 2026-05-02: independently re-checked `REF-01` through `REF-09` after the QA fix and found the wording/topology coherent end-to-end. mod.io is clearly documented as the current outer shell; AeroBeat still explicitly owns schema/IDs, validation, bake/signing, quarantine, and runtime trust; `aerobeat-tool-api` remains a technically coherent Godot-imported manager seam; `aerobeat-vendor-modio` stays clearly vendor-scoped; product/gameplay repos are not steered toward direct mod.io coupling; backend upload wording now matches the brokered outer-shell model; and the docs still align with camera-first Boxing + Flow on a PC community-first path. Navigation/build remain sensible with the new topology page in `mkdocs.yml`.

---

## Final Results

**Status:** ✅ Complete

**What We Built:** The live UGC docs now treat mod.io as AeroBeat's current outer-shell community/distribution path while keeping all package/trust authority first-party, and the new topology doc records the recommended repo split: `aerobeat-tool-api` as the Godot-imported singleton/API-manager lane, `aerobeat-vendor-modio` as the first provider adapter repo, and no extra workflow/domain repo yet. QA tightened the remaining backend wording mismatch so the upload path description matches the mod.io-outer-shell decision without implying vendor-owned runtime truth, and the auditor pass confirmed the full doc set now reads coherently end-to-end.

**Reference Check:** Task 1 satisfied `REF-02` through `REF-08`. Task 2 satisfied `REF-04`, `REF-05`, `REF-08`, and `REF-09`, and updated `REF-01` with the actual topology recommendation and touched files. Task 3 verified `REF-01` through `REF-09`, with a minimum necessary fix in `REF-08` to keep the upload-flow wording aligned with the chosen mod.io path and AeroBeat-owned trust boundary, followed by an independent auditor pass confirming the mod.io outer-shell wording, AeroBeat-owned trust boundary, API-manager topology, provider-adapter seam, and current product-scope framing.

**Commits:**
- `4964e47` - Lock mod.io as current outer UGC shell
- `964ac49` - Document UGC API manager topology
- `1b4fae5` - Clarify brokered upload wording for mod.io path

**Lessons Learned:** The existing docs were already pointing toward `aerobeat-tool-api`; the missing pieces were to make that routing explicit, name the provider-adapter seam concretely, and avoid seemingly small upload-flow wording that accidentally implied a narrower backend shape than the chosen provider-shell architecture.

---

*Completed on 2026-05-02*
