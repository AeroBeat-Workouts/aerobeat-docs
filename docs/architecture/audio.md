# Audio Architecture & Latency Strategy

In a rhythm game, "Audio Latency" is the enemy. If the player hits a drum when they *hear* the beat, but the game registers the input 50ms later (or the audio was played 50ms late), the game feels broken.

AeroBeat uses a **DSP-Based Conductor** to ensure millisecond-precision synchronization between Audio, Visuals, and Input.

## 1. The Problem: The "Delta" Drift

Standard game loops use `_process(delta)` to track time.

*   **Issue 1 (Drift):** `delta` is variable (frame rate fluctuations). Accumulating `delta` leads to drift over a 3-minute song.
*   **Issue 2 (Stepping):** `AudioStreamPlayer.get_playback_position()` only updates when the audio chunk is mixed (every ~20-50ms), causing visual "stutter" if mapped directly to object movement.

## 2. The Solution: The Conductor

We rely on the **AudioServer** as the source of truth, not the Engine clock.

### Calculating Song Position

The `AeroConductor` calculates the precise `song_position` every frame using the hardware clock:

```gdscript
# The time the audio started playing (DSP time)
var time_begin = 0.0
# The delay caused by the hardware audio buffer
var time_delay = AudioServer.get_time_since_last_mix() - AudioServer.get_output_latency()

func _process(delta):
    # Get current DSP time from the AudioServer
    var time_now = AudioServer.get_time_since_last_mix() + AudioServer.get_output_latency()
    # Calculate exact position in the song
    song_position = time_now - time_begin - user_offset
```

*(Note: The actual implementation handles pausing, seeking, and pitch scaling).*

## 3. Latency Compensation Strategy

We handle latency in two directions: **Visuals (Output)** and **Input (Input)**.

### A. Visual Latency (The "Travel Time")

Objects (Targets) must arrive at the "Hit Zone" exactly when the beat plays.

*   **Concept:** We spawn objects *in the future*.
*   **Formula:** `spawn_time = target_beat_time - (approach_rate_seconds)`
*   **Adjustment:** If the user has video lag (e.g., TV post-processing), we adjust the `user_video_offset`.

### B. Input Latency (The "Hit Window")

When the user punches, we compare the current `song_position` to the `target_beat_time`.

*   **Hardware Latency:** Bluetooth headphones add ~200ms of delay. The user hears the beat *late*.
*   **Calibration:** The user runs a calibration wizard to define `user_audio_offset`.
*   **Correction:** We subtract the user's offset from the current time to determine when they *intended* to hit.

## 4. The Conductor Signals

The rest of the game is reactive. It does not count time; it listens to the Conductor.

*   `signal beat(beat_index)`: Emitted on every quarter note. Used for UI pulsing and environment animations.
*   `signal measure(measure_index)`: Emitted every bar. Used for major lighting changes.
*   `signal step(step_index)`: Emitted on 1/16th notes. Used for high-precision sequencing.