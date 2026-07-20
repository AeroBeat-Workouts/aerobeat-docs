# AeroBeat mod.io Tag Mapping

This document defines how AeroBeat discovery metadata should map into the proposed **launch-time mod.io tag categories** for the current **song-package** direction.

The goal is to keep mod.io tags useful for athlete-facing discovery without turning them into a duplicate of every authored field or every local index column. AeroBeat keeps the richer package contract, validation pipeline, and trust boundary first-party; mod.io only gets a lean public taxonomy plus one hidden operational control bucket.

## Current contract reminder

Before applying any tag mapping, keep the current content contract straight:

- the canonical imported package root is **`song-package.yaml`**, not `workout.yaml`
- one song package may contain **multiple chart/set difficulty slices** under one song root
- future multi-song grouping should use **playlist** language, not workout-package language
- coaching and environments are **outside the default imported song-package contract**
- authored chart difficulty labels now use BeatSaver-style vocabulary:
  - `Easy`
  - `Normal`
  - `Hard`
  - `Expert`
  - `ExpertPlus`

If another doc or older tool draft still says `easy|medium|hard|pro` or treats `workout.yaml` as the package root, that older wording is historical and not current truth.

## Launch tag categories

AeroBeat should launch with **four** mod.io tag categories:

1. `feature`
2. `difficulty`
3. `genre`
4. `trust_state`

The first three are public browse filters. `trust_state` is an admin-hidden/admin-only operational category.

## Mapping summary

| mod.io category | Select mode | Visibility / control | AeroBeat source | Mapping rule |
| --- | --- | --- | --- | --- |
| `feature` | single-select | public / normal editable and usable | Authored chart `feature`; derived discovery summary | Assign the package's primary advertised gameplay feature. |
| `difficulty` | single-select | public / normal editable and usable | Authored chart `difficulty`; derived discovery summary | Assign one package-level difficulty tag representing the intended overall challenge. |
| `genre` | multi-select | public / normal editable and usable | Authored song `metadata.genres`; derived discovery summary | Copy the controlled genre union for songs referenced by the package. |
| `trust_state` | single-select | admin-hidden / admin-only editable and usable | AeroBeat first-party review, moderation, approval, and quarantine state | Mirror one operational trust state for provider-side workflow; not creator-authored package metadata. |

## Public discovery categories

### `feature`

**Source metadata**
- Authored `feature` on referenced chart records.
- Derived discovery summary for the package catalog row.

**Launch values**
- `boxing`
- `flow`

**Mapping rule**
- A package gets **one** public feature tag.
- If all referenced charts point at the same feature, copy that feature.
- If the package mixes features, assign the package's **primary advertised feature** instead of spraying multiple public feature tags.

### `difficulty`

**Source metadata**
- Authored `difficulty` on referenced chart records.
- Derived discovery summary for the package catalog row.

**Current authored/discovery vocabulary**
- `Easy`
- `Normal`
- `Hard`
- `Expert`
- `ExpertPlus`

**Mapping rule**
- A package gets **one** public difficulty tag.
- If all referenced charts share the same difficulty, copy that difficulty.
- If the package mixes chart difficulties, choose the **intended package-level challenge** rather than exposing every referenced chart difficulty as separate public tags.

**Why this belongs in mod.io**
- Difficulty is one of the most practical athlete-facing browse filters.
- It is already modeled as a discovery-layer summary field, not just buried in authored YAML.

**Normalization note**
- Older docs and fixtures used the superseded vocabulary `easy|medium|hard|pro`.
- That is no longer the contract-aligned source vocabulary.
- New uploader/tagging work should treat **`Easy|Normal|Hard|Expert|ExpertPlus`** as the authoritative authored source vocabulary.

### `genre`

**Source metadata**
- Authored song `metadata.genres` on referenced song records.
- Derived discovery summary for the package catalog row.

**Current controlled vocabulary**
- `pop`
- `rock`
- `hip_hop`
- `r_and_b`
- `edm`
- `country`
- `latin`
- `jazz`
- `blues`
- `funk`
- `soul`
- `reggae`
- `folk`
- `classical`
- `metal`
- `punk`
- `world`
- `soundtrack`
- `holiday`
- `game`
- `chiptune`
- `anime`

**Mapping rule**
- `genre` is the only launch category that should be **multi-select**.
- Copy the union of approved authored song genres for all songs referenced by the package.
- Do **not** invent storefront-only genre names.
- Do **not** promote freeform descriptive mood words into this category.

## Admin-hidden operational category

### `trust_state`

**Source metadata**
- Not an authored package YAML field.
- Comes from AeroBeat-controlled validation, review, moderation, curation, approval, or quarantine state.

**Example launch values**
- `pending_review`
- `approved`
- `featured`
- `quarantined`
- `revoked`

**Mapping rule**
- `trust_state` is **single-select**.
- It should be configured as **admin-hidden** and **admin-only editable/usable**.
- Creators should not set it in package metadata.
- Provider-side tooling may mirror AeroBeat's internal state here to support moderation dashboards, review queues, or catalog sync workflows.

## Metadata that should stay out of mod.io tags

These fields can still matter to AeroBeat, but they should remain in authored YAML, local discovery indexes, or first-party backend metadata instead of becoming launch-time mod.io tags.

### Keep as structured internal or local discovery metadata

- `duration_ms` on packages and songs
  - Important for browsing, but better handled as numeric sort/range/filter data than storefront tags like `10-min` or `45-min`.
- coaching metadata
  - Coaching is not part of the default imported song-package contract.
- environment ids/themes
  - Environment choice is outside the default imported song-package contract.
- local freeform/index helper fields such as temporary browse notes
  - These can support local discovery experiments without automatically becoming mod.io-visible categories.

### Keep as authored/package truth only

- ids and wiring fields such as `songPackageId`, `songId`, `chartId`, `setId`
- schema/provenance/versioning fields such as `schemaId`, `schemaVersion`, `recordVersion`, `packageVersion`, `createdByTool`, `createdByToolVersion`, and timestamps
- media paths and package layout details
- exact credits and publisher fields unless AeroBeat later adds first-class creator/artist browse surfaces
- low-level chart move taxonomy such as `placement`, `direction`, or BeatSaver-derived conversion details

### Keep as first-party operational metadata

- local install/index/cache state such as package-root paths, install timestamps, index timestamps, validity, or validation errors
- remote catalog presentation helpers such as `preview_image_strategy` and `preview_image_url`
- licensing/compliance flags such as `explicit`, `streamingSafe`, `aiAssisted`, or copyright-risk workflow labels
- editorial or moderation workflow labels beyond the one mirrored `trust_state` bucket

## Mapping guidance for future uploader/tooling work

When uploader or sync tooling prepares a mod.io package/tag payload, it should follow this order:

1. Read the authored package YAML and derive the same normalized discovery summaries AeroBeat already expects locally.
2. Populate public mod.io tags from **only** `feature`, `difficulty`, and `genre`.
3. If AeroBeat review/moderation systems need provider-side mirroring, populate hidden/admin-only `trust_state` separately from creator-authored package data.
4. Do not leak package internals, install state, or first-party-only metadata into public mod.io categories.
5. Prefer controlled vocabularies already locked in AeroBeat docs/schema over provider-specific ad hoc naming.

## Open questions that still need human lock-in

1. **Mixed-feature packages:** should launch tooling always force one primary `feature` tag, or should mixed-feature packages eventually get a dedicated representation?
2. **Difficulty storefront wording:** should public mod.io copy mirror the authored vocabulary exactly, or should AeroBeat present alternate athlete-facing copy while keeping authored/internal vocabulary stable?
3. **Coaching promotion threshold:** should a future release add a public `coaching` category such as `coached` / `uncoached`, or should coaching remain first-party metadata only?
4. **Environment discoverability:** does AeroBeat eventually want a stable athlete-facing atmosphere taxonomy, or should environment data remain outside the imported song-package lane?
5. **Trust-state mirroring depth:** which first-party moderation/approval states actually need provider-side mirrored tags versus staying entirely in AeroBeat-owned systems?

## Related docs

- [UGC Distribution Strategy](ugc-distribution-strategy.md)
- [Content Repo Shapes](content-repo-shapes.md)
- [Workout Package Storage and Discovery (Historical)](workout-package-storage-and-discovery.md)
- [Content Model](content-model.md)
