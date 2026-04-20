# Unit Testing Strategy

To ensure stability across our modular architecture, we enforce a strict **Test-Driven Development (TDD)** workflow.

## 🛠️ The Tool: GUT (Godot Unit Test)

We use **[GUT (Godot Unit Test)](https://github.com/bitwes/Gut)** as our unified testing framework.

*   **Why?** It runs natively inside the Godot Editor (for rapid dev) and via Command Line (for CI/CD).
*   **Installation:** GUT is a dev dependency installed into each repo's local testbed or workspace; it is no longer documented as a submodule inherited from a universal `aerobeat-core` repo.

## 🚦 The Rules

### 1. Coverage Requirements

We require **100% Unit Test Coverage** for all logic paths.

*   **Required:** the six core repos (`aerobeat-input-core`, `aerobeat-feature-core`, `aerobeat-content-core`, `aerobeat-asset-core`, `aerobeat-ui-core`, `aerobeat-tool-core`) plus logic-bearing `aerobeat-input-*`, `aerobeat-feature-*`, `aerobeat-tool-*`, `aerobeat-ui-*`, and `aerobeat-assembly-*` repos.
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

Package-repo unit tests live in `.testbed/tests/` so the hidden testbed remains the canonical development/test surface while repo root stays closer to the published runtime boundary. Assembly repos may still keep root-level application tests where appropriate, but package templates should not treat root `test/` as canonical.

```text
aerobeat-feature-boxing/
├── src/
│   └── logic/
│       └── ScoreManager.gd
└── .testbed/
    └── tests/
        └── test_score_manager.gd
```