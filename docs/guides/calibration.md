# Calibration Wizard

AeroBeat is an **Input Agnostic** platform. Because every device (Webcam, Bluetooth Headphones, TV) introduces different latency, calibration is critical for a good experience.

## 1. Global Latency (Audio & Video)

Before playing, every user should run the **AV Sync Wizard**. This compensates for hardware delays.

### Audio Offset (The "Hit Window")

*   **Problem:** Bluetooth headphones can add 200ms+ of delay. You hear the beat late.
*   **The Test:** You will hear a rhythmic click. Tap/Click exactly when you *hear* the sound.
*   **Result:** We calculate `user_audio_offset_ms`. The game subtracts this from your input timestamp.

### Video Offset (The "Travel Time")

*   **Problem:** TVs with post-processing can delay the image by 50ms+.
*   **The Test:** A visual indicator bounces to a beat. Adjust the slider until the bounce hits the line exactly when the sound plays.
*   **Result:** We calculate `user_video_offset_ms`. We spawn targets earlier so they arrive visually on time.

---

## 2. Input-Specific Calibration

Once AV sync is set, you may need to calibrate your specific controller.

### 📷 Camera (MediaPipe)

*   **Lighting:** Ensure your face and hands are well-lit. Avoid backlighting (windows behind you).
*   **T-Pose:** Stand back until your full upper body is visible. Press "Calibrate" while holding a T-Pose to set your arm span.
*   **Background:** A plain background works best. Remove moving objects (fans, pets).

### 🎮 Joycon & VR

*   **Gyro Drift:** IMU sensors drift over time.
*   **Reset:** Hold the controllers forward and press the **System Button** (Start/Home) to reset "Forward" direction.

### 🕹️ Gamepad

*   **Deadzones:** If your cursor drifts, increase the "Stick Deadzone" in Settings.
*   **Mapping:** Use the "Remap Controls" menu if your generic controller has swapped buttons (A/B or X/Y).

### ⌨️ Keyboard & Mouse

*   **Sensitivity:** For Mouse input, adjust the X/Y sensitivity to match your screen size and arm movement preference.
*   **Keybinds:** WASD / Arrow Keys are default, but fully remappable.

### 📱 Touch

*   **Surface Area:** On tablets, you may want to restrict the active input area to the bottom half of the screen for comfort.

---

## 3. Troubleshooting

*   **"I hit perfectly but get 'Miss'":** Your Audio Offset is likely wrong. Re-run the Audio Calibration.
*   **"Targets stutter":** Check your frame rate. Rhythm games need stable 60fps. Lower graphics settings if needed.
*   **"Camera loses my hands":** Move further back. Fast movements blur on cheap webcams; try smoother motions.