# Welcome to AeroBeat

**AeroBeat** is an open-source rhythm workout platform currently focused on one official v1 gameplay-input combination: **camera-driven Boxing and Flow on PC first**.

The broader long-term vision still matters, but this docs set now reflects the tighter product slice we are actually building first: webcam-based gameplay, BeatSaver-powered song import/conversion, and a release path that prioritizes **PC community**, then **mobile**, then **VR**.

---

## What is in scope right now

- **Official v1 gameplay features:** Boxing and Flow
- **Official v1 gameplay input:** Camera only
- **Primary release target:** PC community edition
- **Default content direction:** imported **song packages** with multiple converted charts/difficulties under one song root
- **Multi-song grouping direction:** **playlists**, not workout-package bundles
- **Environment direction:** player/system-selected environments outside song packages by default
- **Coaching direction:** not part of the default imported-player contract
- **Customization direction:** profile/avatar/cosmetics progression and unlocks, not package-local gameplay asset swaps

## What stays documented as future-looking work

These docs still keep useful references for later expansion, but they should be read as **future-platform or future-input support**, not current v1 commitments:

- mobile gameplay support after the PC community release
- VR product work after mobile
- non-camera gameplay input providers such as keyboard, gamepad, JoyCon, touch, mouse, and XR
- broader runtime shells and platform-specific presentation work
- any future curated/manual-authored content workflow beyond the default imported-player path

## Documentation paths

### [Game Design](gdd/concept.md)

Use the GDD section for the product thesis, gameplay framing, release sequencing, and contributor-facing terminology.

### [Technical Architecture](architecture/overview.md)

Use the architecture section for the current lane split, official v1 input stance, song-package + playlist direction, BeatSaver conversion contracts, and repo boundaries.

### [Contributor Guides](guides/contributing_workflow.md)

Use the guides for practical onboarding plus the current Boxing and Flow choreography references.

### [BeatSaver Conversion Contracts](architecture/beatsaver-flow-v1-conversion.md)

Use the Flow and Boxing conversion architecture docs as the canonical current-truth source for imported gameplay content.

---

## Current status

AeroBeat is still in prototype. This docs repo intentionally distinguishes between:

- **official v1 scope**
- **valuable future research / future-platform work**
- **removed concepts that are no longer part of the active product slice**

If a page talks about non-camera gameplay input, VR, or richer manual-authored package workflows, read it as future-looking or historical unless that page explicitly says otherwise.
