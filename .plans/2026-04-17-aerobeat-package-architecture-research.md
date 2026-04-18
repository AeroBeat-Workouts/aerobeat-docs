# AeroBeat Package Architecture Research

**Date:** 2026-04-17  
**Status:** Complete  
**Agent:** Pico 🐱‍🏍

---

## Goal

Research whether AeroBeat can move from the current spoke-and-wheel repo architecture toward a traditional npm-style package dependency model, with special focus on whether Chickensoft tooling/docs support the desired Godot package workflow.

---

## Overview

This research will focus on the community edition assembly flow centered on `aerobeat-assembly-community`. The question is whether that assembly repo can act like a consumer application that pulls tagged releases of feature, input, and UI packages as dependencies—similar to `node_modules`—while still supporting Godot builds that selectively include only the code/assets needed for a specific build target or scripting define configuration.

The study needs to cover both the architectural mechanism and the practical documentation path. That means identifying how Chickensoft recommends packaging Godot libraries/modules, how dependency acquisition/version pinning works, how `.testbed` assets and development scaffolding should live in package repos without bloating production builds, and whether assembly-time composition can remain lean across game modes like boxing, dance, flow, and step.

This is research-first work. The deliverable is a documented recommendation, not an implementation change. The research may expand beyond Chickensoft-only approaches when needed, including the best credible fallback architecture if Chickensoft's tooling only partially fits AeroBeat's needs.

---

## REFERENCES

| ID | Description | Path |
| --- | --- | --- |
| `REF-01` | Derrick's requested target architecture and constraints from current chat | `webchat conversation 2026-04-17` |
| `REF-02` | AeroBeat owning docs repo for research output | `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-docs` |
| `REF-03` | Community assembly repo to evaluate as dependency consumer | `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-assembly-community` |

---

## Tasks

### Task 1: Research Chickensoft and related Godot package mechanisms

**Bead ID:** `oc-mvz`  
**SubAgent:** `research`  
**References:** `REF-01`, `REF-02`, `REF-03`  
**Prompt:** Investigate whether Chickensoft provides a supported pattern for packaging Godot codebases as reusable versioned dependencies in a way similar to npm packages. Include official docs, package/tooling names, install/versioning workflow, release/tag expectations, and any notes about development assets, testbeds, editor-only content, or conditional build inclusion. Compare the architecture to AeroBeat's desired community assembly flow and call out hard limits or caveats.

**Folders Created/Deleted/Modified:**
- `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-docs/.plans/`
- `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-docs/docs/`

**Files Created/Deleted/Modified:**
- `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-docs/.plans/2026-04-17-aerobeat-package-architecture-research.md`
- `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-docs/docs/architecture/package-dependency-research.md`

**Status:** ✅ Complete

**Results:** Reviewed Chickensoft's official setup/C# architecture/docs, `GodotPackage`, and `GodotEnv`, then cross-checked those findings against Godot's official plugin/export/feature-tag docs and AeroBeat's local repo structure. Main result: Chickensoft supports reusable versioned **C#** packages via NuGet and reusable **asset-bearing Godot addons** via `GodotEnv`, but not a single npm-equivalent system that fully covers both. For AeroBeat's present repo set, addon packages pinned to tags are the relevant mechanism.

---

### Task 2: Map findings onto AeroBeat community assembly requirements

**Bead ID:** `oc-j9o`  
**SubAgent:** `research`  
**References:** `REF-01`, `REF-03`  
**Prompt:** Using the gathered documentation, evaluate whether `aerobeat-assembly-community` can consume versioned package-style dependencies for community features (`boxing`, `dance`, `flow`, `step`), inputs (including `mediapipe-python`), and community UI shell/UI kit repos. Determine what would live in package repos versus the assembly repo, how tagged releases would be referenced, and whether script-define-based builds can avoid shipping unnecessary code/assets.

**Folders Created/Deleted/Modified:**
- `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-docs/docs/`

**Files Created/Deleted/Modified:**
- `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-docs/docs/architecture/package-dependency-research.md`

**Status:** ✅ Complete

**Results:** Mapped the findings onto `aerobeat-assembly-community` and the broader AeroBeat repo graph. Conclusion: the assembly can act as a consumer app with a dependency manifest, but the practical fit is **addon-first** for community features, input drivers, UI kit, and UI shells. `mediapipe-python` can be versioned as a repo dependency, but its Python sidecar still needs custom release/install handling. C# define symbols only help if AeroBeat introduces C# packages; they do not solve Godot asset stripping on their own.

---

### Task 3: Produce recommendation and migration considerations

**Bead ID:** `oc-28w`  
**SubAgent:** `research`  
**References:** `REF-01`, `REF-02`, `REF-03`  
**Prompt:** Summarize whether the desired npm-style dependency architecture is supported, partially supported, or mismatched with Chickensoft/Godot tooling. Provide a plain recommendation, known tradeoffs, missing pieces, and suggested next experiments if AeroBeat wants to pursue the architecture.

**Folders Created/Deleted/Modified:**
- `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-docs/docs/`

**Files Created/Deleted/Modified:**
- `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-docs/docs/architecture/package-dependency-research.md`

**Status:** ✅ Complete

**Results:** Produced a recommendation that the requested architecture is **partially supported**. Best-fit recommendation: use **Godot addon packages + a manifest-driven installer such as GodotEnv** for asset-bearing repos, reserve **NuGet/Chickensoft GodotPackage** for pure C# libraries only, and use **export presets and/or PCK packs** to keep production builds lean. Called out hard constraints around flat addon graphs, Godot asset paths/import behavior, the absence of current repo tags, and the fact that Godot 4 C# still cannot export to web.

---

## Final Results

**Status:** ✅ Complete

**What We Built:** A research memo at `/home/derrick/.openclaw/workspace/projects/aerobeat/aerobeat-docs/docs/architecture/package-dependency-research.md` covering Chickensoft's official package/addon patterns, Godot's official addon/export constraints, the current AeroBeat package topology, and a recommendation for an addon-first hybrid dependency model.

**Reference Check:** `REF-01`, `REF-02`, and `REF-03` were satisfied. The research explicitly checked the requested architecture against AeroBeat's current assembly repo and neighboring package repos, and documented where Chickensoft/Godot are a fit versus a mismatch.

**Commits:**
- Pending (research/doc update only; no git commit was requested from this subagent)

**Lessons Learned:** The most important distinction is between **code-only C# reuse** and **asset-bearing Godot addon reuse**. AeroBeat's current repos fit the second category much better, so the realistic migration path is versioned addon installs plus export-time packaging discipline, not a straight port to a NuGet-style package ecosystem.

---

*Completed on 2026-04-17*
