# AeroBeat Phase 2 Pilot Packet — `aerobeat-feature-boxing`

!!! warning "Superseded pilot packet"
    This page is a historical repo-specific migration packet. It is **not** the current source of truth for Boxing architecture, package shape, or GodotEnv workflow.

    Use these pages for current truth instead:

    - [BeatSaver Boxing v1 Conversion](beatsaver-boxing-v1-conversion.md)
    - [GodotEnv Convention Contract](godotenv-convention-contract.md)
    - [GodotEnv Clean-Break Removal Policy](godotenv-clean-break-removal-policy.md)
    - [Workflow](workflow.md)
    - [Input](input.md)

## Historical context

This packet captured a narrow repo-migration plan for `aerobeat-feature-boxing` during the early GodotEnv cleanup push.

It predated later Boxing-architecture cleanup and later docs work that moved canonical Boxing behavior into dedicated Flow/Boxing conversion pages instead of leaving repo-specific transition packets sounding current.

## Why it was superseded

The original version combined several kinds of truth that should no longer live here as if they were current:

- repo-specific GodotEnv migration steps
- transition-era package/testbed assumptions
- early Boxing repo workflow guidance
- older naming/history that later cleanup passes demoted to background context

Derrick's current direction is to keep this kind of packet only as a historical breadcrumb, not as active guidance.

## Historical takeaways worth preserving

These were the durable ideas inside the old packet:

1. **Package repos should have one committed dependency contract**
   - the repo-local testbed manifest was meant to replace bespoke setup scripts

2. **`.testbed/` should be the real workbench**
   - local debugging, imports, and package-local tests should run from the hidden workbench project rather than through ad hoc bootstrap flows

3. **Legacy setup scripts were intended to be removed, not canonized**
   - the migration posture favored replacement over indefinite compatibility layering

4. **Repo docs, ignores, and CI were part of the migration**
   - the old packet correctly treated contributor instructions and automation as part of the dependency-contract surface

## What changed later

Later work made this packet non-canonical for two separate reasons:

- current Boxing gameplay/conversion truth moved into dedicated architecture docs, especially the BeatSaver Boxing v1 conversion page
- broader docs cleanup passes demoted transition-era migration packets like this one so they would stop reading like live repo instructions

## Current usage rule

Keep this file only as historical migration context for the early `aerobeat-feature-boxing` cleanup work. Do **not** use it as the active Boxing contract or the active dependency/workflow playbook.
