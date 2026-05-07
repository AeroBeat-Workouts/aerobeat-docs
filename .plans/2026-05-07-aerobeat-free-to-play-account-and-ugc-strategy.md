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
- strategy doc(s) TBD from research

**Status:** ⏳ Pending

**Results:** Pending.

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
- feature-priority/account-strategy docs TBD

**Status:** ⏳ Pending

**Results:** Pending.

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

**Reference Check:** Pending.

**Commits:**
- None yet.

**Lessons Learned:** Pending.

---

*Drafted on 2026-05-07*
