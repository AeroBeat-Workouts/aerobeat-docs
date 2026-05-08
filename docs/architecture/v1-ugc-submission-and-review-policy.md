# V1 UGC Submission and Review Policy

This document is the compact source of truth for AeroBeat's locked v1 public UGC policy.

It covers:

- what a creator may publish in v1
- how pricing works for premium workouts
- what package requirements apply to both free and premium lanes
- how review, approval, updates, and suspensions work
- what AeroBeat does **not** try to solve in v1

## V1 public publishing model

AeroBeat v1 supports two public workout lanes:

- **Free workouts**
- **Premium workouts**

For launch, **all public UGC must pass review before release**.

The operational gate in v1 is **mod.io Full Curation**. AeroBeat may still present its own product language, rules, and review expectations, but v1 does **not** introduce a second AeroBeat-owned release cockpit as the public source of truth.

## Package rules locked for v1

### One difficulty per package

Every workout package represents **one concrete difficulty**.

- alternate difficulties are separate packages
- buying one premium difficulty does **not** unlock sibling difficulties automatically
- creators should not treat a package as a multi-difficulty bundle

The launch difficulty names remain:

- `easy`
- `medium`
- `hard`
- `pro`

## Pricing rule for premium workouts

Premium pricing is formula-based in v1:

> **$1 per 10 minutes of package runtime, rounded up to the nearest whole dollar**

Examples:

- 8 minutes → **$1**
- 14 minutes → **$2**
- 30 minutes → **$3**

### Counted runtime

Premium runtime includes:

- all workout-set runtime
- warm-up video runtime, if coaching is enabled
- cool-down video runtime, if coaching is enabled

Premium runtime does **not** include:

- the short automatic transition delay between sets

Creators do not choose arbitrary prices in v1. Reviewers verify that the declared runtime and resulting price are truthful.

## Coaching policy

Coaching is **optional** in v1.

If coaching is enabled, it is **all-or-nothing**:

- one warm-up video is required
- one cool-down video is required
- every set must have **one unique voice-over audio file**
- voice-over clips should be relevant to the set they accompany and should not be random, misleading, or contradictory filler

Warm-up and cool-down videos must each be between **1:00 and 5:00 inclusive**.

Moderation maturity posture for coaching uses a **self-declared ESRB-style content model**. Self-declaration does not excuse illegal, abusive, deceptive, infringing, or otherwise disallowed content.

## Environment and cover-art requirements

Every workout package must include:

- **one environment layer for each set**
- **a thumbnail / cover-art asset**

Environment requirements apply to both free and premium workouts.

The minimum acceptable environment is:

- a **static 2D background image**

Higher-fidelity video or 3D/GLB environments are optional upgrades, not baseline requirements.

To reduce creator burden, the intended tool direction is that creators may select curated AeroBeat-provided default environments and have those assets copied into the package automatically before validation/export.

## Review scope and philosophy

Review exists to protect trust, safety, legality, and catalog truthfulness.

Review should check for:

- malformed or broken packages
- missing required assets
- policy violations
- misleading storefront presentation
- obvious clone / near-duplicate abuse
- free-vs-premium lane violations
- rights / licensing self-attestation completeness
- unsafe or abusive content

Review should **not** act like vague editorial taste policing.

AeroBeat v1 does **not** require proof-of-rights documents in the normal workflow. Creators self-attest that they hold the necessary rights for the included content and assets.

## Approval vocabulary

The conceptual workflow is:

- `draft`
- `submitted`
- `under_review`
- `changes_requested`
- `approved`
- `published`
- `rejected`
- `suspended`

In v1, these concepts map onto **mod.io moderation / Full Curation mechanics** rather than a separate AeroBeat-owned workflow engine.

The conceptual `suspended` state maps to **mod.io `deactivated`** for high-risk post-publication cases.

## Material updates and re-review

Published workouts must re-enter review for **material updates**.

Treat an update as material if it changes:

- workout content
- difficulty
- runtime
- premium price
- coaching media
- environment assets
- thumbnail / cover art
- metadata or storefront truthfulness
- anything else that affects policy compliance or user expectations

Clearly minor updates such as typo fixes or harmless metadata cleanup may bypass full re-review at reviewer discretion. If there is doubt, treat the update as material.

When a new version enters review, the currently approved live version remains available unless the live version itself is under policy, legal, safety, or trust investigation.

## Lane conversion rules

Lane conversion is **not allowed in place**.

- free → premium must be submitted as a **new premium item**
- premium → free must be submitted as a **new free item**

If the new item is effectively the same workout as the prior opposite-lane listing, reviewers may require the old version to be removed as a condition of approval.

## Repeated failed resubmissions

After **3 resubmissions**, reviewers may block further resubmissions if the creator is not meaningfully addressing cited issues or appears to be spamming the review process.

## Rights and takedown posture

Creators self-attest that they have the rights needed for all submitted content and assets.

In v1:

- AeroBeat does **not** require proof-of-rights documents in standard submission flow
- copyright / DMCA / takedown routing should use **mod.io's reporting and moderation system**
- repeat or severe abuse may lead to removal, deactivation, or creator sanctions

## Explicitly out of scope for this policy

This document does **not** reopen or solve:

- boxing difficulty taxonomy specifics
- flow difficulty taxonomy specifics
- exact prefab-tag rules for advisory difficulty recommendation
- deeper coaching discovery taxonomy
- Peanut Gallery advisory integration details

Those belong to later follow-on design work, not the locked v1 launch policy.
