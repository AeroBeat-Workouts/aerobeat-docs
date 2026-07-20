# AeroBeat Package Dependency Research

> [!WARNING]
> **Status: historical rationale only.**
> This page is intentionally trimmed. Use it for background, not for day-to-day contract truth.
>
> Read these first for the live contract:
> - [GodotEnv Convention Contract](godotenv-convention-contract.md)
> - [Workflow & Assets](workflow.md)
> - [Repository Map](repository-map.md)
> - [Repo Structure Reference](repo-structure-reference.md)

_Date: 2026-04-17_

## One-sentence conclusion

**AeroBeat should standardize on GodotEnv manifest-driven dependency composition for Godot-facing repos, and should retire stale bootstrap/submodule-era dependency stories as those replacements land.**

## The durable takeaways

These are the conclusions from the original research that still matter:

1. **GodotEnv manifests are the current dependency contract.**
2. **Package/foundation repos use `.testbed/addons.jsonc` for dev/test composition.**
3. **Assembly repos use root `addons.jsonc` for runtime composition.**
4. **Consumer-install truth and repo-dev truth are different layers; do not flatten them.**
5. **Sidecar-bearing repos need extra runtime/release docs beyond addon install itself.**

## What should not come back from the older draft

Do **not** use this page to reintroduce stale architecture wording such as:

- submodule-first dependency teaching as the preferred current path
- long-lived parallel bootstrap truth in `setup_dev.py`, `.gitmodules`, or one-off sync glue
- old transition-era repo naming as if it were still canonical
- MediaPipe-specific dependency framing as the headline package architecture story

## Current recommended doc rule

When writing current docs:

- point to the **GodotEnv convention docs** for package/dependency truth
- document **sidecar exceptions explicitly**
- avoid pretending every repo shape has one perfect npm-like packaging story
- keep historical reasoning here, not scattered across active architecture pages

## Sidecar note

The only still-useful nuance from the older research is that some repos need more than addon installation.

Typical examples include repos with:

- Python runtimes
- native helpers
- platform-specific bootstrap steps
- export/distribution requirements for companion files

That does **not** weaken the GodotEnv conclusion. It just means addon installation and runtime packaging are separate concerns.

## Camera/input note

Older drafts over-focused on MediaPipe Python as though it defined the entire long-term package architecture.

That framing is too narrow.

Current docs should instead:

- treat **PC camera gameplay** as the current product/input truth
- keep repo ownership and runtime details explicit where needed
- avoid letting older MediaPipe-specific research become the top-level dependency narrative

For present-tense input architecture, use the newer input docs rather than this research page.

## Use this page for

Use this page when you need the background rationale for why AeroBeat moved toward GodotEnv/addon composition.

## Do not use this page for

Do not use this page as the source of truth for:

- final manifest naming
- exact current repo naming
- exact migration steps
- current camera-input product wording
- day-to-day dependency setup instructions

## Bottom line

The historical conclusion still stands:

**GodotEnv manifests are the dependency-management source of truth; stale parallel dependency/bootstrap stories should be removed rather than preserved as equal-status architecture.**
