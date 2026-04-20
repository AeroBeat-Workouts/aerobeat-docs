# Input Pipeline (Provider Pattern)

AeroBeat uses the **Provider Pattern** for runtime input.

The public-facing abstraction is the **Input Provider**: a runtime bridge that turns hardware-specific signals into normalized gameplay data. Game logic never talks to a webcam, controller, keyboard, or tracker directly; it asks the **Input Provider** for normalized data.

`Strategy` remains an implementation-detail term for how a concrete provider internally performs adaptation or switching. It is **not** the main public name for the overall input abstraction.

* **Interface:** `AeroInputProvider` (defined in `aerobeat-core`).
* **Contract:** Must return normalized `0.0 - 1.0` viewport coordinates or equivalent gameplay-space data for `LeftHand`, `RightHand`, and `Head`.

## Supported Input Providers

| Input Provider | Repository | Technology | Typical Target Platform |
| :--- | :--- | :--- | :--- |
| **MediaPipe Python Provider** | `aerobeat-input-mediapipe-python` | **Sidecar Process.** Launches a Python subprocess that pipes landmark data via UDP `localhost:8100`. | Windows, Linux, Mac |
| **MediaPipe Native Provider** | `aerobeat-input-mediapipe-native` | **GDExtension / Plugin.** Runs MediaPipe directly in the application memory. | Android, iOS |
| **JoyCon HID Provider** | `aerobeat-input-joycon-hid` | **Raw Bluetooth.** Connects directly to JoyCons to read high-speed gyro / accel data. | Windows, Linux, Android |
| **Keyboard Provider** | `aerobeat-input-keyboard` | **Godot Native.** Maps WASD / Arrow keys to gameplay lanes or fallback gestures. | All |
| **Mouse Provider** | `aerobeat-input-mouse` | **Godot Native.** Maps cursor X/Y to viewport coordinates. | Desktop / Web |
| **Touch Provider** | `aerobeat-input-touch` | **Godot Native.** Maps touchscreen taps to viewport coordinates. | Mobile / Tablet |
| **Gamepad Provider** | `aerobeat-input-gamepad` | **Godot Native.** Standard XInput / controller stick mapping. | All |
| **XR Provider** | `aerobeat-input-xr` | **Tracked 6DOF controllers / hands.** Uses XR runtime pose data. | XR |

## Interaction Family vs Input Profile

AeroBeat docs distinguish between authored-content compatibility and concrete runtime/device targets.

* **Interaction Family:** The authored-content compatibility group, such as `gesture_2d`, `tracked_6dof`, or `hybrid`.
* **Input Profile:** A concrete runtime/device compatibility target or validated profile, such as `mediapipe_camera`, `keyboard_debug`, or `gamepad_virtual_presence`.

Charts target **interaction families** first. They record **input profiles** as supported or validated compatibility notes.

## Provider Grouping Rationale

We enforce a **one-repo-per-provider** policy, even for standard Godot inputs.

### The Logic: Granularity & Quirks

1. **Isolation of quirks**
   * While Godot handles generic gamepads well, specific controllers such as dance pads or flight sticks often report as generic devices but still require custom axis remapping, deadzone tuning, or timing logic.
   * By isolating `aerobeat-input-gamepad`, AeroBeat can implement provider-specific adaptation without polluting keyboard or touch input code.

2. **The driver tier (`input-mediapipe-*`, `input-joycon`, `input-xr`)**
   * These providers require **heavy external dependencies** such as Python environments, Android `.aar` libraries, GDExtensions, vendor SDKs, or XR runtimes.
   * **Isolation is safety:** keeping those providers in separate repos prevents unrelated contributors from needing every dependency stack just to fix a gameplay or UI issue.

## Normalization Flow

1. **Raw data:** The concrete provider receives device-specific data (for example, MediaPipe landmarks such as `x: 0.54, y: 0.21, z: -0.1`).
2. **Adaptation:** The provider applies technology-specific normalization, offsets, handedness correction, filtering, and coordinate transforms.
3. **Delivery:** The provider exposes a stable gameplay contract such as `get_left_hand_transform()` to the game loop.

Implementation details may still use strategy objects internally, but the public architectural contract remains the **Input Provider**.
