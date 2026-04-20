# AeroBeat Docs Decision-Language and Terminology Audit

**Date:** 2026-04-20  
**Status:** In Progress  
**Agent:** Chip 🐱‍💻

---

## Goal

Audit the full `aerobeat-docs` documentation set for inconsistent terminology and soft/non-affirmative decision language, then update the docs so the public site speaks with one coherent architectural voice.

---

## Overview

The immediate trigger for this plan is a real docs-quality issue Derrick spotted in the new content-model work: public docs were still using discussion-phase language such as `should`, `recommended`, and similar advisory phrasing where AeroBeat had already made a decision. That same issue likely exists elsewhere in the docs set, and terminology drift is the second half of the problem: even if each page is individually readable, conflicting terms across the site make the architecture feel unstable.

This plan treats the repo-wide doc set as a consistency system, not just a bag of pages. The first pass should build a terminology and tone inventory across the docs tree, especially architecture, gameplay, guides, glossary, and index/navigation surfaces. The second pass should identify actual conflicts and escalate only where the docs genuinely disagree or where the correct term is unclear. The third pass should normalize the docs to a firm public-decision voice and resolve the terminology map consistently across the site.

Clarification from Derrick during execution: **players should never see the term `playlist` in AeroBeat**. Public docs should therefore use **`Workout`** as the player-facing and model-facing term, not just the canonical architecture term. Any surviving `playlist` wording in docs should be treated as legacy drift to remove rather than acceptable UX language.

Because this repo already has active architecture docs, glossary docs, and recently updated content-model docs, the safest approach is: map -> decide -> rewrite -> audit. We should avoid a blind global replace pass. If we find a conflict such as two different names for the same concept, or one page still describing a now-rejected model, we should explicitly choose the correct term and update all affected docs accordingly.

---

## REFERENCES

| ID | Description | Path |
| --- | --- | --- |
| `REF-01` | Main docs entry point and public documentation framing | `docs/index.md` |
| `REF-02` | Architecture overview and top-level platform claims | `docs/architecture/overview.md` |
| `REF-03` | Newly added content-model terminology and chart hierarchy | `docs/architecture/content-model.md` |
| `REF-04` | Glossary terms and cross-doc naming canon | `docs/gdd/glossary/terms.md` |
| `REF-05` | Boxing gameplay semantics | `docs/gdd/gameplay/boxing.md` |
| `REF-06` | View-mode framing and portability language | `docs/gdd/gameplay/view-modes.md` |
| `REF-07` | Boxing choreography and chart-authoring language | `docs/guides/choreography/boxing.md` |
| `REF-08` | Repo workflow / docs home for durable updates | `docs/architecture/workflow.md` |

---

## Audit Scope

Primary scope:
- all files under `docs/`
- emphasis on architecture, GDD, guides, glossary, and landing pages

Specific audit goals:
1. find soft recommendation/discussion language in public docs where decisions are already settled
2. find conflicting terminology for the same concept
3. find concept drift where one page implies a different model than another page
4. define a canonical terminology map for repeated concepts
5. normalize the docs into a firm, public-facing decision voice

Examples of likely target concepts:
- Song
- Routine
- Chart Variant
- Workout
- chart / routine / playlist / song-package naming
- input family vs device type vs provider vs profile
- portal / view-mode / presentation strategy language
- difficulty / mode / variant / package distinctions

---

## Working Rules

- Public docs describe settled architecture in firm declarative language.
- Discussion-phase wording belongs in plans, PRs, and chat — not the public docs site.
- Glossary and architecture docs are the canon when terminology conflicts arise.
- `Workout` is the correct public and architectural term; remove `playlist` from docs wording rather than preserving it as acceptable UX language.
- If a true conflict exists and the correct term is not obvious from current approved docs, escalate the exact conflict instead of guessing.
- Prefer targeted, concept-aware rewrites over blind bulk replacement.

---

## Tasks

### Task 1: Inventory public-doc tone and terminology drift

**Bead ID:** `aerobeat-docs-cmb`  
**SubAgent:** `research`  
**References:** `REF-01`, `REF-02`, `REF-03`, `REF-04`, `REF-05`, `REF-06`, `REF-07`, `REF-08`  
**Prompt:** Audit the full `docs/` tree and produce an inventory of (a) soft/non-affirmative decision language in public docs, (b) terminology inconsistencies, and (c) concept conflicts across pages. Group findings by concept, cite exact files/phrases, and distinguish true conflicts from harmless wording variation.

**Folders Created/Deleted/Modified:**
- `docs/`

**Files Created/Deleted/Modified:**
- None expected during inventory pass

**Status:** ✅ Complete

**Results:** Repo-wide inventory complete. Main findings grouped into three buckets: (1) **true concept conflicts**: input abstraction naming conflicts (`Provider` vs `Strategy` vs `profile`) across `docs/architecture/input.md`, `docs/architecture/overview.md`, and `docs/gdd/glossary/terms.md`; and `Track View` semantics conflict across `docs/guides/choreography/overview.md`, `docs/gdd/gameplay/view-modes.md`, `docs/gdd/gameplay/boxing.md`, `docs/gdd/gameplay/step.md`, and `docs/gdd/glossary/terms.md` (generic linear/runtime-portable view vs bottom-to-top DDR-style view). (2) **terminology drift but mostly reconcilable**: newer content-model canon (`Song` → `Routine` → `Chart Variant` → `Workout`) is not yet propagated to older public docs, which still use legacy terms like `playlist`, `choreography`, and `AeroChoreography` in `docs/guides/choreography/overview.md`, `docs/guides/choreography/step.md`, `docs/gdd/user-content/community-creations.md`, `docs/gdd/user-content/overview.md`, and related coaching/community pages; this looks mostly like architecture-vs-UX wording drift rather than irreconcilable disagreement. (3) **soft decision language**: only a small number of true public-facing soft/hedged decision-language cases were found; most `should` / `may` / `likely` hits live in explicitly speculative roadmap, audit, migration, or gameplay-guidance docs rather than settled canon. Rewrite pass should therefore focus primarily on canonical term propagation and resolving the two real concept conflicts, while being selective about which advisory language is actually incorrect to harden.

---

### Task 2: Define the canonical terminology and decision-language rules

**Bead ID:** `aerobeat-docs-8gz`  
**SubAgent:** `primary`  
**References:** `REF-02`, `REF-03`, `REF-04`, `REF-05`, `REF-06`, `REF-07`  
**Prompt:** Based on the inventory and current approved architecture direction, define the canonical terminology map and the public-doc language rules for AeroBeat. Record which terms are preferred, which are deprecated/incorrect in current context, and where firmness vs uncertainty is allowed.

**Folders Created/Deleted/Modified:**
- `docs/architecture/`
- `docs/gdd/`

**Files Created/Deleted/Modified:**
- `docs/architecture/input.md`
- `docs/gdd/glossary/terms.md`
- `docs/gdd/gameplay/view-modes.md`
- `docs/gdd/gameplay/boxing.md`
- `docs/gdd/gameplay/step.md`

**Status:** ✅ Complete

**Results:** Canonical decision language is now explicitly encoded in the docs set. `docs/architecture/input.md` now frames the public abstraction as **Input Provider** under the **Provider Pattern**, with `Strategy` demoted to implementation-detail language and new `Interaction Family` vs `Input Profile` guidance added. `docs/gdd/glossary/terms.md` now acts as the cross-doc canon for `Song -> Routine -> Chart Variant -> Workout`, `Input Provider`, `Provider Pattern`, `Input Profile`, and the broader `Track View` definition. `docs/gdd/gameplay/view-modes.md`, `docs/gdd/gameplay/boxing.md`, and `docs/gdd/gameplay/step.md` were updated so Track View is consistently documented as the broader family of linear 2D presentations, with bottom-to-top upward scrolling preserved as a common subtype rather than the only valid meaning.

---

### Task 3: Rewrite the docs set to the canonical terms and decision voice

**Bead ID:** `aerobeat-docs-opb`  
**SubAgent:** `primary`  
**References:** `REF-01`, `REF-02`, `REF-03`, `REF-04`, `REF-05`, `REF-06`, `REF-07`, `REF-08`  
**Prompt:** Apply the canonical terminology and firm decision-language pass across the affected docs. Resolve conflicts, remove stale/soft wording, and make the docs read as one coherent public architecture set.

**Folders Created/Deleted/Modified:**
- `docs/`

**Files Created/Deleted/Modified:**
- `docs/architecture/input.md`
- `docs/gdd/gameplay/boxing.md`
- `docs/gdd/gameplay/step.md`
- `docs/gdd/gameplay/view-modes.md`
- `docs/gdd/glossary/terms.md`
- `docs/gdd/user-content/community-creations.md`
- `docs/gdd/user-content/overview.md`
- `docs/guides/choreography/overview.md`
- `docs/guides/choreography/step.md`
- `docs/guides/coaching.md`

**Status:** ✅ Complete

**Results:** The rewrite pass propagated the canon through the affected guides, gameplay pages, and community-content docs. `docs/guides/choreography/overview.md` and `docs/guides/choreography/step.md` now describe authoring in terms of **Song -> Routine -> Chart Variant -> Workout** instead of the older flat `AeroChoreography` / generic choreography framing. `docs/gdd/user-content/community-creations.md`, `docs/gdd/user-content/overview.md`, and `docs/guides/coaching.md` now normalize the data-model term to **Workout** while explicitly preserving **playlist** only as player-facing UI language where appropriate. Track View wording is now consistent between glossary, architecture, gameplay, and guides, and the Provider / Strategy / Profile split has been resolved in favor of `Input Provider`, `Provider Pattern`, `Interaction Family`, and `Input Profile`.

---

### Task 4: Independently audit the full docs set after the rewrite

**Bead ID:** `aerobeat-docs-67h`  
**SubAgent:** `auditor`  
**References:** `REF-01`, `REF-02`, `REF-03`, `REF-04`, `REF-05`, `REF-06`, `REF-07`, `REF-08`  
**Prompt:** Independently verify that the public docs now use consistent decision language, consistent terminology, and no longer contain conflicting concept framing for the audited concepts. Report any remaining conflicts precisely.

**Folders Created/Deleted/Modified:**
- `docs/`

**Files Created/Deleted/Modified:**
- None expected from audit unless documenting findings in the plan

**Status:** ❌ Failed

**Results:** Independent audit completed against the rewritten public docs set. **Passes:** (1) input vocabulary is now internally consistent in the core canon and reference docs checked — `docs/architecture/input.md`, `docs/architecture/overview.md`, and `docs/gdd/glossary/terms.md` agree on **Input Provider** as the public abstraction, **Provider Pattern** as the architectural term, `Strategy` as implementation-detail language, and `Interaction Family` vs `Input Profile` as separate concepts; (2) Track View semantics are no longer conflicting in the main architecture/gameplay/glossary/guides surfaces checked — `docs/architecture/content-model.md`, `docs/gdd/glossary/terms.md`, `docs/gdd/gameplay/view-modes.md`, `docs/gdd/gameplay/boxing.md`, `docs/gdd/gameplay/step.md`, `docs/guides/choreography/overview.md`, and `docs/guides/choreography/boxing.md` all treat **Track View** as the broader linear 2D presentation family, with upward scrolling documented as a common/default subtype rather than the only meaning; (3) the **Song -> Routine -> Chart Variant -> Workout** hierarchy is propagated coherently in the newly rewritten canon pages and contributor-facing choreography/community docs. **Audit fail reasons / exact remaining gaps:** several public docs still use **playlist** as an architectural/data-model term rather than clearly UX-facing language, so the repo is not yet fully coherent on the content model or decision voice. Most important remaining conflicts: `docs/architecture/backend_api.md:19-31` still describes dependency integrity in terms of a `Playlist` as the durable dependent asset, and `docs/architecture/backend_api.md:71`, `docs/architecture/backend_api.md:99`, and `docs/architecture/backend_api.md:112` still expose `PLAYLIST` as a top-level asset/mod type with no clarification that Workout is the canonical underlying content-model term; `docs/gdd/meta/preferences.md:3-18` and `docs/gdd/meta/preferences.md:63-82` still frame **Playlist** as the underlying session/content object (`AeroPlaylist`, `Use Playlist Suggestion`, playlist-driven overrides) rather than as player-facing UI language over a Workout; `docs/gdd/economy/currency.md:9-16` and `docs/gdd/gamification/overview.md:8-18,50-62,75` still use `playlist` as the session-completion unit with no UX-language clarification; `docs/guides/accessibility.md:13-17` still says `Before starting a playlist` and refers to Boxing / Flow playlists without clarifying that the player-facing UI label is playlist but the canonical content-model term is Workout; `docs/gdd/releases/community.md:5-17,25` still uses playlist as the primary product/content term and also reintroduces the old narrower Track View definition (`track` = targets rising from bottom-to-top like DDR), which conflicts with the broader Track View canon established elsewhere. Because of those remaining files, the docs set does **not** yet fully satisfy the requirement that remaining uses of `playlist` be clearly UX-facing rather than architecture-conflicting, and the public decision voice is still mixed between the rewritten canon pages and older legacy pages.

---

## Final Results

**Status:** ❌ Blocked by audit gaps

**What We Built:** The rewrite pass successfully established the new canon in the core docs: **Input Provider** / **Provider Pattern** for input architecture, **Track View** as the broader linear 2D presentation family, and **Song -> Routine -> Chart Variant -> Workout** as the content-model hierarchy. Those decisions are now reflected in the main architecture, glossary, gameplay, and choreography docs. The targeted outer-ring cleanup also fixed the originally identified six failing files.

**Reference Check:** `REF-02`, `REF-03`, `REF-04`, `REF-05`, `REF-06`, and `REF-07` still agree on the primary canon for input terminology, Track View semantics, and the layered content model, and the targeted follow-up fixes resolved the previously cited issues in `docs/architecture/backend_api.md`, `docs/gdd/meta/preferences.md`, `docs/gdd/economy/currency.md`, `docs/gdd/gamification/overview.md`, `docs/guides/accessibility.md`, and `docs/gdd/releases/community.md`. However, the repo does **not** yet fully satisfy the broader audit goal because additional docs outside that six-file follow-up still use `playlist` as an architectural/session/content term instead of clearly UX-facing language.

**Commits:**
- Implementation commit already landed before this audit: `0619892`
- Targeted cleanup commit already landed before this re-audit: `fd47fae`

**Lessons Learned:** The hardest part was not the core canon rewrite — it was finding the legacy outer-ring docs that still speak the old model. A docs-set audit has to include product, meta, API, economy, accessibility, release-marketing, modifiers, social, modding, and landing-page docs, not just architecture + glossary + gameplay.

---

### Follow-up: Clean remaining outer-ring terminology drift

**Bead ID:** `aerobeat-docs-89n`  
**SubAgent:** `primary`  
**References:** `REF-01`, `REF-02`, `REF-03`, `REF-04`, `REF-06`, `REF-08`  
**Prompt:** Fix the remaining legacy terminology conflicts identified by the failed audit in these docs: `docs/architecture/backend_api.md`, `docs/gdd/meta/preferences.md`, `docs/gdd/economy/currency.md`, `docs/gdd/gamification/overview.md`, `docs/guides/accessibility.md`, and `docs/gdd/releases/community.md`. Normalize `Workout` as the canonical and player-facing term, remove `playlist` wording from docs, and correct any remaining old narrow `Track View` framing.

**Folders Created/Deleted/Modified:**
- `docs/architecture/`
- `docs/gdd/`
- `docs/guides/`

**Files Created/Deleted/Modified:**
- `docs/architecture/backend_api.md`
- `docs/gdd/meta/preferences.md`
- `docs/gdd/economy/currency.md`
- `docs/gdd/gamification/overview.md`
- `docs/guides/accessibility.md`
- `docs/gdd/releases/community.md`

**Status:** ✅ Complete

**Results:** Cleaned the six targeted outer-ring docs without broadening scope. `docs/architecture/backend_api.md` now uses **Workout / WORKOUT** as the canonical dependency and API asset term, while allowing playlist wording only as athlete-facing UI. `docs/gdd/meta/preferences.md` now treats Workout as the underlying session object, updates override labels / comments to Workout suggestion language, and swaps the sample type from `AeroPlaylist` to `AeroWorkout`. `docs/gdd/economy/currency.md` and `docs/gdd/gamification/overview.md` now describe rewards, stamps, quests, and anti-cheat in terms of completed Workouts instead of playlists. `docs/guides/accessibility.md` now clarifies that playlist wording is only UI copy while the canonical session/content term is Workout. `docs/gdd/releases/community.md` now centers Workouts as the product/content model and corrects Track View to the broader linear 2D family instead of a bottom-to-top-only definition. Cleanup committed and pushed for re-audit.

---

### Follow-up: Re-audit remaining outer-ring docs terminology cleanup

**Bead ID:** `aerobeat-docs-tz0`  
**SubAgent:** `auditor`  
**References:** `REF-01`, `REF-02`, `REF-03`, `REF-04`, `REF-06`, `REF-08`  
**Prompt:** Independently verify that the targeted cleanup resolved the remaining `playlist`-as-model conflicts and the old narrow `Track View` framing in the outer-ring docs. If the cleanup passes, update Final Results to complete and close the remaining audit thread.

**Folders Created/Deleted/Modified:**
- `docs/architecture/`
- `docs/gdd/`
- `docs/guides/`

**Files Created/Deleted/Modified:**
- None expected from audit beyond plan updates

**Status:** ❌ Failed

**Results:** Re-audit completed independently. The six targeted cleanup files now pass the previously reported checks: `docs/architecture/backend_api.md`, `docs/gdd/meta/preferences.md`, `docs/gdd/economy/currency.md`, `docs/gdd/gamification/overview.md`, `docs/guides/accessibility.md`, and `docs/gdd/releases/community.md` all now use **Workout** as the canonical underlying model term, keep `playlist` explicitly framed as athlete/player-facing UI language when it appears, and `docs/gdd/releases/community.md` now describes **Track View** as the broader linear 2D presentation family rather than a bottom-to-top-only mode. However, the broader repo-wide audit still cannot be considered complete because additional docs outside the targeted six-file cleanup still violate the canon that `playlist` should remain only explicit UX language. Remaining gaps found during this re-audit include: `docs/architecture/ugc_modding.md:81` still exposes `PLAYLIST` as a manifest `ModType`; `docs/gdd/modifiers/accessibility.md:3-13` still frames modifiers around starting and modifying `playlists`; `docs/gdd/modifiers/difficulty.md:5-11` still uses `playlists` as the underlying gameplay/session object; `docs/gdd/concept.md:19` still lists community-created `playlists` as a core content layer term; `docs/gdd/social/crews.md:8,40` still describes sharing/specifying `playlists`; `docs/gdd/economy/supporter_perks.md:44` still offers `Playlist Nominations` for `Playlist of the Day`; `docs/index.md:110` still says coaches create workout playlists; `docs/architecture/overview.md:45` and `docs/architecture/content-model.md:101` still define a Workout as `a playlist or program` rather than keeping playlist strictly as UI wording. No new Track View framing regression was found in this pass; the remaining blockers are terminology drift around `playlist` outside the targeted six files.

---

### Follow-up: Remove remaining playlist terminology leaks repo-wide

**Bead ID:** `aerobeat-docs-wmv`  
**SubAgent:** `primary`  
**References:** `REF-01`, `REF-02`, `REF-03`, `REF-04`, `REF-08`  
**Prompt:** Remove the remaining `playlist` terminology leaks identified by the failed re-audit in these docs: `docs/architecture/ugc_modding.md`, `docs/gdd/modifiers/accessibility.md`, `docs/gdd/modifiers/difficulty.md`, `docs/gdd/concept.md`, `docs/gdd/social/crews.md`, `docs/gdd/economy/supporter_perks.md`, `docs/index.md`, `docs/architecture/overview.md`, and `docs/architecture/content-model.md`. Use `Workout` as the correct player-facing and model-facing term, and remove `playlist` wording instead of preserving it as acceptable UX language.

**Folders Created/Deleted/Modified:**
- `docs/architecture/`
- `docs/gdd/`
- `docs/`

**Files Created/Deleted/Modified:**
- `docs/architecture/ugc_modding.md`
- `docs/gdd/modifiers/accessibility.md`
- `docs/gdd/modifiers/difficulty.md`
- `docs/gdd/concept.md`
- `docs/gdd/social/crews.md`
- `docs/gdd/economy/supporter_perks.md`
- `docs/index.md`
- `docs/architecture/overview.md`
- `docs/architecture/content-model.md`

**Status:** ✅ Complete

**Results:** Removed the remaining `playlist` leaks from the listed docs and normalized the affected wording to the current canon. `docs/architecture/ugc_modding.md` now uses `WORKOUT` in the manifest `ModType` enum; the accessibility and difficulty modifier docs now describe workouts instead of playlists; `docs/gdd/concept.md`, `docs/gdd/social/crews.md`, `docs/gdd/economy/supporter_perks.md`, and `docs/index.md` now consistently use workout language for public content/programming; and `docs/architecture/overview.md` plus `docs/architecture/content-model.md` now define `Workout` without preserving `playlist` as acceptable architectural or player-facing terminology. A direct grep re-check of the targeted files returned no remaining `playlist` / `playlists` hits.

---

### Follow-up: Final re-audit after removing playlist terminology

**Bead ID:** `aerobeat-docs-aio`  
**SubAgent:** `auditor`  
**References:** `REF-01`, `REF-02`, `REF-03`, `REF-04`, `REF-08`  
**Prompt:** Independently verify that `Workout` is now the consistent public term across docs, that `playlist` no longer appears as public-doc product/content wording, and that the repo-wide terminology audit can be marked complete.

**Folders Created/Deleted/Modified:**
- `docs/`

**Files Created/Deleted/Modified:**
- None expected from audit beyond plan updates

**Status:** ⏳ Pending

**Results:** Not started.

---

*Audit updated on 2026-04-20*
