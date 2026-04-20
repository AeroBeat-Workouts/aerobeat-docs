# AeroBeat Family Git Hygiene Sweep

**Date:** 2026-04-20  
**Status:** Draft  
**Agent:** Pico 🐱‍🏍

---

## Goal

Bring the full AeroBeat repo family to a clean git state by checking every repo for uncommitted work, committing/pushing the work that belongs on `main`, and verifying each repo ends clean and up to date with origin.

---

## Overview

This is cross-repo coordination work, so the plan lives in `aerobeat-docs`. The task is not just a blind `git status` sweep: it needs to distinguish work created in this session from unrelated local dirt, avoid overwriting or hiding anything unexpected, and verify both local cleanliness and remote sync status across the whole AeroBeat family.

The execution should start with a family-wide audit of repo git state. From there, any repo with local tracked changes, untracked plan files from today’s work, ahead/behind divergence, or blocked pushes should get its own explicit cleanup step. Repos that are already clean and in sync should be recorded as such without churn.

---

## REFERENCES

| ID | Description | Path |
| --- | --- | --- |
| `REF-01` | Derrick’s instruction to ensure every AeroBeat repo is committed, pushed, clean, and up to date | current session notes (2026-04-20 13:46 EDT) |
| `REF-02` | Current AeroBeat repo family | `/home/derrick/.openclaw/workspace/projects/aerobeat/` |
| `REF-03` | Today’s cross-repo cleanup/audit work that may have left plan files or local commits pending | AeroBeat repos touched on 2026-04-20 |

---

## Tasks

### Task 1: Audit git state across all AeroBeat repos

**Bead ID:** `oc-ac0`  
**SubAgent:** `research`  
**References:** `REF-01`, `REF-02`, `REF-03`  
**Prompt:** Audit every git repo under the AeroBeat family. For each repo, report: branch, tracked/untracked changes, ahead/behind status versus origin, whether any local commits are unpushed, and whether any dirt appears to be from today’s intended work vs unrelated local state. Do not change anything yet.

**Folders Created/Deleted/Modified:**
- `.plans/`

**Files Created/Deleted/Modified:**
- `.plans/2026-04-20-aerobeat-family-git-hygiene-sweep.md`

**Status:** ⏳ Pending

**Results:** Pending.

---

### Task 2: Create and execute the repo-by-repo cleanup/push map

**Bead ID:** `oc-2pk`  
**SubAgent:** `coder`  
**References:** `REF-01`, `REF-02`, `REF-03`  
**Prompt:** Using the audit results, perform the repo-by-repo git hygiene cleanup needed to satisfy Derrick’s request. Commit and push intended work where appropriate, resolve simple behind-state sync issues safely, and leave a clear record of any repo that cannot be made clean/up-to-date without a human decision.

**Folders Created/Deleted/Modified:**
- `Pending audit results`

**Files Created/Deleted/Modified:**
- `Pending audit results`

**Status:** ⏳ Pending

**Results:** Pending.

---

### Task 3: Verify family-wide clean/up-to-date state

**Bead ID:** `oc-lxb`  
**SubAgent:** `qa` + `auditor`  
**References:** `REF-01`, `REF-02`, `REF-03`  
**Prompt:** Independently verify that every AeroBeat repo is either clean and up to date, or explicitly called out with the exact blocker. Confirm there are no missed uncommitted worktrees or unpushed commits in the family.

**Folders Created/Deleted/Modified:**
- `.plans/`

**Files Created/Deleted/Modified:**
- `.plans/2026-04-20-aerobeat-family-git-hygiene-sweep.md`

**Status:** ⏳ Pending

**Results:** Pending.

---

## Final Results

**Status:** ⏳ Pending

**What We Built:** Pending.

**Reference Check:** Pending.

**Commits:**
- Pending.

**Lessons Learned:** Pending.

---

*Drafted on 2026-04-20*
