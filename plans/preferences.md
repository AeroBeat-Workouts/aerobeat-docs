# Strategic Plan: Athlete Preferences & Overrides

This document outlines the system allowing athletes to customize their experience, overriding default playlist settings with their personal favorites.

## 1. Philosophy: "My Game, My Way"

While Playlists suggest specific Environments and Skins to create a mood, athletes often have strong preferences for visibility or comfort. The system must allow global overrides that persist across sessions.

## 2. Preference Categories

### A. Visual Overrides (The "Comfort" Layer)
These settings override the content defined in a Playlist.

*   **Preferred Environment:**
    *   *Default:* "Use Playlist Suggestion".
    *   *Override:* Force a specific Environment (e.g., "The Void") for all songs. Critical for players prone to motion sickness or distraction.
*   **Preferred Skins:**
    *   *Default:* "Use Playlist Suggestion".
    *   *Override:* Force specific Gloves/Targets. Critical for players with color blindness or visibility issues who need high-contrast assets.
*   **Avatar Visibility:**
    *   *Toggle:* Show/Hide Coach Avatar.
    *   *Toggle:* Show/Hide Mirror (Self) Avatar.

### B. Menu Customization (The "Vibe" Layer)
*   **Main Menu Background:**
    *   *Free:* Default Hangar.
    *   *Supporter:* Select any installed Environment mod as the background.

### C. Gameplay Defaults (The "Quick Play" Layer)
Used to auto-configure the "Quick Play" button and filter the song browser.

*   **Preferred Mode:** (e.g., Boxing, Flow).
*   **Preferred View Type:** (e.g., Portal, Track).
*   **Preferred Difficulty:** (e.g., Hard).
*   **Modifiers:** (e.g., "No Obstacles", "No Squats" - persisted from Accessibility settings).

## 3. Technical Implementation

### A. Data Storage
Preferences are stored in `AeroUserProfile` (or a sub-resource `AeroUserPreferences`).

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

### B. The Override Logic (`AeroSessionBuilder`)
When a session is started, the builder must resolve conflicts between Playlist suggestions and User Preferences.

*   **Priority Order:**
    1.  User Override (if set).
    2.  Playlist Suggestion (if present).
    3.  System Default.

## 4. Execution Checklist

### Documentation
- [x] Create `docs/gdd/meta/preferences.md` detailing the UI and logic for overrides.
- [x] Update `docs/architecture/state-management.md` to include the `AeroUserPreferences` schema.
- [x] Update `docs/gdd/meta/profile.md` to mention the new "Preferences" tab/menu.

### Code
- [ ] **Core:** Implement `AeroUserPreferences` resource.
- [ ] **Logic:** Update `AeroSessionManager` to apply overrides during session setup.
- [ ] **UI:** Create `PreferencesMenu` scene.