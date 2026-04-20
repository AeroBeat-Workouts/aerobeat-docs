# 🏋️ Gamification & Habit Building

AeroBeat uses a "Consistency over Intensity" philosophy. We reward showing up and building healthy habits rather than just burning the most calories.

## 1. Workout Points (WP)

**Workout Points** are the primary currency of AeroBeat.
*   **Earn:** Complete Workouts. Points are based on Duration, Difficulty, and Accuracy.
*   **Spend:** Unlock cosmetic items for your Avatar in the Locker Room.

## 2. The Weekly Stamp Card

This is the core retention loop, visualizing your progress towards a personal weekly goal.

### Mechanics

1.  **Set Your Goal:** Choose a **Weekly Frequency Goal** (e.g., 3 days/week).
2.  **Earn Stamps:** Complete at least one Workout (min. 10 mins) on a unique day to earn a **Day Stamp**.
3.  **Visuals:** A 7-day bar tracks your progress.
    *   *Empty:* Grey slot.
    *   *Stamped:* Green Checkmark.
    *   *Goal:* A flag marks your target day.

### Rewards

*   **Goal Met:** Hitting your target (e.g., 3rd stamp) grants a **Weekly Bonus** (e.g., 1,000 WP).
*   **Overachiever:** Additional stamps after the goal grant a smaller "Extra Credit" bonus.

## 3. The Streak System

Designed to reward long-term loyalty and consistency.

*   **Streak Counter:** Increases every week you meet your Weekly Frequency Goal.
*   **Multiplier:** Higher streaks boost your WP earnings.
    *   *Weeks 1-4:* 1.0x
    *   *Weeks 5-10:* 1.1x
    *   *Weeks 10+:* 1.25x (Cap)

### "Life Happens" Protection

We understand that illness or vacations happen.

*   **Streak Freeze:** A consumable item purchasable with WP. It automatically consumes itself if you miss a week, saving your streak.
*   **Banked Days:** Exceeding your weekly goal adds to a hidden "Bank" that can cover missed days in future weeks.

## 4. The Explorer Bonus

Encourages athletes to try different gameplay styles (Boxing, Flow, Step, etc.).

*   **Objective:** Complete at least one Workout of *every* available gameplay type within a single week.
*   **Reward:** Grants the **"Jack of All Trades" Bonus** (e.g., 500 WP).

## 5. Daily Quests

Short-term goals to encourage engagement and variety.

*   **Frequency:** 3 quests generated every 24 hours.
*   **Types:**
    *   *Easy:* "Play 1 Song in Boxing Mode"
    *   *Medium:* "Complete 2 Workouts"
    *   *Hard:* "Complete over 30 minutes of Pro level Workouts"
*   **Reroll:** Players can reroll 1 quest per day to avoid modes they cannot play (e.g., due to injury).

## 6. Online-Only Integrity

To ensure fairness and prevent cheating (e.g., changing system clocks), the Gamification system is **Server-Authoritative**.

*   **Server Time:** All streaks and quests rely on server time.
*   **Requirement:** You must be online to earn Stamps, complete Quests, or update your Streak. Offline workouts do not count towards these goals.

## 7. Risk Analysis & Mitigation

| Risk | Impact | Mitigation |
| :--- | :--- | :--- |
| **Cheating** | Players start a Workout and sit on the couch to get a Stamp. | **Activity Threshold.** A stamp is only awarded if the player achieves a minimum score or accuracy threshold (e.g. Accuracy > 10%) for the session. |
| **Demotivation** | "I missed Monday, now I can't hit my 7-day goal." | **Flexible Goals.** Encourage 3-5 day goals rather than 7. UI emphasizes "Weekly Goal" not "Daily Streak". |
| **Hoarding** | Players save WP for Streak Freezes instead of Cosmetics. | **Pricing Balance.** Freezes are expensive enough to be strategic, but cheap enough for active players to afford. |
