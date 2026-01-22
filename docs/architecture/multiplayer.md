# Multiplayer Strategy

AeroBeat uses a **Relay Server** architecture where clients are authoritative over their own rhythm performance, but the Server manages the session state and clock synchronization.

## ⏱️ Real-Time Synchronization

Rhythm games require millisecond-precision. We cannot rely on standard network replication for hit timing.

### 1. The Shared Clock
*   **Server Time:** The Authority.
*   **Client Time:** `Server Time + RTT/2`.
*   **Start Signal:** The Server sends `RPC_StartGame(timestamp_future)`. Clients begin playback when their local clock hits that timestamp.

### 2. Client-Side Authority (Score)
Because latency varies, the **Local Client** is the ultimate judge of "Did I hit that beat?"
1.  **Hit:** Client calculates hit locally (0ms latency feel).
2.  **Update:** Client updates local `AeroUserState`.
3.  **Broadcast:** Client sends `RPC_ScoreUpdate(new_score, combo)` to Server.
4.  **Relay:** Server validates (basic sanity check) and relays to other clients.

### 3. Avatar Replication (Pose)
To visualize opponents, we replicate the `AeroInputProvider` data.
*   **Protocol:** UDP (Unreliable/Ordered).
*   **Rate:** 10-20Hz (Interpolated on remote clients).
*   **Data:** Head Transform + Left Hand + Right Hand.

### The "Remote Athlete" Pattern

Multiplayer opponents are visualized as "Remote Athletes" (Avatars).

1.  **Local Athlete:** Input -> Logic -> `AeroUserState` (Local).
2.  **Remote Athlete:** Network -> `AeroUserState` (Remote) -> Avatar Visualizer.
3.  **Constraint:** Gameplay Logic (`aerobeat-feature-*`) must accept a `target_user_state` in its setup. It does not assume it is always driving the main UI.

### Headless Safety (Multiplayer Prep)

Feature Logic must be safe to run on a Linux Headless Server (No GPU/Audio).

* **Forbidden:** Logic scripts calling `$Audio.play()` or `$Particles.emit()`.
* **Required:** Logic emits `signal hit_confirmed`. A separate `_view_connector.gd` (Client Only) listens and plays FX.