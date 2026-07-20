# Camera Input (PC)

This page keeps an old path name for continuity, but the current topic is broader than that path.

## Current truth

AeroBeat's **official v1 gameplay input** is:

- **camera on PC**
- for **Boxing and Flow**

That is the stable public wording.

Use these pages as the current architecture anchors:

- [Input Pipeline](../../../architecture/input.md)
- [Repository Map](../../../architecture/repository-map.md)
- [Repo Structure Reference](../../../architecture/repo-structure-reference.md)
- [Home](../../../index.md)

## Why this path still says `mediapipe_python`

This docs path is historical baggage.

Do **not** read the path name as a claim that:

- MediaPipe Python is the only wording AeroBeat should use publicly
- the exact current implementation stack is the permanent product contract
- every future camera backend must inherit the same repo naming forever

## Contract boundary

The important product/architecture boundary is simple:

- gameplay features consume a **stable camera gameplay contract**
- implementation details below that layer may change over time

That contract-facing lane may own things such as:

- camera-provider integration
- normalized gameplay-facing signals
- runtime/provider configuration
- sidecar or transport coordination when needed

It should **not** force every feature doc to speak in raw backend/vendor terms.

## Historical MediaPipe note

Older docs referenced `aerobeat-input-mediapipe-python` and a Python sidecar much more directly.

That history still matters for implementation, migration, and repo/runtime details. It is just not the best source for the broad current product statement.

Useful historical references:

- [MediaPipe Camera Input Model Decision (Superseded Historical ADR)](../../../architecture/mediapipe-camera-input-model-decision-2026-05-04.md)
- [GodotEnv Migration Audit](../../../architecture/godotenv-migration-audit.md)

## Scope guardrails

This page does **not** claim that:

- mobile camera is already equal-status official gameplay support
- VR/XR, keyboard, gamepad, mouse, or touch are official v1 gameplay inputs
- the current backend is the only possible long-term PC camera implementation

Those are separate future-input or implementation questions.

## Historical source repo

Historical repo reference:

<https://github.com/AeroBeat-Workouts/aerobeat-input-mediapipe-python>
