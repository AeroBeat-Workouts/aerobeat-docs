# Gameplay Core: Boxing

Boxing is one of the two official AeroBeat v1 gameplay features.

## Core loop

1. Boxing beats arrive in time with the music.
2. The athlete throws timed straights, hooks, uppercuts, guards, squats, and weaves as authored by the chart.
3. Successful reads maintain combo and reinforce workout flow.
4. The workout emphasizes cardio, rhythm, and readable movement patterns.

## Scope notes for this slice

- official gameplay input is **camera only**
- Boxing should be documented primarily around camera-readable movement
- the current chart contract is semantic Boxing gameplay, not portal-driven authored placement

## Current mechanics emphasis

- handed `straight_*`, `hook_*`, and `uppercut_*` strikes
- `guard`, `squat`, and `weave_*` movement prompts
- readable Track View and Portal View presentation options without making portal semantics part of the chart contract

## BeatSaver conversion reference

For the canonical BeatSaver-to-Boxing v1 conversion rules, ignored objects, and unresolved source edge cases, see:

- [BeatSaver to AeroBeat Boxing v1 Conversion](../../architecture/beatsaver-boxing-v1-conversion.md)

This gameplay page stays focused on the feature itself; the conversion contract lives in Architecture.

## Wording guardrails

When describing Boxing, prefer language that supports the current product thesis:

- camera-first gameplay
- PC-first release
- semantic Boxing chart vocabulary aligned to `straight_*`, `hook_*`, `uppercut_*`, `guard`, `squat`, and `weave_*`
- future VR/non-camera possibilities without presenting them as current parity or contract truth
