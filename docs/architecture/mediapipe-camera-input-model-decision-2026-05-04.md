# MediaPipe Camera Input Model Decision

**Date:** 2026-05-04  
**Scope:** `aerobeat-input-mediapipe-python` feeding AeroBeat Boxing + Flow for forward-facing TV play  
**Decision:** **Choose Option A — gesture / intent-first camera input**. Reject Option B as the v1 contract.

---

## Executive recommendation

For the current AeroBeat v1 camera path, the runtime contract should be **intent-first**, not **3D-skeleton-first**.

The MediaPipe Python path can truthfully provide:
- normalized pose landmarks from a single RGB camera
- relative depth-ish `z` values on those normalized landmarks
- landmark visibility/confidence
- enough signal to derive **camera gameplay intents** like left/right punch, guard, squat, lean, lane shift, and broad flow-swing direction, while leaving authored stance semantics above the tracked input-event layer

The current AeroBeat path does **not** truthfully provide a clean gameplay-grade 3D skeleton contract yet because:
- the current sidecar serializes only normalized landmark tuples (`x`, `y`, `z`, `v`)
- the Godot provider exposes those as 2D points or a `Vector3(x, y, z)` without calibrated world semantics
- no explicit world-landmark stream is serialized today
- no stable body-space calibration, floor plane, player scale, or orientation-normalized skeleton contract exists today
- no validated velocity/rotation contract exists today

So the v1 design should be:
1. **MediaPipe provider owns raw camera landmark acquisition plus camera-specific intent derivation**
2. **input-core owns the feature-facing intent/event contracts**
3. **Boxing and Flow consume those intents, not a fake universal 3D skeleton**
4. **future VR/direct-skeleton paths plug in later through a separate richer body-state layer without forcing today’s camera path to pretend it already has it**

---

## Truth today vs future path

### Truth today: what MediaPipe Python can claim

For the current AeroBeat implementation, the practical truth is:
- `python_mediapipe/main.py` uses MediaPipe Pose Landmarker and sends landmark packets containing `id`, `x`, `y`, `z`, `v`
- `src/providers/mediapipe_provider.gd` turns those into:
  - `Vector2(x, y)` for `MODE_2D`
  - `Vector3(x, y, z)` for `MODE_3D`
- that `MODE_3D` value is **not a validated AeroBeat world-space gameplay contract**; it is only a forwarded landmark triple from the camera path
- the repo README already truthfully says gesture callbacks, velocity, rotation, and full transform output are not implemented

Additional important truth:
- the underlying MediaPipe Python Tasks API appears capable of returning `pose_world_landmarks`
- however, **the current AeroBeat MediaPipe Python path does not serialize or expose them**
- therefore AeroBeat should not describe its current MediaPipe Python gameplay contract as world-space or direct-skeleton-grade

### Future upgrade path

A future camera upgrade may explicitly add:
- serialized world landmarks from MediaPipe
- body-relative normalization/orientation solving
- derived velocities in a documented unit space
- calibration rules for player scale, floor, and play volume

But that is **future work**, not present contract truth.

---

## Option comparison

### Option A — gesture / intent-first camera input

**Definition:** The provider’s shipping contract is not “here is a gameplay skeleton.” It is “here are trustworthy camera-derived gameplay intents and optional raw landmark snapshots.”

**Pros**
- matches what the current path can honestly infer
- aligns with camera-first Boxing + Flow gameplay
- keeps feature repos focused on authored move semantics, not CV cleanup
- lets the provider absorb camera-specific heuristics, thresholds, smoothing, and recovery behavior
- de-risks false precision around 3D depth and orientation
- preserves a clean future VR path by treating intent as one layer and richer body state as an optional later layer

**Cons**
- camera provider must own more domain-specific inference than a pure transport adapter
- some authored move families may need careful simplification around what camera can reliably distinguish
- future direct-skeleton consumers will need an additional richer contract instead of reusing the exact v1 camera contract wholesale

### Option B — 3D skeleton-first camera input

**Definition:** The provider’s main contract is a meaningful gameplay skeleton/body-state abstraction, with Boxing and Flow deriving their own move logic primarily from that skeleton.

**Pros**
- elegant on paper
- superficially lines up with a later VR path
- centralizes body representation before feature logic

**Cons**
- over-claims the current path unless AeroBeat first solves world/body-space semantics explicitly
- pushes calibration/orientation/occlusion ambiguity onto all downstream consumers
- encourages Boxing and Flow to depend on noisy low-level geometry instead of stable gameplay intents
- makes “3D” sound stronger than the current runtime really is
- increases tuning burden and feature duplication across Boxing and Flow

**Verdict:** reject as the v1 contract.

---

## Why a 3D-skeleton-first contract is the wrong v1 choice

A meaningful gameplay skeleton contract needs more than “33 landmarks with x/y/z.” For AeroBeat it would need, at minimum:
- clear coordinate semantics
- player/body orientation handling
- confidence/quality semantics per inferred joint or region
- stable velocity semantics
- calibration assumptions for distance, scale, and floor/body center
- rules for lost tracking, partial occlusion, and camera angle drift

The current path does not provide that package.

Even if MediaPipe world landmarks are added later, a single forward-facing consumer camera still carries risks:
- self-occlusion during guard, hooks, cross-body motion
- reduced depth confidence during fast punches
- camera placement variability between TVs, desks, and laptops
- inconsistent framing distance across users
- lower-body ambiguity for knees, squats, and run-in-place
- body yaw/stance changes changing projection quality

Those are manageable for **intent detection**. They are much more dangerous if the official contract says features can trust a stable gameplay 3D skeleton.

---

## Recommended model: sharp hybrid, not vague hybrid

The best answer is a **two-layer hybrid with a single official v1 contract**:

### Layer 1 — provider raw observation layer
Owned by `aerobeat-input-mediapipe-python`.

Contains:
- normalized pose landmarks
- visibility/confidence
- provider health/tracking state
- optional future raw extras such as world landmarks, segmentation, or timestamps

This layer is **provider-specific** and should not be the main Boxing/Flow gameplay contract.

### Layer 2 — provider-derived gameplay intent layer
Owned jointly by `aerobeat-input-mediapipe-python` and `aerobeat-input-core` by responsibility split.

Contains camera-derived intents such as:
- lateral position: `left`, `center`, `right`
- height state: `stand`, `squat`
- guard state: enter/hold/exit
- punches: `punch_left`, `punch_right`, `hook_left`, `hook_right`, optional later `uppercut_left/right`
- body movement: `lean_left`, `lean_right`, `duck`, `run_in_place`, `knee_left/right`
- flow motion intents: `swing_left`, `swing_right`, directional slice family, trail continuation, warning/reward pass-through support if needed
- confidence and timestamps for each emitted intent

This is the **official v1 gameplay-facing contract**.

### Not official v1 contract
A generic “gameplay skeleton” that Boxing and Flow must reinterpret themselves.

That is the sharp boundary.

---

## What the runtime/input contracts should say

### `aerobeat-input-mediapipe-python`

Should say:
- this repo is the **official current camera gameplay provider** for PC-first AeroBeat
- it provides raw camera tracking plus **camera-derived gameplay intents** for Boxing and Flow
- its raw landmark stream is normalized camera-relative pose data
- any returned `Vector3` landmark data is **not automatically a gameplay-grade world-space skeleton contract**
- optional future world-landmark/body-space support requires separate contract/versioning

Should **not** say:
- that the repo already provides a universal 3D skeleton gameplay contract
- that `MODE_3D` means world-calibrated gameplay space
- that downstream features should derive their own core move detection directly from raw landmarks by default

### `aerobeat-input-core`

Should say:
- the v1 official feature-facing contract is **intent-first for camera gameplay**
- providers may optionally expose raw observation data
- richer body-state / skeleton contracts are optional extensions, not the required v1 baseline

Recommended contract shape:
- keep base provider lifecycle and tracking health
- keep optional raw query surface for landmarks
- define explicit feature-facing event/state contracts for Boxing and Flow
- rename or document current `MODE_3D` semantics so consumers cannot mistake it for validated world-space
- gate any future “body state” or “world skeleton” interface behind a separate capability/version, not the baseline provider contract

### Feature repos (`boxing`, `flow`)

Should say:
- features consume **input intents** matched to authored move families
- they do not own raw pose interpretation as their main runtime burden
- they may optionally inspect debug/raw provider data for tooling or tuning, but that is not the gameplay contract

---

## Boxing consumption model

Boxing should consume a **boxing-intent stream**, not a skeleton.

### Boxing needs from input
- punch family events aligned to authored beat types:
  - `punch_left`
  - `punch_right`
  - `hook_left`
  - `hook_right`
  - later optional `uppercut_left/right`
- hold/state events:
  - `guard_start`, `guard_end`
  - `height_changed`
  - `location_changed`
- lower-body/body-movement events when supported:
  - `squat`
  - `lean_left/right`
  - `knee_left/right`
  - `run_in_place_start/active/end`

### Boxing repo should own
- authored beat matching windows
- scoring/judgement against beat timing
- combo, feedback, and presentation
- per-chart tolerances if needed

### Boxing repo should not own by default
- raw wrist/elbow/shoulder geometry heuristics
- camera-angle compensation logic
- MediaPipe-specific smoothing or recovery heuristics

---

## Flow consumption model

Flow should consume a **flow-intent stream** tuned for continuous motion.

### Flow needs from input
- swing/slice direction family
- follow-through continuity
- body-movement states for squat/lean/knee/run prompts
- broad hand/arm path classification with confidence

For v1 camera play, Flow likely needs fewer “precise 3D blade” semantics and more:
- readable left/right/up/down or quadrant-style arm travel
- sustained trail detection
- body shift/height changes
- confidence-aware acceptance windows

### Flow repo should own
- authored beat interpretation
- trail/hold scoring
- combo, feedback, and motion-chain rules
- any feature-specific forgiveness windows

### Flow repo should not own by default
- primary landmark denoising
- per-camera pose reconstruction
- base directional classifier heuristics

---

## Repo ownership split

### `aerobeat-input-mediapipe-python`

Owns:
- MediaPipe runtime integration
- raw landmark capture/transport
- provider health and tracking-loss behavior
- camera-specific smoothing/filtering
- camera-specific derived-intent inference for Boxing/Flow
- confidence estimates and degraded-mode fallback behavior
- optional raw debug snapshots for tuning

Does **not** own:
- authored beat timing/judgement
- feature scoring rules
- package/chart semantics

### `aerobeat-input-core`

Owns:
- stable provider interfaces
- stable Boxing/Flow intent contracts
- capability/version semantics
- naming and documentation for raw-vs-intent-vs-future-body-state layers
- input manager selection and provider identity behavior

Does **not** own:
- MediaPipe-specific thresholds or CV heuristics
- feature-scoring logic

### `aerobeat-feature-boxing` and `aerobeat-feature-flow`

Own:
- consuming the stable intent contracts
- authored move matching
- hit windows, combo, and feedback
- feature-side tuning of judgement strictness

Do **not** own:
- foundational camera pose inference
- duplicated provider-specific classifiers

---

## Clean future VR/direct-skeleton path

Choosing intent-first now does **not** block VR later.

The clean path is:
1. keep v1 feature contracts expressed in gameplay intent terms
2. later add a richer optional contract, e.g. `BodyStateProvider` or `TrackedBodyProvider`
3. let VR/native tracked systems implement both:
   - direct rich body state
   - the same Boxing/Flow intent outputs
4. if a future feature truly needs direct skeleton semantics, version that separately instead of retroactively redefining the camera baseline

That preserves:
- camera-first v1 truth
- feature portability
- a stronger future tracked-body lane

In other words: **VR can emit intents from rich tracking; camera should not fake rich tracking just to look architecturally symmetric.**

---

## Exact contract consequences after this decision

1. **Do not treat current MediaPipe `MODE_3D` as official gameplay-world semantics.**
2. **Define Boxing and Flow around intent events/states as the official v1 input contract.**
3. **Keep raw landmarks available as provider/debug data, not the feature contract.**
4. **Move camera interpretation into the MediaPipe provider lane, not each feature repo.**
5. **Reserve a separate future contract for true tracked-body / world-space semantics.**
6. **Document current truth plainly:** normalized camera-relative landmarks today; richer body-space tomorrow only if explicitly implemented and validated.

---

## Implementation sequence

### Phase 1 — contract correction
1. Update docs and `aerobeat-input-core` wording so current raw 3D values are not described as world-space gameplay truth.
2. Define the official v1 Boxing and Flow intent/event vocabulary in `aerobeat-input-core`.
3. Mark raw landmark access as provider-level/optional.

### Phase 2 — MediaPipe intent layer
4. Implement provider-side intent detection in `aerobeat-input-mediapipe-python` for the minimum v1 set:
   - authored stance semantics stay above the tracked input-event layer
   - location
   - height/squat
   - guard
   - left/right straight punch plus hook family
   - lean left/right
   - basic flow swing direction family
5. Emit confidence/timestamped intent signals or state changes through the input-core contract.
6. Add degraded-mode behavior rules for low confidence / tracking loss.

### Phase 3 — feature integration
7. Update Boxing to consume Boxing intents mapped to authored YAML beat types.
8. Update Flow to consume Flow intents mapped to authored YAML beat types.
9. Keep feature repos responsible for judgement/scoring only.

### Phase 4 — future richer body-state lane
10. If later needed, add an explicitly separate body-state/world-landmark contract.
11. Only then evaluate whether camera world landmarks are good enough for any shared skeleton semantics.
12. Let VR/native tracked providers implement that richer lane first-class.

---

## Rejected alternative

**Rejected:** Option B — make the current MediaPipe Python camera path a 3D-skeleton-first gameplay contract.

**Reason:** it is architecturally attractive but not honest enough for the current implementation or reliable enough for the current product slice. It would push unstable geometry semantics downstream and make Boxing/Flow depend on a representation that sounds stronger than the present runtime actually is.

---

## Open questions

Only two questions remain worth explicit follow-up:
1. what is the exact minimum v1 Boxing punch vocabulary for camera reliability: `punch_left` / `punch_right` plus hooks, or a later-expanded subset that also adds uppercuts?
2. for Flow, should the first shipping contract be a small directional family (`left/right/up/down` + hold/trail states) before any finer motion taxonomy?

Those are tuning/scope questions, not blockers to the contract decision.
