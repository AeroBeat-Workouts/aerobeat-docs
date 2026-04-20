# AeroBeat Godot Version Audit

!!! note "Historical naming note"
    This audit records filesystem paths exactly as they existed on 2026-04-18. Any `aerobeat-core` path in the findings refers to the repo that is now named `aerobeat-input-core`.

_Date: 2026-04-18_

## Scope

Audit of explicit Godot version references across AeroBeat repos under:

- `/home/derrick/.openclaw/workspace/projects/aerobeat`

Comparison baseline from `/home/derrick/.openclaw/.env`:

- `GODOT_VERSION=4.6.2`
- `GODOT_RELEASE_FLAVOR=stable`
- `GODOT_FLAVOR=standard`

## Executive summary

AeroBeat is **not yet normalized** to the pinned OpenClaw Godot toolchain.

The main mismatch is not subtle:

- **31 product repos** still declare `config/features=PackedStringArray("4.2", ...)` in their primary Godot project file.
- **3 product repos** already declare `4.6` in their primary Godot project file, which is aligned to the pinned **major/minor** engine family but still does **not** encode the full OpenClaw patch pin `4.6.2`.
- In `aerobeat-docs`, the **template source files** still stamp new repos with `4.2`, so regeneration would reintroduce drift even after repo fixes.
- Several human-facing docs and helper scripts still say **"Godot 4.6"** rather than the exact pinned runtime **`4.6.2-stable-standard`**.

## Important normalization rule

The audit found two different kinds of version references:

1. **Project-format engine feature markers** in `project.godot`
   - Current AeroBeat files use values like `"4.2"` and `"4.6"` in `config/features`.
   - Based on the tracked files in this repo family, the safe normalization target here is **`4.6`**, not `4.6.2`.

2. **Human-facing / tooling references** in docs, helper scripts, and setup guidance
   - These can and should reference the exact pinned toolchain: **Godot `4.6.2 stable standard`**.

So the safe target is:

- `project.godot` feature markers → **`4.6`**
- docs/tooling/policy text → **`4.6.2 stable standard`** (or "pinned OpenClaw Godot 4.6.2 stable standard")

## Repo-by-repo mismatch inventory

### A. Operationally important project-file mismatches: `4.2` → should become `4.6`

These are the most important mismatches because they affect the repo-local Godot project metadata used for day-to-day opening, import, and migration work.

#### Product repos

- `aerobeat-asset-prototypes` — `.testbed/project.godot`
- `aerobeat-feature-boxing` — `.testbed/project.godot`
- `aerobeat-feature-dance` — `.testbed/project.godot`
- `aerobeat-feature-flow` — `.testbed/project.godot`
- `aerobeat-feature-step` — `.testbed/project.godot`
- `aerobeat-input-gamepad` — `.testbed/project.godot`
- `aerobeat-input-joycon-hid` — `.testbed/project.godot`
- `aerobeat-input-keyboard` — `.testbed/project.godot`
- `aerobeat-input-mediapipe-native` — `.testbed/project.godot`
- `aerobeat-input-mouse` — `.testbed/project.godot`
- `aerobeat-input-touch` — `.testbed/project.godot`
- `aerobeat-input-xr` — `.testbed/project.godot`
- `aerobeat-template-assembly` — `project.godot`
- `aerobeat-template-asset` — `.testbed/project.godot`
- `aerobeat-template-avatar` — `.testbed/project.godot`
- `aerobeat-template-cosmetic` — `.testbed/project.godot`
- `aerobeat-template-environment` — `.testbed/project.godot`
- `aerobeat-template-feature` — `.testbed/project.godot`
- `aerobeat-template-input` — `.testbed/project.godot`
- `aerobeat-template-skin` — `.testbed/project.godot`
- `aerobeat-template-tool` — `.testbed/project.godot`
- `aerobeat-template-ui-kit` — `.testbed/project.godot`
- `aerobeat-template-ui-shell` — `.testbed/project.godot`
- `aerobeat-tool-api` — `.testbed/project.godot`
- `aerobeat-tool-settings` — `.testbed/project.godot`
- `aerobeat-ui-core` — `.testbed/project.godot`
- `aerobeat-ui-kit-community` — `.testbed/project.godot`
- `aerobeat-ui-shell-desktop-community` — `.testbed/project.godot`
- `aerobeat-ui-shell-mobile-community` — `.testbed/project.godot`
- `aerobeat-ui-shell-web-community` — `.testbed/project.godot`
- `aerobeat-ui-shell-xr-community` — `.testbed/project.godot`

#### Template sources in `aerobeat-docs`

These are not standalone product repos, but they are operationally important because they generate future repos and can reintroduce `4.2` drift.

- `aerobeat-docs/templates/assembly/project.godot`
- `aerobeat-docs/templates/asset/.testbed/project.godot`
- `aerobeat-docs/templates/avatars/.testbed/project.godot`
- `aerobeat-docs/templates/cosmetics/.testbed/project.godot`
- `aerobeat-docs/templates/environments/.testbed/project.godot`
- `aerobeat-docs/templates/feature/.testbed/project.godot`
- `aerobeat-docs/templates/input/.testbed/project.godot`
- `aerobeat-docs/templates/skins/.testbed/project.godot`
- `aerobeat-docs/templates/tool/.testbed/project.godot`
- `aerobeat-docs/templates/ui-kit/.testbed/project.godot`
- `aerobeat-docs/templates/ui-shell/.testbed/project.godot`

### B. Partially aligned project files: already `4.6`, but not documented as the exact pin

These files already match the pinned major/minor family and should probably stay at `4.6` if the team keeps using `config/features` as a major/minor marker.

- `aerobeat-assembly-community/project.godot`
- `aerobeat-core/.testbed/project.godot`
- `aerobeat-input-mediapipe-python/.testbed/project.godot`

These are **not urgent format mismatches** unless the team explicitly decides to encode patch-level engine data somewhere else.

### C. Human-facing / tooling references that should point to the exact pin `4.6.2 stable standard`

#### `aerobeat-assembly-community`

Operationally relevant helper text still says only `4.6`:

- `aerobeat-assembly-community/setup_dev.py`
  - `print("1. Open this project in Godot 4.6")`
- `aerobeat-assembly-community/build-scripts/build-macos-bundle.sh`
  - `echo "Please install Godot 4.6 and add it to PATH"`
- `aerobeat-assembly-community/build-scripts/build-windows-bundle.sh`
  - `echo "Please install Godot 4.6 and add it to PATH"`
- `aerobeat-assembly-community/INVESTIGATION-build-distribution.md`
  - `- Godot 4.6 game executable`

#### `aerobeat-docs`

- `aerobeat-docs/docs/architecture/coding-style.md`
  - `Target Engine: Godot 4.6`

This is the cleanest cross-repo place to declare the exact pin and the `project.godot` major/minor exception together.

#### `aerobeat-input-mediapipe-python`

This repo has multiple repo-local plan/research docs that still say `Godot 4.6` rather than the exact pinned patch version. The most operationally relevant ones found during the audit were:

- `aerobeat-input-mediapipe-python/.plans/mediapipe-python/02-PHASE-1-Godot-Upgrade.md`
- `aerobeat-input-mediapipe-python/.plans/mediapipe-python/06-PHASE-5-Integration-Tests.md`
- `aerobeat-input-mediapipe-python/.plans/mediapipe-python/WINDOWS_OPTIMIZATIONS.md`
- `aerobeat-input-mediapipe-python/.plans/mediapipe-python/MACOS_OPTIMIZATIONS.md`
- `aerobeat-input-mediapipe-python/.plans/mediapipe-python/OPTIMIZATION_EXPERT_REVIEW.md`
- `aerobeat-input-mediapipe-python/.plans/gamepad/PLAN-GAMEPAD.md`
- `aerobeat-input-mediapipe-python/.plans/keyboard/PLAN-KEYBOARD.md`
- `aerobeat-input-mediapipe-python/.plans/mouse/PLAN-MOUSE.md`

These are lower priority than the `project.godot` files and template sources, but they are real drift.

## References that were deliberately not treated as normalization targets

### Vendored / embedded third-party GUT content

The audit found many Godot-version references under vendored GUT trees inside:

- `aerobeat-core/.testbed/.addons/gut/...`
- `aerobeat-core/.testbed/addons/gut/...`
- `aerobeat-ui-core/.testbed/.addons/gut/...`
- `aerobeat-ui-core/.testbed/addons/gut/...`
- `aerobeat-ui-kit-community/.testbed/.addons/gut/...`
- `aerobeat-ui-kit-community/.testbed/addons/gut/...`

Those references describe GUT's own compatibility matrix and release history. They are not an AeroBeat repo-policy source of truth and should not be mass-edited as part of this normalization wave.

### Ephemeral local editor metadata

The audit also found local machine metadata such as:

- `aerobeat-core/.testbed/.godot/editor/project_metadata.cfg`
- `aerobeat-ui-core/.testbed/.godot/editor/project_metadata.cfg`
- `aerobeat-ui-kit-community/.testbed/.godot/editor/project_metadata.cfg`

Those already point at a local `4.6.2-stable-standard` install path, but they are editor-generated state rather than repo policy.

## Recommended smallest safe normalization sequence

### Step 1 — Document the policy once in `aerobeat-docs`

Create/maintain one explicit rule:

- OpenClaw-pinned editor/runtime = **`4.6.2 stable standard`**
- `project.godot` `config/features` marker = **`4.6`**

This avoids a second wave of ambiguity about whether `project.godot` should literally contain `4.6.2`.

### Step 2 — Fix the template sources before broad repo edits

Update all 11 template `project.godot` files in `aerobeat-docs/templates/...` from `4.2` to `4.6`.

Reason:

- this prevents new repos or regenerated repos from reintroducing stale `4.2` markers.

### Step 3 — Fix the Phase 2 pilot repo and its immediate path

Update:

- `aerobeat-feature-boxing/.testbed/project.godot` from `4.2` → `4.6`
- `aerobeat-docs/docs/architecture/coding-style.md` from `Godot 4.6` → explicit pinned wording referencing `4.6.2 stable standard`

Reason:

- this satisfies the immediate pilot requirement and keeps the docs next to the active plan accurate.

### Step 4 — Batch-normalize the remaining simple package repos

After the pilot, batch the remaining package-family repos that only need `project.godot` marker updates:

- feature repos
- input repos
- tool repos
- UI repos
- template repos outside `aerobeat-docs`
- asset/supporting repos

This looks like straightforward follow-on bead work, not a research blocker.

### Step 5 — Clean up human-facing helper/script references

Update the remaining explicit text references from `Godot 4.6` to the exact pinned wording where doing so improves operator clarity:

- `aerobeat-assembly-community/setup_dev.py`
- `aerobeat-assembly-community/build-scripts/build-macos-bundle.sh`
- `aerobeat-assembly-community/build-scripts/build-windows-bundle.sh`
- the most active repo-local plan/docs that still say `4.6`

## Suggested new executable work

This audit surfaced clear follow-on execution items that should become beads rather than being hidden in prose:

1. **Template version normalization bead**
   - Update all `aerobeat-docs/templates/.../project.godot` files from `4.2` to `4.6`.

2. **Pilot repo version normalization bead**
   - Update `aerobeat-feature-boxing/.testbed/project.godot` and any pilot-adjacent repo-local references required by the Phase 2 packet.

3. **Family-wide `project.godot` normalization bead**
   - Batch the remaining simple `4.2` → `4.6` repo updates.

4. **Human-facing version text cleanup bead**
   - Normalize helper scripts and active docs to `4.6.2 stable standard` wording.

## Files created/updated by this audit

- Created: `aerobeat-docs/docs/architecture/godot-version-audit-2026-04-18.md`
