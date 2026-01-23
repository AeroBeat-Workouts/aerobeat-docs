# Feature Development Guide

This guide is for **Gameplay Engineers** building new modes for AeroBeat (e.g., "Boxing", "Flow", "Dance", "Step").

Unlike standard Godot development, building a Feature requires strict adherence to **API Stability** because thousands of community-created Skins will depend on your code.

## 🏗️ The Architecture

A **Feature** is a self-contained library that provides:

1.  **Gameplay Logic:** Scoring, Hit Detection, Spawning.
2.  **Base Scenes:** The "Parents" that artists inherit from to create Skins, Environments, etc.
3.  **Choreography Parsers:** Logic to read `.beat` files, controlling how targets and obstacles spawn.

It does **NOT** provide:

*   **Main Menu:** Provided by Assembly utilizing the ui-kit & ui-shell system.
*   **Hardware Input:** Provided by Input Providers.
*   **User Profile:** Provided by Core alongside the ui-kit & ui-shell system.

## 🛡️ The "Stable Wrapper" Pattern

The biggest risk in our ecosystem is **Dependency Hell**. If you rename a node in your feature's scene, you could break 500+ community skins, avatars, environments, etc.

To prevent this, we use the **Stable Wrapper** pattern.

### 1. Internal Logic (`src/logic/`)

This is where your messy code lives. You can refactor this as much as you want.
*   `src/logic/BoxingController.gd`
*   `src/logic/HitCalculator.gd`

### 2. Public API (`src/api/`)

These are the scenes that Skins inherit from. **These are sacred.**

*   `src/api/base_glove.tscn`
*   `src/api/base_target.tscn`

**The Rules of the API:**

1.  **Never Rename Exported Nodes:** If `base_glove.tscn` has a MeshInstance3D named `Visual`, you can never rename it or move it in the hierarchy. Skins depend on that path.
2.  **Use Placeholders:** The API scene should contain generic "Greybox" meshes. The logic script should handle swapping these meshes at runtime based on the loaded Skin.
3.  **Composition:** Don't put logic on the API scene root if possible. Attach a `LogicComponent` node. This allows you to update the logic script without forcing a re-import of the API scene.

### ❓ FAQ: Why are scenes in a "Code" repository?

You might wonder why `base_glove.tscn` is here and not in an Art repository.

1.  **The Scene IS the Contract:** In Godot, the node hierarchy (e.g., "Script expects a child named `CollisionShape`") is part of the logic.
2.  **Dependency Direction:** Skins depend on Features. If the base scene were in an asset repo, the Feature would need to depend on that asset repo to spawn it, creating a circular dependency.
3.  **Greyboxing:** These scenes contain no production art. They use debug shapes (cubes/spheres) to allow engineers to test gameplay without waiting for artists.

## 🤝 API Contracts

### Class Names

Use `class_name` to define your public interface.

*   ✅ `class_name AeroBoxingFeature`
*   ❌ `extends "res://addons/aerobeat-core/feature.gd"`

### Signals over Direct Calls

Your feature does not know about the UI. Never try to `get_node("/root/HUD")`.

*   **Bad:** `ScoreLabel.text = str(score)`
*   **Good:** `signal score_updated(new_score)`

### The `setup()` Function

Every Feature must implement the `AeroFeature` interface from Core.

```gdscript
func setup(session: AeroSessionContext, user_state: AeroUserState) -> void:
    # Store references
    self.session = session
    self.user_state = user_state
    
    # Initialize pools based on song density
    _initialize_object_pools(session.song_data.note_count)
```

## 📦 Versioning Strategy

We use **Semantic Versioning** in `plugin.cfg`.

*   **Patch (1.0.0 -> 1.0.1):** Bug fixes in Logic. No API changes. Safe for everyone.
*   **Minor (1.0.0 -> 1.1.0):** New features (e.g., a new target type). Old skins still work.
*   **Major (1.0.0 -> 2.0.0):** **Breaking Change.** You renamed a node in `base_target.tscn` or changed the `AeroBoxingFeature` class name.
    *   *Impact:* All existing Skins are now incompatible.
    *   *Policy:* Avoid Major versions at all costs. If necessary, provide a migration tool.

## 🧪 Testing

Features require **100% Code Coverage**.

1.  **Unit Tests:** Test your scoring math and parsers in `test/unit/`.
2.  **Integration Tests:** Use the `.testbed` to spawn a mock game session and verify that targets spawn and despawn correctly.

## 🖥️ Headless Server Compatibility

AeroBeat supports multiplayer, running on **Headless Linux Servers** (no GPU, no Audio).

### The Golden Rule: Pure Logic

**Your Logic scripts (`src/logic/`) must never access Visual or Audio nodes directly.**

*   **Risk:** Multiplayer Server Crashes. If a script calls `AudioStreamPlayer.play()` or accesses rendering APIs on a headless server, the instance may crash.

### ❌ Bad Pattern (Direct Access)

```gdscript
# src/logic/BoxingController.gd
func on_target_hit():
    score += 100
    $HitSound.play()   # 💥 CRASH on Server!
    $Particles.emit()  # 💥 CRASH on Server!
```

### ✅ Good Pattern (Signals)

Use signals to notify the "View" layer (the Skin). The Skin exists on Clients but is stripped or ignored on Servers.

```gdscript
# src/logic/BoxingController.gd
signal target_hit(score_amount)

func on_target_hit():
    score += 100
    target_hit.emit(100) # Safe!
```