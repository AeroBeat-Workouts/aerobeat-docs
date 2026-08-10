# AeroBeat Camera Tracking Platform — Boundaries and Assumptions

## Proposed repos

### 1. `aerobeat-vendor-mediapipe-python`
Owns:
- Python sidecar/runtime
- vendor-specific startup/shutdown
- vendor-specific camera enumeration
- vendor-specific tracking frame production
- vendor-specific preview stream production
- vendor-specific config translation and health checks

Does not own:
- consumer scene UI
- gesture/gameplay interpretation
- cross-vendor lifecycle semantics

### 2. `aerobeat-tool-camera-tracking`
Owns:
- singleton/service lifecycle
- live/replay source coordination
- backend selection
- preview contract
- normalized tracking frame contract
- `start/stop/change/list` semantics
- camera tracking state machine and errors

Does not own:
- vendor implementation details
- gameplay gesture interpretation
- environment/coaching-specific UX

### 3. `aerobeat-input-camera-tracking`
Owns:
- transforming normalized tracking frames into gestures / gameplay primitives
- boxing + flow interpretation
- proving scenes for boxing and flow
- integration with `input-core` contracts

Does not own:
- vendor process/runtime lifecycle
- generic camera preview lifecycle
- generic replay/video playback lifecycle

### 4. `aerobeat-vendor-godot-video`
Owns:
- Godot-specific video playback implementation details
- format support realities/quirks for the Godot backend
- low-level playback surface behavior for that backend

Does not own:
- tracking logic
- generic playback lifecycle contract
- environment or coaching feature policy

### 5. `aerobeat-tool-video-player`
Owns:
- singleton/service playback lifecycle
- play/pause/stop/seek/load contract
- output surface binding contract
- normalized playback state and errors
- reusable video service for replay, environments, and coaching

Does not own:
- tracking extraction logic
- vendor-specific playback internals
- gameplay gesture interpretation

---

## Core assumptions to confirm

1. `tool-camera-tracking` is the single owner for camera tracking lifecycle.
2. `tool-camera-tracking` also owns preview lifecycle so consumers stop reimplementing preview restart/rebind logic.
3. Preview ownership should use direct surface attachment (`attach_preview_surface(node)`), with the singleton responsible for preserving aspect-ratio-safe presentation inside the provided Godot UI slot/container.
4. `input-camera-tracking` should consume a vendor-neutral tracking frame contract and not know whether the backend is Python or native.
5. Replay remains a camera-tracking source mode, configured as `source.kind = "video_file"`, while reusable playback controls/lifecycle live in `tool-video-player`.
6. `tool-camera-tracking` may depend on `tool-video-player` through GodotEnv for replay mode rather than reimplementing playback ownership itself.
7. `tool-video-player` is justified because replay is not the only consumer; environments and coaching video playback also need it.
8. The same “tool + vendor” pattern is likely to be reused later for audio/music/SFX, so lifecycle/state conventions should be standardized early.
9. State-machine enums/conventions should be standardized now, before implementation begins.
10. The first migration step should wrap and stabilize contracts before large code moves.

---

## Invariants I’m assuming

- Tool repos own **contracts + lifecycle truth**.
- Vendor repos own **backend-specific implementation**.
- Input repos own **gameplay interpretation**.
- Consumer testbeds should not own low-level restart choreography long-term.
- Preview coordinate contracts should be standardized once, not rediscovered per consumer.
- A tool singleton must expose both push and pull surfaces:
  - signals/events for changes
  - getters for current state

---

## Open questions for Derrick

1. Should `input-camera-tracking` keep repo-local proving scenes that use both `tool-camera-tracking` and `vendor-mediapipe-python` through GodotEnv, or should some proving scenes move down into the tool/vendor repos too?
2. For multiple vendor backends, should backend selection be config-only, or can repos instantiate specific backends in tests for deterministic coverage?
3. Do we want a shared enum namespace/module for tool singleton states, or just duplicated but identical string enums per tool repo at first?

---

## Suggested migration order

1. Approve/edit these boundaries.
2. Lock `CameraTracking` API.
3. Lock `VideoPlayer` API.
4. Implement `tool-camera-tracking` contract shell.
5. Wrap `vendor-mediapipe-python` behind that contract.
6. Rename/migrate `input-mediapipe-python` → `input-camera-tracking`.
7. Implement `tool-video-player` + `vendor-godot-video`.
8. Migrate replay/environment/coaching consumers.
