# Contributing Workflow

!!! info "Not a Programmer?"
    If you are an Artist, Musician, or Choreographer, this workflow might be too technical.
    Check out the **Contributing Section** on the homepage to find the right guide for you.

This guide outlines the lifecycle of a code contribution to the AeroBeat platform. Follow these steps to ensure your Pull Request (PR) is accepted quickly.

## 1. Fork & Clone

1.  **Fork** the target repository (e.g., `aerobeat-feature-boxing`) to your GitHub account.
2.  **Clone** your fork locally.
    ```bash
    git clone https://github.com/YourUsername/aerobeat-feature-boxing.git
    ```

## 2. Setup Environment

Before writing code, you must initialize the dependencies.

1.  **Run Setup:**
    ```bash
    python setup_dev.py
    ```
    This downloads `aerobeat-core` and other dependencies into the `.testbed/addons/` folder (or `addons/` for Assembly).

2.  **Open in Godot:**

    *   **Features/UI/Input:** Open the project inside `.testbed/`.
    *   **Assembly:** Open the project at the root.

## 3. Create a Branch

Create a descriptive branch for your changes.

```bash
git checkout -b feature/new-scoring-algo
# or
git checkout -b fix/input-latency
```

## 4. Development & Testing

1.  **Write Code:** Follow the Style Guide.
2.  **Write Tests:** Create unit tests in `test/unit/`.
3.  **Run Tests:** Use the GUT panel in Godot to ensure all tests pass.
    *   **Requirement:** We enforce **100% Code Coverage** for logic repositories.

## 5. Submit Pull Request (PR)

1.  Push your branch to your fork.
2.  Open a Pull Request against the `main` branch of the upstream repository.
3.  **Description:** Clearly explain *what* you changed and *why*. Link to any relevant Issues.

## 6. The Quality Gates

Once your PR is open, our automated bots will check your code.

### 🤖 CLA Assistant (Legal)

*   **Check:** Verifies you have signed the Contributor License Agreement.
*   **Action:** If this is your first time, a bot will comment on your PR. You must reply with:
    > "I have read and agree to the terms of the AeroBeat-Workouts CLA."

### 🧪 CI/CD (Technical)

*   **Check:** Runs the GUT test suite in a headless Godot runner.
*   **Action:** If any test fails or coverage drops below 100%, the check will fail. You must fix the errors and push again.

## 7. Review & Merge

1.  **Code Review:** A maintainer will review your code for architecture and style compliance.
2.  **Merge:** Once approved and all checks pass, your code will be merged into `main`.