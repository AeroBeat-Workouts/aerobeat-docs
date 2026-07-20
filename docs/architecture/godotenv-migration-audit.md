# GodotEnv Migration Audit

!!! warning "Superseded transition-era audit"
    This page is a historical audit snapshot from the early GodotEnv migration push. It is **not** the current source of truth for AeroBeat dependency management or repo topology.

    Use these pages for current truth instead:

    - [GodotEnv Convention Contract](godotenv-convention-contract.md)
    - [GodotEnv Clean-Break Removal Policy](godotenv-clean-break-removal-policy.md)
    - [Workflow](workflow.md)
    - [Content Repo Shapes](content-repo-shapes.md)
    - [Architecture Overview](overview.md)

## Historical context

This audit was written during a transition period when older `aerobeat-core` naming and broader family-wide GodotEnv migration work were still being sorted out. Some historical references here originally pointed at an older topology split and predated later repo renames and cleanup passes.

This page now preserves the useful historical observations without presenting the old execution plan as current truth.

## What the original audit usefully captured

The old audit correctly identified several real transition-era problems:

- the repo family depended heavily on repo-local `setup_dev.py` bootstrap scripts
- `.testbed/` was useful, but its dependency population had become inconsistent and script-driven
- the assembly repo and UI shell repos were the main special-case migration hotspots
- docs and templates were themselves part of the architecture problem because they kept regenerating and teaching the stale workflow
- GodotEnv needed to become the explicit dependency contract rather than an optional side path

Those findings remain historically useful for understanding why several later cleanup docs exist.

## Why this page was superseded

The original version read like a live migration master plan. That is no longer what Derrick wants these historical packets to do.

It has been superseded because:

- later docs locked the actual GodotEnv conventions more directly
- the broader AeroBeat architecture was subsequently rewritten around cleaner current-truth pages
- several earlier repo and naming assumptions in the old audit are now transition-era baggage rather than active guidance
- the surviving useful parts are better treated as historical rationale than as an actionable checklist

## Historical takeaways worth preserving

If you need the short version of why this audit mattered, it is this:

1. **`.testbed/` was not the problem**
   - the problem was ad hoc bootstrap/install behavior, not the hidden workbench concept itself

2. **Docs/templates were architecture, not just prose**
   - if docs and templates kept teaching `setup_dev.py` and submodule-era behavior, the old model would keep coming back

3. **Special cases needed special handling**
   - assembly and UI shells were materially different from the simpler package/testbed repos

4. **Release/tag discipline mattered**
   - GodotEnv conventions were not enough on their own without predictable dependency/version discipline

## Current usage rule

Keep this file only as a historical explanation of what the early migration audit found. Do **not** use it as the active dependency-management contract or repo-migration plan.
