# Project Glossary

| Term | Definition |
| :--- | :--- |
| **BeatData** | The Resource defining a single gameplay object (timestamp, lane, type). |
| **Measure** | A unit of musical time (4 Beats). |
| **Lane Index** | Integer representing horizontal position when playing in `Track View`. Range depends on Gameplay (e.g., 2 for Boxing, 4 for Step). |
| **Hit Window** | The timeframe (±ms) where a hit counts as valid. |
| **Provider** | A script that bridges Hardware Input to Game Logic. |
| **Strategy** | A script that swaps logic implementations (e.g., Portal vs Track view). |
| **Atom** | A base UI element (Button) in the UI Kit. |
| **Session Context** | Immutable rules of the round (Song, Difficulty). Synced once. |
| **User State** | Mutable player data (Score, Health). Replicated frequently. |
| **Remote Athlete** | A networked opponent visualized via a customizable Avatar. |
| **Authority** | The peer responsible for calculating specific logic (e.g., Local Client for Hits). |
| **Track View** | 2D visualization where targets rise from bottom to top (DDR style). |
| **Portal View** | 3D visualization where targets fly towards the player from the portals origin (VR style). |