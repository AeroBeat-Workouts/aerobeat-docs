# Project Glossary

Use this glossary to keep the docs set aligned with the current AeroBeat scope.

| Term | Definition |
| :--- | :--- |
| **Song Package** | A self-contained imported song-root folder containing package metadata plus the song/charts/sets needed for local playback. It may contain multiple exact playable difficulties or feature slices for the same imported source song. |
| **Song** | The reusable audio and timing source for gameplay content. |
| **Chart** | One concrete playable authored or converted chart representing a single feature+difficulty slice. |
| **Set** | The exact playable record that links one Song and one Chart. |
| **Playlist** | A future multi-song grouping above song packages. |
| **Input Provider** | The runtime abstraction that bridges hardware input systems to gameplay logic. |
| **Input Profile** | A concrete runtime or device compatibility target, such as `mediapipe_camera` or another future provider profile. |
| **Track View** | The broader family of linear 2D runtime presentation modes. |
| **Portal View** | A presentation/view term only. It is not current authored chart-contract truth. |
| **Avatar** | A 3D character model representing the player or coach. |
| **Cosmetic** | An account-level accessory or presentation unlock for an avatar or profile identity. |
| **leaderboard-cache.db** | The local disposable per-song-package SQLite cache used for leaderboard browsing where applicable. |
