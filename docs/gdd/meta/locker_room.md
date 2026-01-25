# The Locker Room (Customization & Shop)

The Locker Room is the immersive 3D space where athletes customize their Avatar. It functions as both an **Inventory Manager** and the **Item Shop**.

## 1. Overview

*   **Role:** Avatar customization and spending "Workout Points" (WP).
*   **Perspective:** 3D "Fitting Room" view.
*   **Requirement:** Online connection required for transactions (Server Authority).

## 2. Layout & UX

The screen is divided into three zones to maximize the view of the Avatar.

### A. The Stage (Center)

*   **Content:** The athlete's 3D Avatar.
*   **Controls:**
    *   *Rotate:* Drag horizontally.
    *   *Zoom:* Pinch / Scroll Wheel.
    *   *Reset:* Button to return to default view.

### B. The Category Rack (Left Panel)

Navigation for different body slots.

*   **Slots:**
    *   Head (Hats, Helmets)
    *   Face (Glasses, Masks)
    *   Torso (Shirts, Jackets)
    *   Hands (Gloves, Watches)
    *   Legs (Pants, Shorts)
    *   Feet (Shoes)
    *   Accessories (Backpacks, Auras)

### C. The Shelf (Right Panel)

A grid displaying items for the selected category.

*   **Tabs:** "Owned" (Inventory) vs "Shop" (Unowned).
*   **Item Card:**
    *   *Thumbnail:* Icon of the item.
    *   *Status:* Equipped / Owned / Price (WP).
    *   *Rarity:* Border color (Common/Rare/Legendary).
    *   *Exclusivity:* Supporter Icon (if applicable).

## 3. The "Fitting Room" Logic

We allow players to try before they buy.

### Preview Mode

1.  Clicking an **Unowned** item temporarily equips it on the Avatar.
2.  The "Buy" button appears at the bottom of the screen.
3.  Leaving the category or exiting the Locker Room reverts the Avatar to its previous state unless purchased.

### Conflict Resolution

Some items cannot be worn together (e.g., a Full Helmet and Sunglasses).

*   **Logic:** If a player equips an item that conflicts with a currently equipped item, the conflicting item is automatically unequipped.
*   **Feedback:** A small toast notification appears: *"Unequipped 'Aviator Shades' due to conflict."*

### Runtime Gizmos (The "Perfect Fit")

Since UGC Avatars vary in shape, accessories might clip.

*   **Feature:** When an accessory is selected, an "Adjust" button appears.
*   **Gizmo:** Allows minor Position, Rotation, and Scale adjustments relative to the attachment bone.
*   **Persistence:** These offsets are saved in the `AeroUserProfile` for that specific `(AvatarID, ItemID)` pair.

## 4. The Shop & Economy

### Purchasing Flow

To prevent accidental spending, we use a "Hold to Confirm" interaction.

1.  **Select:** Player clicks an unowned item (e.g., "Neon Visor - 500 WP").
2.  **Preview:** Avatar wears the item.
3.  **Buy:** The "Purchase" button becomes active.
    *   *State:* If `Wallet < Cost`, button is Disabled (Red).
    *   *State:* If `Wallet >= Cost`, button is Enabled (Green).
4.  **Confirm:** Player holds the button for 1.0s. A radial fill animation plays.
5.  **Transaction:**
    *   Client sends `POST /api/store/purchase` to Server.
    *   Server validates funds, deducts WP, adds Item ID to inventory.
    *   Server responds `200 OK`.
6.  **Unlock:** UI plays "Unlock FX", deducts WP from HUD, and switches item state to "Owned".

### Supporter Exclusives

Certain cosmetic items are tagged as **Supporter Exclusive**.

*   **Visibility:** These items are hidden from the Shop for free players (or shown with a lock icon).
*   **Purchase:** Only active Supporters can purchase them.
*   **Cost:** They still require **Workout Points (WP)** to unlock. Being a Supporter grants *access*, not the item itself.

### Online Requirement

*   **Validation:** The client `AeroUserProfile` is a cache. The Server is the authority on Wallet Balance.
*   **Offline:** If the player is offline, the "Shop" tab is disabled/hidden. Only "Owned" items can be equipped.

## 5. Technical Integration

*   **Data Source:** `AeroCosmeticResource` (Price, Slot, Model).
*   **State:** `AeroUserProfile` (Inventory, Wallet).
*   **Transaction:** **`aerobeat-tool-api`** (Handles purchase requests).
*   **Scene:** `LockerRoom.tscn` (3D Environment).