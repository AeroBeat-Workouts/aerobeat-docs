# 🌍 AeroBeat Global Orchestration Registry

*   **Project:** AeroBeat (Godot 4.x Rhythm Platform)
*   **Orchestration System:** Gastown (Multi-Agent Multi-Rig)
*   **Source of Truth:** `aerobeat-docs` Rig

---

## 🧭 Instructions for All Agents

Regardless of your assigned role, you must adhere to the following baseline constraints:

1. **Registry First**: This file is your entry point. Do not execute tasks until you have confirmed your Role and read the corresponding manual linked below.
2. **Workflow Compliance**: You MUST read and follow the **[AeroBeat Workflow](./aerobeat-workflow.md)** for using `bd` (Beads) and "Landing the Plane" (pushing code).
3. **Context Discovery**: Read the `README.md` of your current Rig (e.g., `aerobeat-core`) to understand its specific Tier and Licensing (MPL 2.0 vs. GPLv3).
4. **Path Awareness**: You are currently operating within a Polyrepo "Town." Your documentation resides in the `aerobeat-docs` rig. Use relative paths defined in this registry to navigate instructions.

---

## 🎭 Role-Based Operating Manuals

Identify your assigned role (Mayor, Polecat, or Refinery) and follow the link to your specific manual. All manuals are located in the same directory as this registry.

### 1. The Mayor 🎩
* **Role**: Chief of Staff & Task Architect.
* **Manual**: [aerobeat-mayor.md](./aerobeat-mayor.md)
* **Objective**: Break down complex tasks into atomic "Beads" and ensure dependency/license safety.

### 2. The Polecat 🦨
* **Role**: Specialized Worker (GDScript Implementation).
* **Manual**: [aerobeat-polecat.md](./aerobeat-polecat.md)
* **Objective**: Execute Beads sequentially using Test-Driven Development (via the GUT tool) and the AeroBeat Style Guide.

### 3. The Refinery 🛡️
* **Role**: Release Engineer & Quality Gate.
* **Manual**: [aerobeat-refinery.md](./aerobeat-refinery.md)
* **Objective**: Manage the Merge Queue and verify that all PRs meet strict licensing and coverage gates.

---

## 🛠️ Global Project Standards

These standards are embedded within the manuals above:

*   **Topology Map**: (In Mayor Manual) Defines the 15-tier repository structure.
*   **Style Guide**: (In Polecat Manual) Defines static typing and architectural patterns (Signal Up/Call Down).
*   **Quality Gate**: (In Refinery Manual) Defines the "No-Merge" conditions for license violations.

---

## 🔗 Environment Note
If you are unable to resolve a relative path, the absolute base for this documentation is:
`~/aerobeat/aerobeat-docs/docs/ai-orchestration/`