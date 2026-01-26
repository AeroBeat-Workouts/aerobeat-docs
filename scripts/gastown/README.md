# Gastown Automation Scripts

This directory contains utility scripts for managing the **Gastown** agentic workflow within the AeroBeat project.

These scripts enforce the **Safety Layer**, ensuring that all autonomous agents ("Polecats") are injected with the project's architectural context and license constraints upon startup.

## Scripts

### 1. `setup_town.sh`
**The primary setup tool.** Iterates through a Gastown workspace ("Town"), identifies known AeroBeat repositories ("Rigs"), and applies the Safety Layer to each one.

**Usage:**
```bash
./scripts/gastown/setup_town.sh <path_to_town>
```
**Example:**
```bash
./scripts/gastown/setup_town.sh ~/aerobeat_town
```

### 2. `audit_town.sh`
Verifies that the Safety Layer is correctly installed in all Rigs. Run this periodically or before starting a large batch of work.

**Usage:**
```bash
./scripts/gastown/audit_town.sh <path_to_town>
```

### 3. `inject_context.sh`
Generates the `CONTEXT_INJECTION.md` bundle in the project root by concatenating the "Context Trinity" (Manifest, Style Guide, Glossary). This is called automatically by `setup_town.sh`.

**Usage:**
```bash
./scripts/gastown/inject_context.sh
```

### 4. `setup_rig.sh`
Internal helper script used by `setup_town.sh` to configure a single Rig.

## Configuration Files

*   **`claude-settings.json`**: A configuration file for the Claude Code CLI. It is copied to `.claude/settings.json` in each Rig, instructing the runtime to load `CONTEXT_INJECTION.md` on startup.