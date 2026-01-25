# Strategic Plan: The "Tool" Repository Tier

This document outlines the proposal for a new repository tier to house reusable, non-gameplay services and singletons.

## 1. The Problem: The "Core" Dilemma

Currently, our topology forces a binary choice for utility code:
1.  **`aerobeat-core`:** Intended for lightweight Contracts, Data Types, and Constants. Adding heavy implementation logic (like an HTTP REST Client) here bloats the core and violates the "Interface vs Implementation" separation.
2.  **`aerobeat-assembly-*`:** Code here is not reusable between editions (e.g., Community vs Arcade).

**Missing Link:** We lack a home for **"Services"**—functional modules that provide specific capabilities (Networking, Analytics, Social) but aren't "Gameplay Features" or "UI".

## 2. Proposed Solution: `aerobeat-tool-*`

We introduce a new tier: **Tools** (or Services/Modules).

*   **Naming Convention:** `aerobeat-tool-[name]`
*   **Role:** Provides a specific technical capability via a Singleton or Helper class.
*   **License:** MPL 2.0 (Library).

### Characteristics
*   **Dependencies:** Can depend on `aerobeat-core` (for types/logging). Must NOT depend on Features or UI.
*   **Scope:** Focused on one job (e.g., "Talk to API", "Log Telemetry").
*   **Integration:** Installed as a Git Submodule in the Assembly.

## 3. Candidate Modules

| Repo Name | Responsibility |
| :--- | :--- |
| **`aerobeat-tool-api`** | `AeroApiManager`. Handles REST calls, Auth tokens, and Retry logic. |
| **`aerobeat-tool-analytics`** | `AeroTelemetry`. Batches events and sends them to the ingestion endpoint. |
| **`aerobeat-tool-discord`** | Wraps Discord GameSDK for Rich Presence. |
| **`aerobeat-tool-settings`** | `AeroSettingsManager`. Handles saving/loading `user://settings.cfg` and applying overrides. |

## 4. Architecture & Usage

### Directory Structure
```text
aerobeat-tool-[name]/
├── src/
│   ├── AeroToolManager.gd  <-- The Autoload
│   └── utils/
├── test/
├── .testbed/
├── plugin.cfg
└── setup_dev.py
```

### Integration Pattern
The Assembly defines which tools are active.

1.  **Install:** `git submodule add ... addons/aerobeat-tool-api`
2.  **Enable:** Project Settings -> Plugins -> Enable.
3.  **Access:** Since they are Autoloads, they are globally accessible (e.g., `AeroApi.get("/user")`).

## 5. Execution Checklist

### Documentation
- [x] Update `docs/architecture/topology.md` to include the `aerobeat-tool-*` tier.
- [x] Update `docs/index.md` repository list.

### Templates
- [x] Create `templates/tool/` directory structure:
    - [x] `templates/tool/.testbed/project.godot`
    - [x] `templates/tool/src/AeroToolManager.gd`
    - [x] `templates/tool/test/unit/test_AeroToolManager.gd`
    - [x] `templates/tool/LICENSE.md` (MPL 2.0)
    - [x] `templates/tool/README.md`
    - [x] `templates/tool/plugin.cfg`
    - [x] `templates/tool/setup_dev.py`
    - [x] `templates/tool/.gitignore`
- [x] Update `scripts/sync_templates.ps1`.

## 6. Pre-Execution Audit Strategy

Before creating the new tier, we must identify existing references to "Managers", "Singletons", or "Services" in the documentation that should be migrated to the Tool tier definition.

*   **Keywords to Search:** `singleton`, `autoload`, `manager`, `service`, `api`, `telemetry`, `discord`, `settings`.
*   **Target Areas:** `docs/`, `templates/`.
*   **Action:** Update and run `scripts/audit_references.ps1` with these keywords.

## 7. Audit Results
- [x] `docs/ai-prompting/AI_MANIFEST.md`
- [x] `docs/ai-prompting/GLOSSARY.md`
- [x] `docs/ai-prompting/overview.md`
- [x] `docs/ai-prompting/STYLE_GUIDE.md`
- [x] `docs/api/core/index.md`
- [x] `docs/api/features/boxing/index.md`
- [x] `docs/api/inputs/mediapipe_native/index.md`
- [x] `docs/api/inputs/mediapipe_python/index.md`
- [x] `docs/architecture/backend_api.md`
- [x] `docs/architecture/input.md`
- [x] `docs/architecture/multiplayer.md`
- [x] `docs/architecture/overview.md`
- [x] `docs/architecture/performance.md`
- [x] `docs/architecture/reference.md`
- [x] `docs/architecture/security.md`
- [x] `docs/architecture/state-management.md`
- [x] `docs/architecture/telemetry.md`
- [x] `docs/architecture/testing.md`
- [x] `docs/architecture/topology.md`
- [x] `docs/architecture/ugc_modding.md`
- [x] `docs/architecture/ui-ux.md`
- [x] `docs/architecture/workflow.md`
- [x] `docs/gdd/art/overview.md`
- [x] `docs/gdd/concept.md`
- [x] `docs/gdd/economy/currency.md`
- [x] `docs/gdd/economy/supporter_perks.md`
- [x] `docs/gdd/gameplay/boxing.md`
- [x] `docs/gdd/gameplay/dance.md`
- [x] `docs/gdd/gameplay/flow.md`
- [x] `docs/gdd/gameplay/step.md`
- [x] `docs/gdd/gameplay/view-modes.md`
- [x] `docs/gdd/gamification/overview.md`
- [x] `docs/gdd/gamification/quests.md`
- [x] `docs/gdd/input-system/agnostic-input.md`
- [x] `docs/gdd/meta/locker_room.md`
- [x] `docs/gdd/meta/preferences.md`
- [x] `docs/gdd/meta/profile.md`
- [x] `docs/gdd/modifiers/difficulty.md`
- [x] `docs/gdd/releases/community.md`
- [x] `docs/gdd/releases/digital-stores-and-arcades.md`
- [x] `docs/gdd/roadmap/future-roadmap.md`
- [x] `docs/gdd/social/crews.md`
- [x] `docs/guides/accessibility.md`
- [x] `docs/guides/avatar_creation.md`
- [x] `docs/guides/calibration.md`
- [x] `docs/guides/choreography/boxing.md`
- [x] `docs/guides/choreography/dance.md`
- [x] `docs/guides/choreography/flow.md`
- [x] `docs/guides/choreography/overview.md`
- [x] `docs/guides/choreography/step.md`
- [x] `docs/guides/coaching.md`
- [x] `docs/guides/contributing_workflow.md`
- [x] `docs/guides/feature_development.md`
- [x] `docs/guides/skins.md`
- [x] `docs/index.md`
- [x] `docs/legal/refund_policy.md`
- [x] `docs/licensing/commercial.md`
- [x] `docs/licensing/CONTRIBUTING.md`
- [x] `docs/licensing/engineers.md`
- [x] `docs/licensing/hardware.md`
- [x] `docs/licensing/index.md`
- [x] `scripts/audit_references.ps1`
- [x] `scripts/create_placeholders.py`
- [x] `scripts/generate_changelog.py`
- [x] `scripts/sync_templates.ps1`
- [x] `templates/assembly/LICENSE.md`
- [x] `templates/assembly/project.godot`
- [x] `templates/assembly/README.md`
- [x] `templates/assembly/setup_dev.py`
- [x] `templates/asset/.testbed/project.godot`
- [x] `templates/asset/README.md`
- [x] `templates/asset/setup_dev.py`
- [x] `templates/avatars/.testbed/project.godot`
- [x] `templates/avatars/README.md`
- [x] `templates/avatars/setup_dev.py`
- [x] `templates/cosmetics/.testbed/project.godot`
- [x] `templates/cosmetics/README.md`
- [x] `templates/cosmetics/setup_dev.py`
- [x] `templates/environments/.testbed/project.godot`
- [x] `templates/environments/README.md`
- [x] `templates/environments/setup_dev.py`
- [x] `templates/feature/.testbed/project.godot`
- [x] `templates/feature/LICENSE.md`
- [x] `templates/feature/plugin.cfg`
- [x] `templates/feature/README.md`
- [x] `templates/feature/setup_dev.py`
- [x] `templates/input/.testbed/project.godot`
- [x] `templates/input/LICENSE.md`
- [x] `templates/input/README.md`
- [x] `templates/input/setup_dev.py`
- [x] `templates/README.md`
- [x] `templates/skins/.testbed/project.godot`
- [x] `templates/skins/README.md`
- [x] `templates/skins/setup_dev.py`
- [x] `templates/ui-kit/.testbed/project.godot`
- [x] `templates/ui-kit/LICENSE.md`
- [x] `templates/ui-kit/README.md`
- [x] `templates/ui-kit/setup_dev.py`
- [x] `templates/ui-shell/.testbed/project.godot`
- [x] `templates/ui-shell/LICENSE.md`
- [x] `templates/ui-shell/plugin.cfg`
- [x] `templates/ui-shell/README.md`
- [x] `templates/ui-shell/setup_dev.py`

## 8. Migration Decisions & Action Items

We have analyzed the codebase references and established the following migration path for existing managers.

### Migration Mapping
| Legacy Concept | New Tool Repository |
| :--- | :--- |
| `AeroApiManager` / Backend API | `aerobeat-tool-api` |
| `AeroTelemetry` / Analytics | `aerobeat-tool-analytics` |
| `AeroSettings` / Preferences | `aerobeat-tool-settings` |
| Discord Integration | `aerobeat-tool-discord` |

### Documentation Updates Checklist
- [x] Update `docs/ai-prompting/AI_MANIFEST.md` to include `aerobeat-tool-*` in the Directory Map.
- [x] Update `docs/architecture/backend_api.md` to reference `aerobeat-tool-api`.
- [x] Update `docs/architecture/telemetry.md` to reference `aerobeat-tool-analytics`.
- [x] Update `docs/architecture/state-management.md` to link `AeroUserPreferences` persistence to `aerobeat-tool-settings`.