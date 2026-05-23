# Input Pipeline (Provider Pattern)

AeroBeat uses the **Provider Pattern** for runtime input, but the current product scope is narrower than the full architecture surface.

The public-facing abstraction is the **Input Provider**: a runtime bridge that turns hardware-specific signals into normalized gameplay data. Game logic never talks to a webcam, controller, keyboard, or tracker directly; it asks the Input Provider for normalized data.

## Official v1 stance

**Official AeroBeat v1 gameplay input support is camera only.**

That means the provider architecture should currently be optimized around camera-driven Boxing and Flow. Other providers can remain documented and versioned as future work without being presented as equal-status shipping inputs.

## Current provider landscape

| Provider | Status in docs | Typical role |
| :--- | :--- | :--- |
| MediaPipe Python Provider | Official v1 gameplay path | PC camera gameplay |
| MediaPipe Native Provider | Near-future follow-on | Mobile camera gameplay |
| JoyCon HID Provider | Future support | Future-input exploration |
| Keyboard Provider | Future support | Debugging, tooling, experiments |
| Mouse Provider | Future support for gameplay, valid for UI navigation | Pointer-driven navigation / experiments |
| Touch Provider | Future support for gameplay, valid for UI navigation | Mobile UI navigation / future gameplay |
| Gamepad Provider | Future support | Accessibility and platform exploration |
| XR Provider | Future support | VR return path |

## Interaction family vs input profile

AeroBeat docs still distinguish between:

- **Interaction Family:** authored-content compatibility groups such as `gesture_2d` or `tracked_6dof`
- **Input Profile:** concrete runtime/device targets such as `mediapipe_camera` or `keyboard_debug`

That model remains useful, but only `mediapipe_camera`-style camera paths should be described as official v1 gameplay support.

## Ownership split for spatial UI inputs

The audited spatial UI work clarified that gameplay input ownership and spatial UI ownership are related but distinct:

- **`aerobeat-input-core`** owns normalized provider contracts and shared input-facing vocabulary, including the canonical UI interaction contract and native 2D bridge path.
- **`aerobeat-spatial-ui-core`** is a reusable helper layer for pointer-style spatial UI providers. It contributes shared surface, projection, target-resolution, and hover/capture helpers, but it does not own the contract.
- **`aerobeat-spatial-ui-mouse`** is the concrete packaged mouse lane that uses those helpers to deliver desktop pointer behavior.
- **`aerobeat-ui-core`** owns menu/UI contracts that consume those interactions, not the extraction logic itself.

This matters because not every non-camera signal should be modeled as a gameplay provider first. Some signals are better treated as **UI-provider lanes** until AeroBeat intentionally promotes them into gameplay-facing contracts.

## Mouse, touch, and XR policy

The current docs should describe these lanes carefully:

- **Mouse:** valid as a concrete spatial UI provider lane and a future gameplay experiment, but not an official v1 gameplay promise.
- **Touch:** should be extracted through its own provider/repo lane rather than hidden behind desktop proof-host glue or silently folded into the mouse package.
- **XR:** should likewise arrive as its own provider lane with XR-specific extraction and runtime semantics, not as an undocumented branch inside another package.

In other words: **touch and XR belong in explicit provider lanes when they happen.** The public docs should not imply that the current mouse-backed proof path secretly covers those surfaces already.

## Why keep future providers documented

The docs should preserve repo/API references for non-camera inputs because they help with:

- future platform planning
- accessibility research
- debugging and tool-side workflows
- eventual mobile and VR expansion

The important rule is wording: **documented does not mean committed for v1**.
