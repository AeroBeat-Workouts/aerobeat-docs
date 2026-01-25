# Athlete Preferences & Overrides

This document details the "Preferences" system, which allows athletes to customize their visual and gameplay experience, overriding default playlist settings.

## 1. Philosophy

**"My Game, My Way."**

While Playlists suggest specific Environments and Skins to create a mood, athletes often have strong preferences for visibility, comfort, or accessibility. The system must allow global overrides that persist across sessions.

## 2. Preference Categories

Preferences are divided into three layers based on their impact.

### A. Visual Overrides (The "Comfort" Layer)

These settings override the content defined in a Playlist.

*   **Preferred Environment:**
    *   *Default:* "Use Playlist Suggestion".
    *   *Override:* Force a specific Environment (e.g., "The Void") for all songs.
    *   *Use Case:* Critical for players prone to motion sickness or distraction who need a consistent background.
*   **Preferred Skins:**
    *   *Default:* "Use Playlist Suggestion".
    *   *Override:* Force specific Gloves/Targets.
    *   *Use Case:* Critical for players with color blindness or visibility issues who need high-contrast assets.
*   **Avatar Visibility:**
    *   *Show Coach:* Toggle visibility of the virtual coach (if available).
    *   *Show Mirror:* Toggle visibility of the player's own avatar reflection.

### B. Menu Customization (The "Vibe" Layer)

*   **Main Menu Background:**
    *   *Free:* Default Environment.
    *   *Supporter:* Select any installed Environment (official or mod) as the background.

### C. Gameplay Defaults (The "Quick Play" Layer)

Used to auto-configure the "Quick Play" button and filter the song browser.

*   **Preferred Mode:** (e.g., Boxing, Flow).
*   **Preferred View Type:** (e.g., Portal, Track).
    *   *Portal:* Targets spawn from a portal in front of the player.
    *   *Track:* Targets travel down a long highway (classic rhythm game style).
*   **Preferred Difficulty:** (e.g., Hard).
*   **Modifiers:** (e.g., "No Obstacles", "No Squats"). These are persisted from Accessibility settings.

## 3. UI Implementation

The Preferences menu is accessible via the **Profile Hub** or the main **Settings** screen.

### Layout

*   **Tabbed Interface:**
    *   *Visuals:* Environment/Skin overrides.
    *   *Gameplay:* Defaults for Mode/Difficulty.
    *   *Menu:* Background selection.
*   **Preview Window:** When selecting an Environment or Skin override, show a live preview.

## 4. Technical Logic

### Data Storage
Preferences are stored in the `AeroUserProfile` resource under a sub-resource or group. Persistence is managed by **`aerobeat-tool-settings`**.

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

### The Override Logic (`AeroSessionBuilder`)

When a session is started, the `AeroSessionBuilder` resolves conflicts between Playlist suggestions and User Preferences.

**Priority Order:**

1.  **User Override:** If the user has explicitly set "Force Void Environment", this wins.
2.  **Playlist Suggestion:** If no override, use the Environment defined by the Playlist.
3.  **System Default:** If the Playlist has no suggestion, use the default fallback.

```gdscript
func get_environment_id(playlist: AeroPlaylist, prefs: AeroUserPreferences) -> String:
    if prefs.override_environment_id != "":
        return prefs.override_environment_id
    if playlist.suggested_environment_id != "":
        return playlist.suggested_environment_id
    return "env_default_hangar"
```