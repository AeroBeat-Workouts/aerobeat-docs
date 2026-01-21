# Development Workflow

### Repository Templates

To ensure license compliance and correct file structure, always start new repositories using the templates found in `aerobeat-docs/templates/`.

*   **Assembly/Feature/UI:** GPLv3
*   **Input/Core:** MPL 2.0
*   **Assets:** CC BY-NC 4.0

### Dependency Management

* **Git Submodules:** Managed via a `setup_dev` script in each repo root.
* **Peer Dependencies:** 3rd Party Plugins (e.g., PhantomCamera) are installed in the `aerobeat-assembly-*` root. Feature packages access them via `class_name` availability (Duck Typing).

### The `.testbed` Pattern

To develop Features in isolation:

1.  Feature Repos contain an ignored `.testbed/` folder.
2.  Developers run `./setup_dev` to clone dependencies (`aerobeat-core`) into `.testbed/addons/`.
3.  Developers work inside `.testbed/project.godot`.

### Asset Pipeline

* **Inheritance:** Artists inherit `res://templates/base_target.tscn` (from Feature) to create skins.
* **Single Dependency:** An Asset Package may only depend on **one** Feature. Shared assets must move to `aerobeat-asset-*-common`.

---

## Internal Assets & UGC Strategy

### Internal Policy
Scripts (`.gd`) and Shaders (`.gdshader`) are **PERMITTED** in Internally developed Asset Repos (Visual Polish).

### Community Content Policy

Scripts are **STRICTLY BANNED** in Community Packages to prevent RCE.

* **Method:** **Data-Driven Injection**.
* **Flow:** The Game spawns the Logic Entity (Feature Repo). The Loader reads a `SkinConfig` resource (UGC) and swaps the Mesh/Material at runtime.
* **Validation:** The Asset Loader rejects any imported package containing text resources with `script/source` references.