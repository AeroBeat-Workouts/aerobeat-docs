# Premium Workout Governance

This document translates AeroBeat's free-to-play + premium-workout strategy into the locked **v1 governance rules** for public community publishing.

For the compact canonical launch policy, see [V1 UGC Submission and Review Policy](v1-ugc-submission-and-review-policy.md).

## Strategic conclusion

AeroBeat's current v1 direction is to support both free and premium community workouts, but only if premium publication is treated as a governed lane with clear rules for:

- package scope
- pricing
- review before release
- truthfulness and rights self-attestation
- suspension and takedown handling

The launch system should optimize for **trust, clarity, and low operational scope**, not for perfect anti-piracy control.

## Locked v1 decisions

### 1. Premium remains a separate governed lane

AeroBeat v1 keeps two public workout lanes:

- **Free workouts**
- **Premium workouts**

Premium is not just a boolean toggle on an arbitrary upload. It carries stronger rules around review, pricing, and catalog trust.

### 2. One difficulty per package

A public workout package represents **one concrete difficulty only**.

That means:

- alternate difficulties are separate packages
- purchasing one premium difficulty does **not** automatically grant sibling difficulties
- premium review should not assume bundled cross-difficulty coverage inside one SKU

This replaces earlier assumptions that premium workouts should ship with multiple bundled difficulty slices.

### 3. Premium pricing is formula-based

Premium pricing in v1 is:

> **$1 per 10 minutes of package runtime, rounded up to the nearest whole dollar**

Examples:

- a package under 10 minutes still prices at **$1**
- a 14-minute package prices at **$2**
- a 30-minute package prices at **$3**

Counted runtime includes:

- all workout sets
- warm-up video runtime when coaching is enabled
- cool-down video runtime when coaching is enabled

Counted runtime does **not** include:

- short automatic delays between sets

Creators do not set arbitrary prices in v1. Review verifies that runtime and price are truthful.

### 4. Coaching is optional, but complete when enabled

Coaching is **optional** for both free and premium workouts.

If coaching is enabled, it is **all-or-nothing**:

- one warm-up video is required
- one cool-down video is required
- every set must have **one unique voice-over audio file**
- VO should be relevant to the set and should not be random, misleading, or contradictory filler

Warm-up and cool-down videos must each be between **1:00 and 5:00 inclusive**.

Coaching content adds value and therefore counts toward premium runtime when present.

### 5. Every set needs an environment, and every package needs cover art

Both free and premium workouts must include:

- an **environment layer for every set**
- a **thumbnail / cover-art asset**

The minimum acceptable environment is a **static 2D background image**.

Video and 3D/GLB environments are optional upgrades, not baseline requirements.

### 6. Public release is gated by mod.io Full Curation

For v1, **all public UGC, free and premium, must pass review before release**.

The operational gate is **mod.io Full Curation**.

AeroBeat may describe the policy in its own product terms, but v1 does **not** build a second AeroBeat-owned public release cockpit. This keeps launch scope lower while still enforcing review.

### 7. Review is about trust, policy, and truthfulness

V1 review should focus on:

- malformed or broken packages
- missing required assets
- misleading titles, descriptions, or artwork
- lane-rule violations
- clone / near-duplicate abuse
- self-attested rights posture
- policy / safety / legal concerns

Review should **not** become a vague editorial-quality filter based on taste alone.

### 8. Lane conversion is not allowed in place

A workout cannot be converted in place from:

- **free → premium**
- **premium → free**

Instead, creators must submit a **new item** in the destination lane.

If the new submission is effectively the same workout as the old opposite-lane listing, reviewers may require the prior listing to be removed as a condition of approval.

### 9. Material updates require re-review

Published workouts must re-enter review when an update changes:

- workout content
- difficulty
- runtime
- premium price
- coaching media
- environment assets
- thumbnail / cover art
- storefront truthfulness or other policy-relevant metadata

Clearly minor updates such as typo fixes may bypass full re-review at reviewer discretion. If there is doubt, treat the update as material.

The currently approved live version should remain available while a new version is under review unless the live version itself is under investigation.

### 10. Suspended maps to mod.io deactivated

The policy vocabulary should still include a conceptual **`suspended`** state for high-risk post-publication problems such as:

- DMCA / rights complaints
- fraud or bait-and-switch behavior
- safety issues
- severe clone / abuse concerns

In v1, that concept maps to **mod.io `deactivated`**.

### 11. Rights posture is self-attested in v1

Creators self-attest that they have the rights needed for all submitted assets and content.

V1 does **not** require proof-of-rights documents in the standard workflow.

The current operational route for DMCA / copyright / takedown handling is **mod.io's reporting and moderation system**, with AeroBeat retaining the policy vocabulary for creator sanctions and lane trust decisions.

### 12. Paid-workout legal posture is still pending firmer confirmation

The governance rules in this document describe the **current intended v1 operating model** for premium community workouts.

They do **not** claim that the broader DMCA / safe-harbor posture for paid creator workouts is already finally confirmed. AeroBeat is currently operating on the working assumption that creator self-attestation, review-gated publication, restrained promotion, and mod.io-centered reporting/takedown routing may be sufficient, but firmer provider/legal confirmation is still pending.

## Recommended workflow consequences

A premium-ready package should be expected to satisfy all of the following before approval:

- one-difficulty-per-package scope
- truthful runtime and formula-based price
- required environment coverage
- required thumbnail / cover art
- complete coaching media if coaching is enabled
- truthful metadata and lane classification
- successful review under mod.io Full Curation

## Not reopened here

This document does **not** reopen the separate follow-on work for:

- detailed boxing difficulty taxonomy
- detailed flow difficulty taxonomy
- prefab-tag recommendation rules
- Peanut Gallery advisory moderation details
- richer coaching discovery taxonomy

Those remain later design/system tasks, not launch-governance questions.

## Final recommendation

AeroBeat should launch premium UGC in v1 with a **small, explicit, review-gated rule set**:

1. one difficulty per package
2. formula-based pricing
3. coaching optional but complete when enabled
4. per-set environments plus required cover art
5. mod.io Full Curation for all public release
6. no in-place free/premium lane conversion
7. re-review for material changes
8. deactivated-as-suspended handling for high-risk issues

That posture is realistic and aligned with the now-locked v1 product policy as the current operating model, while the exact paid-workout legal sufficiency still awaits firmer provider/legal confirmation.
