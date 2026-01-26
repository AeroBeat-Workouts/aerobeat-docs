# Gastown Workflow Guide

This guide explains how to use the **Gastown** agentic workflow for high-throughput, parallel development in AeroBeat.

Unlike "Ralph" (which is sequential and careful), Gastown is an industrial "Factory" that uses a swarm of agents ("Polecats") orchestrated by a "Mayor".

## ⚠️ Critical Safety Warning

Gastown agents run in parallel and can easily "drift" or violate license boundaries (GPL vs MPL) if not properly constrained.

**You must configure the Safety Layer before starting any work.**

## 1. Setup

### A. Prerequisites
1.  **Gastown CLI:** Follow installation instructions at [github.com/steveyegge/gastown](https://github.com/steveyegge/gastown).
2.  **Claude Code:** Ensure you have access to the Claude Code CLI (`claude`).

### B. Initialize the Town
Create your workspace (Town) and add the AeroBeat repositories (Rigs).

```bash
# Create Town
gt install ~/aerobeat_town --git
cd ~/aerobeat_town

# Add Rigs (Example)
gt rig add core https://github.com/AeroBeat-Workouts/aerobeat-core.git
gt rig add boxing https://github.com/AeroBeat-Workouts/aerobeat-feature-boxing.git
```

### C. Install the Safety Layer
This step ensures every agent receives the **Context Trinity** (Manifest, Style Guide, Glossary) and **License Constraints** on startup.

We have provided an automation script to handle the generation of the context bundle and the configuration of runtime hooks for each Rig.

Run this for *each* Rig in your Town (e.g., `~/aerobeat_town/core`):

```bash
# From your main AeroBeat repository root:
./scripts/gastown/setup_rig.sh ~/aerobeat_town/core
```

## 2. The Workflow

### Step 1: The Mayor
Start the orchestration session.

```bash
cd ~/aerobeat_town
gt mayor attach
```

**Prompt the Mayor:**
> "I need to refactor the Input System in `core`. Here is the plan..."

### Step 2: Convoys & Beads
The Mayor will break your request into "Beads" (Tasks) grouped into a "Convoy".

*   **Review the Beads:** Ensure the Mayor hasn't hallucinated dependencies.
*   **Check Context:** Verify the Mayor understands which Repo (Rig) each Bead belongs to.

### Step 3: Slinging (Execution)
The Mayor "slings" beads to Polecats.

*   **Automatic Injection:** Because of Step 1.C, every Polecat that spins up will immediately read `CONTEXT_INJECTION.md`.
*   **License Check:** The agent will see: *"CRITICAL LICENSE WARNING: You are in an MPL 2.0 repo..."*

### Step 4: The Refinery (Human Review)
Gastown is fast, but messy. You act as the "Refinery".

1.  **Monitor:** Watch the dashboard or `gt convoy list`.
2.  **Review PRs:** Agents will create PRs or commits.
3.  **Audit:** Check for:
    *   **License Leaks:** Did GPL code end up in Core?
    *   **Style Violations:** Did they use `var x` instead of `var x: int`?

## 3. Troubleshooting

*   **Agents ignoring Style Guide:**
    *   Verify `CONTEXT_INJECTION.md` exists in the Rig root.
    *   Verify `.claude/settings.json` is correctly placed.
*   **Hallucination Drift:**
    *   If a Convoy runs too long, agents lose context. Break work into smaller Convoys.