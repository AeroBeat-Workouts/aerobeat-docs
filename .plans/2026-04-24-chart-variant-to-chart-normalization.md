# AeroBeat Chart Variant → Chart Normalization

**Date:** 2026-04-24  
**Status:** Complete  
**Agent:** Chip 🐱‍💻

---

## Goal

Normalize the recently landed AeroBeat foundations from `Chart Variant` / `chart_variant` terminology to the simplified canonical `Chart` / `chart` terminology across docs, code, fixtures, tests, and validation surfaces.

---

## Overview

We already locked the naming direction to `Song -> Routine -> Chart -> Workout` and `chartId` / `chartName`, but the first scaffold pass still carries older `Chart Variant` wording in several repo surfaces. Before deeper implementation continues, we should cleanly align the freshly created foundations to the simpler naming so we do not build more code or docs on top of stale terminology.

This pass should start with an audit to find exactly where `Chart Variant` and related `chart_variant` naming still appear in the active AeroBeat repos. Then we should normalize the affected surfaces in the owning repos, verify that validation still passes, and run independent QA + audit to ensure the terminology is fully aligned without breaking the approved content/tool repo boundary.

---

## REFERENCES

| ID | Description | Path |
| --- | --- | --- |
| `REF-01` | Locked naming direction: `Song -> Routine -> Chart -> Workout` | `memory/2026-04-23.md` |
| `REF-02` | Locked naming decision for `chartId` / `chartName` replacing variant wording | `memory/2026-04-24-workout-schema.md` |
| `REF-03` | Day-one content/tool repo shape source of truth | `projects/aerobeat/aerobeat-docs/docs/architecture/content-repo-shapes.md` |
| `REF-04` | Latest scaffold + cleanup execution record | `projects/aerobeat/aerobeat-docs/.plans/2026-04-24-aerobeat-repo-audit-and-initial-scaffolding.md` |
| `REF-05` | Cleanup follow-up execution record | `projects/aerobeat/aerobeat-docs/.plans/2026-04-24-aerobeat-scaffold-cleanups-and-rundown.md` |

---

## Tasks

### Task 1: Audit remaining `Chart Variant` terminology

**Bead ID:** `aerobeat-docs-dd4`  
**SubAgent:** `primary` (for `research` role)  
**Role:** `research`  
**References:** `REF-01`, `REF-02`, `REF-03`  
**Prompt:** Claim the bead and audit the active AeroBeat repos for remaining `Chart Variant` / `chart_variant` terminology now that the naming direction is `Chart` / `chart`. Focus on `aerobeat-content-core`, `aerobeat-tool-content-authoring`, and `aerobeat-docs`. Summarize repo-by-repo occurrences, categorize which are code identifiers vs docs/user-facing text vs filenames, and recommend the minimal clean normalization scope required before more implementation continues. Do not make destructive changes. Close the bead when the audit summary is complete.

**Folders Created/Deleted/Modified:**
- `projects/aerobeat/aerobeat-content-core/`
- `projects/aerobeat/aerobeat-tool-content-authoring/`
- `projects/aerobeat/aerobeat-docs/`

**Files Created/Deleted/Modified:**
- none expected

**Status:** ✅ Complete

**Results:** Audit found the heaviest active terminology drift in `aerobeat-docs`, with substantial remaining `Chart Variant` wording across guides, glossary, architecture, workflow, overview, and index pages. `aerobeat-content-core` has a smaller but structurally important set of remnants in filenames, schema constants/ids, one preload/type reference, a comment, and fixture schema values. `aerobeat-tool-content-authoring` has remaining drift in README text, the `chart_variant_authoring_service.gd` filename, and schema-id references; `.testbed` mostly mirrors generated/downstream content and historical `.plans` / `.beads` records were explicitly left out of the active normalization scope. Recommended order: docs + primary source identifiers, then verification, without rewriting historical records.

---

### Task 2: Normalize `aerobeat-content-core` terminology to `Chart`

**Bead ID:** `aerobeat-docs-o4s`  
**SubAgent:** `primary` (for `coder` role)  
**Role:** `coder`  
**References:** `REF-01`, `REF-02`, `REF-03`  
**Prompt:** After the audit, claim the bead and normalize `aerobeat-content-core` from `Chart Variant` wording to canonical `Chart` wording in the minimal clean way. Update data types, interfaces, validators, fixtures, tests, README/docs, and filenames/identifiers as needed so the repo consistently uses the locked `Chart` terminology without breaking validation. Run relevant validation, commit/push by default, and close the bead with an exact summary.

**Folders Created/Deleted/Modified:**
- `projects/aerobeat/aerobeat-content-core/`

**Files Created/Deleted/Modified:**
- `data_types/chart_variant.gd` → `data_types/chart.gd`
- `globals/aero_content_schema.gd`
- `validators/content_package_validator.gd`
- `fixtures/package_minimal_boxing/charts/song-demo-boxing-medium.json`
- `fixtures/invalid_missing_song_ref/charts/song-demo-boxing-medium.json`
- `.plans/2026-04-23-aerobeat-content-core-first-implementation-slice.md`

**Status:** ✅ Complete

**Results:** Normalized `aerobeat-content-core` to canonical `Chart` terminology. The core data type file was renamed from `chart_variant.gd` to `chart.gd`, `class_name ChartVariant` became `Chart`, validator preload/type references were updated, and the schema constant/id changed from `CHART_VARIANT_V1` / `aerobeat.content.chart_variant.v1` to `CHART_V1` / `aerobeat.content.chart.v1`. Both chart fixture JSON files were updated to the new schema id. The coder also updated one repo-local historical plan file to use `Chart` wording. Validation passed via the full headless contract suite, and a repo-wide grep reported no remaining `Chart Variant` / `chart_variant` / old schema-id matches. Final coder commit: `01705a1`, pushed to `origin/main`, and bead `aerobeat-docs-o4s` was closed.

---

### Task 3: QA + audit `aerobeat-content-core` normalization

**Bead ID:** `aerobeat-docs-urz`  
**SubAgent:** `primary` (for `qa` then `auditor` roles)  
**Role:** `qa` then `auditor`  
**References:** `REF-01`, `REF-02`, `REF-03`  
**Prompt:** Verify and audit the `aerobeat-content-core` terminology normalization. Confirm the repo now consistently uses `Chart` wording where intended, that validation still passes, and that no stale `Chart Variant` terminology remains in the normalized surfaces except where deliberately retained and justified. Close the bead only if the normalization genuinely resolves the issue.

**Folders Created/Deleted/Modified:**
- `projects/aerobeat/aerobeat-content-core/`

**Files Created/Deleted/Modified:**
- none expected unless remediation is required

**Status:** ✅ Complete

**Results:** QA + audit passed. Verification confirmed `aerobeat-content-core` HEAD is commit `01705a1`, that active contract/code surfaces now consistently use `Chart`, and that the full headless contract suite still passes. The only remaining `chart variant` wording in this repo is inside one repo-local plan file as historical/explanatory prose. That edit was judged minor scope expansion but acceptable and non-blocking because it aligns local documentation with the canonical naming without meaningfully distorting history. Bead `aerobeat-docs-urz` was closed.

---

### Task 4: Normalize `aerobeat-tool-content-authoring` and docs terminology to `Chart`

**Bead ID:** `aerobeat-docs-wx9`  
**SubAgent:** `primary` (for `coder` role)  
**Role:** `coder`  
**References:** `REF-01`, `REF-02`, `REF-03`  
**Prompt:** After content-core normalization is verified, claim the bead and normalize `aerobeat-tool-content-authoring` and any still-relevant docs surfaces from `Chart Variant` wording to canonical `Chart` wording. Preserve the shared-service architecture and thin CLI/editor surfaces. Update filenames/identifiers/tests/docs as needed, run validation, commit/push by default, and close the bead with an exact summary.

**Folders Created/Deleted/Modified:**
- `projects/aerobeat/aerobeat-tool-content-authoring/`
- `projects/aerobeat/aerobeat-docs/`

**Files Created/Deleted/Modified:**
- `aerobeat-tool-content-authoring/services/authoring/chart_variant_authoring_service.gd` → `chart_authoring_service.gd`
- `aerobeat-tool-content-authoring/README.md`
- `aerobeat-tool-content-authoring/services/authoring/chart_authoring_service.gd`
- `aerobeat-tool-content-authoring/services/importers/external_chart_import_service.gd`
- `aerobeat-docs/docs/architecture/content-lane-implementation-phases.md`
- `aerobeat-docs/docs/architecture/content-model.md`
- `aerobeat-docs/docs/architecture/content-repo-shapes.md`
- `aerobeat-docs/docs/architecture/overview.md`
- `aerobeat-docs/docs/architecture/repo-structure-reference.md`
- `aerobeat-docs/docs/architecture/repository-map.md`
- `aerobeat-docs/docs/architecture/topology.md`
- `aerobeat-docs/docs/architecture/workflow.md`
- `aerobeat-docs/docs/gdd/glossary/terms.md`
- `aerobeat-docs/docs/gdd/user-content/community-creations.md`
- `aerobeat-docs/docs/guides/choreography/boxing.md`
- `aerobeat-docs/docs/guides/choreography/overview.md`
- `aerobeat-docs/docs/guides/choreography/step.md`
- `aerobeat-docs/docs/index.md`

**Status:** ✅ Complete

**Results:** Normalized active tool/docs surfaces from `Chart Variant` / `chart variant` / `chart_variant` to canonical `Chart` / `chart`. In `aerobeat-tool-content-authoring`, the authoring service file was renamed from `chart_variant_authoring_service.gd` to `chart_authoring_service.gd`, README and source/schema-id references were updated, and the shared-service / thin CLI-editor architecture was preserved. In `aerobeat-docs`, active architecture, glossary, choreography-guide, community-content, workflow, overview, and index pages were updated to the canonical terminology. Validation passed via the tool repo’s headless workflow tests, `git diff --check`, and a docs grep showing no remaining active-doc matches for old chart-variant terms. Final commits: `d2b3419` in `aerobeat-tool-content-authoring` and `c350ca1` in `aerobeat-docs`, both pushed to `origin/main`, and bead `aerobeat-docs-wx9` was closed.

---

### Task 5: QA + audit final terminology normalization state

**Bead ID:** `aerobeat-docs-c7w`  
**SubAgent:** `primary` (for `qa` then `auditor` roles)  
**Role:** `qa` then `auditor`  
**References:** `REF-01`, `REF-02`, `REF-03`, `REF-04`, `REF-05`  
**Prompt:** Verify and audit the final Chart terminology normalization across the touched AeroBeat repos. Confirm the naming direction is now aligned to `Song -> Routine -> Chart -> Workout`, that validation surfaces remain green/truthful, and that the remaining repo state is clean enough for future implementation. Close the bead only if the normalization genuinely lands.

**Folders Created/Deleted/Modified:**
- `projects/aerobeat/aerobeat-content-core/`
- `projects/aerobeat/aerobeat-tool-content-authoring/`
- `projects/aerobeat/aerobeat-docs/`

**Files Created/Deleted/Modified:**
- none expected unless remediation is required

**Status:** ✅ Complete

**Results:** QA + audit passed across the three touched repos. Verification confirmed the target commits are present at HEAD, both repo-local validation surfaces still pass cleanly (`aerobeat-content-core` contract suite and `aerobeat-tool-content-authoring` headless workflow suite), and active touched surfaces are aligned to `Song -> Routine -> Chart -> Workout`. Remaining hits were judged non-blocking because they live only in historical `.plans/` / `.beads` records or ignored/generated `.testbed` addon copies rather than tracked active source/docs surfaces. Bead `aerobeat-docs-c7w` was closed.

---

## Final Results

**Status:** ✅ Complete

**What We Built:** Normalized the freshly landed AeroBeat foundations from `Chart Variant` / `chart_variant` to canonical `Chart` / `chart` terminology across the active touched surfaces in `aerobeat-content-core`, `aerobeat-tool-content-authoring`, and `aerobeat-docs`. The canonical content contract repo now uses `chart.gd`, `Chart`, and `aerobeat.content.chart.v1`; the tool repo now uses `chart_authoring_service.gd` plus updated schema-id references; and the active docs now teach the `Song -> Routine -> Chart -> Workout` hierarchy consistently.

**Reference Check:** `REF-01` and `REF-02` were satisfied by aligning the naming direction to `Chart` / `chartId` / `chartName`. `REF-03` remained intact because the normalization preserved the approved content/tool ownership split. `REF-04` and `REF-05` remain consistent with the scaffold and cleanup work, aside from allowed historical wording in archived/local plan records.

**Commits:**
- `01705a1` - Normalize chart terminology in `aerobeat-content-core`
- `d2b3419` - Normalize tool chart terminology in `aerobeat-tool-content-authoring`
- `c350ca1` - Normalize docs chart terminology in `aerobeat-docs`

**Lessons Learned:** Terminology cleanup should happen as close as possible to the first scaffold landing; otherwise schema ids, filenames, docs, and tests start drifting together. Also, generated/install mirrors like `.testbed/addons/` should be treated as downstream artifacts during terminology work unless they are the actual active validation surface.

---

*Completed on 2026-04-24*
