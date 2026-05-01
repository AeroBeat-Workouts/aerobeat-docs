# Welcome to AeroBeat

**AeroBeat** is an open-source rhythm workout platform currently focused on one official v1 gameplay-input combination: **camera-driven Boxing and Flow on PC first**.

The broader long-term vision still matters, but this docs set now reflects the tighter product slice we are actually building first: webcam-based gameplay, community-authored workouts, and a release path that prioritizes **PC community**, then **mobile**, then **VR**.

---

## What is in scope right now

- **Official v1 gameplay features:** Boxing and Flow
- **Official v1 gameplay input:** Camera only
- **Primary release target:** PC community edition
- **Workout package direction:** songs, charts, sets, workouts, coaching, and environments
- **Customization direction:** profile/avatar/cosmetics progression and unlocks, not package-local gameplay asset swaps

## What stays documented as future-looking work

These docs still keep useful references for later expansion, but they should be read as **future-platform or future-input support**, not current v1 commitments:

- mobile gameplay support after the PC community release
- VR product work after mobile
- non-camera gameplay input providers such as keyboard, gamepad, JoyCon, touch, mouse, and XR
- broader runtime shells and platform-specific presentation work

## Documentation paths

### [Game Design](gdd/concept.md)

Use the GDD section for the product thesis, gameplay framing, release sequencing, and contributor-facing terminology.

### [Technical Architecture](architecture/overview.md)

Use the architecture section for the current lane split, official v1 input stance, workout package contracts, and repo boundaries.

### [Contributor Guides](guides/contributing_workflow.md)

Use the guides for practical authoring and onboarding, including choreography guidance for Boxing and Flow, calibration, accessibility, and the demo workout package.

### [Example Workout Package](examples/workout-packages/overview.md)

Use the package example when you want one concrete end-to-end fixture for the current docs contract.

---

## Current status

AeroBeat is still in prototype. This docs repo intentionally distinguishes between:

- **official v1 scope**
- **valuable future research / future-platform work**
- **removed concepts that are no longer part of the active product slice**

If a page talks about non-camera gameplay input or VR, read it as future-looking unless that page explicitly says otherwise.
