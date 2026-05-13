# AeroBeat mod.io DMCA / Safe-Harbor Documentation Audit

**Date:** 2026-05-13  
**Status:** In Progress  
**Agent:** Chip 🐱‍💻

---

## Goal

Summarize the current post-meeting understanding with mod.io around DMCA / safe-harbor posture for AeroBeat, audit the docs for drift, and update the docs plus any adjacent AeroBeat repos so they reflect the newest understanding and clearly mark remaining open questions.

---

## Overview

Derrick had a direct conversation with the mod.io team and then sent a follow-up email that captures the current working understanding: AeroBeat wants mod.io to be the community/distribution shell for workout packages while keeping AeroBeat positioned as a technology platform rather than as the direct editorial police for all workout content. The legal pressure point is whether the current creator-rights attestation, review posture, moderation routing, public-marketing restraint, and paid-workout workflow are enough to keep AeroBeat aligned with DMCA safe-harbor expectations.

The important shift is not that the whole product policy is changing today; it is that the docs now need to distinguish more carefully between what we believe is true, what mod.io has already effectively confirmed in product/ops terms, and what mod.io is still escalating to legal. We should avoid overstating certainty on DMCA/legal posture until mod.io comes back with a firmer answer, while still documenting the current operational direction and the concrete questions still open.

The documentation owner for this work is `aerobeat-docs`, but the audit likely needs to inspect adjacent polyrepos where we have product-boundary or provider-boundary wording that could accidentally imply stronger legal certainty, stronger AeroBeat moderation ownership, or stronger paid-mod assumptions than we now want to claim. Any repo changes should stay tightly scoped to wording/contract truthfulness unless the audit finds a real structural mismatch.

---

## REFERENCES

| ID | Description | Path |
| --- | --- | --- |
| `REF-01` | Derrick's current mod.io follow-up email / meeting summary | `User-provided conversation notes in this session (2026-05-13)` |
| `REF-02` | Current compact v1 UGC submission/review source of truth | `docs/architecture/v1-ugc-submission-and-review-policy.md` |
| `REF-03` | Current moderation / DMCA / takedown wording | `docs/gdd/user-content/policing-content.md` |
| `REF-04` | Current premium governance / review policy framing | `docs/architecture/premium-workout-governance.md` |
| `REF-05` | Current mod.io distribution-shell architecture framing | `docs/architecture/ugc-distribution-strategy.md` |
| `REF-06` | Current hybrid integration architecture | `docs/architecture/ugc-hybrid-integration-architecture.md` |
| `REF-07` | Current account / entitlement boundary with mod.io | `docs/architecture/account-identity-and-entitlements.md` |
| `REF-08` | mod.io vendor seam planning note incl. open questions for mod.io | `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-vendor-modio/docs/modio-unity-vs-vendor-wrapper-gap-2026-05-05.md` |
| `REF-09` | mod.io vendor REST research note incl. DMCA-related error references | `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-vendor-modio/docs/modio-rest-api-research-2026-05-02.md` |

---

## Tasks

### Task 1: Summarize the current mod.io / AeroBeat DMCA posture from the meeting notes

**Bead ID:** `aerobeat-docs-6l10`  
**SubAgent:** `primary`  
**Role:** `research`  
**References:** `REF-01`, `REF-02`, `REF-03`, `REF-04`, `REF-05`, `REF-07`  
**Prompt:** In `aerobeat-docs`, claim the bead on start. Read the user-provided mod.io meeting/email notes together with the current AeroBeat v1 UGC/moderation/account docs. Produce a precise summary of: what AeroBeat currently believes, what appears operationally true already, what is only a tentative legal assumption pending mod.io legal review, and what explicit open questions still exist. Update this plan with exact findings and recommended wording posture.

**Folders Created/Deleted/Modified:**
- `.plans/`
- `docs/architecture/`
- `docs/gdd/`

**Files Created/Deleted/Modified:**
- `.plans/2026-05-13-aerobeat-modio-dmca-doc-audit.md`
- docs TBD

**Status:** ✅ Complete

**Results:**

**Task 1 summary — current mod.io / AeroBeat DMCA posture**

### 1. What appears operationally true now

Grounded in `REF-01`, `REF-02`, `REF-03`, `REF-04`, `REF-05`, and `REF-07`, the docs and meeting notes currently line up on the following operational posture:

- AeroBeat is treating **mod.io as the community/distribution shell** for public UGC, including reporting/moderation intake, while AeroBeat keeps its own product vocabulary and trust-boundary framing.
- Creators are expected to **have mod.io accounts** in order to participate in the public creator/distribution flow.
- Creators must **self-attest that they have the rights necessary** for the submitted workout content and assets.
- The current v1 docs consistently say AeroBeat does **not** require proof-of-rights documentation in the normal submission path.
- The current moderation/review posture is **review-gated public publishing via mod.io Full Curation**, with AeroBeat using human review plus policy language, but **not** building a second first-party public release cockpit.
- AeroBeat is **not presently describing itself as directly policing every workout for copyright ownership on the front end**; instead it relies on package review, policy checks, creator attestation, and mod.io reporting/moderation flows.
- DMCA / copyright / takedown routing is currently documented as going through **mod.io's reporting and moderation system**.
- AeroBeat wants to preserve the framing that it is a **technology platform for rhythm workouts**, not a curator that is actively endorsing or ownership-verifying each specific creator workout by default.
- The docs already trend toward a lower-scope, operationally realistic position: trust/safety review, truthfulness checks, and rights attestation matter, but the system is **not positioned as a proof-of-rights verification workflow**.

### 2. What is still only a working assumption pending mod.io legal confirmation

The meeting/email notes imply several things that should be treated as **working assumptions**, not settled facts yet:

- That the current package of controls — mod.io account requirement, rights self-attestation, mod.io-hosted reporting/takedown flows, limited AeroBeat review, and restrained marketing posture — is **sufficient for the DMCA / safe-harbor posture AeroBeat wants**.
- That AeroBeat can safely continue framing itself as a **technology platform rather than a direct editorial owner/policing authority** for creator workouts without creating a legal contradiction in practice.
- That AeroBeat can support **paid / premium creator workouts** through the planned mod.io-centered workflow without changing the legal risk posture in a way that requires materially different review or rights verification.
- That routing takedowns and copyright complaints through mod.io is enough **without AeroBeat separately taking on stronger ownership-verification obligations** for every published workout.
- That the current docs' language around review, premium publication, and takedown handling does **not overstate what mod.io has actually blessed legally**.

Per `REF-01`, mod.io is still **escalating the DMCA / paid-mod posture to legal**. That means AeroBeat should not yet write as though mod.io has already issued a definitive legal confirmation on the full paid-UGC / safe-harbor model.

### 3. What wording posture the docs should adopt

Until mod.io legal comes back, the docs should use a **careful operational posture**:

- State what AeroBeat **currently does operationally**.
- Avoid language that implies AeroBeat or mod.io has already reached a **final legal conclusion** on the whole paid-workout / DMCA posture.
- Prefer wording like:
  - "current v1 operational posture"
  - "current working assumption"
  - "pending mod.io legal confirmation"
  - "AeroBeat intends / currently plans"
  - "copyright and takedown flows currently route through mod.io"
- Avoid stronger claims like:
  - "this guarantees DMCA safe harbor"
  - "mod.io has confirmed this is legally approved"
  - "AeroBeat verifies ownership of creator workouts before publication" unless that is actually being added operationally
- The docs should preserve the boundary that AeroBeat is **not publicly acknowledging, featuring, or endorsing specific creator workouts as owned/authorized works unless ownership has actually been verified**.
- Where premium workflows are discussed, docs should describe them as the **current intended governance/distribution model**, while explicitly noting that the exact DMCA / legal posture for paid creator workouts is still awaiting mod.io legal feedback.

### 4. Explicit open questions still outstanding

These are the main unresolved questions surfaced by the notes + docs comparison:

1. Has mod.io legal actually confirmed that the current AeroBeat posture is acceptable for **DMCA / safe-harbor purposes**, especially once workouts can be premium/paid?
2. Does the presence of **paid creator workouts** require stronger moderation, rights verification, proof-of-rights collection, or different escalation handling than the current self-attestation model?
3. Is AeroBeat's desired posture of being a **technology/distribution platform rather than a direct content-policing editor** fully compatible with how the public product, store pages, featured content, and creator promotion are handled?
4. What specific kinds of **AeroBeat promotion, featuring, or acknowledgement** of creator workouts would increase legal/editorial risk unless ownership is verified first?
5. If mod.io handles primary takedown/report flows, what is AeroBeat's **secondary responsibility** when it independently becomes aware of a likely infringing workout?
6. Are the current docs too absolute when they say DMCA / copyright / takedown handling "routes through mod.io," or should they instead say this is the **current operational routing**, subject to provider/legal confirmation and possible AeroBeat-side escalation duties?
7. Does the premium-governance wording currently imply more certainty about the paid-mod path than AeroBeat has actually earned yet?

**Bottom line:** the current docs are broadly consistent with the meeting direction operationally, but they are still a little too close to sounding settled. The safer Task 1 conclusion is: AeroBeat currently appears to require mod.io participation + creator rights attestation + mod.io-centered takedown/moderation routing, while aiming to remain a technology platform and avoid affirmative endorsement of specific creator workouts; however, whether that full posture is legally sufficient — especially for premium workouts — remains pending mod.io legal confirmation.

---

### Task 2: Audit `aerobeat-docs` for wording that now looks too certain, incomplete, or outdated

**Bead ID:** `aerobeat-docs-s918`  
**SubAgent:** `primary`  
**Role:** `research`  
**References:** `REF-01` through `REF-07`  
**Prompt:** In `aerobeat-docs`, claim the bead on start. Audit the docs for mod.io / DMCA / takedown / paid-workout / creator-rights wording. Identify exact files/sections that should change based on the current meeting understanding. Separate findings into: (a) safe to update now, (b) should be rewritten to express uncertainty or pending legal confirmation, and (c) should remain unchanged. Update the plan with a concrete file-by-file audit list.

**Folders Created/Deleted/Modified:**
- `.plans/`
- `docs/architecture/`
- `docs/gdd/`
- `docs/guides/`

**Files Created/Deleted/Modified:**
- `.plans/2026-05-13-aerobeat-modio-dmca-doc-audit.md`
- docs TBD

**Status:** ✅ Complete

**Results:**

**Task 2 audit — file-by-file wording drift review**

### A. Safe to update now

These files can be tightened now without waiting for mod.io legal, because the needed changes are mainly about making the current operational posture and open questions more explicit rather than changing product direction.

- `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-docs/docs/architecture/v1-ugc-submission-and-review-policy.md`
  - Reason: strongest compact source-of-truth for the v1 policy; currently says takedown routing "should use mod.io's reporting and moderation system" without explicitly marking that as the **current operational route** pending legal/provider confirmation and possible AeroBeat-side escalation duties.
- `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-docs/docs/gdd/user-content/policing-content.md`
  - Reason: same drift as the compact policy doc; direct DMCA/takedown wording is operationally aligned but reads more settled than Task 1 recommends.
- `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-docs/docs/architecture/premium-workout-governance.md`
  - Reason: premium-workout lane is exactly where the pending legal uncertainty matters most; doc is broadly right but should explicitly distinguish locked operational governance from unresolved legal sufficiency for paid creator workouts.
- `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-docs/docs/architecture/account-identity-and-entitlements.md`
  - Reason: the sections saying mod.io may act as the current purchase/ownership server after official sync are directionally useful, but should be softened to "current intended/working provider role" until legal/provider confirmation is firmer.
- `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-docs/docs/architecture/backend_api.md`
  - Reason: API wording around provider-backed ownership sync / purchased-content server is implementation-steering, but it should more clearly read as an AeroBeat-facing contract built around the current intended provider workflow rather than a fully validated legal/commercial guarantee.
- `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-docs/docs/gdd/releases/community.md`
  - Reason: premium-workout section is short and easy to harden; useful place to add one sentence that the premium/community/mod.io path is the current intended v1 model, with exact legal/provider posture still pending confirmation.

### B. Should be rewritten to express uncertainty or pending legal confirmation

These files are not wrong, but any edits here should deliberately introduce explicit uncertainty language instead of just making small wording tweaks.

- `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-docs/docs/architecture/premium-workout-governance.md`
  - Reason: this is the highest-risk certainty hotspot because it treats premium UGC as a workable v1 governed lane but does not yet foreground that the **DMCA / safe-harbor posture for paid creator workouts is still awaiting mod.io legal feedback**.
- `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-docs/docs/architecture/account-identity-and-entitlements.md`
  - Reason: statements about provider-backed purchase/ownership sync can be mistaken for settled supportability instead of the current intended seam; needs explicit "where officially supported / pending provider-legal confirmation" framing.
- `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-docs/docs/architecture/backend_api.md`
  - Reason: sequence diagrams and endpoint descriptions assume ownership reconciliation through the provider seam; should explicitly read as the current intended architecture, not as proven final vendor/legal behavior.
- `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-docs/docs/architecture/v1-ugc-submission-and-review-policy.md`
  - Reason: the compact canonical doc should carry the clearest caution note because downstream docs inherit tone from it; rights/takedown wording should explicitly separate locked ops from pending legal certainty.
- `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-docs/docs/gdd/user-content/policing-content.md`
  - Reason: direct moderation/DMCA wording currently sounds operationally final; should say that v1 currently routes reports/takedowns through mod.io while AeroBeat may still need additional escalation duties depending on final provider/legal guidance.

### C. Should remain unchanged

These files already read as architectural/product-boundary docs, stay appropriately cautious, or are too indirect to justify a Task 3 wording pass.

- `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-docs/docs/architecture/ugc-distribution-strategy.md`
  - Reason: already distinguishes distribution shell vs first-party trust boundary and avoids claiming legal sufficiency or app-store/legal guarantees.
- `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-docs/docs/architecture/ugc-hybrid-integration-architecture.md`
  - Reason: already contains explicit non-claims, including that the architecture does not automatically guarantee legal sufficiency for copyright/moderation cases.
- `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-docs/docs/architecture/ugc-distribution-executive-summary.md`
  - Reason: high-level recommendation doc stays at the trust-boundary/distribution-shell layer and does not overclaim DMCA or paid-workout legality.
- `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-docs/docs/gdd/user-content/community-creations.md`
  - Reason: describes free vs premium structure and mod.io boundary without making new DMCA/legal certainty claims.
- `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-docs/docs/architecture/modio-tag-mapping.md`
  - Reason: taxonomy/mapping doc; mentions compliance flags only as metadata to keep out of public tags and does not need legal-tone adjustment now.
- `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-docs/docs/architecture/ugc-api-manager-topology.md`
  - Reason: repo-boundary / integration-shape doc, not a DMCA posture doc.
- `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-docs/docs/architecture/ugc_modding.md`
  - Reason: mentions the authorized upload flow but does not materially assert legal conclusions about moderation or safe-harbor.
- `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-docs/docs/architecture/ui-ux.md`
  - Reason: streamer-mode / copyright-strike note is user-risk framing, not a statement about AeroBeat/mod.io legal posture.

### Smallest high-value docs update set for Task 3

Recommended minimum set:

1. `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-docs/docs/architecture/v1-ugc-submission-and-review-policy.md`
2. `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-docs/docs/gdd/user-content/policing-content.md`
3. `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-docs/docs/architecture/premium-workout-governance.md`
4. `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-docs/docs/architecture/account-identity-and-entitlements.md`

Why this is the minimum high-value set:
- it updates the compact canonical v1 policy source,
- the matching moderation/takedown GDD page,
- the premium-workout doc where paid-UGC legal uncertainty matters most,
- and the identity/ownership doc that otherwise risks sounding too settled about provider-backed premium ownership sync.

Optional fifth file only if Derrick wants the API layer to carry the same caution immediately:
- `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-docs/docs/architecture/backend_api.md`

**Net assessment:** the docs are not directionally broken. The drift is mostly tonal: several policy/premium/ownership docs need to stop sounding like the DMCA / paid-workout posture is already legally settled and instead state that this is the **current v1 operational model pending firmer mod.io legal confirmation**.

---

### Task 3: Apply the docs updates in `aerobeat-docs`

**Bead ID:** `aerobeat-docs-6bd5`  
**SubAgent:** `primary`  
**Role:** `coder`  
**References:** `REF-01` through `REF-07`  
**Prompt:** In `aerobeat-docs`, claim the bead on start. Implement the approved documentation updates from the audit. Keep the wording legally humble where certainty is not yet earned: distinguish current operational policy, current working assumptions, and pending mod.io legal confirmation. Add an explicit open-questions or pending-confirmation note where useful instead of implying settled law. Run repo-local docs validation, commit/push by default, and update the plan with exact file changes and results.

**Folders Created/Deleted/Modified:**
- `.plans/`
- `docs/architecture/`
- `docs/gdd/`

**Files Created/Deleted/Modified:**
- `.plans/2026-05-13-aerobeat-modio-dmca-doc-audit.md`
- `docs/architecture/v1-ugc-submission-and-review-policy.md`
- `docs/gdd/user-content/policing-content.md`
- `docs/architecture/premium-workout-governance.md`
- `docs/architecture/account-identity-and-entitlements.md`

**Status:** ✅ Complete

**Results:**

- Updated `docs/architecture/v1-ugc-submission-and-review-policy.md` to change the DMCA/takedown language from a settled-sounding routing statement to the **current operational route** through mod.io, plus a short note that this is not final safe-harbor certainty and may still require additional provider-aligned or AeroBeat-side escalation steps.
- Updated `docs/gdd/user-content/policing-content.md` to mirror that same moderation/takedown posture: creator self-attestation remains intact, mod.io remains the current operational intake path, and the doc now explicitly says the legal posture is not yet finally settled.
- Updated `docs/architecture/premium-workout-governance.md` in the highest-risk certainty areas by:
  - softening the opening strategic conclusion from a settled statement to the **current v1 direction**,
  - reframing the DMCA/takedown sentence as the **current operational route** through mod.io,
  - adding a new section that explicitly says the **paid-workout DMCA / safe-harbor posture is still pending firmer provider/legal confirmation**, and
  - softening the final recommendation so it stays product-directional without overstating legal certainty.
- Updated `docs/architecture/account-identity-and-entitlements.md` to distinguish the current intended provider workflow from settled guarantees by:
  - changing mod.io from the current premium community layer to the **current intended** layer,
  - reframing the purchase/ownership-sync rule as the **current intended strategy** only where officially supported and provider/legal posture remains acceptable,
  - adding a short note that provider-backed ownership sync is an intended architecture seam rather than a final paid-workout legal conclusion, and
  - adding an explicit unresolved question for the pending paid-workout provider/legal posture.
- Kept the v1 product direction intact: no new rights-proof requirement was introduced, no first-party moderation cockpit was invented, and the docs still describe the mod.io-centered review/distribution workflow as the launch operating model.
- Validation: ran `source venv/bin/activate && python scripts/create_placeholders.py && mkdocs build --strict` successfully. MkDocs reported existing nav omissions already present in the repo, but the strict build completed with exit code `0`.
- Git: committed and pushed to `main` with commit message `docs: soften mod.io DMCA posture wording`.

---

### Task 4: Audit adjacent AeroBeat polyrepos for follow-on wording drift

**Bead ID:** `aerobeat-docs-gatb`  
**SubAgent:** `primary`  
**Role:** `research`  
**References:** `REF-01`, `REF-05`, `REF-06`, `REF-08`, `REF-09`  
**Prompt:** In the AeroBeat workspace, claim the bead on start. Audit adjacent repos likely to carry mod.io/product-boundary wording — especially `aerobeat-vendor-modio`, `aerobeat-tool-api`, and any other touched repo the docs reference. Identify only the follow-on wording or contract drift created by the new DMCA/legal-understanding posture. Do not broaden into unrelated repo cleanup. Update the plan with a concise repo-by-repo recommendation list and whether each item needs immediate docs work, later work, or no change.

**Folders Created/Deleted/Modified:**
- `.plans/`
- adjacent repos only if approved for follow-on changes

**Files Created/Deleted/Modified:**
- `.plans/2026-05-13-aerobeat-modio-dmca-doc-audit.md`
- follow-on files TBD

**Status:** ⏳ Pending

**Results:** Pending.

---

### Task 5: QA and audit the final docs / follow-on recommendations

**Bead ID:** `aerobeat-docs-smwv`  
**SubAgent:** `primary`  
**Role:** `qa` / `auditor`  
**References:** `REF-01` through `REF-09`  
**Prompt:** In `aerobeat-docs`, claim the bead on start. Independently verify that the updated docs and any follow-on repo recommendations accurately reflect the current mod.io meeting understanding without overstating legal certainty. Re-run relevant validation, truth-check the revised language against the current references, and close only if the outcome is clear, grounded, and implementation-safe.

**Folders Created/Deleted/Modified:**
- `.plans/`
- touched repos only if minimum necessary fixes are required

**Files Created/Deleted/Modified:**
- `.plans/2026-05-13-aerobeat-modio-dmca-doc-audit.md`
- touched files only if QA/audit finds minimum necessary fixes

**Status:** ⏳ Pending

**Results:** Pending.

---

## Final Results

**Status:** ⏳ Pending

**What We Built:** Pending.

**Reference Check:** Pending.

**Commits:**
- Pending

**Lessons Learned:** Pending.

---

*Drafted on 2026-05-13*
