# Project Glossary

Use this glossary of AeroBeat specific terms to help align our work.

| Term | Definition |
| :--- | :--- |
| **Song** | The reusable audio/timing asset and metadata source for gameplay content. |
| **Routine** | The gameplay-mode-specific package for one Song, such as the boxing choreography for that song. |
| **Chart Variant** | One concrete playable chart inside a Routine representing a single difficulty and compatibility slice. |
| **Workout** | An ordered training program that assembles routines or chart variants into a session. |
| **Chart Envelope** | The shared chart-level contract that carries ids, timing, scoring, presentation hints, and a mode-specific event payload. |
| **Interaction Family** | A durable movement-target abstraction such as `gesture_2d` or `tracked_6dof`, used instead of binding content directly to a raw device. |
| **Measure** | A unit of musical time (4 Beats). |
| **Lane Index** | Integer representing horizontal position when playing in `Track View`. Range depends on Gameplay (e.g., 2 for Boxing, 4 for Step). |
| **Hit Window** | The timeframe (±ms) where a hit counts as valid. |
| **Provider** | A script that bridges Hardware Input to Game Logic. |
| **Strategy** | A script that swaps logic implementations (e.g., Portal vs Track view). |
| **Tool** | A reusable service or singleton manager (e.g., API, Analytics) independent of gameplay logic. |
| **Atom** | A base UI element (Button) in the UI Kit. |
| **Session Context** | Immutable rules of the round (Song, Difficulty). Synced once. |
| **User State** | Mutable player data (Score, Health). Replicated frequently. |
| **Remote Athlete** | A networked opponent visualized via a customizable Avatar. |
| **Authority** | The peer responsible for calculating specific logic (e.g., Local Client for Hits). |
| **Track View** | 2D visualization where targets rise from bottom to top (DDR style). |
| **Portal View** | 3D visualization where targets fly towards the player from the portals origin (VR style). |
| **Skin** | A visual replacement for a gameplay object (Gloves, Bats, Targets, Obstacles). |
| **Avatar** | A 3D character model representing the player or coach. |
| **Cosmetic** | An accessory attachment for an Avatar (Hat, Glasses). |
| **Environment** | The 3D level geometry and lighting surrounding the gameplay. |