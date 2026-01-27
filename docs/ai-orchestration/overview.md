# AI-Orchestration Development Using Gastown

AeroBeat is architected to be **"AI-Orchestrator-Native"**. This means the project topology and design decisions are specifically intended to be compatible with multi-agent orchestration methods.

We currently utilize the Gastown orchestration method, popularized by Steve Yegge. Gastown enables reliable multi-agent workflows by persisting work state in git-backed hooks, ensuring context isn't lost during agent restarts.

You can read more about Gastown at the public [Github repo](https://github.com/steveyegge/gastown).

---

## 🏗️ Core Architecture & Terminology

Gastown is an opinionated system, it has its own lingo and terminology to learn.

*   **Town**: The AeroBeat polyrepo root (e.g., `~/aerobeat/`), which contains the various `rigs` (repositories).

*   **Rigs**: Individual project containers that wrap each git repository in the topology.

*   **Beads**: Atomic units of work (issues) that track specific task states.

*   **Convoys**: Units that bundle multiple beads for tracking and assignment.

In Gastown, a **Town** acts as the workspace root containing various **Rigs** (git repositories). 

Specialized agent instances take up specific roles to execute work tracked via **Convoys** and **Beads**.

*   **The Mayor**: The central AI coordinator and "Chief of Staff" for the Town. This is who you send commands to most of the time.

*   **Polecats**: Ephemeral worker agents spawned to execute specific GDScript tasks.

*   **Refinery**: The release engineer agent responsible for merge-queue management and quality gates.

In addition to our user-defined Agent roles, Gastown includes some predefined Agent roles baked in.

*   **Deacon**: The Watchdog. This is a background process (a daemon) that monitors the entire "Town". Its primary job is to watch for stalled tasks or "Beads" and alert the human operator if a system-level failure occurs.

*   **Witness**: The Patrol. This agent operates at the Rig level. It acts as a lightweight patrol that can verify local state and ensure that the "Hook" (the persistent work state) is being respected by the active worker agents.

---

## 📑 Centralized Instruction Registry

To prevent configuration drift across our 15+ repositories, AeroBeat uses a **Source of Truth** (SSOT) model. All agent logic is housed within the `aerobeat-docs` repository.

### The Registry File

Every agent entering the Town is directed to the **Global Orchestration Registry**: `~/aerobeat/aerobeat-docs/docs/ai-orchestration/instructions.md`

This file acts as a directory, pointing agents to their specific operating manuals (Mayor, Polecat, Refinery, etc.) based on their assigned role.

---

Below are more details on each Agent role in the AeroBeat Gastown ecosystem.

---

## 🎩 The Mayor

The Mayor manages the overarching polyrepo structure and enforces license safety. It breaks down complex engineering requests into atomic **Beads** and assigns them to the appropriate Rigs.

### 1. Create the Mayor Alias

Register the persistent alias to ensure the Mayor always loads the correct orchestration logic:

```bash
gt config agent set aerobeat-mayor "claude --prompt-mode none --instructions-file ~/aerobeat/aerobeat-docs/docs/ai-orchestration/aerobeat-mayor.md"
```

### 2. Start the Session

Initialize the Town coordination session:

```bash
gt mayor start --agent aerobeat-mayor
```

---

## 🦨 Polecats

Polecats are the "proletariat" worker agents. They operate within a specific Rig, following sequential actionable steps assigned by the Mayor.

*   **Protocol**: Polecats must follow the **AeroBeat Style Guide** (Static Typing, Signal Up/Call Down).

*   **Quality**: They are required to use Test-Driven Development (TDD) with GUT, aiming for 100% logic coverage.

*   **Context**: Each Rig contains a `AGENTS.md` and `CLAUDE.md` that points the Polecat to the global `instructions.md` and the local `README.md`.

---

## 🛡️ The Refinery

The Refinery is a specialized role that serves as the automated quality gatekeeper. It reviews code produced by Polecats before it is permitted to enter the `main` branch.

*   **Context**: Each Rig contains a `AGENTS.md` and `CLAUDE.md` that points the Refinery to the global `instructions.md` and the local `README.md`.

### 1. Create the Refinery Alias

Register the alias for review-focused tasks:

```bash
gt config agent set aerobeat-refinery "claude --prompt-mode none --instructions-file ~/aerobeat/aerobeat-docs/docs/ai-orchestration/aerobeat-refinery.md"
```

### 2. The Review Workflow (MEOW)

The Mayor remains the "Chief of Staff" and "slings" the completed work to a Refinery-tuned agent for final verification.

```bash
# Mayor assigns a completed Bead to the Refinery for review
gt sling <bead-id> <rig-name> --agent aerobeat-refinery
```

### 3. Automated Gates

The Refinery automatically rejects PRs that fail:

*   **License Safety**: No GPLv3 code in MPL 2.0 repositories.

*   **Topology Check**: Dependencies must flow DOWN (Assembly -> Feature -> Core).

*   **Style/Coverage**: Strict adherence to the GDScript style guide and 100% test coverage.

---

## 👨‍💼 The Deacon (The Watchdog)

The Deacon is the persistent background daemon that oversees the entire Town. It acts as a health monitor for the orchestration system, ensuring that work state remains consistent across all Rigs and that the "GUPP" (Gastown Universal Persistence Protocol) is functioning correctly.

*   **Role**: System-level watchdog and health monitor.

*   **Primary Objective**: To detect stalled Beads or "zombie" agents and alert the human overseer if the persistent state becomes corrupted.

*   **Context Awareness**: It monitors the "Hook" (the work state) to ensure the Mayor and Polecats are in sync.

### Common Commands

```bash
# Start the Deacon to monitor the current Town
gt deacon start

# Check the health of the Deacon and the status of system-level hooks
gt deacon status

# Restart the Deacon if monitoring has stalled
gt deacon restart
```

---

### 🐕 The Witness (The Patrol)

The Witness is a rig-level agent that acts as a "lightweight patrol". While the Deacon watches the whole Town, the Witness focuses on specific Rigs to verify that the local repository state matches the global orchestration instructions.

*   **Role**: Local state validator.

*   **Primary Objective**: To ensure that any worker agent (Polecat) operating in the Rig is respecting the local CLAUDE.md and AGENTS.md constraints.

*   **Integrity Check**: It serves as a secondary check to prevent "instruction drift" within a specific repository.

### Common Commands

```bash
# Invoke the Witness to verify the current Rig's state
gt witness check

# List all active Witnesses patrolling your Rigs
gt witness list

# Force a Witness to refresh its local context from the documentation Rig
gt witness refresh
```

