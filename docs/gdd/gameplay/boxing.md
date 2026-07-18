# Gameplay Core: Boxing

Boxing is one of the two official AeroBeat v1 gameplay features.

## Core loop

1. Targets arrive in time with the music.
2. The athlete punches, guards, leans, squats, or shifts as authored by the chart.
3. Successful reads maintain combo and reinforce workout flow.
4. The workout emphasizes cardio, rhythm, and readable movement patterns.

## Scope notes for this slice

- official gameplay input is **camera only**
- Boxing should be documented primarily around camera-readable movement
- portal-aware presentation can stay in the docs, but it should not imply a current VR-first product focus

## Current mechanics emphasis

- directional punches such as `punch_left`, `punch_right`, hooks, and uppercuts
- `guard` prompts, authored stance semantics, and body-movement prompts
- authored portal placement where it improves choreography readability
- readable Track View and Portal View presentation options

## BeatSaver conversion reference

For the canonical BeatSaver-to-Boxing v1 conversion rules, ignored objects, and unresolved source edge cases, see:

- [BeatSaver to AeroBeat Boxing v1 Conversion](../../architecture/beatsaver-boxing-v1-conversion.md)

This gameplay page stays focused on the feature itself; the conversion contract lives in Architecture.

## Wording guardrails

When describing Boxing, prefer language that supports the current product thesis:

- camera-first gameplay
- PC-first release
- `punch_left` / `punch_right` are the canonical input-truth Boxing punch labels
- `orthodox` / `southpaw` are authored stance semantics, not tracked input events
- future VR/non-camera possibilities without presenting them as current parity
