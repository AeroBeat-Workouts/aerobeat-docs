# 👁️ View Modes & Optimizations

AeroBeat is designed to run on everything from a high-end VR headset to a budget Android phone. To achieve this, we separate the **gameplay logic** from the **runtime presentation**.

## The Two Core Views

Creators need to understand that their charts are experienced in two very different ways depending on the athlete's device. These view modes are primarily runtime presentation strategies, not separate chart families. The same authored chart remains portable across views by default.

### 1. Portal View (Immersive)

* **Target Device:** VR headsets, large TVs (PC / Console).
* **Perspective:** First-person 3D.
* **Mechanic:** Targets travel toward the athlete through portal-driven 3D presentation.
* **Spatiality:** Can utilize 360-degree space (VR) or wide 180-degree arcs.

### 2. Track View (Linear)

* **Target Device:** Mobile phones, tablets, laptops, and any compact 2D presentation surface.
* **Perspective:** Linear 2D.
* **Mechanic:** Targets travel through fixed lanes or lane-like tracks on a flat display.
* **Common Subtype:** Bottom-to-top upward scrolling is common, especially for Step and some Boxing presentations, but Track View is not limited to that single layout.
* **Constraint:** Limited screen real estate.

## 🔄 Auto-Optimizations & Fallbacks

To ensure a "Pro" difficulty chart created for VR is still playable on a phone, the engine applies automatic optimizations at runtime.

### The "360 to 2D" Fold

* **Scenario:** A chart uses **360-Portal-View**, requiring the player to physically spin around to hit targets behind them.
* **The Problem:** A mobile player cannot see behind them, nor can the camera track them if they turn away from the screen.
* **The Fix:** The engine detects the device type. On 2D screens, rear and side portals are mathematically folded onto the main forward-facing plane.
  * *Result:* The athlete performs the same arm gesture (for example, Left Hook), but the target appears in a readable front-facing Track View presentation instead of directly behind or beside them.

### Snap-Fatigue Prevention

* **Scenario:** Rapid switching between extreme left and extreme right portals.
* **The Problem:** On a small phone screen in Track View, this looks like visual noise and is hard to read.
* **The Fix:** The Track View renderer clamps the horizontal lane spread. While the physical input required remains high-energy, the visual representation stays inside the readable zone of the device's aspect ratio.
