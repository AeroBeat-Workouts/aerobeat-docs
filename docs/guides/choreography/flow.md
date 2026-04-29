# Creating Flow Choreography

"Flow" is the art of continuous motion. Unlike the explosive, staccato rhythm of Boxing, Flow is about momentum, follow-through, and guiding the athlete through wide readable swings.

This guide now teaches the **locked Flow chart contract** for this pass. Keep authoring conservative: use the shared flattened `beats:` shape from Boxing, then add only the Flow-specific fields that are now approved.

## 🛠️ The Flow Studio

*   **Tool:** **Flow Choreography Studio**
*   **Authoring model:** flat `beats:` list under `feature: flow`
*   **Core idea:** `portal` controls where the beat originates, `placement` controls where it passes around the athlete, and `direction` controls swing/follow-through guidance

## ✅ Canonical Flow chart shape

Flow charts use the same top-level authored structure as the locked Boxing pass:

```yaml
schemaId: aerobeat.chart.flow.v1
schemaVersion: 1
recordVersion: 1
createdByTool: aerobeat-tool-content-authoring
createdByToolVersion: 0.1.0
createdAt: 2026-04-29T16:00:00Z
updatedAt: 2026-04-29T16:00:00Z
chartId: uid
chartName: string
feature: flow
difficulty: medium
beats:
  - start: 8.0
    type: swing_left
    portal: 0
    placement: 2
    direction: 3
  - start: 9.0
    type: trail_right
    portal: 1
    placement: 4
  - start: 10.0
    type: reward_left
    placement: 12
  - start: 12.0
    end: 13.0
    type: squat
```

### Beat fields

Each Flow beat has:

- `start` — required float
- `end` — optional inclusive float
- `type` — required Flow type
- `portal` — optional integer in `0..11`
- `placement` — optional integer in `0..12`
- `direction` — optional integer in `0..11`

### Field meanings

- `portal` = origin / presentation source
- `placement` = where around the athlete the beat passes
- `direction` = swing / follow-through guidance

### Direction inheritance

For these types:

- `swing_left`, `swing_right`
- `trail_left`, `trail_right`
- `warn_left`, `warn_right`

if `direction` is omitted, the effective `direction` is the same value as `placement`.

## ⚔️ Flow type vocabulary

### Swing and guidance families

These types support both `placement` and `direction`:

- `swing_left`, `swing_right`
- `trail_left`, `trail_right`
- `warn_left`, `warn_right`

Use them like this:

- **`swing_*`** for primary playable swings.
- **`trail_*`** for continuous guided follow-through paths.
- **`warn_*`** for readable advance guidance that sets up the next movement.

### Placement-only reward families

These types support `placement` but **not** `direction`:

- `reward_left`, `reward_right`

Use reward beats when you want to visually acknowledge a successful lane/space resolution without adding another directional requirement.

### Body-movement families

These types support neither `placement` nor `direction`:

- `squat`
- `lean_left`, `lean_right`
- `knee_left`, `knee_right`
- `leg_lift_left`, `leg_lift_right`
- `run_in_place`

These are still authored in the same `beats:` list. Keep the chart shape flat; do not introduce a separate obstacle lane for this pass.

## 📐 Placement and direction guidance

### `portal`

`portal` uses the same `0..11` integer domain as Boxing.

### `placement`

`placement` is an integer in `0..12`.

- `0..11` describe positions around the athlete
- `12` is the special center/chest-directed placement

Use `placement` to answer: **where should this beat pass around the athlete?**

### `direction`

`direction` is an integer in `0..11`.

Use it to answer: **how should the athlete swing through or follow through this beat?**

If the beat's natural swing direction matches its placement, omit `direction` and let inheritance do the work for supported types.

## 🌊 Mapping Best Practices

### 1. Preserve pendulum flow

Flow still lives or dies on parity.

*   **Good Flow:** Down -> Up -> Down -> Up.
*   **Bad Flow:** Down -> Down without enough time to recover.
*   Use explicit `direction` when the intended follow-through differs from the most obvious reading of the beat's `placement`.

### 2. Optimize for sight-readability

The chart should be easy to read at a glance.

*   Prefer omitting `direction` when it simply matches `placement`.
*   Use `trail_*` and `warn_*` sparingly and with clear setup intent.
*   Reserve `placement: 12` for moments that truly want a strong center/chest-directed read.

### 3. Telegraph body moves

When using `squat`, `lean_*`, `knee_*`, `leg_lift_*`, or `run_in_place`, leave enough musical space for the athlete to shift weight and recover.

### 4. Keep schema complexity flat

For this pass:

*   author under `beats:`, not `events:`
*   use `feature: flow`, not `mode: flow`
*   do not add nested payload objects for swings, trails, or warnings
*   do not re-introduce older inner/outer ring authoring vocabulary as required schema

## 🚀 Workflow Tips

### Pattern ideas

*   **Pendulum:** alternating `swing_*` beats with inherited direction.
*   **Guide Into Hit:** `warn_*` or `trail_*` into a clearer `swing_*` resolution.
*   **Center Reward:** `reward_*` with `placement: 12` for a strong chest-line emphasis.

### Difficulty grading

| Difficulty | Mechanics | Density |
| :--- | :--- | :--- |
| **Easy** | Clear `swing_*` reads, minimal cross-body motion, simple body moves. | Low |
| **Medium** | Cross-body placements, occasional `trail_*`, more recovery management. | Moderate |
| **Hard** | Faster alternation, denser body-move inserts, more non-default `direction`. | High |
| **Pro** | Technical follow-through, rapid setup beats, precision placement changes. | Extreme |

## 🛡️ Validation

The **Flow Validator** should at minimum catch the contract rules taught here:

- `feature` must be `flow`
- authored entries must live under `beats:`
- every beat must have `start` and `type`
- `portal` must stay in `0..11`
- `placement` must stay in `0..12`
- `direction` must stay in `0..11`
- `reward_*` must not carry `direction`
- `squat`, `lean_*`, `knee_*`, `leg_lift_*`, and `run_in_place` must not carry `placement` or `direction`
- for `swing_*`, `trail_*`, and `warn_*`, missing `direction` should inherit from `placement`

That is the current Flow contract. Keep broader view/renderer/runtime interpretation outside the chart YAML unless a later pass explicitly locks more fields.