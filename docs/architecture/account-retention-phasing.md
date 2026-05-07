# Account and Retention Feature Phasing

This document defines which **account-driven product systems** belong in the AeroBeat **launch product (v1)** versus later releases.

It is intentionally opinionated.

The goal is not to list every sticky feature AeroBeat could someday support. The goal is to decide what must exist for the first **PC-first free-to-play launch** to feel compelling, recoverable, and worth returning to without bloating v1 into a half-built social platform.

See also:

- [Account, Identity, and Entitlements Strategy](account-identity-and-entitlements.md)
- [Premium Workout Governance](premium-workout-governance.md)
- [Backend API Specification](backend_api.md)

## Strategic conclusion

AeroBeat v1 should ship with a **narrow first-party account and retention loop**:

1. **AeroBeat-owned account identity and linked-account recovery**
2. **free vs premium workout entitlement + library sync**
3. **basic profile/preferences + workout history**
4. **Workout Points (WP) as the single launch progression currency**
5. **simple weekly goals and streaks**

That is enough to support the launch promise:

- the app is free-to-play
- athletes can discover free workouts and buy premium workouts
- progress survives device changes
- the product has a reason to come back next week

AeroBeat does **not** need friends, global social graphs, real-time multiplayer, premium currency, a battle pass, or a rotating live-ops shop to be compelling at launch.

Trying to ship all of those at once would create a broad but fragile product. AeroBeat needs a strong workout loop first, not a bloated meta-game.

## Launch success criteria

For this strategy, v1 is successful if a new athlete can:

1. install the game for free
2. start quickly, including with a guest path for free content
3. create or link an AeroBeat account when they want durable progression or premium ownership recovery
4. browse trusted free and premium workouts
5. buy a premium workout through platform-compliant commerce and see ownership sync reliably
6. complete workouts and see meaningful progress accumulate
7. feel a clear reason to come back later this week

The launch retention loop therefore needs to answer two practical questions:

- **Why should I trust this as my long-term workout library?**
- **Why should I come back tomorrow or next week?**

The first answer is account identity + entitlements + history.
The second answer is WP + simple goals + streaks.

## v1 feature cut

## Ship in v1

### 1. AeroBeat account identity, guest conversion, and linked-account recovery

This is a **hard requirement**.

V1 should support:

- guest entry for limited free-play onboarding
- sign-in / account creation for durable progression
- linked platform/provider identity records
- recovery of owned premium workouts and cloud-backed progression on a new device
- explicit guest-to-account conversion rules

Why it belongs in v1:

- premium workout ownership without recovery is a support nightmare
- free-to-play products need a clean path from casual tryout to durable identity
- this architecture is already required by the entitlement strategy

### 2. Entitlements, library sync, and install authorization

This is also a **hard requirement**.

V1 should support:

- free vs premium workout access checks
- owned workout library sync in AeroBeat terms
- install/download authorization for trusted content
- resync/relink UX when ownership cannot be verified

Why it belongs in v1:

- it is the product contract behind free + premium workouts
- it is necessary for official premium access to feel legitimate and recoverable

### 3. Basic profile, preferences, workout history, and lifetime stats

V1 should include a practical profile layer, not a giant social identity layer.

V1 should support:

- athlete display identity in AeroBeat terms
- saved preferences relevant to workout selection and comfort
- recent workout history
- simple lifetime stats such as total sessions, total minutes, and lifetime WP earned

Why it belongs in v1:

- athletes need visible continuity for a fitness product
- this makes the account feel useful even before deeper social features exist

### 4. Workout Points (WP)

**Workout Points should ship in v1.**

WP should be the only meaningful progression currency at launch.

V1 expectations:

- award WP after completed workouts
- keep the grant model simple and understandable
- store WP in a first-party authoritative ledger
- expose current balance and lifetime earned totals
- support a small curated set of official cosmetic/profile unlock sinks if enough launch content exists

Why it belongs in v1:

- AeroBeat already frames WP as the core progression language
- it creates a durable, low-complexity reward loop without introducing premium-currency pressure
- it gives the product a sense of growth even before deeper content cadence systems exist

Important constraint:

> V1 should ship **WP**, not a full economy platform.

That means no complicated exchange systems, no multiple soft currencies, and no live-ops-heavy store dependency.

### 5. Weekly goals and streaks

**Simple weekly goals and streaks should ship in v1.**

Recommended v1 shape:

- athlete chooses or receives a simple weekly target such as workout days or sessions
- the game shows progress toward that target
- the product tracks a streak based on completed weekly goals or another clearly defined consistency rule
- the rule is transparent and forgiving enough for a fitness product

Why it belongs in v1:

- fitness retention depends more on consistency than on score-chasing alone
- WP without a cadence loop becomes a generic points counter
- weekly framing is better aligned with workout habit-building than a punitive daily-only loop

Important constraint:

> V1 should use **simple, transparent streak logic**, not manipulative live-ops pressure.

Recommended posture:

- prefer a **weekly consistency streak** over a brittle daily log-in streak
- avoid monetized streak repair mechanics in v1

## Defer from v1

### Leaderboards

**Do not make leaderboards a v1 requirement.**

They are valuable, but they are not necessary to prove the core product.

Why defer:

- score integrity and anti-cheat posture are non-trivial in a camera-based workout product
- leaderboards favor the more competitive slice of the audience, while launch must first prove broad workout appeal
- v1 already has enough account complexity from premium entitlements and progression

Recommended first deferred priority:

- start with **asynchronous, scoped leaderboard concepts** later, not a giant global competition stack on day one

### Friends / following / crews

**Do not ship a full social graph in v1.**

Why defer:

- social graphs multiply moderation, privacy, safety, and notification complexity
- they are more valuable after the base content/progression loop is stable
- crews especially imply private leaderboards, activity feeds, invites, and moderation tooling

Recommended posture:

- defer the full feature
- reserve only the minimal identity primitives needed for later relationship models

### Real-time multiplayer

**Real-time multiplayer should be firmly post-v1.**

Why defer:

- networking, session orchestration, and anti-abuse are substantial systems on their own
- multiplayer is attractive but not required for the first compelling workout product
- the launch product should prove that solo workout retention and premium content access work first

### Unlockable cosmetics / environments / avatars as a large catalog system

**Controlled customization matters, but a large cosmetic program is not a v1 blocker.**

Recommended v1 posture:

- ship only a modest set of official unlockables if content supply is ready
- do not require a broad cosmetic catalog, rotating storefront, or complex rarity economy

### Premium currency / earnable premium loops

**Do not ship premium currency in v1.**

Why defer:

- it introduces pricing, wallet, refund, fraud, and live-ops complexity that the launch product does not need
- AeroBeat already has premium workouts as the launch monetization lane
- WP already covers the non-cash progression loop

### Battle pass / seasonal progression

**Do not ship a battle pass in v1.**

Why defer:

- battle-pass systems require content cadence, reward planning, season operations, and expiration policy
- shipping one too early often creates an obligation treadmill before the product loop is proven
- AeroBeat should first prove that workouts themselves drive repeat engagement

### Rotating point shop / premium shop layers

**Do not make rotating shops a v1 dependency.**

Why defer:

- they create live-ops pressure and content hunger
- they are more appropriate once WP sink behavior and cosmetic demand are known

## Design depth: what must be fully designed now vs lightly designed now vs safely wait

## Must be fully designed now

These directly affect the launch product contract and should not be left fuzzy.

### Account identity and recovery

Must be designed now:

- canonical `athlete_id`
- guest vs signed-in actor model
- guest-to-account upgrade path
- linked-account model for platform/provider identities
- recovery/relink flows for premium ownership and progression

### Entitlements and library truth

Must be designed now:

- free vs premium access vocabulary
- owned library shape in AeroBeat terms
- entitlement sync/reconciliation states
- install authorization decisions
- offline/cached premium access policy

### Workout completion event model

Must be designed now:

- what counts as a completed workout
- what event is recorded locally vs server-side
- idempotency / replay protection for progression grants
- minimum anti-abuse posture for points and streaks

### WP ledger and grant rules

Must be designed now:

- authoritative grant path
- base earn formula or equivalent rule set
- balance vs lifetime-earned semantics
- rollback/correction policy for bad grants

### Weekly goal and streak semantics

Must be designed now:

- whether goals are days, sessions, minutes, or a simple chosen weekly target
- when a week resets and in which timezone context
- what breaks or preserves a streak
- whether streaks are derived or stored

### Profile/preferences/history scope

Must be designed now:

- minimum cloud-backed profile fields
- which preferences are product-critical
- workout history retention shape for UI
- privacy posture for personal workout history

## Should be lightly designed now, then heavily deferred

These need enough design now to avoid boxing the architecture into a corner, but not enough to force v1 implementation.

### Leaderboards

Lightly design now:

- canonical workout/run identifiers
- score/result schema
- basic anti-cheat stance
- privacy/display-name implications

Defer:

- global ranking UX
- crew/friend filters
- seasonal ladder operations

### Friends / social graph / crews

Lightly design now:

- whether the account model should allow future friend/follow relationships
- basic privacy/block/report assumptions
- notification/event model seams

Defer:

- invites
- feeds
- chat
- crew roles and moderation tooling

### Cosmetic inventory and unlock catalog

Lightly design now:

- whether official unlockables use first-party inventory IDs
- how WP-owned unlocks differ from premium workout entitlements
- how official cosmetics stay separate from UGC cosmetics

Defer:

- large catalog plans
- rarity ladders
- rotating availability logic

## Can safely wait

These do not need meaningful v1 design depth beyond a note that they exist.

- premium currency wallets
- earnable premium-currency loops
- battle passes
- seasonal progression tracks
- rotating premium shops
- real-time multiplayer parties/lobbies/matchmaking
- broad social feeds
- gifting systems
- creator patronage/subscription systems

Those should be designed only after AeroBeat has real usage data and a stable content cadence.

## Recommended post-v1 priority order

If AeroBeat launches successfully, the recommended order is:

### 1. Scoped leaderboards and async competition

Why first:

- high motivational upside
- lower complexity than full social graphs or multiplayer
- fits the workout-and-improvement fantasy well

Recommended shape:

- workout-specific leaderboards
- personal-best comparisons
- possibly time-boxed challenge boards later

### 2. Friends / following and lightweight social accountability

Why second:

- social accountability can materially improve retention
- works well once rankings and shareable progress already exist

Recommended shape:

- add friends/follows
- simple activity visibility or challenge sharing
- avoid full chat/community-platform sprawl at first

### 3. Expanded WP sinks and official cosmetic inventory

Why third:

- once WP earn rates are validated, expand reasons to spend it
- lets AeroBeat deepen progression without yet introducing cash-wallet complexity

Recommended shape:

- more official unlockables
- profile titles/badges
- limited rotating WP-only offers if content supply exists

### 4. Crews / group accountability features

Why fourth:

- valuable, but only once friend/accountability primitives already work
- requires more moderation and privacy tooling than simple following

Recommended shape:

- small crews/groups
- group goals
- scoped group leaderboards

### 5. Real-time multiplayer or ghost competition

Why fifth:

- attractive and stream-friendly, but technically expensive
- should follow proof that async social retention is worth extending

Recommended shape:

- consider ghost competition before full live lobbies if the product needs a cheaper intermediate step

### 6. Premium currency, seasonal progression, battle pass, rotating premium shop

Why last:

- these are live-ops multipliers, not launch necessities
- they are easiest to justify after AeroBeat has DAU, retention data, and a dependable premium content pipeline

## Explicit feature-by-feature decision summary

| Feature | v1? | Design now? | Notes |
| --- | --- | --- | --- |
| AeroBeat account identity | Yes | Full | Canonical product identity |
| Guest path + conversion | Yes | Full | Required for free-to-play onboarding |
| Linked account recovery | Yes | Full | Required for premium/library recovery |
| Free/premium entitlements | Yes | Full | Core launch contract |
| Library sync | Yes | Full | Core launch contract |
| Profile/preferences/history | Yes | Full | Minimum continuity layer |
| Workout Points | Yes | Full | Single launch progression currency |
| Weekly goals | Yes | Full | Keep simple |
| Streaks | Yes | Full | Prefer weekly consistency framing |
| Leaderboards | No | Light | First strong post-v1 candidate |
| Friends/following | No | Light | Defer implementation |
| Crews | No | Light | Future group accountability layer |
| Unlockable cosmetics catalog | Partial at most | Light | Small official set only if content ready |
| Premium currency | No | Wait | Unneeded v1 complexity |
| Earnable premium loops | No | Wait | Same as above |
| Battle pass | No | Wait | Needs live-ops cadence |
| Seasonal progression | No | Wait | Needs retention proof and cadence |
| Rotating point shop | No | Wait | Optional later WP sink |
| Real-time multiplayer | No | Wait | Large technical scope |

## Final recommendation

AeroBeat should launch with a **disciplined account-and-retention cut**:

- first-party account identity
- premium entitlement recovery
- profile/history continuity
- Workout Points
- simple weekly goals and streaks

Everything else should earn its way in later.

That cut keeps the launch product credible as a free-to-play workout platform without turning v1 into an underpowered imitation of a mature live-service game.
