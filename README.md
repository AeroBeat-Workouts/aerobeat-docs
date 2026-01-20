# aerobeat-docs
Documentation for the AeroBeat platform

## Local Development

To run this documentation site locally, you will need [Python](https://www.python.org/downloads/) installed.

### Quick Start (Windows)

We have included a helper script that automatically sets up the virtual environment, installs dependencies, and launches the server.

```powershell
.\serve.ps1
```

### Manual Setup

If you are on Mac/Linux or prefer to run commands manually:

1.  **Create a virtual environment:**
    ```bash
    python -m venv venv
    ```

2.  **Activate the environment:**
    *   Windows: `.\venv\Scripts\activate`
    *   Mac/Linux: `source venv/bin/activate`

3.  **Install dependencies:**
    ```bash
    pip install -r requirements.txt
    ```

4.  **Run the server:**
    ```bash
    mkdocs serve
    ```

The site will be available at `http://127.0.0.1:8000`.
