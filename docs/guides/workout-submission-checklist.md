# Workout Submission Checklist

Use this checklist before submitting any public AeroBeat workout in v1.

## Core package checks

- [ ] The package represents **one difficulty only**.
- [ ] The selected difficulty is labeled truthfully as `easy`, `medium`, `hard`, or `pro`.
- [ ] Every set points to a valid environment.
- [ ] The package includes a **thumbnail / cover-art asset**.
- [ ] Package metadata, title, description, and artwork describe the workout truthfully.

## Environment checks

- [ ] Every set has an environment layer.
- [ ] At minimum, the environment is a valid **static 2D background image**.
- [ ] If using an AeroBeat default environment, the package export contains the copied asset payload, not just an editor-only reference.
- [ ] If using custom video or GLB environments, assets are performant and correctly referenced.

## Coaching checks

If coaching is disabled:

- [ ] `coaches/coach-config.yaml` uses the minimal disabled payload.
- [ ] No dormant enabled-coaching sections are left behind.

If coaching is enabled:

- [ ] The package includes **one warm-up video**.
- [ ] The package includes **one cool-down video**.
- [ ] Warm-up length is between **1:00 and 5:00 inclusive**.
- [ ] Cool-down length is between **1:00 and 5:00 inclusive**.
- [ ] Every set has **one unique VO audio file**.
- [ ] VO content is relevant to the set and is not random, misleading, or contradictory filler.
- [ ] Coaching maturity / content is labeled using the expected self-declared ESRB-style posture.

## Premium pricing and runtime checks

If the workout is premium:

- [ ] Declared package runtime includes all workout sets.
- [ ] If coaching is enabled, declared runtime also includes warm-up and cool-down duration.
- [ ] Set-transition delay is **not** counted toward runtime.
- [ ] The listed price matches **$1 per 10 minutes, rounded up to the nearest whole dollar**.
- [ ] The package is not presented as a multi-difficulty bundle.

## Review and publishing checks

- [ ] The workout is ready for **public review before release**.
- [ ] Rights for all included content and assets have been self-attested truthfully.
- [ ] The package is not a clone or near-duplicate of an existing listing.
- [ ] If this replaces an opposite-lane version, the prior free/premium listing has been handled according to review guidance.
- [ ] If this is a material update to a published workout, expect it to re-enter review.

## Common reasons review may fail

- missing per-set environment coverage
- missing thumbnail / cover art
- coaching enabled but incomplete
- inaccurate runtime or price
- deceptive metadata or artwork
- obvious clone / near-duplicate behavior
- rights / licensing concerns
- broken file references or malformed package structure

For the canonical policy source, see [V1 UGC Submission and Review Policy](../architecture/v1-ugc-submission-and-review-policy.md).
