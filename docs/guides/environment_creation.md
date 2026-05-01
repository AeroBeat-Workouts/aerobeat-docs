# Creating Environments

Environments remain part of the official workout-package concept.

> **Scope note:** this page describes the deeper Godot-authored environment workflow, which should still be treated as an advanced controlled-pipeline path. The baseline package contract stays smaller: package YAML should point at `image_background`, `video_background`, or cleaned `glb_environment` payloads via `type` + `resourcePath`.

## Why environments stay

The current product slice keeps environments because they meaningfully shape the workout atmosphere without reopening the older package-asset customization model.

## Environment goals

- readable workout presentation
- good performance on the PC-first community target
- future portability to mobile and later VR where feasible

## Current authoring guidance

- prefer clean, lightweight authored backgrounds or GLB environments
- optimize for readability first, spectacle second
- keep runtime assumptions conservative for the first community release
- avoid teaching loose `godot_scene` as the default community handoff

## Product note

If you are looking for customization beyond environments, the likely future direction is controlled avatar/cosmetics unlocks rather than package-local gameplay asset bundles.
