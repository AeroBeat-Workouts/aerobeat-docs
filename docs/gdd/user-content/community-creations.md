# Community Creations

AeroBeat still aims to support community-created workout content, but the current docs slice is more focused about what that means in v1.

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

AeroBeat is now explicitly a **free-to-play** product, so community workout distribution should be understood through two catalog lanes:

- **free workouts**
- **premium workouts**

mod.io remains the current outer community/distribution layer for this ecosystem, including premium UGC/community distribution, but it is not the canonical source of AeroBeat identity, runtime trust, or long-term entitlement vocabulary.

Premium publication should assume:

- platform-compliant purchase flows
- AeroBeat-owned trust and compatibility decisions
- provider-side ownership/distribution mechanics staying behind the vendor seam
- creator enrollment plus pre-publication review before sale
- pricing-band policy rather than arbitrary creator-set pricing
- minimum difficulty/accessibility coverage expectations for sellable content

For the current recommended guardrails, see [Premium Workout Governance](../../architecture/premium-workout-governance.md).

## What changed

Older docs taught package-local gameplay assets as a first-class workout authoring concept. That is being removed from the official v1 package story.

Older framing also risked implying that community distribution alone described the business/access model. That is no longer sufficient: workout publishing and discovery now live inside a broader free-to-play product with both free and premium access paths.

Future customization direction should instead point toward:

- controlled avatar customization
- cosmetics unlocks
- profile-driven progression using workout points

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
