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

## ⭐ Community Edition

AeroBeat will be available from our website as the "Community Edition" for PC/Mac/Linux/Android, with the following features.

* **Free-To-Win** - Download for free from our website. Uses a `supporter` model to fund development.
* **Headset Free VR** - Brings the popular rhythm workout gameplay seen in VR titles to 2D screens using a standard Webcam.
* **Gameplay Modes** - Multiple rhythm gameplay modes. `Boxing`, `Flow`, `Dance`, and `Step` available across devices.
* **View Modes** - Change `view` styles between `track` and `portal` to visualize the gameplay in different ways, with each option being best for different purposes (`track` has targets rising from bottom-to-top in a 2D track like dance-dance-revolution and is best for small screens and mobile, while `portal` is a first person immersive view, great for TV's and VR).
* **Multiplayer** - Supports both local and online multiplayer modes with `supporters` and `friends`.
* **Play Anywhere** - Downloaded playlists are available offline and region free.
* **Runs On Your Device** - Runs on Windows, Mac, Linux, and Android phones. Unavailable on iOS due to restrictions.
* **Playlist Browser** - Easily search and filter playlists. Sign in or create an account to enable `community playlists`.
* **Official Playlists** - Based on `supporter` funding, we will patronize the creation cost of `official` AeroBeat playlists.
* **Community Playlists** - Navigate our `playlist browser` to find a never ending amount of content developed by the community.
* **Favorites** - Add playlists and creators to your `favorite` to easily find them again
* **Recommended Playlists** - Featured pre-screened playlists we think you'll love based on your play style. 
* **Playlist Of The Day** - Featured pre-screened playlist our `supporters` want to shout-out as the `playlist of the day` for everyone to see.
* **Meet Your Fitness Goals** - Track your progress and achieve your weekly workout goals to build good workout habits.

To fund development, we will use a `supporter` model. Pay a one time fee for each month you wish to support AeroBeat and recieve the following account perks. These are similar to the perks given in the touch rhythm platform `Osu!` to their supporters, but with some new additions.

* **Discord:** : Access `supporter` only sections of our Discord channel and visual flairs to your account
* **Account Icon** : Shows your status as a supporter each time you log in
* **Avatar Options** : Access supporter only customizations to be purchased with your `workout points`
* **Leaderboard Shoutouts** : Supporters have their own tab on playlist leaderboards and their name on a leaderboard list is called out as being a supporter.
* **Increased Friends List** : Double the size of your friends list (500 to 1000)
* **Early Builds:** : Gain access to in-development feature builds
* **Supporter-Only Polls:** : Supporters can voice their opinion on polls only available to them.

---

## 📱 Digital Stores & Arcade Editions

Porting AeroBeat to digital storefronts and Arcades requires the following changes to be successful.

* **Top-40 Music:** - Publisher funding would be used to pay for the rights to popular music
* **Choreography:** - Each song would be choreographed for our various difficulty levels as needed.
* **Collaborations:** - Custom environments and assets would be created in collaborations with IP holders.
* **Community Features:** - Generally unaccessible in these ports to prevent bad experiences with casual athletes.

Each version of AeroBeat across storefronts would have a unique selling point.
* **Arcade:** - Quick jump-in and play of individual songs. Use a touch screen to choose your gameplay style, song, and start! Uses the `portal` view with high resolution environments. Allows two players if there's enough physical space.
* **Mobile:** - Focuses on fitness goals with a stripped down version of our Community edition's user interface. Defaults to `track` view for small screens.
* **Steam:** - Similar to the mobile release, but defaults to `portal` view and high-resolution environments.

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

## 🕹️ Gameplay Agnosticism

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

## Accessibility Modifiers

Before starting a playlist, athletes can enable accessibility focused modifiers to change their gameplay.

* **No Squats:** Disables `obstacles` that require you to `squat` down to avoid them in `boxing` or `flow` playlists.
* **No Knee Strikes:** Disables `knee strikes` targets in `boxing` playlists
* **No Leg Lifts:** Disables `obstacles` that require you to use `leg lifts` in` boxing` playlists
* **No Arrows:** Disables directionality requirment of targets in `boxing` and `flow` playlists
* **No Obstacles:** Disables `obstacles` in `boxing` and `flow` playlists
* **No Bombs:** Disables `bomb` targets in `Flow` playlists
* **Zen Mode:** Disables `targets` and `obstacles`, just enjoy the sounds and the sights
* **Hit Streak:** Enables the `hit streak` counter to be visible during gameplay.
* **Practice Mode:** Enables you to scrub a `timeline` while paused to jump to sections of a song in a playlist. `workout points` are not saved while enabled.

---

## 🕹️ Difficulty Modifiers

These gameplay modifiers make the game easier or harder.

* **One Portal:** Forces choreography while in `portal` view to appear from a single forward facing `portal` in `boxing` and `flow` playlists.
* **3-Portals:** Condenses choreography while in `portal` view to appear in three portals (left, center, right) ahead of you in `boxing` and `flow` playlists.
* **Ghost Targets:** `targets` disappear as they get close to you in `boxing`, `flow`, and `step` gameplay.
* **Speed Up:** `targets` and `obstacles` take less time to travel from `portals` and the bottom of the `track`. Available on `boxing`, `flow`, and `step` gameplay styles.
* **Slow Down:**: `targets` and `obstacles` take more time to travel from `portals` and the bottom of the `track`. Available on `boxing`, `flow`, and `step` gameplay styles.
* **Arcade Mode:** Adds a health system that depletes as you miss `targets`. Miss too many and you fail the song. Regain health as you destroy `targets` and dodge `obstacles`.
* **Hardcore Mode:** Miss a `target`, or hit a `bomb` or `obstacle` to get sent back to the beginning of a song in a playlist.

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

## 🌐 Community Creations

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

## 🚨 Policing Community Content

The following restrictions will be put in place regarding community created content to prevent bad actors.

* **Opt-In:** - Athletes must create an account and agree to our terms and conditions before accessing community content.
* **DMCA Blocking:** - If AeroBeat recieves a DMCA takedown notice, the offending content will be unaccessible for new athletes.
* **DMCA Bans:** - DMCA content takedowns will result in account warnings and bans for creators.
* **Prevention:** - Offending content will be blocked from re-upload to our servers.
* **Pre-Banned Lists:** - If a pre-banned list exists, AeroBeat will adhere to it.
* **Marketing:** - All official communication and marketing will feature only legally licensed music and content.
* **Discussion Bans:** - Discussing unpermitted content on our official channels (Discord) will result in warnings and eventual bans for bad actors. 

---

## 🏋️ Workout Points & Goals

The following gamification systems will be included in the full release to help build healthy workout habits.

* **Workout Points:** - Playlists award `workout points` after completing them, you can see your total workout points since you started playing AeroBeat on the main menu near your account icon.
* **Weekly Goal:** - Set how many times you want to workout per week, and AeroBeat will automatically track this. Shown on our main UI and after a playlist finishes. Provides positive reinforcement each day you complete a playlist, and even more when you finish your weekly goal. Shown as a 7-day timestamp system for easy visual identification.
* **Avatars:** - Create a customizable avatar seen in multiplayer. Spend `workout points` to unlock new options.
* **Leaderboards:** - View how your doing in comparison to other athletes and your online friends.

---

## 🎨 Art Inspiration

* **Direction:** Natural Wonder with Digital Zen UI
* **Aesthetic:** High contrast Supernatural VR style with an Apple Watch art direction.
* **Constraint:** Must be capable of down-scaling quality or swapping assets to be performant on low end devices.
* **Nature Inspired:** Choose environments inspired by the best parts of our natural world.
* **Keywords:** Nature, Wonder, Outdoors, Athletic, Clean, Energetic.

---

## 🔮 Future Roadmap

These will likely change as production continues, but they are our best guess based on the current priorities for the project.

* **Phase 1 (Prototype):** PC Build + Python CV + Basic Boxing Core + 1 Song - Get community feedback.
* **Phase 2 (Mobile):** Native Android/iOS Port + On-Device CV - Test agnostic platform concepts.
* **Phase 3 (Platform):** Support for downloading community playlists and creations - Test community creation system.
* **Phase 4 (Multiplayer):** Real-time multiplayer with other athletes or compete against ghost data.
* **Phase 5 (Additional Gameplay):** Support additional gameplay cores as requested by the community.
