# Strategic Plan: Workout Points & Cosmetic Economy

This document outlines the implementation plan for the "Workout Points" (WP) economy, transforming it from a simple score counter into a functional currency for unlocking Avatar cosmetics.

## 1. The Core Loop

**Objective:** Incentivize consistent workouts by rewarding effort with customization options.

1.  **Earn:** Player completes a Playlist.
2.  **Reward:** WP is calculated based on **Duration**, **Difficulty**, and **Accuracy**.
3.  **Accumulate:** WP is stored in the local `AeroUserProfile`.
4.  **Spend:** Player purchases items in the **Locker Room** UI.
5.  **Equip:** Unlocked items are applied to the Avatar.

## 2. Economy Design (The "Faucet")

We need a balanced earn rate that feels rewarding but requires dedication for top-tier items.

### The Formula
`WP_Earned = (Base_Rate * Duration_Mins * Difficulty_Mult) + Accuracy_Bonus`

*   **Base_Rate:** 10 WP per minute.
*   **Difficulty_Mult:**
    *   Easy: 1.0x
    *   Normal: 1.2x
    *   Hard: 1.5x
    *   Pro: 2.0x
*   **Accuracy_Bonus:** If Accuracy > 90%, add flat 50 WP.

*Example:* 30 min workout on Hard with 92% accuracy.
`(10 * 30 * 1.5) + 50 = 450 + 50 = 500 WP`.

### Pricing Tiers (The "Sink")

| Tier | Cost | Est. Workout Time | Example Items |
| :--- | :--- | :--- | :--- |
| **Common** | 500 WP | ~30 mins | Basic colors, Wristbands. |
| **Uncommon** | 2,500 WP | ~3 hours | Patterned textures, Sunglasses. |
| **Rare** | 10,000 WP | ~2 weeks | Glowing materials, Neon gloves. |
| **Legendary** | 50,000 WP | ~2 months | Particle effect auras, Complex models. |

## 3. Technical Implementation

### A. Data Schema Updates (`aerobeat-core`)

We must update the core resources to support currency and ownership.

**1. `AeroCosmeticResource`**
Add economy fields to the base resource.
```gdscript
@export_group("Economy")
@export var unlock_cost: int = 0  # 0 implies free/default
@export var is_premium: bool = false # If true, cannot be bought with WP (future proofing)
```

**2. `AeroUserProfile`**
Add persistence for the wallet and inventory.
```gdscript
@export var wallet_balance: int = 0
@export var unlocked_cosmetics: Array[String] = [] # List of Resource IDs
```

### B. UI Architecture (`aerobeat-ui-shell`)

**1. The Locker Room (Shop Mode)**

*   **Filter:** Toggle between "Owned" and "Shop".
*   **Card State:**
    *   *Owned:* Show "Equip" button.
    *   *Affordable:* Show "Buy [Cost] WP" button (Green).
    *   *Too Expensive:* Show "Buy [Cost] WP" button (Red/Disabled).
*   **Confirmation:** Simple "Hold to Buy" interaction to prevent accidental clicks.

**2. Post-Workout Screen**

*   Add a "Currency Gained" animation counting up the WP earned alongside the Calorie counter.

## 4. Risk Analysis & Mitigation

| Risk | Impact | Mitigation Strategy |
| :--- | :--- | :--- |
| **Local Save Editing** | Users edit `user_profile.tres` to give themselves infinite WP. | **Obfuscation.** Switch save format from text-based `.tres` to binary `.res` or encrypted JSON for the profile. While not hack-proof, it deters casual editing. |
| **Economy Inflation** | Hardcore players accumulate millions of WP with nothing to buy. | **Consumable Sinks.** Introduce "Workout Boosters" (e.g., "Double XP for 30 mins") or "Visual Effects" (e.g., "Fire Trail for 1 song") that cost WP to use. |
| **Content Drought** | Players unlock all cosmetics too quickly. | **Weekly Rotations.** Implement a "Featured Shop" logic in the client that only exposes a subset of items for purchase each week, even if the assets are local. |
| **UGC Conflicts** | A modder releases a "Free" version of a "Legendary" paid skin. | **ID Namespacing.** Official items use `aerobeat.official.*`. UGC uses `aerobeat.ugc.*`. The Shop only lists Official items. UGC is always free/unlocked but separated in the UI. |
| **"Pay-to-Win"** | Cosmetics obscure vision or change hitboxes. | **Strict Validation.** The `aerobeat-cosmetics` template must enforce bounding box limits. The game engine will force-unload cosmetics that exceed polycount or volume limits during gameplay. |

## 5. Execution Checklist

### Documentation
- [ ] Create `docs/gdd/economy/currency.md` detailing the math.
- [ ] Update `docs/guides/cosmetics.md` with "Setting a Price" instructions.
- [ ] Update `docs/architecture/state-management.md` with the new UserProfile schema.

### Code
- [ ] **Core:** Update `AeroCosmeticResource` and `AeroUserProfile`.
- [ ] **Logic:** Implement `AeroEconomyManager` singleton (Add/Subtract/Validate funds).
- [ ] **UI:** Update `LockerRoom` scene in `aerobeat-ui-shell`.