# 👣 Gameplay Core: "Step"

The "Step" module brings the classic arcade dance-pad experience to AeroBeat.

### The Loop

1. **The Beat:** Arrows scroll along the screen in sync with the music.
2. **The Action:** The athlete steps on the corresponding cardinal direction (Left, Down, Up, Right) when the arrow overlaps the target zone.
3. **The Feedback:** Precision is key. Ratings range from "Perfect" to "Miss".
4. **The Workout:** High-intensity cardio focusing on legs, glutes, and coordination.

### Mechanics

* **4-Lane Grid:** The standard layout uses four directional inputs: Left, Down, Up, Right.
* **Taps:** A single step on the target.
* **Holds (Freeze Arrows):** Keep your foot planted on the target for the duration of the trail.
* **Jumps:** Two arrows appear simultaneously, requiring a jump to hit both targets at once.
* **Mines:** Avoid stepping on these zones when they pass the target line.

### Input Methods

#### 1. Dance Pad (Recommended)

For the authentic arcade experience, AeroBeat recommends using a USB dance pad.

* **Support:** Native support for generic USB HID pads and console adapters via `aerobeat-input-gamepad`.
* **Latency:** Wired pads offer the lowest latency for high-difficulty charts.

#### 2. Camera / Computer Vision (Experimental)

AeroBeat is prototyping controller-free stepping using MediaPipe pose tracking.

* **The Challenge:** Standard webcams often struggle to see feet if placed on a desk.
* **Setup:** Players must place their phone or webcam low to the ground or angle it significantly downward to capture foot movement.
* **Warning:** This mode is currently **experimental**. Fast footwork may blur on standard 30fps webcams. If tracking proves unreliable, the game recommends switching to a dance pad or keyboard.

#### 3. Keyboard (Finger Mode)

* **Accessibility:** Play with your fingers using WASD or Arrow Keys. Great for testing charts or for players unable to perform the physical workout.

### View Modes

Unlike Boxing, Step gameplay is tightly associated with lanes, so Step's most common Track View form is the classic upward-scrolling layout.

* **Track View (Classic Upward-Scrolling):** The traditional waterfall view. Arrows rise from the bottom of the screen to the top. This is a common Track View subtype and the default Step presentation on mobile and laptop.
* **Portal View (VR / Immersive):** Arrows slide along the floor toward the athlete from the horizon. Best for VR headsets where the athlete can look down toward their virtual feet.

> **Note:** In **Portal View**, the hit zone is physically located on the floor around the athlete's feet rather than at chest height.
