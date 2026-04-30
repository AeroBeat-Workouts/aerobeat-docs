# Creating Step Charts (StepMania Style)

Welcome to the world of Step mapping. Unlike Boxing or Flow, Step gameplay is entirely about **foot placement** and **weight transfer**.

If you are coming from *StepMania* or *Dance Dance Revolution*, you will feel right at home. The `aerobeat-sdk-choreography-step` tooling is built to support standard 4-panel charting.

In AeroBeat's content model, a Step chart is a reusable **Chart** record, and a Step **Set** links that chart to one **Song** inside a workout package.

## 🛠️ The Step Studio

* **Tool:** **Step Choreography Studio**
* **Grid:** 4 lanes (Left, Down, Up, Right).
* **Perspective:** The editor defaults to a top-down receptor view, similar to standard VSRGs (Vertical Scrolling Rhythm Games).

## 📦 The Step chart contract

Step uses the same shared chart envelope as Boxing, Flow, and Dance. The authored gameplay payload stays in one flat `beats:` list.

```yaml
schemaId: aerobeat.chart.step.v1
schemaVersion: 1
recordVersion: 1
createdByTool: aerobeat-tool-content-authoring
createdByToolVersion: 0.1.0
createdAt: 2026-04-30T12:00:00Z
updatedAt: 2026-04-30T12:00:00Z
chartId: uid
chartName: string
feature: step
difficulty: medium
beats:
  - start: 8.0
    type: tap
    lanes: [left]
  - start: 12.0
    type: tap
    lanes: [left, right]
  - start: 16.0
    end: 18.0
    type: hold
    lanes: [down]
  - start: 20.0
    type: mine
    lanes: [up]
```

### Required Step row fields

Every Step row in `beats:` uses:

- `start` — required beat-domain float
- `type` — required Step object family
- `lanes` — required ordered unique lane list
- `end` — optional inclusive beat-domain float used only for holds

### Allowed `type` values in v1

- `tap`
- `hold`
- `mine`

### Allowed `lanes` values in v1

Use only the stable 4-panel lane ids:

- `left`
- `down`
- `up`
- `right`

Write simultaneous lanes in canonical pad order:

```yaml
lanes: [left, down, up, right]
```

That means authored two-lane rows should appear as:

- `[left, down]`
- `[left, up]`
- `[left, right]`
- `[down, up]`
- `[down, right]`
- `[up, right]`

### Validation rules that matter

- `tap` supports `lanes` count `1..2` and must **not** include `end`
- `hold` requires exactly one lane and **must** include `end`
- `mine` supports `lanes` count `1..2` and must **not** include `end`
- triples/quads are invalid in first-pass Step YAML
- overlapping holds on the same lane should be treated as invalid authored data

### What stays out of Step rows

Do **not** put these into chart rows:

- scoring logic or judgment windows
- footedness guidance
- crossover intent
- bracket / hand / jack / stream labels
- presentation or runtime hints
- environment or asset configuration
- engine interpretation details

Environment and asset customization remains outside chart YAML and is linked through **Sets** at engine interpretation time.

## 🦶 The Golden Rule: Alternation

The most fundamental rule of Step mapping is **flow**.
Unless you are creating a specific jack (repeated tap) pattern, players should naturally alternate feet:
**Left -> Right -> Left -> Right**

### Common Patterns

1. **The Stream:** A continuous run of notes (1/4, 1/8, or 1/16).
   * *Good:* L-D-U-R (alternates feet naturally).
   * *Bad:* L-D-L-D (forces the player to twist awkwardly or double-step).
2. **The Crossover (Candle):** A pattern that forces the player to turn their body sideways.
   * *Example:* Left foot on Left -> Right foot on Up -> Left foot on Right.
   * *Result:* The player is now facing right.
3. **The Gallop:** A rhythm pattern (1/16th triplet) that feels like a skip.
   * *Timing:* `1... a2... a3`
4. **Jumps:** Two arrows at once.
   * *Authoring:* In AeroBeat v1, a jump is a `tap` row with two `lanes` values, not a separate `type`.
   * *Constraint:* Humans only have two feet. Never place 3 arrows at once unless you intentionally want advanced hand or bracket tech.
   * *Flow:* Avoid placing a jump immediately after a fast stream without a break.

## 🚀 Mapping Workflow

### 1. Setup

1. Open `aerobeat-sdk-choreography-step`.
2. Create or open the **Chart** for the intended difficulty.
3. Create or open the Step **Set** that links the selected Song and Chart for this workout slice.
4. Load your Song using the content browser, ensure the set is the only composition record linking the exact Song + Chart IDs, and sync the BPM with the **Auto-Detect** feature.

### 2. The Editor Grid

* **Lane 1 (Left):** ⬅️
* **Lane 2 (Down):** ⬇️
* **Lane 3 (Up):** ⬆️
* **Lane 4 (Right):** ➡️

### 3. Placing Notes

* **Tap (Arrow):** Standard step. One lane is a single step; two lanes at the same `start` are a jump.
* **Hold (Freeze):** Click and drag to extend. In YAML this is one `hold` row with `start`, inclusive `end`, and exactly one lane.
* **Mine (Shock):** The athlete must *avoid* the panel. Use these to force foot placement without turning them into runtime-only hazards.

## 📉 Difficulty Guidelines

Step charts are rated by feet (intensity).

| Difficulty | Mechanics | Note Density |
| :--- | :--- | :--- |
| **Easy (1-3)** | On-beat (1/4) only. No jumps. No crossovers. | Low |
| **Medium (4-6)** | Introduces 1/8th notes. Simple jumps. Basic voltage. | Moderate |
| **Hard (7-9)** | Streams (1/8th). Crossovers. Short 1/16th bursts. | High |
| **Pro (10+)** | Chaos. 1/16th streams. Tech patterns. Stamina tests. | Extreme |

## 💡 Best Practices (From the Community)

* **Avoid Double Stepping:** Do not force a player to hit the same arrow twice in rapid succession with the same foot unless it matches a specific drum-roll sound.
* **Respect the Center:** Players naturally return to the center of the pad.
* **Facing Matters:** If you use a crossover to turn the player, give them a beat to untwist before the next pattern.
* **Mines are Spice:** Use mines sparingly. They should clarify the intended footing, not just annoy the player.
