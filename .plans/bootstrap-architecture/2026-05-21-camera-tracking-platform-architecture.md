# AeroBeat Camera Tracking Platform Architecture

**Date:** 2026-05-21  
**Status:** Draft  
**Agent:** Cookie 🍪

---

## Goal

Draft the repo-boundary and singleton-contract documents for the new camera-tracking/video platform split, surface key assumptions for Derrick to confirm or change, and prepare clean implementation planning after review.

---

## Overview

Derrick created the new GitHub repos for a platform split around vendor/tool/input responsibilities:
- `aerobeat-vendor-mediapipe-python`
- `aerobeat-tool-camera-tracking`
- `aerobeat-input-camera-tracking`
- `aerobeat-vendor-godot-video`
- `aerobeat-tool-video-player`

The architecture intent is to stop duplicating lifecycle, preview, replay, and contract logic across proving scenes and consumer repos. The camera-tracking layer should own tracking lifecycle and preview contract, the input layer should translate normalized tracking frames into gestures/gameplay primitives, and the video-player layer should become a reusable media service for replay, environments, and coaching videos.

These new repos are not yet cloned into the local AeroBeat workspace, so this planning/documentation pass is temporarily anchored in the coordinating repo `openclaw-cookie`. Once Derrick confirms the assumptions and the repos exist locally, the approved docs can be copied into the appropriate repo homes and turned into implementation work plans.

---

## REFERENCES

| ID | Description | Path |
| --- | --- | --- |
| `REF-01` | Prior camera-tracking architecture discussion in this session | current chat context |
| `REF-02` | New GitHub repos created by Derrick | current chat context |
| `REF-03` | Earlier MediaPipe/input architecture memories | `Source: memory/2026-02-06-1742.md#L1-L42`, `Source: memory/2026-02-11.md#L90-L108` |

---

## Tasks

### Task 1: Draft repo-boundary and architecture assumptions document

**Bead ID:** `Pending`  
**SubAgent:** `human/assistant planning`  
**Role:** `architect`  
**References:** `REF-01`, `REF-02`, `REF-03`  
**Prompt:** Draft a review-first architecture document that states the proposed repo responsibilities, explicit assumptions, invariants, and open questions Derrick should confirm before implementation planning starts.

**Files Created/Deleted/Modified:**
- `.plans/aerobeat-architecture/BOUNDARIES-AND-ASSUMPTIONS.md`

**Status:** ✅ Complete

**Results:** Initial draft created for review.

---

### Task 2: Draft first-pass `CameraTracking` singleton contract

**Bead ID:** `Pending`  
**SubAgent:** `human/assistant planning`  
**Role:** `architect`  
**References:** `REF-01`, `REF-02`  
**Prompt:** Draft a first-pass API/contract document for the `aerobeat-tool-camera-tracking` singleton, including state machine, config model, preview contract, tracking frame contract, replay/live source model, and backend abstraction assumptions.

**Files Created/Deleted/Modified:**
- `.plans/aerobeat-architecture/CAMERA-TRACKING-API.md`

**Status:** ✅ Complete

**Results:** Initial draft created for review.

---

### Task 3: Draft first-pass `VideoPlayer` singleton contract

**Bead ID:** `Pending`  
**SubAgent:** `human/assistant planning`  
**Role:** `architect`  
**References:** `REF-01`, `REF-02`  
**Prompt:** Draft a first-pass API/contract document for the `aerobeat-tool-video-player` singleton, including lifecycle state machine, playback contract, surface/output binding, and relationship to replay-based camera tracking.

**Files Created/Deleted/Modified:**
- `.plans/aerobeat-architecture/VIDEO-PLAYER-API.md`

**Status:** ✅ Complete

**Results:** Initial draft created for review.

---

### Task 4: Prepare implementation-planning checkpoints for post-review work

**Bead ID:** `Pending`  
**SubAgent:** `human/assistant planning`  
**Role:** `architect`  
**References:** all above  
**Prompt:** Record the proposed migration order and explicit confirmation gates so Derrick can approve assumptions before repo-local implementation plans and beads are created.

**Files Created/Deleted/Modified:**
- this plan file

**Status:** ✅ Complete

**Results:** Migration order and confirmation gates captured below.

---

## Proposed Review Gates

Derrick should explicitly confirm or edit these before implementation planning/work begins:

1. Repo boundaries are correct, especially:
   - `tool-camera-tracking` owns preview + lifecycle + replay/live source coordination
   - `input-camera-tracking` owns gesture/gameplay interpretation only
   - `tool-video-player` is a reusable media service rather than just a tracking detail
2. `CameraTracking` should expose a vendor-agnostic tracking frame contract.
3. `CameraTracking` should own direct preview-surface attachment and preserve aspect ratio within arbitrary Godot UI slots/containers.
4. Replay should enter camera tracking through source-kind/config (`source.kind = "video_file"`), while `tool-camera-tracking` consumes `tool-video-player` for playback lifecycle.
5. State machine conventions should be standardized across tool singletons early.
6. Initial implementation order should be:
   - docs/contracts
   - `tool-camera-tracking`
   - `vendor-mediapipe-python`
   - `input-camera-tracking`
   - `tool-video-player` + `vendor-godot-video`
   - consumer migrations

---

## Final Results

**Status:** ⚠️ Awaiting Derrick review

**What We Built:** Draft planning docs only; no implementation work started.

**Reference Check:** Architecture assumptions are derived from the current session’s design discussion plus earlier MediaPipe/input architecture context.

**Commits:**
- None.

**Lessons Learned:** For a platform split like this, clean repo boundaries and singleton contracts need explicit review before migration planning, otherwise the same lifecycle ambiguity just gets redistributed under new names.

---

*Last updated on 2026-05-21*
