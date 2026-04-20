# Creating Coaching Content

Coaches are the heart of the AeroBeat experience. While the music provides the rhythm, **you** provide the motivation.

Our coaching system is designed to replicate the feeling of a personal trainer working out right beside the athlete. You are not just a voice in their ear; you are their partner in the session.

## 🎯 The Philosophy: "Sweat With Them"

The most successful coaching content (inspired by platforms like Supernatural VR) feels authentic because the coach is physically active during the recording.

* **Do not just read a script.** Get your heart rate up. Let the athlete hear the effort in your voice.
* **Tell a Story.** A Workout is not just random songs. It is a journey. Use the warm-up to set the theme ("Today is about resilience") and the cool-down to reflect.
* **Vibe Check.** Match your energy to the song. If it is a high-intensity interval track, use your voice to acknowledge what the athlete is working through. If it is a flow track, be calm and grounding.

> **Terminology note:** The player-facing UI may still call a Workout a playlist. In the content model, **Workout** is the canonical term.

## 📦 Anatomy of a Coaching Pack

A Coaching Pack is a collection of media files designed to wrap around a specific **Workout**.

1. **Warm-Up Video:** Plays before the first song. (1-2 minutes)
2. **Audio Overlays:** Voice tracks that play *on top of* specific songs in the Workout.
3. **Cool-Down Video:** Plays after the last song. (2-3 minutes)

## 🛠️ Technical Requirements

* **Video Format:** `.webm` (VP8 or VP9 codec). Max resolution 1080p.
* **Audio Format:** `.ogg` (Vorbis).
* **Tools:**
  * **Recording:** OBS Studio (video), Audacity / Reaper (audio).
  * **Tool:** **Coaching Studio** (web app).

## 🚀 Step-by-Step Workflow

### Phase 1: Preparation

1. **Select Base Content:** Use the SDK's content browser to find an existing Workout or Song on the AeroBeat server. You do not need to have the files locally; the SDK streams the metadata and audio for you to coach against.
2. **Learn the Charts:** Play the Workout yourself. Note where the hard drops are, where the breaks are, and where the athlete will be struggling.
3. **Write Your Script (Loose):** Plan your intro story and your outro message. For the songs, note down cues such as "Big uppercuts coming up!" or "Breathe through the squat."

### Phase 2: Recording

#### The Videos (Warm-Up / Cool-Down)

* **Lighting:** Ensure you are well lit.
* **Background:** Keep it clean or use a green screen.
* **Action:** Lead the athlete through dynamic stretching (warm-up) or static stretching (cool-down).
* **Export:** Render as `.webm`.

#### The Audio Overlays

* **Setup:** Put on your headset, start recording in your DAW, and **play the song** in your headphones.
* **Action:** Perform the workout while recording. Speak to the athlete as if they are next to you.
* **Export:** Save the vocal track *only* (do not include the music) as `.ogg`. Ensure the start time aligns with the song start, or note the offset.

### Phase 3: The Coaching Studio

1. **Open:** Navigate to the **Coaching Studio** web portal.
2. **Import Files:** Drag your `.webm` and `.ogg` files into the project.
3. **Create the Pack:**
   * Create a new resource: `AeroCoachingPack`.
   * Assign your `warm_up_video` and `cool_down_video`.
   * **Map the Songs:** In the `overlays` array, add entries for each song in the Workout.
     * `Song ID`: The ID of the song you are coaching over.
     * `Audio Clip`: Your `.ogg` voice track.
     * `Volume`: Adjust to ensure you do not drown out the music (default `1.0`).
4. **Create Manifest:**
   * Create `AeroModManifest`.
   * Type: `COACHING`.
   * Target Feature: (for example, `boxing`).
5. **Validate & Upload:** Use the AeroBeat uploader tab to publish.

## 💡 Best Practices

* **Feel the Vibe:** You do not need to talk non-stop. Let the music drive the energy. Speak when motivation or instruction is needed.
* **Generic vs. Specific:** Since you are coaching a specific **Workout**, you can reference the specific songs ("I love this guitar solo!"). This creates much deeper immersion than generic "Good job" lines.
* **Audio Ducking:** The game engine automatically ducks the music volume slightly when your voice track is speaking. You do not need to mix this yourself.

## ♿ Coaching Modifications

Not every athlete can perform high-impact moves. It is important to acknowledge this and offer alternatives.

* **Knee Strikes:** These are heavy movements. Emphasize them, but remind athletes that if they cannot perform the impact, they can swap the action for a **Guard / Block** or **Crunch**.
  * *Why this works:* In Boxing mode, the game tracks the **Head Position** relative to the target lane rather than the physical leg. As long as the athlete shifts their weight (head) to the correct position where they *would* be if they lifted their knee, the hit will register.
* **Obstacles (Walls / Bars):** Remind athletes that the game only tracks their **Head** for collisions. They do not need to contort their entire body to avoid a wall, just their head. This prevents over-extension and injury.
* **Flow - Leg Lifts & Run In Place:** These are high-intensity fitness intervals. Remind athletes that the specific leg movement is not scored. If they cannot perform the action safely, they should modify it (for example, a small lift or a stretch) rather than risking injury. Safety is the priority.

## ❓ Coaching FAQ

**Q: Can I use Green Screen (Chroma Key) video?**
**A:** **Yes.** This is highly recommended for immersion.
1. Record your video against a green background.
2. In the Coaching SDK, select your video resource.
3. Enable **Transparent Background** in the inspector. The engine uses a real-time shader to remove the green, making you appear inside the game environment.

**Q: Can I remix an existing playlist?**
**A:** Yes. You can load an existing Workout in the SDK, add your coaching tracks, and save it as a remix. The original author is automatically credited in the manifest.
