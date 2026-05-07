# Account, Identity, and Entitlements Strategy

This document locks the current AeroBeat strategy for **accounts**, **identity**, **workout access**, and the boundary between **AeroBeat-owned product truth** and the current **mod.io provider shell**.

The short version:

- **AeroBeat is explicitly free-to-play.**
- The product supports both **free workouts** and **premium workouts**.
- **Platform-compliant purchase flows** are mandatory for premium access.
- **mod.io remains the current community/distribution layer** for premium UGC and related ownership/discovery flows.
- **AeroBeat still needs its own account architecture** as a first-class design concern for retention, product progression, and future portability.
- **`aerobeat-tool-api` is the AeroBeat-facing identity/access/entitlement layer**, not a thin mod.io wrapper.

## Product truth

AeroBeat should now be described as a **free-to-play rhythm workout platform**.

That means the base app can be installed and used without an up-front purchase, while the content model supports multiple access tiers:

- **free workouts**
- **premium workouts**
- future account-driven progression, cosmetics, and social systems

The important architectural consequence is that **workout access is no longer equivalent to simple community download access**. Some content is free, some content is premium, and the runtime needs a durable way to answer:

- who is this athlete?
- what devices/platform identities are linked?
- what workouts does this athlete own or have access to?
- which access came from free catalog policy vs paid entitlement?
- which content is currently trusted, compatible, and installable?

## Why AeroBeat-owned accounts matter even before the full account product ships

Even if AeroBeat phases the end-user account product over time, the architecture cannot assume that mod.io identity alone is the long-term product center.

AeroBeat needs an **AeroBeat-owned account model** because the product roadmap already implies first-party state such as:

- workout points
- streaks and goals
- athlete profile and preferences
- cosmetics and locker-room progression
- recommendations and retention systems
- social features and crews
- future multiplayer and competitive state
- cross-platform continuity expectations

Those are AeroBeat product systems, not vendor features.

So the strategy is:

1. **Design AeroBeat identity now** as a first-class architecture concern.
2. **Allow phased rollout** of the end-user account experience if product sequencing demands it.
3. **Do not let vendor account semantics become canonical** for long-lived product state.

## Canonical identity model

AeroBeat should treat its own athlete/account identity as canonical.

### Canonical AeroBeat records

AeroBeat-owned systems should be the source of truth for:

- `athlete_id`
- account status / guest vs signed-in state
- linked identity records per platform/provider
- profile and progression state
- entitlement summaries expressed in AeroBeat terms
- library sync state expressed in AeroBeat terms
- trust/approval/install policy metadata for workouts

### External identity mappings

External identity mappings remain important, but secondary:

- platform account identity (Steam, mobile store identity, console identity, etc.)
- provider identity such as mod.io user/account linkage
- provider content/listing/mod IDs

Those should be stored as mappings, not as the primary product identity.

## Access model: free workouts vs premium workouts

AeroBeat needs a stable product vocabulary for access.

### Free workouts

Free workouts are content the athlete may acquire or install without a paid entitlement.

They may still require:

- compatibility checks
- trust approval
- catalog visibility policy
- library sync or favorite/subscription state
- guest-vs-account access policy decisions

But they do **not** require a premium purchase entitlement.

### Premium workouts

Premium workouts are content whose access depends on a recognized entitlement path.

For the current strategy:

- purchases must flow through **official platform/store surfaces**
- mod.io can remain the current **premium UGC/community/distribution layer**
- AeroBeat should treat premium access as an **AeroBeat-facing entitlement decision** even if some transport/ownership synchronization is provider-backed

The runtime and docs should therefore talk about **premium workout access** or **owned premium workouts**, not about raw provider wallet semantics.

## Purchase and entitlement rules

### Rule 1: platform-compliant commerce only

AeroBeat should assume premium purchases originate through official platform-compliant paths.

Examples include:

- Steam or other PC storefront purchase flows
- mobile store purchase flows
- platform-holder compliant commerce on future platforms

AeroBeat should **not** architect around unofficial direct-billing shortcuts that would create platform-policy risk.

### Rule 2: mod.io may act as the current purchase/ownership server only after official sync

The currently acceptable strategy is:

1. user purchases through the official platform/store path
2. the game authenticates through legitimate supported identity surfaces
3. ownership/entitlement is synchronized to the provider where officially supported
4. mod.io may then act as the current ownership/purchased-content server for the premium UGC layer
5. AeroBeat still exposes the resulting access in AeroBeat terms

Important constraint:

> AeroBeat should rely only on **official, non-deprecated, legitimately supportable provider/platform surfaces**.

If a workflow is not clearly supported by official documentation or supportable product surfaces, the docs should not present it as a guaranteed implementation path.

## Responsibility split

### AeroBeat owns

AeroBeat owns the long-term product contract for:

- athlete identity
- linked-account model
- entitlement vocabulary
- free vs premium workout access policy
- profile/progression/retention systems
- trusted content IDs and compatibility policy
- install/mount/runtime trust decisions
- library experience as a product concept
- future migration path away from any one provider

### mod.io currently owns or assists with

mod.io is the current provider seam for:

- community/discovery shell
- premium UGC listing and distribution support
- provider-side ownership/purchase state after official sync where supported
- provider transport details such as account-linking mechanics, purchase sync mechanics, and owned-content queries

Those concerns should stay conceptually inside the **vendor seam**, not leak into long-lived AeroBeat product contracts.

## What `aerobeat-tool-api` should be

`aerobeat-tool-api` should be described as the **AeroBeat-facing identity, access, and entitlement layer** used by game clients and related product surfaces.

It should expose AeroBeat-shaped capabilities such as:

- guest/session bootstrap
- athlete sign-in and linked-account status
- content discovery views shaped for AeroBeat
- free vs premium access checks
- owned-workout/library sync
- install/download authorization for trusted content
- submission/status flows for creators
- normalized entitlement/access status for UI and runtime policy

It should **not** become:

- a raw mod.io DTO dump
- a generic REST wrapper for arbitrary provider endpoints
- the place where provider-specific account-linking mechanics become public contract
- a thin SDK clone whose vocabulary is just vendor terminology with AeroBeat branding pasted on top

## Vendor seam rule

All mod.io-specific transport and account-linking mechanics should stay inside the provider seam conceptually and, where possible, in provider-specific repos such as `aerobeat-vendor-modio`.

That includes details such as:

- provider auth exchange mechanics
- provider account-link requirements
- provider purchase-sync calls
- provider wallet/purchased-content transport
- provider ID formats and raw DTOs

`aerobeat-tool-api` should consume those capabilities indirectly and expose **AeroBeat-shaped results**.

## Recommended near-term implementation stance

Near-term implementation planning should assume:

1. **AeroBeat account architecture must be designed now**, even if the athlete-facing account product is phased.
2. **Free-to-play with free + premium workouts is the baseline product framing.**
3. **Platform-native purchase flows remain the commerce origin.**
4. **mod.io remains the current premium UGC/community layer**, not the long-term product center of gravity.
5. **`aerobeat-tool-api` should become the client-facing identity/access/entitlement manager**, with provider details staying in the vendor seam.

For launch-vs-later product slicing, see [Account and Retention Feature Phasing](account-retention-phasing.md).

## Explicit unresolved questions

These are intentionally left visible for follow-up work rather than hand-waved away:

1. **Account rollout phasing:** how much of the AeroBeat-owned end-user account experience must ship in v1 versus exist only as backend/architecture readiness?
2. **Cross-platform recovery UX:** what is the exact athlete experience for linking multiple platform identities to one durable AeroBeat identity and recovering premium purchases across devices/platforms?
3. **Entitlement reconciliation policy:** when AeroBeat account truth, platform purchase truth, and provider purchase truth disagree temporarily, which system wins for client UX and runtime access?
4. **Guest conversion rules:** which free-to-play behaviors remain available to guests, and which premium/community flows require sign-in?
5. **Catalog policy:** what content classes can ever be premium at launch, and what catalog-quality/moderation rules apply before premium publication?

Those should be handled in later strategy tasks rather than hidden inside this Task 1 docs pass.
