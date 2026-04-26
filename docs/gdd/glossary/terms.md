# Project Glossary

Use this glossary of AeroBeat specific terms to keep the docs set aligned.

| Term | Definition |
| :--- | :--- |
| **Song** | The reusable audio / timing asset and metadata source for gameplay content. |
| **Routine** | The gameplay-mode-specific package for one Song, such as the boxing routine for that song. |
| **Chart** | One concrete playable chart inside a Routine representing a single difficulty and compatibility slice. |
| **Workout** | An ordered training program that assembles exact chart selections into a session and owns workout-level coaching/session flow. |
| **Workout Package** | A self-contained on-disk folder containing `workout.yaml`, typed YAML content folders, package-local media/resources, and optional disposable local caches. |
| **Coach Config** | The single workout-level coaching YAML domain inside a package. If coaching is disabled it reduces to `enabled: false`; if enabled it must define the coach roster, warmup/cooldown video references, and exactly one overlay audio clip per workout entry. |
| **Chart Envelope** | The shared chart-level contract that carries ids, timing, scoring, presentation hints, and a mode-specific event payload. |
| **Interaction Family** | A durable movement-target abstraction such as `gesture_2d`, `tracked_6dof`, or `hybrid`, used instead of binding content directly to a raw device. |
| **Input Provider** | The top-level runtime/gameplay abstraction that bridges hardware input systems to gameplay logic. |
| **Provider Pattern** | The architectural pattern where gameplay consumes normalized data through an Input Provider instead of talking to hardware directly. |
| **Input Profile** | A concrete runtime or device compatibility target, such as `mediapipe_camera` or `keyboard_debug`. |
| **Strategy** | An implementation-detail logic-swapping pattern used inside a system or provider. It is not the public docs term for AeroBeat's overall input abstraction. |
| **Measure** | A unit of musical time (4 beats). |
| **Lane Index** | Integer representing position when playing in Track View. Range and orientation depend on gameplay and renderer (for example, 2 for Boxing, 4 for Step). |
| **Hit Window** | The timeframe (±ms) where a hit counts as valid. |
| **Tool** | A reusable service or singleton manager (for example API or Analytics) independent of gameplay logic. |
| **Atom** | A base UI element (Button) in the UI Kit. |
| **Session Context** | Immutable rules of the round (Song, Difficulty). Synced once. |
| **User State** | Mutable player data (Score, Health). Replicated frequently. |
| **Remote Athlete** | A networked opponent visualized via a customizable Avatar. |
| **Authority** | The peer responsible for calculating specific logic (for example, local client for hits). |
| **Track View** | The broader family of linear 2D runtime presentation modes. Bottom-to-top upward scrolling is a common subtype, especially for Step, but not the only valid Track View form. |
| **Portal View** | 3D visualization where targets travel toward the athlete from portal-driven spatial presentation. |
| **Skin** | A visual replacement for a gameplay object (Gloves, Bats, Targets, Obstacles). |
| **Avatar** | A 3D character model representing the player or coach. |
| **Cosmetic** | An accessory attachment for an Avatar (Hat, Glasses). |
| **Environment** | The package-local authored environment record and its referenced scene/lighting resources used to surround gameplay for a workout entry. |
| **Asset** | A package-local typed runtime-presented content record. The locked v1 asset types are `gloves`, `targets`, `obstacles`, and `trails`. |
| **Asset Type** | The closed v1 enum that identifies what kind of package asset a record is. Unknown values fail validation rather than silently behaving like generic assets. |
| **workouts.db** | The local SQLite discovery/index database for installed workouts. It powers browse/search/filter views but is not the authored source of truth. |
| **Catalog DB** | A SQLite browse/discovery snapshot that uses the shared AeroBeat catalog core schema. Local installs use the core tables plus `workout_local`; remote/distribution snapshots use the same core tables plus `workout_remote`. |
| **Leaderboard Cache** | The local disposable per-workout SQLite cache used for leaderboard browsing. It is non-authoritative and excluded from canonical package submission payloads. |
