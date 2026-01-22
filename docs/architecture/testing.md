# Unit Testing Strategy

To ensure stability across our modular architecture, we enforce a strict **Test-Driven Development (TDD)** workflow.

## 🛠️ The Tool: GUT (Godot Unit Test)

We use **[GUT (Godot Unit Test)](https://github.com/bitwes/Gut)** as our unified testing framework.

*   **Why?** It runs natively inside the Godot Editor (for rapid dev) and via Command Line (for CI/CD).
*   **Installation:** GUT is included as a submodule in `aerobeat-core` and available in all derived projects.

## 🚦 The Rules

### 1. Coverage Requirements

We require **100% Unit Test Coverage** for all logic paths.

*   **Required:** `aerobeat-core`, `aerobeat-input-*`, `aerobeat-ui-core`, `aerobeat-feature-*`, `aerobeat-assembly-*`.
*   **Exempt:** `aerobeat-asset-*` (These contain only Art/Music/Models and no logic).

### 2. CI/CD & Branch Protection

We utilize **GitHub Actions** to enforce quality gates.

*   **Trigger:** Every Push or Pull Request to the `main` branch.
*   **Action:** The runner spins up a headless Godot instance and executes the GUT test suite.
*   **Policy:** If **ANY** test fails, the commit is rejected and the PR cannot be merged.
*   **Template:** A standard workflow file for CI/CD unit testing is included in the appropriate repository templates.

## 🤖 AI-Assisted Testing

Writing boilerplate tests is tedious. We encourage using AI to generate comprehensive test suites that cover edge cases you might miss.

### The "Test Gen" Prompt
When you finish a script (e.g., `ScoreCalculator.gd`), open your AI assistant and use this prompt:

```
**Context:** I have just written the attached GDScript file.
**Task:** Write a GUT (Godot Unit Test) script for it.
**Requirements:**
1.  **Coverage:** Create test cases for every function and every logical branch (if/else).
2.  **Edge Cases:** Test with null values, negative numbers, and boundary limits.
3.  **Style:** Use `assert_eq`, `assert_signal_emitted`, etc.
4.  **Mocking:** If the script depends on other classes, use `double()` to mock them.
```

## 📂 Test Structure

Tests live in a `test/` folder at the root of the repository, mirroring the structure of `src/`.

```text
aerobeat-core/
├── src/
│   └── logic/
│       └── ScoreManager.gd
└── test/
    └── unit/
        └── test_ScoreManager.gd
```