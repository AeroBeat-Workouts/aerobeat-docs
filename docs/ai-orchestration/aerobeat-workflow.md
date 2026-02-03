# 🔄 AeroBeat Agent Workflow (Gastown Standard)

This document defines the standard operating procedures for all agents within the AeroBeat Gastown environment. It is derived from the core Gastown protocols.

## ⚡ Quick Reference (Beads CLI)

All agents must use the `bd` (beads) tool to track their work.

```bash
bd ready              # Find available work assigned to you
bd show <id>          # View detailed instructions for a bead
bd update <id> --status in_progress  # Claim and start working on a bead
bd close <id>         # Mark work as complete
bd sync               # Sync local state with the town database
```

## 🛬 Landing the Plane (Session Completion)

**When ending a work session**, you MUST complete ALL steps below. Work is NOT complete until `git push` succeeds.

### MANDATORY WORKFLOW:

1.  **File issues for remaining work**
    *   Create new beads for any tasks that were left unfinished or discovered during your session.
    *   Do not leave "mental notes"—if it's not in a bead, it doesn't exist.

2.  **Run quality gates** (if code changed)
    *   Run relevant tests (GUT).
    *   Run linters/formatters (gdformat).
    *   Ensure the project builds.

3.  **Update issue status**
    *   Close finished beads (`bd close <id>`).
    *   Update in-progress beads with your latest status.

4.  **PUSH TO REMOTE** - This is **MANDATORY**:
    ```bash
    git pull --rebase
    bd sync
    git push
    git status  # MUST show "up to date with origin"
    ```

5.  **Clean up**
    *   Clear stashes.
    *   Prune local branches that have been merged.

6.  **Verify**
    *   Confirm all changes are committed AND pushed.

7.  **Hand off**
    *   Provide context for the next session (or the next agent picking up the work).

### 🚨 CRITICAL RULES:
*   **Work is NOT complete until `git push` succeeds.**
*   **NEVER stop before pushing** - that leaves work stranded locally in your container.
*   **NEVER say "ready to push when you are"** - YOU must push.
*   **If push fails**, resolve the conflict and retry until it succeeds.
