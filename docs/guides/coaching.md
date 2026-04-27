# Creating Coaching Content

Coaches are the heart of the AeroBeat experience. While the music provides the rhythm, **you** provide the motivation.

Our coaching system is designed to feel like a real trainer working out beside the athlete. You are not just a voice in their ear. You are part of the session.

> **Current contract note:** This guide reflects the approved v1 package model. Coaching is optional, but when a package uses coaching it does so through the package's single `coaches/coach-config.yaml` file.

## 🎯 The Philosophy: "Sweat With Them"

The best coaching content feels authentic because the coach is physically engaged during the recording.

- **Do not just read a script.** Get your heart rate up. Let the athlete hear the effort.
- **Tell a Story.** If you include warmup or cooldown video, use them to set the workout tone and close it out well.
- **Match the song energy.** High-intensity tracks need sharper encouragement. Flow tracks need calmer guidance.

## 📦 The Approved v1 Coaching Contract

Every workout package owns exactly one `coaches/coach-config.yaml` file.

Coaching is **optional all-or-nothing**:

- If coaching is **disabled**, the file should be the minimal sentinel payload:

```yaml
enabled: false
```

- If coaching is **enabled**, the file returns to the normal authored-record rule and must include its schema/provenance fields plus all required coaching sections:
  - `schemaId`, `schemaVersion`, `recordVersion`
  - `createdByTool`, `createdByToolVersion`, `createdAt`, `updatedAt`
  - `enabled: true`
  - a coach roster with one or more `coachId` + `coachName` entries
  - one required warmup video reference
  - one required cooldown video reference
  - an overlay audio registry whose records use `overlayId`; workout sets choose entries from that registry through `coachingOverlayId`

### Enabled example

```yaml
schemaId: aerobeat.coach-config.v1
schemaVersion: 1
recordVersion: 1
createdByTool: aerobeat-tool-content-authoring
createdByToolVersion: 0.1.0
createdAt: 2026-04-25T22:00:00Z
updatedAt: 2026-04-27T13:00:00Z
enabled: true
coachConfigId: ab-coach-config-neon-bootcamp
coachConfigName: Neon Bootcamp Coach Config
featuredCoaches:
  - coachId: ab-coach-aria
    coachName: Coach Aria
  - coachId: ab-coach-blaze
    coachName: Coach Blaze
warmupVideo:
  mediaId: ab-warmup-breathing-intro
  path: media/coaching/warmup-breathing-intro.mp4
cooldownVideo:
  mediaId: ab-cooldown-stretch-outro
  path: media/coaching/cooldown-stretch-outro.mp4
overlayAudio:
  - overlayId: ab-overlay-aria-neon-stride-cue
    coachId: ab-coach-aria
    mediaId: ab-overlay-aria-neon-stride-cue-media
    path: media/coaching/aria-neon-stride-overlay.ogg
  - overlayId: ab-overlay-blaze-midnight-sprint-cue
    coachId: ab-coach-blaze
    mediaId: ab-overlay-blaze-midnight-sprint-cue-media
    path: media/coaching/blaze-midnight-sprint-overlay.ogg
```

## ✅ Validation Rules in Plain Language

When coaching is enabled, validation should fail if **any** of the following are true:

- the roster is missing
- the warmup video reference is missing
- the cooldown video reference is missing
- any workout set is missing its one referenced overlay audio clip
- any referenced file path does not exist on disk inside the package

When coaching is disabled, validation should fail if authors try to leave behind dormant roster/media sections. Disabled means disabled.

## 🛠️ Technical Requirements

- **Warmup / cooldown video:** package-local video files such as `.mp4` or `.webm`
- **Overlay coaching clips:** package-local audio files such as `.ogg`
- **Tools:**
  - **Recording:** OBS Studio (video), Audacity / Reaper (audio)
  - **Authoring:** a future AeroBeat package authoring workflow built on the shared package contracts

## 🚀 Step-by-Step Workflow

### Phase 1: Preparation

1. **Select Base Content:** Start from the workout package you are coaching.
2. **Learn the Set Flow:** Know each workout set and where the athlete will need support.
3. **Plan the Coaching Pass:** Write the warmup, the cooldown, and exactly one overlay audio cue that each workout set will reference by `coachingOverlayId`.

### Phase 2: Recording

#### Warmup / Cooldown Video

- **Lighting:** Ensure you are well lit.
- **Background:** Keep it clean or use a green screen.
- **Action:** Record the package warmup and cooldown videos.
- **Export:** Render as package-local video files.

#### Set Overlay Audio

- **Setup:** Put on your headset, start recording in your DAW, and play the song in your headphones.
- **Action:** Perform the workout while recording. Speak to the athlete as if they are next to you.
- **Export:** Save the vocal track only. Do not include the music.
- **Scope rule:** Record one final overlay clip per workout set. Do not author multiple competing overlay clips for the same set under the current v1 contract.

### Phase 3: Package Authoring

1. **Open the workout package authoring flow.**
2. **Import Files:** Add the warmup video, cooldown video, and overlay audio files to package-local `media/` folders.
3. **Update `coaches/coach-config.yaml`:**
   - set `enabled: true`
   - define the coach roster
   - wire the warmup video reference
   - wire the cooldown video reference
   - add the overlay audio registry records
4. **Validate:** Run package validation so every `coachingOverlayId` resolves and every referenced file exists.

## 💡 Best Practices

- **Feel the Vibe:** You do not need to talk constantly. Speak when motivation or guidance matters.
- **Keep it specific:** Because each set picks one `coachingOverlayId`, you can tailor each cue to the exact workout slice the athlete is playing.
- **Keep packages self-contained:** Do not rely on cross-package inheritance, hidden defaults, or external coaching bundles.
- **Be explicit:** If a package is not coached, ship the minimal disabled file. If it is coached, fully wire every required section.

## ♿ Coaching Modifications

Not every athlete can perform high-impact moves. Acknowledge that and offer alternatives.

- **Knee Strikes:** If impact is not safe, suggest a guard/block or crunch alternative.
- **Obstacles (Walls / Bars):** Remind athletes that head movement matters more than exaggerated body motion.
- **Flow - Leg Lifts & Run In Place:** Remind athletes that modification is better than risking injury.

## ❓ Coaching FAQ

**Q: Can I use green-screen video?**
**A:** Yes. That is a great fit for warmup and cooldown media.

**Q: Can I remix an existing workout?**
**A:** Yes. Duplicate or fork the workout package, then author that package's single `coaches/coach-config.yaml` file for the new revision.
