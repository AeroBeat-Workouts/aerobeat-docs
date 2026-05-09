# AeroBeat Athlete and Creator API Shape

**Date:** 2026-05-07  
**Status:** In Progress  
**Agent:** Chip 🐱‍💻

---

## Goal

Define the next high-level documentation slice for how `aerobeat-tool-api` should serve expected athlete interactions and the workout creator community in the current PC community + mod.io-shaped AeroBeat release path.

---

## Overview

Yesterday's `aerobeat-vendor-modio` sweep proved the current safe integration boundary for public reads, authenticated self/inventory reads, owned content authoring, guide/comment/dependency flows, collection flows, and real modfile download verification in the sandbox. That gives us enough concrete footing to stop poking the adapter seam for a moment and step back up to product shape.

The next slice should stay high-level first. Before we implement more `aerobeat-tool-api`, we should document what the API layer is actually for from two human-facing perspectives: the **athlete** using the PC community build and the **workout creator** publishing or managing community content. That means clarifying which interactions stay first-party, which ones pass through the current mod.io outer shell, and where `aerobeat-tool-api` should provide a stable AeroBeat-shaped abstraction instead of leaking provider semantics.

The likeliest home for this work is `aerobeat-docs`, because the immediate need is architectural clarity and product-shape alignment rather than code changes. If the docs land cleanly, we can spin the resulting implementation beads in `aerobeat-tool-api` and related repos from a better source of truth.

---

## REFERENCES

| ID | Description | Path |
| --- | --- | --- |
| `REF-01` | Yesterday's AeroBeat handoff and validated vendor-modio boundary | `/home/derrick/.openclaw/workspace/memory/2026-05-06.md` |
| `REF-02` | Current UGC distribution strategy | `docs/architecture/ugc-distribution-strategy.md` |
| `REF-03` | Current hybrid UGC integration architecture | `docs/architecture/ugc-hybrid-integration-architecture.md` |
| `REF-04` | Current concept framing for the product slice | `docs/gdd/concept.md` |
| `REF-05` | Current community-content framing | `docs/gdd/user-content/community-creations.md` |
| `REF-06` | `aerobeat-tool-api` repo identity and dependency boundary | `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-tool-api/README.md` |

---

## Tasks

### Task 1: Research the athlete and creator interaction model we should optimize for

**Bead ID:** `aerobeat-docs-whru`  
**SubAgent:** `primary`  
**Role:** `research`  
**References:** `REF-01` through `REF-06`  
**Prompt:** In `aerobeat-docs`, review the listed references and synthesize the expected athlete-facing and workout-creator-facing interactions for the current AeroBeat slice. Explicitly call out which interactions are first-party AeroBeat truth, which ones currently ride through mod.io, and which areas should remain provider-decoupled in `aerobeat-tool-api`. Claim the bead on start once created, update the active plan with findings, and create follow-on implementation notes if new seams appear.

**Folders Created/Deleted/Modified:**
- `.plans/`
- `docs/architecture/` or `docs/gdd/` depending on the best fit

**Files Created/Deleted/Modified:**
- `.plans/2026-05-07-aerobeat-athlete-and-creator-api-shape.md`
- suggested next docs targets: `docs/architecture/ugc-api-manager-topology.md`, `docs/architecture/backend_api.md`, and likely one new focused architecture page such as `docs/architecture/athlete-and-creator-api-shape.md`

**Status:** ✅ Complete

**Results:** Reviewed `REF-02` through `REF-06`, plus adjacent content-model/package docs and the current `aerobeat-vendor-modio` seam docs. The repo evidence points to a clear high-level recommendation: **`aerobeat-tool-api` should be the AeroBeat-shaped client/service layer for athlete library/discovery/install flows and creator submission/status flows, but it should not become a mod.io-shaped REST dump or a raw provider workflow mirror.** `REF-03` already establishes the intended split: product repos consume only `aerobeat-tool-api`, while `aerobeat-vendor-modio` owns provider request construction, DTO parsing, and transient delivery mechanics. `REF-06` and the current repo shape confirm `aerobeat-tool-api` is still only a thin singleton skeleton (`src/AeroToolManager.gd`) with no service breakdown yet, which supports documenting the service boundary before implementation.

High-level recommended `aerobeat-tool-api` contents:
- **Shared capabilities:** AeroBeat auth/session surface, guest vs verified access policy, AeroBeat-shaped DTOs/resources, content discovery queries, content detail lookup, approved-version/trust-state lookup, library/subscription sync, install/download policy resolution, cache/install state helpers, and provider composition/selection behind internal interfaces. Evidence: `REF-03`, `docs/architecture/backend_api.md`, `docs/architecture/ugc-hybrid-integration-architecture.md`.
- **Athlete-facing capabilities:** browse approved content, search/filter by content type and supported feature (`boxing`, `flow`), fetch trusted content detail, request install/download for an AeroBeat content ID/version, sync library/favorites/subscriptions, expose offline-safe installed content state, and surface quarantine/revocation/install errors in AeroBeat terms rather than provider terms. Evidence: `backend_api.md` athlete endpoints, `docs/gdd/releases/community.md`, `docs/gdd/user-content/community-creations.md`, and `docs/architecture/workout-package-storage-and-discovery.md`.
- **Creator-facing capabilities:** quota/status lookups, submission/upload-session creation, upload completion handoff, validation/bake/status polling, creator-owned listing/library views, and eventual creator-facing publish/update/dependency metadata flows expressed in AeroBeat concepts (`submission`, `content`, `version`, `approval`, `compatibility`) rather than raw mod.io forms. Evidence: `backend_api.md` creator endpoints, `ugc-hybrid-integration-architecture.md` creator-auth + submission flow, `aerobeat-vendor-modio/docs/modio-seam-plan.md`.
- **What it should NOT contain:** raw mod.io DTOs as public contract, direct mod.io IDs as canonical content identity, provider-specific comment/guide/collection/wallet/team transport semantics in the public API surface, gameplay logic/UI flows, or store/platform purchase logic that assumes mod.io is the permanent commerce center. Evidence: `REF-03` anti-patterns, `REF-02` non-negotiable principles, `aerobeat-vendor-modio/docs/modio-unity-vs-vendor-wrapper-gap-2026-05-05.md`, and `docs/modio-monetization-follow-up-2026-05-04.md`.

Recommended boundary by responsibility:
- **Belongs in `aerobeat-tool-api`:** stable service categories roughly matching `auth`, `discovery`, `library`, `downloads/install`, `submissions`, and maybe `creator_inventory` / `creator_status`; AeroBeat-shaped models for content summaries, approved artifact records, install intents, submission status, quota, and trust/revocation state; and orchestration that joins AeroBeat-owned metadata with provider-backed transport.
- **Stays in `aerobeat-vendor-modio` only:** mod.io auth exchange details, endpoint/query/body construction, provider browse/comment/guide/collection/team/rating/report routes, provider media/modfile/multipart upload mechanics, provider wallet/purchase/entitlement transport, provider download URL resolution and expiry handling, and provider DTO/error normalization. The seam doc is explicit that canonical artifact identity, transient `binary_url`, and raw provider mechanics should stay local to the vendor adapter.
- **Future commerce/hosting concerns that should shape the API now:** keep actor identity AeroBeat-owned; keep entitlements/subscriptions/library as AeroBeat concepts that can later map to platform-native purchases on Steam/mobile, provider-backed free/community subscriptions, or future AeroBeat-operated catalog logic; keep submission status separate from provider listing visibility; keep artifact publication/approval/version identity first-party; and avoid any public API naming that assumes mod.io wallet/checkout is the durable commerce path. Derrick clarified that the intended monetization path is **not** first-party AeroBeat payments: purchases should happen through the platform distributors first, then entitlement sync should unlock the matching content on mod.io. mod.io appears to conceptually support store-link/content-sync behavior, and the Unity SDK exposed similar flows, but those REST calls were unofficial/non-public and were intentionally excluded from the current wrapper because this repo only wraps official, non-deprecated APIs. So the docs should frame store-to-mod.io entitlement sync as a desired architecture and research item, not as a currently validated official integration seam. This is strongly supported by `ugc-distribution-strategy.md`, `ugc-hybrid-integration-architecture.md`, and the mod.io monetization follow-up which argues Steam-first should prefer platform-native commerce + entitlement sync, while mobile stores will likely require store-native billing rather than direct mod.io checkout.

Interpretation note on yesterday's `2026-05-06-aerobeat-modio-pages-links.md` slice: coder work being complete while QA/audit remain pending does **not** materially change this architectural recommendation. That slice only added canonical sandbox/live mod.io page URLs to docs; it does not alter the trust boundary or service split. It is relevant only as confirmation that the current provider shell is concretely mod.io right now, not as a change to the intended `tool-api` boundary.

**Addendum — official mod.io monetization docs and portability answer (2026-05-07):** The official docs clearly support a platform-compliant flow where users buy **consumable entitlements** on a platform store (Steam/Xbox/PSN/Meta/Epic, and separate Apple/Google docs exist), the game authenticates that user with mod.io **via the same platform**, and mod.io then **syncs and consumes** that entitlement into the user’s **mod.io wallet** as virtual currency. Strongest source claims: (1) “Entitlement… is always purchased through platform stores … and exchanged with mod.io for virtual currency.” (2) “Once entitlements are sync'd with mod.io … they are converted into virtual currency and the entitlements no longer exist.” (3) during sync, “Game Client instructs mod.io to sync the users platform entitlements to their mod.io account.” (4) purchased Premium UGC then appears in `GET /me/purchased`, which “should be used to determine if a player owns a mod, and to act as a source of truth of if a player still owns the mod.” This combination strongly implies that **after sync and purchase, ownership truth lives on the user’s mod.io account**, not on the original platform entitlement record. The docs also prove platform/account-linking requirements: prerequisite “Platform authentication for the platform where you intend to enable marketplace,” the flow says you must authenticate with mod.io via the purchasing platform, and error `11069` means “The authenticated user does not have an account linked with the associated platform.”

What the docs **do not fully prove** is a product-level guarantee that the *same human* can later sign into AeroBeat on a different platform and automatically recover that purchased workout **without friction**, because the docs do not spell out the account-recovery/linking UX across multiple platforms or whether a single user can seamlessly converge several platform identities into one durable AeroBeat identity. The safest reading is: **cross-platform portability is plausible if the purchase is first converted into a mod.io-account-backed wallet/purchase record, and the athlete later authenticates into the same mod.io identity on the other device/platform**. That likely requires either (a) explicit mod.io account continuity, or (b) an AeroBeat-owned identity layer that consistently links each platform login to the same underlying mod.io user/account. Therefore, `aerobeat-vendor-modio` should keep platform-auth, entitlement-sync, wallet, checkout, and `/me/purchased` transport/details local to the adapter, while `aerobeat-tool-api` should expose first-party concepts like athlete identity, linked accounts, library/entitlement sync status, owned-workout access, and revocation-aware library truth without baking raw mod.io wallet/entitlement semantics into its long-term public contract.

Specific Task 2 doc targets recommended from this research:
1. **Primary target:** add a new focused architecture page, likely `docs/architecture/athlete-and-creator-api-shape.md`, that defines shared vs athlete vs creator capabilities and explicitly states what remains provider-local.
2. **Secondary target:** tighten `docs/architecture/ugc-api-manager-topology.md` so its existing service list explicitly calls out athlete/creator/shared service buckets and future-first-party migration constraints.
3. **Secondary target:** revise `docs/architecture/backend_api.md` so the endpoint examples are clearly framed as AeroBeat-facing shapes and not mistaken for a mod.io pass-through contract.
4. **Optional tertiary target:** expand `docs/architecture/tool.md` if the team wants the generic Tool lane doc to mention that `aerobeat-tool-api` is the client-facing online/UGC service manager for both athlete and creator flows.

Concrete recommendation summary: **treat `aerobeat-tool-api` as the stable AeroBeat client/application service layer for trustable discovery, library, install, and submission workflows; do not let it absorb mod.io-native catalog/community/commerce transport as public contract.** Keep mod.io as the current replaceable shell, not the canonical API vocabulary.

---

### Task 2: Draft the documentation slice that defines the intended `aerobeat-tool-api` shape

**Bead ID:** `Pending`  
**SubAgent:** `primary`  
**Role:** `coder`  
**References:** `REF-01` through `REF-06`  
**Prompt:** In `aerobeat-docs`, claim the bead on start once created. Draft or update the most appropriate architecture/product docs so the intended `aerobeat-tool-api` boundary is clear for athlete flows, creator flows, AeroBeat-owned truth, and the current mod.io outer-shell responsibilities. Keep the language high-level but implementation-steering. Run `source venv/bin/activate && mkdocs build --clean`, update the active plan with exact files/results, commit and push by default, and close the bead.

**Folders Created/Deleted/Modified:**
- `.plans/`
- `docs/architecture/`
- `docs/gdd/` if needed

**Files Created/Deleted/Modified:**
- `.plans/2026-05-07-aerobeat-athlete-and-creator-api-shape.md`
- likely new `docs/architecture/athlete-and-creator-api-shape.md`
- `docs/architecture/ugc-api-manager-topology.md`
- `docs/architecture/backend_api.md`
- optional: `docs/architecture/tool.md`

**Status:** ⏳ Pending

**Results:** Pending.

---

### Task 3: QA and audit the documentation slice before implementation planning

**Bead ID:** `Pending`  
**SubAgent:** `primary`  
**Role:** `qa` then `auditor`  
**References:** `REF-01` through `REF-06`  
**Prompt:** In `aerobeat-docs`, claim the relevant bead on start once created. Independently verify that the resulting docs actually describe realistic athlete and creator flows, preserve the existing AeroBeat-owned trust boundary, and do not accidentally let vendor semantics become canonical API truth. Re-run `source venv/bin/activate && mkdocs build --clean`, update the active plan with findings, and only close the audit bead if the slice is truly ready to drive implementation.

**Folders Created/Deleted/Modified:**
- `.plans/`

**Files Created/Deleted/Modified:**
- `.plans/2026-05-07-aerobeat-athlete-and-creator-api-shape.md`
- docs file(s) only if minimum-fix follow-up is required

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
