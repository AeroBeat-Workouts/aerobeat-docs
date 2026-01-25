# Athlete Profile Hub

The Athlete Profile is the central dashboard for player identity, progress tracking, and goal management. It serves as the "Digital Mirror" of the athlete.

## 1. Overview

*   **Role:** Central hub for stats, goals, and identity.
*   **Access:** Accessible via the "Profile Badge" in the top-right corner of the Main Menu.
*   **Philosophy:** "The Mirror" — It reflects the effort put in (Stats) and the style chosen (Avatar).

## 2. The Profile Badge (HUD)

A persistent UI element visible on the Main Menu and Song Select screens.

*   **Visuals:**
    *   Mini-Avatar Headshot (Circle crop).
    *   Username.
    *   Current Level / Total WP.
    *   Streak Flame Icon (Active/Inactive).
*   **Interaction:** Clicking the badge opens the **Profile Hub Overlay**.

## 3. Profile Hub Layout

The Hub is a modal overlay composed of modular widgets.

### A. Identity Card (Left Panel)

Focuses on "Who I Am".

*   **Avatar:** Full-body 3D render of the current avatar (Idle animation).
*   **Name:** Player Username.
*   **Title:** Unlockable titles (e.g., "Speed Demon", "Early Riser").
*   **Join Date:** "Member since [Year]".
*   **Edit Button:** Shortcut to the **Locker Room**.

### B. The "Workout Stats" (Center Panel)

Focuses on "What I've Done".

*   **Weekly Goal:** Displays the current week's Stamp Card (see [Gamification](../gamification/overview.md)).
*   **Streak:** Current active weeks count.
*   **Total WP:** Lifetime Workout Points earned.
*   **Play Time:** Total hours spent in active gameplay.

#### Supporter Enhancements (Pro Stats)

Active Supporters gain access to deeper analytics in this panel:

*   **Heatmaps:** A visual overlay showing accuracy per lane (e.g., "Weakness: Low-Left").
*   **Trend Graphs:** Toggle between Weekly, Monthly, and Yearly progress (Free users are limited to Weekly).

### C. Settings & Preferences (Center Panel)

Allows athletes to adjust their targets and customize their experience.

*   **Frequency Slider:** "I want to workout [X] days a week." (Range: 1-7).
*   **Difficulty Preference:** "Preferred Difficulty: [Pro]."
    *   *Usage:* Used by the "Playlist Browser" to auto-filter difficulty.

#### Preferences & Overrides

*   **Visuals:** Force specific Environments or Skins (e.g., for accessibility or comfort).
*   **Gameplay:** Set default Mode (Boxing/Flow) and View Type (Portal/Track).
*   **Menu:** Customize the Main Menu background (Supporter Feature).

#### Connected Athlete (Supporter Only)

*   **Health Sync:** Toggle to enable auto-upload to Strava, Apple Health, or Google Fit.
*   **Data Export:** Button to download full CSV history.

### D. Workout History (Right Panel)

A scrollable list of recent activity.

*   **Capacity:** Last 10 sessions (Unlimited for Supporters).
*   **Columns:**
    *   *Date:* (e.g., "Today", "Yesterday").
    *   *Content:* Song or Playlist Name.
    *   *Stats:* Duration, WP Earned, Accuracy %.

## 4. UI Flows

### Viewing Progress

1.  **User** clicks the Profile Badge on the Main Menu.
2.  **System** opens the `ProfileHub` modal.
3.  **User** reviews the Stamp Card to see if they hit their weekly goal.

### Changing Goals

1.  **User** opens `ProfileHub`.
2.  **User** clicks the "Settings" tab.
3.  **User** adjusts the "Days per Week" slider from 3 to 5.
4.  **User** clicks "Save".
5.  **System** updates the local `AeroUserProfile` and syncs with the server.

## 5. Technical Integration

*   **Data Source:** `AeroUserProfile` (Resource).
*   **Persistence:** **`aerobeat-tool-settings`** (Saves profile to disk).
*   **Sync:** **`aerobeat-tool-api`** (Syncs profile to cloud).
*   **3D Avatar:** The Hub instantiates a `SubViewport` to render the 3D Avatar scene separately from the UI, ensuring high fidelity.