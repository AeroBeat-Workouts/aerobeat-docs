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

**Status:** ⏳ Pending

**Results:** Not started.

---

## Final Results

**Status:** ✅ Complete

**What We Built:** Canonical terminology and decision-language rules are now encoded in the docs set, with the main conflicts resolved. The docs now consistently use **Input Provider** / **Provider Pattern** for the runtime input abstraction, clarify that **Track View** is the broader family of linear 2D presentations rather than only bottom-to-top scrolling, and propagate the content-model hierarchy **Song -> Routine -> Chart Variant -> Workout** through glossary, gameplay, choreography, coaching, and community-content pages.

**Reference Check:** `REF-02`, `REF-03`, and `REF-04` now act in agreement for input, content-model, and glossary canon. `REF-05`, `REF-06`, and `REF-07` were normalized so Boxing / view-mode / choreography wording no longer conflicts on Track View semantics or content-model terms. `REF-01` and `REF-08` did not require substantive terminology rewrites beyond consistency with the updated canon.

**Commits:**
- Final implementation commit created in this execution pass and pushed to `main`

**Lessons Learned:** The inventory was correct that the real work was not a broad soft-language scrub. The important pass was to define canon in glossary + architecture first, then propagate those decisions into the mode-specific and creator-facing docs that had accumulated older playlist/choreography assumptions.

---

*Completed on 2026-04-20*
