# AeroBeat GodotEnv Phase 1 Execution Packet

!!! warning "Superseded execution packet"
    This page is preserved as a historical phase packet only. It should **not** be used as an active implementation checklist.

    Use these pages for current truth instead:

    - [GodotEnv Convention Contract](godotenv-convention-contract.md)
    - [GodotEnv Clean-Break Removal Policy](godotenv-clean-break-removal-policy.md)
    - [Workflow](workflow.md)
    - [Architecture Overview](overview.md)

## Historical context

This packet documented an early foundation-wave plan for normalizing the GodotEnv dependency chain across foundational AeroBeat repos.

It originally assumed a live phased execution order centered on:

1. `aerobeat-core`
2. `aerobeat-ui-core`
3. `aerobeat-ui-kit-community`

It was written before later cleanup passes turned several of these transition-era packets into historical references instead of current operational truth.

## Why it was superseded

The original version read like a pre-authorized execution plan. That is exactly the kind of stale planning packet Derrick wants to stop presenting as live truth.

This page is now superseded because:

- the canonical GodotEnv rules are documented more directly elsewhere
- later architecture/docs cleanup removed a lot of transition-era ambiguity
- some older naming and rollout assumptions in this packet no longer match the cleaned current docs surface

## Historical takeaways still worth preserving

The packet is still mildly useful as a record of the intended migration posture:

- foundational repos should establish dependency/install conventions before downstream consumer repos copy them
- package/testbed repos should use manifest-driven dependency restore rather than bespoke bootstrap scripts
- clean-break removal of legacy bootstrap artifacts was an explicit goal, not a side effect
- repo-local docs and validation flow were considered part of the migration contract, not optional polish

## Current usage rule

Treat this file as background context only. If you need the actual current dependency-management rules or workflow expectations, follow the current canonical docs linked above rather than this historical packet.
