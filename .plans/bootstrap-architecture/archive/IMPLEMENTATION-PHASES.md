# AeroBeat Camera Tracking Platform — Implementation Phases

## Locked defaults

These are now treated as approved assumptions unless Derrick changes them later:

- `tool-camera-tracking` owns lifecycle, preview attachment, replay/live source coordination, and the normalized tracking frame contract.
- Preview ownership uses direct surface attachment via `attach_preview_surface(node)`, while preserving aspect ratio inside the provided Godot UI slot/container.
- Replay enters camera tracking through `source.kind = "video_file"`.
- `tool-camera-tracking` may depend on `tool-video-player` through GodotEnv for replay mode.
- `input-camera-tracking` consumes tracking frames and produces gestures/gameplay primitives without caring which backend produced the tracking data.
- State-machine enums/conventions should be standardized before implementation begins.
- Backend selection is config-first for product/runtime usage; tests may instantiate specific backends directly when needed.
- `change(config)` should default to a full stop boundary unless a later backend-specific safe hot-change contract is explicitly introduced.
- Preview attachment is single-surface only in v1.
- Start with identical string enums across tool repos; extract a shared helper later only if duplication becomes painful.

---

## Recommended implementation order

### Phase 1 — Contract shells and repo bootstrap

Targets:
- `aerobeat-tool-camera-tracking`
- `aerobeat-tool-video-player`

Deliverables:
- repo-local architecture docs copied in
- singleton shell classes
- state enum/constants
- signal definitions
- config shape docs/helpers
- placeholder backend interfaces
- placeholder/fake test backends

Goal:
- make the contracts real before moving production logic

### Phase 2 — Vendor wrapper extraction for camera tracking

Targets:
- `aerobeat-vendor-mediapipe-python`
- `aerobeat-tool-camera-tracking`

Deliverables:
- move/wrap Python sidecar lifecycle behind backend adapter
- camera listing implementation
- preview descriptor/binding contract
- normalized tracking frame adapter
- start/stop/change/list lifecycle under the tool singleton
- initial live camera source mode working end-to-end

Goal:
- centralize the current camera lifecycle truth under the new tool/vendor split

### Phase 3 — Input layer migration

Targets:
- `aerobeat-input-camera-tracking`

Deliverables:
- rename/refactor current `input-mediapipe-python` role
- proving scenes for boxing/flow switched to use `CameraTracking` singleton
- gesture/gameplay interpretation moved to tracking-frame consumption instead of vendor-owned lifecycle logic

Goal:
- make the input repo backend-agnostic and contract-driven

### Phase 4 — Video playback tool/vendor extraction

Targets:
- `aerobeat-vendor-godot-video`
- `aerobeat-tool-video-player`

Deliverables:
- playback singleton shell + vendor wrapper
- play/pause/seek/load/surface binding contract
- first working local-file playback path via Godot backend
- state and error signaling

Goal:
- create the reusable playback service for replay, environments, and coaching

### Phase 5 — Replay integration into camera tracking

Targets:
- `aerobeat-tool-camera-tracking`
- `aerobeat-tool-video-player`

Deliverables:
- `source.kind = "video_file"` path in camera tracking
- camera tracking coordinated with video player lifecycle/time
- replay preview + playback controls available through the tracking stack

Goal:
- replace ad hoc replay logic with the new service split

### Phase 6 — Consumer migrations

Targets:
- `aerobeat-tool-camera-gesture-control`
- environments / coaching / other consumers

Deliverables:
- remove duplicated lifecycle/preview/restart logic from consumer testbeds
- migrate environment/workout playback to `tool-video-player`
- migrate coaching video flows to `tool-video-player`

Goal:
- eliminate duplicated contract work and lifecycle bugs from consumers

---

## First execution slice I recommend

Start here:
1. clone the new repos locally
2. add docs to:
   - `aerobeat-tool-camera-tracking`
   - `aerobeat-tool-video-player`
3. implement `tool-camera-tracking` contract shell first:
   - singleton class
   - state enum/constants
   - signals
   - config model helpers
   - backend interface class
   - fake backend for tests
4. only then begin wrapping `vendor-mediapipe-python`

Reason:
- if the contract is not nailed down first, the old lifecycle bugs will just move into the new repos under different names

---

## Risks to watch during implementation

- accidentally letting tool repos become thin wrappers that leak vendor behavior
- moving testbed-specific UX into tool repos
- letting replay and live camera lifecycle diverge too much in `tool-camera-tracking`
- failing to standardize coordinate-space truth in the tracking frame contract
- rebuilding preview ownership ambiguity across multiple repos again

---

## Suggested immediate next implementation plan

The first repo-local implementation plan should probably live in `aerobeat-tool-camera-tracking` and cover:
- repo bootstrap
- singleton contract shell
- backend interface
- fake backend + tests
- state enum/constants
- preview attachment contract
- tracking frame contract stub
