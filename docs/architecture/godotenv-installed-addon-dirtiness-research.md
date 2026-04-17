# GodotEnv Installed Addon Dirtiness Research

_Date: 2026-04-17_
_Status: Research complete_

## Short verdict

**GodotEnv does not currently solve dirty installed addons well when the dirtiness is caused by Godot-generated files inside the installed addon.**

It **does** have a built-in safety mechanism that prevents accidental overwrites of modified installed addons. But that same protection is what blocks `godotenv addons install` once Godot generates files like `plugin.gd.uid` or rewrites addon-local `.import` files.

For AeroBeat, the best low-maintenance response is:

1. **Treat GodotEnv-installed addons as immutable/disposable.**
2. **Keep first-party AeroBeat repos on intentional repo-root import unless a repo documents an exception.** Dot-prefixed folders in that payload are acceptable because Godot hides them.
3. **Fix first-party and maintained-fork addons at the source** so they do not become dirty after editor use — especially by committing required `.uid` files upstream before tagging releases intended for GodotEnv consumption.
4. **Do not add permanent wrapper architecture** just to paper over dirty installs.
5. **Document manual delete-and-reacquire as the temporary escape hatch** for third-party exceptions until the addon source is fixed or replaced.

---

## Scope

This memo focuses on the remaining concern from the audit:

- **Issue A is already resolved**: first-party AeroBeat repos are intentionally imported from repo root unless a repo documents an exception, and dot-prefixed folders in that payload are acceptable because Godot hides them.
- **Issue B is the target here**: installed addons becoming dirty after Godot touches them.

---

## Research questions

1. Does GodotEnv explicitly account for installed addons becoming dirty after Godot generates files like `.uid` files?
2. Does it have built-in protection, ignore handling, reinstall behavior, force-refresh behavior, or known workarounds?
3. Is this a known/common issue in GodotEnv or Godot addon workflows?
4. If GodotEnv does not fully solve it, what should AeroBeat do?

---

## What upstream GodotEnv clearly does today

### 1. GodotEnv intentionally protects installed addons from overwrite if they look modified

**Documented evidence**

The upstream README says:

> "GodotEnv will check for accidental modifications made to addon content files before re-installing addons in your project to prevent overwriting changes you have made. It does this by turning non-symlinked addons into their own temporary git repositories and checking for changes before uninstalling them and reinstalling them."

Source: `README.md` in `chickensoft-games/GodotEnv`

**Source evidence**

Current source confirms this implementation:

- `AddonsInstaller` deletes and reinstalls addons during install.
- `AddonsRepository.InstallAddonFromCache(...)` copies the addon into the project, runs `git init`, stages all files, and makes an initial commit inside the installed addon folder.
- `AddonsRepository.DeleteAddon(...)` runs `git status --porcelain` inside the installed addon folder and refuses deletion if any changes exist.

Relevant source paths in the current upstream repo:

- `GodotEnv/src/features/addons/commands/install/AddonsInstaller.cs`
- `GodotEnv/src/features/addons/domain/AddonsRepository.cs`

So yes: **GodotEnv has built-in protection** — but it is overwrite protection, not generated-file tolerance.

### 2. GodotEnv does not currently ship built-in ignore handling for `.uid` / `.import` churn inside installed addons

**Documented/source evidence**

Current upstream source shows:

- the pre-delete check is a raw `git status --porcelain`
- there is **no install-time option or force flag** in `AddonsInstallCommand`
- there is **no current code creating per-installed-addon `.gitignore` rules** for generated files like `*.uid` or `*.import`

That means GodotEnv currently treats those generated files the same as any other local modification.

### 3. For `.uid` files specifically, upstream has explicitly treated this as “working as intended”

**Issue evidence**

In upstream issue **#92 — “Godot 4.4 UID”**, a user reported exactly the failure mode relevant here:

- Godot 4.4 generates missing `*.uid` files in installed addons
- the next `godotenv addons install` fails because the addon now looks locally modified
- example error includes `plugin.gd.uid` and similar files

Maintainer response:

> "I'm going to close this because this is working as intended. The problem is not with GodotEnv, but with the addons which need updating. The whole point of Godot's addon immutability check is to make sure that addons are treated as such, immutable."

When asked about ignore/force behavior, the maintainer recommended:

> "my recommendation would be to simply fork the addon, bring it up to date, and use your repo to install it from."

This is strong evidence that **GodotEnv does not currently consider missing `.uid` files in old addons something it should silently tolerate**.

### 4. For `.import` churn, there is an open upstream request, but not a shipped solution

**Issue evidence**

In upstream issue **#202 — “Option to ignore .import file changes?”**, a user reported that addon-local `.import` files were being changed by the engine, causing reinstall failure with the same dirty-addon protection.

That issue is still open.

Notable maintainer/commenter discussion:

- a contributor suggested that a per-addon `.gitignore` for generated files could be a fix
- the maintainer replied that a project-level `.gitignore` would not help because GodotEnv creates a **git repo inside each addon**, so any ignore handling would need to be created **inside each installed addon before the temporary git repo is initialized**

That is useful technical confirmation that upstream understands the problem, but **the fix is not present in current source**.

### 5. GodotEnv has related cache hygiene discussion, but that is separate from installed-addon dirtiness

**Issue evidence**

Issue **#200** / PR **#207** discuss adding a `.gdignore` under `.addons/` cache to prevent editor parsing problems there.

That is adjacent, but it does **not** solve dirty installed addons under `addons/` after Godot edits them.

This supports AeroBeat’s earlier conclusion that dotfolder/cache concerns are separate from the dirty-installed-addon problem.

---

## What official Godot evidence says

### Godot 4.4 intentionally generates `.uid` files beside scripts and shaders

**Official evidence**

Godot’s official article **“UID changes coming to Godot 4.4”** says:

- Godot 4.4 introduces dedicated `.uid` files for scripts and shaders
- these files are **automatically generated by Godot**
- they are placed beside the source file, e.g. `plugin.gd.uid`

The same article also says:

> "The most important step is to make sure .uid files are committed to version control. In other words, *.uid should not be added to .gitignore."

This matters a lot for AeroBeat:

- if an addon repo does **not** ship the needed `.uid` files,
- Godot 4.4 may create them locally inside the installed copy,
- which makes the installed copy look modified to GodotEnv,
- which then blocks reinstall.

So for `.uid`, the official Godot direction aligns with the GodotEnv maintainer stance: **the addon source should be updated**.

---

## Is this a known/common issue?

### Documented evidence

Yes, there is direct evidence that this is not just a one-off AeroBeat concern:

- GodotEnv issue **#92** documents the exact `plugin.gd.uid` style failure.
- GodotEnv issue **#202** documents the same general failure mode for addon-local `.import` churn.
- Godot proposal **#11464** explicitly asks for Godot to stop generating `.uid` files under `res://addons/` because addon-management workflows that do not commit installed addon contents are affected.

### Inference

It is reasonable to infer that this is a **broader addon-workflow friction point** created by the interaction of:

1. Godot-generated sidecar files (`*.uid`, sometimes addon-local `.import` churn), and
2. package-manager-style workflows where installed addons are treated as disposable/generated artifacts rather than committed repo content.

That inference is strengthened by the Godot 4.4 UID rollout itself and by the proposal/discussion traffic around addons.

But the strongest official statement remains: **Godot expects `.uid` files to be committed**.

---

## What GodotEnv currently gives AeroBeat vs. what it does not

### What it gives

- reproducible manifest-based addon acquisition
- delete-and-reinstall behavior for managed addons
- protection against silently overwriting local edits
- support for immutable package-style addon workflows
- support for `symlink` sources when live mutable local development is intended

### What it does not currently give

- built-in tolerance for editor-generated `.uid` churn in installed addons
- built-in tolerance for addon-local `.import` churn in installed addons
- a documented force-refresh mode for dirty installed addons
- a documented per-addon ignore configuration for the temporary git repos inside installed addons
- a documented “just clean/reinstall everything even if dirty” escape hatch

---

## Option comparison for AeroBeat

| Option | Pros | Cons | Verdict |
| --- | --- | --- | --- |
| Rely on built-in GodotEnv behavior | Zero extra AeroBeat work | Does **not** solve `.uid`/`.import` dirtiness today; reinstall still fails | **Not sufficient by itself** |
| Add wrapper scripts for delete-and-reacquire flows | Can brute-force recovery locally | Extra architecture, extra maintenance, surprises users, weakens clean-break clarity, papers over source problems | **Use only as last-resort local convenience, not as primary architecture** |
| Commit generated files upstream | Aligns with official Godot guidance for `.uid`; keeps installed addons clean; works with GodotEnv’s immutability model | Requires maintained upstream/forks; less helpful for some `.import` cases | **Best primary fix for `.uid`, especially for first-party/forked addons** |
| Ignore/tolerate generated files in GodotEnv installs | Would reduce local friction if upstream implements it | Not shipped today; can hide real modifications; `.import` semantics may vary | **Do not depend on this today** |
| Adjust validation/workflow policy | Cheap, clear, low-maintenance; matches GodotEnv mental model | Does not magically fix bad third-party addons | **Required complement to source fixes** |

---

## Recommended AeroBeat response

## Recommendation summary

**AeroBeat should keep the GodotEnv clean-break direction, but pair it with an explicit immutability policy and source-level fixes.**

### 1. Treat installed addons as immutable/disposable

This is already how GodotEnv is designed to work.

For AeroBeat policy, that means:

- installed `addons/` or `.testbed/addons/` content is not a place for durable edits
- if an installed addon becomes dirty, that is a signal to fix the addon source or handle it as an exception
- routine workflows should assume reinstallability from manifest + source tags

### 2. For AeroBeat-owned repos and maintained forks, commit `.uid` files upstream before tagging releases

This is the most important practical step.

Why:

- official Godot 4.4 guidance says `.uid` files should be committed
- GodotEnv’s maintainer treats missing `.uid` files in old addons as an addon problem, not a GodotEnv problem
- committing `.uid` files upstream prevents the installed copy from becoming dirty just because the editor opened it

For AeroBeat, this should become part of addon release hygiene for first-party repos and any third-party forks we choose to maintain: if a GodotEnv consumer is expected to install a release tag, that tag must already contain the required `.uid` files.

### 3. Prefer fixing/forking problematic third-party addons over inventing wrapper architecture

For abandoned or stale third-party addons that generate missing `.uid` files locally:

- fork them
- add the needed compatibility files / updates
- pin AeroBeat to the fork/tag

That is more aligned with both Godot and GodotEnv than teaching a permanent “delete dirty addons and try again” wrapper path.

### 4. Do not make wrapper-based delete-and-reacquire flows the primary answer

A small manual delete-and-reacquire step is acceptable as a temporary operator escape hatch.

But turning that into official wrapper architecture would be:

- more surprising
- more maintenance-heavy
- less aligned with the clean-break policy in AeroBeat docs
- more likely to normalize broken upstream addon state instead of fixing it

### 5. Add a documented exception policy for dirty third-party installs

Until every dependency is clean:

- if `godotenv addons install` fails because an installed addon is dirty,
- the first question should be **why** it is dirty:
  - missing committed `.uid` files?
  - addon-local `.import` churn?
  - a real manual edit?
- for known stale third-party addons, the short-term recovery can be:
  1. delete the affected installed addon directory
  2. rerun `godotenv addons install`
  3. log the dependency as needing upstream/fork remediation

That should be documented as an **exception recovery procedure**, not the normal architecture.

### 6. Watch upstream issue #202, but do not plan around it yet

If GodotEnv eventually adds per-installed-addon ignore handling for `*.import` or similar generated files, AeroBeat can simplify later.

But today that would be speculative.

AeroBeat should not design Phase 1 around a feature that upstream has discussed but not shipped.

---

## Least-surprising / lowest-maintenance answer

If AeroBeat wants the least-surprising and lowest-maintenance path, it is this:

> **Use GodotEnv as an immutable addon installer, fix `.uid` dirtiness at the source by committing `.uid` files upstream (or in maintained forks), and keep manual delete-and-reacquire as a temporary exception-handling step rather than building wrapper tooling.**

That matches:

- Godot’s official 4.4 UID guidance
- GodotEnv’s current implementation
- GodotEnv maintainer guidance in issue #92
- AeroBeat’s clean-break/no-wrapper policy direction

---

## Direct answers to the research questions

### Does GodotEnv explicitly account for installed addons becoming dirty after Godot generates files like `.uid` files?

**Partially, but only as a safety block.**

It detects that the addon is dirty and refuses to overwrite it. It does **not** currently distinguish Godot-generated files from intentional local edits.

### Does it have built-in protection, ignore handling, reinstall behavior, force-refresh behavior, or known workarounds?

- **Protection:** yes
- **Reinstall behavior:** yes, delete-and-reinstall when clean
- **Ignore handling for `.uid` / `.import`:** not currently shipped
- **Force-refresh behavior:** not currently shipped/documented
- **Known workaround:** maintainer recommendation is to update/fork the addon, or use mutable workflows like symlinks/manual management when appropriate

### Is this a known/common issue in GodotEnv or Godot addon workflows?

**Yes.** There is direct upstream issue evidence for both `.uid` and `.import` variants, plus broader Godot proposal/discussion evidence that addon/package workflows are affected by generated sidecar files.

### If GodotEnv does not fully solve it, what should AeroBeat do?

**Best next step:**

- keep GodotEnv
- treat managed installs as immutable
- commit `.uid` files upstream for first-party / maintained-fork addons
- fork/update stale third-party addons when needed
- document manual delete-and-reacquire as a temporary exception flow
- do **not** add permanent wrapper architecture unless recurring evidence later proves it is necessary

---

## Confidence and evidence notes

### Strong documented evidence

- GodotEnv README behavior description
- GodotEnv current source code in `AddonsRepository` / `AddonsInstaller`
- GodotEnv issue #92 maintainer stance
- GodotEnv issue #202 current open state and technical discussion
- Godot official article on Godot 4.4 UID files and version-control guidance

### Inference / recommendation layer

- that AeroBeat should prefer source fixes over wrappers
- that first-party/fork hygiene is the lowest-maintenance long-term answer
- that `.import` handling should remain an exception policy until upstream ships something clearer

Those recommendations are not directly mandated by upstream docs, but they are the most consistent reading of the current upstream behavior and AeroBeat’s own clean-break architecture policy.
