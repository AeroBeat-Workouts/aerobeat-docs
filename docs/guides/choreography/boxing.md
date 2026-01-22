# Creating Boxing Choreography

Boxing is the core gameplay of AeroBeat. A good boxing chart is a conversation between the music and the athlete's body. It uses punches to express rhythm and obstacles to force body movement (squats and leans).

## 🛠️ The Boxing SDK

*   **SDK:** `aerobeat-sdk-choreography-boxing`
*   **Grid:** 4 Lanes (Left Outer, Left Inner, Right Inner, Right Outer).
*   **Perspective:** 3D Portal View (Targets fly towards you).

## 🥊 Mechanics & Objects

### Targets (Punches)

*   **Color Coding:**
    *   **Black:** Left Hand.
    *   **White:** Right Hand.
*   **Direction:** The arrow on the target dictates the punch type.
    *   *Up Arrow:* Uppercut.
    *   *Down/Side Arrow:* Hook or Cross.
    *   *Dot:* Jab (Any direction).

### Obstacles (Movement)

Don't just use obstacles to punish the player. Use them to **choreograph movement**.

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
*   **Tip:** Use the "Portal Marker" tool to explicitly open a new portal. Add a 1-measure gap before the first target appears in the new portal to give the player time to react.

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