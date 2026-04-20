# AeroBeat Beat Chart / Workout Architecture

**Date:** 2026-04-20  
**Status:** In Progress  
**Agent:** Chip 🐱‍💻

---

## Goal

Define the content architecture for creating, storing, and playing back AeroBeat beat charts and workouts, starting with Boxing + Camera Tracking (MediaPipe), and capture the resulting decisions in `aerobeat-docs`.

---

## Overview

AeroBeat already establishes several important architecture constraints in the docs: polyrepo hub-and-spoke structure around `aerobeat-core`, strong input agnosticism via normalized providers, and data-driven content loading. That means our chart/workout design should avoid coupling content too tightly to a single device or a single view mode, while still leaving room for gameplay-mode-specific authoring details where they are truly needed.

The immediate design pressure comes from the first shipping slice: Boxing with camera tracking via MediaPipe. That first slice needs a practical schema now, but we should avoid backing ourselves into a corner where Step, Dance, Flow, JoyCons, or XR all need incompatible content pipelines later. The plan should therefore separate durable content primitives from mode/device interpretation rules, then document where boxing-specific exceptions belong.

The current discussion should answer three early product questions: whether there is one universal chart type or a layered family of chart types, whether difficulty belongs inside a chart or inside a higher-order song package, and what the concrete boxing-via-MediaPipe data shape looks like for a first pass. The output should become documentation in `aerobeat-docs`, not just chat conclusions.

---

## REFERENCES

| ID | Description | Path |
| --- | --- | --- |
| `REF-01` | Architecture overview: modular hub-and-spoke + data-driven content | `docs/architecture/overview.md` |
| `REF-02` | Input provider architecture and normalization contract | `docs/architecture/input.md` |
| `REF-03` | DSP/audio timing and conductor model | `docs/architecture/audio.md` |
| `REF-04` | Input-agnostic gameplay framing | `docs/gdd/input-system/agnostic-input.md` |
| `REF-05` | Boxing gameplay mechanics and lane/target concepts | `docs/gdd/gameplay/boxing.md` |
| `REF-06` | Boxing choreography guidance and difficulty framing | `docs/guides/choreography/boxing.md` |
| `REF-07` | Docs repo workflow and content update home | `docs/architecture/workflow.md` |

---

## Key Questions To Resolve

1. Is there a single chart model that spans all gameplay modes and input types, or a layered model with shared primitives plus mode-specific chart payloads?
2. Should difficulty variants live inside one chart, or does AeroBeat need a higher-level song package primitive between chart and workout?
3. What should the first concrete chart data shape be for Boxing + Camera Tracking via MediaPipe?
4. Where do view-mode concerns (portal view, track view, 3-portal, 360) belong: in authored content, runtime presentation config, or both?
5. How should a workout package assemble songs/charts with pre/post workout media and workout-level metadata?

---

## Working Direction (Draft)

### Initial Recommendation

Use a **layered content model**, not one flat universal chart blob and not totally separate incompatible chart systems.

Suggested primitives:

1. **Song**
   - Audio asset + global metadata
   - BPM/tempo map / timing map
   - song-level tags, duration, credits, licensing, etc.

2. **Routine** *(recommended new primitive between Song and Workout)*
   - A gameplay-mode-specific interpretation package for one song
   - Owns one or more **Chart Variants** for the same song
   - Examples:
     - `boxing routine` for a song
     - `dance routine` for a song
     - `step routine` for a song
   - Holds mode-specific metadata, recommended view modes, validation rules, and difficulty set

3. **Chart Variant**
   - One playable authored sequence for a specific difficulty and possibly an optional input-profile constraint
   - Example: `Boxing / Medium / Gesture`, `Boxing / Hard / XR`
   - Contains the timed event stream and scoring metadata

4. **Workout**
   - Playlist/composition of routines or chart variants across one or more songs
   - Includes workout-level metadata such as warmup, cooldown, pre-video, post-video, total intensity, target duration, etc.

This keeps **Song** reusable across modes, **Routine** as the mode-aware package, **Chart Variant** as the concrete playable difficulty artifact, and **Workout** as the playlist/program container.

### Why this shape currently looks strongest

- `REF-01` and `REF-02` argue against hard-binding content directly to raw devices.
- `REF-05` and `REF-06` show that boxing has real authored semantics that are richer than generic notes in lanes.
- Different gameplay families likely need different authored event vocabularies, but they can still share timing, packaging, validation, and playback interfaces.
- Difficulty feels too specific to live at the workout level and too variable to force into a single all-difficulties blob without creating authoring/versioning pain.

---

## Proposed Architecture Hypothesis (Discussion Draft)

### 1. One chart type vs many

**Recommendation:** one **shared chart envelope/interface**, with **mode-specific event schemas** inside it.

In practice:
- Shared across all modes:
  - ids
  - song reference
  - gameplay mode
  - difficulty
  - timing base / conductor alignment
  - tags
  - validation metadata
  - playback hints
  - event list envelope
- Mode-specific inside the payload:
  - boxing events
  - dance events
  - step events
  - flow events

This avoids pretending boxing, dance, and step are literally the same content shape while still preserving a common loader/editor/runtime contract.

### 2. Device compatibility model

**Recommendation:** charts should target **interaction semantics**, not raw devices.

Suggested interaction families:
- `gesture_2d` — camera, keyboard, mouse, touch, standard gamepad, some JoyCon mappings
- `tracked_6dof` — XR controllers / world-space tracked hands
- `hybrid` — charts/rules that can adapt to both with explicit runtime mapping

For Boxing v1, author charts primarily against **gesture semantics**:
- left/right strike
- strike type: jab/cross/hook/uppercut/block/dodge/knee/etc.
- lane/zone relative to the active portal
- optional body movement requirement

Then allow the runtime/input adapter to map those semantics onto MediaPipe, JoyCons, keyboard, or gamepad.

For XR/world-space, some charts may still be playable if the authored semantics are relative enough. If XR later needs extra authored data such as depth windows, approach vectors, or portal rotation demands, add those as optional mode/input-profile extensions rather than fork the whole content system.

### 3. Difficulty containment

**Recommendation:** do **not** make one beat chart file hold all difficulties as peer event sets by default.

Instead:
- `Routine` groups all difficulties for one song + mode.
- each difficulty is its own `Chart Variant`.

Why:
- cleaner diffs/versioning
- easier tooling and validation
- easier to add/remove difficulties independently
- easier to support alternate device-targeted variants later
- avoids giant files where unrelated difficulty edits collide

### 4. New primitive between chart and workout

**Recommendation:** yes — add **Routine**.

Preferred name: **Routine**

Why `Routine` over `Track Pack`, `Song Bundle`, or `Program`:
- reads naturally in fitness context
- can mean “the boxing choreography for this song”
- sits comfortably under `Workout`
- distinguishes the authored playable package from the underlying audio `Song`

Proposed hierarchy:
- `Song`
  - `Routine (mode-specific for that song)`
    - `Chart Variant (difficulty/device-profile playable chart)`
- `Workout`
  - ordered list of routine/chart selections + workout metadata

### 5. First-use-case shape: Boxing + MediaPipe

**Recommendation:** start with a **boxing chart variant** that encodes timed interaction events in portal-relative zones, plus a small set of presentation and validation hints.

That first version should assume:
- input family: `gesture_2d`
- primary runtime adapter: MediaPipe camera tracking
- event semantics: relative body actions, not world coordinates
- view-mode portability: track/portal presentation derived at runtime from the same authored events where possible

---

## Candidate Boxing v1 Data Shape (Draft)

```json
{
  "schema": "aerobeat.chart.boxing.v1",
  "chartId": "boxing-song123-medium-gesture",
  "songId": "song123",
  "routineId": "song123-boxing",
  "mode": "boxing",
  "difficulty": "medium",
  "interactionFamily": "gesture_2d",
  "supportedInputProfiles": ["mediapipe_camera"],
  "timing": {
    "bpm": 128,
    "offsetMs": 0,
    "resolution": 16
  },
  "presentation": {
    "preferredViews": ["portal", "track"],
    "portalMode": "front_3_portal",
    "mirrorCamera": true
  },
  "scoring": {
    "hitWindowMs": {
      "perfect": 45,
      "good": 90,
      "ok": 140
    },
    "comboModel": "standard"
  },
  "events": [
    {
      "t": 1.875,
      "type": "strike",
      "id": "e1",
      "hand": "left",
      "strike": "jab",
      "zone": "left_high",
      "portal": "center",
      "travelBeats": 2,
      "intensity": 0.4
    },
    {
      "t": 2.344,
      "type": "strike",
      "id": "e2",
      "hand": "right",
      "strike": "cross",
      "zone": "right_high",
      "portal": "center",
      "travelBeats": 2,
      "intensity": 0.6
    },
    {
      "t": 3.750,
      "type": "guard",
      "id": "e3",
      "zone": "center",
      "holdMs": 250,
      "portal": "center"
    },
    {
      "t": 5.625,
      "type": "obstacle",
      "id": "e4",
      "avoid": "squat",
      "shape": "bar_horizontal",
      "portal": "center",
      "durationMs": 500
    },
    {
      "t": 7.500,
      "type": "stance",
      "id": "e5",
      "stance": "southpaw",
      "portal": "center",
      "scored": false
    }
  ],
  "metadata": {
    "author": "tbd",
    "tags": ["cardio", "boxing", "camera-first"]
  }
}
```

### Notes on this draft shape

- `t` should align with conductor/song time, not frame time (`REF-03`).
- `zone` is relative to the active portal and athlete, matching the boxing docs (`REF-05`, `REF-06`).
- `portal` can stay symbolic (`center`, `left`, `right`, future ring ids), which preserves portability between camera and XR experiences.
- `supportedInputProfiles` should express known-tested compatibility, not exclusive capability.
- `travelBeats` belongs to presentation/playback tuning, not scoring semantics, but may be useful in authored content if choreographers need per-event approach feel.
- obstacles, stance cues, knee strikes, and future rotation instructions can all be modeled as distinct event types.

---

## Open Questions / Risks

1. Should `travelBeats` be author-controlled per event, or chart-level/view-level only?
2. Do we want `portal` and `zone` separate, or a single composite spatial token?
3. For XR, will we need depth/approach vectors authored explicitly for some boxing events?
4. Do we want separate `validatedInputProfiles` vs `supportedInputProfiles`?
5. Should workouts reference `routineId + difficulty`, or reference concrete `chartId` directly?

---

## Tasks

### Task 1: Re-read architecture and gameplay docs relevant to chart/workout design

**Bead ID:** `Completed during planning`  
**SubAgent:** `research`  
**References:** `REF-01`, `REF-02`, `REF-03`, `REF-04`, `REF-05`, `REF-06`, `REF-07`  
**Prompt:** Read the referenced architecture/gameplay docs in `aerobeat-docs`, summarize the current system constraints for chart/workout design, and identify any doc gaps or contradictions that matter for content architecture.

**Folders Created/Deleted/Modified:**
- `docs/architecture/`
- `docs/gdd/`
- `docs/guides/`

**Files Created/Deleted/Modified:**
- None expected during research

**Status:** ✅ Complete

**Results:** Relevant architecture, input, audio, boxing gameplay, and choreography docs were read during planning. Those findings established the current recommendation baseline: shared chart envelope, mode-specific payloads, interaction-family targeting, `Routine` as the missing primitive between `Song` and `Workout`, and a Boxing + MediaPipe-first schema direction.

---

### Task 2: Define content primitives for song, routine, chart variant, and workout

**Bead ID:** `aerobeat-docs-36o`  
**SubAgent:** `primary`  
**References:** `REF-01`, `REF-02`, `REF-03`, `REF-04`, `REF-05`, `REF-06`  
**Prompt:** Based on the approved direction, propose a durable AeroBeat content model for Songs, Routines, Chart Variants, and Workouts, including how difficulty, gameplay mode, and input compatibility are represented.

**Folders Created/Deleted/Modified:**
- `docs/architecture/`
- `docs/gdd/`

**Files Created/Deleted/Modified:**
- `docs/architecture/content-model.md` *(new)*
- `docs/architecture/overview.md`
- `docs/gdd/glossary/terms.md`
- `docs/gdd/gameplay/view-modes.md`
- `docs/index.md`

**Status:** ✅ Complete

**Results:** Added a new central architecture doc at `docs/architecture/content-model.md` instead of scattering the model across multiple speculative notes. The docs now explicitly define the hierarchy `Song -> Routine -> Chart Variant -> Workout`, recommend **Routine** as the missing primitive, keep difficulty at the chart-variant layer, and define one shared chart envelope with mode-specific payloads. The docs also codify **interaction-family targeting** (`gesture_2d`, `tracked_6dof`, `hybrid`) instead of binding authored content directly to raw devices, and clarify that view modes are primarily runtime presentation strategies rather than separate chart families.

---

### Task 3: Define Boxing + MediaPipe v1 chart schema and authoring guidance

**Bead ID:** `aerobeat-docs-hn9`  
**SubAgent:** `primary`  
**References:** `REF-02`, `REF-03`, `REF-05`, `REF-06`  
**Prompt:** Design the first-pass data shape for Boxing + Camera Tracking (MediaPipe), including event vocabulary, timing fields, presentation hints, and validation concerns, then draft the corresponding docs updates.

**Folders Created/Deleted/Modified:**
- `docs/architecture/`
- `docs/gdd/`
- `docs/guides/`

**Files Created/Deleted/Modified:**
- `docs/guides/choreography/boxing.md`
- `docs/architecture/content-model.md`

**Status:** ✅ Complete

**Results:** Expanded `docs/guides/choreography/boxing.md` with a concrete **Boxing + MediaPipe v1** chart-shape section. The docs now specify the shared boxing chart fields, a first-pass event vocabulary (`strike`, `guard`, `obstacle`, `stance`, `knee`), symbolic `zone` + `portal` spatial targeting, conductor-aligned timing guidance, and a full JSON example. The written direction is explicitly camera-first but not camera-bound: Boxing v1 targets the `gesture_2d` interaction family, uses MediaPipe as the first validated input profile, and treats presentation fields like `preferredViews`, `portalMode`, and `travelBeats` as hints rather than the root scoring abstraction.

---

### Task 4: Audit the aerobeat-docs updates for coherence and coverage

**Bead ID:** `aerobeat-docs-4m9`  
**SubAgent:** `auditor`  
**References:** `REF-01`, `REF-02`, `REF-03`, `REF-04`, `REF-05`, `REF-06`, `REF-07`  
**Prompt:** Independently audit the updated `aerobeat-docs` content. Verify the docs clearly cover the approved decisions for Song, Routine, Chart Variant, Workout, interaction-family targeting, and Boxing + MediaPipe v1 chart shape. Confirm the story is coherent from Song -> Routine -> Chart Variant -> Workout and call out any contradictions or missing pieces.

**Folders Created/Deleted/Modified:**
- `docs/architecture/`
- `docs/gdd/`
- `docs/guides/`

**Files Created/Deleted/Modified:**
- `docs/architecture/content-model.md`
- `docs/architecture/overview.md`
- `docs/gdd/gameplay/view-modes.md`
- `docs/gdd/glossary/terms.md`
- `docs/guides/choreography/boxing.md`
- `docs/index.md`

**Status:** ✅ Complete

**Results:** Independent audit passed. Verified that the updated docs explicitly cover the approved hierarchy `Song -> Routine -> Chart Variant -> Workout` (`docs/architecture/content-model.md`, `docs/architecture/overview.md`, `docs/gdd/glossary/terms.md`), establish **Routine** as the missing primitive, define a **shared chart envelope with mode-specific payloads**, and move targeting to **interaction families** instead of raw-device binding (`docs/architecture/content-model.md`, `docs/guides/choreography/boxing.md`). Confirmed that the Boxing docs now include a concrete **Boxing + MediaPipe v1** chart shape and JSON example (`docs/guides/choreography/boxing.md`), and that **view modes are framed primarily as runtime presentation strategies** rather than separate authored chart families (`docs/gdd/gameplay/view-modes.md`, `docs/architecture/content-model.md`). Cross-check against `REF-01` through `REF-06` found the update internally coherent with the existing input-agnostic, conductor-aligned, and portal-relative gameplay architecture. No blocking contradictions or missing approved decisions were found.

---

## Final Results

**Status:** ✅ Complete

**What We Built:** Added a durable content-model architecture for AeroBeat that formalizes `Song -> Routine -> Chart Variant -> Workout`, documents **Routine** as the mode-aware package between Song and Workout, defines a **shared chart envelope with mode-specific payloads**, and records **interaction-family targeting** as the preferred abstraction over raw-device binding. The docs also now include a concrete **Boxing + MediaPipe v1** chart-shape section with event vocabulary, timing guidance, symbolic portal/zone targeting, and a worked JSON example, while clarifying that view modes are primarily runtime presentation strategies.

**Reference Check:** `REF-01` through `REF-06` satisfied. The final docs are coherent with the existing architecture overview, provider-pattern input model, DSP/conductor timing guidance, input-agnostic gameplay framing, boxing gameplay semantics, and boxing choreography guidance. `REF-07` satisfied by placing the durable architecture writeup in `docs/architecture/content-model.md` and wiring it into `docs/index.md`.

**Commits:**
- None in this audit pass (no commits or pushes performed)

**Lessons Learned:** Centralizing the content architecture in a dedicated `content-model.md` doc made the hierarchy and portability rules easier to verify than scattering the decisions across gameplay-specific pages.

---

*Completed on 2026-04-20*
