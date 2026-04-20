# Daily Quests System

The Daily Quest system provides short-term goals to encourage daily engagement and guide players to explore different features of AeroBeat.

## 1. Overview

*   **Frequency:** Quests reset every 24 hours (00:00 UTC).
*   **Quantity:** 3 Quests per day.
*   **Rewards:** Workout Points (WP).
*   **Requirement:** Online connection required to generate and complete quests.

## 2. Quest Tiers

Quests are generated in three difficulty tiers to ensure accessibility for all skill levels while providing a challenge for veterans.

| Tier | Reward | Difficulty | Target Audience | Example |
| :--- | :--- | :--- | :--- | :--- |
| **Easy** | **100 WP** | Participation | Everyone | "Play 1 Song in Boxing Mode" |
| **Medium** | **250 WP** | Effort | Regulars | "Complete 2 Workouts" |
| **Hard** | **500 WP** | Skill/Endurance | Veterans | "Complete over 30 minutes of Pro level Workouts" |

## 3. Quest Types

The system selects from a pool of quest templates.

### A. Mode Specific
Encourages trying different gameplay styles.
*   *Play [X] songs in Boxing Mode.*
*   *Play [X] songs in Flow Mode.*
*   *Play [X] songs in Step Mode.*

### B. Performance Based
Encourages skill improvement.
*   *Achieve [X]% Accuracy in a song.*
*   *Get a Combo of [X].*

### C. Endurance Based
Encourages longer sessions.
*   *Play for [X] minutes total.*
*   *Complete [X] Workouts.*

## 4. Generation Logic

To prevent frustration, the generation logic considers the player's history (if available).

1.  **The "Anti-Frustration" Check:**
    *   If a player has *never* played "Pro" difficulty, do not generate "Pass a Pro Song" quests.
    *   If a player exclusively plays "Seated Mode", avoid "Squat" related quests (if trackable).

2.  **Variety Enforcement:**
    *   The 3 daily quests must be distinct types (e.g., not 3 "Boxing" quests).

## 5. Reroll Mechanics

Sometimes a quest is physically impossible for a user (e.g., an injury prevents Flow mode).

*   **Allowance:** 1 Free Reroll per day.
*   **Cost:** Subsequent rerolls cost **50 WP** (small sink).
*   **Logic:** Rerolling guarantees a *different* quest template than the current one.

## 6. Technical Implementation

### State Management
Quests are stored in `AeroUserProfile` but validated by the server.

```gdscript
# AeroQuest Instance
{
    "id": "quest_boxing_easy_01",
    "type": "play_mode",
    "target": "boxing",
    "count_required": 1,
    "count_current": 0,
    "reward": 100,
    "status": "active" # active, completed, claimed
}
```

### Server Authority
*   **Generation:** The Server generates the daily seed/list.
*   **Completion:** When a workout finishes, the client sends the result. The server checks active quests and updates progress.
*   **Claiming:** Rewards are added directly to the server-side wallet.