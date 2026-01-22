# 👁️ View Modes & Optimizations

AeroBeat is designed to run on everything from a high-end VR headset to a budget Android phone. To achieve this, we separate the **Gameplay Logic** from the **Visualization**.

## The Two Core Views

Creators should understand that their charts will be experienced in two very different ways depending on the athlete's device.

### 1. Portal View (Immersive)

*   **Target Device:** VR Headsets, Large TVs (PC/Console).
*   **Perspective:** First-Person 3D.
*   **Mechanic:** Targets fly towards the player from "Portals" in 3D space.
*   **Spatiality:** Can utilize 360-degree space (VR) or wide 180-degree arcs.

### 2. Track View (Linear)

*   **Target Device:** Mobile Phones, Tablets, Laptops.
*   **Perspective:** 2D "Waterfall" (Vertical or Horizontal).
*   **Mechanic:** Targets rise along fixed lanes (like *Dance Dance Revolution* or *Guitar Hero*).
*   **Constraint:** Limited screen real estate.

## 🔄 Auto-Optimizations & Fallbacks

To ensure a "Pro" difficulty chart created for VR is still playable on a phone, the Engine applies automatic optimizations at runtime.

### The "360 to 2D" Fold

*   **Scenario:** A chart uses **360-Portal-View**, requiring the player to physically spin around to hit targets behind them.
*   **The Problem:** A mobile player cannot see behind them, nor can the camera track them if they turn away from the screen.
*   **The Fix:** The Engine detects the device type. On 2D screens, "Rear" and "Side" portals are mathematically "folded" onto the main forward-facing plane.
    *   *Result:* The player performs the same arm gesture (e.g., Left Hook), but the target appears from the front-left instead of directly left.

### Snap-Fatigue Prevention
*   **Scenario:** Rapid switching between extreme left and extreme right portals.
*   **The Problem:** On a small phone screen in Track View, this looks like visual noise and is hard to read.
*   **The Fix:** The Track View renderer clamps the horizontal lane spread. While the physical input required remains high-energy, the visual representation is kept within the "readable zone" of the device's aspect ratio.