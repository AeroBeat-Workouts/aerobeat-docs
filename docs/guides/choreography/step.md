# Creating Step Charts (StepMania Style)

Welcome to the world of "Step" mapping. Unlike Boxing or Flow, Step gameplay is entirely about **Foot Placement** and **Weight Transfer**.

If you are coming from *StepMania* or *Dance Dance Revolution*, you will feel right at home. The `aerobeat-sdk-choreography-step` is built to support standard 4-panel charting.

## 🛠️ The Step Studio

*   **Tool:** **Step Choreography Studio**
*   **Grid:** 4 Lanes (Left, Down, Up, Right).
*   **Perspective:** The editor defaults to a top-down "Receptor" view, similar to standard VSRGs (Vertical Scrolling Rhythm Games).

## 🦶 The Golden Rule: Alternation

The most fundamental rule of Step mapping is **Flow**.
Unless you are creating a specific "Jack" (repeated tap) pattern, players should naturally alternate feet:
**Left -> Right -> Left -> Right**

### Common Patterns

1.  **The Stream:** A continuous run of notes (1/4, 1/8, or 1/16).
    *   *Good:* L-D-U-R (Alternates feet naturally).
    *   *Bad:* L-D-L-D (Forces the player to twist awkwardly or double-step).
2.  **The Crossover (Candle):** A pattern that forces the player to turn their body sideways.
    *   *Example:* Left Foot on Left -> Right Foot on Up -> Left Foot on Right.
    *   *Result:* The player is now facing Right.
3.  **The Gallop:** A rhythm pattern (1/16th triplet) that feels like a skip.
    *   *Timing:* `1... a2... a3`
4.  **Jumps:** Two arrows at once.
    *   *Constraint:* Humans only have two feet. Never place 3 arrows at once (unless you intend for a "Hand" bracket, which is advanced tech).
    *   *Flow:* Avoid placing a Jump immediately after a fast stream without a break.

## 🚀 Mapping Workflow

### 1. Setup

1.  Open `aerobeat-sdk-choreography-step`.
2.  Create an `AeroChoreography` resource.
3.  Load your song using our content-browser and sync the BPM (Use the **Auto-Detect** feature).

### 2. The Editor Grid

*   **Lane 1 (Left):** ⬅️
*   **Lane 2 (Down):** ⬇️
*   **Lane 3 (Up):** ⬆️
*   **Lane 4 (Right):** ➡️

### 3. Placing Notes

*   **Tap (Arrow):** Standard step.
*   **Hold (Freeze):** Click and drag to extend. Player must keep weight on the panel.
*   **Mine (Shock):** Player must *avoid* the panel. Use these to force foot placement (e.g., putting a mine on the Down arrow forces the player to keep their foot on Up).

## 📉 Difficulty Guidelines

Step charts are rated by "Feet" (Intensity).

| Difficulty | Mechanics | Note Density |
| :--- | :--- | :--- |
| **Easy (1-3)** | On-beat (1/4) only. No Jumps. No Crossovers. | Low |
| **Medium (4-6)** | Introduces 1/8th notes. Simple Jumps. Basic voltage. | Moderate |
| **Hard (7-9)** | Streams (1/8th). Crossovers. Short 1/16th bursts. | High |
| **Pro (10+)** | Chaos. 1/16th streams. Tech patterns. Stamina tests. | Extreme |

## 💡 Best Practices (From the Community)

*   **Avoid "Double Stepping":** Don't force a player to hit the same arrow twice in rapid succession with the same foot unless it matches a specific drum roll sound.
*   **Respect the Center:** Players naturally return to the center of the pad.
*   **Facing Matters:** If you use a Crossover to turn the player, give them a beat to untwist before the next pattern.
*   **Mines are Spice:** Use Mines sparingly. They should clarify the intended footing, not just annoy the player.