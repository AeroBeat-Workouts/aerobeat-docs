# Choreography Overview

In AeroBeat, charting is the art of translating music into movement. A good chart does not just match the beat; it makes the athlete feel like they are dancing, boxing, stepping, or flowing with the song.

AeroBeat's content model is:

* **Song → Chart → Set → Workout**

When you author gameplay, you are usually creating or editing one or more reusable **Charts** for a Song, then wiring those charts into package-local **Sets** that a **Workout** can order.

## 🛠️ The Choreography SDKs

Because a Boxing workout is biomechanically different from a Step workout, AeroBeat provides specialized SDKs for each gameplay style.

* **[Boxing Guide](boxing.md):** Optimized for arm reach, punches, and 360-degree spatial mapping.
* **[Flow Guide](flow.md):** Optimized for continuous arm arcs and bat swing mechanics.
* **[Step Guide](step.md):** Optimized for foot placement and balance (4-lane grid).
* **[Dance Guide](dance.md):** Timeline-based gesture matching.

### ⚠️ Web vs. Desktop: Audio Latency

While the web studio is convenient for quick edits, **web browsers introduce variable audio latency** that makes precise rhythm mapping difficult.

* **Risk:** Charts mapped entirely in the web browser may feel off-beat when played in the game engine because of browser audio-buffer drift.
* **Recommendation:** Use the **desktop app** version of the choreography studio for final synchronization and timing checks. The desktop app uses the same low-latency audio driver as the game client.

## 👁️ Designing for Multiple Views

Your chart may be played on VR headsets (Portal View) and phones, tablets, or laptops (Track View).

* **Portal View:** Targets fly at the athlete through 3D space.
    *   **Automatic Portals:** Creators do not manually place portals, only targets and obstacles. The engine automatically opens and closes portals based on authored placement.
    *   **Visual Cues:** When a new portal opens, a subtle particle trail guides the athlete's eye. In VR, this signals that they should rotate to face the new portal.
* **Track View:** Targets render in a linear 2D presentation.
    *   Depending on the gameplay mode, this may appear as upward-scrolling lanes, horizontally arranged tracks, or another compact lane-based rendering.

> **Note:** The engine handles auto-optimizations for you. If you author a 360-degree Portal View chart, the runtime automatically folds rear targets to the front for Track View devices. You do not need to make separate portal and track charts by default.

## 🚀 Step-by-Step Workflow

### Phase 1: Song Selection

You cannot map silence. You need a base audio track.

1. **Open the Studio:** Launch the **Choreography Studio** app (web or desktop).
2. **Content Browser:** Open the server-assets tab.
3. **Select a Song:**
   * **Remix:** Pick an existing song uploaded by a musician.
   * **Upload:** If you are the musician, upload your `.ogg` file first as a `SONG` mod before using it here.

### Phase 2: Setup & Analysis

Before placing a single note, you must sync the grid and establish the chart / set structure.

1. **Create or open a Chart:** Choose the gameplay mode and work inside one concrete playable difficulty / compatibility slice.
2. **Create or open a Set:** Wire the selected Song and Chart together for one package-local workout slice.
3. **Link the Song and Chart:** Ensure the set points at the selected Song ID and Chart ID.
4. **BPM & Offset:**
   * **Auto-detect:** The SDK automatically scans the audio file to calculate BPM and offset when assigned.
   * **Manual Override:** If detection is slightly off, type in the correct value or use the **Tap Tempo** button.
   * *Tip:* The metronome click should align perfectly with the song's kick drum.

### Phase 3: Mapping

Open the **Editor View**. You will see a timeline and a gameplay-specific representation of the hit space.

#### Accelerators (Work Smarter)

* **Automapper:** Do not start from zero. Use the Generate from Audio button to create a rhythmic skeleton based on the song's BPM and intensity. It will not be perfect, but it saves hours of setup.
* **Pattern Prefabs:** Use the predefined pattern libraries included with each SDK. Drag and drop common flows like Left-Right-Duck or 3-Hit Combo directly onto the timeline.

#### The Editor Interface

While the specific objects (targets vs arrows) differ by SDK, the core interface remains consistent:
1. **Timeline:** The vertical scrolling grid representing time.
2. **Object Library:** The palette of available moves / notes.
3. **Properties Panel:** Fine-tune rotation, lane position, width, and presentation hints.

### Phase 4: Validation & Publish

The SDK includes a **Flow Validator**. Run this before uploading.

1. **Check Parity:** Ensure no hand tangles or vision blocks.
2. **Prepare the Publishable Content:**
   * Finalize the set metadata and composition links.
   * Finalize the chart metadata for difficulty, interaction family, and any supported / validated input profiles.
3. **Upload:** Use the uploader tab to publish your authored gameplay content.
