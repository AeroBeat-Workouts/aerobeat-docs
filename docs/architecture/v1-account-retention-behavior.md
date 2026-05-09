# V1 Account and Retention Behavior

This document turns the retained v1 account/retention feature list into a concrete launch product contract.

It is intentionally narrow.

The goal is to make AeroBeat feel durable and worth returning to **without** bloating v1 into a half-built social platform or a manipulative live-ops shell.

See also:

- [Account, Identity, and Entitlements Strategy](account-identity-and-entitlements.md)
- [Account and Retention Feature Phasing](account-retention-phasing.md)
- [Workout Points (WP) Economy](../gdd/economy/currency.md)
- [Gamification & Habit Building](../gdd/gamification/overview.md)

## Product stance

AeroBeat v1 should answer two launch questions clearly:

1. **Can I trust this as my long-term workout library and progress record?**
2. **Do I have a simple reason to come back next week?**

The retained v1 features exist to answer those questions, not to maximize feature count.

## 1. AeroBeat account identity

## What it does in v1

AeroBeat has two actor states in v1:

- **Guest athlete** — local, device-scoped, fast entry for free workouts
- **Signed-in athlete** — durable AeroBeat account with cloud-backed progression and entitlement recovery

The canonical long-lived identity is the AeroBeat `athlete_id`.

In v1:

- guests can launch quickly and play the allowed free/trusted content path
- guests use the generic `Guest` identity and do not get a durable display-name/profile layer
- guests do **not** earn WP, build streaks, appear on leaderboards, use multiplayer, purchase premium content, or accumulate cloud-backed history/stats
- guest preferences/settings save locally only
- signed-in athletes get a durable `athlete_id`
- signed-in athletes have linked identity records for supported platform/provider surfaces
- product-facing state such as profile, history, WP, weekly goals, and streaks belongs to the signed-in AeroBeat account

AeroBeat display names do **not** need to be globally unique in v1.
A stable internal `athlete_id` matters more than username scarcity friction.

## What it does not do yet

V1 does **not** need:

- a public social profile graph
- searchable athlete directories
- friend codes
- crews/guilds/clubs
- in-app chat or DMs
- advanced account roles beyond normal athlete/admin support needs

## Rules and edge cases that matter now

- **Guest is not durable.** Guest progress should be treated as local-only until converted. The UI should say that plainly before premium purchase, library sync, or reinstall-risk moments.
- **Device reinstall risk is real.** If a guest uninstalls or changes devices before conversion, their guest progress may be lost.
- **Cloud truth only starts at account level.** Do not pretend guest state is recoverable unless it has been explicitly converted.
- **Provider identities are linked mappings, not product identity.** Steam/mod.io/etc. stay secondary to the AeroBeat `athlete_id`.

## 2. Guest-to-account conversion

## What it does in v1

Guest-to-account conversion is the bridge from casual tryout to durable ownership.

V1 conversion should happen when the athlete:

- explicitly chooses **Create Account / Sign In**
- attempts a premium purchase flow
- attempts ownership recovery on a new device
- attempts a feature that requires durable account state

When converting a guest to a **new** AeroBeat account, v1 should carry forward only the small local values that make the transition feel smooth:

- selected local preferences that are safe to reuse for the new account
- selected avatar / basic customization only if guest mode exposes any local cosmetic choice at all

Account-tracked systems start fresh at conversion time. Guest-mode activity before sign-in does **not** retroactively become:

- workout history
- lifetime stats
- WP balance or lifetime WP earned
- weekly goal progress
- streak progress
- leaderboard history

## What it does not do yet

V1 should **not** attempt a complicated universal merge engine.

Avoid:

- multi-account merge tooling
- hidden background merging between unrelated accounts
- conflict resolution across several previous devices
- support-heavy “combine everything” recovery promises

## Rules and edge cases that matter now

- **New-account upgrade is the happy path.** Guest mode is a local-only tryout path; creating an account is a clean step into durable identity.
- **Existing-account sign-in should not silently merge guest activity.** Default to the signed-in cloud account and ignore guest progression/history because guest mode does not accumulate those systems in v1.
- **This is not a merge engine.** The transition is intentionally simple: local guest settings may carry forward, but account progression starts when the account exists.
- **One-way conversion:** once the athlete signs in or creates an account, the signed-in account becomes canonical for all durable systems.
- **Device-specific settings stay local.** Camera calibration, graphics/performance settings, and similar hardware-specific settings should not be part of guest-to-account migration.

## 3. Premium ownership recovery

## What it does in v1

Premium ownership recovery is a launch requirement.

In v1, a signed-in athlete should be able to:

- link the required platform/provider identities
- sync owned premium workouts into their AeroBeat library
- install previously owned trusted premium workouts on a new device
- recover cloud-backed progression after sign-in

The athlete-facing recovery path should be simple:

1. sign into AeroBeat
2. relink or verify the required platform/provider identities if needed
3. run **Restore Purchases / Sync Library**
4. regain the owned premium library in AeroBeat terms

## What it does not do yet

V1 does **not** need:

- gifting
- family sharing policy complexity
- cross-account ownership transfers
- resale/trading
- support-issued manual entitlement codes as a normal product path

## Rules and edge cases that matter now

- **Premium access requires account-level identity.** Guests can browse premium catalog surfaces but should not be able to complete premium ownership flows as anonymous users.
- **Downloads require current or recently verified ownership.** New premium installs should require a valid entitlement check.
- **Offline play is allowed for already-downloaded premium workouts only.** If entitlement was previously verified and the premium workout is already installed on the device, the athlete may still play it while offline.
- **Offline behaves like guest mode for progression.** Offline workouts do not award WP, do not advance weekly goals or streaks, do not create leaderboard records, and do not reconcile retroactively into account progression later.
- **Recovery lag should degrade gracefully.** If store/provider sync is temporarily delayed, show a clear “ownership sync pending” state instead of hard-failing with a vague error.
- **No new premium downloads during unresolved entitlement state.** Previously verified installed content may still work offline if already present, but new installs should wait for reconciliation.
- **Entitlement disagreement should fail soft first.** Preserve access to already-installed previously verified premium content during temporary disagreement, but block new premium installs until truth is re-established.

## 4. Basic profile, preferences, history, and stats

## What it does in v1

The v1 profile is a practical continuity layer, not a social network.

### Cloud-backed profile fields

V1 should keep the cloud-backed account profile narrow:

- display name
- join date
- avatar / official cosmetic selections
- preferred mode (Boxing or Flow)
- preferred difficulty
- comfort/accessibility preferences that affect cross-device gameplay experience
- account timezone for weekly-goal/streak calculations

### Preferences split

Preferences should be split deliberately:

**Sync across devices:**

- preferred mode
- preferred difficulty
- accessibility / comfort toggles that shape the intended workout experience
- profile cosmetics and titles if those exist at launch

**Stay device-local:**

- camera calibration
- graphics quality
- input/device-specific tuning
- local audio/video settings

### Workout history and lifetime stats

V1 should provide enough history to make the account feel real:

- recent workout history list
- lifetime completed workouts
- lifetime active minutes
- lifetime WP earned
- current WP balance
- current weekly goal progress
- current streak
- best-effort summaries by Boxing vs Flow if available without major extra scope

## What it does not do yet

V1 should avoid:

- deep performance analytics
- coach heatmaps
- social showcase profiles
- profile bios/comments
- health-provider integrations
- CSV exports
- weight/body-measurement storage
- “supporter-only analytics” complexity

## Rules and edge cases that matter now

- **Keep private fitness data narrow.** AeroBeat does not need sensitive health/biometric storage to make v1 sticky.
- **History should be append-only from completed workouts.** Do not let casual menu actions or test sessions pollute the history feed.
- **Stats should be understandable.** Avoid a giant wall of counters; show a few trustworthy numbers.
- **Timezone is product logic, not decoration.** Weekly-goal and streak calculations should use the account timezone, not whichever device timezone happened to be active mid-travel.

## 5. Workout Points (WP)

## What it does in v1

WP is the single launch progression currency.

Its v1 jobs are simple:

- reward completed workouts
- make improvement and consistency visible
- optionally unlock a small curated set of official profile/cosmetic rewards if content supply is ready

V1 should keep both:

- **current WP balance**
- **lifetime WP earned**

Those are different and both matter.

### Grant model

V1 WP grants should remain simple and predictable:

- award WP only for completed workouts
- base the grant primarily on workout duration and selected difficulty
- allow a modest performance/completion bonus if it stays legible
- grant a separate weekly-goal completion bonus if that feature ships with a reward

The existing formula in the economy doc is a reasonable v1 starting point if implementation wants a concrete first pass.

## What it does not do yet

V1 should **not** turn WP into:

- a cash-adjacent premium wallet
- a creator payout currency
- a trading currency
- an energy system
- a battle-pass progression layer
- a giant rotating store dependency

## Rules and edge cases that matter now

- **Server authority for grants.** WP grants should come from an authoritative workout-complete event path, not from a trusted local counter alone.
- **Idempotent completion IDs are required.** Retried uploads, duplicate submissions, or reconnects must not double-pay WP.
- **No quit/retry farming.** Incomplete or abandoned workouts should not generate normal WP grants.
- **Core gameplay should never be paywalled by WP.** WP is for progression and optional unlocks, not access to Boxing/Flow basics.
- **Spend scope stays curated.** In v1, WP should only unlock official items or official profile rewards, not arbitrary UGC goods.
- **Balance corrections need an admin path.** If grants were duplicated or revoked, AeroBeat needs an explicit correction mechanism rather than hidden save edits.

## 6. Weekly goals

## What it does in v1

Weekly goals are the main habit loop in v1.

The recommended launch shape is:

- the athlete chooses a **weekly workout-days goal**
- the supported goal range is **1 through 7 days per week**
- the default goal is **3 workout days per week**
- a day counts when the athlete completes any workout that day
- higher weekly-goal targets should pay a larger one-time WP reward when completed

This keeps the system extremely legible: work out on a day, and that day counts.

Weekly-goal completion should auto-grant a one-time WP bonus for that week.

## What it does not do yet

V1 does **not** need:

- a giant library of rotating challenges
- coach-authored goal templates
- minute-based personalized plans
- social/shared group goals
- premium-only goal tracks

## Rules and edge cases that matter now

- **Use account timezone.** Weeks should reset Monday 00:00 in the athlete’s account timezone.
- **Goal changes should apply next week, not retroactively.** Otherwise athletes can lower the target on Sunday and instantly “complete” the week.
- **Show progress transparently.** “2 of 3 workout days completed” is better than opaque scoring.
- **One completion reward per week.** Do not repeatedly reward the same weekly goal after it is hit.
- **Keep the day-count rule obvious.** If a signed-in athlete completes any workout that day, the day counts.

## 7. Streaks

## What it does in v1

V1 streaks should measure **weekly consistency**, not daily login obedience.

Recommended rule:

- a streak increments when the athlete completes that week’s weekly goal
- a streak breaks when the week ends without the goal being completed
- the first successful week starts a streak at `1`

This makes the streak about actual workout habit, not app-open compulsion.

## What it does not do yet

V1 should avoid:

- daily login streaks
- monetized streak repair
- paid streak shields/freezes
- streak competitions between athletes
- multiple parallel streak types

## Rules and edge cases that matter now

- **The streak rule must match the weekly-goal rule.** Do not run a hidden second consistency system.
- **Late sync tolerance matters.** If a workout finished before the weekly cutoff but uploads slightly later because of connectivity, allow a short reconciliation window so legitimate sessions are counted.
- **Streak state should be explainable.** Athletes should be able to see why the streak continued or broke.
- **Changing next week’s goal should not rewrite last week’s streak result.**

## Final recommendation

For v1, AeroBeat should be opinionated:

- guests can try the product fast
- durable value starts at account conversion
- premium ownership recovery must be reliable
- profile/history/stats should feel useful, not bloated
- WP should stay simple and authoritative
- weekly goals should optimize for realistic consistency
- streaks should reward meeting those weekly goals, not punish normal life

That cut is strong enough to support launch trust and retention without pretending AeroBeat already needs a full social/live-ops stack.
