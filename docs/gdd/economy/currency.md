# Workout Points (WP) Economy

This document details the "Workout Points" (WP) economy, the primary currency in AeroBeat used to unlock cosmetic items.

## 1. Philosophy

The goal of the WP economy is to incentivize consistency. We reward effort (Time + Difficulty) rather than just skill.

## 2. Earning WP (The Faucet)

WP is calculated at the end of every completed Workout. If the athlete started that Workout from a playlist-style browser, the underlying rewarded unit is still the Workout session.

### The Formula

`WP_Earned = (Base_Rate * Duration_Mins * Difficulty_Mult) + Accuracy_Bonus`

### Variables

*   **Base Rate:** `10 WP` per minute of active gameplay.
*   **Duration:** The total length of the completed Workout in minutes (rounded down).
*   **Difficulty Multiplier:**
    *   **Easy:** 1.0x
    *   **Normal:** 1.2x
    *   **Hard:** 1.5x
    *   **Pro:** 2.0x
*   **Accuracy Bonus:** `+50 WP` Flat Bonus if Session Accuracy > 90%.

### Examples

| Scenario | Duration | Difficulty | Accuracy | Calculation | Total WP |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **Quick Warmup** | 10 mins | Easy (1.0x) | 85% | `(10 * 10 * 1.0) + 0` | **100 WP** |
| **Standard Workout** | 30 mins | Normal (1.2x) | 92% | `(10 * 30 * 1.2) + 50` | **410 WP** |
| **Intense Session** | 45 mins | Hard (1.5x) | 95% | `(10 * 45 * 1.5) + 50` | **725 WP** |

## 3. Spending WP (The Sink)

WP is spent in the **Locker Room** to unlock cosmetic items for the Avatar.

### Pricing Tiers

| Tier | Cost | Est. Workout Time | Example Items |
| :--- | :--- | :--- | :--- |
| **Common** | 500 WP | ~30 mins | Basic colors, Wristbands. |
| **Uncommon** | 2,500 WP | ~3 hours | Patterned textures, Sunglasses. |
| **Rare** | 10,000 WP | ~2 weeks | Glowing materials, Neon gloves. |
| **Legendary** | 50,000 WP | ~2 months | Particle effect auras, Complex models. |

## 4. Risk Analysis & Mitigation

| Risk | Impact | Mitigation Strategy |
| :--- | :--- | :--- |
| **Local Save Editing** | Users edit `user_profile.tres` to give themselves infinite WP. | **Obfuscation.** Switch save format from text-based `.tres` to binary `.res` or encrypted JSON for the profile. While not hack-proof, it deters casual editing. |
| **Economy Inflation** | Hardcore players accumulate millions of WP with nothing to buy. | **Consumable Sinks.** Introduce "Workout Boosters" (e.g., "Double XP for 30 mins") or "Visual Effects" (e.g., "Fire Trail for 1 song") that cost WP to use. |
| **Content Drought** | Players unlock all cosmetics too quickly. | **Weekly Rotations.** Implement a "Featured Shop" logic in the client that only exposes a subset of items for purchase each week, even if the assets are local. |
| **UGC Conflicts** | A modder releases a "Free" version of a "Legendary" paid skin. | **ID Namespacing.** Official items use `aerobeat.official.*`. UGC uses `aerobeat.ugc.*`. The Shop only lists Official items. UGC is always free/unlocked but separated in the UI. |
| **"Pay-to-Win"** | Cosmetics obscure vision or change hitboxes. | **Strict Validation.** The `aerobeat-cosmetics` template must enforce bounding box limits. The game engine will force-unload cosmetics that exceed polycount or volume limits during gameplay. |