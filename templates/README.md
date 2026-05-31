# AeroBeat Repository Templates

`aerobeat-docs` no longer ships runnable template payloads. The canonical template code lives in the standalone GitHub repositories under the AeroBeat-Workouts organization. This folder is now a **docs-only template directory** that points humans and agents at the real owners.

## First step after cloning any template

Before you treat a fresh template clone as real runtime code, do this cleanup immediately:

1. **Rename placeholder files** to the repo's real public names.
2. **Rename placeholder classes** so stale `class_name` values do not leak into the real repo.
3. **Rename autoload/singleton entries** to the repo's actual contract names.
4. **Delete or rewrite leftover placeholder identifiers** in tests, README examples, plugin metadata, and docs.
5. **Search for stale names** such as `AeroToolManager` and remove them before starting real implementation work.

`AeroToolManager` is the concrete failure mode that triggered this cleanup wave: it was acceptable only as a clone-time placeholder, never as a durable shipped runtime identity.

## Canonical template repositories

| Template | Canonical repo | Notes |
| --- | --- | --- |
| Assembly | <https://github.com/AeroBeat-Workouts/aerobeat-template-assembly> | Assembly/game repo starting point |
| Feature | <https://github.com/AeroBeat-Workouts/aerobeat-template-feature> | Gameplay feature package starting point |
| Input | <https://github.com/AeroBeat-Workouts/aerobeat-template-input> | Input-driver package starting point |
| Tool | <https://github.com/AeroBeat-Workouts/aerobeat-template-tool> | Tool/workflow package starting point; rename placeholder manager names immediately after clone |
| UI Kit | <https://github.com/AeroBeat-Workouts/aerobeat-template-ui-kit> | Reusable UI kit package starting point |
| UI Shell | <https://github.com/AeroBeat-Workouts/aerobeat-template-ui-shell> | Shell/application package starting point |
| Asset (Internal) | <https://github.com/AeroBeat-Workouts/aerobeat-template-asset> | Internal asset package starting point |
| Skin | <https://github.com/AeroBeat-Workouts/aerobeat-template-skin> | Community skin package starting point |
| Avatar | <https://github.com/AeroBeat-Workouts/aerobeat-template-avatar> | Community avatar package starting point |
| Cosmetic | <https://github.com/AeroBeat-Workouts/aerobeat-template-cosmetic> | Community cosmetic package starting point |
| Environment | <https://github.com/AeroBeat-Workouts/aerobeat-template-environment> | Community environment package starting point |

## Ownership rule

- **Canonical code owner:** the standalone `aerobeat-template-*` GitHub repo
- **Docs owner:** `aerobeat-docs`, which explains how to choose and clean up a template
- **Do not** copy runnable payloads back into this docs repo just to make the docs feel self-contained

If a template needs code changes, land them in the owning template repo and link to that repo from documentation here.
