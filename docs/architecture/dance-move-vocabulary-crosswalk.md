# Dance Move Vocabulary Crosswalk

**Date:** 2026-04-29  
**Purpose:** Bridge proposed AeroBeat Dance chart move families to searchable public terminology from Dance Central and Just Dance.

---

## How to use this

This is a **search helper**, not a claim that AeroBeat should copy branded move names directly.

Use this file to:
- look up example routines and move breakdowns online
- compare Dance Central's more technical decomposition with Just Dance's more player-readable presentation
- inform the final first-pass `feature: dance` chart YAML taxonomy

The general direction remains:
- use **Dance Central** for movement decomposition and transition logic
- use **Just Dance** for readability, cueing, and emphasis moments
- keep AeroBeat-authored YAML centered on durable, cross-song movement-function vocabulary

---

## Proposed move families vs branded search terms

| Proposed AeroBeat family | What it means in AeroBeat | Dance Central style search terms | Just Dance style search terms |
| --- | --- | --- | --- |
| `pose` | Hit a recognizable body shape on a beat | pose, hit, freeze, shape | pose, hit, stop, freeze |
| `hold_pose` | Sustain a pose across a window | hold, freeze, sustain | hold, freeze, gold move hold |
| `step` | Single directional foot placement | step, side step, forward step, back step | step, side step, march |
| `step_touch` | Step then bring feet together / touch | step touch | step touch, easy side step |
| `travel` | Move body position across space | travel step, grapevine, move across floor | travel, side travel, moving combo |
| `weight_shift` | Transfer weight to set up next move | rock step, weight change, prep step | sway, prep step, side shift |
| `reach` | Extend arm(s) outward/upward/etc | reach, extend | reach, arm up, point |
| `push` | Pressing action away from body | push, press | push, press, shove gesture |
| `pull` | Draw arm(s) back toward body | pull, row, draw back | pull, tug, row |
| `sweep` | Broad curved arm/body arc | arm sweep, body sweep | sweep, big arm arc |
| `swing` | Rhythmic swinging motion | swing, groove swing | swing, arm swing |
| `clap` | Clap on an accent | clap | clap |
| `hit` | Sharp punctual accent | hit, strike, accent | hit, sharp accent |
| `accent` | Generic musical punctuation move | accent, hit, musical accent | accent, hit, snap |
| `isolation` | Chest/hip/shoulder/head emphasis | chest pop, rib isolation, hip isolation, shoulder isolate | hip move, chest pop, body roll fragment |
| `turn` | General rotational reorientation | turn | turn |
| `pivot` | Smaller planted-foot reorientation | pivot turn, quarter turn | pivot, turn step |
| `spin` | Fuller more committed rotation | spin, full turn | spin, twirl |
| `bounce` | Repeated down-up energy | bounce, groove bounce | bounce, bouncy groove |
| `hop` | Small airborne accent | hop | hop |
| `jump` | Larger airborne accent | jump | jump |
| `kick` | Clear leg extension strike | kick, front kick, side kick | kick, high kick |
| `knee_lift` | Lift knee sharply | knee lift, knee up | knee up |
| `leg_lift` | General lifted-leg action, broader than knee drive | leg lift, side lift | leg lift, side leg |
| `groove` | Looser style span, vibe over exact geometry | groove, freestyle groove, bounce groove | groove, dance vibe, easy combo |

---

## Transition and stance concepts

| Proposed AeroBeat concept | What it means | Good search terms |
| --- | --- | --- |
| `stance_open` | Feet/body opened out | open stance, second position, wide ready stance |
| `stance_closed` | Feet/body more closed together | closed stance, feet together |
| `stance_wide` | Deliberately wide base | wide stance |
| `stance_split` | One foot forward/back | split stance, staggered stance |
| `prep` | Setup before a bigger move | prep, wind-up, ready position |
| `reset` | Return to neutral after phrase | reset, back to center, neutral |
| `recover` | Recover after accent/jump/turn | recover, land and reset |
| `transition` | Bridge between bigger authored moves | transition, connecting step |
| `weight_shift` | Rebalance for next action | weight transfer, rock step, sway |

---

## Suggested search strategy

### For technical breakdowns

Use **Dance Central** searches like:
- `dance central step touch`
- `dance central chest isolation`
- `dance central pivot turn`
- `dance central knee lift`
- `dance central weight shift`

### For readability and audience-facing phrasing

Use **Just Dance** searches like:
- `just dance clap move`
- `just dance gold move examples`
- `just dance spin pictogram`
- `just dance side step routine`
- `just dance jump move`

---

## Practical guidance for AeroBeat

Treat **Dance Central** as the stronger reference for:
- `step_touch`
- `weight_shift`
- `isolation`
- `pivot`
- `prep`
- `transition`

Treat **Just Dance** as the stronger reference for:
- `pose`
- `hold_pose`
- `clap`
- `sweep`
- `jump`
- `gold` highlight moments

Recommended hybrid:
- use **Dance Central's decomposition discipline** for the authored taxonomy
- use **Just Dance's readability/emphasis philosophy** for preview and highlight systems

---

## Current recommendation status

This file is a research bridge for the active Dance chart YAML slice.
It is not yet the final locked authored contract.

Related plan:
- `projects/aerobeat/aerobeat-docs/.plans/2026-04-29-aerobeat-dance-chart-yaml-slice.md`
