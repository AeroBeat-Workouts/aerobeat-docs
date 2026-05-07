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

**Results:** Added `docs/architecture/v1-account-retention-behavior.md` as the concrete v1 contract for the retained account/retention slice. The strongest recommendation is to keep the launch loop disciplined and legible: guests can try free content quickly, durable value starts at account conversion, premium ownership recovery is a signed-in/library-sync flow, the profile stays narrow and useful, WP remains the single authoritative progression currency, weekly goals are based on workout days rather than manipulative daily login pressure, and streaks measure weekly-goal consistency rather than brittle daily behavior.

The new doc makes the feature boundaries explicit instead of leaving them as category labels. It defines two actor states (guest vs signed-in), recommends that only signed-in athletes receive a canonical durable `athlete_id`, and makes guest data intentionally local/unreliable until conversion. It also recommends that guest-to-account conversion be optimized for the **new-account upgrade** path and warns against trying to ship a broad multi-account merge engine in v1. For premium recovery, it defines a simple restore path, recommends a short offline entitlement cache for already-verified installed premium workouts, and says entitlement disagreements should fail soft before hard-locking the athlete out.

For retention behavior, the doc locks a more practical launch loop: cloud-backed profile fields stay narrow; device-specific settings stay local; WP grants come only from authoritative completed-workout events with idempotency protection; weekly goals are small curated workout-day targets with a default of 3 days/week; changes apply next week rather than retroactively; and streaks increment only when the weekly goal is completed. Updated `docs/gdd/meta/profile.md` so the profile hub now reflects that narrower v1 role instead of implying supporter analytics and other future-only depth. Also linked the new behavior doc from the phasing/gamification docs and added it to `mkdocs.yml` navigation.

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

**Status:** ⏳ Pending

**Results:** Pending.

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
