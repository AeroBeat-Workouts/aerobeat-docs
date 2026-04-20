# AeroBeat GodotEnv Phase 1 Execution Packet

!!! note "Transition note"
    This execution packet was authored during the rename and topology split. Where it still says `aerobeat-core`, read that as the transition-era name for today's `aerobeat-input-core`; the current live architecture is the six-core model documented elsewhere in this repo.

_Date: 2026-04-17_
_Status: Phase 0 implementation packet for Phase 1_

## Purpose

This packet translates the approved Phase 0 decisions into the first implementation wave.

Phase 1 is intentionally narrow. It establishes the foundational contract and release discipline in the three repos every downstream migration depends on:

1. `aerobeat-core`
2. `aerobeat-ui-core`
3. `aerobeat-ui-kit-community`

Once Phase 0 is approved/landed, this packet is considered pre-authorized work. Later phases do not need fresh architectural approval unless they discover a conflict with the Phase 0 contract.

---

## 1. Phase 1 objective

Normalize the foundational repo chain so downstream repos can stop guessing how GodotEnv should work.

At the end of Phase 1, AeroBeat should have:

- a real first-party `addons.jsonc` convention implemented in foundation repos
- `.testbed/addons.jsonc` established as the package/foundation dev harness contract
- the first real first-party release tags for the foundation chain
- `aerobeat-ui-kit-community` consuming the normalized core/UI core contract
- obsolete setup flow removed from the UI kit repo

Phase 1 does **not** migrate the whole family. It creates the stable base every later repo wave depends on.

---

## 2. Scope

## In scope

- `aerobeat-core`
- `aerobeat-ui-core`
- `aerobeat-ui-kit-community`
- repo-local docs/README changes required to explain the new dependency flow in those repos
- release/tag policy implementation for those repos

## Out of scope

- assembly repo migration
- UI shell migration
- template repo sweep
- broad feature/input/tool migration
- final family closeout audit

Those belong to later phases, but this packet sets them up.

---

## 3. Readiness criteria before Phase 1 starts

Phase 1 should not start until all of these are true:

1. **Phase 0 docs are landed or otherwise accepted as the active contract.**
2. **Developers know the canonical manifest locations.**
   - `.testbed/addons.jsonc` for package/foundation repos
   - root `addons.jsonc` for assembly repos
3. **The initial first-party tag format is agreed.**
   - `v0.x.y` during migration
4. **GodotEnv is available in the developer environment(s) that will perform the work.**
5. **Each repo's expected addon identity/subfolder is confirmed.**
   - first-party AeroBeat repos default to repo-root import with `subfolder: "/"`
   - any narrower published subfolder must be documented before tagging anything meant for downstream use
6. **The work is understood as a clean break.**
   - no "keep `setup_dev.py` for now" hedging inside Phase 1

If any readiness item is missing, Phase 1 should pause and fix that first.

---

## 4. Required outcome by repo

## 4.1 `aerobeat-core`

Phase 1 must leave `aerobeat-core` in a state where it is an explicitly releasable foundational addon.

**Required outcomes**

- `.testbed/addons.jsonc` exists and is the only dev/test dependency contract
- `.gitignore` reflects GodotEnv-managed testbed install/cache paths
- repo docs explain the GodotEnv-based dev/test flow directly
- the repo has an initial SemVer-style tag for downstream consumption
- downstream repos can reference it in `tag` mode

**Boundary check**

- must remain the bottom of the first-party dependency stack
- Phase 1 must not introduce feature/UI-shell dependencies into core

## 4.2 `aerobeat-ui-core`

Phase 1 must leave `aerobeat-ui-core` as a releasable UI logic contract on top of core.

**Required outcomes**

- `.testbed/addons.jsonc` exists and expresses its dev/test dependency story
- any dependency on `aerobeat-core` is represented via the new manifest contract
- `.gitignore` reflects GodotEnv-managed testbed install/cache paths
- repo docs explain the new flow directly
- the repo has an initial SemVer-style tag for downstream consumption

**Boundary check**

- must depend on `aerobeat-core` only as needed for contracts
- must not absorb concrete kit visuals or shell-specific layout logic

## 4.3 `aerobeat-ui-kit-community`

Phase 1 must leave `aerobeat-ui-kit-community` as the first real consumer of the normalized foundation chain.

**Required outcomes**

- `.testbed/addons.jsonc` exists and declares required dev/test deps
- the repo no longer relies on `setup_dev.py`
- `.gitignore` reflects GodotEnv-managed testbed install/cache paths
- repo docs explain the new flow directly
- the repo is tagged for downstream shell consumption

**Boundary check**

- must remain a kit, not a shell
- must depend on `aerobeat-ui-core` as the logic base
- must not reintroduce a second sync mechanism

## 4.4 Shared Phase 1 install hygiene rule

Every Phase 1 first-party repo must satisfy the same GodotEnv consumption rule before QA/audit handoff:

- downstream GodotEnv consumers intentionally import the repo from repo root unless that repo documents an exception
- dot-prefixed folders inside that repo-root payload are acceptable because Godot hides them
- installed addons are immutable/disposable payloads, not a place for durable manual edits
- any required Godot-generated `.uid` files are committed before cutting a release tag intended for GodotEnv consumption

---

## 5. Recommended sequencing

Phase 1 should execute in dependency order, not alphabetically.

## Step 1 — Normalize `aerobeat-core`

Do this first because everything else depends on it conceptually or directly.

**Why first**

- it is the lowest-level contract repo
- later tags in `ui-core` and `ui-kit-community` depend on knowing how core is packaged and versioned

## Step 2 — Normalize `aerobeat-ui-core`

Do this second because `aerobeat-ui-kit-community` should consume the normalized UI logic contract, not a moving target.

**Why second**

- it establishes the UI-facing foundational layer
- it clarifies the dependency edge from kits to UI logic

## Step 3 — Normalize `aerobeat-ui-kit-community`

Do this third because it proves the foundational chain is usable by a real downstream consumer.

**Why third**

- it is the first practical integration proof of the new convention
- it removes a real `setup_dev.py` from the critical path
- it creates the release surface shells will later pin to

---

## 6. Suggested bead breakdown

Use repo-local Beads in each owning repo for implementation, QA, and audit. The titles below are the suggested minimum breakdown; exact IDs can be created during execution.

## 6.1 `aerobeat-core`

1. **Define core package layout and testbed manifest**
   - add `.testbed/addons.jsonc`
   - update ignore rules
   - document dev/test flow
2. **Validate core repo as a releasable foundational addon**
   - run repo-local validation/test path
   - verify clean-clone GodotEnv restore
3. **Cut initial core release tag**
   - create first SemVer-style tag for downstream use

## 6.2 `aerobeat-ui-core`

1. **Define UI core manifest and dependency on core**
   - add `.testbed/addons.jsonc`
   - encode any required core dependency explicitly
   - update ignore rules/docs
2. **Validate UI core contract shape**
   - run repo-local validation/test path
   - verify no kit/shell logic has leaked in
3. **Cut initial UI core release tag**
   - create first SemVer-style tag for downstream use

## 6.3 `aerobeat-ui-kit-community`

1. **Replace setup script with manifest-driven testbed flow**
   - add `.testbed/addons.jsonc`
   - remove `setup_dev.py`
   - update ignore rules/docs
2. **Validate UI kit against tagged foundations**
   - confirm it installs/works against tagged core and UI core releases
3. **Cut initial UI kit release tag**
   - create first SemVer-style tag for shell consumption

## 6.4 Cross-repo audit bead

After the three repo-specific waves, create one cross-repo truth-check bead to confirm:

- tag names line up with committed manifests
- first-party repos are intentionally consumed from repo root unless a documented exception says otherwise
- dot-prefixed folders in repo-root payloads are not being misclassified as package-shape failures
- required `.uid` files ship in tagged first-party source so installed addons stay clean after editor open
- docs match the implemented flow
- `aerobeat-ui-kit-community` really consumes the normalized foundation chain

---

## 7. Per-repo completion checklist

Every foundational repo in Phase 1 should clear this checklist before it is considered done.

## 7.1 Structure

- [ ] canonical manifest exists in the correct location
- [ ] legacy dependency bootstrap script is gone where applicable
- [ ] ignore rules match GodotEnv-managed install/cache locations

## 7.2 Documentation

- [ ] README or repo-local docs point directly to GodotEnv
- [ ] no surviving instruction tells contributors to use the old flow

## 7.3 Validation

- [ ] clean-clone dependency restore works
- [ ] repo-local validation/test path works after restore
- [ ] no tracked-file mutation is required after install because required first-party `.uid` files already ship in source
- [ ] installed addons are treated as immutable/disposable payloads; fixes land in source repos, not installed copies

## 7.4 Release

- [ ] repo has a SemVer-style release tag
- [ ] downstream consumers can reference that tag in `checkout`
- [ ] the release tag ships the intended repo-root payload (unless a documented exception says otherwise) with required `.uid` files already committed

---

## 8. Risks and handling

## 8.1 No tag habit exists yet

**Risk:** the family has not been operating on release tags.

**Handling:** make "cut the first real tag" part of Phase 1, not a later nicety.

## 8.2 `aerobeat-ui-core` package shape may be less normalized than the others

**Risk:** UI core may need more explicit package-shape cleanup before it behaves like a clean addon dependency.

**Handling:** keep the Phase 1 scope focused on manifest/release normalization, not on broad redesign.

## 8.3 UI kit could try to preserve `setup_dev.py` for convenience

**Risk:** partial migration that keeps the old script around.

**Handling:** reject it. Phase 1 is explicitly clean-break work for the targeted repos.

---

## 9. Exit criteria for Phase 1

Phase 1 is complete only when all of the following are true:

1. `aerobeat-core` is normalized and tagged
2. `aerobeat-ui-core` is normalized and tagged
3. `aerobeat-ui-kit-community` is normalized, no longer depends on `setup_dev.py`, and is tagged
4. repo docs in those three repos describe the GodotEnv flow directly
5. at least one audit pass confirms the three-repo chain matches the Phase 0 contract

---

## 10. Explicit closeout rule for the overall migration

Phase 1 does **not** satisfy final migration closeout on its own.

The overall GodotEnv migration is not complete until AeroBeat performs and records a **full-family re-audit** after later phases finish.

That final re-audit must verify at minimum:

- no first-party repo still relies on legacy dependency bootstrap artifacts
- manifest placement rules match the Phase 0 contract across the repo family
- foundational repos are being consumed via the intended tag/branch/symlink rules
- assembly repos use root `addons.jsonc`
- package and UI shell repos use `.testbed/addons.jsonc`
- templates/docs/CI no longer regenerate or teach the obsolete workflow

**Closeout rule:** no parent migration bead, epic, or plan may be marked fully complete until that final family-wide re-audit is done.

---

## Final decision summary

- Phase 1 is the foundation wave: `aerobeat-core` -> `aerobeat-ui-core` -> `aerobeat-ui-kit-community`.
- The goal is not broad migration; it is stable contract and tag discipline.
- Each repo must end with the canonical manifest, updated ignore/docs, clean validation, and a real release tag.
- `aerobeat-ui-kit-community` is the proof that the normalized foundation chain is actually consumable.
- The overall migration still closes only after a later full-family re-audit.
