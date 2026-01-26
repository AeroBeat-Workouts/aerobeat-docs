# Agentic Onboarding: Choosing Your Workflow

AeroBeat is an **AI-Native** project. We don't just use AI for autocomplete; we use "Agentic Workflows" where AI plans, executes, and tests code autonomously.

We support two distinct workflows: **Ralph** (Precision) and **Gastown** (Scale).

## 📊 The Decision Matrix

| Feature | 🕵️ Ralph (Hybrid) | 🏭 Gastown (Swarm) |
| :--- | :--- | :--- |
| **Best For** | Feature Development, Complex Logic, Architecture. | Refactors, Grunt Work, Mass Updates, Test Gen. |
| **Analogy** | The Sniper. | The Machine Gun. |
| **Cost** | Low (~$1.60/hr). | High (~$32/hr) to Moderate. |
| **Context** | **Fresh Context** every task. High intelligence. | **Persistent Context** (Beads). Prone to drift. |
| **Safety** | High. Enforces strict architecture via prompt injection. | Moderate. Requires "Safety Layer" setup. |
| **Topology** | Works perfectly with Hub-and-Spoke. | Requires careful orchestration to respect boundaries. |

### When to use Ralph?
*   You are building a new Feature (e.g., "Add Kickboxing Mode").
*   You are debugging a complex race condition.
*   You need strict adherence to the `STYLE_GUIDE.md`.
*   *Why?* Ralph resets his memory after every task, ensuring he never gets "lazy" or hallucinates fake APIs.

### When to use Gastown?
*   You need to rename a variable across 50 files.
*   You want to generate Unit Tests for an entire module.
*   You have a backlog of 20 small, independent bugs.
*   *Why?* Gastown runs agents in parallel. It's messy, but fast.

---

## 🕵️ Workflow A: Ralph (The Standard)

Ralph is a loop: **Plan → Build → Reset**.

### 1. Setup
No installation required. Just use the helper script in the repo.

### 2. The Loop
Run the interactive loop script from your terminal:

```bash
./scripts/ralph/loop.sh
```

1.  **Select "Plan":** The script generates a prompt containing the GDDs and Codebase context. Paste it into Claude/Cursor.
    *   *Output:* `IMPLEMENTATION_PLAN.md`
2.  **Select "Build":** The script generates a prompt containing the **Context Trinity** and the **Plan**. Paste it into the AI.
    *   *Action:* AI implements **ONE** task from the plan.
3.  **Verify:** Run tests. If pass, commit.
4.  **Reset:** Clear the AI chat context. Repeat Step 2.

---

## 🏭 Workflow B: Gastown (The Factory)

Gastown orchestrates a swarm of "Polecat" agents.

### 1. Setup
Gastown requires CLI tools and a specific workspace structure.

1.  **Install Gastown:** Installation Guide
2.  **Initialize Town:**
    ```bash
    gt install ~/aerobeat_town --git
    # Add your rigs (repos)...
    ```
3.  **Apply Safety Layer (CRITICAL):**
    You **MUST** run this to prevent license contamination (GPL vs MPL).
    ```bash
    ./scripts/gastown/setup_town.sh ~/aerobeat_town
    ```

### 2. The Workflow

1.  **Start Mayor:** `cd ~/aerobeat_town && gt mayor attach`
2.  **Create Convoy:** Tell the Mayor your plan. It creates "Beads" (Tasks).
3.  **Sling:** The Mayor assigns Beads to Polecats.
4.  **Refine:** You act as the "Refinery," reviewing PRs and merging them.

---

## ⚠️ Universal Rules

Regardless of the workflow, you must respect the **Context Trinity**.

1.  **AI_MANIFEST:** Do not invent new folders.
2.  **STYLE_GUIDE:** Static typing is mandatory.
3.  **GLOSSARY:** Use correct terminology.