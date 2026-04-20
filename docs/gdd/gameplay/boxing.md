# 🥊 Gameplay Core: "Boxing"

The debut gameplay module for AeroBeat is a rhythm-boxing experience.

### The Loop
1.  **The Beat:** Targets fly toward the athlete in sync with the music.
2.  **The Action:** The athlete must punch, dodge, or block based on the incoming target or obstacles.
3.  **The Feedback:** Successful hits trigger haptic feedback (if available), satisfying visual effects, and score multipliers if available.
4.  **The Workout:** The pattern of targets forces the player into a "Flow State," seamlessly blending cardio with rhythm.

### v0.0.1 Mechanics
* **Directional Punches:** Actions such as jabs, crosses, hooks, and uppercuts are used to hit targets based on their incoming direction.
* **Target Zones:** Targets spawn in 5 distinct zones relative to the active portal:
    *   **Arm Height (Left/Right):** Standard punches.
    *   **Crouch Height (Left/Right):** Forces the athlete to punch low or squat-punch.
    *   **Center:** Reserved for **Guard / Block** targets.
* **Left Targets:** Black targets come from portals toward the athlete. They must be hit with the athlete's left hand.
* **Right Targets:** White targets come from portals toward the athlete. They must be hit with the athlete's right hand.
* **Boxing Gloves:** Your left hand has a visible black glove, and your right hand has a white glove. This helps you know which targets to hit with each hand.
* **Guard Targets:** A target with a mix of black and white in yin-yang pattern. Requires the athlete to bring their arms together to block.
* **Hit:** If a target is hit appropriately, it explodes into a quickly decaying black or white particle with a satisfying `smack` sound effect.
* **Near Miss:** If a target hits your hand without the appropriate action, it flies off your hand with a `bonk` sound effect.
* **Miss:** If a target passes you without getting hit, no sound effect is heard, but if a score multiplier is present, it will be reduced or reset.
* **Portal View:** Targets fly toward the athlete from a central portal.
* **Track View:** Boxing can render in the broader Track View family on 2D screens. A common/default presentation moves targets upward through lanes toward a hit zone, but Track View is not limited to only that one bottom-to-top layout.

### Full Mechanics
* **Reward Targets:** These targets explode to reveal `confetti` particles, paired with a `reward` sound effect. Can be hit by either `hand`.
* **Obstacles:** Orange lines that force the athlete to squat (legs) or lean (core), or both. Counts as hitting a target if you dodge these with your `head`, otherwise it counts as a `miss`. **Note:** Only the head is tracked for collision. Athletes should be reminded not to over-extend their body, as moving just the head is sufficient to clear the obstacle.
* **Stance Changes:** Stance indicators appear on the track to guide the athlete's foot placement. While the game does not track feet in Boxing mode, proper stance is critical for power and flow.
    *   **Orthodox:** Swap body position so your **Left Foot** is pointing forward.
    *   **Southpaw:** Swap body position so your **Right Foot** is pointing forward.
    *   **Note:** Failing to change your body to the correct side does not affect your score. It is merely a guide to keep the athlete in proper form for the upcoming choreography.
* **Knee Strikes:** Lift your left or right knee at the right time to hit the black or white knee-strike target. Always appears physically low in the portal.
    *   **Tracking:** Detected by checking the horizontal alignment of the player's **Head** relative to the target lane, inferring a weight shift. This allows players to substitute the move for a Block or Crunch if unable to perform high-impact leg lifts.
* **Leg Lifts:** Lift your left or right leg horizontally at the right time to match the shape of the obstacles flying at you. Counts as if an `obstacle` hit you if your `head` touches the side of the `obstacle` shape. (Example: a triangle that extends far to the left, signifying a left leg lift.)
* **Run In Place:** Rings of obstacles fly at the athlete rapidly. Signifies an optional run-in-place segment for the athlete.
* **360-Portal-View:** Portals can appear within a full 360 ring around you. New portals open up requiring VR players to face them by rotating their body and head. Controller players use L1/R1, DPAD, or control sticks to snap to portal positions. Camera players are automatically rotated to face them. If too many portals appear too quickly, the 2D presentation folds those targets and obstacles into a readable Track View-compatible rendering to avoid snap fatigue and visual overload.
    *   **Active Portal:** The portal currently spawning targets is highlighted. In Pro modes, side portals may also become active simultaneously, requiring rapid focus shifts.
    *   **Portal Trails:** A visual particle stream flows from the bottom of every active portal toward the player. This helps the athlete center themselves relative to the portal and catches the eye when a new portal opens.
    *   **The Anchor:** The athlete's position is fixed at the center. Gameplay relies on rotation (swivel), not locomotion.
* **3-Portal-View:** Only left, center, and right portals appear in front of you, keeping you forward facing but adding more strategy to your workouts. For camera users, all portals are visible at all times without moving your head and targets and obstacles fly toward you without requiring body rotation.
* **Simultaneous-Portals:** Targets and obstacles can appear from multiple simultaneous portals. Used typically on Pro-level difficulty. In VR you have to move quickly to face these new portals to hit targets with high accuracy and dodge obstacles while switching positions rapidly (left, center, right). In 2D the targets and obstacles appear from left and right portal positions while remaining readable inside the Track View presentation. **Note:** This mechanic is discouraged for standard fitness flows as it breaks the rotation rhythm.
