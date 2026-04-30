# AeroBeat Asset V1 Contract Rollout

**Date:** 2026-04-30  
**Status:** In Progress  
**Agent:** Chip 🐱‍💻

---

## Goal

Lock the first intentional AeroBeat Asset v1 YAML contract, then roll the approved asset contract into `aerobeat-docs` and `aerobeat-tool-content-authoring` so docs, examples, and validation all enforce the same rules.

---

## Overview

The Environment v1 slice is now fully locked across both repos. That gives us a cleaner package model boundary for the next move: Asset v1. We already did the first research pass earlier today and came away with a strong proposed shape: a small typed asset record, a closed type enum, and the rule that composition constraints like “at most one asset per type in a Set” belong in Set/package validation rather than inside each asset record.

The remaining work is to convert that research into a human-approved contract decision and then execute the normal docs/tooling rollout. Derrick has now made that naming decision explicitly: Asset v1 should normalize the record field from legacy `assetType` to `type`, keep the enum values stable, and keep `metadata` / `tags` out of the durable v1 contract unless they are explicitly promoted later.

### Session Resume — 2026-04-30 (Asset v1 approved for execution)

Derrick approved immediate execution of the Asset v1 slice and explicitly chose the normalized field name:

- use `type`, not `assetType`
- keep the existing closed enum values
- proceed with docs/examples rollout and validator/tooling rollout now

That means the contract-approval step is resolved and the next work is implementation + QA + audit across both repos.

As with Environment v1, this should stay truthful and narrow. The contract should define the durable record shape and the composition/validation rules we can honestly enforce now. It should not smuggle in runtime rendering semantics, athlete preference overrides, marketplace decoration, or future advanced asset families.

---

## REFERENCES

| ID | Description | Path |
| --- | --- | --- |
| `REF-01` | Environment/asset contract review plan with asset research findings | `projects/aerobeat/aerobeat-docs/.plans/2026-04-30-aerobeat-environment-and-asset-yaml-contract-review.md` |
| `REF-02` | Canonical content model | `projects/aerobeat/aerobeat-docs/docs/architecture/content-model.md` |
| `REF-03` | Package storage/discovery contract | `projects/aerobeat/aerobeat-docs/docs/architecture/workout-package-storage-and-discovery.md` |
| `REF-04` | Demo package walkthrough | `projects/aerobeat/aerobeat-docs/docs/guides/demo_workout_package.md` |
| `REF-05` | Demo package overview | `projects/aerobeat/aerobeat-docs/docs/examples/workout-packages/overview.md` |
| `REF-06` | Demo package asset examples | `projects/aerobeat/aerobeat-docs/docs/examples/workout-packages/demo-neon-boxing-bootcamp/assets/` |
| `REF-07` | Current authoring-tool responsibilities plan | `projects/aerobeat/aerobeat-tool-content-authoring/.plans/2026-04-25-aerobeat-tool-content-authoring-responsibilities.md` |
| `REF-08` | Package-validation CLI slice plan | `projects/aerobeat/aerobeat-tool-content-authoring/.plans/archive/2026-04-30-aerobeat-package-validation-cli-slice.md` |
| `REF-09` | Environment v1 validator rollout plan (for rollout pattern parity) | `projects/aerobeat/aerobeat-tool-content-authoring/.plans/2026-04-30-aerobeat-environment-v1-validator-rollout.md` |

---

## Tasks

### Task 1: Turn the existing asset research into a concrete Derrick-facing Asset v1 approval proposal

**Bead ID:** `Pending`  
**SubAgent:** `primary` (for `research`)  
**Role:** `research`  
**References:** `REF-01` through `REF-06`  
**Prompt:** Convert the completed asset research into a concrete approval proposal: exact Asset v1 YAML shape, exact enum, whether the field should be `type` or `assetType`, what remains outside the contract, and which rules belong in record validation versus Set/package validation.

**Folders Created/Deleted/Modified:**
- `.plans/`

**Files Created/Deleted/Modified:**
- This plan file

**Status:** ✅ Complete

**Results:** Derrick approved the narrow Asset v1 contract: normalize the record field to `type`, keep the closed gameplay-facing enum at `gloves` / `targets` / `obstacles` / `trails`, keep Set composition rules in set/package validation, and leave `metadata` / `tags` out of the canonical v1 contract.

---

### Task 2: Human approval of the Asset v1 contract

**Bead ID:** `Pending`  
**SubAgent:** `primary` (for `research`)  
**Role:** `research`  
**References:** `REF-01` through `REF-09`  
**Prompt:** Present the Asset v1 proposal for explicit approval before any docs/examples/validator execution starts.

**Folders Created/Deleted/Modified:**
- `.plans/`

**Files Created/Deleted/Modified:**
- This plan file

**Status:** ✅ Complete

**Results:** Approval is recorded in the session notes captured above and is now reflected in the docs rollout scope for Task 3.

---

### Task 3: Roll the approved Asset v1 contract into `aerobeat-docs`

**Bead ID:** `Pending`  
**SubAgent:** `primary` (for `coder` / `qa` / `auditor`)  
**Role:** `coder` / `qa` / `auditor`  
**References:** `REF-01` through `REF-06` plus the approved Asset v1 proposal  
**Prompt:** After approval, update the docs repo to teach Asset v1 consistently, refresh the checked-in demo asset YAMLs and package references, and run the full coder → QA → auditor loop.

**Folders Created/Deleted/Modified:**
- `docs/architecture/`
- `docs/guides/`
- `docs/examples/workout-packages/`
- `.plans/`

**Files Created/Deleted/Modified:**
- implementation scope only

**Status:** ✅ Complete

**Results:** Updated the docs surfaces that actively taught Asset v1 so they now consistently use `type` rather than `assetType`, describe the small canonical asset record shape, and state the Set composition rule as “multiple assets allowed, but at most one per asset type in a Set.” Refreshed the four checked-in demo asset YAML files to the locked v1 shape (`assetId`, `assetName`, `type`, `resourcePath` plus shared schema/provenance), removed canonical `metadata` / `tags` teaching from those examples, and updated the demo package walkthrough/overview/glossary/index references to match. Validation run: `python3 scripts/create_placeholders.py && .venv/bin/mkdocs build --strict` (pass). Commit: `8589503`.

---

### Task 4: Roll the approved Asset v1 contract into `aerobeat-tool-content-authoring`

**Bead ID:** `Pending`  
**SubAgent:** `primary` (for `coder` / `qa` / `auditor`)  
**Role:** `coder` / `qa` / `auditor`  
**References:** `REF-01`, `REF-07`, `REF-08`, `REF-09` plus the approved Asset v1 proposal  
**Prompt:** After docs approval/rollout, update the validator/tooling repo so docs/help text and package validation enforce the approved Asset v1 contract and the Set/package asset-composition rules truthfully.

**Folders Created/Deleted/Modified:**
- `docs/`
- `services/validation/`
- `tests/`
- `.plans/`

**Files Created/Deleted/Modified:**
- implementation scope only

**Status:** ⏳ Pending

**Results:** Blocked on approval and docs rollout.

---

## Final Results

**Status:** ⚠️ Partial

**What We Built:** Completed the `aerobeat-docs` Asset v1 rollout slice: canonical docs now teach the locked small asset record (`assetId`, `assetName`, `type`, `resourcePath`), the exact four-value enum, and the Set/package composition rule; the checked-in demo asset YAMLs and package walkthrough now match that contract; and canonical example-only `metadata` / `tags` teaching was removed from the active asset examples.

**Reference Check:** Task 3 now aligns the active docs/example surfaces with the approved contract direction documented from `REF-01` through `REF-06`: `type` replaced legacy `assetType`, the closed enum stayed at four gameplay-facing values, the Set composition rule is explicit, and runtime/marketplace/override scope stayed out of the v1 docs contract.

**Commits:**
- `8589503` - Lock Asset v1 docs and example package teaching

**Lessons Learned:** Environment went smoothly because we forced the contract, examples, and validator to line up around a small truthful surface. Asset v1 should follow the same pattern instead of letting legacy field names or example-only metadata silently harden into policy.

---

*Drafted on 2026-04-30*