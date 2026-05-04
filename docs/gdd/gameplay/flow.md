# Gameplay Core: Flow

Flow is the second official AeroBeat v1 gameplay feature.

## Core loop

1. Flow charts author a flat `beats:` list under `feature: flow`.
2. The athlete swings through beats using the authored `type`, `placement`, and optional `direction` guidance. `placement` means where the beat passes; `direction` means follow-through guidance for max-score correctness.
3. Successful hits maintain combo and support a smooth full-body workout rhythm.
4. The feature emphasizes shoulder mobility, core rotation, and movement continuity.

## Scope notes for this slice

- official gameplay input is **camera only**
- Flow remains an active retained feature
- broader device/input permutations can stay future-facing, not official v1 parity claims

## Mechanics emphasis

- continuous arm arcs and follow-through
- body-movement prompts such as squats and leans
- authored placement/direction cues when they improve readability, without blurring pass-through location vs follow-through guidance
- presentations that remain understandable on the PC-first camera product path
