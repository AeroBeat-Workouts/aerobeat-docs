# Creating Flow Choreography

"Flow" is the art of continuous motion. Unlike the explosive, staccato rhythm of Boxing, Flow is about momentum, arcs, and slicing through the beat. Think of it as a mix of drumming and swordplay.

## 🛠️ The Flow SDK

*   **SDK:** `aerobeat-sdk-choreography-flow`
*   **Grid:** 4 Lanes (Standard), expandable to 360.
*   **Perspective:** 3D Portal View.

## ⚔️ Mechanics & Objects

### Targets (Cuts)
*   **Color Coding:**
    *   **Black:** Left Hand (Bat/Saber).
    *   **White:** Right Hand (Bat/Saber).
*   **Direction:** The arrow dictates the **Cut Direction**.
    *   *Down Arrow:* Swing from Top to Bottom.
    *   *Up Arrow:* Swing from Bottom to Top.
    *   *Dot:* Stab (Thrust forward).

### Arcs (The Guide)
Arcs are visual trails that connect two targets or extend from a target into empty space.
*   **Purpose:** They force the player to keep their arm moving in a specific path between hits.
*   **Scoring:** Players must keep the tip of their bat inside the arc to maintain combo.

### Obstacles (Walls)
*   **Dodging:** Walls force the player to lean or squat.
*   **Blade Avoidance:** Unlike Boxing, in Flow, your "Saber" can cut through walls (usually penalizing score). Map walls to force the player to pull their arms in or reach wide.

## 🌊 Mapping Best Practices

### 1. The Pendulum Rule (Parity)
Flow relies on physics. If you swing **Down**, your arm is now at the bottom. The next natural move is to swing **Up**.
*   **Good Flow:** Down -> Up -> Down -> Up.
*   **Bad Flow (Reset):** Down -> Down. (This forces the player to awkwardly reset their hand position instantly).
*   **Forehand/Backhand:** Use horizontal cuts to transition between forehand and backhand swings.

### 2. Large Movements
AeroBeat Flow is a fitness mode, not just a wrist-flick game.
*   **Use Arcs:** Force the player to swing wide.
*   **Cross-Body:** Map targets on the opposite side (e.g., Right Hand hitting a target in the Left Lane) to engage the core.

### 3. 360 Portal Usage
*   **Rotation:** Use directional cuts to guide the player's body rotation towards a new portal.
*   **Example:** A Right-Hand "Right Swipe" naturally turns the body to the right. Open the next portal on the Right side immediately after.

## 🚀 Workflow Tips

### Pattern Prefabs
*   **"The Drum Roll":** Rapid Up/Down alternating streams.
*   **"The Windmill":** Large circular arm movements using Arcs.
*   **"The Cross":** Simultaneous diagonal cuts forming an X.

### Difficulty Grading

| Difficulty | Mechanics | Density |
| :--- | :--- | :--- |
| **Easy** | On-beat. Simple Up/Down flow. No crossovers. | Low |
| **Medium** | 1/8th notes. Cross-body hits. Simple Arcs. | Moderate |
| **Hard** | 1/16th bursts. Complex streams. Wide squats. | High |
| **Pro** | Technical angles. 360 rotation. Precision Arcs. | Extreme |

## 🛡️ Validation

The **"Flow Validator"** in the SDK is critical. It checks for **Parity Errors** (Two same-direction cuts in a row without time to reset) and **Hitbox Clashes**.