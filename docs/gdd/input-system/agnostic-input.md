# Input Strategy

AeroBeat still uses a normalized input architecture, but the product messaging is now more specific than the older "input agnostic" framing.

## Official v1 gameplay input

**Camera is the only official AeroBeat v1 gameplay input.**

That applies to the current Boxing and Flow product slice. The game should be documented, validated, and marketed around camera-driven gameplay first.

## Why the architecture still stays modular

Keeping an input-provider architecture is still useful because it lets the platform:

- isolate camera implementation details from gameplay logic
- keep room for future accessibility and platform work
- preserve future paths for mobile-native camera, XR, JoyCon, keyboard, gamepad, mouse, and touch experiments

That architectural flexibility should not be mistaken for current shipping parity.

## Current input tiers

### Tier 1: Official gameplay support

- **Camera on PC** via MediaPipe or successor camera tracking stacks
- **Camera on mobile** remains a planned follow-on path, not the first release priority

### Tier 2: Future-input support worth preserving in docs

These inputs may remain documented at the repo/API level because they are useful future work:

- JoyCon
- keyboard
- gamepad
- mouse
- touch
- XR

For now, treat them as **future support**, testing hooks, accessibility experiments, or platform exploration rather than official v1 gameplay promises.

## Navigation vs gameplay

AeroBeat now draws a clearer line between menu navigation and gameplay input:

- **Gameplay:** camera only for official v1
- **UI navigation on PC:** mouse is fine
- **UI navigation on mobile:** touch is fine

That distinction lets the docs stay honest without pretending every pointer or controller path is a first-class workout experience today.
