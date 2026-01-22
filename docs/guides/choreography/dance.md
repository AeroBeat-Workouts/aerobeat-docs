# Creating Dance Choreography

Dance mode is unique in AeroBeat. Instead of placing abstract targets, you are creating a **Performance**. The athlete's goal is to mimic your movements as if looking in a mirror.

The `aerobeat-sdk-choreography-dance` allows you to be the choreographer, the motion capture actor, and the level designer all at once.

## 🛠️ The Dance Studio

*   **Tool:** **Dance Choreography Studio**
*   **Input:** Requires a Webcam (MediaPipe) or VR Headset for recording.
*   **Output:** A timeline of `AeroDanceMove` resources and a Coach Animation track.

## 💃 The "Mirror" Concept

When mapping for Dance, remember: **The Player is your Mirror.**

*   If you (the Coach) step to the **Left**, the Player steps to their **Left** (which looks like your Right on screen).
*   The SDK handles this mirroring automatically during the "Bake" process, but keep it in mind when designing flow.

## 🚀 Workflow

### Phase 1: Setup

1.  **Load Song:** Import your audio track via the Content Browser.
2.  **Sync BPM:** Use Auto-Detect to set the grid.
3.  **Select Avatar:** Choose a default Coach Avatar to visualize your moves.

### Phase 2: Motion Capture (Record Yourself)

You don't need to manually animate 3D bones. You just need to dance.

1.  **Setup Input:** In the SDK, select **"Input Source"** -> **"Camera (MediaPipe)"**.
2.  **Calibrate:** Stand back and ensure your full body is visible.
3.  **Arm Record:** Press the red circle on the timeline. The music will start.
4.  **Perform:** Dance to the music! The SDK records your skeletal data in real-time.
    *   *Tip:* You don't have to do the whole song in one take. You can record section by section (Verse 1, Chorus, Bridge).

### Phase 3: The Timeline Editor

Once you have raw motion data, you need to turn it into gameplay.

1.  **Simplify (Quantize):** The raw data is messy. Use the **"Simplify"** tool to snap key poses to the nearest beat (1/4 or 1/8).
2.  **Define Moves:**
    *   Highlight a section of the timeline (e.g., a "Clap").
    *   Right-Click -> **"Create Move"**.
    *   This generates a scoring window where the game checks the player's pose against yours.
3.  **Assign Pictograms:**
    *   Select the Move.
    *   Choose an icon from the library (e.g., "Spin Left", "Wave", "V-Step").
    *   *Note:* Pictograms appear 2 beats before the move by default.

### Phase 4: Polish

*   **Gold Moves:** Mark high-energy moments (like a final pose or a jump) as **"Gold"**. These trigger special effects and bonus points.
*   **Parity Check:** Run the validator to ensure you haven't created impossible transitions (e.g., spinning 360 degrees in 0.5 seconds).

## 💡 Best Practices

*   **Repetition is Good:** Dance is built on patterns. Create a "Chorus" block and copy-paste it every time the chorus plays. This helps players learn the routine.
*   **Telegraphing:** Don't surprise the player. If a move requires a complex foot placement, give them a simple "Step Touch" before it to get ready.
*   **Energy Curve:**
    *   **Verse:** Low intensity, simple arm movements.
    *   **Chorus:** High energy, full body jumps and spins.
    *   **Bridge:** Cool down, focus on style.

## 🎥 Green Screen Coaching (Optional)

If you prefer to be the coach yourself (video) instead of using a 3D Avatar:

1.  Record yourself dancing against a Green Screen.
2.  Import the `.webm` video as a **Coaching Overlay**.
3.  Use the SDK to manually place "Move" markers on the timeline that match your video performance.