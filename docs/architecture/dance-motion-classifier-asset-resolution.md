# Dance motion/classifier asset resolution notes

Public Just Dance / OpenDance tooling points to a consistent asset-resolution pattern:

- A timed move entry does **not** contain the motion data itself.
- It resolves to an external classifier asset via a move name or explicit `ClassifierPath`.
- In the inspectable OpenDance/Bluestar path, `currentMove.name` resolves to `opendance_data/mapdata/<Song>/timeline/moves/<move>.msm`.
- In inspectable UbiArt/DTAPE tooling, `MotionClip.ClassifierPath` typically resolves to `world/maps/<map>/timeline/moves/<move>.msm` for normal motion scoring and `.gesture` for gesture/camera-style scoring.
- Coach ownership is carried separately via `CoachId`; the classifier file path stays under the shared song map’s `timeline/moves/` area rather than a per-coach folder.

What is directly inspectable:

- `.msm` has a reverse-engineered binary reader in OpenDance with fields including `move_name`, `song_name`, `classifier_type`, `duration`, thresholds, measure counts, and a float `measures[]` payload used as reference scoring data.
- `.gesture` is directly inspectable only at the **reference level** in public tools: DTAPE/deserializer code emits `MotionClip` entries with `MoveType: 1` and a `.gesture` `ClassifierPath`, but the underlying binary gesture-file body is not parsed by the public OpenDance runtime code we inspected.

Implication for AeroBeat docs:

- If a chart says “play move X,” the closest Just Dance/OpenDance analogue is: resolve `X` to a timed motion-classifier asset path, then score against that external asset, while keeping preview/picto/media assets adjacent but separate.
