# 💃 Gameplay Core: "Dance"

The `Dance` module brings full-body choreography matching to AeroBeat.

This gameplay surface now assumes the approved first-pass Dance chart contract: authored charts store the expected move over time in a flat `beats:` list, while scoring/classifier logic, cue systems, and coach presentation stay outside the chart row.

### The Loop

1.  **The Beat:** The chart names the current expected Dance move for the active beat window.
2.  **The Action:** A virtual coach performs the move and the athlete mirrors it.
3.  **The Feedback:** Runtime motion matching evaluates accuracy and timing.
4.  **The Workout:** Full-body cardio, coordination, rhythm, and flexibility.

### Authored chart contract

Dance charts follow the same shared envelope direction as Boxing and Flow:

```yaml
feature: dance
beats:
  - start: 8.0
    type: step_touch
  - start: 12.0
    end: 15.0
    type: hold_pose
    gold: true
  - start: 20.0
    type: spin
```

Per-row meaning is intentionally small:

- `start` — required beat-domain start
- `end` — optional inclusive sustained window end
- `type` — required durable move identifier
- `gold` — optional authored emphasis marker

### Mechanics

*   **The Coach:** A 3D avatar or equivalent presentation layer that demonstrates the current move.
*   **Move Matching:** Runtime systems compare the athlete's movement against the active move window.
*   **Gold Moves:** Rows marked with `gold: true` are specially highlighted moments.
*   **Preview/Cues:** Pictograms, dance cards, countdowns, and other read-ahead systems are presentation-layer features that consume chart data rather than expanding the chart row itself.

### Contract boundary

The Dance chart row owns only:

- expected move identity
- authored timing window
- optional Gold emphasis

The Dance feature/runtime owns:

- classifier or pose-matching interpretation
- scoring thresholds and feedback logic
- coach behavior
- pictogram/cue systems
- media/camera/controller adaptation

### Input Methods

#### 1. Camera / Computer Vision (Recommended)

For the most authentic experience, use a Webcam or Phone Camera.

*   **Technology:** MediaPipe Pose or equivalent body-tracking runtime.
*   **Requirement:** **Full Body View.** Unlike Boxing, Dance expects the runtime to observe hands, torso, and feet well enough to interpret the active move.
*   **Feedback:** Mirror-mode athlete feedback can sit beside or under the coach presentation.

#### 2. VR (Immersive)

*   **Tracking:** Headset, controllers, and optional extra body tracking.
*   **Limitation:** Runtime interpretation may need to infer lower-body fidelity when no dedicated trackers are present.
*   **Experience:** You stand in the scene with the coach while still following the same authored chart truth.

#### 3. JoyCon / Phone (Motion Controller)

*   **Tracking:** Uses handheld IMU data.
*   **Style:** Similar to console dance-game controller modes.
*   **Limitation:** Runtime scoring may focus more on timing, rhythm, and arm energy than exact whole-body pose fidelity.

### View Modes

*   **Studio View (2D):** The Coach is center stage, with optional preview/cue surfaces and athlete camera feedback.
*   **Stage View (VR):** The athlete shares the performance space with the coach while the same authored Dance move windows drive the experience.
