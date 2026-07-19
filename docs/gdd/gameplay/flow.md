# Gameplay Core: Flow

Flow is the second official AeroBeat v1 gameplay feature.

## Core loop

1. Flow gameplay uses a calibrated athlete-relative 4x3 play grid.
2. The athlete enters target cells with the correct wrist in time with the music.
3. Arrow-note correctness comes from recent wrist motion direction; dot-note correctness comes from timed cell entry without an added direction requirement.
4. Successful reads maintain combo and support a smooth full-body workout rhythm.

## Scope notes for this slice

- official gameplay input is **camera only**
- Flow remains an active retained feature
- the old portal/placement authored model is not current product truth
- broader device/input permutations can stay future-facing, not official v1 parity claims

## Mechanics emphasis

- direct 4x3 cell-entry gameplay
- rolling wrist-motion direction checks for arrow notes
- bombs as wrist-space hazards to avoid
- obstacles as nose-space occupancy bans
- arcs/sliders as guidance-only visuals in v1
- movement that remains understandable on the PC-first camera product path

## BeatSaver conversion reference

For the canonical BeatSaver-to-Flow v1 conversion rules, object treatment, frozen burst schema, and still-open implementation seams, see:

- [BeatSaver to AeroBeat Flow v1 Conversion](../../architecture/beatsaver-flow-v1-conversion.md)

This gameplay page stays focused on the feature itself; the conversion contract lives in Architecture.
