# AeroBeat Package Dependency Research

_Date: 2026-04-17_

## Executive summary

**Short answer:** AeroBeat can get **part of the way** to an npm-style dependency workflow, but **not as a single universal package system in the Chickensoft sense**.

- **Chickensoft's strongest packaging story is for Godot C# code distributed as NuGet packages.** That works well for **compiled C# libraries**, not for Godot scenes, GDScript assets, textures, audio, or whole addon folders.[^S1][^S2][^S3]
- **Godot's native/addon workflow for asset-bearing packages is still folder-based**: packages are copied into `addons/` (or otherwise into the project tree), then optionally enabled if they are true editor plugins.[^S5][^S6]
- **Chickensoft GodotEnv is the closest official tool to an npm-like addon workflow** for Godot assets. It gives AeroBeat a manifest-driven install flow (`addons.json` / `addons.jsonc`), supports installs from remote git repos, local repos, or symlinks, supports `checkout` values that can be branches or tags, and allows addons to declare dependencies in a **flat dependency graph**.[^S4]
- For AeroBeat's current repos, which are overwhelmingly **GDScript/addon-oriented** and contain **scenes + assets + hidden `.testbed` projects**, the best fit is a **Godot addon package model with version-pinned git tags**, not NuGet-first packaging.[^L1][^L2][^L3][^L4][^L5][^L6]
- If AeroBeat wants production builds that **do not always ship every feature's assets/code**, that is **not solved by package installation alone**. Godot handles shipping through **export presets, resource include/exclude rules, hidden-folder exclusion, and optional PCK/ZIP packs**, not through npm-style tree shaking.[^S7][^S8][^S9][^S10]

## Verdict

### Requested architecture vs current tooling

| Question | Answer |
| --- | --- |
| Can `aerobeat-assembly-community` consume reusable versioned dependencies? | **Yes, partially.** Best fit is addon packages installed into `addons/` from tagged git releases, optionally mixed with NuGet for pure C# libraries. |
| Can AeroBeat get true `node_modules` semantics for Godot packages? | **No, not natively.** GodotEnv uses a **flat addon dependency graph**, and Godot assets live in project paths like `res://addons/...`, not isolated nested package directories.[^S4][^S5] |
| Does Chickensoft support versioned reusable dependencies? | **Yes, but split by package type.** NuGet for reusable C# code; GodotEnv-managed addons for scenes/assets/addons.[^S1][^S2][^S3][^S4] |
| Is Chickensoft alone a full answer for AeroBeat's current GDScript-heavy package graph? | **No.** It is a **partial fit**. Chickensoft helps most with C# packages and addon installation, but not with asset-aware versioned dependency isolation or build-time asset stripping. |

## What AeroBeat is doing today

AeroBeat's current workflow is already package-like in intent, but not in release/install mechanics.

### Current assembly consumer behavior

`aerobeat-assembly-community/setup_dev.py` currently wires dependencies in through **git submodules from sibling local paths**, specifically `../aerobeat-core` and `../aerobeat-input-mediapipe-python`, then updates `project.godot` plugin configuration.[^L1] The repo's `.gitmodules` pins those sources as local `file://` URLs on `main`, not release tags.[^L2]

### Current feature/UI package behavior

Feature and UI repos are structured like reusable packages already:

- `aerobeat-feature-boxing/setup_dev.py` clones `aerobeat-core` and GUT into `.testbed/addons`, then symlinks `src/` and `test/` into the hidden `.testbed/` project.[^L3]
- `aerobeat-ui-kit-community/setup_dev.py` clones `aerobeat-core`, `aerobeat-ui-core`, and GUT into `.testbed/addons`, then symlinks `src/` and `test/`.[^L4]
- `aerobeat-ui-shell-desktop-community/setup_dev.py` does the same for `aerobeat-core`, `aerobeat-ui-core`, and GUT.[^L5]

The topology docs already describe this as a layered dependency system where assemblies consume active packages and dev-only dependencies are cloned into local testbeds.[^L6]

### Current hard evidence from the repo set

- The sampled AeroBeat repos currently have **no local git tags** and `ls-remote --tags origin` returned no remote tags for the sampled package repos during this research. That means a tag-pinned workflow is **possible**, but **not yet established**.
- A scan of the AeroBeat repo set found **no `.csproj`, `.sln`, or `global.json` files**, which means the current architecture is **not presently using Chickensoft's C#/NuGet project model**.
- The package repos commonly contain hidden `.testbed/` projects, plugin metadata, tests, and runtime source folders, which strongly matches a **Godot addon/package** model rather than a NuGet library model.[^L3][^L4][^L5]

## What Chickensoft officially supports

## 1) Reusable C# packages via NuGet

Chickensoft's setup docs explicitly separate two reuse modes:

- **NuGet packages** for sharing **compiled source code** between Godot C# projects.[^S1]
- **Godot Asset Library/addon packages** for sharing **code plus resource files** like scenes, textures, music, and other non-C# assets.[^S1]

Chickensoft's "How C# Works in Godot" doc makes the limitation sharper:

- Godot C# projects are standard `.sln`/`.csproj` projects.
- External packages can be referenced like any normal .NET project.
- But only **plain C# code files** modularize cleanly into packages.
- **Script assets** attached to Godot scenes/resources are different from loose code files and are path-sensitive inside the engine.[^S2]

That distinction matters a lot for AeroBeat. A repo like `aerobeat-feature-boxing` is not just loose code; it is meant to carry Godot-facing gameplay logic and probably scenes/resources over time. That means it does **not** naturally become a NuGet package without narrowing it down to code-only logic.

### Chickensoft GodotPackage template

The official `GodotPackage` template is for creating a **C# NuGet package** for Godot 4.[^S3]

It provides:

- CI/testing scaffolding
- a Godot-based test project via GoDotTest
- release automation that can publish to **GitHub and NuGet**
- versioning around the Godot/.NET SDK ecosystem[^S3]

That is strong evidence that Chickensoft supports **reusable, versioned Godot-adjacent C# libraries**. But it is still a **code library workflow**, not a whole-Godot-addon workflow.

## 2) Reusable addons via GodotEnv

Chickensoft's `GodotEnv` README describes it as both a Godot version manager and an **addon manager**.[^S4]

Important capabilities:

- installs addons from **remote git repositories**, **local git repositories**, or **symlinks**[^S4]
- uses an `addons.json`/`addons.jsonc` manifest[^S4]
- supports a `checkout` field that can point to a **branch or tag**[^S4]
- allows addons to declare dependencies in a **flat dependency graph**[^S4]
- intentionally avoids git submodule pain by reinstalling addons from the manifest[^S4]

This is the Chickensoft tool that most closely matches AeroBeat's desired consumer-app workflow.

### Where it matches npm-style expectations

- consumer repo keeps a **dependency manifest**
- dependencies can be **pinned to tags**
- local development can use **symlinks**
- switching branches/reinstalling is cleaner than submodules
- package repos can remain independent git repos

### Where it does not match npm

- dependencies install into the Godot project's **`addons/` path**, not an isolated nested dependency tree
- the dependency graph is explicitly **flat**, so multiple versions of the same addon are not a normal supported pattern[^S4]
- asset/resource paths remain Godot project paths (`res://...`), so package isolation is much weaker than `node_modules`

## Godot constraints that matter for AeroBeat

## 1) Asset-bearing packages are folder-based, not NuGet-native

Godot's official plugin docs say installation is fundamentally: download the package, extract it, and move its `addons/` folder into the project.[^S6]

This is a strong sign that **asset-bearing reuse in Godot is still filesystem/project-tree oriented**. Godot can consume packaged assets, but they must end up in project paths the engine can import and resolve.

## 2) Hidden dev folders are safe for `.testbed`

Godot's export docs explicitly state that **files and folders whose name begin with a period are never included in exported projects**.[^S7]

That means AeroBeat's current `.testbed/` pattern is actually a good fit for package repos:

- keep dev/test scaffolding in `.testbed/`
- keep package runtime assets in visible runtime folders (`src/`, `addons/...`, scenes/assets folders)
- exports naturally omit `.testbed/` without special stripping logic[^S7]

So the desired requirement that package repos may still contain `.testbed` assets for unit/E2E/dev work is **supported today**.

## 3) Export inclusion is explicit, not automatic tree shaking

Godot export works by choosing resource modes and filters:

- export all resources
- export selected scenes/resources and dependencies
- export all except selected resources
- include/exclude additional file patterns[^S7]

This is useful, but it is **not npm-style dead-code elimination**. If a feature package has scenes, textures, or sidecar files present in the project, whether they ship depends on export configuration and dependency reachability, not package manager semantics alone.

## 4) Optional content is best handled with separate packs

Godot officially supports **PCK/ZIP resource packs** for DLC, patches, and mods, and can load them at runtime with `ProjectSettings.load_resource_pack(...)`.[^S8]

That is relevant because AeroBeat's desire to avoid shipping every game mode or asset in every production build is often better served by:

- separate export presets, and/or
- separate feature PCK packs loaded on demand

rather than trying to make one monolithic installed dependency tree behave like a tree-shaken web bundle.

## 5) Feature tags are runtime/build-environment signals, not asset stripping

Godot feature tags let code check platform/build conditions at runtime (`OS.has_feature()` / `OS.HasFeature()`), and they are used by GDExtension to pick the right native library for a platform/build combination.[^S9]

That helps with **conditional behavior** and platform-specific native binaries. It does **not** by itself remove unwanted scenes/textures/scripts from the export. For that, export configuration or separate packs still matter.[^S7][^S8][^S9]

## 6) C# define symbols only solve code paths

Standard .NET projects can use `DefineConstants` for conditional compilation across the whole project.[^S10]

So if AeroBeat later creates C# libraries for some systems, it can use compilation symbols to include/exclude code paths. But that only helps for **compiled C# code**. It does **not** automatically strip Godot scenes/resources/addons from the exported game.[^S7][^S10]

## Fit analysis against AeroBeat's requested package graph

## `aerobeat-assembly-community` as the consumer app

**Supported, with caveats.** The assembly repo can absolutely become the consumer app that declares dependency versions. The cleanest path is:

- assembly owns the dependency manifest
- package repos publish git tags/releases
- assembly installs them into `addons/` via GodotEnv or a thin wrapper around it
- local development uses symlink mode for active package work

That gets close to the desired "consumer app installs packages" model.

## Community game modes: boxing, dance, flow, step

**Supported best as addon packages, not NuGet packages.**

These repos are gameplay packages that will likely include Godot-facing scripts/scenes/assets. They should be treated as **versioned addons** installed into `addons/feature-*` (or similarly namespaced folders), pinned to git tags.

If some internal logic later becomes pure C# with no scene/resource coupling, that logic could be split into separate NuGet libraries. But the feature package as a whole is more naturally a Godot addon package.

## Input dependencies including `mediapipe-python`

**Partially supported; repo install is easy, runtime packaging is harder.**

The Godot-facing part of `aerobeat-input-mediapipe-python` fits the addon model. But the Python sidecar brings extra concerns:

- Python runtime/dependencies are outside normal Godot addon semantics
- export may need explicit inclusion/exclusion for non-resource files[^S7]
- desktop packaging of the Python runtime/venv remains a custom release engineering problem
- mobile/web targets are a separate problem entirely

So the repo can be consumed as a versioned dependency, but a fully polished production package flow for this dependency still needs **custom process/tooling**.

## UI dependencies including `ui-shell` and `ui-kit`

**Supported best as addon packages.**

`ui-kit` is a strong match for a versioned addon package. `ui-shell` can also be versioned this way if the assembly chooses among shells or consumes one shell package per target platform.

A practical caution: if the shell is effectively the app's top-level scene and navigation layer, it may be simpler for the assembly to own shell selection and include only the chosen shell package in a given export.

## Pinned tagged releases

**Supported in principle, not yet practiced in the sampled AeroBeat repos.**

GodotEnv supports `checkout` values for tags/branches, GitHub releases work fine for addon zips, and Godot's plugin docs explicitly recommend downloading stable tagged releases when available.[^S4][^S6]

But the sampled AeroBeat repos currently show **no tags**, so a release discipline would need to be introduced before this becomes real.

## Build variants that should not ship every dependency asset/code path

**Only partially supported.**

What works today:

- hidden `.testbed/` folders stay out of exports automatically[^S7]
- C# code can use compilation symbols via `DefineConstants` if AeroBeat adopts C# projects for some modules[^S10]
- export presets can explicitly include/exclude resources[^S7]
- optional modes/assets can be split into PCK/ZIP packs[^S8]

What still needs custom process/tooling:

- deciding which package folders/resources are present for each SKU/build
- keeping export preset resource lists synchronized with package manifests
- bundling non-Godot sidecars like Python cleanly per platform
- creating a single lockfile-like experience across addons, sidecars, and any future NuGet packages

## Major mismatches and hard constraints

## 1) Chickensoft C# packaging does not map directly onto today's AeroBeat repos

AeroBeat is currently structured as addon repos with GDScript/testbeds, not as C# solution/package repos. Chickensoft's NuGet story is excellent for C# libraries, but **AeroBeat would have to rewrite or split large parts of the system** to benefit from it directly.

## 2) C# is a poor fit if web export matters

Godot's official C# docs state that **Godot 4 C# projects currently cannot be exported to the web platform**.[^S5]

That matters because AeroBeat's repo map includes a `aerobeat-ui-shell-web-community` target.[^L7] If web remains in scope, a C#-first Chickensoft package architecture is not a universal answer.

## 3) Flat addon graphs are not `node_modules`

GodotEnv explicitly uses a **flat dependency graph** for addons.[^S4]

That means:

- no natural support for nested multiple versions of the same package
- package authors must coordinate on shared addon versions
- dependency conflicts are closer to Unity/Godot addon management than npm's nested install model

## 4) Godot asset paths remain real project paths

Godot resources are imported and resolved by project path. This is why addon installation ultimately lands inside the project tree and why script assets are treated differently from loose C# code files.[^S2][^S6]

That limits how far AeroBeat can push fully isolated package semantics without building a lot of custom tooling on top.

## Recommended target architecture

## Recommendation

Adopt a **hybrid addon-first architecture**:

1. **Keep asset-bearing AeroBeat repos as Godot addon packages**.
   - features
   - input drivers
   - UI kit
   - UI shells

2. **Use a manifest-driven installer for the assembly repo**.
   - Prefer `GodotEnv` directly, or a thin AeroBeat wrapper around it.
   - Pin packages to **git tags** rather than branches.
   - Use symlink/local modes for active package development.

3. **Reserve NuGet/Chickensoft GodotPackage for pure C# libraries only**.
   - internal logic libs
   - tooling helpers
   - serialization/state-machine/util layers that do not need scenes/resources

4. **Handle optional shipping with export presets and/or PCK packs**.
   - do not rely on package install mechanics alone to keep final builds lean

### Why this is the best fit

It gives AeroBeat most of the desired ergonomics:

- versioned dependencies
- consumer-app-owned dependency manifest
- independent package repos
- tagged release pinning
- local dev linking
- `.testbed` dev scaffolding in package repos

while staying aligned with how Godot actually handles assets and exports.

## Suggested migration experiments

### Experiment 1: Replace one assembly submodule with a manifest-managed addon install

Use `aerobeat-core` as the first target.

Success criteria:

- `aerobeat-assembly-community` installs `aerobeat-core` into `addons/` from a git tag
- local dev can swap to symlink mode cleanly
- branch switching is easier than the current submodule setup

### Experiment 2: Add release tags to 2-3 foundational repos

Start with:

- `aerobeat-core`
- `aerobeat-ui-core`
- `aerobeat-ui-kit-community`

Success criteria:

- semantic version tags exist
- install manifest pins exact versions
- upgrade/downgrade flow is documented and repeatable

### Experiment 3: Prove `.testbed` stays dev-only

Export a package-consuming assembly build and confirm:

- `.testbed/` content is omitted from exports
- tests and GUT scaffolding do not leak into shipping artifacts
- only the intended runtime addon content is included

### Experiment 4: Package one optional mode as a separate PCK

Use one feature package, likely `boxing`, as the first optional content pack.

Success criteria:

- base assembly exports without the boxing feature assets
- boxing content can be delivered as a PCK and loaded intentionally
- startup/content discovery flow remains sane

### Experiment 5: Isolate the `mediapipe-python` release story

Decide whether the Python sidecar is:

- vendored into the assembly build,
- packaged as a separate downloadable runtime dependency, or
- replaced over time by a native/mobile-specific input package.

Success criteria:

- one documented release/install path per supported platform
- no ambiguity about what the addon provides vs what the sidecar provides

## Final answer

If Derrick's question is:

> "Can AeroBeat move to a versioned dependency model where `aerobeat-assembly-community` consumes tagged packages like an app consumes npm dependencies?"

**Answer: yes, partially.**

If the question is:

> "Can Chickensoft give AeroBeat a single npm-equivalent package manager for Godot code + scenes + assets + sidecars + build stripping?"

**Answer: no, that is a mismatch.**

The realistic, credible architecture is:

- **Godot addon packages + manifest-driven installs** for feature/input/UI repos
- **NuGet packages** only for pure C# reusable libraries
- **export presets and/or PCK packs** for keeping production builds lean
- **custom wrapper/process** only where AeroBeat needs stronger lockfile/release ergonomics or sidecar packaging

That gets AeroBeat close to the requested model without fighting Godot's core assumptions.

## Sources

### External / official

[^S1]: Chickensoft, "Godot 4 C# Setup Guide" — https://chickensoft.games/docs/setup
[^S2]: Chickensoft, "How C# Works in Godot" — https://chickensoft.games/docs/how_csharp_works
[^S3]: Chickensoft `GodotPackage` template — https://github.com/chickensoft-games/GodotPackage
[^S4]: Chickensoft `GodotEnv` README — https://github.com/chickensoft-games/GodotEnv
[^S5]: Godot docs, "C# basics" — https://docs.godotengine.org/en/stable/tutorials/scripting/c_sharp/c_sharp_basics.html
[^S6]: Godot docs, "Installing plugins" — https://docs.godotengine.org/en/stable/tutorials/plugins/editor/installing_plugins.html
[^S7]: Godot docs, "Exporting projects" — https://docs.godotengine.org/en/stable/tutorials/export/exporting_projects.html
[^S8]: Godot docs, "Exporting packs, patches, and mods" — https://docs.godotengine.org/en/stable/tutorials/export/exporting_pcks.html
[^S9]: Godot docs, "Feature tags" — https://docs.godotengine.org/en/stable/tutorials/export/feature_tags.html
[^S10]: Microsoft Learn, "Compiler Options - language feature rules" (`DefineConstants`) — https://learn.microsoft.com/en-us/dotnet/csharp/language-reference/compiler-options/language

### Local AeroBeat evidence

[^L1]: `aerobeat-assembly-community/setup_dev.py`
[^L2]: `aerobeat-assembly-community/.gitmodules`
[^L3]: `aerobeat-feature-boxing/setup_dev.py`
[^L4]: `aerobeat-ui-kit-community/setup_dev.py`
[^L5]: `aerobeat-ui-shell-desktop-community/setup_dev.py`
[^L6]: `docs/architecture/topology.md`
[^L7]: `docs/architecture/repository-map.md`
