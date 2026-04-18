# AeroBeat GodotEnv Clean-Break Removal Policy

_Date: 2026-04-17_
_Status: Phase 0 authoritative retirement policy_

## Purpose

This document defines how AeroBeat retires obsolete dependency/bootstrap flows during the GodotEnv migration.

It is intentionally stricter than the earlier audit notes. The audit floated temporary wrapper ideas as a migration aid. Derrick's approved Phase 0 decision overrides that suggestion:

> **AeroBeat is doing a clean break. There will be no temporary holdovers and no wrapper-era dual systems.**

That means legacy setup artifacts are removed when their GodotEnv replacement is ready. They are not kept around as "just in case" shims.

---

## 1. Clean-break policy statement

A legacy dependency-management artifact must be deleted, not wrapped, once the replacement conditions in this document are satisfied.

The migration standard is:

1. introduce the GodotEnv manifest/config that replaces the old behavior
2. update docs/CI/templates so the new behavior is the only documented path
3. verify the replacement from a clean checkout
4. remove the legacy artifact outright

**Not allowed**

- keeping `setup_dev.py` as a thin wrapper around `godotenv addons install`
- keeping `.gitmodules` after root `addons.jsonc` exists
- keeping `.kit_version` as a second version pin alongside `addons.jsonc`
- keeping `sync_ui_kit.py` after shell manifests declare the kit dependency directly
- keeping CI `submodules: recursive` because "it doesn't hurt"

If a repo still needs the legacy artifact to function, that repo is not yet ready for legacy removal.

---

## 2. Retirement matrix

| Legacy artifact | Replacement that must exist first | Safe-retirement verification | Removal decision |
| --- | --- | --- | --- |
| `setup_dev.py` in package repos | `.testbed/addons.jsonc`, updated `.gitignore`, updated repo README/contributor instructions | fresh clone -> `cd .testbed && godotenv addons install` works; tests/dev harness resolve dependencies without the script | delete outright |
| `setup_dev.py` in `aerobeat-ui-kit-community` and similar UI repos | `.testbed/addons.jsonc` covering core/ui-core/dev deps, updated docs, updated CI | fresh clone -> install succeeds; UI testbed opens/validates without the script | delete outright |
| Root `setup_dev.py` in assembly repos | root `addons.jsonc`, committed plugin/runtime config, documented sidecar bootstrap where needed | fresh clone -> `godotenv addons install` at repo root produces working addon layout with no submodule commands | delete outright |
| `.gitmodules` and assembly submodule bootstrap | root `addons.jsonc` and non-submodule plugin/runtime setup | fresh clone contains no submodules; `git submodule status` is irrelevant because the repo no longer depends on it; runtime addons resolve via GodotEnv only | delete outright |
| `sync_ui_kit.py` | shell `.testbed/addons.jsonc` explicitly declaring UI kit dependency | fresh clone -> shell gets the exact kit through GodotEnv; no manual sync step required | delete outright |
| `.kit_version` | version/tag/branch now declared directly in shell `.testbed/addons.jsonc` | shell version source of truth is only the manifest; no duplicate version pin remains | delete outright |
| Legacy dependency glue in docs | docs pages rewritten around GodotEnv | docs no longer instruct `python setup_dev.py`, submodule init, or kit sync scripts | delete/update outright |
| Legacy dependency glue in templates | templates emit manifests instead of scripts | generating a new repo from templates no longer produces obsolete bootstrap files | delete/update outright |
| Recursive submodule CI checkout | CI/bootstrap installs addons from manifests | CI no longer depends on submodule checkout to restore first-party deps | delete/update outright |

---

## 3. Replacement requirements by legacy artifact

## 3.1 `setup_dev.py` in package repos

This applies to feature, input, tool, UI kit, asset/supporting, and template-derived package repos.

### Required replacement artifacts

Before deleting `setup_dev.py`, the repo must have all of the following:

1. `.testbed/addons.jsonc` committed
2. `.gitignore` updated for GodotEnv-managed install/cache paths at minimum:
   - `.testbed/addons/*`
   - `!.testbed/addons/.editorconfig`
   - `.testbed/.addons/`
3. repo docs/README updated so the setup instructions point directly to GodotEnv
4. any prior dependency notes moved into comments inside `addons.jsonc` or docs, not hidden in the deleted script

### Required verification

From a clean clone:

1. enter `.testbed/`
2. run `godotenv addons install`
3. confirm required deps appear under `.testbed/addons/`
4. open or validate the `.testbed` project successfully
5. run the repo's test/dev verification path without using `setup_dev.py`

### Safe-retirement proof

If the repo works from the manifest-driven flow and the docs no longer reference the script, the script is obsolete and must be deleted.

## 3.2 Root `setup_dev.py` in assembly repos

This applies first to `aerobeat-assembly-community`.

### Required replacement artifacts

Before deletion, the assembly repo must have:

1. root `addons.jsonc` committed
2. all first-party runtime addon deps declared in that manifest
3. `.gitignore` updated for:
   - `addons/*`
   - `!addons/.editorconfig`
   - `.addons/`
4. committed plugin/runtime project configuration that does not rely on a setup script mutating `project.godot`
5. documented non-addon sidecar bootstrap steps for exceptional deps such as `aerobeat-input-mediapipe-python`

### Required verification

From a clean clone:

1. run `godotenv addons install` at repo root
2. verify required runtime addons appear in `addons/`
3. verify the project no longer needs git submodule add/update commands
4. verify plugin/runtime config resolves correctly without the script appending config blocks
5. verify any sidecar-specific instructions are documented separately from addon install

### Safe-retirement proof

If the assembly can be restored from `addons.jsonc` plus committed project config, `setup_dev.py` is redundant and must be deleted.

## 3.3 `.gitmodules` and assembly submodule bootstrap

### Required replacement artifacts

Before deleting `.gitmodules`, the assembly repo must have:

1. root `addons.jsonc` covering the same first-party dependency set the submodules previously supplied
2. GodotEnv-driven addon restore documented as the only dependency bootstrap path
3. committed repo state that no longer assumes nested git repos under `addons/`

### Required verification

From a clean clone:

1. `git status` shows a normal repo with no dependency on submodule init
2. `godotenv addons install` restores the needed addon content
3. branch switching plus reinstall remains predictable
4. no contributor doc tells humans to run `git submodule update --init --recursive`

### Safe-retirement proof

If dependency restore works without submodule metadata, `.gitmodules` becomes architectural drift and must be deleted.

## 3.4 `sync_ui_kit.py` and `.kit_version`

This applies to the community UI shells and the UI shell template.

### Required replacement artifacts

Before deletion, each shell repo must have:

1. `.testbed/addons.jsonc` committed
2. the UI kit dependency declared directly in that manifest
3. the desired version reference expressed as `checkout` in that manifest
4. any shell-specific dev/test dependencies declared in the same manifest
5. docs updated so there is no separate kit sync step

### Required verification

From a clean clone:

1. enter `.testbed/`
2. run `godotenv addons install`
3. verify the UI kit appears under `.testbed/addons/`
4. verify the shell no longer depends on `.kit_version`
5. verify README/CI use only the manifest-driven flow

### Safe-retirement proof

If the shell's kit dependency and version are fully represented by `.testbed/addons.jsonc`, then both `sync_ui_kit.py` and `.kit_version` are duplicate architecture and must be deleted.

## 3.5 Related legacy dependency glue

This includes:

- contributor docs instructing `python setup_dev.py`
- docs describing submodules as the default dependency workflow
- docs describing the UI Sync Protocol as the shell dependency contract
- template files that generate obsolete bootstrap scripts
- CI workflows that still check out submodules recursively for first-party dependencies
- `.gitignore` comments that still describe deps as managed by `setup_dev.py`

### Required replacement artifacts

Before deleting/updating these, the repo family must have:

1. current architecture docs pointing to the GodotEnv contract
2. updated templates that generate the new layout
3. CI/bootstrap steps based on manifest-driven restore
4. ignore rules aligned with GodotEnv cache/install paths

### Required verification

1. grep/docs review shows no old-path instructions in the migrated scope
2. generated/template repos no longer emit the old files
3. CI jobs can restore deps without recursive submodules or legacy scripts

### Safe-retirement proof

If a file only exists to document or automate the legacy path, and the replacement path is already real, that file must be updated or removed in the same migration wave.

---

## 4. Verification standard for every deletion

No legacy dependency artifact is considered safely retired until all four checks pass.

## 4.1 Clean checkout proof

A fresh clone must be able to restore dependencies using only the new GodotEnv flow and the committed project/docs state.

## 4.2 Branch-switch proof

If a repo changes manifests across branches, a developer must be able to switch branches, rerun `godotenv addons install`, and end up with the expected dependency state without manual cleanup rituals.

## 4.3 No hidden tracked-file mutation proof

The new flow must not rely on scripts silently editing tracked project files after install. If plugin configuration or runtime project settings are required, they should be committed deliberately.

## 4.4 Documentation parity proof

The README/docs/CI/template outputs in the migrated scope must agree on the new flow. If the docs still teach the old workflow, the migration is not actually done.

---

## 5. Exceptions and non-exceptions

## 5.1 Real exception: sidecar runtimes

`aerobeat-input-mediapipe-python` may require sidecar/bootstrap documentation beyond the addon install itself.

That is a packaging/release exception.

It is **not** an exception that justifies keeping:

- assembly submodules
- assembly `setup_dev.py`
- branch-only runtime dependency policy on `main`

The addon dependency contract and the sidecar runtime contract are separate concerns.

## 5.2 Not an exception: contributor convenience

"People are used to running `python setup_dev.py`" is not a valid reason to keep the old flow.

The new flow must be documented directly and consistently.

## 5.3 Not an exception: template lag

A repo migration is not complete if the docs/templates still regenerate the obsolete files.

Template cleanup is part of architecture cleanup, not a nice-to-have follow-up.

---

## 6. Repo-wave retirement guidance

## 6.1 Package repo wave

For each migrated package repo:

1. add `.testbed/addons.jsonc`
2. update `.gitignore`
3. update README/docs
4. verify from clean clone
5. delete `setup_dev.py`

## 6.2 UI shell wave

For each migrated shell repo:

1. add `.testbed/addons.jsonc`
2. encode core/ui-core/kit deps in one manifest
3. update docs and CI
4. verify from clean clone
5. delete `setup_dev.py`
6. delete `sync_ui_kit.py`
7. delete `.kit_version`

## 6.3 Assembly wave

For the assembly repo:

1. add root `addons.jsonc`
2. commit non-script plugin/runtime config
3. document sidecar exceptions separately
4. verify from clean clone
5. delete `setup_dev.py`
6. delete `.gitmodules`
7. remove any submodule-oriented CI/docs

---

## Final decision summary

- Legacy setup artifacts are removed, not wrapped, once their GodotEnv replacement is proven.
- `setup_dev.py`, `.gitmodules`, `sync_ui_kit.py`, and `.kit_version` are all targeted for outright deletion.
- Safe retirement requires clean-checkout proof, branch-switch proof, no hidden tracked-file mutation, and doc/CI/template parity.
- Sidecar-heavy repos may keep separate runtime docs, but they do not get to keep obsolete dependency-management architecture.
