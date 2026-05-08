# Community Edition

The Community Edition is the first public-facing AeroBeat product path.

## Release priority

1. **PC community first**
2. **mobile second**
3. **VR third**

## Community Edition scope for this slice

- **free-to-play** app distribution
- official gameplay features: **Boxing** and **Flow**
- official gameplay input: **camera only**
- a workout catalog containing both **free workouts** and **premium workouts**
- offline-capable installed workouts once trust/access rules are satisfied
- workout browsing, favorites, recommendations, and progression surfaces
- AeroBeat-owned account architecture for profile/progression/library systems, even if some end-user account UX is phased

## Platform wording

The docs should stop implying present-tense parity across PC, mobile, and VR.

- **PC** is the main release target for the first community slice
- **mobile** remains an important follow-on target
- **VR** remains a later platform return, not the lead product shape

## Workout access model

### Free workouts

Free workouts are the on-ramp for the community edition. They should be discoverable without requiring the premium purchase path, while still respecting AeroBeat trust, compatibility, and install policy.

### Premium workouts

Premium workouts are paid content within the community ecosystem.

For the locked v1 strategy:

- purchases must follow **official platform/store** paths
- mod.io remains the current **community/distribution layer**
- athlete-facing UX should still speak in **AeroBeat ownership/access** terms rather than raw provider wallet language
- every premium package is **one difficulty only**
- premium pricing follows **$1 per 10 minutes, rounded up to the nearest whole dollar**
- counted runtime includes coaching media when coaching is enabled

## Public release gate

For launch, **all public UGC — free and premium — goes through mod.io Full Curation before release**.

That means:

- creators do not publish directly to the public catalog without review
- review is expected for first publication
- review is also expected again for **material updates**
- the approved live version stays up while a replacement version is under review unless the live version itself is under investigation

## Lane conversion rules

Free/premium lane conversion is not allowed in place.

- free → premium must be submitted as a **new premium item**
- premium → free must be submitted as a **new free item**

If the new submission is effectively the same workout as the prior opposite-lane listing, reviewers may require the old version to be removed.

See also: [Premium Workout Governance](../../architecture/premium-workout-governance.md) and [V1 UGC Submission and Review Policy](../../architecture/v1-ugc-submission-and-review-policy.md).

## Funding and progression

AeroBeat may still use supporter/community programs where helpful, but the main product framing should distinguish between:

- supporter/community perks
- premium workout access
- long-term account-driven progression such as workout points, profile state, and cosmetics unlocks

Future customization should point toward controlled avatar/cosmetics progression via workout points rather than old package-asset mod examples.
