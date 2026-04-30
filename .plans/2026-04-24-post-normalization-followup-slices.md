# AeroBeat Post-Normalization Follow-up Slices

**Date:** 2026-04-24  
**Status:** In Progress  
**Agent:** Chip 🐱‍💻

---

## Goal

Turn the newly scaffolded and normalized AeroBeat foundations into the next real implementation slices: deepen `aerobeat-content-core` contracts/validators, deepen `aerobeat-tool-content-authoring` services/CLI around real authoring operations, keep editor UX thin and service-backed, and avoid prematurely collapsing feature/runtime concerns into these repos.

---

## Overview

The foundation work is now in a better place than it was even a few hours ago: the initial `content-core` and `tool-content-authoring` scaffolds landed, the two validation-quality cleanup issues were resolved, and the `Chart` terminology normalization is complete across the active touched surfaces. That means the next work can move from “standing up clean shapes” into “adding the first real behavior” without dragging stale naming, noisy negative fixtures, or misleading test surfaces forward.

The next implementation should still stay disciplined. `aerobeat-content-core` needs to deepen as a dependency-light contract repo, not turn into a tool or runtime blob. `aerobeat-tool-content-authoring` should deepen around concrete service/CLI operations that consume those contracts, while the editor surface remains a thin adapter over the same shared services. Richer feature/runtime repos should remain explicitly deferred until these contracts and workflows are sturdier.

---

## REFERENCES

| ID | Description | Path |
| --- | --- | --- |
| `REF-01` | Locked naming and durable model direction | `memory/2026-04-23.md` |
| `REF-02` | Day-one content/tool repo shapes and ownership split | `projects/aerobeat/aerobeat-docs/docs/architecture/content-repo-shapes.md` |
| `REF-03` | Initial scaffold execution record | `projects/aerobeat/aerobeat-docs/.plans/2026-04-24-aerobeat-repo-audit-and-initial-scaffolding.md` |
| `REF-04` | Scaffold cleanup execution record | `projects/aerobeat/aerobeat-docs/.plans/2026-04-24-aerobeat-scaffold-cleanups-and-rundown.md` |
| `REF-05` | Chart terminology normalization execution record | `projects/aerobeat/aerobeat-docs/.plans/2026-04-24-chart-variant-to-chart-normalization.md` |

---

## Tasks

### Task 1: Define the first real `aerobeat-content-core` behavior slice

**Bead ID:** `aerobeat-docs-2k3`  
**SubAgent:** `primary` (for `research` role)  
**Role:** `research`  
**References:** `REF-01`, `REF-02`, `REF-03`, `REF-04`, `REF-05`  
**Prompt:** Claim the bead and propose the smallest high-value next behavior slice for `aerobeat-content-core` now that the scaffold/cleanup/normalization work is complete. The recommendation should stay contract-first and validator-focused, avoid tool UX/runtime concerns, and identify the exact contracts/validators/tests that should deepen next.

**Folders Created/Deleted/Modified:**
- `projects/aerobeat/aerobeat-content-core/`
- `projects/aerobeat/aerobeat-docs/`

**Files Created/Deleted/Modified:**
- none expected unless the recommendation is captured in-doc

**Status:** ✅ Complete

**Results:** Planning recommendation returned: **Workout Step Resolution Contract + Legality Validation**. The proposed next slice deepens `WorkoutStep` and `ResolvedWorkoutStep` contracts, tightens `Workout` step semantics, extends `ContentPackageValidator` with workout-step legality checks, and replaces placeholder workout-resolution tests with real contract/validation coverage. It was chosen because it adds the smallest high-value shared behavior to `aerobeat-content-core` without drifting into tool UX or runtime gameplay logic.

---

### Task 2: Implement the first real `aerobeat-content-core` slice

**Bead ID:** `aerobeat-docs-7e6`  
**SubAgent:** `primary` (for `coder` role)  
**Role:** `coder`  
**References:** `REF-01`, `REF-02`, `REF-03`, `REF-04`, `REF-05`  
**Prompt:** After the next content-core slice is selected, claim the bead and implement it in `aerobeat-content-core`. Deepen contracts/validators/tests in the minimal clean way, keep the repo dependency-light, do not introduce tool UX or runtime concerns, run validation, commit/push by default, and close the bead with an exact summary.

**Folders Created/Deleted/Modified:**
- `projects/aerobeat/aerobeat-content-core/`

**Files Created/Deleted/Modified:**
- TBD during execution

**Status:** ✅ Complete

**Results:** Implemented the approved **Workout Step Resolution Contract + Legality Validation** slice in `aerobeat-content-core`. The repo now has explicit `WorkoutStep` and `ResolvedWorkoutStep` contracts, deeper `Workout` and `WorkoutResolution` semantics, stronger workout-step legality checks in `ContentPackageValidator`, and new valid/invalid fixtures plus contract tests for workout-step structure, song/routine/chart consistency, and duplicate step IDs. Validation passed via the full headless contract suite and `git diff --check`. Final coder commit: `c0c90eb`, pushed to `origin/main`, and bead `aerobeat-docs-7e6` was closed.

---

### Task 3: QA + audit `aerobeat-content-core` behavior slice

**Bead ID:** `aerobeat-docs-8ym`  
**SubAgent:** `primary` (for `qa` then `auditor` roles)  
**Role:** `qa` then `auditor`  
**References:** `REF-02`, `REF-03`, `REF-04`, `REF-05`  
**Prompt:** Verify and audit the implemented `aerobeat-content-core` behavior slice. Confirm validation still passes, the repo remains contract-first, and no tool/runtime concerns have leaked into the repo. Close the bead only if the implementation genuinely strengthens the foundation without violating the boundary.

**Folders Created/Deleted/Modified:**
- `projects/aerobeat/aerobeat-content-core/`

**Files Created/Deleted/Modified:**
- none expected unless remediation is required

**Status:** ✅ Complete

**Results:** QA + audit passed. Verification confirmed `aerobeat-content-core` remains contract-first / validator-first, the full headless contract suite still passes, and no tool UX, CLI, or runtime/feature logic leaked into the repo. New fixtures/tests were judged cohesive and well-targeted, with one non-blocking caveat: dedicated committed tests for missing-chart and routine-mismatch workout-step cases were not added, though both behaviors were verified via ad hoc probes and the validator implementation clearly covers them. Bead `aerobeat-docs-8ym` was closed.

---

### Task 4: Define the first real `aerobeat-tool-content-authoring` behavior slice

**Bead ID:** `aerobeat-docs-ruu`  
**SubAgent:** `primary` (for `research` role)  
**Role:** `research`  
**References:** `REF-01`, `REF-02`, `REF-03`, `REF-04`, `REF-05`  
**Prompt:** After content-core is verified, claim the bead and propose the smallest high-value next behavior slice for `aerobeat-tool-content-authoring`. The recommendation should deepen shared services/CLI around real authoring operations, keep editor UX thin and service-backed, and explicitly avoid collapsing feature/runtime concerns into this repo.

**Folders Created/Deleted/Modified:**
- `projects/aerobeat/aerobeat-tool-content-authoring/`
- `projects/aerobeat/aerobeat-docs/`

**Files Created/Deleted/Modified:**
- none expected unless the recommendation is captured in-doc

**Status:** ✅ Complete

**Results:** Planning recommendation returned: **Persist Canonical Chart Authoring to a Content Package**. The proposed next slice deepens the shared authoring service into a real chart upsert/write workflow, adds a thin `author` CLI command over that service, reuses package validation after writes, and keeps editor UX limited to service-registry exposure rather than UI-heavy authoring work. It was chosen because it gives the tool repo its first true persisted authoring capability without collapsing feature/runtime concerns into the repo.

---

### Task 5: Implement the first real `aerobeat-tool-content-authoring` slice

**Bead ID:** `aerobeat-docs-uv3`  
**SubAgent:** `primary` (for `coder` role)  
**Role:** `coder`  
**References:** `REF-01`, `REF-02`, `REF-03`, `REF-04`, `REF-05`  
**Prompt:** After the next tool-side slice is selected, claim the bead and implement it in `aerobeat-tool-content-authoring`. Deepen shared services and CLI around real authoring operations, keep the editor/plugin surface thin and service-backed, run validation, commit/push by default, and close the bead with an exact summary.

**Folders Created/Deleted/Modified:**
- `projects/aerobeat/aerobeat-tool-content-authoring/`

**Files Created/Deleted/Modified:**
- `services/authoring/chart_authoring_service.gd`
- `services/authoring/routine_authoring_service.gd`
- `cli/commands/author_command.gd`
- `cli/main.gd`
- `editor/plugins/content_authoring_plugin.gd`
- `src/AeroToolManager.gd`
- `tests/test_chart_authoring_service.gd`
- `tests/test_author_command.gd`
- `tests/test_editor_uses_shared_services.gd`
- `tests/run_tool_tests.gd`

**Status:** ✅ Complete

**Results:** Implemented the approved **Persist Canonical Chart Authoring to a Content Package** slice in `aerobeat-tool-content-authoring`. `ChartAuthoringService.upsert_record()` now writes canonical chart JSON into the package, updates `manifest.json`, ensures the owning routine includes the chart via `RoutineAuthoringService.ensure_chart_membership()`, and reruns package validation as part of the result. A thin `author` CLI command was added and wired through `cli/main.gd`, while the editor surface remained limited to shared-service exposure. The headless workflow suite passed after the changes. Final coder commit: `d1c4c29`, pushed to `origin/main`, and bead `aerobeat-docs-uv3` was closed.

---

### Task 6: QA + audit `aerobeat-tool-content-authoring` behavior slice

**Bead ID:** `aerobeat-docs-rl9`  
**SubAgent:** `primary` (for `qa` then `auditor` roles)  
**Role:** `qa` then `auditor`  
**References:** `REF-02`, `REF-03`, `REF-04`, `REF-05`  
**Prompt:** Verify and audit the implemented `aerobeat-tool-content-authoring` behavior slice. Confirm the shared-service architecture still holds, CLI/editor remain thin surfaces, validation stays truthful, and no feature/runtime concerns have leaked into this repo. Close the bead only if the implementation genuinely strengthens the foundation while preserving the repo boundary.

**Folders Created/Deleted/Modified:**
- `projects/aerobeat/aerobeat-tool-content-authoring/`

**Files Created/Deleted/Modified:**
- none expected unless remediation is required

**Status:** ✅ Complete

**Results:** QA + audit passed. Verification confirmed the repo now has a real persisted chart-authoring workflow: `ChartAuthoringService.upsert_record()` writes canonical chart JSON into the package, updates `manifest.json`, updates the owning routine’s `charts` list, and reruns package validation. The CLI remained thin over shared services, the editor surface stayed thin/service-backed, the headless workflow suite passed cleanly, and no runtime/feature concerns leaked into the repo. One non-blocking caveat was noted: `RoutineAuthoringService.ensure_chart_membership()` currently introduces a derived `title` field if missing when it rewrites the routine, which does not break the slice but is worth watching in future contract tightening. Bead `aerobeat-docs-rl9` was closed.

---

### Task 7: Define the next deferred feature/runtime repo boundary note

**Bead ID:** `aerobeat-docs-fsc`  
**SubAgent:** `primary` (for `research` role)  
**Role:** `research`  
**References:** `REF-02`, `REF-03`, `REF-05`  
**Prompt:** After the content-core and tool-side behavior slices are complete, claim the bead and write a short boundary note describing what richer feature/runtime repos should own next, and what must continue to stay out of `aerobeat-content-core` and `aerobeat-tool-content-authoring`. This is a planning/guardrail task, not a feature implementation task.

**Folders Created/Deleted/Modified:**
- `projects/aerobeat/aerobeat-docs/`

**Files Created/Deleted/Modified:**
- TBD if documentation note is created

**Status:** ⏳ Pending

**Results:** Pending.

---

## Final Results

**Status:** ⚠️ Partial

**What We Built:** Landed the first real post-normalization behavior slices in both foundation repos. `aerobeat-content-core` now owns explicit workout-step resolution contracts plus legality validation and coverage around workout-step structure, routine/chart consistency, and duplicate step IDs. `aerobeat-tool-content-authoring` now owns a real persisted chart-authoring workflow that writes canonical chart JSON into a content package, updates package membership state, reruns validation, and exposes the workflow through a thin `author` CLI over shared services.

**Reference Check:** `REF-01` through `REF-05` were satisfied for the completed slices: naming stayed on `Chart`, the content-core repo remained contract-first / validator-first, the tool repo stayed shared-service-backed with thin CLI/editor surfaces, and richer feature/runtime concerns remained deferred. The one still-open item on this plan is Task 7 (`aerobeat-docs-fsc`), which is a follow-up boundary-note task rather than a blocker on the completed implementation slices.

**Commits:**
- `c0c90eb` - Implement workout-step resolution contracts and legality validation in `aerobeat-content-core`
- `d1c4c29` - Implement persisted canonical chart authoring workflow in `aerobeat-tool-content-authoring`

**Lessons Learned:** The next valuable foundation slices are emerging cleanly now that the scaffolds and terminology are stable. Small vertical slices that strengthen contracts/validators first, then shared authoring services second, are producing durable progress without letting runtime/editor scope leak into the wrong repos.

---

*Completed on 2026-04-24*
