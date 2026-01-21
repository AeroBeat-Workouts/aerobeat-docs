# Helper script to setup and run the documentation server

if (-not (Test-Path "venv")) {
    Write-Host "Initializing virtual environment..."
    python -m venv venv
}

Write-Host "Syncing dependencies..."
.\venv\Scripts\pip install -r requirements.txt

Write-Host "Ensuring placeholders exist..."
python scripts/create_placeholders.py

.\venv\Scripts\mkdocs serve