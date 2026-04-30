# Creating Dance Choreography

Dance authoring now follows the approved **first-pass Dance chart contract** for this repo.

Like Boxing and Flow, Dance charts keep a shared flat `beats:` list. The difference is the payload meaning: each Dance beat names the expected move over time rather than a target lane or portal pattern.

## 🛠️ The Dance Studio

*   **Tool:** **Dance Choreography Studio**
*   **Authoring model:** flat `beats:` list under `feature: dance`
*   **Core idea:** author **what move is expected when**, not how runtime scoring, cueing, or coaching should interpret it

## ✅ Canonical Dance chart shape

Dance charts use the same top-level authored structure as the locked Boxing and Flow passes:

```yaml
schemaId: aerobeat.chart.dance.v1
schemaVersion: 1
recordVersion: 1
createdByTool: aerobeat-tool-content-authoring
createdByToolVersion: 0.1.0
createdAt: 2026-04-30T11:30:00Z
updatedAt: 2026-04-30T11:30:00Z
chartId: uid
chartName: string
feature: dance
difficulty: medium
beats:
  - start: 8.0
    type: step_touch
  - start: 12.0
    end: 15.0
    type: hold_pose
    gold: true
  - start: 20.0
    type: spin
```

### Beat fields

Each Dance beat has:

- `start` — required float
- `end` — optional inclusive float
- `type` — required Dance move identifier
- `gold` — optional boolean

### Field meanings

- `start` = the authored beat where the move window begins
- `end` = the inclusive authored beat where a sustained move window ends
- `type` = the durable Dance move identity expected during that window
- `gold` = special authored emphasis for that move window

## 💃 Dance move vocabulary direction

For this first pass, Dance move ids should stay durable, compact, and choreography-oriented.

Representative approved direction includes families such as:

- `step_touch`
- `hold_pose`
- `spin`
- `pivot`
- `reach`
- `sweep`
- `clap`
- `jump`
- `knee_lift`
- `groove`

This guide is **not** locking a giant franchise-style move catalog. The important contract rule is that the chart stores the expected move id only. The detailed semantics of how that move is taught, previewed, mirrored, or scored belong elsewhere.

## 🪙 Gold moves

Use `gold: true` when the authored move should be specially highlighted.

Gold means only that the move window is emphasized in authored content. It does **not** inline bonus-scoring rules, special VFX logic, or coach-reaction behavior into the chart row.

## ⏱️ Span semantics

Dance uses the same timing philosophy as Boxing and Flow:

- omit `end` for an instantaneous authored move moment
- include `end` for one continuous sustained move/pose window
- keep `end` inclusive when present

Use spans for holds, freezes, sustained poses, or other continuous windows where the athlete is expected to maintain one named move.

## 🚫 What does not belong in Dance chart rows

Do **not** add:

- scoring thresholds or classifier tuning
- runtime interpretation details
- coach behavior or camera logic
- pictogram names or asset paths
- dance-card / cue-system metadata
- inline move-performance semantics
- `portal`, `placement`, or `direction` fields borrowed from other features
- nested Dance-only payload objects

If a move needs durable left/right specificity, encode that in the move identifier only when the authored intent truly requires it.

## 📐 Mapping Best Practices

### 1. Keep the chart contract minimal

A Dance chart should read like a timed list of expected move ids.

*   **Good:** `start`, optional `end`, `type`, optional `gold`
*   **Bad:** rows bloated with cue art, scoring data, classifier paths, or coach presentation details

### 2. Use spans only when the move is truly continuous

*   Use a span for `hold_pose`, a sustained `groove`, or another intentional maintained window.
*   Do not split one continuous pose into multiple rows unless the authored expectation actually changes.

### 3. Prefer durable movement-function names

*   Favor reusable move ids such as `step_touch`, `pivot`, or `reach`.
*   Avoid song-specific or franchise-branded labels that do not generalize across charts.

### 4. Telegraph complexity through sequencing, not schema bloat

If a complex move needs setup, author a simpler move before it.

*   Example: `step_touch` before `spin`
*   Example: `reach` before `hold_pose`

The chart should still stay flat and readable even when the choreography becomes more technical.

## 🚀 Workflow Tips

### Pattern ideas

Useful flat-schema Dance phrases include:

*   **Prep Into Turn:** `step_touch` -> `spin`
*   **Accent Freeze:** `clap` -> `hold_pose` with `gold: true`
*   **Travel Groove:** `travel` or `groove` span into a sharper accent move

### Difficulty grading

| Difficulty | Mechanics | Density |
| :--- | :--- | :--- |
| **Easy** | Clear move ids, short poses, simple prep beats. | Low |
| **Medium** | More sustained windows, turns, and readable transitions. | Moderate |
| **Hard** | Denser move changes, longer memorized phrases, faster transitions. | High |
| **Pro** | Technical choreography, tighter timing, and sustained complex phrases. | Extreme |

## 🛡️ Validation

Before publishing a Dance chart, check that:

*   every entry lives under `beats`
*   every beat has `start` and `type`
*   any `end` value is intentional, numeric, and inclusive
*   any `gold` value is boolean
*   rows stay sorted by ascending `start`
*   sustained windows do not overlap
*   no authored Dance beat adds scoring logic, pictogram/cue data, runtime classifier fields, or other extra Dance-only payload keys
