# Creating Boxing Choreography

Boxing is the core gameplay of AeroBeat. A good boxing chart is a conversation between the music and the athlete's body. It uses punches, guards, footwork, stance changes, and body-movement cues to express rhythm while staying easy for a choreographer to sight-read.

## 🛠️ The Boxing Studio

*   **Tool:** **Boxing Choreography Studio**
*   **Perspective:** 3D Portal View for authoring and review.
*   **Content Model:** A boxing chart is a reusable **Chart** record. The song owns audio/timing, the chart owns one concrete playable difficulty, and package-local **Set** records link charts to songs, environments, asset selections, and optional coaching overlays.
*   **Targeting Rule:** Author boxing against movement intent, not raw device coordinates. Boxing charts use concrete move `type` values plus an optional integer `portal` target from `0` to `11` when a move should land somewhere other than the default front target.

## 🥊 Mechanics & Move Vocabulary

### Punches

Concrete punch types are authored directly in the chart:

*   `jab`
*   `cross`
*   `hook_left`
*   `hook_right`
*   `uppercut_left`
*   `uppercut_right`

Use the move name that the athlete should perform. Do not split punches into nested payloads like `type: strike` plus extra `hand` / `strike` / `zone` fields.

### Guards, Stance, and Footwork

These moves are also authored as direct `type` values:

*   `guard`
*   `orthodox`
*   `southpaw`
*   `sidestep_left`
*   `sidestep_right`
*   `run_in_place`

`orthodox` and `southpaw` remain normal beat types in authored YAML. The boxing feature interprets them internally as stance-state changes without needing a special nested payload shape.

### Lower-Body Moves

Lower-body intensity comes from concrete authored beat types too:

*   `squat`
*   `lean_left`
*   `lean_right`
*   `knee_left`
*   `knee_right`
*   `leg_lift_left`
*   `leg_lift_right`

These remain human-readable authored moves. Do not author boxing-only subtype objects like `obstacle.avoid`, `knee.side`, or `stance.stance`.

## 📦 Boxing Chart Shape

For this pass, the boxing chart contract is intentionally flat and boxing-specific.

### Shared boxing chart fields

A Boxing chart includes:

*   `schemaId`: `aerobeat.chart.boxing.v1`
*   `chartId`
*   `chartName`
*   `feature`: `boxing`
*   `difficulty`
*   `beats`: timed boxing actions

For boxing authoring in this pass:

*   use `feature`, not `mode`
*   use `beats`, not `events`
*   do **not** add a chart-level `beatSpace`
*   do **not** add authored boxing `zone`
*   do **not** use symbolic portal strings such as `center`, `left`, or `right`
*   do **not** use old boxing timing fields such as `holdMs` or `durationMs`

### Beat shape

Each boxing beat has:

*   required float `start`
*   optional inclusive float `end`
*   required concrete `type`
*   optional integer `portal` in `0-11` (defaults to `0`)

Author only the information the choreographer actually needs to read. If a move should hit the default front target, omit `portal` and let it default to `0`.

### Spatial targeting rule

`portal` is a concrete authored integer, not a symbolic string.

Think of the values like a clock face around the athlete:

*   `0` = front
*   `3` = right
*   `6` = back
*   `9` = left

The values between them fill the ring. This keeps the authored chart compact while still supporting portal-aware presentation.

### Timing rule

Boxing timing is authored directly in beat-domain floats.

*   `start` marks when the move begins.
*   `end`, when present, is inclusive and means the move continues through that beat.

Use this one timing shape consistently instead of mixing alternate boxing-only fields like `holdMs` or `durationMs`.

### Concrete example

```yaml
schemaId: aerobeat.chart.boxing.v1
chartId: boxing-song123-medium
chartName: Boxing Song 123 Medium
feature: boxing
difficulty: medium
beats:
  - start: 1.0
    type: jab
  - start: 2.0
    type: cross
  - start: 3.5
    end: 4.5
    type: guard
  - start: 5.0
    end: 6.0
    type: squat
  - start: 7.0
    type: hook_left
    portal: 9
  - start: 8.0
    type: southpaw
  - start: 9.0
    type: run_in_place
    end: 12.0
```

### Boxing authoring guidance for this pass

*   Author the athlete move directly as the `type`.
*   Prefer the default front target and only add `portal` when placement matters.
*   Keep beats flat and sight-readable.
*   Use `end` only when the move truly spans beats.
*   Keep the boxing contract local to boxing docs/examples for now rather than trying to force unresolved Flow, Dance, or Step details into the same vocabulary.

## 📐 Mapping Best Practices

### 1. Flow & Parity

The golden rule of boxing mapping is **flow**.

*   **Alternation:** The most natural rhythm is left-right alternation.
*   **Reset:** After a punch, the hand needs time to return to guard.
*   **Readability:** A flat beat list should still read like choreography, not like a serialized runtime object dump.

### 2. Fitness Intensity

*   **Squats:** Use `squat` spans to create sustained lower-body work.
*   **Reach:** Use non-default `portal` values to ask for fuller rotation or reach.
*   **Core:** `lean_left` and `lean_right` can create quick weave patterns.

### 3. Portal Awareness

Boxing can still play well in portal-aware views without symbolic layout strings.

*   **Default:** Omit `portal` for front-facing moves.
*   **Rotation Cues:** Use left/right hooks, sidesteps, and off-front portal targets to suggest turning flow.
*   **Sparingly:** Wide portal jumps are strongest when they reinforce the choreography rather than fighting it.

## 🚀 Workflow Tips

### Pattern Prefabs

Useful flat-schema boxing phrases include:

*   **"The 1-2":** `jab`, `cross`
*   **"Guard Break":** `jab`, `cross`, `guard`
*   **"Weave":** `lean_left`, `lean_right`, `lean_left`
*   **"Burner":** `jab`, `cross`, `squat`, `jab`, `cross`

### Difficulty Grading

| Difficulty | Mechanics | Density |
| :--- | :--- | :--- |
| **Easy** | On-beat punches and simple guards. | Low |
| **Medium** | 1-2 combos, short spans, basic footwork. | Moderate |
| **Hard** | Denser phrases, portal movement, mixed lower-body cues. | High |
| **Pro** | Fast alternation, sustained spans, aggressive portal travel. | Extreme |

## 🛡️ Validation

Before publishing a boxing chart, check that:

*   every entry lives under `beats`
*   every beat has `start` and `type`
*   any `end` value is intentional and inclusive
*   any `portal` value is an integer from `0` to `11`
*   no authored boxing beat uses `zone`, symbolic portal strings, `holdMs`, or `durationMs`
