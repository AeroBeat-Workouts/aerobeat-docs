# Creating Environments

Environments remain part of the official workout-package concept.

> **Scope note:** this page describes the deeper Godot-authored environment workflow, which should still be treated as an advanced controlled-pipeline path. The baseline package contract stays smaller: package YAML should point at `image_background`, `video_background`, or cleaned `glb_environment` payloads via `type` + `resourcePath`.

## Why environments stay

The current product slice keeps environments because they meaningfully shape the workout atmosphere without reopening the older package-asset customization model.

## Locked v1 requirements

For public workout publishing in v1:

- **every set must have an environment layer**
- the minimum acceptable environment is a **static 2D background image**
- higher-fidelity video and 3D/GLB environments are optional upgrades
- every package still needs a separate **thumbnail / cover-art asset**; the environment does not replace cover art

## Current authoring guidance

- prefer clean, lightweight authored backgrounds or GLB environments
- optimize for readability first, spectacle second
- keep runtime assumptions conservative for the PC-first community target
- avoid teaching loose `godot_scene` as the default community handoff

## AeroBeat default-environment workflow note

To lower creator burden, the intended creator-tool workflow is that AeroBeat may provide a curated set of default environments.

If a creator selects one of those defaults, the tool should copy the needed environment asset payload into the exported package before validation/zip/export. Public packages should not depend on a hidden editor-only reference to a shared environment library.

## Product note

If you are looking for customization beyond environments, the likely future direction is controlled avatar/cosmetics unlocks rather than package-local gameplay asset bundles.
