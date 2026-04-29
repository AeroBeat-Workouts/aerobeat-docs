# Accessibility Guide

AeroBeat is designed to be fitness for *everyone*. Whether you are recovering from an injury, playing from a wheelchair, or just having a low-energy day, the game adapts to you—not the other way around.

## 👂 Listen to Your Body

The most important rule in AeroBeat is: **Do what feels right.**

Our scoring system is designed to be permissive.

*   **Fitness Moves:** High-intensity moves like "Run in Place" or "Leg Lifts" in Flow mode are not strictly scored on limb movement. If a move feels unsafe, modify it (e.g., stretch instead of run).
*   **Range of Motion:** You can calibrate your arm span to ensure targets are within comfortable reach.

## ⚙️ Gameplay Modifiers

Before starting a Workout, you can enable specific modifiers to tailor the session to your needs.

*   **No Squats:** Disables obstacles (Walls/Bars) that force you to squat or duck.
*   **No Knee Strikes:** Removes Knee Strike targets from Boxing Workouts.
*   **No Leg Lifts:** Removes balancing obstacles from Flow Workouts.
*   **No Obstacles:** Removes all walls and barriers entirely.
*   **No Arrows:** Removes the directional requirement. You can hit targets from any angle (great for limited wrist mobility).
*   **No Trails & Warnings:** Removes `trail_*` and `warn_*` guidance beats for athletes who want simpler primary swing reads.
*   **Zen Mode:** Disables all targets and scoring. Just enjoy the music and the environment.

## 🪑 Seated Play

AeroBeat is fully playable while seated.

1.  **Calibration:** When running the **Calibration Wizard**, perform the "T-Pose" step while seated. This tells the engine where your head and hands are relative to your chair.
2.  **VR Recenter:** If playing in VR, use the "Recenter" button while looking forward in your comfortable seated position.
3.  **Head Height:** The game dynamically adjusts "High" and "Low" targets based on your calibrated head height, so you won't have to reach impossibly high.

## 🛡️ Safety & Substitution

Our tracking system is built to allow for safe substitutions.

### Knee Strikes (Boxing)

In Boxing mode, the game does not track your legs. It tracks your **Head Position**.

*   **The Logic:** To hit a "Left Knee" target, the game expects your weight to shift to the left.
*   **The Modification:** If you cannot lift your knee, you can substitute the move with a **Side Crunch** or a **Block**. As long as your head moves to the target lane, it counts!

### Obstacles (Walls)

*   **The Logic:** Collision is checked only against your **Head**.
*   **The Modification:** You do not need to contort your whole body. A slight lean of the head is often enough to clear a wall. Don't over-extend!

## 🎮 Input Flexibility

Because AeroBeat is **Input Agnostic**, you can choose the controller that fits your mobility.

*   **Camera (Hands Free):** Great if holding a controller is difficult.
*   **Touch/Mouse:** Allows playing the game with minimal physical exertion, focusing on reaction time rather than cardio.
*   **Adaptive Controllers:** Since we support generic Gamepads (XInput), devices like the **Xbox Adaptive Controller** should work out of the box.
    *   *Need a specific integration?* If you have a specialized device that isn't working, please reach out to our engineering community on GitHub or Discord. As an open-source project, we are eager to build drivers that help you play.