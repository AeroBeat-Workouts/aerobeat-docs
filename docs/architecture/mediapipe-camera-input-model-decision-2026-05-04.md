# MediaPipe Camera Input Model Decision (Superseded Historical ADR)

> [!WARNING]
> **Status: superseded for current architecture wording.**
> This ADR is preserved as a historical record of the original **intent-first camera-input decision**, but it predates later repo and architecture cleanup.
> 
> Read the current docs as authoritative first:
> - `docs/index.md`
> - `docs/architecture/input.md`
> 
> Then verify concrete repo ownership/routing against the newer repo docs before assuming old MediaPipe naming still applies.
> 
> In particular, do **not** treat this page as the current source of truth for repo naming, provider packaging details, or present-tense implementation claims.

**Original date:** 2026-05-04  
**Current status:** Historical rationale preserved; current product truth lives in the newer architecture docs  
**Historical scope:** the earlier MediaPipe Python camera-provider path that informed later camera-tracking work for AeroBeat Boxing + Flow

---

## Why keep this page at all?

This page still captures one decision that remains directionally correct:

> **AeroBeat's camera gameplay contract should be intent-first, not fake-universal-skeleton-first.**

That principle survived the later cleanup. What did **not** survive unchanged was the surrounding repo/package framing and some present-tense wording about which concrete provider repo owned the work at that moment.

So read this page as:

- a record of **why** the team rejected "pretend we already have a gameplay-grade 3D body contract"
- **not** a current implementation spec
- **not** the authoritative repo map
- **not** a reason to teach old `MODE_3D` / MediaPipe Python wording as today's canonical public story

## The durable decision

The lasting architectural call was:

1. camera gameplay should expose **gameplay intents/states** as the official feature-facing contract
2. raw landmarks may still exist as provider/debug data
3. a richer tracked-body or world-space contract, if ever needed, should be versioned separately rather than smuggled in as baseline v1 truth

That remains aligned with the current docs slice:

- official v1 gameplay input is **camera only**
- the product focus is **camera-driven Boxing and Flow on PC first**
- future tracked-body / future-platform paths should not be described as equal-status current support

## What is outdated in this ADR

The following parts are historical only and should not be read as current truth:

- repo-level wording centered on **`aerobeat-input-mediapipe-python`** as if it were still the only present-tense public owner doc for camera gameplay
- implementation-detail wording that can be mistaken for a locked current contract instead of a snapshot from an earlier architecture pass
- any implication that old MediaPipe-specific transport names or repo shapes are the final public wording Derrick wants to keep teaching

The current docs slice has since moved toward a cleaner camera-tracking story and a stronger distinction between:

- current official camera gameplay
- future input/platform support
- historical or superseded implementation details

## Historical problem statement

At the time this ADR was written, the architecture needed to answer a real question:

- Should AeroBeat treat single-camera pose output as if it were already a reliable gameplay-grade 3D skeleton?
- Or should it expose camera-derived **intents** that match what Boxing and Flow actually need?

The answer was the second one.

## Historical conclusion

### Chosen direction

**Choose intent-first camera input. Reject 3D-skeleton-first as the v1 gameplay contract.**

### Why

Because a single forward-facing consumer camera path could not honestly guarantee:

- stable world-space semantics
- calibration/body-space truth
- reliable orientation normalization
- trustworthy velocity/rotation semantics
- enough consistency across occlusion, camera placement, and player scale to justify a generic gameplay skeleton claim

What it *could* honestly support was a gameplay-facing contract shaped around things like:

- left/right strikes
- guard state
- squat/height changes
- lean or lane-position changes
- broad flow swing direction or similar coarse motion families

That reasoning is still useful.

## How to translate this ADR into today's docs language

If you need the modern wording, use this translation instead of quoting the old repo-specific phrasing directly:

- **Then:** "MediaPipe Python should not pretend `MODE_3D` is gameplay-world truth."
- **Now:** "Current camera gameplay should not overclaim a generic world-space/tracked-body contract when the product truth is still camera-first Boxing + Flow."

- **Then:** "Boxing and Flow should consume intents instead of raw landmarks by default."
- **Now:** "Feature-facing contracts should describe the stable gameplay events/states the camera lane can support truthfully, while raw observations stay below that contract boundary."

- **Then:** "A future VR path can add richer body-state contracts later."
- **Now:** "Future input/platform lanes may add richer body-state or tracked-space contracts later, but they should be documented as future work until explicitly implemented and validated."

## What still holds up from the original analysis

These claims remain worth preserving:

- single-camera pose data is prone to occlusion and projection ambiguity
- raw landmark tuples are not automatically the same thing as a gameplay-grade body contract
- feature repos should not each reinvent the same low-level camera interpretation logic
- camera-specific heuristics belong closer to the camera-provider lane than to chart-judgement logic
- future richer tracking can coexist with an intent-first feature contract rather than replacing it retroactively

## What to cite instead for current truth

If you are updating or writing another doc, prefer citing these current pages instead of this ADR:

- `docs/index.md` for v1 scope
- `docs/architecture/input.md` for official input stance
- the newer repo-routing docs that own concrete camera-provider naming in whatever cleanup pass is current when you read this

Use this ADR only when you specifically need the historical rationale for **why AeroBeat rejected skeleton-first camera wording in the earlier architecture pass**.

## Final superseded-status note

This ADR is intentionally **not deleted**, because the reasoning still has value.

But its superseded status should be read as unmistakable:

- keep it for history
- do not quote it as current repo/package truth without translating it through the newer docs
- do not let it reintroduce old architecture wording into the live docs set
