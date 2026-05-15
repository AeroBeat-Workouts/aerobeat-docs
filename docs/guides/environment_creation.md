# Creating Environments

Environments remain part of the official workout-package concept.

> **Scope note:** this page describes the deeper Godot-authored environment workflow, which should still be treated as an advanced controlled-pipeline path. The package contract now officially recognizes `image_background`, `video_background`, `glb_environment`, and `splat` via `type` + `resourcePath`, but `splat` remains the most controlled advanced lane.

## Why environments stay

The current product slice keeps environments because they meaningfully shape the workout atmosphere without reopening the older package-asset customization model.

## Locked v1 requirements

For public workout publishing in v1:

- **every set must have an environment layer**
- the minimum acceptable environment is a **static 2D background image**
- higher-fidelity video and 3D/GLB environments are optional upgrades
- every package still needs a separate **thumbnail / cover-art asset**; the environment does not replace cover art

## Current authoring guidance

- prefer clean, lightweight authored backgrounds or GLB environments for the default creator path
- treat `splat` as a controlled advanced option, not the baseline recommendation
- if a splat package is used, prefer `.compressed.ply` as the official recommended AeroBeat payload while keeping `.ply`, `.splat`, and `.sog` as GDGS compatibility paths
- optimize for readability first, spectacle second
- keep runtime assumptions conservative for the PC-first community target
- avoid teaching loose `godot_scene` as the default community handoff

## AeroBeat default-environment workflow note

To lower creator burden, the intended creator-tool workflow is that AeroBeat may provide a curated set of default environments.

If a creator selects one of those defaults, the tool should copy the needed environment asset payload into the exported package before validation/zip/export. Public packages should not depend on a hidden editor-only reference to a shared environment library.

## Product note

If you are looking for customization beyond environments, the likely future direction is controlled avatar/cosmetics unlocks rather than package-local gameplay asset bundles.
## Controlled advanced `splat` note

If you ship a `splat` environment record, keep the docs and package behavior honest:

- the final exported workout should still copy the chosen splat payload into the package so playback stays self-contained
- `.compressed.ply` is the official recommended AeroBeat splat payload when authors have a choice
- `.ply`, `.splat`, and `.sog` remain compatibility-supported through GDGS
- the current validated runtime path is desktop-focused and depends on Godot Forward Plus plus compute-capable GPU support
- this is not yet the broad creator-friendly cross-device path; it is the advanced lane validated through the environment-community/tool/vendor stack

