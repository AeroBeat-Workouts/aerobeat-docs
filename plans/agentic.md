# Strategic Plan: Agentic Engineering Workflows

This document outlines the strategy for integrating advanced Agentic Workflows into the AeroBeat development lifecycle.

## Links To Important Articles

*   **Ralph:** https://medium.com/@joe.njenga/ralph-wiggum-claude-code-new-way-to-run-autonomously-for-hours-without-drama-095f47fbd467

*   **Gastown:** https://steve-yegge.medium.com/welcome-to-gas-town-4f25ee16dd04

*   **Clawdbot:** https://github.com/clawdbot/clawdbot

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
    *   **Expensive (at Scale):** Running 20+ concurrent agents consumes massive API credits, though this is configurable (e.g., 2-5 agents).
    *   **Complexity:** Requires a heavy orchestration layer (Beads/Git) and specific tooling (tmux).
    *   **Chaos:** "Vibe Coding" approach can be messy; fixes might happen multiple times before the Refinery sorts them out.
    *   **License Contamination:** Risk of agents moving code between GPL and MPL repositories. *Mitigation:* Recent findings confirm we can inject context at the start of a Polecat session to significantly reduce this risk.

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
- [x] Create `scripts/gastown/inject_context.sh` (Context Bundle generator).
- [x] Create `scripts/gastown/claude-settings.json` (Runtime config).
- [x] Create `scripts/gastown/setup_town.sh` (Town automation).
- [x] Create `scripts/gastown/audit_town.sh` (Compliance checker).
- [x] Create `scripts/gastown/README.md` (Documentation).

## 4. Cost Analysis & ROI

To communicate the value of these workflows to non-technical stakeholders, we correlate the API costs (Token Burn) to an equivalent Human Hourly Wage.

*Assumptions: Using **Claude 3.5 Sonnet** ($3/M Input, $15/M Output). While **Claude 3 Opus** is technically the "higher tier," Sonnet 3.5 currently outperforms it in coding benchmarks at 1/5th the cost. Using Opus would increase costs by 5x (~$6.00/hr for Ralph).*

| Style | Burn Rate (Est.) | Human Equivalent | ROI Verdict |
| :--- | :--- | :--- | :--- |
| **Ralph** | **~$1.20 / hr** | **< Minimum Wage** | Extremely high. A tireless junior dev for the price of a coffee. |
| **Hybrid** | **~$1.60 / hr** | **< Minimum Wage** | **Best Value.** Slightly higher cost due to strict context injection, but prevents costly refactors later. |
| **Gastown (Swarm)** | **~$32.00 / hr** | **Junior Engineer** | High Risk. Burns cash like a salaried employee (20 concurrent agents). Only use for critical, time-sensitive crunches. |
| **Gastown (Lite)** | **~$4.00 / hr** | **< Minimum Wage** | **Balanced.** 2 concurrent agents + Mayor. Good for steady background work without the massive burn. |

### The "Context Tax"
In the **Hybrid** model, we pay a "Context Tax" of roughly **$0.40/hr** to inject the `AI_MANIFEST` and `STYLE_GUIDE` into every prompt. This ~$3.20/day investment prevents "Hallucination Drift," saving hours of human cleanup time.

## 5. License Compliance Strategy

**Universal Constraint:** Regardless of the system (Hybrid Ralph vs Gastown), we are working with limited AI agent systems that degrade as context fills up. Preventing license contamination and context drift are general issues inherent to any current agentic workflow.

Our polyrepo structure uses mixed licenses (GPLv3, MPL 2.0, CC BY-NC). Agents are generally "license-blind" and prioritize functional code over legal boundaries.

*   **The Risk:** An agent might move a helper function from a GPL `feature` repo into the MPL `core` repo to resolve a dependency, inadvertently "washing" the license or violating the GPL.
*   **The Mitigation (Hybrid Ralph):**
    *   **Repo-Aware Context:** The `AI_MANIFEST` injected into every prompt must declare the specific license of the active repository.
    *   **Constraint:** "You are working in an **MPL 2.0** repository. Do not import or paste code from GPL sources."
*   **The Mitigation (Gastown):**
    *   **Runtime Injection:** Run `scripts/gastown/inject_context.sh` to generate the bundle, then copy `scripts/gastown/claude-settings.json` to the `.claude/` directory of each Rig to auto-load it.
    *   **Bead Context:** The Mayor can prepend the license constraints to the Bead description before "slinging" it to a Polecat.

## 6. Tooling Exploration: Clawdbot

To further professionalize our agentic workforce, we are investigating **Clawdbot** as a persistent "Digital Employee" runtime.

*   **Source:** https://github.com/clawdbot/clawdbot
*   **Role:** An open-source, local-first assistant that acts as a team member.

### Key Capabilities

*   **Local Execution:** Runs on a dedicated PC/Mac (Node.js), giving it full access to the file system, Godot Editor binaries, and local build tools. This bypasses the sandboxing limitations of cloud agents.
*   **Omnichannel:** Connects to our existing communication infrastructure (Discord, Slack, Teams). We can assign tasks to it just like a human engineer.
*   **Model Agnostic:** Can utilize any API (Anthropic, OpenAI) or local models, allowing us to balance cost/intelligence dynamically.
*   **Always On:** Capable of monitoring webhooks or cron jobs to autonomously start "Ralph" loops during off-hours.

### Use Case: The "Headless" Engineer

Instead of a developer manually running `loop.sh` in their terminal, Clawdbot can host the "Hybrid Ralph" workflow.

1.  **Task Assignment:** Lead Engineer tags `@Clawdbot` in Discord: *"Implement the tasks in `plans/supporters.md`."*
2.  **Autonomous Loop:** Clawdbot spins up the Ralph workflow locally, managing the Plan -> Build -> Test cycle.
3.  **Reporting:** It posts status updates, PR links, and test results back to the Discord thread.