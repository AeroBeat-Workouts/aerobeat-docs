# AI-Assisted Development Guide

AeroBeat is architected to be "AI-Native." We encourage the use of LLMs (Gemini, Cursor, Claude, ChatGPT) to accelerate development.

However, to prevent "Code Drift" and hallucinations, you must strictly follow this prompting workflow.

---

## 🏗️ The "Context Trinity"

We have established three static files in `docs/ai-context/` that define our universe. You must **always** provide these to the AI before asking it to write code.

| File | Purpose | When to use |
| :--- | :--- | :--- |
| **`AI_MANIFEST.md`** | **The Map.** Defines folder structure and file locations. | Use when creating new files or refactoring. |
| **`STYLE_GUIDE.md`** | **The Rules.** Enforces GDScript typing and naming conventions. | Use for **ALL** code generation. |
| **`GLOSSARY.md`** | **The Dictionary.** Defines terms like "Beat" vs "Measure". | Use when discussing game logic. |

Download Context Bundle (.zip){ .md-button .md-button--primary }

---

## ⚡ The Standard "Priming" Prompt

When starting a new session (e.g., opening a new Chat in Cursor), copy and paste this block immediately. Do not type a custom intro.

```
**System Context:**
I am developing for the **AeroBeat Platform** (Godot 4.x).

**Constraints:**
1. **Style:** Adhere strictly to the attached `STYLE_GUIDE.md`. Use static typing (`var x: int`) and composition over inheritance.
2. **Architecture:** Respect the `AI_MANIFEST.md`. Do not invent new folders.
3. **Terminology:** Use definitions from `GLOSSARY.md`.

**Task:**
[Insert your specific task here, e.g., "Implement a new LayoutStrategy for 360 spawning"]
```

---

## 🟢 Best Practices

### 1. Reference Tiers Explicitly

Don't say: *"Make a button for the menu."*

**Do say:** *"Create a new Atom in `aerobeat-ui-kit-community` called `AeroToggle`. Then implement it in the `aerobeat-ui-shell-mobile-community` shell."*

### 2. The "One File" Rule

AI struggles with massive refactors. Ask for one file at a time.

* ❌ *"Refactor the entire Input System."*
* ✅ *"Create the `StrategyJoycon` script based on the `AeroInputStrategy` interface."*

### 3. Review Against the Style Guide

Before committing AI-generated code, verify these common "AI lazy" habits:

* Did it use `var x` instead of `var x: float`? (Reject it).
* Did it use `Input.is_action_pressed`? (Reject it—must use `AeroInputProvider`).
* Did it put a script on a Node that should be a Resource? (Reject it).

---

## 🛠️ Tool-Specific Setup

### For Cursor (IDE)

1.  Go to **Settings > General > Rules for AI**.
2.  Paste the contents of `STYLE_GUIDE.md` there.
3.  This ensures Cursor applies our style rules automatically without you needing to paste them every time.

### For Gemini / ChatGPT / Claude (Web)

1.  Zip the `docs/ai-context/` folder.
2.  Upload it at the start of the conversation.
3.  Tell it: *"Read these context files. Do not generate code until I ask."*