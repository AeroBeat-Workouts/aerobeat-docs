# Choreography Overview

In AeroBeat, "Choreography" (or Charting) is the art of translating music into movement. A good chart doesn't just match the beat; it makes the athlete feel like they are dancing (or fighting) to the music.

## 🛠️ The Choreography SDKs

Because a Boxing workout is biomechanically different from a Step workout, we provide specialized SDKs for each gameplay style.

*   **[Boxing Guide](boxing.md):** Optimized for arm reach, punches, and 360-degree spatial mapping.
*   **[Flow Guide](flow.md):** Optimized for continuous arm arcs and bat swing mechanics.
*   **[Step Guide](step.md):** Optimized for foot placement and balance (4-lane grid).
*   **[Dance Guide](dance.md):** Timeline-based gesture matching.

### ⚠️ Web vs. Desktop: Audio Latency

While the Web Studio is convenient for quick edits, **Web Browsers introduce variable audio latency** that makes precise rhythm mapping difficult.

*   **Risk:** Charts mapped entirely in the web browser may feel "off-beat" when played in the game engine due to the browser's audio buffer drift.
*   **Recommendation:** Use the **Desktop App** version of the Choreography Studio for final synchronization and timing checks. The Desktop App uses the same low-latency audio driver as the game client.

## 👁️ Designing for Multiple Views

Your chart will be played on VR headsets (Portal View) and Mobile Phones (Track View).

*   **Portal View:** Targets fly at the player from 3D space.
    *   **Automatic Portals:** Creators do not manually place portals, only targets and obstacles. The engine automatically opens and closes portals based on your placement.
    *   **Visual Cues:** When a new portal opens, a subtle particle trail guides the athlete's eye. In VR, this signifies they should rotate to face the new portal to expect incoming targets.
*   **Track View:** Targets move from one side of the screen to the other in lanes.

> **Note:** The engine handles **Auto-Optimizations** for you. If you map a 360-degree VR chart, the engine will automatically "fold" the rear targets to the front for mobile players. You do not need to make two separate charts!

## 🚀 Step-by-Step Workflow

### Phase 1: Song Selection

You cannot map silence. You need a base audio track.

1.  **Open the Studio:** Launch the **Choreography Studio** app (Web or Desktop).
2.  **Content Browser:** Open the "Server Assets" tab.
3.  **Select a Song:**
    *   **Remix:** Pick an existing song uploaded by a musician.
    *   **Upload:** If you are the musician, upload your `.ogg` file first as a `SONG` mod before using it here.

### Phase 2: Setup & Analysis

Before placing a single note, you must sync the grid.

1.  **Create Resource:** Create a new `AeroChoreography` resource.
2.  **Assign Song:** Link it to the Song ID you selected.
3.  **BPM & Offset:**
    *   **Auto-Detect:** The SDK automatically scans the audio file to calculate BPM and Offset when assigned.
    *   **Manual Override:** If the detection is slightly off, you can type in the correct value or use the **"Tap Tempo"** button.
    *   *Tip:* The metronome click should align perfectly with the song's kick drum.

### Phase 3: Mapping

Open the **Editor View**. You will see a timeline and a 3D representation of the "Hit Zone."

#### Accelerators (Work Smarter)

*   **Automapper:** Don't start from zero. Use the "Generate from Audio" button to create a rhythmic skeleton based on the song's BPM and intensity. It won't be perfect, but it saves hours of setup.
*   **Pattern Prefabs:** Use our predefined Pattern Libraries included with each SDK. Drag and drop common flows like "Left-Right-Duck" or "3-Hit Combo" directly onto the timeline.

#### The Editor Interface

While the specific objects (Targets vs Arrows) differ by SDK, the core interface remains consistent:
1.  **Timeline:** The vertical scrolling grid representing time.
2.  **Object Library:** The palette of available moves/notes.
3.  **Properties Panel:** Fine-tune rotation, lane position, and width.

### Phase 4: Validation & Publish

The SDK includes a **"Flow Validator"**. Run this before uploading.

1.  **Check Parity:** Ensure no hand tangles or vision blocks.
2.  **Create Manifest:**
    *   Type: `GAMEPLAY_TWEAK` (Select "Chart" subtype in inspector).
    *   Target Feature: (e.g., `boxing`).
3.  **Upload:** Use the Uploader tab to publish your chart to the server.