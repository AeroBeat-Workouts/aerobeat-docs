# 🥊 Gameplay Core: "Boxing"

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
