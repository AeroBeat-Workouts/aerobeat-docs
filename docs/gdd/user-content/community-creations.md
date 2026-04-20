# 🌐 Community Creations

When athletes browse community content, the player-facing UI may describe a session as a **playlist**. In the underlying content model, the canonical term is **Workout**.

A Workout assembles community-authored content into a coherent training session. It is specific to a gameplay style and difficulty intent, even though the athlete may simply experience it as a playlist in the browser UI.

The durable content hierarchy is:

* **Song** → reusable audio and timing source
* **Routine** → gameplay-mode-specific package for one Song
* **Chart Variant** → one concrete playable difficulty / compatibility slice inside a Routine
* **Workout** → ordered training session that assembles routines or chart variants

## Community Content Types

* **Songs:** Musicians can add songs to the platform for others to use.
* **Routines / Chart Variants:** Choreographers author gameplay for songs using the charting tools. A routine packages one gameplay mode for one song, and chart variants represent specific difficulties or compatibility slices inside that routine.
* **Environments:** Environments change the background visuals and looping sound effects during a song or workout segment.
* **Skins:** Artists can create custom visuals for `targets`, `obstacles`, `portals`, and `gloves / bats`.
* **Coaching:** Trainers can upload motivational content to guide athletes through a workout.
  * **Warm Up:** A video playing before the first song.
  * **Audio Overlays:** Voice-over tracks that play on top of specific songs.
  * **Cool Down:** A video playing after the last song.

## Building a Workout

When creating a Workout, a creator uses the community browser and tooling to pick the following:

* **Gameplay:** What gameplay style is this Workout made for? (`Boxing`, `Flow`, etc.)
* **Difficulty Intent:** Which chart-variant difficulty is this Workout targeting (`easy`, `medium`, `hard`, `pro`)?
* **Songs / Selections:** Which songs, routines, or exact chart variants are included?
* **Chart Choice:** By default the Workout can reference the preferred chart variant for the requested gameplay and difficulty, but the creator may override this and pin a different variant explicitly.
* **Environments:** Optional. Change the recommended environment for each song or segment in the Workout.
* **Skins:** Optional. Change the recommended visuals such as `targets`, `obstacles`, `portals`, and `gloves`.
* **Coaching:** Optional. Select a **Coaching Pack** to apply warm-up / cool-down videos and per-song audio overlays.

When choosing any Workout, athletes can override the suggestions using their **Profile Preferences**.

* **Avatars:** Your avatar is your identity. It is set in your profile and persists across all workouts.
* **Environment:** Workouts often suggest immersive environments. You can override this to always use your preferred environment (for example, a simple dark void) if the suggested one is distracting.
* **Skins:** Workouts may suggest themed gloves or targets. You can override this to stick with your preferred skins (for example, high-contrast targets) for visibility or comfort.
* **Coaching:** Disable all coaching material from playing.
