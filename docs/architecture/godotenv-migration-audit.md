# GodotEnv Migration Audit and Cleanup Plan

_Date: 2026-04-17_

## Executive summary

I audited the full AeroBeat repo family under `projects/aerobeat` to map the current dependency/setup model and the work needed to move to a GodotEnv-centered architecture.

### What the audit found

- The repo family currently spans **35 git repos**: 1 assembly repo, 1 docs repo, 1 core repo, 1 UI core repo, 4 feature repos, 8 input repos, 2 tool repos, 1 UI kit repo, 4 UI shell repos, 1 asset/supporting repo, and 11 standalone template repos. [E-01]
- **31/35 repos** still carry a repo-local `setup_dev.py` bootstrap script. [E-01]
- **32/35 repos** currently use a hidden `.testbed/` project pattern for local dev/testing. [E-01]
- **5 repos** use the older UI kit sync flow with `.kit_version` plus `sync_ui_kit.py`: the 4 community UI shells and `aerobeat-template-ui-shell`. [E-01][E-05]
- Only **1 repo** currently uses real git submodules: `aerobeat-assembly-community`. Its `setup_dev.py` mutates the repo by adding local-path submodules and patching `project.godot`. [E-02]
- I found **no `addons.json` or `addons.jsonc` manifests** anywhere in the repo family yet, so the GodotEnv migration is architectural cleanup rather than a partially completed rollout. [E-01]

### Bottom line

AeroBeat is already organized like a package ecosystem, but its install/dev workflow is still split across:

- `setup_dev.py` clone scripts,
- `.testbed` symlink conventions,
- one real submodule workflow in the assembly repo,
- a separate UI shell sync mechanism,
- docs that still describe the old `setup_dev` / submodule / hub-and-spoke workflow as the primary model. [E-02][E-03][E-04][E-05][E-06]

The migration target should be:

1. **GodotEnv manifests as the default dependency contract** for package and assembly repos.
2. **Keep `.testbed/` as the local dev/test project pattern**, but switch it from ad hoc clone/symlink bootstrapping to manifest-driven installs and a documented layout.
3. **Retire `setup_dev.py`, `.gitmodules`, and `sync_ui_kit.py` gradually**, starting by wrapping them around GodotEnv for transition and ending with removal once docs/templates/CI are updated.
4. **Establish three supported dependency modes** across the family: `tag`, `branch`, and `symlink`.
5. **Treat `aerobeat-core` and `aerobeat-ui-core` as foundational package repos** that must be normalized first because almost every other repo assumes them. [E-02][E-03][E-04][E-06]

---

## Current architecture inventory

## Family-wide patterns

### 1. `setup_dev.py` is the dominant install mechanism

Most package repos still use a small Python bootstrap script that:

- creates `.testbed/addons/`,
- clones `aerobeat-core` and sometimes `aerobeat-ui-core`,
- clones `gut`,
- symlinks `src/`, `test/`, or `assets/` into `.testbed/`. [E-03][E-04]

This is consistent across features, inputs, tools, UI kit repos, UI shell repos, asset-style repos, and nearly all template repos. [E-03][E-04][E-08]

### 2. `.testbed/` is deeply embedded in the developer workflow

The docs still describe `.testbed/` as the local dev pattern for feature repos, and the repo family matches that at scale. The key insight is that `.testbed/` itself is not the problem; the problem is that the dependency population for `.testbed/` is currently driven by per-repo bootstrap scripts instead of a shared manifest model. [E-06][E-07]

### 3. The assembly repo is the odd one out

`aerobeat-assembly-community` does **not** use `.testbed/`. It installs into root `addons/`, uses `.gitmodules`, and its `setup_dev.py` adds submodules from sibling local paths, updates submodules recursively, and appends plugin configuration to `project.godot`. [E-02]

That means the assembly migration is not just a "convert one script" task. It is the place where the old spoke-and-wheel pattern is most explicit.

### 4. UI shells have a second dependency mechanism

The UI shell repos do not just use `setup_dev.py`; they also keep `.kit_version` plus `sync_ui_kit.py`, which clones a UI kit repo into `.testbed/addons/` using a branch or tag-like `version` field. In practice, the current community shells are pinned to `"version": "main"`, not a release tag. [E-05]

This is the clearest place where a GodotEnv manifest can replace custom one-off tooling.

### 5. Docs and templates still teach the old model

The docs repo currently tells contributors to run `python setup_dev.py`, describes dependency management in terms of git submodules and `.testbed` cloning, and states that GUT is included as a submodule in `aerobeat-core`. The template source-of-truth in `aerobeat-docs/templates/` still generates repos around those assumptions. [E-06][E-07][E-08][E-09]

That means documentation cleanup is not optional; it is part of the architecture migration itself.

---

## Architecture cleanup findings by repo cluster

## Foundational contract repos

### `aerobeat-core`

Current state:

- acts as the hub/contract repo in docs and in downstream setup scripts, [E-03][E-07]
- has a `.testbed/` project,
- does **not** currently have `setup_dev.py`,
- already has `plugin.cfg`,
- is assumed by nearly every package repo. [E-01]

Impact:

- should be one of the **first repos normalized** for GodotEnv,
- needs explicit release/tag discipline before the rest of the family can pin to tags,
- likely needs a documented development manifest for its own `.testbed/`.

### `aerobeat-ui-core`

Current state:

- is treated by docs and scripts as the UI logic base for kits and shells, [E-04][E-05][E-10]
- has a `.testbed/` project,
- does **not** currently have `setup_dev.py`,
- does **not** currently expose the same obvious package shape as most other addon repos. [E-01]

Impact:

- needs normalization alongside `aerobeat-core`,
- should become a clearly documented foundational dependency with the same GodotEnv conventions as core,
- is a migration blocker for UI kit and shell cleanup.

## Assembly repo

### `aerobeat-assembly-community`

Current state:

- root project, no `.testbed/`, [E-01]
- uses `.gitmodules` and a custom `setup_dev.py` to add local sibling repos as submodules, [E-02]
- setup script mutates `project.godot` plugin configuration, [E-02]
- currently references `aerobeat-core` plus `aerobeat-input-mediapipe-python` directly in its submodule flow. [E-02]

Impact:

- should own the **root `addons.jsonc`** for app/runtime dependencies,
- should be the first place where GodotEnv `tag` vs `branch` vs `symlink` policy is made concrete,
- should stop using git submodules for first-party AeroBeat repos,
- will need a deliberate plan for the `mediapipe-python` sidecar because it is not a pure addon-only dependency. [E-11]

## Feature repos

`aerobeat-feature-boxing`, `aerobeat-feature-dance`, `aerobeat-feature-flow`, and `aerobeat-feature-step` all currently follow the same pattern:

- `setup_dev.py`,
- `.testbed/`,
- clone `aerobeat-core` and `gut`,
- symlink `src/` and `test/` into `.testbed/`. [E-03]

Impact:

- these are ideal **pilot package repos** because the pattern is uniform,
- each should adopt a `.testbed`-local manifest for dev/test dependencies,
- `setup_dev.py` can become a thin GodotEnv wrapper during transition and then be removed,
- docs for feature development should stop telling contributors to run repo-specific clone scripts. [E-07]

## Input repos

### Standard input repos

`aerobeat-input-gamepad`, `aerobeat-input-joycon-hid`, `aerobeat-input-keyboard`, `aerobeat-input-mouse`, `aerobeat-input-touch`, and `aerobeat-input-xr` all follow the same general pattern as features:

- `setup_dev.py`,
- `.testbed/`,
- clone `aerobeat-core` and `gut`,
- symlink runtime/test content into `.testbed/`. [E-03]

Impact:

- these should migrate the same way as feature repos,
- `aerobeat-input-keyboard` or `aerobeat-input-mouse` are good low-risk pilots after the feature pilot.

### `aerobeat-input-mediapipe-native`

Current state:

- same overall package/testbed pattern as the other input repos,
- but has native/mobile-specific dependency concerns implied by its purpose and name.

Impact:

- should migrate to GodotEnv like the other input repos,
- but may need platform-specific dependency notes in the new docs.

### `aerobeat-input-mediapipe-python`

Current state:

- special-case repo,
- no `setup_dev.py`, but does have `.testbed/`, plugin metadata, Python sidecar code, tests, and runtime docs, [E-01][E-11]
- README documents a Python virtualenv / sidecar process flow rather than a normal package-only addon workflow. [E-11]

Impact:

- should still be treated as a package repo for the Godot-facing addon portion,
- needs explicit documentation for how GodotEnv manages the addon while Python runtime/bootstrap remains a second concern,
- should be called out as a **release engineering exception** in the migration plan.

## Tool repos

`aerobeat-tool-api` and `aerobeat-tool-settings` both match the feature/input testbed pattern:

- `setup_dev.py`,
- `.testbed/`,
- clone `aerobeat-core` and `gut`,
- symlink `src/` and `test/` into `.testbed/`. [E-04]

Impact:

- should be normalized after the foundational repos,
- are good candidates for an early post-pilot wave because they are likely lighter than UI shells and assembly.

## UI repos

### `aerobeat-ui-kit-community`

Current state:

- `setup_dev.py`,
- `.testbed/`,
- clones `aerobeat-core`, `aerobeat-ui-core`, and `gut`,
- symlinks `src/` and `test/`. [E-04]

Impact:

- should adopt a `.testbed`-local GodotEnv manifest,
- is a foundational UI dependency and should be migrated before UI shells,
- should participate in the new release/tag policy.

### UI shell repos

`aerobeat-ui-shell-desktop-community`, `aerobeat-ui-shell-mobile-community`, `aerobeat-ui-shell-web-community`, and `aerobeat-ui-shell-xr-community` currently combine:

- `setup_dev.py` for core/UI core/GUT bootstrapping, [E-04]
- `.kit_version` + `sync_ui_kit.py` for UI kit installs, [E-05]
- CI still checking out recursive submodules even though the repos are using clone/sync workflows instead. [E-09]

Impact:

- GodotEnv should replace **both** setup paths with one manifest,
- these repos need the clearest policy for `tag` vs `branch` vs `symlink`,
- `sync_ui_kit.py` is a high-confidence removal candidate after migration,
- UI shell docs currently overstate a tagged sync workflow that the repos are not actually using because `.kit_version` is on `main`. [E-05][E-10]

## Asset/supporting repo

### `aerobeat-asset-prototypes`

Current state:

- `setup_dev.py`,
- `.testbed/`,
- clones `aerobeat-core`,
- symlinks `assets/` into `.testbed/`,
- explicitly tells developers to manually clone a feature repo into `addons/` if the asset pack depends on one. [E-12]

Impact:

- this is a strong example of why a manifest-driven model is better,
- should switch to declaring the optional or required feature dependency explicitly instead of telling humans to clone things manually,
- should help define asset-package conventions in the new docs.

## Docs repo and template system

### `aerobeat-docs`

Current state:

- owns the published architecture docs, workflow docs, and contributor docs, [E-06][E-07]
- also owns the template source-of-truth under `templates/`, [E-08]
- docs currently describe the old dependency workflow and old topology assumptions. [E-06][E-07][E-10]

Impact:

- should receive the first documentation analysis and the final migration docs,
- needs both published docs changes and template-source changes,
- is the right coordination repo for the architecture cleanup plan.

### Standalone template repos

The 11 standalone template repos (`aerobeat-template-*`) are not just examples; they actively encode the old workflow and will keep reproducing it until updated. Most currently match the same `setup_dev.py` + `.testbed` conventions as the real repos. [E-01][E-04]

Impact:

- templates must be updated **before or alongside** broad repo migration,
- otherwise every new repo will keep generating obsolete bootstrap scripts.

---

## Repo-by-repo GodotEnv impact map

| Repo | Type | Current dependency/setup state | GodotEnv-centered target | Likely cleanup / removal work |
| --- | --- | --- | --- | --- |
| `aerobeat-assembly-community` | assembly | Root `setup_dev.py`; real `.gitmodules`; local-path submodules; manual plugin patching. [E-02] | Root `addons.jsonc` for app/runtime deps; documented `tag`/`branch`/`symlink` modes. | Remove `.gitmodules`; remove submodule add/update logic; replace project mutation flow with manifest-driven install policy. |
| `aerobeat-asset-prototypes` | asset/supporting | `setup_dev.py`; `.testbed`; clones core; symlinks `assets`; manual note to clone feature deps yourself. [E-12] | `.testbed` manifest declaring core and any feature dependency explicitly. | Remove manual clone note; replace asset symlink bootstrap with documented GodotEnv-backed dev flow. |
| `aerobeat-core` | contract/core | Foundational repo; `.testbed`; no `setup_dev.py`; consumed everywhere. [E-01][E-03] | First-class foundational package with clear version/tag policy and dev manifest. | Add normalized GodotEnv docs/metadata; establish tag discipline. |
| `aerobeat-docs` | docs | No package manifest; publishes docs and owns template source-of-truth. [E-06][E-08] | New architecture docs and template guidance; not a runtime package consumer. | Update docs pages, contributor guidance, and template sources. |
| `aerobeat-feature-boxing` | feature | `setup_dev.py`; `.testbed`; core + GUT clone; symlink `src`/`test`. [E-03] | `.testbed` manifest for dev deps; publishable addon package. | Replace/remove `setup_dev.py`; update feature dev docs. |
| `aerobeat-feature-dance` | feature | Same pattern as Boxing. [E-03] | Same as Boxing. | Same cleanup as Boxing. |
| `aerobeat-feature-flow` | feature | Same pattern as Boxing. [E-03] | Same as Boxing. | Same cleanup as Boxing. |
| `aerobeat-feature-step` | feature | Same pattern as Boxing. [E-03] | Same as Boxing. | Same cleanup as Boxing. |
| `aerobeat-input-gamepad` | input | `setup_dev.py`; `.testbed`; core + GUT clone. [E-03] | `.testbed` manifest for dev deps. | Remove `setup_dev.py`; align docs/template. |
| `aerobeat-input-joycon-hid` | input | Same standard input pattern. [E-03] | Same as above. | Same cleanup. |
| `aerobeat-input-keyboard` | input | Same standard input pattern. [E-03] | Same as above. | Same cleanup; good low-risk pilot. |
| `aerobeat-input-mediapipe-native` | input | `setup_dev.py`; `.testbed`; core + GUT clone; native/mobile flavor. [E-01] | Same manifest model plus platform notes. | Remove `setup_dev.py`; add platform-specific docs. |
| `aerobeat-input-mediapipe-python` | input | No `setup_dev.py`; `.testbed`; plugin + Python sidecar + tests. [E-11] | Treat addon deps via GodotEnv; document Python runtime separately. | No broad script removal, but add explicit sidecar/install policy and assembly integration docs. |
| `aerobeat-input-mouse` | input | Standard input pattern. [E-03] | `.testbed` manifest for dev deps. | Remove `setup_dev.py`. |
| `aerobeat-input-touch` | input | Standard input pattern. [E-03] | `.testbed` manifest for dev deps. | Remove `setup_dev.py`. |
| `aerobeat-input-xr` | input | Standard input pattern. [E-03] | `.testbed` manifest for dev deps. | Remove `setup_dev.py`. |
| `aerobeat-template-assembly` | template | Root `setup_dev.py`; root `addons/`; no `.testbed`; mirrors old assembly pattern. [E-04][E-08] | Emit root `addons.jsonc` for new assembly repos. | Remove old bootstrap script from template output. |
| `aerobeat-template-asset` | template | Asset-style `setup_dev.py`; `.testbed`; core clone. [E-01][E-04] | Emit `.testbed` manifest and asset-package conventions. | Remove old bootstrap script from template output. |
| `aerobeat-template-avatar` | template | Asset-style template with old setup script. [E-01] | Emit `.testbed` manifest and avatar package conventions. | Remove old bootstrap script from template output. |
| `aerobeat-template-cosmetic` | template | Asset-style template with old setup script. [E-01] | Emit `.testbed` manifest and cosmetic package conventions. | Remove old bootstrap script from template output. |
| `aerobeat-template-environment` | template | Asset-style template with old setup script. [E-01] | Emit `.testbed` manifest and environment package conventions. | Remove old bootstrap script from template output. |
| `aerobeat-template-feature` | template | Feature-style `setup_dev.py`; `.testbed`; core + GUT pattern. [E-04] | Emit `.testbed` manifest for feature repos. | Remove old bootstrap script from template output. |
| `aerobeat-template-input` | template | Input-style `setup_dev.py`; `.testbed`; core + GUT pattern. [E-04] | Emit `.testbed` manifest for input repos. | Remove old bootstrap script from template output. |
| `aerobeat-template-skin` | template | Asset-style template with old setup script. [E-01] | Emit `.testbed` manifest and skin package conventions. | Remove old bootstrap script from template output. |
| `aerobeat-template-tool` | template | Tool-style `setup_dev.py`; `.testbed`; core + GUT pattern. [E-04] | Emit `.testbed` manifest for tool repos. | Remove old bootstrap script from template output. |
| `aerobeat-template-ui-kit` | template | UI kit template with core + UI core + GUT bootstrap. [E-04] | Emit `.testbed` manifest for UI kit repos. | Remove old bootstrap script from template output. |
| `aerobeat-template-ui-shell` | template | UI shell template with `setup_dev.py` + `.kit_version` + `sync_ui_kit.py`. [E-05] | Emit one manifest-driven shell dependency model. | Remove `sync_ui_kit.py`; remove `.kit_version`; remove old bootstrap script. |
| `aerobeat-tool-api` | tool | `setup_dev.py`; `.testbed`; core + GUT pattern. [E-04] | `.testbed` manifest for tool deps. | Remove `setup_dev.py`. |
| `aerobeat-tool-settings` | tool | `setup_dev.py`; `.testbed`; core + GUT pattern. [E-04] | `.testbed` manifest for tool deps. | Remove `setup_dev.py`. |
| `aerobeat-ui-core` | ui-core | Foundational UI contract repo; `.testbed`; no `setup_dev.py`. [E-01][E-10] | First-class foundational package with explicit GodotEnv conventions. | Normalize package docs/metadata and release policy. |
| `aerobeat-ui-kit-community` | ui-kit | `setup_dev.py`; `.testbed`; core + UI core + GUT pattern. [E-04] | `.testbed` manifest for kit deps; taggable addon package. | Remove `setup_dev.py`; align with new release policy. |
| `aerobeat-ui-shell-desktop-community` | ui-shell | `setup_dev.py` + `.kit_version` + `sync_ui_kit.py`; `.testbed`. [E-04][E-05] | Single shell manifest covering core, UI core, kit, and dev deps. | Remove `setup_dev.py`; remove `sync_ui_kit.py`; remove `.kit_version`. |
| `aerobeat-ui-shell-mobile-community` | ui-shell | Same as desktop shell. [E-04][E-05] | Same as desktop shell. | Same cleanup. |
| `aerobeat-ui-shell-web-community` | ui-shell | Same as desktop shell. [E-04][E-05] | Same as desktop shell. | Same cleanup; keep web-specific constraints in docs. |
| `aerobeat-ui-shell-xr-community` | ui-shell | Same as desktop shell. [E-04][E-05] | Same as desktop shell. | Same cleanup; keep XR-specific notes in docs. |

### Highest-confidence removal candidates

These are the obsolete workflow artifacts most likely to be deleted after migration:

1. **Repo-local `setup_dev.py` scripts** in the 31 repos that still carry them. [E-01]
2. **`sync_ui_kit.py` + `.kit_version`** in the 4 community UI shell repos and the UI shell template. [E-05]
3. **`.gitmodules` and submodule logic** in `aerobeat-assembly-community`. [E-02]
4. **`submodules: recursive` checkout flags** in repo/template CI where submodules are no longer part of the architecture. [E-09]
5. **Docs text that describes submodules / setup scripts as the primary dependency model**. [E-06][E-07][E-10]

### Best candidates for transitional wrappers

For one migration phase, these can stay as thin compatibility shims that call the new manifest-driven install flow:

- feature/input/tool/UI kit `setup_dev.py`,
- assembly `setup_dev.py`,
- shell `sync_ui_kit.py`.

If kept temporarily, they should print a deprecation notice and point developers to the new GodotEnv docs.

---

## Docs revision map

## Pages that explicitly describe the old workflow and should be revised first

| Path | Current issue | Required change |
| --- | --- | --- |
| `docs/architecture/workflow.md` | Says dependency management is via git submodules managed through `setup_dev`; documents `.testbed` cloning workflow. [E-06] | Rewrite around GodotEnv manifests, dependency modes, and `.testbed` expectations. |
| `docs/guides/contributing_workflow.md` | Tells contributors to run `python setup_dev.py` before working. [E-07] | Replace with GodotEnv install/update flow and repo-type-specific guidance. |
| `docs/licensing/CONTRIBUTING.md` | Says contributors should use the included `./setup_dev` script. [E-08] | Replace with manifest-driven setup instructions. |
| `docs/architecture/testing.md` | Says GUT is included as a submodule in `aerobeat-core`. [E-09] | Update to describe GUT as a dev dependency managed through testbed manifests. |
| `docs/architecture/ui-ux.md` | Describes `sync_ui_kit` / `.kit_version` as the shell dependency workflow and implies tag sync discipline not seen in current community shell configs. [E-05][E-10] | Replace with GodotEnv-based shell/kit dependency model. |
| `docs/architecture/topology.md` | Defines the repo topology around dev-only/testbed scaffolding installed via `setup_dev.py`. [E-10] | Keep topology, rewrite dependency/install mechanics. |
| `docs/architecture/overview.md` | Still frames the architecture around the old hub-and-spoke picture without the new manifest contract. [E-10] | Add a concise GodotEnv dependency overview and point to the dedicated page. |
| `docs/architecture/repo-structure-reference.md` | Several examples appear stale relative to current repo shapes. [E-09] | Refresh examples around actual repo structures and `.testbed` conventions. |
| `docs/architecture/repository-map.md` | Repo inventory exists, but not migration-aware. [E-10] | Add or link a dependency-management appendix / GodotEnv migration note. |

## Template and source-of-truth files that also need revision

| Path | Why it matters | Required change |
| --- | --- | --- |
| `templates/README.md` | Says template output is built around `setup_dev.py` and old project location rules. [E-08] | Reframe templates around manifest-driven dependency setup. |
| `templates/assembly/setup_dev.py` | Encodes the old root-addons bootstrap. [E-04] | Replace with manifest file and, if needed, temporary wrapper. |
| `templates/feature/setup_dev.py` | Encodes clone + symlink `.testbed` workflow. [E-03] | Replace with manifest file and documented `.testbed` layout. |
| `templates/input/setup_dev.py` | Same issue. [E-04] | Same change. |
| `templates/tool/setup_dev.py` | Same issue. [E-04] | Same change. |
| `templates/ui-kit/setup_dev.py` | Same issue. [E-04] | Same change. |
| `templates/ui-shell/setup_dev.py` | Same issue. [E-04] | Same change. |
| `templates/ui-shell/sync_ui_kit.py` | Encodes the separate shell sync model. [E-05] | Remove in favor of one manifest-driven dependency story. |
| `templates/*/.gitignore` | Comments still say deps are managed by `setup_dev.py`. [E-04] | Update comments and ignore rules to match GodotEnv caches/install conventions. |
| `templates/*/.github/workflows/gut_ci.yml` | Still checks out submodules recursively. [E-09] | Update CI bootstrapping to use manifest-driven dependency restore. |

## Proposed new documentation section/page

Recommended new primary page:

- **`docs/architecture/godotenv-dependency-management.md`**

Recommended section outline:

1. **Why AeroBeat uses GodotEnv**
   - replace submodules/setup scripts
   - one manifest contract for app and package repos

2. **Supported dependency modes**
   - `tag`: stable/release consumption
   - `branch`: active cross-repo development
   - `symlink`: local sibling repo development

3. **Repo conventions by repo type**
   - foundational package repos (`aerobeat-core`, `aerobeat-ui-core`)
   - package repos (feature/input/tool/UI kit)
   - UI shell repos
   - assembly repos
   - asset-style repos
   - docs/templates ownership

4. **`.testbed` expectations**
   - what lives in `.testbed/`
   - what gets symlinked vs what is installed via manifest
   - what stays dev-only

5. **`aerobeat-core` and `aerobeat-ui-core` responsibilities**
   - contract boundaries
   - what other repos can assume
   - release/tag expectations

6. **Migration compatibility notes**
   - temporary wrappers
   - when `setup_dev.py` is still acceptable
   - when `sync_ui_kit.py` is considered deprecated

7. **CI and contributor workflow**
   - how dependencies get restored in automation
   - what contributors run locally

---

## Execution-ready migration plan

## Recommended sequencing

### Phase 0 — Decide the contract and write the docs first

**Objective:** lock the target conventions before mass repo edits.

Deliverables:

- approve the GodotEnv page structure,
- decide exact manifest file naming (`addons.jsonc` recommended where comments help),
- define the official meaning of `tag`, `branch`, and `symlink` for AeroBeat,
- define whether `.testbed` manifests live inside `.testbed/`, repo root, or both.

Why first:

- otherwise every repo migration will invent its own interpretation.

### Phase 1 — Normalize the foundations

**Pilot/foundation repos:**

- `aerobeat-core`
- `aerobeat-ui-core`
- `aerobeat-ui-kit-community`

**Objective:** prove the foundational dependency chain works with the new model.

Deliverables:

- explicit manifest policy for `core` and `ui-core`,
- release/tag discipline for these foundational repos,
- one working UI kit flow that no longer depends on `setup_dev.py`.

### Phase 2 — Migrate one simple package family end-to-end

**Best first pilot:**

- `aerobeat-feature-boxing`

**Alternative low-risk pilots:**

- `aerobeat-input-keyboard`
- `aerobeat-tool-settings`

**Objective:** prove the standard package-repo `.testbed` flow.

Deliverables:

- working `.testbed` manifest-driven dev setup,
- transitional wrapper or direct GodotEnv command flow,
- updated README / contributor instructions for the pilot repo.

### Phase 3 — Collapse the UI shell special case

**Repos:**

- `aerobeat-ui-shell-desktop-community`
- `aerobeat-ui-shell-mobile-community`
- `aerobeat-ui-shell-web-community`
- `aerobeat-ui-shell-xr-community`
- `aerobeat-template-ui-shell`

**Objective:** replace `setup_dev.py` plus `sync_ui_kit.py` plus `.kit_version` with one manifest-driven flow.

Deliverables:

- one shell dependency model,
- deprecation/removal of `sync_ui_kit.py`,
- updated shell docs and template output.

### Phase 4 — Migrate the assembly repo

**Repo:**

- `aerobeat-assembly-community`

**Objective:** remove submodules and make the assembly the canonical consumer app.

Deliverables:

- root `addons.jsonc`,
- no `.gitmodules`,
- documented dependency modes for local dev vs stable builds,
- explicit strategy for `aerobeat-input-mediapipe-python` sidecar integration.

### Phase 5 — Sweep templates, docs, and CI

**Repos/files:**

- `aerobeat-docs`
- `aerobeat-docs/templates/*`
- all standalone `aerobeat-template-*` repos
- repo/template GitHub Actions

**Objective:** stop regenerating or teaching the old workflow.

Deliverables:

- all published docs updated,
- templates generating the new manifest-based structure,
- CI bootstrapping updated away from recursive submodule assumptions,
- all deprecation notes removed when the family is fully migrated.

## Suggested bead/task breakdown for execution

1. **Foundations bead** — define manifest conventions and migrate `aerobeat-core` + `aerobeat-ui-core`.
2. **UI base bead** — migrate `aerobeat-ui-kit-community` and prove the `ui-core` chain.
3. **Standard package pilot bead** — migrate one feature repo.
4. **Standard package wave bead** — migrate remaining feature/input/tool repos sharing the same pattern.
5. **UI shell bead** — remove `.kit_version` / `sync_ui_kit.py` from community shells.
6. **Assembly bead** — remove submodules and adopt root manifest.
7. **Docs bead** — update published docs pages.
8. **Template source bead** — update `aerobeat-docs/templates/*`.
9. **Standalone template repos bead** — sync/update `aerobeat-template-*` repos.
10. **CI cleanup bead** — remove recursive submodule assumptions and align test dependency restore.
11. **Mediapipe sidecar bead** — clarify the `aerobeat-input-mediapipe-python` packaging/release story.

## Main risk areas

### 1. No established tag discipline yet

The earlier dependency research found no working tagged-release habit in sampled repos. GodotEnv can support `tag` mode, but AeroBeat first has to start producing and trusting tags. [E-13]

### 2. `.testbed` is useful and should not be removed accidentally

A migration that treats `.testbed` itself as legacy will likely hurt developer ergonomics. The old part is the bootstrap method, not the local dev project concept. [E-06][E-07]

### 3. UI shells currently have two dependency systems

If `sync_ui_kit.py` is removed before a replacement manifest flow is proven, shell repos could get temporarily worse rather than better. [E-05]

### 4. `aerobeat-input-mediapipe-python` is not a normal addon-only repo

Its Python runtime/install story has to be documented separately from the addon dependency story or the assembly migration will stay muddy. [E-11]

### 5. Docs/templates are a second source of architecture truth

Even if code repos migrate successfully, stale docs or templates will reintroduce the old pattern immediately. [E-08]

## Recommended migration policy

- **Do not mass-delete scripts on day one.** Convert them to temporary wrappers first where needed.
- **Do not migrate assembly first.** Migrate the foundations and one standard package flow before touching the consumer app.
- **Do update docs early.** Even a temporary migration guide is better than letting contributors follow obsolete instructions.
- **Do call out exceptions explicitly.** `aerobeat-input-mediapipe-python` should be documented as a sidecar-bearing package, not treated like a basic input repo.

---

## Most important conclusions

1. **AeroBeat is already package-shaped, but not manifest-driven yet.** The repo graph is ready for GodotEnv; the install workflow is what is stale.
2. **The cleanup is broad but highly repetitive.** Once one standard `.testbed` package repo is migrated, most feature/input/tool/template repos should follow the same pattern.
3. **The assembly repo and UI shell repos are the two special cases.** Assembly has the real submodule problem; shells have the extra `.kit_version` / `sync_ui_kit.py` problem.
4. **Docs and templates are part of the architecture.** They currently teach and regenerate the old workflow, so they must be migrated with the code repos.
5. **`aerobeat-core` and `aerobeat-ui-core` must go first.** Everything else assumes them.

---

## Evidence index

| ID | Evidence | Path |
| --- | --- | --- |
| `E-01` | Repo-family audit counts and repo inventory from shell scan | `projects/aerobeat/*` |
| `E-02` | Assembly submodule workflow, local file URLs, and `project.godot` patching | `aerobeat-assembly-community/setup_dev.py`, `aerobeat-assembly-community/.gitmodules` |
| `E-03` | Standard feature/input package bootstrap pattern (`core` + `gut` + symlinked `.testbed`) | `aerobeat-feature-boxing/setup_dev.py` |
| `E-04` | Standard tool/UI/package/template bootstrap variants | `aerobeat-ui-kit-community/setup_dev.py`, `aerobeat-ui-shell-desktop-community/setup_dev.py`, `aerobeat-tool-api/setup_dev.py`, `aerobeat-template-feature/setup_dev.py`, `aerobeat-template-assembly/setup_dev.py` |
| `E-05` | UI shell `.kit_version` and `sync_ui_kit.py` flow | `aerobeat-ui-shell-desktop-community/.kit_version`, `aerobeat-ui-shell-desktop-community/sync_ui_kit.py`, `aerobeat-docs/templates/ui-shell/sync_ui_kit.py` |
| `E-06` | Docs page describing submodules / `setup_dev` / `.testbed` as primary workflow | `aerobeat-docs/docs/architecture/workflow.md` |
| `E-07` | Contributor workflow still telling users to run `python setup_dev.py` | `aerobeat-docs/docs/guides/contributing_workflow.md` |
| `E-08` | Docs repo template source-of-truth and template architecture | `aerobeat-docs/templates/README.md` |
| `E-09` | Testing docs and CI still assume submodule-oriented bootstrapping | `aerobeat-docs/docs/architecture/testing.md`, `aerobeat-ui-shell-desktop-community/.github/workflows/gut_ci.yml` |
| `E-10` | Topology/UI architecture/repository map docs still frame the old dependency model | `aerobeat-docs/docs/architecture/topology.md`, `aerobeat-docs/docs/architecture/ui-ux.md`, `aerobeat-docs/docs/architecture/overview.md`, `aerobeat-docs/docs/architecture/repository-map.md` |
| `E-11` | MediaPipe Python sidecar shape and runtime/install complexity | `aerobeat-input-mediapipe-python/README.md` |
| `E-12` | Asset package setup script that still requires manual feature cloning | `aerobeat-asset-prototypes/setup_dev.py` |
| `E-13` | Earlier package dependency research memo recommending GodotEnv and calling out missing tag discipline | `aerobeat-docs/docs/architecture/package-dependency-research.md` |
