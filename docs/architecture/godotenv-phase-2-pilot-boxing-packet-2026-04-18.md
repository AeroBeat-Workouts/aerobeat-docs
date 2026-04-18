# AeroBeat Phase 2 Pilot Packet — `aerobeat-feature-boxing`

_Date: 2026-04-18_
_Status: Execution-ready research packet_

## Purpose

This packet translates the approved GodotEnv migration contract into exact repo-level work for the Phase 2 pilot repo:

- `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-feature-boxing`

It is intentionally concrete so the implementation bead can execute without re-discovering architecture.

---

## Executive summary

`aerobeat-feature-boxing` is still on the old template-era bootstrap flow.

Current state:

- dependency bootstrap is still encoded in `setup_dev.py`
- repo docs still tell contributors to run `python setup_dev.py`
- `.gitignore` still assumes dependencies are managed only by that script
- `.testbed/project.godot` still declares `config/features=PackedStringArray("4.2", ...)`
- CI still assumes recursive submodule checkout, runs Godot `4.2.1`, and does **not** restore dependencies through GodotEnv
- there is **no** committed `.testbed/addons.jsonc`
- the tracked repo does **not** currently contain the template-advertised `src/` folder, so the migration should not invent a fake runtime folder just to mirror the old template prose

Required outcome:

1. make `.testbed/addons.jsonc` the **only** committed dev/test dependency contract
2. remove `setup_dev.py` entirely
3. update repo docs/ignore/CI to match the clean-break GodotEnv flow
4. normalize the testbed project marker from `4.2` to `4.6`
5. make the `.testbed/` Godot project the canonical day-to-day boxing bugfinding surface

This repo is a standard package repo, so it must follow the Phase 0 package convention:

- committed manifest: `.testbed/addons.jsonc`
- installed deps: `.testbed/addons/`
- cache: `.testbed/.addons/`
- no root `addons.jsonc`
- no `setup_dev.py`

---

## Source findings in the pilot repo

### Files present today

Tracked files currently found in the repo:

- `.github/workflows/cla.yml`
- `.github/workflows/gut_ci.yml`
- `.gitignore`
- `LICENSE.md`
- `README.md`
- `plugin.cfg`
- `setup_dev.py`
- `.testbed/project.godot`
- `test/test_example.gd`

Notably absent from the tracked repo:

- `.testbed/addons.jsonc`
- `.testbed/tests/`
- `.testbed/src`
- `src/`

### File-level mismatches

#### `setup_dev.py`

Current behavior:

- creates `.testbed/addons/`
- clones `aerobeat-core` via **HTTPS** into `.testbed/addons/aerobeat-core`
- clones `gut` via **HTTPS** into `.testbed/addons/gut`
- creates runtime symlinks for `src -> .testbed/src` and `test -> .testbed/test`

That old test symlink behavior is now superseded by Derrick's updated package-layout decision: package repos should move repo-local unit tests under `.testbed/tests/` and stop treating a root `test/` directory as canonical.

Why this must change:

- the convention contract requires `.testbed/addons.jsonc` as the package-repo dependency contract
- the clean-break policy explicitly forbids keeping `setup_dev.py` once the manifest flow is ready
- committed shared dependency state must use SSH remotes, not HTTPS

#### `README.md`

Current issues:

- still tells users to run `python setup_dev.py`
- still presents the repo like a template (`YourOrg`, `aerobeat-feature-custom.git`)
- says `src/` exists even though it is not currently tracked in this repo
- does not document the GodotEnv restore flow
- does not document `.testbed/` as the future direct bugfinding environment with explicit commands

#### `.gitignore`

Current issues:

- only ignores `.testbed/addons/`
- does not preserve `.testbed/addons/.editorconfig`
- does not ignore `.testbed/.addons/`
- still documents dependencies as "Managed by setup_dev.py"

Required replacement pattern:

```gitignore
.testbed/addons/*
!.testbed/addons/.editorconfig
.testbed/.addons/
```

#### `.testbed/project.godot`

Current issues:

- `config/features=PackedStringArray("4.2", "Forward Plus")`
- GUT is enabled from `res://addons/gut/plugin.cfg`, which is correct for the future manifest-driven testbed once dependencies are restored

Required change:

- update the feature marker to `4.6`
- keep the project rooted in `.testbed/`
- keep GUT plugin enablement pointing at `res://addons/gut/plugin.cfg`

#### `.github/workflows/gut_ci.yml`

Current issues:

- uses `submodules: recursive`
- uses `chickensoft-games/setup-godot@v1`
- pins Godot `4.2.1`
- never installs GodotEnv
- never restores `.testbed` dependencies from a manifest
- runs GUT from repo root instead of the hidden `.testbed` project
- points GUT at `res://test/unit`, but the repo only has `test/test_example.gd`
- the packet's original `.testbed/test -> ../test` symlink assumption is now obsolete after Derrick's revised layout decision

Required direction:

- follow the same Phase 1 CI pattern already used by `aerobeat-ui-kit-community`
- remove recursive submodule checkout
- install GodotEnv
- run `godotenv addons install` from `.testbed/`
- import the `.testbed` project explicitly
- run GUT with `--path .testbed` and `-gdir=res://tests`

---

## Canonical dependency contract for the pilot repo

Create:

- `.testbed/addons.jsonc`

Required initial contents:

```jsonc
{
  "$schema": "https://chickensoft.games/schemas/addons.schema.json",
  "addons": {
    // Phase 2 pilot pins the foundational core contract for boxing feature work.
    "aerobeat-core": {
      "url": "git@github.com:AeroBeat-Workouts/aerobeat-core.git",
      "checkout": "v0.1.0",
      "subfolder": "/"
    },
    // GUT drives the repo-local test suite inside the hidden testbed/workbench.
    "gut": {
      "url": "git@github.com:bitwes/Gut.git",
      "checkout": "main",
      "subfolder": "/addons/gut"
    }
  }
}
```

### Why these exact dependencies

#### `aerobeat-core`

`aerobeat-feature-boxing` is a standard feature repo. The migration audit identified feature repos as consuming:

- `aerobeat-core`
- GUT for testbed testing

There is no evidence in the current repo that Boxing should also consume:

- `aerobeat-ui-core`
- `aerobeat-ui-kit-community`

So the pilot packet should stay minimal and not pull in UI dependencies unless implementation work later proves they are actually needed.

#### `gut`

GUT is still the test runner for the package workbench. Phase 1 precedent uses:

- SSH remote
- `checkout: "main"`
- `subfolder: "/addons/gut"`

The Boxing pilot should match that exact pattern so CI and local validation behave the same way as the already-migrated foundation chain.

---

## Exact repo changes for the implementation bead

## Files to add

### 1. `aerobeat-feature-boxing/.testbed/addons.jsonc`

Add the canonical package-repo manifest shown above.

### 2. `aerobeat-feature-boxing/.testbed/tests/`

Move the repo-local unit test suite from the legacy root `test/` directory into `.testbed/tests/`.

Why:

- package repos should treat repo root as the package/published boundary, not as the canonical testbed content root
- the hidden workbench project should run the repo-local GUT suite directly from `res://tests`
- CI and local runs should agree on `-gdir=res://tests`

### Optional workbench scene folder: `aerobeat-feature-boxing/.testbed/scenes/`

If the repo ever contains interactive workbench scenes or scratch content, place them under `.testbed/scenes/`.

For this specific pilot repo, do **not** invent a placeholder scenes folder unless real workbench content exists.

### Not required right now: `.testbed/src`

Do **not** add `.testbed/src` during the migration bead unless actual tracked runtime content also lands in `src/` as part of separately approved feature work.

Reason:

- this repo does not currently track `src/`
- the packet is for migration/normalization, not inventing placeholder runtime structure
- `plugin.cfg` at repo root is sufficient evidence that the package boundary is still intended to be repo-root (`subfolder: "/"`) for future consumers

## Files to update

### 3. `aerobeat-feature-boxing/README.md`

Replace the template-era setup instructions with real repo instructions.

Required content changes:

- remove all `python setup_dev.py` guidance
- replace template clone example with either a neutral repo-root workflow or the actual repo path
- document the canonical restore flow:

```bash
cd .testbed
godotenv addons install
```

- document the canonical editor launch:

```bash
godot --editor --path .testbed
```

- document the canonical headless import check:

```bash
godot --headless --path .testbed --import
```

- document the canonical GUT run:

```bash
godot --headless --path .testbed --script addons/gut/gut_cmdln.gd \
  -gdir=res://tests \
  -ginclude_subdirs \
  -gexit
```

- stop claiming `src/` exists unless the implementation bead also introduces it
- explicitly describe `.testbed/` as the future day-to-day boxing bugfinding workbench

### 4. `aerobeat-feature-boxing/.gitignore`

Update to the GodotEnv package-repo ignore policy.

Required outcomes:

- keep existing Godot/editor ignore rules that still apply
- replace the setup-script comment with GodotEnv wording
- ignore installed addons and cache via the package-repo pattern
- preserve `.testbed/addons/.editorconfig`

### 5. `aerobeat-feature-boxing/.testbed/project.godot`

Change only the version marker needed by the audit:

- `config/features=PackedStringArray("4.2", "Forward Plus")`
- -> `config/features=PackedStringArray("4.6", "Forward Plus")`

Do not try to encode `4.6.2` inside `config/features`; the Godot version audit established that `project.godot` should use `4.6` while human-facing docs/tooling should reference the exact OpenClaw pin `4.6.2 stable standard`.

### 6. `aerobeat-feature-boxing/.github/workflows/gut_ci.yml`

Replace the legacy CI flow with the `.testbed` GodotEnv pattern.

Minimum required behavior:

1. checkout repo without recursive submodules
2. setup .NET 8
3. setup Godot using current workflow action family (`setup-godot@v2`)
4. use the same Godot version policy as the approved repo wave for this migration
5. install GodotEnv as a .NET tool
6. run `godotenv addons install` in `.testbed`
7. run `godot --headless --path .testbed --import`
8. run GUT with `--path .testbed` and `-gdir=res://tests`

Recommended starting point:

- mirror `aerobeat-ui-kit-community/.github/workflows/gut_ci.yml`
- then adjust naming/comments for the Boxing repo only

### Optional but useful: coverage enforcement cleanup

Current CI includes a 100% coverage gate wired to a JSON export shape that may not be stable across GUT versions, and it currently points at the wrong test directory anyway.

For the pilot migration bead, the minimum required change is to get dependency restore and test execution correct from `.testbed/`.

If the coder keeps or reintroduces coverage enforcement, it should only happen after:

- GUT actually runs against `res://tests`
- the exported JSON shape is validated against the installed GUT version

## Files to delete

### 7. `aerobeat-feature-boxing/setup_dev.py`

Delete outright.

This is required by the clean-break retirement policy once `.testbed/addons.jsonc`, docs, ignore rules, and CI are updated.

---

## Godot version normalization required for the pilot

### Repo-local required update

In `aerobeat-feature-boxing`:

- `.testbed/project.godot`: `4.2` -> `4.6`

### Human-facing wording for the pilot

Repo docs/CI comments may say the repo targets the pinned OpenClaw toolchain:

- `Godot 4.6.2 stable standard`

But the committed project feature marker should remain:

- `4.6`

---

## Validation flow to standardize on

The future day-to-day bugfinding environment for Boxing should be the hidden `.testbed/` Godot project, not a bootstrap script and not a repo-root Godot project.

## Local restore

From repo root:

```bash
cd .testbed
godotenv addons install
```

Expected result:

- `.testbed/addons/aerobeat-core/` restored from tag `v0.1.0`
- `.testbed/addons/gut/` restored from `main`
- `.testbed/.addons/` cache populated

## Local import smoke check

From repo root:

```bash
godot --headless --path .testbed --import
```

Expected result:

- testbed imports cleanly using the restored addons
- GUT plugin path resolves from `.testbed/addons/gut/plugin.cfg`

## Local editor workflow

From repo root:

```bash
godot --editor --path .testbed
```

This is the direct environment developers should use for future boxing bugfinding and package-local debugging.

## Local test run

From repo root:

```bash
godot --headless --path .testbed --script addons/gut/gut_cmdln.gd \
  -gdir=res://tests \
  -ginclude_subdirs \
  -gexit
```

Expected result:

- GUT discovers `.testbed/tests/test_example.gd` via `res://tests` without any legacy symlink layer
- no legacy setup step is needed first

## CI flow

CI should run the same four stages:

1. checkout
2. GodotEnv restore in `.testbed`
3. headless import of `.testbed`
4. GUT run against `res://tests`

That gives parity between local and automation paths.

---

## Safe-retirement checklist for `setup_dev.py`

The implementation bead should not delete `setup_dev.py` until all of the following are true in the same PR:

1. `.testbed/addons.jsonc` exists and is committed
2. `.gitignore` matches the GodotEnv package pattern
3. `README.md` documents GodotEnv directly
4. `.github/workflows/gut_ci.yml` restores dependencies from `.testbed/addons.jsonc`
5. `.testbed/project.godot` is normalized to `4.6`
6. `.testbed/tests/` is committed so the testbed sees the repo-local test suite at `res://tests`
7. a clean local validation run succeeds from `.testbed`

Once those conditions are met, `setup_dev.py` is obsolete and must be removed in the same change.

---

## Separable follow-on execution work discovered during research

These are clearly separable from the pilot repo migration and should not be hidden inside the Boxing implementation bead unless explicitly linked.

### Follow-on 1: template cleanup bead

The Boxing repo still reflects stale template output. The docs/template source of truth should get its own execution work to prevent reintroducing this exact drift.

Expected scope:

- `aerobeat-docs/templates/feature/.testbed/project.godot` (`4.2` -> `4.6`)
- `aerobeat-docs/templates/feature/setup_dev.py` removal/replacement
- template README/instructions updated to the GodotEnv flow
- template CI updated to restore from `.testbed/addons.jsonc`

### Follow-on 2: package-family rollout bead

Once Boxing passes coder → QA → auditor, the same migration pattern should be rolled across the other standard package repos that share the old bootstrap shape:

- `aerobeat-feature-dance`
- `aerobeat-feature-flow`
- `aerobeat-feature-step`
- the low-complexity input/tool repos identified in the audit

### Follow-on 3: repo-shape cleanup bead for Boxing itself

This repo currently has template prose claiming `src/` exists, but no tracked `src/` directory.

That mismatch should be treated as separate product-shape work unless the implementation bead already has approved scope to establish actual boxing runtime content. The migration bead should fix the documentation mismatch, not invent placeholder code structure.

---

## Files this research updates

- created: `docs/architecture/godotenv-phase-2-pilot-boxing-packet-2026-04-18.md`

---

## Bottom line

The Boxing pilot is ready for implementation once the coder follows this exact shape:

- add `.testbed/addons.jsonc`
- move repo-local tests into `.testbed/tests/`
- update `README.md`
- update `.gitignore`
- update `.testbed/project.godot` from `4.2` to `4.6`
- replace `.github/workflows/gut_ci.yml` with the Phase 1-style GodotEnv testbed flow
- delete `setup_dev.py`

Dependency expectations for the first pilot cut:

- `aerobeat-core` -> `git@github.com:AeroBeat-Workouts/aerobeat-core.git` @ `v0.1.0`, `subfolder: "/"`
- `gut` -> `git@github.com:bitwes/Gut.git` @ `main`, `subfolder: "/addons/gut"`

Validation should run from `.testbed/` directly and become the normal direct-development/debugging surface for future boxing work, with GUT targeting `res://tests`.
