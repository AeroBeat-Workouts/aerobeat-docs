# AeroBeat Camera Tracking Platform — Next Session Handoff

## Start here

Read these docs first:
- `/workspace/projects/openclaw-cookie/.plans/aerobeat-architecture/2026-05-21-camera-tracking-platform-architecture.md`
- `/workspace/projects/openclaw-cookie/.plans/aerobeat-architecture/BOUNDARIES-AND-ASSUMPTIONS.md`
- `/workspace/projects/openclaw-cookie/.plans/aerobeat-architecture/CAMERA-TRACKING-API.md`
- `/workspace/projects/openclaw-cookie/.plans/aerobeat-architecture/VIDEO-PLAYER-API.md`
- `/workspace/projects/openclaw-cookie/.plans/aerobeat-architecture/IMPLEMENTATION-PHASES.md`

## Locked decisions from Derrick

Approved architecture split:
- `aerobeat-vendor-mediapipe-python`
- `aerobeat-tool-camera-tracking`
- `aerobeat-input-camera-tracking`
- `aerobeat-vendor-godot-video`
- `aerobeat-tool-video-player`

Approved defaults:
- `tool-camera-tracking` owns lifecycle, preview attachment, live/replay coordination, and normalized tracking frame contract.
- Preview ownership uses direct `attach_preview_surface(node)` and should preserve aspect ratio inside the provided Godot slot/container.
- Replay enters tracking via `source.kind = "video_file"`.
- `tool-camera-tracking` may depend on `tool-video-player` through GodotEnv for replay mode.
- `input-camera-tracking` consumes tracking frames and converts them into gestures/gameplay primitives; it should not care which backend produced the tracking data.
- State enums/conventions should be standardized before implementation starts.
- Backend selection is config-first for product/runtime use; tests may instantiate specific backends directly when needed.
- Default `change(config)` semantics should use a full stop boundary.
- Preview attachment is single-surface only in v1.
- Start with identical string enums across tool repos; extract a shared helper later only if duplication becomes painful.

## Important workspace reality

The new GitHub repos exist remotely, but were **not yet cloned locally** in `/workspace/projects/aerobeat/` during this session.

That is why the planning docs currently live temporarily in:
- `/workspace/projects/openclaw-cookie/.plans/aerobeat-architecture/`

Once the repos are cloned locally, copy/move the approved docs into their proper repo homes before starting real implementation planning there.

## Recommended next move

1. Clone the five new repos locally under `/workspace/projects/aerobeat/`.
2. Copy the approved planning docs into the correct repo homes.
3. Start implementation planning in `aerobeat-tool-camera-tracking` first.
4. First implementation slice should be contract shell only:
   - singleton class
   - state enum/constants
   - signals
   - config model helpers
   - backend interface
   - fake backend for tests
   - preview attachment contract
   - tracking frame contract stub
5. Only after that begin wrapping `aerobeat-vendor-mediapipe-python`.

## Current unfinished/paused work

The previous camera-gesture quality-switch GUI crash lane is **not resolved** in real manual QA. However, Derrick explicitly chose to pause that firefight and pivot to the cleaner architecture split in a fresh session.

Most recent crash-forensics conclusion before pausing:
- the strongest remaining crash surface appeared consumer-owned in `aerobeat-tool-camera-gesture-control`
- but further debugging was intentionally paused in favor of the platform refactor

Do **not** resume that firefight by default in the next session unless Derrick explicitly asks to.

## Why this handoff exists

The main goal for the next session is to begin the new architecture with a clean context window, not to continue ad hoc bug repair inside the old shape.
