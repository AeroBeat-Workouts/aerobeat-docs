# Creating Boxing Choreography

Boxing is the core gameplay of AeroBeat. A good boxing chart is a conversation between the music and the athlete's body. It uses punches to express rhythm and obstacles to force body movement (squats and leans).

## 🛠️ The Boxing Studio

*   **Tool:** **Boxing Choreography Studio**
*   **Grid:** 5 Zones (Left, Right, Low-Left, Low-Right, Center).
*   **Perspective:** 3D Portal View (Targets fly towards you).

## 🥊 Mechanics & Objects

### Targets (Punches)

*   **Color Coding:**
    *   **Black:** Left Hand.
    *   **White:** Right Hand.
*   **Positioning:** Targets spawn at specific heights relative to the user's calibration.
    *   **Standard:** Arm height (Left/Right).
    *   **Low:** Crouch height (Left/Right).
    *   **Center:** Reserved for **Guard/Block** targets.
*   **Direction:** The arrow on the target dictates the punch type.
    *   *Up Arrow:* Uppercut.
    *   *Down/Side Arrow:* Hook or Cross.
    *   *Dot:* Jab (Any direction).

### Obstacles (Movement)

Obstacles spawn within a specific radius around the active portal, using a separate positioning system to force body movement.

*   **Vertical Wall:** Forces a lean (engages core).
*   **Horizontal Bar:** Forces a squat (engages legs).
*   **Angled Wall:** Forces a specific body rotation.

## 📐 Mapping Best Practices

### 1. Flow & Parity

The "Golden Rule" of boxing mapping is **Flow**.

*   **Alternation:** The most natural rhythm is L -> R -> L -> R.
*   **Reset:** After a punch, the hand needs time to return to the "Guard" position.
*   **Bad Parity:** Avoid "Double Vision" (placing a target directly behind another) or "Hand Tangles" (Cross-body Left punch followed immediately by a far-left punch).

### 2. Fitness Intensity

*   **Squats:** The most calorie-burning move. Use horizontal bars on the downbeats of the chorus.
*   **Reach:** Use the outer lanes to force full arm extension.
*   **Core:** Use vertical walls to force rapid side-to-side weaving.

### 3. 360 vs. 2D

When mapping in the Boxing SDK, you can place targets in a 360-degree ring.

*   **VR Players:** Will physically rotate to face the new portal.
*   **2D Players:** The engine automatically "folds" these targets to the front.
*   **Relative Lanes:** The 5-Zone Grid is always **relative to the Active Portal**. If the player turns 90 degrees right, "Left Arm" is still their physical left hand.

#### Rotation Cues (The Fitness Flow)
Instead of random portal jumps, use the choreography to guide the turn.
*   **The Guide:** Use obstacles and directional punches (Hooks) to force body rotation towards the next target zone. Sequential portals in a single direction also create a strong guiding flow.
*   **Example:** If the next portal is to the **Right**, end the current phrase with a **Left Hook** or **Right Cross**. This naturally rotates the athlete's torso to the right, setting them up for the new portal.
*   **Visuals:** Every active portal emits a particle trail flowing towards the player to help them center their stance.

> **Note:** **Simultaneous Portals** (targets coming from multiple directions) are a valid mechanic for high-intensity "Pro" charts, but use them sparingly to maintain flow.

## 🚀 Workflow Tips

### Pattern Prefabs

Use the **Prefab Library** (Spacebar) to drag-and-drop common boxing combos:

*   **"The 1-2":** Left Jab, Right Cross.
*   **"The Weave":** Wall Left, Wall Right, Wall Left.
*   **"The Burpee":** High Target, Squat Wall, High Target.

### Difficulty Grading

| Difficulty | Mechanics | Density |
| :--- | :--- | :--- |
| **Easy** | On-beat only. No obstacles. | Low |
| **Medium** | Simple 1-2 combos. Basic walls. | Moderate |
| **Hard** | 1/8th streams. Squats. Wide reaches. | High |
| **Pro** | 1/16th bursts. Complex weaves. 360 rotation. | Extreme |

## 🛡️ Validation

Always run the **"Flow Validator"** before uploading. It checks for impossible reaches and vision blocks specific to the human arm span.