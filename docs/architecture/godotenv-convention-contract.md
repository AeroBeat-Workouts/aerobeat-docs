# AeroBeat GodotEnv Convention Contract

_Date: 2026-04-17_
_Status: Phase 0 authoritative spec_

## Purpose

This document is the operating contract for AeroBeat's GodotEnv migration.

It defines the dependency-management rules that later migration phases must follow. It is intentionally opinionated. If an older doc, template, or repo-local script disagrees with this contract, this contract wins.

## Fixed Phase 0 decisions

These decisions are already approved and are not up for reinterpretation during later phases:

1. **Clean break only.** There will be no wrapper-era dual system, no long-lived compatibility layer, and no permanent retention of the old setup flow.
2. **`addons.jsonc` is the canonical manifest name.** AeroBeat standardizes on JSONC so manifests can carry comments and migration notes.
3. **Package repos use `.testbed/addons.jsonc`.** That manifest is for dev/test dependencies inside the package workbench.
4. **Assembly repos use `addons.jsonc` at repo root.** That manifest is the runtime dependency contract for the product app.
5. **`.testbed` stays.** The hidden testbed/workbench pattern remains the standard package-repo development harness.
6. **The migration closes with a full-family re-audit.** No repo-family migration is considered done until that audit is completed and recorded.
7. **After Phase 0 is approved and landed, later phases may execute without fresh approval.**

---

## 1. Canonical file placement rules

## 1.1 Package repos

This includes feature, input, tool, UI kit, asset/supporting, and similar addon-producing repos.

**Required placement**

- Committed manifest: `.testbed/addons.jsonc`
- Installed dev/test addons path: `.testbed/addons/`
- Testbed cache path: `.testbed/.addons/`

**Not allowed as the package convention**

- Root-level `addons.jsonc` as the primary package dev manifest
- Repo-local `setup_dev.py` as the dependency contract
- Submodules for first-party AeroBeat dependencies

**Rationale**

Package repos are producers of reusable addons. Their own dependency-management need is a local workbench for development, tests, and previewing runtime content. That is exactly what `.testbed` is for.

## 1.2 Foundational repos

This specifically includes `aerobeat-core` and `aerobeat-ui-core`.

They follow the same placement convention as package repos:

- Committed manifest: `.testbed/addons.jsonc`
- No root runtime manifest required

These repos are foundational providers, not app assemblies. They must still support their own testbed/dev harness, but they do not become special snowflakes with a second manifest layout.

## 1.3 UI shell repos

UI shell repos are still package repos for Phase 0 purposes.

**Required placement**

- Committed manifest: `.testbed/addons.jsonc`
- Installed dev/test addons path: `.testbed/addons/`
- Testbed cache path: `.testbed/.addons/`

**Explicitly forbidden**

- `.kit_version`
- `sync_ui_kit.py`
- A separate shell-only dependency sync protocol

Shells must consume UI kit, UI core, core, and any dev-only addons through the same GodotEnv manifest model as every other package repo.

## 1.4 Assembly repos

This includes `aerobeat-assembly-community` and any future `aerobeat-assembly-*` repo.

**Required placement**

- Committed manifest: `addons.jsonc` at repo root
- Installed runtime addons path: `addons/`
- Runtime cache path: `.addons/` at repo root

**Not allowed**

- `.gitmodules`
- First-party AeroBeat submodules under `addons/`
- Root `setup_dev.py` as a dependency manager

The assembly manifest is the product's source of truth for runtime addon composition.

## 1.5 Docs and template repos

`aerobeat-docs` itself is not a runtime addon consumer, so it does not need an `addons.jsonc` for this migration.

However, the docs repo owns the template source of truth and therefore must emit the correct manifest placement for every generated repo type:

- package template output -> `.testbed/addons.jsonc`
- assembly template output -> `addons.jsonc` at repo root

---

## 2. Naming and manifest-shape rules

## 2.1 Canonical manifest filename

AeroBeat uses **`addons.jsonc`** as the only standard committed manifest filename.

`addons.json` is not the preferred AeroBeat file. If a tool can read either filename, AeroBeat still commits `addons.jsonc`.

## 2.2 First-party addon key naming

Inside `addons.jsonc`, the key under `addons` must match the installed addon directory name exactly.

For first-party AeroBeat repos, the installed addon directory name is the **repo name by default**:

- `aerobeat-core`
- `aerobeat-ui-core`
- `aerobeat-ui-kit-community`
- `aerobeat-feature-boxing`
- `aerobeat-input-keyboard`
- `aerobeat-input-mediapipe-python`

**Rule:** do not invent aliases for first-party AeroBeat addon keys. If a repo ever needs a published addon folder name that differs from the repo name, that exception must be documented explicitly in architecture docs and downstream migration notes before implementation.

That means this is correct:

```jsonc
{
  "addons": {
    "aerobeat-core": {
      "url": "git@github.com:AeroBeat-Workouts/aerobeat-core.git",
      "checkout": "v0.1.0",
      "subfolder": "/"
    }
  }
}
```

And this is not:

```jsonc
{
  "addons": {
    "core": {
      "url": "git@github.com:AeroBeat-Workouts/aerobeat-core.git"
    }
  }
}
```

## 2.3 Transport naming for first-party remotes

First-party AeroBeat remote git URLs should use **SSH Git remotes**, not HTTPS, to stay aligned with the broader workspace Git policy.

Preferred form:

- `git@github.com:AeroBeat-Workouts/<repo>.git`

## 2.4 `path` and `cache` policy

AeroBeat standardizes on GodotEnv defaults unless there is a repo-specific reason to do otherwise.

- `path`: `addons`
- `cache`: `.addons`

That means:

- package and foundational repos usually omit these fields in `.testbed/addons.jsonc`, because `.testbed` is the working directory and defaults already resolve to `.testbed/addons` and `.testbed/.addons`
- assembly repos usually omit these fields in root `addons.jsonc`, because defaults already resolve to `addons/` and `.addons/`

**Policy:** do not customize `path` or `cache` for first-party repos unless a later architecture doc explicitly declares an exception.

## 2.5 `subfolder` policy

Every first-party AeroBeat addon entry must explicitly declare `subfolder`, even when it is `/`.

**Default rule:** first-party AeroBeat repos are intentionally consumed from repo root. Use `subfolder: "/"` unless that repo has a documented architecture exception declaring a narrower published folder.

Dot-prefixed folders inside a repo-root payload are acceptable. Godot hides dot-prefixed folders such as `.testbed`, so their presence does not make a repo-root import invalid by itself.

Why:

- it makes repo shape assumptions visible in code review
- it records that repo-root import is the expected first-party default, not an accident
- it avoids implicit behavior during migration
- it leaves room for a repo to later narrow install scope deliberately

## 2.6 Portable manifest policy

Committed manifests must be portable across machines.

Therefore:

- committed manifests may use `remote` sources with SSH URLs
- committed manifests may use `local` sources only if the path is repo-portable and agreed for that repo class, which AeroBeat is **not** standardizing on in Phase 0
- committed manifests must **not** contain developer-specific absolute paths
- committed manifests must **not** contain committed `symlink` entries pointing at personal machine paths

Portable shared state is more important than personal convenience in committed manifests.

---

## 3. Dependency mode contract: `tag`, `branch`, `symlink`

AeroBeat supports exactly three operational dependency modes in the migration contract.

## 3.1 `tag` mode

**Meaning:** consume a released, immutable version of a repo.

**Manifest form**

- `source`: omitted or `remote`
- `checkout`: a git tag such as `v0.1.0`

**When `tag` mode is required**

- assembly repo manifests on `main`
- CI intended to validate releasable integration
- downstream consumption of foundational repos after a version is released
- UI shell and UI kit integration on stable branches
- any documented example meant to show the default production/release flow

**When `tag` mode is preferred**

- cross-repo integration where the dependency already has a suitable release tag
- documentation snippets
- template defaults

**Why it exists**

`tag` mode is the contract-safe default. It gives reproducible installs and makes upgrades explicit in git diffs.

## 3.2 `branch` mode

**Meaning:** consume a moving integration line from a git branch.

**Manifest form**

- `source`: omitted or `remote`
- `checkout`: a branch such as `main` or `feature/some-work`

**When `branch` mode is allowed**

- package repo `.testbed/addons.jsonc` during active development
- foundational repo `.testbed/addons.jsonc` when validating unpublished sibling changes
- short-lived integration work before a release tag exists
- explicitly temporary cross-repo coordination during a migration wave

**When `branch` mode is not allowed**

- assembly repo `addons.jsonc` on `main`
- release tags, release branches, or release-candidate validation meant to be reproducible
- long-term documentation examples presented as the steady-state production pattern

**Additional policy**

If a dependency remains on `branch` mode long enough that multiple repos depend on it, that is a release-management smell. The fix is to create a tag, not to normalize branch drift.

## 3.3 `symlink` mode

**Meaning:** use a live local folder for same-machine development.

**Manifest form**

- `source`: `symlink`
- `url`: local path
- `checkout`: ignored

**When `symlink` mode is allowed**

- solo local development on a machine that has sibling repos checked out
- tight iteration between two first-party repos before committing
- short-lived debugging where instant file reflection is useful

**When `symlink` mode is not allowed**

- committed shared manifests on `main`
- CI
- release validation
- any repo state intended to be portable for another developer or automation runner

**AeroBeat policy for symlinks**

`symlink` mode is a local working-copy override only. If a developer temporarily edits `addons.jsonc` to use a symlink, that edit must not be committed. The committed manifest must be restored to `tag` or approved `branch` mode before merge.

## 3.4 Mode precedence rule

When more than one mode could work, use the most stable valid mode:

1. `tag`
2. `branch`
3. `symlink`

That rule is deliberate. AeroBeat optimizes for reproducibility by default and uses live-link behavior only when actively developing.

---

## 4. `.testbed` rules and expectations

`.testbed` remains the standard package-repo workbench.

## 4.1 What `.testbed` is for

`.testbed` exists to let a package repo:

- open a runnable Godot project during addon development
- install dev/test dependencies into a hidden project-local `addons/`
- host GUT and similar test-only tooling
- preview package scenes/assets in isolation

## 4.2 What belongs in `.testbed`

Allowed examples:

- `.testbed/project.godot`
- `.testbed/addons.jsonc`
- `.testbed/addons/` (ignored, installed)
- `.testbed/.addons/` (ignored cache)
- `.testbed/tests/` for repo-local unit tests used by package development
- `.testbed/scenes/` for manual workbench scenes or interactive scratch content
- other `.testbed`-local fixtures, mock data, and test harness files used only for package development

## 4.3 What does not belong in `.testbed`

Do not place the package's canonical runtime addon content under `.testbed`.

The reusable package content belongs in the repo's actual addon/runtime folders, not in the hidden workbench.

## 4.4 Symlink expectations inside package repos

The old pattern used ad hoc symlinks from root `src/` or `test/` into `.testbed/`.

Package repos should no longer treat a root `test/` directory as canonical. Repo-local unit tests belong in `.testbed/tests/`, while any manual or workbench scenes belong in `.testbed/scenes/`. Keep those two concerns distinct.

Phase 0 does **not** preserve those symlink scripts as architecture. Package repos may still need local scene references or test harness arrangements, but the dependency contract is the manifest, not a bespoke symlink bootstrap script.

If a package repo requires root runtime content to appear inside `.testbed` for Godot project layout reasons, that relationship must be implemented by the repo's tracked structure, not by a repo-local dependency manager script.

## 4.5 Export expectation

`.testbed` is development-only and must not be treated as runtime-shipping content. This aligns with the existing decision to keep `.testbed` as the workbench and with Godot's handling of hidden folders during exports.

---

## 5. Repo-type conventions

## 5.1 Foundational repos

### `aerobeat-core`

**Role**

- lowest-level shared contract hub
- shared interfaces, enums, constants, signals, and foundational utilities
- may expose plugin/addon metadata required by downstream repos

**Dependency boundary**

- must not depend on first-party feature repos
- must not depend on first-party UI kits or shells
- must remain the bottom of the first-party dependency stack

**Manifest convention**

- keep `.testbed/addons.jsonc` for dev/test only
- no root runtime manifest

### `aerobeat-ui-core`

**Role**

- shared UI logic layer
- abstract UI behaviors, contracts, signals, and non-themed component logic
- contract surface used by UI kits and shells

**Dependency boundary**

- may depend on `aerobeat-core`
- must not depend on a concrete UI kit
- must not depend on a concrete UI shell
- must not absorb shell-specific layout logic

**Manifest convention**

- keep `.testbed/addons.jsonc` for dev/test only
- no root runtime manifest

## 5.2 UI kit repos

### `aerobeat-ui-kit-community`

**Role**

- default community visual component kit
- concrete themed atoms, molecules, and other visual components built on UI core contracts
- no shell orchestration responsibilities

**Dependency boundary**

- may depend on `aerobeat-ui-core`
- may depend on `aerobeat-core` if needed by the contract chain
- must not absorb shell-specific page wiring or assembly logic

**Manifest convention**

- `.testbed/addons.jsonc` is the dev/test dependency contract
- no `setup_dev.py`
- no separate UI sync tooling

## 5.3 UI shell repos

**Role**

- layout and page assembly layer
- platform-specific UI composition
- consumer of UI kit releases

**Dependency convention**

- consume `aerobeat-core`, `aerobeat-ui-core`, and a specific `aerobeat-ui-kit-*` through `.testbed/addons.jsonc`
- use `tag` mode for stable kit consumption
- use `branch` mode only for deliberate coordinated integration
- never use `.kit_version` as a parallel source of truth

## 5.4 Standard package repos

Feature, input, tool, and asset/supporting repos follow the standard package convention:

- they are addon producers
- they use `.testbed/addons.jsonc` for dev/test
- they do not use root runtime manifests as their primary dependency contract
- they publish tags so assemblies and other consumers can pin released versions

## 5.5 Assembly repos

Assembly repos are the product-composition layer.

**Required responsibilities**

- own the runtime addon dependency graph in root `addons.jsonc`
- pin stable first-party dependencies by tag on `main`
- compose the runtime app from released packages
- avoid repo mutation flows such as submodule adds or plugin patch scripts

**Explicit constraint**

Assembly repos are consumers, not dependency managers by script.

---

## 6. Cache and ignore policy

GodotEnv-managed installed addons are immutable/disposable payloads. AeroBeat does not treat an installed `addons/` or `.testbed/addons/` copy as a durable editing surface; if it becomes dirty, fix the source repo or handle it as a documented exception.

## 6.1 Never commit installed addon folders

Installed dependency folders managed by GodotEnv are generated artifacts.

Do not commit:

- `addons/*` in assembly repos
- `.testbed/addons/*` in package repos
- `.addons/`
- `.testbed/.addons/`

## 6.2 Keep GodotEnv's editor config when needed

Where GodotEnv initializes an addons directory, keep the generated `.editorconfig` unignored if the tool needs it.

Practical pattern:

### Assembly repos

```gitignore
addons/*
!addons/.editorconfig
.addons/
```

### Package and foundational repos

```gitignore
.testbed/addons/*
!.testbed/addons/.editorconfig
.testbed/.addons/
```

## 6.3 Commit the contract, not the install result

Commit:

- `addons.jsonc`
- `.testbed/addons.jsonc`
- `.godotrc` or other approved Godot version pin files
- required Godot-generated `.uid` files that belong to the published addon source
- tracked repo content that defines the addon itself

Do not commit:

- cloned/symlinked dependency payloads
- cache folders
- machine-specific symlink paths

---

## 7. Foundational repo release and tagging expectations

The first three repos normalized in Phase 1 must follow the same release discipline.

## 7.1 Tagging format

AeroBeat first-party foundational releases use SemVer with a `v` prefix.

Examples:

- `v0.1.0`
- `v0.2.0`
- `v0.2.1`

Because the ecosystem is still stabilizing, `0.x` releases are acceptable during migration. The important part is consistency and explicit versioned tags.

## 7.2 Tagging rule

A repo may be consumed in `tag` mode only after:

1. the relevant contract changes are committed
2. repo-local validation passes
3. the repo is in a state another repo can consume reproducibly
4. any required Godot-generated `.uid` files are committed in the source tree
5. the tag is created specifically for that state

GodotEnv-installed addons are expected to be immutable/disposable. First-party release tags must therefore ship the files Godot needs, rather than relying on downstream consumers to generate missing `.uid` files after install.

## 7.3 Change classification rule

### `aerobeat-core`

Create a new tag whenever it changes any shared contract or behavior other repos are meant to consume, including:

- interfaces
- enums
- constants with integration significance
- shared utility behavior that downstream repos rely on
- plugin metadata or addon packaging shape

### `aerobeat-ui-core`

Create a new tag whenever it changes any UI contract surface consumed by kits or shells, including:

- base classes
- signals
- shared UI logic
- UI-facing constants/enums/contracts

### `aerobeat-ui-kit-community`

Create a new tag whenever it changes any shipped component surface meant for shells to consume, including:

- exported scene/component names
- required UI core compatibility expectations
- resource structure relied upon by shells
- component behavior changes that affect shell integration

## 7.4 Release responsibility by repo

### `aerobeat-core`

Must provide the stable lowest-level contract the rest of the family builds on.

### `aerobeat-ui-core`

Must provide the stable UI logic contract that kits and shells build on without importing kit visuals.

### `aerobeat-ui-kit-community`

Must provide the stable default community visual layer that shells can pin to a release tag.

## 7.5 No branch-only foundations policy

A foundational repo staying branch-only is not an acceptable steady state.

If other repos depend on a foundational repo, that repo must produce real release tags so downstream manifests can converge on `tag` mode.

---

## 8. Minimum manifest examples

## 8.1 Package/foundation/UI shell testbed manifest example

Stored at `.testbed/addons.jsonc`.

```jsonc
{
  "$schema": "https://chickensoft.games/schemas/addons.schema.json",
  "addons": {
    "aerobeat-core": {
      "url": "git@github.com:AeroBeat-Workouts/aerobeat-core.git",
      "checkout": "v0.1.0",
      "subfolder": "/"
    },
    "gut": {
      "url": "git@github.com:bitwes/Gut.git",
      "checkout": "main",
      "subfolder": "/"
    }
  }
}
```

## 8.2 Assembly manifest example

Stored at `addons.jsonc` in repo root.

```jsonc
{
  "$schema": "https://chickensoft.games/schemas/addons.schema.json",
  "addons": {
    "aerobeat-core": {
      "url": "git@github.com:AeroBeat-Workouts/aerobeat-core.git",
      "checkout": "v0.1.0",
      "subfolder": "/"
    },
    "aerobeat-input-mediapipe-python": {
      "url": "git@github.com:AeroBeat-Workouts/aerobeat-input-mediapipe-python.git",
      "checkout": "v0.1.0",
      "subfolder": "/"
    }
  }
}
```

---

## 9. Non-negotiable migration rules

1. **One repo, one dependency contract.** No parallel source of truth between GodotEnv manifests and legacy scripts/config files.
2. **No committed machine-specific symlink paths.**
3. **No first-party submodules for addon consumption.**
4. **No shell-specific sync mechanism once GodotEnv is in place.**
5. **No release-ready assembly manifest pinned to branches.**
6. **Foundational repos must tag real releases.**
7. **Templates and docs must teach the same rules the repos implement.**

## Final decision summary

- `addons.jsonc` is the AeroBeat standard.
- Package, foundational, and UI shell repos commit `.testbed/addons.jsonc`.
- Assembly repos commit root `addons.jsonc`.
- `tag` is the default stable mode, `branch` is the temporary coordination mode, and `symlink` is local-only and uncommitted.
- `.testbed` stays as the package workbench.
- `aerobeat-core`, `aerobeat-ui-core`, and `aerobeat-ui-kit-community` are the first foundational repos that must establish tag discipline.
- Old setup flows do not coexist with the new contract long-term.
