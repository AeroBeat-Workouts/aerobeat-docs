# Community Creations

AeroBeat still aims to support community-created workout content, but the current docs slice is now explicit about the locked **v1 publishing rules**.

## Durable content hierarchy

- **Song** → reusable audio and timing source
- **Chart** → one concrete playable difficulty / compatibility slice
- **Set** → package-local composition record that links one Song, one Chart, one Environment, and optional coaching overlay choices
- **Workout** → ordered training session that assembles exact set selections

## Community content types kept in this slice

- **Songs**
- **Charts / Sets** for Boxing and Flow
- **Workouts**
- **Environments**
- **Coaching** inside the package's single `coaches/coach-config.yaml`

## Free vs premium community workouts

AeroBeat is a **free-to-play** product with two public workout lanes:

- **free workouts**
- **premium workouts**

mod.io remains the current outer community/distribution layer, but it is not the canonical source of AeroBeat identity, runtime trust, or long-term entitlement vocabulary.

For the compact launch policy, see [V1 UGC Submission and Review Policy](../../architecture/v1-ugc-submission-and-review-policy.md).

## V1 publishing rules

The following rules are locked for public workout publishing in v1:

- every package is **one difficulty only**
- alternate difficulties are separate workout packages
- coaching is **optional**, but if enabled it is **all-or-nothing**
- every set must have an environment layer
- a simple **static 2D background image** is an acceptable minimum environment
- every package must include a **thumbnail / cover-art asset**
- **all public UGC** must pass review before release

Premium workouts also follow the locked pricing rule:

- **$1 per 10 minutes, rounded up to the nearest whole dollar**
- counted runtime includes workout sets plus coaching media when coaching is enabled

## Building a workout

Creators assemble workouts by choosing:

- gameplay feature: Boxing or Flow
- chart difficulty intent
- exact songs, charts, and sets
- one environment per set
- optional coaching overlays through the package's single coach config

## Athlete overrides

Athletes may still want profile-level preferences such as:

- avatar identity
- preferred environment style
- coaching on/off
- accessibility and comfort settings

Those account-level choices are different from the old package-local gameplay asset swap model.

## What changed

Older docs taught package-local gameplay assets as a first-class workout authoring concept. That is being removed from the official v1 package story.

Older framing also risked implying that community distribution alone described the business/access model. That is no longer sufficient: workout publishing and discovery now live inside a broader free-to-play product with both free and premium access paths.

Future customization direction should instead point toward:

- controlled avatar customization
- cosmetics unlocks
- profile-driven progression using workout points
