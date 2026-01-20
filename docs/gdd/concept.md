# AeroBeat: Concept Overview

**AeroBeat** is an open-source, modular rhythm game platform designed to democratize fitness gaming.

Unlike traditional rhythm games that are locked to specific ecosystems (VR headsets, pc, mobile, or consoles), AeroBeat is **Gameplay Agnostic**, **Hardware Agnostic**, and **Input Agnostic**. Each piece of the engine is expandable to support a variety of rhythm workout gameplay mechanics across a variety of devices.

Our first featured rhythm workout Gameplay style is **Boxing** for laptop and desktop PC's. By utilizing Computer Vision (CV) to turn standard webcams into high-fidelity motion controllers, we allow anyone with a laptop or desktop to access a premium workout experience previously reserved for VR owners.

---

## 🎯 The High Concept

> **"The YouTube of Workout Games."**

AeroBeat is not just a game; it is a **Platform** consisting of three decoupled layers:
1.  **The Inputs:** How you move (Webcam, VR, Joycons, Keyboard, Mouse, Controller). Extensible with open and closed hardware API's.
2.  **The Engine:** The core rhythm logic, audio synchronization, and scoring.
3.  **The Content:** Community-created playlists, songs, assets, environments, and even entirely new gameplay mechanics (ex: **Flow**, **Step**, and **Dance**).

### Key Pillars
* **Accessibility First:** Hardware should not be a gatekeeper. If you have any supported device and input type, you can play any gameplay mode.
* **Fitness First:** Gameplay is designed for healthy habits, pushing for full movements that are safe to perform repeatedly.
* **Open Ecosystem:** Built on Godot and open standards to encourage community modding and proprietary hardware integrations.

---

## 🥊 Gameplay Core: "Boxing"

The debut gameplay module for AeroBeat is a rhythm-boxing experience.

### The Loop
1.  **The Beat:** Targets fly toward the athlete in sync with the music.
2.  **The Action:** The athlete must punch, dodge, or block based on the incoming target or obstacles.
3.  **The Feedback:** Successful hits trigger haptic feedback (if available), satisfying visual effects, and score multipliers if available.
4.  **The Workout:** The pattern of targets forces the player into a "Flow State," seamlessly blending cardio with rhythm.

### v0.0.1 Mechanics
* **Directional Punches:** Actions such as Jabs, Crosses, Hooks, and Uppercuts are used to hit targets based on the their income direction.
* **Left Targets:** Black targets come from portals toward the athlete. They must be hit with the athletes left hand.
* **Right Targets:** White targets come from portals toward the athlete. They must be hit with the ahtletes right hand.
* **Boxing Gloves:** Your left hand has a visible black glove, and your right hand has a white glove. This helps you know what targets to hit with each hand.
* **Guard Targets:** A target with a mix of black and white in yin-yang pattern. Requires athlete bring their arms together to block.
* **Hit:** If a target is hit appropriately, it explodes into a quickly decaying black or white particle with a satisfiying `smack` sound effect.
* **Near Miss:** If a target hits your hand without you performing the appropriate action it flies off your hand with a `bonk` sound effect.
* **Miss:** If a target gets passed you without getting hit, no sound effect is heard, but if a score multiplier is present, it will be reduced or reset.
* **Portal-View:** Targets fly towards the athlete from a central portal.
* **Track-View:** Targets move from the bottom of the screen to the top. Hit the target when it reaches the box at the top to succeed. Works great on smaller screens or when you stand farther away from the TV.

### Full Mechanics
* **Reward Targets:** These targets explode to reveal `confetti` particles, paired with a `reward` sound effect. Can be hit by either `hand`.
* **Obstacles:** Orange lines that force the athlete to Squat (Legs) or Lean (Core), or both. Counts as hitting a target if you dodge these with your `head`, otherwise it counts as a `miss`. There are many obstacle types in the forms of multiple lines at different angles, or hollow shapes and patterns.
* **Stance Changes:** At the start of a song and throughout, athletes may have to swap stances (Orthodox or Southpaw) which effects their real-world leg position and ability to throw quick punches from a cetain hand. This is not tracked by gameplay and is purely as a recommendation from the choreographer or coach.
* **Knee Strikes:** Lift your left or right knee at the right time to hit the black or white knee strike target. Always appears physically low in the portal.
* **Leg Lifts:** Lift your left or right leg horizontally at the right time to match the shape of the obstacles flying at you. Counts as if a `obstacle` hit you if your `head` touches the side of the `obstacle` shape. (ex: a triangle that extends far to the left, signifying a left leg lift).
* **Run In Place:** Rings of obstacles fly at the athlete rapidly. Signifies an an optional run-in-place segment for the athlete.
* **360-Portal-View:** Portals can appear within a full 360 ring around you. New portals open up requiring VR players to face them by rotating their body and head. Controller players use L1/R1, DPAD, or Control Sticks to snap to portal positions. Camera players are automatically rotated to face them. If too many portals appear too quickly, the 2D players see targets and obstacles appear from the same portal to avoid snap-fatique and visual problems reading the choreography.
* **3-Portal-View:** Only left, center, and right Portals appear in front of you, keeping you forward facing but adding more strategy to your workouts. For Camera users, all portals are visible at all times without moving your head and targets and obstacles fly towards you, without the need for you to 'rotate', because you can't as a Camera player.
* **Simultaneous-Portals:** Targets and obstacles can appear from multiple simultaneous portals. Used typically on Pro level difficulty. In VR you have to move to quickly face these new portals to hit targets with high accuracy and dodge obstacles while switching positions rapidly (left, center, right). In 2D the targets and obstacles appear from portals on the left and the right side of the center portal, but fly towards the player in the center without requiring the user adjust their body or head rotation.

---

## Gameplay Agnosticism

In time, additional gameplay modules will become available, based on community requests and support.

### FLOW: 
* **Gameplay:** Swing bats at targets to destroy them.
* **Based On:** SuperNatural VR's `Flow` gameplay, and first popularized in Beat Saber.

### STEP: 
* **Gameplay:** Step on targets as they come towards you.
* **Based On:** Made popular with Dance Dance Revolution in arcades

### DANCE:
* **Gameplay:** Perform popular dance moves to match the gestures.
* **Based On:** Originally popularized with the Dance Central series.

---

## 🎮 Input Agnosticism

AeroBeat's "Secret Sauce" is its ability to normalize data from wildly different hardware into a standard viewport space.

### Tier 1: Computer Vision (CV)
* **Tech:** MediaPipe (Python on PC / Native Plugin on Mobile).
* **Experience:** "Controller-Free." The athlete stands in front of a camera. The game tracks hands, arms, shoulders, and your head.
* **Pros:** Zero cost, high accessibility.
* **Cons:** Higher latency than VR, occlusion issues.

### Tier 2: Dedicated Hardware
* **Tech:** VR Controllers, JoyCons, Dance Pads
* **Experience:** "Tactile." The athlete holds devices that provide rumble feedback and ultra-low latency tracking.
* **Pros:** Precision, haptics, "Pro" feel.

### Tier 3: Legacy/Debug
* **Tech:** Mouse & Keyboard, Gamepads, Touch.
* **Experience:** Used for testing charts or playing when no other input is capable.

---

## 🛠️ The "Skin" System (UGC)

To support the "YouTube" vision, visual content is strictly separated from game logic.

* **Logic (The Skeleton):** A "Target" is just a mathematical hitbox and a timestamp.
* **Skin (The Visuals):** Artists can replace the default `targets`, `obstacles`, `portals`, and `hands` to skin the games visuals.
* **Environment:** The included environments can be replaced easily. Transporting athletes anywhere from a *Live Concert Stage* to the *Moon*.

This allows the community to create "Total Conversion" aesthetics without touching a line of code. 

Atheletes simply select a playlist and the engine takes care of the rest.

---

## Community Creations

When athletes navigate our community content portal, they can search and filter through various `playlists`. These are collections of content remixed to work together for a good workout experience by the community.

Every `playlist` is made up of multiple pieces of community content and is specific to a Gameplay style and difficulty level. (ex: A `Boxing` playlist is not the same as a `Flow` playlist, and a `easy` playlist is not the same as a `pro` playlist)

* **Songs:** - Musicians can add their songs to the platform for others to use.
* **Choreography:** - Custom choreography written for songs using our in-game charting software. The choreographer uploads their work under a specific difficulty level (`easy`, `medium`, `hard`, `pro`). Limited to one chart per difficulty per song.
* **Environments:** - Environments change up the background visuals and looping sound effects during a song. One environment is paired with one song in the playlist.
* **Art Assets:** - Artists can create custom visuals for the `targets`, `obstacles`, `portals`, and `hands` used per song in the playlist. 

When creating a `playlist`, a creator uses our in-game community content browser to pick the following.
* **Gameplay:** - What gameplay style is this playlist made for? (`Boxing`, `Flow`, etc)
* **Difficulty:** - Choose what difficulty level this playlist is intended for (`easy`, `medium`, `hard`, `pro`).
* **Songs:** - What songs are in this playlist? Limited to songs with existing choreography that matches your playlist and difficulty.
* **Choreography:** - Optional: By default we use the most popular choreography chart per gameplay and difficulty, however you can override this to choose another match.
* **Environments:** - Optional: Change the recommended environment. Once selection per song in the playlist.
* **Assets:** - Optional: Change the recommended visuals such as `targets`, `obstacles`, `portals`, and `hands`.
* **Coaching:** - Optional: Add warm up and cool down videos that play before and after the playlist finishes. In addition to an optional audio track to play during each song in the workout for your coaching.

When choosing any playlist (official or community created), athletes can override the following.
* **Environment:** - Disable custom environments from being used, instead using your preferred settings in your profile.
* **Assets:** - Disable custom assets from being used, instead using your preferred settings in your profile.
* **Coaching:** - Disable all coaching material from playing.

---

## 🔮 Future Roadmap

These will likely change as production continues, but they are our best guess based on the current priorities for the project.

* **Phase 1 (Prototype):** PC Build + Python CV + Basic Boxing Core + 1 Song - Get community feedback.
* **Phase 2 (Mobile):** Native Android/iOS Port + On-Device CV - Test agnostic platform concepts.
* **Phase 3 (Platform):** Support for downloading community playlists and creations - Test community creation system.
* **Phase 4 (Multiplayer):** Real-time multiplayer with other athletes or compete against ghost data.
* **Phase 5 (Additional Gameplay):** Support additional gameplay cores as requested by the community.
