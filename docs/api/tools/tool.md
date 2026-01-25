# Tool Architecture & API

**Tools** are reusable, non-gameplay services that provide specific technical capabilities (Networking, Analytics, Discord Integration) to the AeroBeat Assembly.

## Overview

Unlike **Features** (which handle gameplay logic) or **UI** (which handle presentation), Tools are strictly **Service Providers**. They are designed to be:

1.  **Singleton-Ready:** Intended to be used as Autoloads.
2.  **Game-Agnostic:** They do not depend on specific gameplay modes (Boxing/Flow, Dance, Step).
3.  **MPL 2.0 Licensed:** Safe to link into proprietary assemblies.

## The Base Contract: `AeroToolManager`

Every Tool repository must expose a main manager class inheriting from `AeroToolManager`.

### Class Reference

```gdscript
class_name AeroToolManager
extends Node

# Signals
## Emitted when the tool has finished initializing.
signal initialized

# Properties
## Master toggle for the service.
@export var is_active: bool = true

# Lifecycle
func _ready() -> void:
    _initialize()

func _initialize() -> void:
    # Override this in your implementation
    pass
```

## Integration Pattern

Tools are integrated into the Assembly via **Git Submodules** and **Autoloads**.

### 1. Installation
Tools are cloned into `addons/`.

```bash
git submodule add https://github.com/AeroBeat-Fitness/aerobeat-tool-api.git addons/aerobeat-tool-api
```

### 2. Registration
In `project.godot`, the tool's main script is registered as an Autoload (Singleton).

```ini
[autoload]

AeroApi="*res://addons/aerobeat-tool-api/src/AeroApiManager.gd"
AeroAnalytics="*res://addons/aerobeat-tool-analytics/src/AeroTelemetry.gd"
```

### 3. Usage
Game logic accesses the tool via the global singleton name.

```gdscript
func _on_login_button_pressed():
    AeroApi.login(username, password)
```

## Standard Tools

| Tool | Repository | Singleton Name | Responsibility |
| :--- | :--- | :--- | :--- |
| **API** | `aerobeat-tool-api` | `AeroApi` | REST Client, Auth, Retry Logic. |
| **Settings** | `aerobeat-tool-settings` | `AeroSettings` | Persistence for Profile and Preferences. |
| **Analytics** | `aerobeat-tool-analytics` | `AeroTelemetry` | Event batching and ingestion. |
| **Discord** | `aerobeat-tool-discord` | `AeroDiscord` | Rich Presence integration. |