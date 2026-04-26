# 🌐 Community Creations

A Workout assembles community-authored content into a coherent training session. It is specific to a gameplay style and a creator-chosen difficulty intent, but the durable authored package stays explicit about the exact content ids it references.

The durable content hierarchy is:

* **Song** → reusable audio and timing source
* **Routine** → gameplay-mode-specific package for one Song
* **Chart** → one concrete playable difficulty / compatibility slice inside a Routine
* **Workout** → ordered training session that assembles exact chart selections plus workout-level coaching/session flow

## Community Content Types

* **Songs:** Musicians can add songs to the platform for others to use.
* **Routines / Charts:** Choreographers author gameplay for songs using the charting tools. A routine packages one gameplay mode for one song, and charts represent specific difficulties or compatibility slices inside that routine.
* **Environments:** Environment authors create package-local worlds that a workout entry can select one at a time.
* **Assets:** Artists can create typed package-local assets for `gloves`, `targets`, `obstacles`, and `trails`.
* **Coaching:** Trainers can create optional workout-level coaching content inside the package's single `coaches/coach-config.yaml` domain. When enabled, that file owns the coach roster, warmup video, cooldown video, and exactly one overlay audio clip per workout entry.

## Building a Workout

When creating a Workout, a creator uses the community browser and tooling to pick the following:

* **Gameplay:** What gameplay style is this Workout made for? (`Boxing`, `Flow`, etc.)
* **Difficulty Intent:** Which chart difficulty is this Workout targeting (`easy`, `medium`, `hard`, `pro`)?
* **Songs / Selections:** Which exact songs, routines, and charts are included?
* **Chart Choice:** The package should resolve to exact chart ids rather than loose song/mode/difficulty matching.
* **Environments:** Optional. Choose one environment per workout entry.
* **Assets:** Optional. Choose at most one asset per entry-selectable asset type (`gloves`, `targets`, `obstacles`, `trails`) for each workout entry.
* **Coaching:** Optional. Attach workout-level coaching configuration through the package's single `coaches/coach-config.yaml` file. Disabled coaching uses `enabled: false`; enabled coaching must fully wire the roster, warmup/cooldown videos, and one overlay audio clip per entry.

When choosing any Workout, athletes can override the suggestions using their **Profile Preferences**.

* **Avatars:** Your avatar is your identity. It is set in your profile and persists across all workouts.
* **Environment:** Workouts often suggest immersive environments. You can override this to always use your preferred environment (for example, a simple dark void) if the suggested one is distracting.
* **Assets:** Workouts may suggest themed gloves, targets, obstacles, or trails. You can override this to stick with your preferred visuals (for example, high-contrast targets) for visibility or comfort.
* **Coaching:** Disable all coaching material from playing.
