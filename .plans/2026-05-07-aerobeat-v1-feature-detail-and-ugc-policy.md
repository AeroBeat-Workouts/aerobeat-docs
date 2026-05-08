# AeroBeat V1 Feature Detail and UGC Policy

**Date:** 2026-05-07  
**Status:** In Progress  
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

**Results:** Phase 2 policy decisions are now locked. Premium workout pricing is no longer arbitrary or creator-chosen; it scales from total workout package runtime at **$1 per 10 minutes, rounded up to the nearest whole dollar**. Under this rule, a 14-minute package prices at **$2**, a 30-minute package prices at **$3**, and there is **no minimum premium runtime**. A package shorter than 10 minutes is still valid and prices at **$1**. Counted runtime includes **all workout sets plus the warm-up and cool-down videos**. The short automatic delay between sets is explicitly not part of the declared workout package runtime and does not affect pricing.

Free and premium workouts are both locked to a **one-difficulty-per-package** model rather than bundling multiple difficulties into one SKU. Alternate difficulties remain separate workout packages, and purchasing one difficulty does **not** automatically grant entitlement to sibling difficulties. If creators want to group related variants together, mod.io collections are the current possible grouping layer, but exposing collections directly in the AeroBeat UI remains undecided. The workout browser and suggested-workout surfaces should require a difficulty filter, not merely default one silently. New signed-in athletes start with **medium** as the default selected difficulty. After that, the system persists the **last difficulty value the athlete selected** and reuses it as their effective preference the next time the browser or recommendation surfaces load. The launch difficulty names remain the internal set: **easy, medium, hard, pro**.

Coaching direction is intentionally strict as the main quality divider between free and premium. Free workouts do not require coaching media. Premium workouts do require a **warm-up video**, a **cool-down video**, and **one unique voice-over audio file for every set in the workout**, with no within-workout VO reuse allowed. Environment requirements are universal across free and premium workouts, but the required floor stays intentionally low scope: every workout package must include an environment presentation layer, and a simple **static 2D background image** is sufficient for launch, while video or 3D/GLB environments remain optional upgrades. Phase 2 is now locked at the product-policy level; the remaining follow-up is documentation codification in architecture/GDD pages.

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

**Status:** ⏳ Pending

**Results:** Pending.

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

**Results:** Pending.

---

## Final Results

**Status:** ⏳ Pending

**What We Built:** Pending.

**Reference Check:** Pending.

**Commits:**
- None yet.

**Lessons Learned:** Pending.

---

*Drafted on 2026-05-07*
