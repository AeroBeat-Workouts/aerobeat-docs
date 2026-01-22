# 💃 Gameplay Core: "Dance"

The "Dance" module brings the full-body choreography experience to AeroBeat.

### The Loop

1.  **The Beat:** A virtual coach performs dance moves on screen in sync with the music.
2.  **The Action:** The athlete mimics the movements of the coach as if looking in a mirror.
3.  **The Feedback:** Motion matching algorithms score your pose accuracy and timing.
4.  **The Workout:** Full-body cardio, coordination, and flexibility.

### Mechanics

*   **The Coach:** A 3D avatar that demonstrates the current move.
*   **Pictograms:** Scrolling icons on the side of the screen preview the next move (e.g., "Spin", "Clap", "Slide").
*   **Pose Matching:** The core scoring mechanic. We compare your limb positions against the target pose.
*   **Gold Moves:** Special high-impact poses that trigger a "Yeah!" effect and bonus points if hit perfectly.

### Input Methods

#### 1. Camera / Computer Vision (Recommended)

For the most authentic experience, we recommend using a Webcam or Phone Camera.

*   **Technology:** Uses MediaPipe Pose to track 33 body landmarks.
*   **Requirement:** **Full Body View.** Unlike Boxing (which only needs upper body), Dance requires the camera to see your feet and hands. Place the camera further back or higher up.
*   **Feedback:** You see a video feed of yourself next to the coach (Mirror Mode).

#### 2. VR (Immersive)

*   **Tracking:** Uses Headset and Controllers to track Head and Hands.
*   **Limitation:** Without full-body trackers (Vive Trackers), we infer leg movement or ignore it for scoring.
*   **Experience:** You are on the dance floor with the coach.

#### 3. Joycon / Phone (Motion Controller)

*   **Tracking:** Uses the Accelerometer and Gyroscope in your hand.
*   **Style:** Similar to console dance games. We track the velocity and rotation of your right hand (or both).
*   **Limitation:** Less precise than Camera; focuses on timing and arm energy rather than full pose accuracy.

### View Modes

*   **Studio View (2D):** The standard view. The Coach is center stage. Pictograms slide in from the right. Your camera feed (if enabled) appears in a picture-in-picture or split-screen overlay.
*   **Stage View (VR):** You stand on stage next to the coach. Pictograms appear as floating holograms.