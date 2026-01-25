# Strategic Plan: Agentic Engineering Workflows

This document outlines the strategy for integrating advanced Agentic Workflows into the AeroBeat development lifecycle.

## Links To Important Articles

*   **Ralph:** https://medium.com/@joe.njenga/ralph-wiggum-claude-code-new-way-to-run-autonomously-for-hours-without-drama-095f47fbd467

*   **Gastown:** https://steve-yegge.medium.com/welcome-to-gas-town-4f25ee16dd04

## 1. Context & Motivation

We are exploring upgrades to our engineering systems to leverage "Agentic" capabilities—where AI doesn't just autocomplete code, but plans, executes, and iterates on complex tasks.

## 2. Workflow Styles

### Style A: "Ralph" (The Deconstructor)
*   **Summary:** A sequential, loop-based workflow that separates **Planning** from **Building**. It uses a "fresh context" for every single task to maintain high intelligence.
*   **The Loop:**
    1.  **Phase 1 (Requirements):** Human & AI define "Jobs to be Done" (JTBD) and write `specs/*.md`.
    2.  **Phase 2 (Planning):** Agent reads specs vs. code (Gap Analysis) and generates `IMPLEMENTATION_PLAN.md`. No code is written.
    3.  **Phase 3 (Building):** Agent picks *one* task from the plan, implements it, runs tests (Backpressure), commits, and updates the plan.
    4.  **Reset:** The context is cleared after every task.
*   **Key Artifacts:**
    *   `specs/`: Requirements per topic.
    *   `IMPLEMENTATION_PLAN.md`: The mutable todo list.
    *   `AGENTS.md`: Operational guide (how to run tests/builds).
    *   `loop.sh`: The script that restarts the agent.
*   **Pros:**
    *   **Smart Zone:** Keeps context usage low (40-60%) so the LLM stays intelligent.
    *   **Self-Correcting:** If the plan is wrong, you just regenerate the plan, not the code.
    *   **Backpressure:** Tests prevent the agent from committing broken code.
*   **Cons:**
    *   **Slow Start:** Requires writing specs before coding.
    *   **Token Cost:** Restarting context every task consumes input tokens rapidly.
    *   **"YOLO" Risk:** Standard Ralph runs with `--dangerously-skip-permissions`, requiring sandboxing.

### Style B: "Gastown" (The Orchestrator)
*   **Summary:** An industrialized "Factory" approach that orchestrates swarms of agents (Claude Code instances) to attack work in parallel. It uses a "Hub-and-Spoke" role system (Mayor, Polecats, Refinery) to manage state via persistent "Beads" (Git-backed issues) and "Molecules" (Workflows).
*   **Key Roles:**
    *   **Mayor:** Concierge and dispatcher.
    *   **Polecats:** Ephemeral workers that swarm on tasks.
    *   **Refinery:** Intelligently merges conflicting changes from the swarm.
    *   **Witness:** Monitors the health of the swarm.
*   **Pros:**
    *   **Massive Throughput:** Can burn through huge backlogs or refactors by parallelizing work.
    *   **Resilience:** Uses "Nondeterministic Idempotence" (NDI) to ensure workflows complete even if agents crash.
    *   **Asynchronous:** Work is "slung" to the town and runs in the background (tmux).
*   **Cons:**
    *   **Expensive:** Running 20+ concurrent agents consumes massive API credits.
    *   **Complexity:** Requires a heavy orchestration layer (Beads/Git) and specific tooling (tmux).
    *   **Chaos:** "Vibe Coding" approach can be messy; fixes might happen multiple times before the Refinery sorts them out.

### Style C: Hybrid (AeroBeat-Ralph)
*   **Summary:** Adapts the "Ralph" loop but enforces AeroBeat's strict topology via **Context Injection**.
*   **The Modification:**
    *   **Strict Context:** The `PROMPT_*.md` files must inject `AI_MANIFEST.md` and `STYLE_GUIDE.md` at the start of every loop.
    *   **Spec Mapping:** Instead of loose `specs/`, we map `docs/gdd/*.md` as the source of truth.
    *   **Backpressure:** We use `gut` (Godot Unit Test) as the hard gate for the "Building" loop.
*   **Why:** Ralph's default "Let Ralph Ralph" philosophy encourages inventing patterns. AeroBeat requires strict adherence to the Hub-and-Spoke architecture.

## 3. AeroBeat Integration

Given our strict "Hub-and-Spoke" topology and "Context Trinity" (Manifest, Style Guide, Glossary), we need a workflow that respects these constraints.

- [x] Define "Ralph" and "Gastown" methodologies.
- [x] Evaluate fit for AeroBeat (Selected: Hybrid Ralph).
- [x] Update `docs/ai-prompting/overview.md` with the chosen workflow.

### Implementation Checklist
- [x] Create `scripts/ralph/` directory.
- [x] Create `PROMPT_plan.md` (with Context Trinity injection).
- [x] Create `PROMPT_build.md` (with Context Trinity injection).

## 4. Cost Analysis & ROI

To communicate the value of these workflows to non-technical stakeholders, we correlate the API costs (Token Burn) to an equivalent Human Hourly Wage.

*Assumptions: Using **Claude 3.5 Sonnet** ($3/M Input, $15/M Output). While **Claude 3 Opus** is technically the "higher tier," Sonnet 3.5 currently outperforms it in coding benchmarks at 1/5th the cost. Using Opus would increase costs by 5x (~$6.00/hr for Ralph).*

| Style | Burn Rate (Est.) | Human Equivalent | ROI Verdict |
| :--- | :--- | :--- | :--- |
| **Ralph** | **~$1.20 / hr** | **< Minimum Wage** | Extremely high. A tireless junior dev for the price of a coffee. |
| **Hybrid** | **~$1.60 / hr** | **< Minimum Wage** | **Best Value.** Slightly higher cost due to strict context injection, but prevents costly refactors later. |
| **Gastown** | **~$32.00 / hr** | **Junior Engineer** | High Risk. Burns cash like a salaried employee (20 concurrent agents). Only use for critical, time-sensitive crunches. |

### The "Context Tax"
In the **Hybrid** model, we pay a "Context Tax" of roughly **$0.40/hr** to inject the `AI_MANIFEST` and `STYLE_GUIDE` into every prompt. This ~$3.20/day investment prevents "Hallucination Drift," saving hours of human cleanup time.