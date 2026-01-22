# Creating Flow Choreography

"Flow" is the art of continuous motion. Unlike the explosive, staccato rhythm of Boxing, Flow is about momentum, arcs, and slicing through the beat. Think of it as a mix of drumming and swordplay.

## 🛠️ The Flow Studio

*   **Tool:** **Flow Choreography Studio**
*   **Grid:** 360-degree Ring with **Inner** and **Outer** zones.
*   **Perspective:** 3D Portal View.

## ⚔️ Mechanics & Objects

### Targets (Swings)
*   **Color Coding:**
    *   **Black:** Left Bat.
    *   **White:** Right Bat.
*   **Positioning:**
    *   **Outer Ring:** Intended for full body movements and arm extensions.
    *   **Inner Ring:** Intended for half-movements (drumming, rope swings). Typically used in Hard/Pro charts.
*   **Direction:** The arrow dictates the **Swing Direction**.
    *   *Directional Arrow:* Swing through the target in the arrow's direction.
    *   *Note:* There are no "Guard" or "Block" targets in Flow.

### Arcs (The Guide)
Arcs are visual trails that connect two targets or extend from a target into empty space.
*   **Purpose:** They force the player to keep their arm moving in a specific path. Use them without targets to create "Zen-like" movement or to guide the bat to the correct position for the next sequence.
*   **Scoring:** Players must keep the tip of their bat inside the arc to maintain combo.

### Obstacles (Movement)
Obstacles work similarly to Boxing (forcing squats and leans), but Flow includes specialized fitness prefabs:
*   **Leg Lifts:** Triangular shapes that force the player to lift a leg (Left or Right) horizontally while balancing.
*   **Run In Place:** A rapid sequence of obstacles requiring a running motion.
*   **Blade Avoidance:** Your bats can pass through obstacles (penalizing score), so map them to guide arm position.

## 🌊 Mapping Best Practices

### 1. The Pendulum Rule (Parity)
Flow relies on physics. If you swing **Down**, your arm is now at the bottom. The next natural move is to swing **Up**.
*   **Good Flow:** Down -> Up -> Down -> Up.
*   **Bad Flow (Reset):** Down -> Down. (This forces the player to awkwardly reset their hand position instantly).
*   **Forehand/Backhand:** Use horizontal cuts to transition between forehand and backhand swings.

### 2. Telegraphing & Callouts
When using advanced fitness prefabs (Leg Lifts, Run In Place), the athlete needs time to shift their weight.
*   **Lower Difficulties:** Leave a gap before these moves so the Coach has time to call it out ("Get ready to run!").
*   **Pro Difficulty:** Athletes expect rapid transitions, so you can chain squats into leg lifts for maximum intensity.

### 3. Large Movements
AeroBeat Flow is a fitness mode, not just a wrist-flick game.
*   **Use Arcs:** Force the player to swing wide.
*   **Cross-Body:** Map targets on the opposite side (e.g., Right Hand hitting a target in the Left Lane) to engage the core.

### 4. 360 Portal Usage
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