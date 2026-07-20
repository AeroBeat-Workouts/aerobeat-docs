# Skins in the Current Docs Slice

AeroBeat still has a **skin lane**, but it should no longer be read as a public v1 creator pillar or as the old package-local gameplay-swap story.

## Current truth

- **Official v1 gameplay:** camera-driven Boxing and Flow on PC first
- **Current customization emphasis:** controlled **avatar / cosmetics / profile** progression, not community gameplay-skin swapping
- **Skin repo role:** internal or controlled product presentation work in the **asset lane**
- **Canonical template:** `aerobeat-template-skin`

If you are looking for the main community creation path today, start with workout packages, choreography, coaching, and environments instead.

## What this page means now

Use the skin lane when AeroBeat itself needs to author or validate:

- internal glove/hand presentation variants for Boxing
- internal target/obstacle presentation variants for Boxing or Flow
- trail/accent presentation for retained gameplay features
- controlled product-facing visual variants that belong to the asset lane

Do **not** use this page to imply that AeroBeat v1 ships a broad public marketplace for swapping gameplay equipment skins.

## Canonical starting point

The runnable template story now lives in:

- `aerobeat-template-skin`
- `aerobeat-docs/templates/skins/README.md` for the docs-side handoff note

That template already captures the current repo truth:

- skins are **internal/system-facing packages** by default
- shared contracts belong in `aerobeat-asset-core`
- concrete feature dependencies should stay explicit and selective
- the old universal mod/SDK story should not be revived accidentally

## Scope guardrails

### What belongs in skin work

- visual meshes/materials for retained feature presentation
- asset-lane resources consumed by a concrete feature or assembly
- validation against the current Boxing/Flow runtime surfaces when needed

### What does not belong here

- community-authored workout package content
- coach content
- avatar/cosmetic progression design as a substitute for gameplay skins
- claims that skins are an equal-status public modding lane in the current v1 product slice
- old `AeroModManifest` / public uploader instructions from the superseded UGC-first docs story

## Practical workflow

1. Open `aerobeat-template-skin`.
2. Restore the `.testbed/` GodotEnv dependencies documented there.
3. Validate the presentation assets against the concrete feature surface that actually consumes them.
4. Keep the package boundary and dependency list narrow.
5. If the work is really avatar/cosmetic/environment content instead, route it to the correct lane instead of forcing it into `skins`.

## Creator routing note

If you are a community creator trying to decide where to contribute today:

- build **workouts/charts/sets/coaching/environments** for the active content lane
- treat **skins** as a controlled/internal asset path unless a future docs update explicitly broadens that scope

## Summary

Skins are still real, but in the current docs slice they are **not** the headline community customization system. Read them as a **narrow asset-lane package for controlled product presentation**, aligned to the retained Boxing + Flow v1 scope.
