# AeroBeat V1 Feature Detail and UGC Policy

**Date:** 2026-05-07  
**Status:** Stale  
**Agent:** Chip 🐱‍💻

---

## Goal

Define the detailed v1 behavior for the retained account/retention features and lock the policy rules for free vs premium UGC, including pricing bands, difficulty expectations, coaching requirements, and AeroBeat review/approval gates.

---

## Overview

The prior strategy pass locked the broad direction: AeroBeat is free-to-play, supports free and premium workouts, treats mod.io as the current premium/community/distribution shell, and needs AeroBeat-owned identity and entitlement architecture. We also narrowed v1 to a focused retention/account slice rather than trying to ship the whole long-term social/live-ops stack at once.

The next step is to go from architecture framing into **feature-detail and policy-detail**. That means documenting exactly how the v1 account/retention features behave — not just that they exist — and making product-policy calls for UGC that creators, reviewers, and future implementation can actually follow. This includes pricing bands, premium-vs-free content obligations, difficulty coverage rules, coaching-media requirements, and whether all UGC passes through AeroBeat review before release.

A key tension to resolve is creator burden versus premium quality. Requiring premium workouts to cover all four difficulty levels and full coaching media could create a much stronger premium bar, but it also materially increases authoring and QA effort. Likewise, requiring all UGC to go through AeroBeat review improves trust, moderation, and anti-cloning enforcement, but it also creates operational workload and throughput constraints. The point of this slice is to make those tradeoffs explicit and documented rather than leaving them as hand-wavy assumptions.

---

## REFERENCES

| ID | Description | Path |
| --- | --- | --- |
| `REF-01` | Free-to-play/account/UGC strategy plan | `.plans/2026-05-07-aerobeat-free-to-play-account-and-ugc-strategy.md` |
| `REF-02` | Account identity and entitlements | `docs/architecture/account-identity-and-entitlements.md` |
| `REF-03` | Premium workout governance | `docs/architecture/premium-workout-governance.md` |
| `REF-04` | Account/retention feature phasing | `docs/architecture/account-retention-phasing.md` |
| `REF-05` | Concept framing | `docs/gdd/concept.md` |
| `REF-06` | Community release framing | `docs/gdd/releases/community.md` |
| `REF-07` | Community creations framing | `docs/gdd/user-content/community-creations.md` |
| `REF-08` | Gamification overview | `docs/gdd/gamification/overview.md` |
| `REF-09` | Currency/economy framing | `docs/gdd/economy/currency.md` |
| `REF-10` | Coaching guide / philosophy | `docs/guides/coaching.md` |

---

## Tasks

### Task 1: Define the detailed v1 behavior for retained account/retention features

**Bead ID:** `aerobeat-docs-1zg2`  
**SubAgent:** `primary`  
**Role:** `research`  
**References:** `REF-01`, `REF-02`, `REF-04`, `REF-05`, `REF-08`, `REF-09`  
**Prompt:** In `aerobeat-docs`, claim the bead on start once created. Define the detailed v1 product behavior for the retained account/retention features: AeroBeat account identity, guest-to-account conversion, premium ownership recovery, basic profile/preferences/history/stats, Workout Points, weekly goals, and streaks. Clarify what each feature actually does in v1, what is intentionally omitted, and any implementation-shaping rules or edge cases that must be documented now. Update the active plan with findings and create/update the most appropriate docs.

**Folders Created/Deleted/Modified:**
- `.plans/`
- `docs/architecture/`
- `docs/gdd/`

**Files Created/Deleted/Modified:**
- `.plans/2026-05-07-aerobeat-v1-feature-detail-and-ugc-policy.md`
- `docs/architecture/v1-account-retention-behavior.md`
- `docs/architecture/account-retention-phasing.md`
- `docs/gdd/gamification/overview.md`
- `docs/gdd/meta/profile.md`
- `mkdocs.yml`

**Status:** ✅ Complete

**Results:** Added `docs/architecture/v1-account-retention-behavior.md` as the concrete v1 contract for the retained account/retention slice, then tightened it during human review. Phase 1 is now effectively locked around a stricter guest-vs-account boundary: guests can play free workouts, but they remain the generic `Guest` identity and cannot earn WP, appear on leaderboards, purchase premium content, use multiplayer, accumulate cloud-backed stats/history, or progress weekly goals/streaks. Guest preferences/settings save locally only. Signed-in AeroBeat accounts remain the only durable product identity, with platform/provider accounts treated as linked mappings rather than product truth.

Guest-to-account is now documented as a simple transition into durable identity, not a merge engine. Local guest settings may carry forward when the athlete creates or signs into an AeroBeat account, but guest-mode activity does not retroactively become account history, stats, WP, weekly-goal progress, or streak progress. Premium ownership recovery is a signed-in restore/sync flow, and previously downloaded premium workouts remain playable offline; however, offline sessions are explicitly treated like guest-mode play for progression, so they do not award WP or advance weekly goals/streaks and do not reconcile later.

The retention loop is also sharper now. Profile/stats stay cloud-backed only for signed-in athletes. WP is explicitly separate from workout score/leaderboards/personal bests, and both current balance and cumulative lifetime WP earned are retained. Weekly goals are locked as a simple 1–7 workout-days-per-week setting where completing any workout on a signed-in day makes that day count, with larger weekly WP bonuses for larger chosen goals. Streaks are locked as weekly streaks, not daily streaks. A WP-based streak-save mechanic is explicitly deferred as a later feature, not part of v1. Updated `docs/gdd/meta/profile.md`, `docs/architecture/account-retention-phasing.md`, and `docs/gdd/gamification/overview.md` to point at the new behavior spec, and added the new doc to `mkdocs.yml` navigation.

---

### Task 2: Lock pricing bands and free-vs-premium UGC policy requirements

**Bead ID:** `aerobeat-docs-3mn1`  
**SubAgent:** `primary`  
**Role:** `research`  
**References:** `REF-01`, `REF-03`, `REF-05`, `REF-06`, `REF-07`, `REF-09`, `REF-10`  
**Prompt:** In `aerobeat-docs`, claim the bead on start once created. Define the policy rules for free vs premium UGC at launch, including premium pricing bands, free/premium authoring expectations, difficulty coverage requirements, coaching-media requirements, and any other minimum quality/accessibility bars. Explicitly resolve or recommend positions on questions like whether premium workouts must support all four difficulties, whether free UGC may support only one, and whether premium workouts require coaching VO plus warmup/cooldown media. Document the tradeoffs, recommend the launch policy, and update the appropriate docs and active plan.

**Folders Created/Deleted/Modified:**
- `.plans/`
- `docs/architecture/`
- `docs/gdd/`
- `docs/guides/`

**Files Created/Deleted/Modified:**
- `.plans/2026-05-07-aerobeat-v1-feature-detail-and-ugc-policy.md`
- docs TBD

**Status:** ✅ Complete

**Results:** Phase 2 policy decisions are now locked, with one later human-reviewed adjustment on coaching and environment expectations. Premium workout pricing is no longer arbitrary or creator-chosen; it scales from total workout package runtime at **$1 per 10 minutes, rounded up to the nearest whole dollar**. Under this rule, a 14-minute package prices at **$2**, a 30-minute package prices at **$3**, and there is **no minimum premium runtime**. A package shorter than 10 minutes is still valid and prices at **$1**. Counted runtime includes **all workout sets**, plus **any coaching content that is present** such as the warm-up and cool-down videos. The short automatic delay between sets is explicitly not part of the declared workout package runtime and does not affect pricing.

Free and premium workouts are both locked to a **one-difficulty-per-package** model rather than bundling multiple difficulties into one SKU. Alternate difficulties remain separate workout packages, and purchasing one difficulty does **not** automatically grant entitlement to sibling difficulties. Later follow-up is now required to define the concrete design rules for what counts as **easy / medium / hard / pro** complexity, including boxing-vs-flow chart expectations, pattern/spacing density limits, and whether authoring-time prefabs plus validation scans should enforce those rules. The workout browser and suggested-workout surfaces should require a difficulty filter, not merely default one silently. New signed-in athletes start with **medium** as the default selected difficulty. After that, the system persists the **last difficulty value the athlete selected** and reuses it as their effective preference the next time the browser or recommendation surfaces load. The launch difficulty names remain the internal set: **easy, medium, hard, pro**.

Coaching is no longer required for either free or premium workouts. However, if coaching content is present, it remains an **all-or-nothing package feature**: the workout must include a warm-up video, a cool-down video, and **one unique voice-over audio file for every set in the workout**, with no within-workout VO reuse allowed. Because coaching content increases workout package value, its runtime counts toward the total package runtime and therefore the price of premium content. Coaching is also expected to become a discoverability/filter dimension in the workout browser rather than a hard release requirement. Additional follow-up is required to define coaching policy more concretely, including acceptable warm-up/cool-down duration ranges, baseline behavior/content rules for coaches on video and VO, and whether AI-assisted review such as Peanut Gallery emotion-engine scanning should be part of submission validation or moderation.

Environment requirements remain universal across free and premium workouts, but the policy is now more creator-supportive: every workout package must include an environment layer **for each set**, and a simple **static 2D background image** remains the minimum acceptable environment. To lower creator burden and reduce low-quality filler uploads, the AeroBeat workout creator should expose a curated set of AeroBeat-provided default environments that can be selected in-tool; when selected, those assets should be copied into the workout package automatically before validation/zip/export. Custom uploaded environments remain allowed, while video or 3D/GLB environments remain optional upgrades. Workouts are also explicitly required to include a thumbnail / cover-art asset regardless of whether the workout is free or premium. Phase 2 is now locked at the product-policy level, with the remaining follow-up being docs codification plus the separate deeper design work for difficulty standards, coaching guidelines, and creator-tool validation behavior.

---

### Task 3: Define the AeroBeat review/approval gate for all UGC

**Bead ID:** `aerobeat-docs-k03u`  
**SubAgent:** `primary`  
**Role:** `research`  
**References:** `REF-01`, `REF-02`, `REF-03`, `REF-06`, `REF-07`, `REF-10`  
**Prompt:** In `aerobeat-docs`, claim the bead on start once created. Evaluate and define the launch policy for AeroBeat review/approval of UGC, including whether all UGC (free and premium) must be reviewed before release, what that review is intended to catch (security, bad actors, quality, near-duplicate premium cloning, policy violations), how the approval states should work, and where the likely operational tradeoffs sit. Recommend a concrete launch approach and document it clearly.

**Folders Created/Deleted/Modified:**
- `.plans/`
- `docs/architecture/`
- `docs/gdd/`

**Files Created/Deleted/Modified:**
- `.plans/2026-05-07-aerobeat-v1-feature-detail-and-ugc-policy.md`
- docs TBD

**Status:** ✅ Complete

**Results:** Phase 3 review-gate policy is now locked, and Derrick explicitly chose the lower-scope **mod.io-native gatekeeping approach** for v1 rather than building an AeroBeat-owned review/release source of truth up front. The launch policy is: **all public UGC, both free and premium, must pass through review before release**, with **mod.io Full Curation** acting as the operational enforcement layer. This choice is intentionally motivated by lower scope, lower implementation complexity, and faster path to a governed launch, while preserving the ability for AeroBeat to layer additional review/release functionality on top later if the product proves the need.

The strategic framing is now explicit: in v1, **mod.io is the gate system**, not AeroBeat. AeroBeat can still present creator-friendly product language, but it should not invent a second authoritative approval cockpit yet. If a future phase justifies it, AeroBeat may transition toward its own richer source-of-truth workflow for review/release gating; however, that future system would be understood as **additional functionality layered over or eventually replacing the simple mod.io gate model**, not as something we should prematurely build now. This avoids duplicate reviewer/creator UX and unnecessary synchronization complexity before there is evidence that the extra system is needed.

At the product-policy level, the intended approval flow is still conceptually `draft -> submitted -> under_review -> changes_requested -> approved -> published -> rejected`, with **`suspended` now effectively required as an operational concept for high-risk post-publication issues** even if the exact UI/state mapping remains grounded in mod.io. For launch, those concepts should be mapped onto mod.io’s native moderation/curation mechanics instead of implemented as a separate AeroBeat-owned workflow engine wherever possible. Review is intended to catch security/policy problems, broken or malformed submissions, misleading storefront presentation, clone/near-duplicate abuse, and compliance with free/premium/coaching/environment rules. Two additional policy clarifications are now locked: **free -> premium conversion is not allowed in-place** and must instead be treated as a new premium submission under the premium workflow, with the old free item removed if it is effectively just the same workout with a price tag; likewise, **premium -> free conversion is not allowed in-place** and must instead be treated as a new free submission under the free workflow, with the old premium item removed if it is effectively just the same workout made free. Review also should not attempt to gate public release on vague aesthetic quality; instead, creator-quality differentiation should primarily emerge later through athlete feedback systems such as hearts/favorites and search/discovery filters rather than a heavy editorial moderation bar. The durable recommendation is therefore: **use mod.io’s built-in features now, keep scope low, and preserve the option to evolve toward AeroBeat-owned gating later only if justified by real product pressure.**

The Task 3 operational edge rules are now also locked. **Material updates** to a published workout must re-enter review if they change workout content, difficulty, runtime, premium price, coaching media, environment assets, thumbnail/storefront truthfulness, or other metadata that affects policy compliance or user expectations. Clearly **minor updates** such as typo fixes, grammar cleanup, and harmless metadata housekeeping may bypass full re-review at reviewer discretion; however, if there is doubt, the update is treated as material. Internally, AeroBeat may use Peanut Gallery or similar AI comparison tooling to compare the prior vs new submission and help classify whether an update appears minor, but any uncertain result should escalate into the material-update workflow rather than bypassing review.

The **live-version rule** is also explicit: when a published workout submits a new version for review, the currently approved live version remains available unless the live version itself is under policy, safety, legal, or trust investigation. The conceptual **`suspended`** state is now officially part of the v1 policy vocabulary and maps to **deactivated** on mod.io for high-risk post-publication cases such as DMCA/IP complaints, serious misleading storefront behavior, safety concerns, fraud/bait-and-switch, or severe clone/abuse concerns.

The **resubmission ceiling** is now locked as reviewer discretion after repeated failed attempts: after **3 resubmissions**, reviewers may block further resubmissions if the creator is not meaningfully resolving cited issues or appears to be spamming the review system. The **rights posture** is also locked: creators self-attest at submission time that they hold the necessary rights for all included content and assets, AeroBeat v1 does not require proof-of-rights documentation in the standard workflow, and copyright / DMCA / takedown handling should route through mod.io’s reporting and moderation system.

Finally, the lane-conversion duplicate rule is now explicit: if a creator submits a new free or premium workout that is effectively the same workout as an already published opposite-lane version, reviewers may require the prior version to be removed as a condition of approval rather than allowing duplicate listings separated only by monetization lane. With those additions, Task 3 is now fully locked at the governance and operational-policy level; the remaining future work belongs to later design slices such as difficulty taxonomy, coaching standards, creator-tool validation, and post-v1 commerce ideas rather than this launch-gate policy itself.

---

### Task 4: QA and audit the detailed v1 + UGC policy docs

**Bead ID:** `aerobeat-docs-sjkj`  
**SubAgent:** `primary`  
**Role:** `qa` then `auditor`  
**References:** `REF-01` through `REF-10`  
**Prompt:** In `aerobeat-docs`, claim the relevant bead on start once created. Independently verify that the new detailed v1 feature docs and UGC policy docs are coherent, realistic, and aligned with the already-locked free-to-play/account/entitlement strategy. Re-run docs validation, make minimum necessary fixes, update the plan with findings, and close the audit bead only if the resulting docs are ready to guide implementation and product decisions.

**Folders Created/Deleted/Modified:**
- `.plans/`

**Files Created/Deleted/Modified:**
- `.plans/2026-05-07-aerobeat-v1-feature-detail-and-ugc-policy.md`
- docs files only if minimum necessary follow-up is required

**Status:** ⏳ Pending

**Results:** Formal independent QA/auditor closure is still pending, but the practical codification and fallout-alignment work landed this session. `aerobeat-docs` now contains the locked v1 UGC submission/review policy and creator checklist, `mkdocs build --strict` passed there, and the immediate cross-repo fallout cleanup also landed in the affected AeroBeat repos. Remaining work is primarily the explicit QA/audit bead plus the deferred workout-creation-tool design beads rather than unresolved launch-policy questions.

---

## Phase 4 Follow-on (discussion lock-in so far)

Phase 4 is now scoped as the next design slice after the v1 UGC launch-gate policy: **difficulty taxonomy / validation** and **coaching standards / validation**. The current direction is that difficulty support should combine **authoring guidance**, **automated recommendation tooling**, and **human review examples** rather than relying on vibes alone. The workout creator should expose chart-authoring guidance plus examples of labeling mistakes and examples of charts that may technically pass heuristic checks while still violating difficulty intent.

For difficulty tooling, the current preferred shape is a first-class **Difficulty Validation Manager** that runs analysis and returns a **recommended difficulty**, a **confidence score**, and human-readable explanation of what drove that recommendation. The recommendation roadmap is now explicitly phased: **v0** has no beat prefabs and therefore no auto-recommended difficulty; **v1** introduces some beat prefabs and uses those tagged prefabs as the basis for difficulty auto-recommendations; **v2+** may optionally introduce further heuristics later if that complexity is earned. For v1, the preferred simple direction is to key recommendation primarily off the **highest tagged difficulty beat prefab used in the chart**: if a creator uses a `pro`-tagged prefab at least once, the system recommends `pro`. This is intentionally favored over a fuzzier density-only heuristic. If a creator authors entirely without prefab usage, the system may simply have no confident recommendation basis in v1 unless later heuristics are added.

A critical philosophy lock is that **AI/recommendation systems are advisory, not blocking**. The tooling should help creators and reviewers, but should not hard-block workout creation or submission solely because the recommendation engine disagrees. Derrick explicitly does **not** want hard AI blocks; recommendation drift over time is expected and patchable. Because the meaning of recommendations will evolve as the rules improve, AeroBeat should also **avoid storing historical recommendation outputs as durable truth**. Instead, reviewers should be able to run the current recommendation tooling/CLI/web flow against a package when they need present-tense judgment under the current ruleset.

The more detailed design work for **boxing and flow beat-prefab taxonomy** is now intentionally **tabled for a later session** rather than forced through this one. We still need to mention the prefab-based recommendation concept in the docs because it directly affects the AeroBeat workout-creation tools, but the specific prefab buckets/tags and the per-discipline difficulty taxonomy should be reopened later under a dedicated parent design bead or follow-on planning slice.

For coaching policy, the current direction is to use a **self-declared ESRB-style maturity/content model** rather than inventing an endlessly growing proprietary moderation taxonomy. Creators declare the content rating/maturity status; content that is illegal, abusive, deceptive, infringing, clearly unsafe, or otherwise violates platform / mod.io / AeroBeat policy remains disallowed regardless of declared maturity. Warm-up and cool-down videos, when coaching is enabled, should each have clear duration limits of **1:00 minimum through 5:00 maximum inclusive**. Coaching VO should also have a baseline intent rule: it should be reasonably relevant to the set it accompanies and should not be random, misleading, or contradictory filler.

The implementation scope is now explicitly phased in the same general way as the workout-authoring recommendation systems. **v0** focuses on mechanical correctness and manual creator entry. **v1** keeps that same low-scope posture rather than forcing AI into the path. **v2+** may introduce Peanut Gallery or similar systems for auto-recommendation, mismatch flagging, and human-review prioritization, but those systems remain advisory rather than blocking. Likewise, coaching discovery is intended to become a product/discovery dimension, while moderation stays focused on structure, policy compliance, truthful labeling, and baseline safety rather than subjective taste. Additional coaching standards work remains for later sub-slices, but the broad policy/tooling posture is now set.

---

## Follow-on execution outcomes captured this session

### Docs codification checklist for `aerobeat-docs`

**Execution bead:** `aerobeat-docs-ewco`

**Update now — highest priority docs/files:**
- `docs/architecture/premium-workout-governance.md`
  - codify the exact **$1 per 10 minutes, rounded up** pricing rule
  - make runtime include workout sets plus coaching content when coaching is present
  - replace any old multi-difficulty / coverage assumptions with **one-difficulty-per-package**
  - update coaching to **optional but all-or-nothing when enabled**
  - add environment-per-set requirement, static 2D minimum, and required thumbnail / cover art
  - lock **mod.io Full Curation** as the v1 public gate
  - capture no in-place free<->premium conversion, re-review rules, and `suspended` => mod.io `deactivated`
  - frame moderation as policy/trust/truthfulness/completeness review, not vague editorial quality review
- `docs/gdd/user-content/community-creations.md`
  - add a concise **v1 publishing rules** section covering one difficulty per package, coaching optionality, per-set environments, required cover art, and public review before release
- `docs/gdd/releases/community.md`
  - reflect mod.io Full Curation for all public UGC and add the lane-conversion + update re-review rules
- `docs/gdd/user-content/policing-content.md`
  - reframe v1 moderation away from any stronger AI-first posture and toward mod.io curation + human review
  - lock self-attested rights, mod.io DMCA routing, and deactivated-as-suspended mapping
- `docs/guides/coaching.md`
  - codify 1:00–5:00 inclusive warm-up/cool-down bounds
  - restate all-or-nothing coaching, VO relevance baseline, and ESRB-style self-declared maturity posture
- `docs/guides/modding_quickstart.md`
  - add a submission checklist for one-difficulty-per-package, required environment per set, thumbnail requirement, coaching completeness when enabled, and public review before release
- `docs/guides/environment_creation.md`
  - add static 2D minimum and AeroBeat-default-environment creator-workflow notes
- `docs/guides/demo_workout_package.md`
  - update the example package expectations to match the locked one-difficulty / coaching optional / per-set environment / required cover-art rules
- `mkdocs.yml`
  - add nav entries for any new canonical policy/checklist docs created below

**Recommended new docs to create now:**
- `docs/architecture/v1-ugc-submission-and-review-policy.md`
  - compact source-of-truth for pricing, submission requirements, review gate rules, conversion rules, re-review rules, rights posture, and moderation philosophy
- `docs/guides/workout-submission-checklist.md`
  - creator-facing checklist for assets, coaching completeness, environment/thumbnail checks, pricing/runtime truth, and common review failure reasons

**Implementation outcome on 2026-05-08:**
- added `docs/architecture/v1-ugc-submission-and-review-policy.md` as the compact canonical v1 source of truth for pricing, one-difficulty-per-package, coaching optionality, environment/cover-art requirements, review states, lane conversion, material re-review, rights posture, and mod.io `deactivated` as the operational `suspended` mapping
- added `docs/guides/workout-submission-checklist.md` as the creator-facing release checklist covering package scope, environments, coaching completeness, premium runtime/price truth, review readiness, and common review failure reasons
- rewrote `docs/architecture/premium-workout-governance.md` to align it with the now-locked v1 policy rather than earlier open questions or older multi-difficulty assumptions
- updated `docs/gdd/user-content/community-creations.md`, `docs/gdd/releases/community.md`, and `docs/gdd/user-content/policing-content.md` so the GDD now consistently reflects mod.io Full Curation for all public UGC, human-review-first moderation, self-attested rights, and no in-place free/premium lane conversion
- updated `docs/guides/coaching.md`, `docs/guides/modding_quickstart.md`, `docs/guides/environment_creation.md`, and `docs/guides/demo_workout_package.md` so the creator docs now match the locked v1 package/review rules
- updated `mkdocs.yml` navigation to surface the new canonical policy and checklist docs
- validation/build status: `./.venv/bin/mkdocs build --strict` passed; MkDocs emitted existing nav-coverage informational notices plus expected new-file git-timestamp warnings for the newly created docs

**Record as future follow-up rather than solving now:**
- boxing difficulty taxonomy specifics
- flow difficulty taxonomy specifics
- exact prefab-tag rules and recommendation UX details
- coaching/environment discovery taxonomy
- Peanut Gallery advisory integration specifics

### Deferred parent bead / phase definition

**Cross-repo audit bead:** `aerobeat-docs-kop4`

### Cross-repo cleanup execution opened from the audit

The audit fallout is now converted into executable follow-up work for this same session:
- `aerobeat-tool-api-rnf` in `aerobeat-tool-api` — realign repo charter/docs to the locked v1 UGC policy
- `oc-hvtv` in `aerobeat-vendor-modio` — separate provider capability from approved v1 product surface
- `oc-3pn` in `aerobeat-content-core` — align content package docs and validator with the current `workout.yaml` contract
- `aerobeat-tool-content-authoring-xyj` in `aerobeat-tool-content-authoring` — decide and clean up the legacy manifest compatibility path

These are execution beads, distinct from the later deferred Phase 4 taxonomy/design work.

**Suggested title:** `Phase 4 Follow-on: Difficulty Taxonomy, Coaching Standards, and Advisory Validation Design`

**Goal:** Define the deeper design-system work intentionally deferred from the v1 policy lock: boxing and flow beat-prefab taxonomy, exact difficulty-tag rules, creator-tool recommendation UX, future optional heuristics beyond prefab-based recommendation, richer coaching standards/examples, and v2+ Peanut Gallery advisory workflows.

**Why this is separate from the current plan:** The current plan locks launch behavior and v1 governance. This follow-on is a taxonomy/spec/creator-tool-design phase, not a policy-lock phase, and should not muddy the now-stable v1 launch rules.

**Suggested child tasks for that future phase:**
- boxing beat prefab taxonomy
- flow beat prefab taxonomy
- exact difficulty-tag rules by prefab/pattern family
- creator-tool difficulty recommendation UX
- future optional heuristics beyond prefab-tag recommendations
- deeper coaching standards/examples
- v2+ Peanut Gallery advisory workflows

**Explicit out of scope for that future phase:**
- reopening already locked v1 pricing, review-gate, coaching-optional, one-difficulty-per-package, or advisory-not-blocking decisions
- implementing the actual validator, reviewer dashboard, or blocking AI enforcement in v1

---

## Final Results

**Status:** ⚠️ Partial

**What We Built:** Locked the AeroBeat v1 UGC policy end-to-end for pricing, packaging, coaching optionality, review gates, conversion rules, update/re-review rules, rights posture, and the advisory-only Phase 4 recommendation philosophy. Codified those decisions into `aerobeat-docs`, added a canonical v1 submission/review policy doc plus creator submission checklist, and then cleaned up the most obvious cross-repo drift so the surrounding AeroBeat repos no longer overstate v1 scope or silently imply older package-truth paths are current.

**Reference Check:** `REF-01` through `REF-10` informed the policy lock and docs updates. The core codification pass updated the referenced governance/community/coaching docs directly, and the resulting `aerobeat-docs` build passed `mkdocs build --strict`. Remaining validation still needed is the explicit independent QA/auditor bead for the full docs set.

**Commits:**
- `60763a6` - `docs: codify v1 ugc submission and review policy`
- `fb8b449` - `docs: align tool api scope to locked v1 UGC policy`
- `2dceeb1` - `Clarify v1 product boundary in mod.io docs`
- `e3afcdc` - `Clarify legacy manifest validator status`
- `8dee256` - `Quarantine legacy manifest chart authoring`

**Lessons Learned:** Locking product policy first made the docs and repo fallout pass much cleaner. The biggest latent drift was not only in docs, but in legacy package-validator/authoring seams that still looked current until explicitly quarantined. The main deferred work is now well isolated: the workout-creation-tool design beads for prefab-based difficulty recommendation, coaching standards/examples, and eventual advisory tooling belong in the next session rather than being mixed back into the v1 launch-policy slice.

---

*Drafted on 2026-05-07*
