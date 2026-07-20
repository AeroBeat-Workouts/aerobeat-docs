# Performance Architecture

AeroBeat's current performance story should match the actual product slice:

- **camera-first gameplay**
- **BeatSaver-powered Boxing + Flow**
- **PC-first community release**
- later mobile follow-on, with VR no longer treated as the default design center

This page is intentionally about the **current direction**, not the older broad "mobile + VR + rich UGC everywhere" architecture story.

## Current performance priorities

### 1. Stable gameplay timing beats flashy rendering

The most important performance rule is still simple:

- gameplay timing must stay stable
- camera input, note timing, and obstacle evaluation must not hitch under normal play
- expensive work belongs **before gameplay** or **after gameplay**, not inside the active song loop

For the current BeatSaver-powered direction, a dropped frame is not just a visual blemish. It can corrupt:

- direct 4x3 Flow cell-entry timing
- Boxing hit timing
- wrist-motion direction checks
- obstacle/bomb avoidance windows

## 2. Keep the active song loop lightweight

During active play, AeroBeat should avoid doing new heavyweight work such as:

- downloading content
- unpacking large archives
- media transcoding
- first-time package conversion
- broad package rescans
- synchronous scene/material churn that can be staged earlier

### Practical implication for the current product slice

BeatSaver acquisition and conversion should be treated as **pre-play preparation work**, not something we casually push into the live song path.

That means the runtime should prefer this order:

1. acquire/import the source package
2. normalize or convert what needs converting
3. prepare the local playable artifact
4. only then enter gameplay

This matches the newer imported-player architecture better than the older always-online or cloud-heavy assumptions.

## 3. Optimize for camera gameplay first

The active runtime is not a generic renderer-first rhythm shell anymore. It is a **camera gameplay system**.

That means the hottest path is dominated by:

- camera frame ingestion
- landmark/pose extraction
- direct gameplay-state derivation from those landmarks
- chart timing / hit-window evaluation
- lightweight note and obstacle presentation

### Consequence

Performance work should prioritize reducing cost in the camera-input path before spending major effort on richer scene complexity.

Examples:

- keep pose-processing work predictable per frame
- avoid unnecessary landmark/history bookkeeping
- keep Flow 4x3 hit detection and Boxing checks simple and deterministic
- prefer cheaper debug visualizations that can be disabled cleanly

## 4. Presentation should fit the PC-first + webcam-first slice

The current docs no longer assume that AeroBeat's main value comes from heavy VR-style presentation.

For the active slice, performance guidance should bias toward:

- clean 2D backgrounds first
- lightweight video backgrounds second
- heavier 3D/advanced environment lanes only when they stay honest about device scope

This matches the newer package/customization cleanup:

- imported-player song packages should not be treated like freeform environment-asset bundles
- environment choice is no longer the center of the BeatSaver-powered path
- advanced environment types may still exist, but they are not the baseline assumption performance planning should optimize around

## 5. Package/media preparation should stay conservative

The current imported-player direction is deliberately simpler:

- preserve source provenance under `.artifacts/`
- use normalized runtime media for actual playback
- keep the playable package self-contained

From a performance perspective, that means:

- prefer one runtime-canonical audio format for playback
- avoid repeated on-the-fly media interpretation when a normalized asset can be prepared once
- treat provenance storage as a tooling/debug concern, not a hot runtime path

## 6. Avoid broad public-customization assumptions in the renderer

Older architecture drift sometimes assumed a much larger package-local customization surface.

That is not the current center of gravity.

Performance planning should therefore **not** assume that every gameplay session must support a huge mix of arbitrary runtime-swapped package assets. The current direction is narrower and easier to optimize:

- official/manual-authored workout packages have a controlled package contract
- BeatSaver-derived play should center on converted song/chart playback
- cosmetics/customization should not quietly reopen an unbounded gameplay render surface in these docs

## 7. Quality targets should be phrased honestly

The old page taught fixed targets like "90 FPS VR" as if VR were still the main design anchor.

Current truthful guidance is simpler:

- **PC-first:** prioritize smooth camera gameplay on ordinary desktop hardware
- **mobile later:** keep future mobile cost in mind, but do not distort the current architecture around hypothetical parity
- **VR later if it returns:** treat VR as a future-expansion concern, not the present performance contract

If concrete frame budgets are needed later, they should be set from measured implementation reality rather than inherited from the older cross-platform pitch.

## 8. What to measure first

For the current product slice, the most useful performance instrumentation should answer:

- how expensive is camera/pose processing per frame?
- how stable is the gameplay loop during dense BeatSaver charts?
- do imported/converted assets cause first-play hitches?
- do backgrounds or advanced environments materially harm gameplay stability?
- do debug overlays materially distort camera-gameplay performance?

Those questions are more important right now than legacy platform-wide render-budget tables.

## Current recommendation

AeroBeat should treat performance architecture as a **camera-gameplay stability problem first** and a **presentation-scale problem second**.

That means:

- prepare content before play
- keep the live song loop small and predictable
- optimize the direct 4x3 Flow + Boxing camera path first
- prefer lightweight background defaults
- keep advanced environment/customization lanes honest and controlled

That is the performance posture that best matches the current BeatSaver-powered product direction.
