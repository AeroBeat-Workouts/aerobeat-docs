# AeroBeat Chart Contract Post-Song-Timing Phase

**Date:** 2026-04-28  
**Status:** In Progress  
**Agent:** Chip 🐱‍💻

---

## Goal

Resume the AeroBeat `charts/*.yaml` discussion now that song-owned timing truth is locked, and decide the remaining chart-contract boundaries before implementation edits begin.

---

## Overview

The song timing foundation is now closed across docs, shared contract code, and authoring tooling. That removes the biggest ambiguity from the earlier paused chart-contract work: charts no longer need to pretend to own canonical tempo/anchor/stop/meter truth. The next discussion can therefore focus much more cleanly on what chart YAML should still own, what chart-local timing/snap metadata means now that song timing is authoritative, and how mode-specific gameplay payloads should coexist with any shared chart envelope features.

This phase should stay definition-first. We already know the high-level package model remains `Song -> Chart -> Set -> Workout`, that charts stay reusable exact playable slices, and that broader chart-side timing/gameplay-mode design is the next frontier. The right move now is to turn the residual risks into explicit discussion slices: chart-local timing/snap metadata vs canonical song timing, authored marker/signal events, shared envelope vs mode-specific payload boundaries, and vocabulary questions like `interactionFamily` versus lane/portal-centered truth. Only after those are locked should we create implementation beads for docs/example YAML changes.

---

## REFERENCES

| ID | Description | Path |
| --- | --- | --- |
| `REF-01` | Prior paused chart-yaml research/decision plan | `projects/aerobeat/aerobeat-docs/.plans/2026-04-27-aerobeat-chart-yaml-review.md` |
| `REF-02` | Song timing rollout plan now closed enough to use as foundation | `projects/aerobeat/aerobeat-docs/.plans/2026-04-28-aerobeat-song-timing-contract-rollout.md` |
| `REF-03` | Current demo chart example: Neon Stride | `projects/aerobeat/aerobeat-docs/docs/examples/workout-packages/demo-neon-boxing-bootcamp/charts/ab-chart-neon-stride-boxing-medium.yaml` |
| `REF-04` | Current demo chart example: Midnight Sprint | `projects/aerobeat/aerobeat-docs/docs/examples/workout-packages/demo-neon-boxing-bootcamp/charts/ab-chart-midnight-sprint-boxing-hard.yaml` |
| `REF-05` | Canonical workout package/storage contract | `projects/aerobeat/aerobeat-docs/docs/architecture/workout-package-storage-and-discovery.md` |
| `REF-06` | Canonical content model | `projects/aerobeat/aerobeat-docs/docs/architecture/content-model.md` |

---

## Tasks

### Task 1: Reconstruct the post-song-timing chart discussion state

**Bead ID:** `aerobeat-docs-5bw`  
**SubAgent:** `primary` (for `research`)  
**Role:** `research`  
**References:** `REF-01`, `REF-02`, `REF-03`, `REF-04`, `REF-05`, `REF-06`  
**Prompt:** Reconstruct the current chart-contract state now that song timing truth is locked. Summarize what is already settled, what was intentionally deferred, and which chart-side decisions still need Derrick sign-off before implementation beads should exist.

**Folders Created/Deleted/Modified:**
- `.plans/`
- chart/docs paths only if notes are added later

**Files Created/Deleted/Modified:**
- This plan file only unless notes are needed

**Status:** ✅ Complete

**Results:** Reconstructed the current chart-contract state on top of the now-landed song timing contract. Already settled: `Song -> Chart -> Set -> Workout` remains locked; songs now own canonical timing truth through `anchorMs`, `tempoSegments`, `stopSegments`, and `timeSignatureSegments`; charts remain reusable exact playable slices with no song/set/workout links; sets remain the single source of truth for composition wiring; boxing examples already teach structured event payloads; and the prior directional call to remove `validatedInputProfiles`, avoid numeric difficulty ratings, and keep movement-semantics-first chart targeting still stands. Still unresolved before implementation beads should exist: what chart-local `timing` means now that songs own conductor truth (for example whether `timing.resolution` survives as editor/snap guidance and where that boundary is documented), whether a separate narrow authored marker/signal lane is part of the shared chart contract and how it is shaped, which shared envelope fields remain durable versus being demoted to authoring-tool/runtime hints (`supportedInputProfiles`, `presentationHints`, `scoringHints`, possible `interactionFamily` vocabulary refinements), and how explicitly the docs/examples should separate the generic chart envelope from boxing-specific `events[*]` payloads. Recommended discussion order after this reconstruction is: (1) chart-local timing/snap metadata boundary first, because song timing is now locked and this is the biggest remaining ambiguity, (2) marker/signal lane plus shared-envelope boundary second, because authored signals depend on the chosen event-addressing/timing model, and (3) remaining vocabulary/field-survival cleanup last, because it is easiest once the semantic boundaries are fixed.

---

### Task 2: Define chart-local timing/snap metadata boundaries

**Bead ID:** `aerobeat-docs-b5k`  
**SubAgent:** `primary` (for `research`)  
**Role:** `research`  
**References:** `REF-01`, `REF-02`, `REF-03`, `REF-04`, `REF-05`, `REF-06`  
**Prompt:** Define what chart-side timing/snap metadata still belongs in chart YAML now that songs own canonical anchor/tempo/stop/meter truth. Pressure-test fields like `timing.resolution`, beat subdivision hints, editor snap guidance, presentation hints, and anything else that risks becoming parallel timing truth.

**Folders Created/Deleted/Modified:**
- same as discussion scope

**Files Created/Deleted/Modified:**
- same as discussion scope

**Status:** ✅ Complete

**Results:** Recommendation: keep a tiny chart-local timing/snap block, but only as optional beat-grid authoring guidance that never duplicates song-owned canonical conductor truth. Song YAML remains the sole durable owner of `anchorMs`, `tempoSegments`, `stopSegments`, and `timeSignatureSegments`. Chart YAML should not carry `beatOffset`, `offsetMs`, BPM, tempo maps, stop data, meter data, or any other field that can change beat↔ms conversion. If a chart-side timing block survives, it should be renamed away from generic `timing` toward an explicit editor-guidance concept (for example `beatGrid` / `snapGuidance`) and limited to durable beat-domain authoring hints such as default snap denominator or optional beat subdivision groupings that help reconstruct the intended authored beat lattice. `timing.resolution` as currently named is too ambiguous because it reads like conductor truth; it should either be removed entirely or replaced with a clearer optional field such as `defaultSnapDivisor` under an editor-guidance block. Strong recommendation: durable chart truth stays in authored event beat positions plus any future chart-authored marker/signal events, while ephemeral cursor snap, zoom, temporary quantization overrides, and other session UX remain authoring-tool-only state outside chart YAML. `validatedInputProfiles` should still be removed from authored chart YAML; `supportedInputProfiles`, `presentationHints`, and `scoringHints` can survive only as clearly optional hint-level metadata. Spillover: `aerobeat-content-core` should ultimately stop teaching/accepting generic chart `timing` as a required shared-envelope field and instead codify song-owned conductor truth plus an optional narrowly scoped chart guidance block; `aerobeat-tool-content-authoring` should persist durable snap defaults only if they aid cross-tool reopen/export, while keeping richer editor state out of package content; docs/examples should explicitly teach “song owns conductor truth, chart owns beat-authored gameplay truth, tool owns ephemeral editing UX”; future runtime/gameplay work should resolve beats against song timing only and treat chart snap guidance as non-authoritative, ignorable metadata.

---

### Task 3: Define authored marker/signal event lane and shared chart envelope boundaries

**Bead ID:** `aerobeat-docs-uym`  
**SubAgent:** `primary` (for `research`)  
**Role:** `research`  
**References:** `REF-01`, `REF-03`, `REF-04`, `REF-05`, `REF-06`  
**Prompt:** Define the shared chart envelope vs mode-specific payload split now that song timing is settled. Include whether marker/signal events are a separate stream, what envelope metadata survives, and how to avoid boxing-shaped assumptions in the generic chart contract.

**Folders Created/Deleted/Modified:**
- same as discussion scope

**Files Created/Deleted/Modified:**
- same as discussion scope

**Status:** ✅ Complete

**Results:** Recommended a strict two-lane chart contract: keep authored marker/signal data as a **separate shared stream** from gameplay `events`, not mixed into a single heterogeneous event array. The shared chart envelope should stay intentionally small and mode-agnostic: schema/provenance fields, `chartId`, `chartName`, `mode`, `difficulty`, `interactionFamily`, optional `supportedInputProfiles`, optional lightweight `timing` snap/editor metadata (not canonical tempo truth), optional `presentationHints`, optional `scoringHints`, `signals`, and mode-specific `events`. `validatedInputProfiles` should still be removed from durable authored chart YAML. The `signals` lane should be generic, deterministic, and typed by a tiny taxonomy such as `section`, `phrase`, `cue`, and `state`, with stable ids plus optional labels/tags and bounded payload fields. Everything that describes playable interaction objects stays in mode-specific `events`; do not force generic lane/portal/hand/pose fields into the shared envelope. This avoids boxing-shaped assumptions because the common contract only says that a chart has one gameplay-event stream for its mode and one optional authored-signal stream for cross-system synchronization. Recommended v1 explicitly includes deterministic authored signals for sectioning, phrase markers, environment/VFX sync hooks, debug checkpoints, and lightweight training cues; v1 explicitly excludes arbitrary script execution, branching logic, score logic, coaching clip graphs, dynamic runtime triggers, and any freeform event bus semantics. Spillover impact: docs/examples must teach the two-lane split clearly; `aerobeat-content-core` should model `signals` as a first-class shared timeline beside mode-specific `events`; `aerobeat-tool-content-authoring` should expose/edit/validate that shared signal lane without smuggling runtime-only behavior into it; later gameplay/runtime work should subscribe to authored signals through content-driven dispatch rather than by scraping boxing/step/flow payloads directly.

---

### Task 4: Resolve vocabulary questions before implementation

**Bead ID:** `aerobeat-docs-0o4`  
**SubAgent:** `primary` (for `research`)  
**Role:** `research`  
**References:** `REF-01`, `REF-03`, `REF-04`, `REF-05`, `REF-06`  
**Prompt:** Resolve remaining chart-envelope vocabulary questions such as `interactionFamily` versus lane/portal-centered terminology, and decide which fields belong in the durable shared contract versus mode-specific event payloads or authoring-tool-only UX.

**Folders Created/Deleted/Modified:**
- same as discussion scope

**Files Created/Deleted/Modified:**
- same as discussion scope

**Status:** ✅ Complete

**Results:** Initial recommendation favored keeping `interactionFamily`, but Derrick's later compatibility/view breakdown materially changes this slice. The current stronger direction is to reconcile the chart contract around explicit gameplay-view topologies rather than broad legacy profile hints: `single-lane`, `dual-lanes`, `single-portal`, and `multi-portal`, with AeroBeat's primary device focus clarified as camera, Joy-Cons, and VR 6DoF controllers, while gamepad/keyboard/mouse/touch are primarily ADA/debug/testing surfaces. This means the earlier `interactionFamily` recommendation is no longer considered settled; it must now be pressure-tested against the new feature × input × supported-view matrix before implementation. The field-pruning direction *is* settled: remove `validatedInputProfiles`, remove `supportedInputProfiles`, remove `scoringHints`, and remove `presentationHints` from durable authored chart YAML. Durable shared contract remains centered on identity/provenance, `mode`, `difficulty`, beat-authored `events`, and the separate authored `signals` lane, while the exact replacement (if any) for `interactionFamily` is now an active design question tied to the newly articulated lane/portal view model.

---

### Task 5: Research portal zone-grid sizing by inspiration game

**Bead ID:** `aerobeat-docs-6zf`  
**SubAgent:** `primary` (for `research`)  
**Role:** `research`  
**References:** `REF-03`, `REF-04`, `REF-05`, `REF-06`  
**Prompt:** Research how the inspiration games handle portal-space targeting / zone-grid sizing so AeroBeat can define feature-owned zone-grid rules for the portal-supporting features. Focus on Boxing via Supernatural, Flow via Beat Saber and Starri, and explicitly note that Dance and Step do not need portal grids. Produce a recommendation for AeroBeat's initial feature-owned zone-grid sizes and naming boundaries.

**Folders Created/Deleted/Modified:**
- `.plans/`
- research-only unless notes are added later

**Files Created/Deleted/Modified:**
- This plan file only unless notes are needed

**Status:** ✅ Complete

**Results:** Research outcome: the inspirations do **not** converge on one shared portal-grid truth, so AeroBeat should treat portal placement as feature-owned rather than chart-owned. **Beat Saber** is the clearest public anchor: the official level-editor docs define a `4 x 3` vertical grid with `12` placement spots sitting over `4` bridge lanes, and note/wall/bomb placement is explicitly authored onto those cells (`beatsaber.com/documentation/placing-notes/index.html`, `beatsaber.com/documentation/terminology/index.html`). Certainty: **high**. **Supernatural boxing** does not expose an equivalent public numbered grid; public coverage consistently supports left-hand vs right-hand targets, punch-type-specific target shapes (jab / uppercut / hook), blocks, and dodge bars, while a long-term user review also calls out right / left / abs / uppercuts / side punches / blocks. That supports a **coarse body-relative target region model** rather than a Beat-Saber-style dense cell lattice, but the exact count/layout is still inference. Certainty: **medium-low** on layout, **medium-high** on the existence of distinct left/right + punch-family + dodge/block semantics. **Starri** publicly supports Slash mode, Catch mode, dodge obstacles, and turn-the-wheel interactions, but I did not find a public doc that defines a discrete fixed cell count the way Beat Saber does; current evidence supports a broader screen/body-space target field rather than a documented dense numbered grid. Certainty: **low-medium** on exact layout, **medium** that no public fixed-grid contract is visible. Recommendation for AeroBeat v1: **boxing portal spaces = 3 x 3 coarse grid** (left / center / right by high / mid / low) so the feature can express jabs/hooks, body shots, uppercut-origin regions, guard/cover cues, and dodge-adjacent centerline logic without pretending to be a dense slicer grid; **flow portal spaces = 4 x 3 grid** to align with Beat Saber’s strongest observable topology and still leave room to emulate broader Starri-like placements inside the same flow-owned space if desired. Boxing and flow should therefore use **different feature-owned grid definitions**, even if the implementation later shares a neutral underlying placement container. Naming implication: a universal event field named `zone` is probably too boxing-flavored / semantically loose once flow wants explicit row+column cells. Prefer a neutral shared concept like `portalSpace`, `targetSpace`, or `placement`, with feature-owned payloads beneath it (for example semantic boxing regions vs explicit flow grid cells). Dance and Step should explicitly declare **no portal support needed** in this phase.

---

### Task 6: Research documented boxing feature mechanics before event taxonomy design

**Bead ID:** `aerobeat-docs-7k6`  
**SubAgent:** `primary` (for `research`)  
**Role:** `research`  
**References:** `REF-03`, `REF-04`, `REF-05`, `REF-06`  
**Prompt:** Find the existing boxing feature documentation in `aerobeat-docs` and extract the documented gameplay mechanics, target types, defensive actions, movement requirements, and any already-written event semantics before proposing a new boxing chart-event taxonomy. Treat this as the source-of-reference pass for the boxing slice.

**Folders Created/Deleted/Modified:**
- `.plans/`
- research-only unless notes are added later

**Files Created/Deleted/Modified:**
- This plan file only unless notes are needed

**Status:** ✅ Complete

**Results:** Completed a repo-wide boxing-docs sweep and identified the best source-of-reference files for the upcoming boxing event-taxonomy proposal. Primary sources are `docs/guides/choreography/boxing.md` and `docs/gdd/gameplay/boxing.md`, with supporting context from the demo boxing chart YAML, `content-model.md`, `view-modes.md`, `calibration.md`, and accessibility docs. The current docs already document the core boxing loop (punch / dodge / block), explicit target/object families (`strike`, `guard`, `obstacle`, `stance`, `knee`), and the authored **5 symbolic zone** model (`left_high`, `right_high`, `left_low`, `right_low`, `center`). They also imply additional mechanics (`reward`, `leg_lift`, `run_in_place`) that need taxonomy treatment. Most importantly, this pass confirmed that the boxing chart slice should build from existing docs-first semantics rather than from the older Supernatural research notes directly.

---

### Task 7: Apply approved chart-contract edits, then QA + audit

**Bead ID:** `Pending`  
**SubAgent:** `primary` (for `coder` / `qa` / `auditor`)  
**Role:** `coder` / `qa` / `auditor`  
**References:** `REF-03`, `REF-04`, `REF-05`, `REF-06`  
**Prompt:** After Derrick explicitly approves the chart-side decisions, update the docs/example chart YAML and any directly coupled contract surfaces, then run the normal coder → QA → auditor loop before closing the phase.

**Folders Created/Deleted/Modified:**
- implementation scope only

**Files Created/Deleted/Modified:**
- implementation scope only

**Status:** ✅ Major discussion decisions landed

**Results:** Derrick approved several major chart-contract directions: (1) charts should use two lanes, `events` for gameplay and `signals` for authored shared markers; (2) songs remain the only canonical timing authority and chart-side timing guidance should not survive in chart YAML because song timing already provides the per-section guidance needed by chart-creation tools; (3) `validatedInputProfiles`, `supportedInputProfiles`, `scoringHints`, and `presentationHints` should all be removed from durable authored chart YAML; (4) the older `interactionFamily` term should be replaced, with `beatSpace` now approved as the chart-declared spatial topology field; (5) charts should declare a single gameplay feature/topology pairing rather than trying to support multiple topologies in one chart, because that is cleaner even if it means more chart variants; (6) the durable term should be `feature` rather than `mode`, with a follow-up audit required across workout YAML, docs, and SQLite/catalog surfaces where `mode` still appears; (7) `beatSpace` should stay enum-only; and (8) zone-grid size/shape should be feature-owned so charts adhere to and validate against feature rules rather than redefining grid structure locally. Boxing-specific clarification landed afterward: the authored boxing space should remain the documented **5 symbolic zones** (`left_high`, `right_high`, `left_low`, `right_low`, `center`) for both `single-portal` and `multi-portal` beat spaces, with `center` treated as the dedicated block/guard zone rather than a general-purpose strike zone. Derrick also clarified the default workout rule philosophy: missing a beat simply loses points, and negative-score / fail-state complexity should only appear via explicit workout modifiers, not as baseline boxing-chart semantics. Boxing event-family rules are now further defined: `strike` carries forward explicit strike subtype semantics (`jab`, `cross`, `hook`, `uppercut`) alongside `hand`, `zone`, and optional/required `portal` depending on beatSpace, and is invalid if `zone=center`; `guard` is a one-beat center-zone event and invalid outside `center`; `stance` should be duration-capable (a short span rather than an instant cue); `knee` stays in scope with left/right semantics anchored to the lower left/right zones; boxing adds non-obstacle beat families `leg-lift` and `run-in-place` with no zone requirement; and boxing obstacles include `look-here`, `sidestep`, `weave`, and `crouch`, using subtype-based obstacle encoding with authored duration on a single event rather than repeated per-beat duplicates. Remaining open before implementation: turn these boxing decisions into a formal first-pass event taxonomy/payload table, settle exact field names for span duration, and then convert the approved decisions into a concrete boxing chart YAML skeleton and implementation/audit plan.

---

## Final Results

**Status:** ⚠️ Partial / Paused for next-session review

**What We Built:** Reopened the chart-contract phase on top of the now-locked song timing foundation, then resolved the major chart-envelope directions: `feature` replaces `mode`, `beatSpace` replaces `interactionFamily`, charts use separate `events` and `signals` lanes, songs remain the only canonical timing authority, and weak compatibility/presentation/scoring hint fields were removed from durable authored chart YAML. For boxing specifically, we also locked the 5 symbolic authored zones, clarified that `center` is the dedicated guard zone, confirmed the default no-fail / no-negative-score rule philosophy, and outlined the first-pass boxing event families that still need to be formalized into payload shapes next session.

**Reference Check:** `REF-01` carried forward the paused chart research state, while `REF-02` establishes that song-owned timing truth is now sufficiently locked to support the next chart discussion without re-litigating song timing.

**Commits:**
- Pending

**Lessons Learned:** The right way to avoid chart-contract drift is to separate song-owned conductor truth from chart-owned authoring semantics, then define chart-local timing/snap metadata very carefully so it does not grow back into parallel timing authority. Boxing also exposed that chart-envelope decisions can be settled before input-implementation rules are finished, as long as the chart stays input-agnostic and feature-owned spatial semantics stay distinct from device/runtime detection logic.

---

*Completed on 2026-04-28 (draft for discussion)*
