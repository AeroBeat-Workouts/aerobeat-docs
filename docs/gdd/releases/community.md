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

For the current strategy:

- purchases must follow **official platform/store** paths
- mod.io remains the current **community/distribution layer** for premium UGC
- provider-side ownership synchronization should only rely on **official, non-deprecated surfaces** we can legitimately support
- the athlete-facing product should still speak in **AeroBeat ownership/access** terms rather than raw provider wallet terminology
- premium workouts should launch on a **review-gated premium lane**, not as arbitrary paid uploads
- PC is the safe launch surface; mobile/console/arcade should be treated as stricter future policy lanes

See also: [Premium Workout Governance](../../architecture/premium-workout-governance.md).

## Funding and progression

AeroBeat may still use supporter/community programs where helpful, but the main product framing should no longer imply that paid access is only a generic supporter status. The docs now need to distinguish between:

- supporter/community perks
- premium workout access
- long-term account-driven progression such as workout points, profile state, and cosmetics unlocks

Future customization should point toward controlled avatar/cosmetics progression via workout points rather than old package-asset mod examples.
