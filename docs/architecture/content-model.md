# Content Model: Songs, Routines, Chart Variants, and Workouts

AeroBeat content is authored as a layered model rather than a single flat chart blob or a set of unrelated per-mode file formats.

The durable hierarchy is:

- **Song**
  - **Routine**
    - **Chart Variant**
- **Workout**
  - ordered selections of routines or chart variants

This structure keeps audio and licensing metadata reusable at the song layer, keeps gameplay-mode semantics at the routine layer, keeps difficulty-specific authored event streams at the chart variant layer, and keeps coaching / workout programming at the workout layer.

## Canonical ownership

The canonical contracts for `Song`, `Routine`, `Chart Variant`, `Workout`, the shared chart envelope, and shared content loading / validation interfaces live in [`aerobeat-content-core`](https://github.com/AeroBeat-Workouts/aerobeat-content-core).

[`aerobeat-feature-core`](https://github.com/AeroBeat-Workouts/aerobeat-feature-core) consumes those contracts to define gameplay-mode/runtime rules. It does not own the durable content primitives.

[`aerobeat-tool-core`](https://github.com/AeroBeat-Workouts/aerobeat-tool-core) and tool repos consume the same content contracts so authoring, validation, ingestion, and runtime all speak the same content language.

## Why AeroBeat needs `Routine`

`Routine` is the missing primitive between `Song` and `Workout`.

A `Song` alone is too low-level. It knows about the audio timeline, credits, and metadata, but it does not know whether the athlete is boxing, stepping, dancing, or flowing.

A `Workout` is too high-level. It is a program that assembles multiple playable items into a training session, possibly with warmup, cooldown, coaching cues, and non-song media.

`Routine` is the correct place for:

- the gameplay mode for a song
- the mode-specific authored vocabulary
- validation rules for that mode
- presentation defaults
- a grouped set of difficulty variants for the same song + mode

Examples:

- one song can have a **Boxing Routine** and a **Dance Routine**
- a Boxing Routine can have **Easy**, **Medium**, **Hard**, and **Pro** chart variants
- a Workout can pick the Medium Boxing chart from one song and the Hard Dance chart from another

## Core primitives

### 1. Song

A `Song` is the reusable music and timing source.

It owns:

- song id
- title / artist / credits / licensing metadata
- audio asset references
- duration
- tempo map / beat grid / conductor alignment data
- global tags and descriptive metadata

It does **not** own gameplay-mode-specific note data.

### 2. Routine

A `Routine` is the authored gameplay package for one `Song` interpreted through one gameplay mode.

It owns:

- routine id
- song reference
- gameplay mode reference, such as `boxing`, `dance`, `step`, or `flow`
- routine-level metadata such as intensity, training focus, and authoring notes
- presentation defaults
- validation profile for the mode
- one or more chart variants

A routine is where AeroBeat says, “this is the boxing choreography for this song,” not just “this song exists.”

### 3. Chart Variant

A `Chart Variant` is one concrete playable authored sequence.

It owns:

- chart id
- routine reference
- difficulty
- interaction family target
- optional supported / validated input profiles
- timing-aligned event stream
- scoring metadata and hit windows
- optional presentation hints needed to render the chart well

A chart variant represents **one playable difficulty / compatibility slice**, not an all-difficulties megafile.

#### Why difficulty belongs here

AeroBeat does not store all difficulties as peer event arrays inside one giant chart by default.

Separate chart variants give us:

- cleaner diffs and version control
- easier validation
- easier tooling
- fewer edit collisions between contributors
- room for alternate device-compatible variants later without forking the whole routine

### 4. Workout

A `Workout` is a training program.

It owns:

- workout id
- title / coach / goal / target duration / intensity metadata
- ordered list of routine selections or chart selections
- pre-roll / warmup / cooldown / post-roll content
- transitions, coaching cues, and workout-level presentation notes

A workout references either a full routine plus difficulty preference, or an exact chart variant directly when the sequence must be locked.

## Shared chart envelope

AeroBeat uses **one shared chart envelope** across gameplay modes, with **mode-specific payloads** inside it.

This keeps tooling, loading, validation, and runtime contracts coherent without pretending that Boxing and Step are authored with the exact same event vocabulary.

The shared chart envelope is owned by `aerobeat-content-core` because it is part of the durable authored-content contract. Feature repos consume it and interpret it.

### Shared fields

All chart variants expose a common envelope containing fields such as:

- `schema`
- `chartId`
- `songId`
- `routineId`
- `mode`
- `difficulty`
- `interactionFamily`
- `supportedInputProfiles`
- `validatedInputProfiles`
- `timing`
- `presentation`
- `scoring`
- `events`
- `metadata`

### Mode-specific payloads

The meaning of `events` depends on the routine mode.

Examples:

- **Boxing:** strike, guard, obstacle, stance, knee, rotation cue
- **Dance:** limb pose, direction, hold, travel, formation cue
- **Step:** pad lane, hold, jump, mine, modifier
- **Flow:** saber-style cut direction, lane, obstacle, path, gesture hold

The loader contract is shared. The event schema is not identical across all modes.

That is the correct compromise.

## Interaction families, not raw devices

Charts target **interaction semantics**, not raw hardware bindings.

Do **not** author charts directly against devices such as webcam, JoyCon, headset, or keyboard. Those are runtime input strategies and profiles, not durable content primitives.

### Recommended interaction families

- `gesture_2d`
  - camera tracking
  - mouse / touch
  - keyboard / gamepad fallback mappings
  - some JoyCon mappings
- `tracked_6dof`
  - XR controllers
  - tracked hands in world space
- `hybrid`
  - content deliberately authored to adapt across both families with explicit runtime rules

### Why this matters

This preserves AeroBeat's input-agnostic architecture:

- content stays reusable longer
- runtime adapters can map the same authored semantics to multiple devices
- validated compatibility can be recorded without pretending every device behaves identically
- device-specific extensions can be added later without forking the entire content model

### Input profile fields

Use profile fields to express compatibility without making the profile the primary content target.

- `interactionFamily` = what movement semantics the chart expects
- `supportedInputProfiles` = profiles the chart is intended to run on
- `validatedInputProfiles` = profiles that have actually been tested and approved

For example, a Boxing chart targets `gesture_2d`, supports `mediapipe_camera`, `keyboard_debug`, and `gamepad_virtual_presence`, but only marks `mediapipe_camera` as validated initially.

## View modes belong mostly to runtime presentation

View modes such as Portal View, Track View, 3-Portal View, and 360-Portal View are treated primarily as **presentation and runtime interpretation concerns**, not as separate chart families.

Charts include presentation hints such as:

- preferred views
- preferred portal layout
- mirror-camera mode preference
- travel-time or approach hints where authoring truly depends on them

The same authored event stream remains portable across views by default.

### Authoring rule

Author the athlete interaction first.

Then let the runtime render that interaction as:

- 3D incoming portal targets
- 2D track lanes
- folded 360-to-front fallback layouts
- multi-portal or simplified mobile representations

If a future mode truly requires view-specific authored data that cannot be derived, add that as an extension field rather than replacing the content hierarchy.

## Recommended file / package relationship

At the docs level, AeroBeat treats these as distinct assets even if implementation details evolve later:

- one `Song` record
- one or more `Routine` records under that song
- one chart file or record per `Chart Variant`
- one `Workout` file or record assembling selections

That yields small, reviewable, reusable units.

## Minimal shared chart envelope example

```json
{
  "schema": "aerobeat.chart.boxing.v1",
  "chartId": "boxing-song123-medium-gesture",
  "songId": "song123",
  "routineId": "song123-boxing",
  "mode": "boxing",
  "difficulty": "medium",
  "interactionFamily": "gesture_2d",
  "supportedInputProfiles": ["mediapipe_camera"],
  "validatedInputProfiles": ["mediapipe_camera"],
  "timing": {
    "offsetMs": 0,
    "resolution": 16
  },
  "presentation": {
    "preferredViews": ["portal", "track"],
    "portalMode": "front_3_portal",
    "mirrorCamera": true
  },
  "scoring": {
    "hitWindowMs": {
      "perfect": 45,
      "good": 90,
      "ok": 140
    },
    "comboModel": "standard"
  },
  "events": [],
  "metadata": {
    "tags": ["cardio", "boxing"]
  }
}
```

## Opinionated rules

To keep the ecosystem coherent, AeroBeat follows these rules:

1. **One song can power many routines.** Do not duplicate song metadata per mode.
2. **One routine equals one song interpreted through one mode.** Do not mix Boxing and Dance inside a single routine.
3. **One chart variant equals one playable sequence.** Keep each difficulty / compatibility slice distinct.
4. **Charts target interaction families first.** Devices are compatibility notes, not the root abstraction.
5. **View modes are render strategies first.** Do not create separate content silos for portal vs track unless a future mode proves it is necessary.
6. **Mode-specific event vocabularies are allowed.** The chart envelope is shared; the authored payload is not forced into fake universality.
7. **Content ownership stays in `aerobeat-content-core`.** Feature, tool, UI, and assembly repos consume these contracts; they do not redefine them.

## First shipping recommendation

For the first shipping slice, AeroBeat standardizes on:

- `Song` as the reusable music source
- `Routine` as the missing gameplay package primitive
- `Chart Variant` as the single playable difficulty artifact
- `Workout` as the session/program container
- a shared chart envelope with mode-specific event payloads
- `gesture_2d` as the first target interaction family for Boxing + MediaPipe

That gives Boxing + Camera Tracking a practical v1 format now while preserving room for XR, JoyCons, keyboard fallback, and future gameplay families later.
