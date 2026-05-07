# AeroBeat Free-to-Play Account and Premium UGC Strategy

**Date:** 2026-05-07  
**Status:** In Progress  
**Agent:** Chip 🐱‍💻

---

## Goal

Lock the updated AeroBeat strategy around free-to-play distribution, free + premium workouts, AeroBeat-owned account architecture, and the documentation/tool-api changes required before implementation begins.

---

## Overview

AeroBeat's strategy has now materially shifted from a narrow mod.io integration discussion into a broader platform-shaping decision. The team is aligning around a **free-to-play app** with both **free workouts** and **premium workouts**, using platform-compliant purchase flows and mod.io as the current UGC/community/distribution layer for premium workout ownership and delivery. At the same time, AeroBeat's long-term product stickiness — workout points, goals, streaks, social, multiplayer, cosmetics, currencies, and progression — clearly belongs to an **AeroBeat-owned account layer**, even if not all of those features ship in v1.

That means the immediate work is not to jump into coding `aerobeat-tool-api`, but to re-audit the docs and strategy so the system does not accidentally calcify around a mod.io-only identity or a too-thin UGC model. We need to update the architecture so `aerobeat-tool-api` can become the AeroBeat-facing identity/access/entitlement layer, while `aerobeat-vendor-modio` remains the provider adapter and mod.io-specific transport seam.

This plan therefore has four linked outcomes: (1) update docs and `aerobeat-tool-api` repo framing for the new strategy, (2) pressure-test the broader AeroBeat business/platform/open-source/anti-abuse strategy under the free + premium UGC model, (3) define which account-driven retention systems are v1 versus later, and (4) only then begin implementation planning for `aerobeat-tool-api` with a trustworthy source of truth.

---

## REFERENCES

| ID | Description | Path |
| --- | --- | --- |
| `REF-01` | Current API-shape research plan and findings | `.plans/2026-05-07-aerobeat-athlete-and-creator-api-shape.md` |
| `REF-02` | UGC distribution strategy | `docs/architecture/ugc-distribution-strategy.md` |
| `REF-03` | Hybrid UGC integration architecture | `docs/architecture/ugc-hybrid-integration-architecture.md` |
| `REF-04` | UGC API manager topology | `docs/architecture/ugc-api-manager-topology.md` |
| `REF-05` | Backend API framing | `docs/architecture/backend_api.md` |
| `REF-06` | AeroBeat concept / release framing | `docs/gdd/concept.md` |
| `REF-07` | Community release framing | `docs/gdd/releases/community.md` |
| `REF-08` | Community creations framing | `docs/gdd/user-content/community-creations.md` |
| `REF-09` | mod.io monetization docs discussed this session | `https://docs.mod.io/monetization/how-it-works`, `https://docs.mod.io/monetization/modio-as-purchase-server` |
| `REF-10` | `aerobeat-tool-api` current repo framing | `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-tool-api/README.md` |
| `REF-11` | `aerobeat-vendor-modio` seam findings from recent validation | `/home/derrick/.openclaw/workspace/memory/2026-05-06.md` |

---

## Tasks

### Task 1: Audit and update docs + tool-api framing for the locked free-to-play / free+premium strategy

**Bead ID:** `aerobeat-docs-vpqh`  
**SubAgent:** `primary`  
**Role:** `coder`  
**References:** `REF-01` through `REF-11`  
**Prompt:** In `aerobeat-docs` and `aerobeat-tool-api`, claim the bead on start once created. Audit the current docs and repo framing against the now-locked strategy: free-to-play app, free + premium workouts, mod.io as current premium UGC/community layer, and AeroBeat-owned account architecture as a first-class design concern. Update or add the docs necessary to make the intended boundaries explicit, and update `aerobeat-tool-api` repo framing/README if needed so it no longer reads like a generic API wrapper. Keep the work architecture-focused and implementation-steering. Run the relevant docs validation/build steps, update this plan with exact files/results, commit and push by default, and close the bead.

**Folders Created/Deleted/Modified:**
- `.plans/`
- `docs/architecture/`
- `docs/gdd/`
- `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-tool-api/`

**Files Created/Deleted/Modified:**
- `.plans/2026-05-07-aerobeat-free-to-play-account-and-ugc-strategy.md`
- `docs/architecture/account-identity-and-entitlements.md`
- `docs/architecture/ugc-api-manager-topology.md`
- `docs/architecture/backend_api.md`
- `docs/gdd/concept.md`
- `docs/gdd/releases/community.md`
- `docs/gdd/user-content/community-creations.md`
- `mkdocs.yml`
- `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-tool-api/README.md`
- `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-tool-api/plugin.cfg`
- `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-tool-api/src/AeroToolManager.gd`

**Status:** ✅ Complete

**Results:** Audited the strategy docs plus `aerobeat-tool-api` framing and tightened the minimum architecture set needed to lock the new direction. The key change is that the docs now explicitly describe **AeroBeat as free-to-play with both free and premium workouts**, while keeping **platform-compliant store purchases** as the source of premium commerce and treating **mod.io as the current premium UGC/community/distribution layer rather than the canonical product identity**. Added `docs/architecture/account-identity-and-entitlements.md` as the new anchor doc for AeroBeat-owned athlete identity, linked-account mappings, entitlement vocabulary, and the rule that `aerobeat-tool-api` should be the **AeroBeat-facing identity/access/entitlement layer** with mod.io account-link/purchase-sync mechanics conceptually contained in the vendor seam.

Updated `ugc-api-manager-topology.md` to reframe `aerobeat-tool-api` as the Godot-imported identity/access/entitlement manager instead of a generic UGC wrapper, and updated `backend_api.md` so the example surface is clearly AeroBeat-shaped for catalog, library, entitlement sync, install-request, and creator submission flows rather than reading like a provider pass-through. Updated the GDD/community docs (`concept.md`, `releases/community.md`, `user-content/community-creations.md`) so the product framing, community release wording, and community-workout model all consistently reflect free-to-play + free/premium workouts + AeroBeat-owned account architecture.

In `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-tool-api`, rewrote `README.md` so the repo is explicitly framed as the client-facing **identity/access/entitlement** tool layer, then aligned `plugin.cfg` and the `AeroToolManager.gd` header comments to that same responsibility. Validation: `source venv/bin/activate && mkdocs build --clean` completed successfully in `aerobeat-docs`. For `aerobeat-tool-api`, no reliable repo-local automated check was runnable from the current checkout because the hidden `.testbed/` depends on uninstalled addon dependencies (`aerobeat-core`, `gut`), so Task 1 used README/package framing consistency inspection instead of claiming a passing runtime test. Explicit unresolved follow-ups left visible for later tasks: account rollout phasing, cross-platform linked-account recovery UX, entitlement reconciliation policy, guest conversion rules, and premium catalog/moderation policy.

---

### Task 2: Pressure-test the broader AeroBeat strategy under the new free + premium UGC model

**Bead ID:** `aerobeat-docs-lehj`  
**SubAgent:** `primary`  
**Role:** `research`  
**References:** `REF-02` through `REF-11`  
**Prompt:** In `aerobeat-docs`, claim the bead on start once created. Review the broader AeroBeat strategy under the new lens of free-to-play plus free/premium workouts. Pressure-test whether the strategy still works with the open-source posture, current/future platforms (PC, mobile, arcade, console), premium-content abuse risks, moderation/review pipeline expectations, premium workout pricing guidance, and content quality/accessibility requirements such as difficulty coverage. Produce concrete architecture/product recommendations and document them in the most appropriate strategy docs plus this plan. Create follow-on notes for unresolved policy questions rather than hand-waving them.

**Folders Created/Deleted/Modified:**
- `.plans/`
- `docs/architecture/`
- `docs/gdd/`

**Files Created/Deleted/Modified:**
- `.plans/2026-05-07-aerobeat-free-to-play-account-and-ugc-strategy.md`
- `docs/architecture/premium-workout-governance.md`
- `docs/gdd/releases/community.md`
- `docs/gdd/user-content/community-creations.md`
- `mkdocs.yml`

**Status:** ✅ Complete

**Results:** Added `docs/architecture/premium-workout-governance.md` to pressure-test whether the free-to-play + free/premium workout strategy still holds under open-source, mod.io-backed premium UGC, and AeroBeat-owned account/entitlement architecture. The strongest conclusion is that the strategy is still viable, but only if AeroBeat treats premium workouts as a **review-gated governed product lane** rather than "community mods, but paid." The new doc explicitly separates what is safe to lock now, what is still risky/policy-sensitive, and what should be v1-safe versus later refinement.

Safe-to-lock conclusions recorded in the doc: AeroBeat can remain open-source while selling premium workouts; premium content protection must be framed as licensing/trust/moderation rather than magical DRM; premium workouts should launch only on a **creator-enrolled, pre-reviewed premium lane**; AeroBeat must own canonical approval/entitlement/trust state even while mod.io remains the current outer community/distribution shell; and **PC is the sane launch lane** for premium UGC while mobile/console/arcade should be treated as stricter future policy variants.

Concrete product/policy recommendations recorded in the doc: require premium creator enrollment; require first-publication and material-update review for premium workouts; use **pricing bands** rather than arbitrary creator-set prices in v1; require minimum metadata honesty, licensing attestation, and difficulty/accessibility coverage for sellable premium content; and explicitly assume premium cloning/reposting attempts will happen, so provenance tracking, duplicate review, rapid delisting, and creator sanctions matter more than file secrecy. The doc also recommends limiting v1 premium sale classes to **whole workouts or tightly scoped workout packs**, not fragmented micro-items like premium environments or coaching fragments.

Updated `docs/gdd/releases/community.md` and `docs/gdd/user-content/community-creations.md` to point at the new premium governance stance so the community release framing no longer implies that paid uploads can be a loosely moderated extension of free UGC. Added the new architecture doc to `mkdocs.yml`. Validation: `source venv/bin/activate && mkdocs build --clean` completed successfully; the only output beyond the normal build was the existing upstream plugin warning about future MkDocs 2 / ProperDocs risk plus the usual note about some docs pages not being included in nav.

---

### Task 3: Define v1 vs future account-required features and launch-priority retention systems

**Bead ID:** `aerobeat-docs-dhw6`  
**SubAgent:** `primary`  
**Role:** `research`  
**References:** `REF-01`, `REF-04`, `REF-05`, `REF-06`, `REF-07`, `REF-08`  
**Prompt:** In `aerobeat-docs`, claim the bead on start once created. Define which account-driven features belong in v1 versus later releases, including workout points, weekly goals/schedule, streaks, social features, leaderboards, multiplayer, cosmetics, premium currency, and other stickiness systems discussed this session. Recommend a priority order and explicitly call out which account capabilities must be fully designed now versus which can be deferred without compromising launch success. Update the active plan and the appropriate docs with clear decision language.

**Folders Created/Deleted/Modified:**
- `.plans/`
- `docs/gdd/`
- `docs/architecture/`

**Files Created/Deleted/Modified:**
- `.plans/2026-05-07-aerobeat-free-to-play-account-and-ugc-strategy.md`
- `docs/architecture/account-retention-phasing.md`
- `docs/architecture/account-identity-and-entitlements.md`
- `docs/gdd/gamification/overview.md`
- `docs/gdd/economy/currency.md`
- `docs/gdd/roadmap/future-roadmap.md`
- `mkdocs.yml`

**Status:** ✅ Complete

**Results:** Added `docs/architecture/account-retention-phasing.md` as the decision anchor for what account-driven systems belong in launch versus later. The strongest recommendation is a disciplined v1 cut: **AeroBeat-owned account identity + guest conversion + linked-account recovery, entitlement/library sync, basic profile/preferences/history, Workout Points, and simple weekly goals/streaks**. The doc explicitly argues that this is enough to make AeroBeat compelling at launch because it solves the two product questions that matter most: "why trust this as my long-term workout library?" and "why come back next week?"

The same doc also draws a hard line against overbuilding v1. It recommends deferring **leaderboards, friends/following, crews, real-time multiplayer, premium currency, battle passes, seasonal progression, and rotating shop layers**. Those are not called bad ideas; they are called the wrong launch priorities. The recommended post-v1 order is: (1) scoped leaderboards/async competition, (2) lightweight social accountability, (3) expanded WP sinks and official cosmetics, (4) crews/group features, (5) multiplayer/ghost competition, and only then (6) premium-currency/live-ops systems.

The doc also separates design depth clearly. Items that must be fully designed now: canonical athlete identity, guest conversion, linked-account recovery, entitlement and library truth, workout-completion event model, WP ledger/grant rules, weekly goal + streak semantics, and minimum profile/history scope. Items that should be lightly designed now then heavily deferred: leaderboard schemas, future social graph/privacy seams, and official cosmetic inventory modeling. Items that can safely wait: premium-currency wallets, battle passes, seasonal tracks, rotating premium shops, gifting, and real-time multiplayer implementation details.

To align the rest of the docs with that decision, updated `docs/gdd/gamification/overview.md` so the v1 retention loop is now explicitly WP + weekly goals + streaks rather than an open-ended live-service bundle; updated `docs/gdd/economy/currency.md` so WP reads as the single launch progression currency instead of implying a broad v1 store economy; updated `docs/gdd/roadmap/future-roadmap.md` so the post-launch order matches the new retention strategy; linked the new phasing doc from `docs/architecture/account-identity-and-entitlements.md`; and added the new page to `mkdocs.yml` navigation.

---

### Task 4: QA and audit the revised strategy/docs before tool-api implementation planning

**Bead ID:** `aerobeat-docs-ez3q`  
**SubAgent:** `primary`  
**Role:** `qa` then `auditor`  
**References:** `REF-01` through `REF-11`  
**Prompt:** In `aerobeat-docs` (and `aerobeat-tool-api` if touched), claim the relevant bead on start once created. Independently verify that the revised docs and repo framing are coherent, preserve the intended AeroBeat-vs-mod.io responsibility split, correctly reflect the free-to-play + free/premium strategy, and leave us in a good place to begin `aerobeat-tool-api` implementation planning. Re-run validation/build steps, update the plan with findings, and only close the audit bead if the strategy is genuinely ready.

**Folders Created/Deleted/Modified:**
- `.plans/`

**Files Created/Deleted/Modified:**
- `.plans/2026-05-07-aerobeat-free-to-play-account-and-ugc-strategy.md`
- docs/repo files only if minimum necessary follow-up is required

**Status:** ⏳ Pending

**Results:** Pending.

---

## Final Results

**Status:** ⏳ Pending

**What We Built:** Pending.

**Reference Check:** Task 1 and Task 2 conclusions remain intact. The Task 3 additions explicitly preserve the AeroBeat-vs-mod.io split from `REF-04`/`REF-05`, keep the free-to-play + free/premium framing from `REF-06`/`REF-07`/`REF-08`, and convert the earlier unresolved question in Task 1 about account rollout phasing into a concrete v1-vs-later decision.

**Commits:**
- None yet.

**Lessons Learned:** Pending.

---

*Drafted on 2026-05-07*
