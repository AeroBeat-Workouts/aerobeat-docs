# State Management

To support multiplayer without refactoring core logic, we strictly separate **Immutable Context** from **Mutable State**.

### The Session Context (Immutable)

* **Class:** `AeroSessionContext` (Core).
* **Role:** Defines the "Rules of the Round" (Song ID, Difficulty, Modifiers, Random Seed).
* **Sync:** Sent **Once** by the Host before the round starts.
* **Rule:** Features **READ** this to configure themselves. They **NEVER** modify it.

### The User State (Mutable / Replicated)

* **Class:** `AeroUserState` (Core).
* **Role:** Holds real-time player data (Score, Combo, Health, Current Input Pose).
* **Authority:** The **Local Client** is the authority on their own score/hits (Client-Side Prediction).
* **Replication:**
    * **High Frequency (Unreliable):** Avatar Pose (Head/Hands) for visual representation.
    * **Event Based (Reliable):** Score updates, Combo breaks, Health changes.
* **Rule:** Features write to their Local `AeroUserState`. The Assembly handles replicating this object to other peers.

### The User Profile (Persistent)

* **Class:** `AeroUserProfile` (Core).
* **Role:** Long-term persistence of player progress, economy, and settings.
* **Storage:** Managed by **`aerobeat-tool-settings`** (Serializes to `user://profile.res`).
* **Schema:**

```gdscript
class_name AeroUserProfile
extends Resource

# Economy
@export var wallet_balance: int = 0
@export var unlocked_cosmetics: Array[String] = [] # List of Resource IDs

# Gamification
@export_group("Gamification")
@export var weekly_goal_days: int = 3
@export var current_week_stamps: Array[Dictionary] = [] # [{ "date": "2023-10-27", "score": 15000 }]
@export var weekly_modes_played: Array[String] = [] # ["boxing", "flow"]
@export var streak_weeks: int = 0
@export var streak_freezes: int = 0
@export var last_quest_generation: int = 0 # Unix Timestamp
@export var active_quests: Array[Resource] = []

# Settings
@export var preferences: AeroUserPreferences = AeroUserPreferences.new()
```

### The User Preferences (Persistent)

* **Class:** `AeroUserPreferences` (Core).
* **Role:** Long-term persistence of player preferences.
* **Storage:** Managed by **`aerobeat-tool-settings`** (Serializes to `user://preferences.res`).
* **Schema:**

```gdscript
class_name AeroUserPreferences
extends Resource

# Visuals
@export var override_environment_id: String = "" # Empty = Use Playlist
@export var override_skin_id: String = ""        # Empty = Use Playlist
@export var show_coach: bool = true

# Menu
@export var menu_background_id: String = "default"

# Gameplay
@export var default_mode: String = "boxing"
@export var default_view_type: String = "portal" # "portal" or "track"
@export var default_difficulty: String = "hard"
```