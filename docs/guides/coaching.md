# Creating Coaching Content

Coaches are the heart of the AeroBeat experience. While the music provides the rhythm, **you** provide the motivation.

Our coaching system is designed to replicate the feeling of a personal trainer working out right beside the athlete. You are not just a voice in their ear; you are their partner in the session.

> **Current contract note:** This guide reflects the locked v1 package model. Coaching is not a separate “Coaching Pack” product. Coaching data lives inside the workout package’s single `coaches/coach-config.yaml` domain, and any coach-specific media/assets stay package-local.

## 🎯 The Philosophy: "Sweat With Them"

The most successful coaching content (inspired by platforms like Supernatural VR) feels authentic because the coach is physically active during the recording.

* **Do not just read a script.** Get your heart rate up. Let the athlete hear the effort in your voice.
* **Tell a Story.** A Workout is not just random songs. It is a journey. If you use intro or cooldown media, use it to set the theme and reflect on the session.
* **Vibe Check.** Match your energy to the song. If it is a high-intensity interval track, use your voice to acknowledge what the athlete is working through. If it is a flow track, be calm and grounding.

## 📦 Anatomy of the Workout Coaching Domain

A workout package owns exactly one `coaches/coach-config.yaml` file.

That single file may describe:

1. **Featured Coaches:** one or more package-local coaches, typically referencing `coach_avatar` and `coach_voice` assets.
2. **Coach Media:** intro, overlay, or other referenced media files that live inside the same package.
3. **Overlay Triggers:** workout/chart moment mappings that tell runtime which coaching clip or cue belongs where.

If the workout also includes warm-up or cooldown media, treat those as workout-package media references rather than a separate coaching-pack artifact.

## 🛠️ Technical Requirements

* **Video Format:** `.webm` (VP8 or VP9 codec). Max resolution 1080p.
* **Audio Format:** `.ogg` (Vorbis).
* **Tools:**
  * **Recording:** OBS Studio (video), Audacity / Reaper (audio).
  * **Tool:** a future AeroBeat coaching/content authoring workflow built on the shared package contracts.

## 🚀 Step-by-Step Workflow

### Phase 1: Preparation

1. **Select Base Content:** Start from the workout package you are coaching. Know the exact workout, charts, and session flow you are targeting.
2. **Learn the Charts:** Play the Workout yourself. Note where the hard drops are, where the breaks are, and where the athlete will be struggling.
3. **Write Your Script (Loose):** Plan your coach intro, any optional workout-level intro/outro media, and the key chart moments where coaching overlays should trigger.

### Phase 2: Recording

#### Coach Intro / Workout-Level Media

* **Lighting:** Ensure you are well lit.
* **Background:** Keep it clean or use a green screen.
* **Action:** Record any optional workout-level intro/outro or explanatory media you want the package to reference.
* **Export:** Render as `.webm`.

#### Voice / Overlay Clips

* **Setup:** Put on your headset, start recording in your DAW, and **play the song** in your headphones.
* **Action:** Perform the workout while recording. Speak to the athlete as if they are next to you.
* **Export:** Save the vocal track *only* (do not include the music) as `.ogg`. Ensure the start time aligns with the intended trigger moment, or record the offset you will wire into coaching metadata.

### Phase 3: Package Authoring

1. **Open the workout package authoring flow.**
2. **Import Files:** Add your `.webm`, `.ogg`, avatar assets, and voice assets to the package-local media/assets folders.
3. **Update `coaches/coach-config.yaml`:**
   * Define your featured coach entries.
   * Reference any `coach_avatar` / `coach_voice` assets.
   * Add overlay mappings keyed to the relevant chart/event moments.
4. **Update the workout package:** If you are using optional workout-level intro/outro media, wire those references through the workout package contract instead of inventing a parallel pack type.
5. **Validate:** Run package validation so ids, references, asset types, and media paths resolve cleanly.

## 💡 Best Practices

* **Feel the Vibe:** You do not need to talk non-stop. Let the music drive the energy. Speak when motivation or instruction is needed.
* **Specific beats beat generic hype:** Because the coaching config is attached to one workout package, you can tailor cues to exact chart moments and session flow.
* **Keep packages self-contained:** Do not rely on cross-package inheritance, patching, or external coaching bundles.
* **Coach assets are typed:** Use `coach_avatar` and `coach_voice` for coach-facing asset records. Do not place those asset types in workout-entry gameplay asset selections.

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
2. Keep the keyed result as package-local media referenced by the coaching config or workout package.

**Q: Can I remix an existing Workout?**
**A:** Yes. Duplicate or fork the workout package, then add your coaching configuration and media in the new package revision. Do not rely on inheritance or patch layering across packages.
