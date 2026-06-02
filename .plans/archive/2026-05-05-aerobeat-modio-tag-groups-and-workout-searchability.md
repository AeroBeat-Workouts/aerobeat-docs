# AeroBeat mod.io Tag Groups and Workout Searchability

**Date:** 2026-05-05  
**Status:** Stale  
**Agent:** Chip 🐱‍💻

---

## Goal

Define the tag-group strategy for the private AeroBeat mod.io page so workout packages will be searchable and filterable in ways that actually match AeroBeat’s planned content model, while avoiding premature or noisy taxonomy.

---

## Overview

Derrick created the private AeroBeat mod.io page and the next step is configuring tag groups. This should not be treated as random storefront metadata. The mod.io tag groups need to line up with the search/query/tag fields AeroBeat expects to care about for workout discovery, package browsing, and eventual install/download flows.

Prior AeroBeat content work already locked that local discovery will eventually care about search/filter/tag browsing, and that `workouts.db` should hold the metadata needed for those queries. That means mod.io tag groups should be chosen as a practical public/distribution taxonomy, not as a duplicate of every authored field in `workout.yaml`.

The clean path is: first identify which dimensions really matter for browsing and filtering workout packages, then translate only the useful ones into mod.io tag groups, then document the intended mapping so future authoring/import/tooling work stays consistent.

Derrick also clarified the mod.io-side control model we should design for: tag categories can contain multiple tag names, can optionally allow multiple selections, can be hidden to admins only, and can be restricted so only admins can edit/use them. That means the proposal should explicitly classify categories by visibility/editability and by whether they are user-facing browse filters versus internal moderation/curation metadata.

---

## REFERENCES

| ID | Description | Path |
| --- | --- | --- |
| `REF-01` | Daily memory note on search/filter/tag browsing in `workouts.db` | `memory/2026-04-23.md` |
| `REF-02` | Workout schema discussion on search/query/tags metadata | `memory/2026-04-24-workout-schema.md` |
| `REF-03` | Package-contract completion handoff | `memory/2026-04-25.md` |
| `REF-04` | Current AeroBeat docs repo | `/workspace/projects/aerobeat/aerobeat-docs/` |
| `REF-05` | Current mod.io game page context | private AeroBeat mod.io project |

---

## Tasks

### Task 1: Audit AeroBeat’s current workout/package metadata for searchability dimensions

**Bead ID:** `aerobeat-docs-6ht1`  
**SubAgent:** `primary`  
**Role:** `research`  
**References:** `REF-01` through `REF-04`  
**Prompt:** In `aerobeat-docs`, claim the assigned bead on start. Audit the current AeroBeat workout/package docs and identify the metadata dimensions that actually matter for package searchability and browsing. Separate durable high-value browse/filter fields from low-value/internal/authored-only metadata. Update the plan with the recommended searchability dimensions and close the bead.

**Folders Created/Deleted/Modified:**
- `.plans/`
- docs paths only if a short notes file is useful

**Files Created/Deleted/Modified:**
- `.plans/2026-05-05-aerobeat-modio-tag-groups-and-workout-searchability.md`

**Status:** ✅ Complete

**Results:** Audit completed against the current docs contracts and example package data. The strongest current browse/search dimensions are the ones already represented or clearly implied by the discovery-layer docs: `feature` (from chart `feature`, surfaced in `workout_features`), `difficulty` (from chart `difficulty`, surfaced in `workout_difficulties`), `genre` (union of authored song genres, surfaced in `workout_genres`), and coaching presence / coach roster (from `coach-config.yaml`, surfaced in `workout_coaches`). Duration also matters for browsing, but the current docs model it as numeric metadata (`duration_ms` on `workouts` / `workout_songs`), so it should likely drive native sort/range/filter behavior rather than freeform tags. Environment identity exists in package metadata but the current docs do not yet show environment summaries as a first-class browse/index table, so exact environment names/themes look lower-confidence for launch tags unless Derrick explicitly wants atmosphere-based discovery. Authored provenance fields (`createdByTool`, schema versions, timestamps, author ids), package/install/cache state, preview image strategy, and exact content ids are useful operational metadata but low-value as public discovery tags.

## Audit Findings: Searchability Dimensions That Matter

### 1. High-value user-facing browse/filter dimensions

These are the dimensions that materially help an athlete find the right workout package in a storefront-like browser.

#### A. Gameplay feature

- **Why it matters:** This is the clearest top-level intent filter. AeroBeat is explicitly organized around feature-specific chart content, and the docs already normalize gameplay classification to `feature` rather than legacy `mode` terminology.
- **Evidence in current docs:**
  - `docs/architecture/content-model.md` defines Boxing and Flow as the active authored features.
  - chart YAML examples carry `feature: boxing` / `feature: flow`.
  - `docs/examples/workout-packages/demo-neon-boxing-bootcamp/sql/workouts.db.schema.sql` includes `workout_features(feature)` specifically so clients can filter without reparsing chart files.
- **Searchability value:** Extremely high. This should almost certainly be a public browse/filter dimension.

#### B. Difficulty

- **Why it matters:** Athletes need to avoid workouts that are too easy or too hard, and the docs already treat difficulty as a browse filter rather than hidden authored trivia.
- **Evidence in current docs:**
  - chart YAML examples carry `difficulty: medium` / `difficulty: hard`.
  - `workout_difficulties(difficulty)` exists specifically for browse filters.
  - profile/preferences docs mention auto-filtering difficulty in the workout browser.
- **Searchability value:** Extremely high. This is a core public filter.

#### C. Music genre

- **Why it matters:** Genre is a natural discovery vector when browsing rhythm workouts. It helps users find a workout vibe they want even when they do not know package names or creators.
- **Evidence in current docs:**
  - song YAML `metadata.genres` is authored directly.
  - `workout_genres(genre)` exists as the union of referenced song genres.
  - the schema uses a controlled enum, which is good for stable filtering.
- **Searchability value:** High. Strong public browse/filter candidate.

#### D. Coaching availability / coached vs uncoached

- **Why it matters:** Whether a package includes coaching materially changes the workout experience and is easy for users to understand.
- **Evidence in current docs:**
  - the architecture explicitly models coaching as optional all-or-nothing.
  - `workout_coaches` exists and is derived from the package coach config.
- **Searchability value:** High, but best kept coarse. The useful user-facing dimension is likely “coached” vs “not coached,” with optional coach-name discovery later if the creator ecosystem makes named coaches meaningful.

#### E. Duration bucket

- **Why it matters:** Duration is one of the most practical workout-selection criteria.
- **Evidence in current docs:**
  - `duration_ms` exists on `workouts` and song summaries in the discovery schema.
  - broader product docs repeatedly frame workouts as sessions users select for a given time/effort window.
- **Searchability value:** High, but this is better treated as structured numeric filtering or derived buckets than raw tags. It should inform the tag-group design conversation, but not automatically become freeform public tags unless mod.io’s available controls make bucketing necessary.

#### F. Atmosphere / environment theme

- **Why it matters:** Visual vibe can influence discovery, especially in a rhythm-fitness product.
- **Evidence in current docs:**
  - sets choose exact `environmentId` values.
  - environment records remain part of the package contract because they meaningfully shape workout atmosphere.
- **Searchability value:** Medium, not yet fully earned by the current schema. The docs support atmosphere as a concept, but do not yet define a strong controlled discovery surface for environment themes. This is a possible later public filter, not a must-have launch dimension.

### 2. Admin / curation / moderation dimensions

These matter operationally, but should not be treated as the main public discovery vocabulary.

#### A. Approval / trust / moderation state

- **Examples:** reviewed, approved, featured, quarantined, hidden, rejected, needs-fix, copyright-risk.
- **Why it matters:** The UGC distribution docs make AeroBeat’s validation/trust boundary first-party even when mod.io is the outer shell.
- **Use in mod.io terms:** Good fit for admin-hidden and/or admin-only categories.

#### B. Content policy / licensing flags

- **Examples:** explicit lyrics/content, streaming safe, AI-assisted, licensing class.
- **Why it matters:** These are real operational and policy surfaces present in song metadata.
- **Use in mod.io terms:** Mostly moderation/compliance metadata, though `explicit` could later become a user-facing safety filter if Derrick wants that.

#### C. Release / curation merchandising flags

- **Examples:** new-release candidate, seasonal, official-pick, workout-of-the-day candidate, beginner-friendly curated pick.
- **Why it matters:** Useful for storefront/editorial management.
- **Use in mod.io terms:** Admin-controlled, possibly public-facing only through curated feeds rather than user-editable tags.

#### D. Creator / provenance review flags

- **Examples:** official creator, trusted creator, docs fixture, internal test content, migration-needed.
- **Why it matters:** Helpful internally, not meaningful as user-authored taxonomy.
- **Use in mod.io terms:** Admin-only/hidden if used at all.

### 3. Low-value internal or authored-only metadata that should stay out of mod.io tags

These fields are useful in package YAML, validation, or local indexing, but they are weak or noisy as storefront tags.

- exact ids and wiring fields: `workoutId`, `songId`, `chartId`, `setId`, `environmentId`, `coachConfigId`, `coachingOverlayId`
- schema/provenance/versioning: `schemaId`, `schemaVersion`, `recordVersion`, `packageVersion`, `createdByTool`, `createdByToolVersion`, timestamps
- package/install/cache/runtime bookkeeping: `workout_yaml_path`, `package_root_path`, `installed_at`, `indexed_at`, `updated_at`, `is_installed`, `is_valid`, `validation_error`, preview image strategy/url
- exact media/resource paths and package layout details
- credits/publisher/composer fields unless AeroBeat later decides creator/artist pages are a first-class browse surface
- low-level chart beat taxonomy (`jab`, `cross`, `portal`, `placement`, etc.) — useful for gameplay logic and maybe future accessibility analytics, but too granular for mod.io tags at launch
- exact environment ids or raw asset types without a higher-level user meaning

## Audit Conclusion

The current docs support a lean searchability hierarchy.

**Best current public discovery dimensions:**
- gameplay feature
- difficulty
- music genre
- coaching presence
- duration bucket/range

**Possible later public dimension, but not clearly proven yet:**
- atmosphere / environment theme

**Best admin-only or admin-hidden dimensions:**
- approval/trust/moderation status
- licensing/policy/compliance flags
- editorial/curation flags
- provenance/test/internal workflow flags

**Strong recommendation:** when the next task proposes actual mod.io tag groups, it should resist mirroring every authored field. The current AeroBeat contract says discoverability is a derived browse layer, so the mod.io taxonomy should stay small, controlled, and biased toward what athletes actually use to choose a workout.

---

### Task 2: Propose the mod.io tag-group schema for AeroBeat

**Bead ID:** `aerobeat-docs-vkwt`  
**SubAgent:** `primary`  
**Role:** `research`  
**References:** `REF-01` through `REF-05`  
**Prompt:** In `aerobeat-docs`, claim the assigned bead on start. Turn the approved searchability dimensions into a practical mod.io tag-group proposal. Recommend which groups should exist, which should be single-select vs multi-select, which values should be controlled vocabularies, which categories should be public vs admin-hidden, which should be admin-only editable/usable, and which metadata should stay out of mod.io tags entirely. Keep the schema lean enough to be maintainable at launch. Update the plan with the proposed tag groups, rationale, and any open questions, then close the bead.

**Folders Created/Deleted/Modified:**
- `.plans/`
- docs paths only if a short note is useful

**Files Created/Deleted/Modified:**
- `.plans/2026-05-05-aerobeat-modio-tag-groups-and-workout-searchability.md`

**Status:** ✅ Complete

**Results:** Proposed a lean launch schema with four categories total: three public athlete-facing browse filters and one admin-hidden moderation/control bucket. Recommended public categories are `feature` (single-select, normal/public, normal editable/usable, example values `boxing`, `flow`), `difficulty` (single-select, normal/public, normal editable/usable, example values `easy`, `normal`, `hard`, `pro`), and `genre` (multi-select, normal/public, normal editable/usable, example values drawn from the controlled song-genre vocabulary already used in package metadata such as `electronic`, `hip_hop`, `rock`, `pop`, `latin`, `ambient`). Recommended the one launch-time operational category as `trust_state` (single-select, admin-hidden, admin-only editable/usable, example values `pending_review`, `approved`, `featured`, `quarantined`, `revoked`).

## Proposed mod.io Tag Category Schema

### Launch principle

Keep mod.io tags small, legible, and durable. mod.io should expose the few browse filters that athletes actually use when deciding whether to try a workout package, while AeroBeat-owned systems continue to carry richer structured metadata, trust state, and numeric filtering. The launch taxonomy should therefore prefer **coarse stable discovery dimensions** over detailed authored/package internals.

### 1. `feature`

- **Example tag values:** `boxing`, `flow`
- **Selection model:** single-select
- **Visibility:** public
- **Control model:** normal editable / normal usable
- **Rationale:** This is the clearest top-level browse axis and is already a first-class normalized discovery field in the docs (`workout_features`). A workout package should present one dominant gameplay feature to storefront browsing even if the package contains multiple sets internally. For launch, the cleanest rule is: assign the tag for the package's primary advertised feature. If AeroBeat later decides mixed-feature packages need explicit storefront expression, that should be a deliberate future change rather than a launch-time taxonomy complication.

### 2. `difficulty`

- **Example tag values:** `easy`, `normal`, `hard`, `pro`
- **Selection model:** single-select
- **Visibility:** public
- **Control model:** normal editable / normal usable
- **Rationale:** Difficulty is one of the most practical athlete-facing filters and already maps cleanly to the discovery-layer docs (`workout_difficulties`). It should stay a tight controlled vocabulary. Single-select keeps the storefront understandable and avoids packages spraying multiple difficulty labels. If a package contains mixed chart difficulties, the launch rule should still force one displayed package difficulty based on the intended overall workout challenge or merchandising choice.

### 3. `genre`

- **Example tag values:** `electronic`, `hip_hop`, `rock`, `pop`, `latin`, `ambient`
- **Selection model:** multi-select
- **Visibility:** public
- **Control model:** normal editable / normal usable
- **Rationale:** Music genre is a high-value discovery vector and already exists as a derived union field in the docs (`workout_genres`). Unlike feature and difficulty, genre legitimately benefits from multi-select because a workout package may mix songs across adjacent styles. The vocabulary should stay aligned to the controlled genre enum already used by AeroBeat package/song metadata rather than inventing mod.io-only genres.

### 4. `trust_state`

- **Example tag values:** `pending_review`, `approved`, `featured`, `quarantined`, `revoked`
- **Selection model:** single-select
- **Visibility:** admin-hidden
- **Control model:** admin-only editable / admin-only usable
- **Rationale:** AeroBeat's UGC architecture keeps trust, approval, quarantine, and runtime allow/deny authority first-party even when mod.io is the outer shell. A hidden control bucket is therefore still useful on the provider side for operational mirroring, review queues, and curation state. This should not be a public creator-authored taxonomy. Keeping it single-select prevents contradictory moderation states.

## Dimensions that should stay out of mod.io tags at launch

### Keep out entirely

- **Duration / workout length**
  - Important for discovery, but better represented as numeric metadata or derived range filtering from `duration_ms`, not as hand-maintained storefront tags like `10-min`, `20-min`, `45-min` that will proliferate and age badly.
- **Coach roster / named coaches**
  - The coarse concept of "has coaching" matters, but named-coach taxonomy is premature until coach identity is proven as a major browse surface. Coach presence can still be surfaced in AeroBeat-owned metadata/UI without becoming a public mod.io tag category.
- **Coached vs uncoached as a launch tag**
  - Useful conceptually, but not worth spending one of the few launch tag groups unless Derrick explicitly wants coaching as a headline storefront filter. It can stay in AeroBeat-owned metadata first and be promoted later if browse behavior proves it matters.
- **Environment names or themes**
  - Current docs support environment identity inside the package, but not yet a strong stable browse taxonomy for atmosphere. Exact environment ids are too implementation-shaped; freeform mood words would drift quickly.
- **Low-level chart move/beat taxonomy**
  - `jab`, `cross`, `swing_left`, `portal`, `placement`, `direction`, and similar fields are gameplay-authoring detail, not storefront discovery metadata.
- **Input/platform/runtime traits**
  - Camera-first PC framing is a product-level truth for the current slice, not something every package needs to redundantly encode as tags.
- **Provenance/versioning/install state**
  - Schema ids, tool versions, timestamps, package versions, install/cache flags, validation errors, and other operational metadata should never become public storefront tags.
- **Exact ids and package wiring**
  - `workoutId`, `songId`, `chartId`, `setId`, `environmentId`, `coachConfigId`, `coachingOverlayId`, file paths, and similar identifiers stay internal.

### Keep out of public tags, but acceptable as hidden/admin metadata if needed later

- **Licensing/compliance flags** such as `explicit`, copyright-risk, or streamer-safety markers
- **Editorial merchandising flags** such as `new_release_candidate`, `seasonal`, or `workout_of_the_day_candidate`
- **Creator/provenance workflow flags** such as `official_creator`, `internal_test`, or `migration_needed`

Those may matter operationally, but they should only become mod.io categories if AeroBeat later proves it needs them for provider-side workflow. They are not part of the lean launch browse taxonomy.

## Why this schema stays lean and durable

- It mirrors the strongest already-derived browse dimensions in the current docs instead of inventing new storefront semantics.
- It avoids trying to stuff numeric or highly granular authored metadata into tags.
- It preserves room for AeroBeat-owned richer discovery later without forcing a storefront cleanup migration.
- It keeps the public vocabulary understandable for athletes: **what feature is this, how hard is it, what music vibe is it?**
- It gives admins one provider-side control bucket without turning moderation state into public taxonomy.

## Open questions for the follow-up mapping/doc pass

1. **Primary feature rule:** if a package includes both Boxing and Flow sets, should mod.io still force one primary `feature` tag, or should mixed-feature packages get a future explicit solution such as a separate `format` tag or allowing multi-select for `feature` later?
2. **Difficulty normalization:** the current docs use `medium` in example chart YAML while other product docs and economy docs often say `normal` / `pro`. The follow-up mapping doc should lock the canonical public difficulty vocabulary before tooling depends on it.
3. **Genre source of truth:** confirm the exact controlled genre enum that mod.io should mirror so the provider vocabulary does not drift from the package/schema vocabulary.
4. **Coaching promotion threshold:** decide whether coaching stays out of launch mod.io tags entirely or whether Derrick wants a future public `coaching` single-select bucket (`coached`, `uncoached`) once browsing behavior is better understood.

---

### Task 3: Document the mapping between AeroBeat package metadata and mod.io tags

**Bead ID:** `aerobeat-docs-kqqz`  
**SubAgent:** `primary`  
**Role:** `coder`  
**References:** `REF-01` through `REF-05`  
**Prompt:** In `aerobeat-docs`, claim the assigned bead on start. Add or update documentation that explains how AeroBeat package/workout metadata maps to mod.io tag groups, including what belongs in mod.io tags versus what remains internal/local metadata. Keep the mapping explicit so future tooling and uploader work can follow it. Update the plan with exact files/results, commit and push by default, then close the bead.

**Folders Created/Deleted/Modified:**
- docs/
- .plans/

**Files Created/Deleted/Modified:**
- `docs/architecture/modio-tag-mapping.md`
- `docs/architecture/ugc-distribution-strategy.md`
- `mkdocs.yml`
- `.plans/2026-05-05-aerobeat-modio-tag-groups-and-workout-searchability.md`

**Status:** ✅ Complete

**Results:** Added a durable reference doc at `docs/architecture/modio-tag-mapping.md` that turns the launch tag-group proposal into explicit uploader/tooling mapping rules. The new doc defines the four launch categories (`feature`, `difficulty`, `genre`, `trust_state`), identifies the exact AeroBeat source metadata behind each category, explains how package-level tag selection should work when underlying authored content is mixed, and spells out which metadata must stay in authored YAML, local discovery indexes, or first-party operational systems instead of becoming mod.io tags. It also documents the admin-hidden/admin-only `trust_state` concept and preserves the unresolved human lock-in questions around mixed-feature packages, difficulty wording, coaching promotion, environment discoverability, and trust-state mirroring depth. Cross-linked the new doc from `docs/architecture/ugc-distribution-strategy.md` and added it to the docs nav in `mkdocs.yml` so future uploader and catalog-sync work has a stable architecture reference.

---

## Final Results

**Status:** ✅ Complete

**What We Built:** Added a new architecture reference doc at `docs/architecture/modio-tag-mapping.md` that documents how AeroBeat package/discovery metadata should map into the proposed launch mod.io taxonomy. The final docs set now clearly separates athlete-facing public tags from internal/local/first-party-only metadata and gives future uploader/sync tooling a stable mapping target.

**Reference Check:** `REF-01` through `REF-05` satisfied for this docs slice. The final mapping aligns with the existing workout/discovery contract (`feature`, `difficulty`, `genre`, `duration_ms`, coaching, environments), preserves the first-party trust boundary established by the UGC strategy docs, and records the remaining decisions that still need human lock-in instead of pretending they are settled.

**Commits:**
- `bb88c17` - Document AeroBeat mod.io tag mapping

**Lessons Learned:** The durable handoff point for mod.io work is not the earlier proposal prose alone; future tooling needs an explicit mapping document that states both the positive mapping rules and the intentional non-mappings so provider taxonomy does not drift into a mirror of every authored field.

---

*Completed on 2026-05-05*