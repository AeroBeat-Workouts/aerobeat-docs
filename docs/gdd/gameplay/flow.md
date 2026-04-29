# 🌊 Gameplay Core: "Flow"

The "Flow" module focuses on large, continuous movements using virtual bats. It is designed to improve range of motion, core stability, and balance.

### The Loop
1.  **The Beat:** Flow charts author a flat `beats:` list under `feature: flow`.
2.  **The Action:** The athlete swings through beats using the authored `type`, `placement`, and optional `direction` guidance.
3.  **The Feedback:** Successful hits create a satisfying slice effect and maintain combo.
4.  **The Workout:** Focuses on core rotation, shoulder mobility, and lower body stability.

### Mechanics
*   **Bats:** The athlete wields two bats. Left is Black, Right is White.
*   **Primary Swing Families:** `swing_left`, `swing_right`, `trail_left`, `trail_right`, `warn_left`, `warn_right`, `reward_left`, and `reward_right`.
*   **Body-Movement Families:** `squat`, `lean_left`, `lean_right`, `knee_left`, `knee_right`, `leg_lift_left`, `leg_lift_right`, and `run_in_place`.
*   **Placement:** `placement` describes where around the athlete the beat passes.
*   **Direction:** `direction` describes swing/follow-through guidance. When omitted for `swing_*`, `trail_*`, and `warn_*`, it inherits from `placement`.
*   **No Guard:** There are no blocking targets in Flow mode.

### Obstacles & Fitness Prefabs
Flow keeps the authored chart shape flat rather than splitting a separate obstacle lane. Body-movement beats still live in the same `beats:` list.

*   **Squats and Leans:** Use `squat`, `lean_left`, and `lean_right`.
*   **Leg Lifts:** Use `leg_lift_left` and `leg_lift_right`.
*   **Run In Place:** Use `run_in_place`.
*   **Coaching Callouts:** For complex fitness moves, coaches are encouraged to verbally prepare the athlete for the weight shift, especially at lower difficulties.

### Portals
*   **Active Portal:** `portal` identifies the origin/presentation source when the beat needs explicit portal placement.
*   **Rotation:** Just like in Boxing, portals can appear 360 degrees around the player. The choreography should guide the player's rotation toward the next readable swing.

### View Modes
*   **Portal View:** Flow beats are rendered from their authored portal/placement relationship in 3D space.
*   **Track View:** The same authored beats can be adapted into track-like presentation without changing the chart contract.
