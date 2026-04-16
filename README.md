# aerobeat-docs
Public design and technical documentation in `mkdocs` format for the AeroBeat platform.

## Local Development

To run this documentation site locally, you will need [Python](https://www.python.org/downloads/) installed.

### Quick Start (Windows)

We have included a helper script that automatically sets up the virtual environment, installs dependencies, creates any missing placeholder docs, and launches the server.

```powershell
./serve.ps1
```

### Quick Start (Linux/macOS)

Use the shell helper for the same repo-local setup flow on Unix-like systems:

```bash
chmod +x serve.sh
./serve.sh
```

### Manual Setup

If you prefer to run commands manually:

1.  **Create a virtual environment:**
    ```bash
    python3 -m venv venv
    ```

2.  **Activate the environment:**
    *   Windows: `.\venv\Scripts\activate`
    *   Mac/Linux: `source venv/bin/activate`

3.  **Install dependencies:**
    ```bash
    pip install -r requirements.txt
    ```

4.  **Ensure placeholder API docs exist:**
    ```bash
    python scripts/create_placeholders.py
    ```

5.  **Run the server:**
    ```bash
    mkdocs serve
    ```

The site will be available at `http://127.0.0.1:8000`.

## Deployment

This repository uses **GitHub Actions** to automatically build and publish the documentation.

1.  **Make Changes:** Edit the markdown files or configuration in the `main` branch.
2.  **Push:** Commit and push your changes to GitHub.
3.  **Auto-Publish:** The "Publish Docs" workflow will automatically run, build the site, and deploy it to the `gh-pages` branch.

The live site is available at: https://aerobeat-workouts.github.io/aerobeat-docs/

## Repository Templates

This repository serves as the **Source of Truth** for our GitHub Template Repositories.
If you are looking to create a new repository for the AeroBeat ecosystem (Assembly, Feature, Input, etc.), please refer to the Templates Documentation.
