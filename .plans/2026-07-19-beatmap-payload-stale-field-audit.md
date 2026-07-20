# AeroBeat Beatmap Payload Stale-Field Audit

**Date:** 2026-07-19
**Status:** In Progress
**Last Updated:** 2026-07-20 00:18 EDT
**Blocked Reason:** None
**Agent:** `pico`

---

## Goal

Audit the current AeroBeat beatmap/chart payload shape to find stale fields or semantics that no longer belong in the BeatSaver-aligned conversion architecture.

---

## Overview

Derrick wants a targeted audit of the actual beat payload shape now that the architecture has shifted hard toward BeatSaver conversion. The concern is that some chart payload details may still reflect older AeroBeat-authored semantics instead of the new BeatSaver-aligned model.

Specific suspected baggage includes older Flow ideas such as beats with `start` + `end` semantics that could repeat over time, held-note/obstacle-like semantics, and other stale authored fields that are no longer used by the new BeatSaver conversion architecture. The goal is not to blindly delete any field that looks complex; it is to determine whether each chart payload field is still required by the converted BeatSaver model, should be reinterpreted, or should be retired.

This coordination plan lives in `aerobeat-docs` per Derrick’s preference so it has a real repo home instead of the shared ignored umbrella path.

---

## REFERENCES

| ID | Description | Path |
| --- | --- | --- |
| `REF-01` | Prior BeatSaver conversion architecture plan | `/home/derrick/.openclaw/workspace/projects/aerobeat/.plans/2026-06-23-beatsaver-conversion-architecture-and-flow-first.md` |
| `REF-02` | Current content-core chart contract | `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-content-core/data_types/chart.gd` |
| `REF-03` | Current content-core chart contract tests | `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-content-core/tests/test_chart_event_contract.gd` |
| `REF-04` | Content-core fixtures and canonical sample content | `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-content-core/fixtures/` |
| `REF-05` | Current docs/content rewrite execution plan | `/home/derrick/.openclaw/workspace/projects/aerobeat/.plans/2026-07-19-aerobeat-docs-and-content-contract-rewrite-execution.md` |

---

## Tasks

### Task 1: Audit current beat payload fields against BeatSaver-aligned semantics

**Bead ID:** `aerobeat-docs-jd8`
**SubAgent:** `primary` (for `research`)
**Role:** `research`
**References:** `REF-01`, `REF-02`, `REF-03`, `REF-04`, `REF-05`
**Prompt:** In `/home/derrick/.openclaw/workspace/projects/aerobeat`, claim the assigned bead at start if resolvable. Serve as the research role. Audit the current beat/chart payload shape in `aerobeat-content-core` against the BeatSaver-aligned conversion architecture. Derrick specifically suspects stale baggage such as old Flow-style `start`+`end` repetition/held semantics, obstacle-like legacy semantics, or other unused authored beat fields that no longer belong in the new model. Determine field-by-field which beat payload fields are: (a) still valid for BeatSaver-aligned conversion, (b) currently implemented but now wrong/stale, or (c) ambiguous and need a follow-up design decision. Include exact file/path findings, canonical sample/fixture evidence, and recommended next cleanup seam if stale fields remain. Update this plan with results and close the bead with a concrete reason when done.

**Folders Created/Deleted/Modified:**
- `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-docs/.plans/`

**Files Created/Deleted/Modified:**
- `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-docs/.plans/2026-07-19-beatmap-payload-stale-field-audit.md`

**Status:** ✅ Complete

**Results:** Completed the field-by-field audit against the current `aerobeat-content-core` chart contract, tests, fixtures, and the BeatSaver-aligned architecture plan.

Field-by-field read of the current beat payload shape:

- **`start`** — **(a) still valid**. `aerobeat-content-core/data_types/chart.gd` requires every beat to declare numeric `start` (`lines 58-71`). This still matches the BeatSaver-aligned model for both Boxing semantic events and Flow burst head timing.
- **`type`** — **(a) still valid, but now tightly feature-scoped**. Boxing only allows the semantic BeatSaver-aligned set `straight_left/right`, `hook_left/right`, `uppercut_left/right`, `guard`, `squat`, `weave_left/right` (`chart.gd:15-27`, `95-117`). Flow currently allows only `burst` (`chart.gd:28-30`, `120-136`). This matches the architecture direction that old Flow vocab should not survive as canonical authored truth.
- **`portal`** — **(b) implemented but explicitly stale**. Both Boxing and Flow reject `portal` with stale-field messages (`chart.gd:111-117`, `122-128`). This directly matches the architecture decision to retire portal-based authored placement for the 2D/webcam-first contract.
- **legacy Boxing `type` values (`jab`, `cross`, `jab_left`, `cross_right`, `punch_left`, `punch_right`)** — **(b) implemented but stale**. They are preserved only as rejection/replacement knowledge in `BOXING_LEGACY_TYPE_REPLACEMENTS` (`chart.gd:6-13`) and exercised by the legacy fixture + contract test (`tests/test_chart_event_contract.gd:35-43`; `fixtures/invalid_boxing_legacy_chart_vocab/charts/chart-demo-boxing-medium.json` contains `jab`, `cross`, `orthodox`).
- **old authored Boxing semantic types like `orthodox`** — **(b) implemented but stale**. The invalid legacy fixture above includes `orthodox`, and the contract test expects it to fail as `invalid_boxing_type` (`tests/test_chart_event_contract.gd:44-52`, `112-118`). This confirms stance-style authored beat semantics no longer belong in the current chart model.
- **`end`** — **mixed**:
  - **Flow `burst`: (a) still valid and required.** The architecture freezes `start..end` for Flow burst timing (`REF-01` lines `1570-1599`; canonical docs at `aerobeat-docs/docs/architecture/beatsaver-flow-v1-conversion.md:257-296`), and `chart.gd` requires Flow burst `end` (`137-143`).
  - **Generic Boxing beat `end`: (c) ambiguous and probably the main remaining stale seam.** The base validator accepts numeric `end` on any beat before feature-specific checks (`chart.gd:72-78`), and the contract test currently treats a Boxing `straight_left` with `end: 2.0` as valid (`tests/test_chart_event_contract.gd:21-34`, especially `25-28`). But the BeatSaver-aligned Boxing architecture now treats normal punches as semantic events, explicitly says repeated guard prompting should emit multiple `guard` events rather than a hold-style guard object (`REF-01` lines `2188-2199`), and only clearly justifies time-ranged hold semantics for obstacle-derived avoidance windows (`REF-01` lines `1156-1167`). So `end` is no longer a safe generic Boxing field even though current validation still permits it.
- **`hand`** — **(a) still valid for Flow burst only**. The Flow burst schema explicitly preserves BeatSaver hand/color ownership as `left|right` (`chart.gd:144-158`; `beatsaver-flow-v1-conversion.md:273-294`). No evidence in `content-core` says this should appear on Boxing authored beats.
- **`placement`** — **(a) still valid for Flow burst only**. It is required for the frozen burst object as the head cell (`chart.gd:159-172`; `tests/test_chart_event_contract.gd:63-92`; `beatsaver-flow-v1-conversion.md:263-294`). However, the broader old Flow authored `placement` model is no longer canonical for ordinary notes/objects (`beatsaver-flow-v1-conversion.md:298-312`; `docs/guides/choreography/flow.md`).
- **`direction`** — **(a) still valid for Flow burst only**. It remains the burst head cut-direction carry-through (`chart.gd:173-186`; `beatsaver-flow-v1-conversion.md:285-294`). As with `placement`, the older general Flow `direction` authored model is no longer the general current truth for non-burst objects.
- **`tailPlacement`** — **(a) still valid for Flow burst only**. Required in the frozen burst schema (`chart.gd:187-200`; `beatsaver-flow-v1-conversion.md:273-294`).
- **`checkpointCount`** — **(a) still valid for Flow burst only**. Required positive integer in validator (`chart.gd:201-214`), matching the locked BeatSaver `sliceCount`/`sc` mapping (`beatsaver-flow-v1-conversion.md:263-294`).
- **`spacingBias`** — **(a) still valid but optional for Flow burst only**. Optional numeric field in validator (`chart.gd:215-220`), matching the locked optional BeatSaver `squish`/`s` carry-through (`beatsaver-flow-v1-conversion.md:265-266`, `293-294`).
- **old Flow `type` values like `swing_left` / `trail_*`** — **(b) stale**. The contract test explicitly proves `swing_left` is now invalid (`tests/test_chart_event_contract.gd:93-101`, `121`), and the current Flow docs say not to reintroduce old `portal`, `swing_*`, or `trail_*` vocabulary as canonical authored guidance (`docs/guides/choreography/flow.md`; `beatsaver-flow-v1-conversion.md:302-312`).

Canonical evidence / fixture read:

- Current canonical `content-core` fixture coverage is overwhelmingly Boxing-only. The clean song-package fixtures under `aerobeat-content-core/fixtures/song_package_yaml_valid_splat/charts/` contain only simple Boxing beats with `start` + semantic Boxing `type` fields.
- There are **no canonical Flow chart fixtures** in `aerobeat-content-core/fixtures/`; Flow evidence currently lives in the contract test plus docs, not in a representative package fixture. That means the only truly frozen Flow payload object in live `content-core` today is `type: burst`, exactly as the docs say.
- The old authored-model baggage is present only as negative coverage now: `invalid_boxing_legacy_chart_vocab` preserves `jab`, `cross`, and `orthodox` purely so the validator can reject them.

Bottom line:

- Derrick’s suspected old `portal` baggage is already correctly marked stale and rejected.
- Old Flow `swing_*` / `trail_*` and old Boxing strike/stance labels are also already stale and rejected.
- The one real payload seam still left fuzzy in live code is **generic `end` acceptance**, especially on ordinary Boxing beats. That permissiveness looks like leftover authored hold semantics bleeding past the newer BeatSaver-aligned contract.

Recommended next cleanup seam:

1. Tighten `aerobeat-content-core/data_types/chart.gd` so `end` is **type-scoped instead of globally tolerated**.
   - Keep `end` required for Flow `burst`.
   - Decide explicitly whether Boxing `squat` / `weave_*` authored beats should carry `end` as obstacle-window holds, or whether even those should become repeated semantic events plus runtime hold logic.
   - Reject `end` on Boxing punch/guard beats unless Derrick deliberately wants a hold-style Boxing chart lane back.
2. Add contract tests for the chosen Boxing `end` policy so this seam stops being implicit.
3. Do **not** resurrect the old general Flow authored note schema just to fill the gap. If ordinary direct-4x3 Flow YAML is still intentionally unfrozen, keep `content-core` honest by only validating the frozen `burst` object plus stale-field rejection until the new general Flow record shape is actually designed.

---

### Task 2: Restrict `end` to Flow burst only and reject it for Boxing

**Bead ID:** `aerobeat-docs-9xl`
**SubAgent:** `primary` (for `coder`)
**Role:** `coder`
**References:** `REF-01`, `REF-02`, `REF-03`, `REF-05`
**Prompt:** In `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-content-core`, claim the assigned bead at start. Serve as the coder. Derrick approved the next chart-payload cleanup seam: Boxing cannot carry `end`; only Flow `burst` can use `end`. Update `data_types/chart.gd` so generic `end` permissiveness is removed, keep `end` required for Flow `burst`, reject `end` for Boxing event types, and add/adjust tests and any representative fixtures needed so this truth is explicit and durable. Update this plan with exact edits and validation. Commit and push to `main` by default unless blocked. Close the bead with a concrete reason when done.

**Folders Created/Deleted/Modified:**
- `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-content-core/data_types/`
- `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-content-core/tests/`
- `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-content-core/fixtures/`
- `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-docs/.plans/`

**Files Created/Deleted/Modified:**
- `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-content-core/data_types/chart.gd`
- `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-content-core/tests/test_chart_event_contract.gd`
- `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-content-core/fixtures/invalid_boxing_end_field/manifest.json`
- `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-content-core/fixtures/invalid_boxing_end_field/charts/chart-demo-boxing-medium.json`
- `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-content-core/fixtures/invalid_boxing_end_field/coaches/coach-config.json`
- `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-content-core/fixtures/invalid_boxing_end_field/environments/environment-demo-gym.json`
- `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-content-core/fixtures/invalid_boxing_end_field/sets/set-demo-boxing-round-01.json`
- `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-content-core/fixtures/invalid_boxing_end_field/songs/song-demo.json`
- `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-content-core/fixtures/invalid_boxing_end_field/workouts/demo-workout.json`
- `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-docs/.plans/2026-07-19-beatmap-payload-stale-field-audit.md`

**Status:** ✅ Complete

**Results:** Tightened the live chart contract so `end` is no longer generically tolerated on any beat. In `aerobeat-content-core/data_types/chart.gd`, the base validator still type-checks `end` when present but now short-circuits after `chart_beat_invalid_end` so malformed numeric failures do not cascade into feature-specific stale-field noise. Boxing validation now emits a dedicated `invalid_boxing_end` error whenever any Boxing beat declares `end`, with the message making the new contract explicit: only Flow `burst` beats may carry an `end` beat value. Flow `burst` still requires `end` unchanged, so the only allowed positive use of `end` remains the frozen BeatSaver-aligned burst object from `REF-01`.

Expanded `aerobeat-content-core/tests/test_chart_event_contract.gd` to make the new policy durable in three places: the happy-path Boxing sample no longer includes `end`; a direct Boxing beat with `end` is now expected to fail as `invalid_boxing_end`; and a new representative package fixture is validated end-to-end so repo-level contract coverage proves a serialized Boxing chart carrying `end` is rejected. Added `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-content-core/fixtures/invalid_boxing_end_field/` by cloning the canonical minimal Boxing package and introducing `end` on the first chart beat, giving the suite a durable serialized example of the stale field.

Validation: `godot --headless --path .testbed --script res://../tests/run_contract_tests.gd` passed in `aerobeat-content-core`, including the new `invalid_boxing_end` direct-contract and fixture-package assertions. Content-core changes were committed and pushed as `1195f53` (`Restrict chart end field to flow burst`).

---

## Final Results

**Status:** ⚠️ Partial

**What We Built:** Completed the stale-field audit and the approved coder cleanup seam that hardens `end` to Flow `burst` only in the live `aerobeat-content-core` chart contract.

**Reference Check:**
- `REF-01` checked against the locked BeatSaver Flow/Boxing architecture decisions, especially portal retirement, Flow burst freeze, direct-4x3 Flow posture, and Boxing semantic chart encoding.
- `REF-02` checked directly against the live validator implementation in `aerobeat-content-core/data_types/chart.gd`.
- `REF-03` checked directly against the contract test evidence in `aerobeat-content-core/tests/test_chart_event_contract.gd`.
- `REF-04` checked against canonical package fixtures in `aerobeat-content-core/fixtures/`.
- `REF-05` stays consistent with the broader rewrite direction: the old authored Flow/Boxing baggage is mostly already removed, and the previously identified generic `end` permissiveness seam is now hardened in code/tests.

**Commits:**
- `1195f53` - `Restrict chart end field to flow burst` (`aerobeat-content-core`)
- `5a3b870` - `Document boxing end field hardening` (`aerobeat-docs`)

**Lessons Learned:**
- The suspected pre-BeatSaver baggage is mostly already retired in live `content-core`; the validator explicitly rejects stale `portal`, stale Boxing labels, and stale Flow `swing_*` style vocabulary.
- The current contract is more minimal than it first appears: Boxing fixtures are canonical, while Flow is only truly frozen as the `burst` object so far.
- Generic optional field acceptance is easy to leave behind during architecture shifts; fixture-backed negative coverage is the cheapest way to keep stale authored semantics from creeping back in.

---

*Updated on 2026-07-20*
