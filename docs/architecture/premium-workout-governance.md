# Premium Workout Governance

This document pressure-tests AeroBeat's **free-to-play + free/premium workout** strategy against the practical realities of:

- an **open-source client/runtime posture**
- **mod.io** as the current premium UGC/community/distribution shell
- an **AeroBeat-owned account + entitlement architecture**
- future expansion across **PC, mobile, arcade, and console**

The goal is to lock the parts that are safe to lock now and expose the parts that still require deliberate policy decisions.

## Strategic conclusion

The strategy can work, but only if AeroBeat treats **premium workout monetization as a governed product lane**, not just "community mods, but paid."

That means:

1. **AeroBeat can stay open-source** while still selling premium workouts.
2. **AeroBeat cannot rely on DRM-grade secrecy** to protect premium workout files.
3. **Premium UGC must be policy-heavy and review-gated in v1.**
4. **AeroBeat-owned identity, trust, entitlement, and approval state must remain canonical.**
5. **mod.io is acceptable as the current shell for PC-first premium UGC**, but it should not become the permanent center of commerce, identity, or moderation truth.

The business model is therefore viable if AeroBeat accepts that premium workout leakage is a **risk to manage**, not a **risk to eliminate**.

## Safe to lock now

These decisions are stable enough to lock immediately.

### 1. Open-source compatibility stance

AeroBeat should explicitly treat premium workouts like other digital creative goods in an open ecosystem:

- the **engine/client may be open-source**
- the **premium workout files, artwork, metadata, and license grants are not automatically open-source**
- purchase grants **access and license**, not perfect copy protection
- the product should rely on **account-linked entitlement checks, trusted install flows, moderation, and takedown policy**, not fantasy DRM

Recommended product language:

> AeroBeat is open-source software with both free and premium workout content. Open-source code does not imply that paid workout content is public-domain or freely redistributable.

### 2. Premium workouts should be a separate governed lane

Premium workouts should not be treated as a simple boolean on any arbitrary community upload.

Lock this structure now:

- **Free lane:** broad community publishing, subject to trust/moderation policy
- **Premium lane:** creator enrollment, stronger review, commerce policy, and entitlement handling

At minimum, premium workouts need these additional records:

- `creator_account_status`
- `premium_eligibility_status`
- `review_status`
- `price_tier`
- `licensed_assets_attestation`
- `difficulty_coverage_status`
- `accessibility_compliance_status`
- `fraud_or_abuse_flags`
- `takedown_status`

### 3. V1 should require review before premium publication

For v1, **every premium workout should require review/approval before first publication and before material updates**.

Recommended rule:

- free workouts may use lighter moderation/review paths
- premium workouts require **pre-publication review**
- premium workout updates that change charts, audio, licensing claims, pricing, or difficulty coverage should re-enter review

This is not optional polish. Paid UGC without review is how AeroBeat buys itself chargebacks, copyright disputes, cloned content, low-quality listings, and platform risk.

### 4. AeroBeat should own premium eligibility and trust decisions

mod.io can help host/distribute/discover premium UGC, but AeroBeat should own the approval decisions for:

- which creators may publish premium workouts
- which workout packages are allowed into the premium catalog
- which versions remain purchasable
- what gets suspended, refunded, delisted, or escalated

In practice, the premium lane should use **AeroBeat approval state** as the source of truth, even if mod.io mirrors visibility or commerce-serving state.

### 5. The anti-abuse stance should assume premium cloning will happen

AeroBeat should assume:

- a premium workout can be extracted once delivered to a client
- a bad actor can attempt to repost a cloned version as "free"
- a creator can attempt to resell near-duplicate charts or lightly modified packs
- platform/account farms can attempt refund abuse or spam publication

So the baseline protection model should be:

- strong content IDs and provenance tracking
- creator verification / enrollment for premium publishing
- review queue + human moderation
- duplicate detection heuristics
- rapid delist/takedown process
- sanctions against abusive creators/accounts

Not:

- "the files are hidden so nobody can copy them"

### 6. PC-first is the only comfortable premium UGC launch surface

AeroBeat should lock a conservative platform rollout posture:

- **PC:** acceptable first premium UGC target
- **mobile:** policy-sensitive, likely more curated or delayed
- **console:** policy-sensitive, partner-sensitive, likely requires tighter certification/compliance
- **arcade/commercial:** should use a stricter licensed catalog, not general open premium UGC

That does not mean other targets are impossible. It means PC-first remains the sane launch lane.

## V1-safe policy

These are the policies AeroBeat should adopt for a realistic first release.

### 1. Premium creator program

V1 premium workouts should be limited to creators who are explicitly accepted into a premium creator program.

Recommended requirements:

- verified AeroBeat account
- accepted monetization terms
- payout/tax onboarding where relevant
- strike history below threshold
- proven content quality on free lane first, or direct staff approval

This sharply reduces spam, impersonation, and low-effort paid uploads.

### 2. Premium review workflow

Recommended v1 workflow:

1. creator submits package plus premium metadata
2. automated validation checks package integrity, schema, media, and duplicate signals
3. automated policy checks scan title, description, thumbnails, and obvious abuse patterns
4. human review checks licensing claims, obvious plagiarism, content quality, category fit, and pricing band
5. AeroBeat approves or rejects the premium version
6. only approved version becomes purchasable

Required review dimensions:

- **rights/licensing attestation** for audio and any third-party assets
- **content authenticity** / duplication suspicion
- **minimum quality** and packaging completeness
- **difficulty/accessibility coverage**
- **metadata honesty**
- **safe-for-platform presentation**

### 3. Pricing policy should use bands, not arbitrary creator-set prices

V1 should not allow fully freeform premium pricing.

Recommended policy:

- define a **small set of allowed price bands**
- map each premium workout to one band during review
- allow exceptions only through explicit AeroBeat override

Example policy shape:

- **Band A:** short / starter premium workout
- **Band B:** standard single workout
- **Band C:** expanded or high-production workout pack
- later: themed bundles or official-featured collections

The exact numbers can remain unresolved for now, but the **banded pricing model** should be locked. That makes moderation easier, reduces sticker-shock abuse, and keeps catalog expectations understandable.

### 4. Premium workouts should meet minimum difficulty coverage

V1 premium workouts should not be sellable if they only serve a narrow elite audience unless they are clearly labeled as specialty content and explicitly approved.

Default recommendation:

- premium workouts should include **at least two difficulty slices**
- one should be a broadly approachable difficulty
- one may target a more advanced audience
- purely hard/pro-only premium content should be exception-only

Reason: AeroBeat is a fitness product, not just a hardcore rhythm chart market. Paid content should not routinely strand mainstream users.

### 5. Premium workouts should meet minimum accessibility/compliance requirements

At minimum, premium review should verify:

- clear intensity / comfort labeling
- accurate gameplay mode labeling
- visible difficulty labeling
- no deceptive thumbnails/descriptions
- no broken package references or missing required assets
- no disallowed scripts/unsafe payloads
- compliance with current camera-first gameplay constraints

Recommended later expansion:

- cadence/intensity ranges
- one-handed/limited-mobility suitability tags where honestly supported
- comfort / motion / spatial demand tags

### 6. Refund/takedown expectations must be explicit

Because premium UGC can be low-quality, infringing, or misleading, AeroBeat needs a policy baseline for:

- delisting premium workouts quickly
- suspending creator premium privileges
- revoking access where legally/product-appropriate
- handling refunds/credits when paid content is removed for cause

If this stays fuzzy, the first bad premium incident becomes a policy fire.

## Risky or policy-sensitive decisions still needing explicit choice

These should stay visible as unresolved decisions rather than being silently assumed.

### 1. What content classes may be premium?

AeroBeat should decide whether premium is allowed for:

- individual workouts
- workout bundles
- coaching overlays
- environments
- cosmetic-only content
- remix/derivative works using community-shared source material

Recommended v1 constraint:

- allow premium only for **whole workouts or tightly scoped workout packs**
- do **not** start with premium environments, premium coaching fragments, or fragmented micro-item pricing

### 2. How much duplication is too much?

AeroBeat needs a policy for near-duplicate or derivative workouts:

- same song, different chart
- same chart with tiny edits
- same workout structure with new thumbnail/title
- cloned premium content re-uploaded free

Recommended v1 stance:

- obvious reuploads or near-clones of premium workouts are disallowed
- derivative works need materially distinct authorship and must not confuse buyers
- AeroBeat reserves the right to delist disputed copies while reviewing provenance

### 3. What happens when entitlement truth disagrees?

AeroBeat still needs a policy for disagreement between:

- platform purchase truth
- AeroBeat account truth
- mod.io wallet/ownership truth

Recommended v1-safe stance:

- fail toward **temporary restricted premium access** when entitlement cannot be verified
- provide explicit resync/retry UX
- escalate unresolved disputes to support instead of silently granting permanent access

### 4. Offline behavior for premium workouts

AeroBeat should decide how generous offline access is after entitlement validation.

Recommended v1-safe stance:

- allow cached/offline play for previously validated owned premium workouts for a bounded period
- require periodic entitlement refresh
- do not promise indefinite offline ownership without periodic account verification

This is not anti-piracy magic. It is just sane entitlement hygiene.

### 5. Whether premium creators can self-update without re-review

Recommended answer for v1: **no** for material changes.

Potential future relaxation:

- typo-only metadata fixes without full review
- thumbnail-only changes under constraints
- trusted creators with limited fast-path privileges

## Platform-specific landmines

### PC

Best fit for v1, but still risky.

Main issues:

- easiest environment for file extraction and reposting
- highest chance of manual sideloading expectations
- community culture may resist strict premium moderation unless messaging is clear

Recommended posture:

- be honest that PC files can be copied
- keep official install/discovery UX entitlement-aware
- treat sideloaded/untrusted content as separate from trusted premium catalog flows

### Mobile

Main issues:

- app-store policy scrutiny
- entitlement syncing complexity
- premium UGC review expectations may be stricter
- background file/download behavior and storage constraints

Recommended posture:

- assume mobile premium UGC will require a more curated catalog
- avoid promising parity with PC premium community publishing at launch
- keep purchase and entitlement flows platform-native and conservative

### Console

Main issues:

- partner policy sensitivity
- more constrained commerce and identity flows
- stronger expectations around moderation, rights, and supportability

Recommended posture:

- assume premium UGC on console requires explicit platform-partner validation
- do not design v1 premium policy around console permissiveness
- be prepared for a curated or approved-only subset rather than open creator publication

### Arcade / commercial deployments

Main issues:

- venue licensing
- operational simplicity
- lower tolerance for community moderation incidents
- need for predictable catalog quality and uptime

Recommended posture:

- treat arcade/commercial as a **separate distribution policy lane**
- prefer whitelisted official or partner-approved catalogs
- do not inherit the open PC premium UGC rules by default

## Open-source compatibility model

The durable compatibility model is:

- **open-source codebase**
- **AeroBeat-owned trust/approval service**
- **licensed premium content files**
- **policy + moderation + account entitlements** instead of strong DRM

AeroBeat should be comfortable saying:

- we can sell premium workouts even though the client is open-source
- we cannot stop every unauthorized copy
- we can make the **official premium ecosystem** significantly better than piracy through convenience, trust, visibility, updates, account library value, and creator legitimacy

That is the realistic strategy.

## Recommended architecture consequences

### Required product records

AeroBeat should support first-party records for at least:

- creator premium eligibility
- workout review state
- workout pricing band
- workout rights/licensing attestations
- workout duplicate/provenance review notes
- takedown/suspension state
- entitlement state in AeroBeat terms
- platform/provider mappings as secondary data

### Required workflow states

Premium workouts should have explicit states such as:

- `draft`
- `submitted_for_review`
- `changes_requested`
- `approved_for_sale`
- `delisted`
- `suspended`
- `takedown_hold`

### Required trust split

AeroBeat should keep separate answers for:

- **is this package technically valid?**
- **is this package safe/trusted to install?**
- **is this package approved for premium sale?**
- **does this athlete currently have access?**

That separation matters because a technically valid workout may still be ineligible for premium sale or access.

## Later refinements, not v1 blockers

These are worthwhile later, but should not block the initial policy lock:

- trusted-creator fast lanes
- richer automated duplicate detection
- regional pricing sophistication
- more nuanced accessibility scorecards
- subscriptions or creator patronage layers
- web marketplace parity with in-app catalog sophistication
- creator reputation scoring beyond simple strikes/review history

## Final recommendation

AeroBeat should proceed with the strategy, but with the following explicit posture:

1. **Stay open-source, but do not promise copy-proof premium files.**
2. **Launch premium UGC only on a review-gated, creator-enrolled lane.**
3. **Use pricing bands, not arbitrary prices, in v1.**
4. **Require minimum quality, metadata honesty, and difficulty/accessibility coverage for premium sale.**
5. **Treat PC as the premium UGC launch lane; treat mobile/console/arcade as stricter future variants.**
6. **Keep AeroBeat-owned identity, entitlement, trust, and moderation state canonical even while mod.io remains the current shell.**

That is the version of the strategy that is realistic, supportable, and compatible with the architecture already being locked elsewhere in the docs.
