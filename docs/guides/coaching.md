# Creating Coaching Content

Coaches are the heart of the AeroBeat experience. While the music provides the rhythm, **You** provide the motivation.

Our coaching system is designed to replicate the feeling of a personal trainer working out right beside the athlete. You aren't just a voice in their ear; you are their partner in the sweat session.

## 🎯 The Philosophy: "Sweat With Them"

The most successful coaching content (inspired by platforms like Supernatural VR) feels authentic because the coach is physically active during the recording.

*   **Don't just read a script.** Get your heart rate up. Let the athlete hear the effort in your voice.
*   **Tell a Story.** A playlist isn't just random songs. It's a journey. Use the warm-up to set the theme ("Today is about resilience") and the cool-down to reflect.
*   **Vibe Check.** Match your energy to the song. If it's a high-intensity interval track, use your voice to acknowledge the craziness the athlete is working through in their journey. If it's a flow track, be calm and grounding.

## 📦 Anatomy of a Coaching Pack

A Coaching Pack is a collection of media files designed to wrap around a specific **Playlist**.

1.  **Warm-Up Video:** Plays before the first song. (1-2 minutes).
2.  **Audio Overlays:** Voice tracks that play *on top* of specific songs in the playlist.
3.  **Cool-Down Video:** Plays after the last song. (2-3 minutes).

## 🛠️ Technical Requirements

*   **Video Format:** `.webm` (VP8 or VP9 codec). Max resolution 1080p.
*   **Audio Format:** `.ogg` (Vorbis).
*   **Tools:**
    *   **Recording:** OBS Studio (Video), Audacity/Reaper (Audio).
    *   **SDK:** `aerobeat-sdk-coaching` (Godot Project).

## 🚀 Step-by-Step Workflow

### Phase 1: Preparation

1.  **Select Base Content:** Use the SDK's **Content Browser** to find an existing Playlist or Song on the AeroBeat server. You don't need to have the files locally; the SDK will stream the metadata and audio for you to coach against.
2.  **Learn the Charts:** Play the playlist yourself. Note where the hard drops are, where the breaks are, and where the athlete will be struggling.
3.  **Write your Script (Loose):** Plan your "Intro" story and your "Outro" message. For the songs, note down cues ("Big uppercuts coming up!", "Breathe through the squat").

### Phase 2: Recording

#### The Videos (Warm-Up / Cool-Down)

*   **Lighting:** Ensure you are well-lit.
*   **Background:** Keep it clean or use a green screen.
*   **Action:** Lead the athlete through dynamic stretching (Warm-up) or static stretching (Cool-down).
*   **Export:** Render as `.webm`.

#### The Audio Overlays

*   **Setup:** Put on your headset, start recording in your DAW, and **play the song** in your headphones.
*   **Action:** Perform the workout while recording. Speak to the athlete as if they are next to you.
*   **Export:** Save the vocal track *only* (do not include the music) as `.ogg`. Ensure the start time aligns with the song start (or note the offset).

### Phase 3: The SDK

1.  **Download & Open:** Launch the `aerobeat-sdk-coaching` project in Godot.
2.  **Import Files:** Drag your `.webm` and `.ogg` files into the project.
3.  **Create the Pack:**
    *   Create a new Resource: `AeroCoachingPack`.
    *   Assign your `warm_up_video` and `cool_down_video`.
    *   **Map the Songs:** In the `overlays` array, add entries for each song in the playlist.
        *   `Song ID`: The ID of the song you are coaching over.
        *   `Audio Clip`: Your `.ogg` voice track.
        *   `Volume`: Adjust to ensure you don't drown out the music (default `1.0`).
4.  **Create Manifest:**
    *   Create `AeroModManifest`.
    *   Type: `COACHING`.
    *   Target Feature: (e.g., `boxing`).
5.  **Validate & Upload:** Use the "AeroBeat Uploader" tab to publish.

## 💡 Best Practices

*   **Feel The Vibe:** You don't need to talk non-stop. Let the music drive the energy. Speak when motivation or instruction is needed.
*   **Generic vs. Specific:** Since you are coaching a specific *Playlist*, you can reference the specific songs ("I love this guitar solo!"). This creates a much deeper immersion than generic "Good job" lines.
*   **Audio Ducking:** The game engine automatically "ducks" (lowers) the music volume slightly when your voice track is speaking. You don't need to mix this yourself.

## ❓ Coaching FAQ

**Q: Can I use Green Screen (Chroma Key) video?**
**A:** **Yes!** This is highly recommended for immersion.
1.  Record your video against a green background.
2.  In the Coaching SDK, select your video resource.
3.  Enable **"Transparent Background"** in the inspector. The engine uses a real-time shader to remove the green, making you appear inside the game environment!

**Q: Can I remix an existing playlist?**
**A:** Yes. You can load an existing playlist in the SDK, add your coaching tracks, and save it as a **Remix**. The original author is automatically credited in the manifest.