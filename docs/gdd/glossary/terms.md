# Project Glossary

Use this glossary to keep the docs set aligned with the current AeroBeat scope.

| Term | Definition |
| :--- | :--- |
| **Song** | The reusable audio and timing source for gameplay content. |
| **Chart** | One concrete playable authored chart representing a single difficulty and compatibility slice. |
| **Set** | The package-local composition record that links one Song, one Chart, one Environment, and optional coaching overlay choices. |
| **Workout** | An ordered training program that assembles exact set selections into a session. |
| **Workout Package** | A self-contained on-disk folder containing `workout.yaml`, typed content folders, package-local media/resources, and optional disposable local caches. |
| **Coach Config** | The single workout-level coaching YAML domain inside a package. |
| **Environment** | The package-local authored environment record selected by a workout set. |
| **Input Provider** | The runtime abstraction that bridges hardware input systems to gameplay logic. |
| **Input Profile** | A concrete runtime or device compatibility target, such as `mediapipe_camera` or `keyboard_debug`. |
| **Track View** | The broader family of linear 2D runtime presentation modes. |
| **Portal View** | 3D visualization where targets travel toward the athlete from portal-driven spatial presentation. |
| **Avatar** | A 3D character model representing the player or coach. |
| **Cosmetic** | An account-level accessory or presentation unlock for an avatar or profile identity. |
| **workouts.db** | The local SQLite discovery/index database for installed workouts. |
| **Leaderboard Cache** | The local disposable per-workout SQLite cache used for leaderboard browsing. |
