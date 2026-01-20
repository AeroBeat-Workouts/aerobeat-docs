# Helper script to setup and run the documentation server

if (-not (Test-Path "venv")) {
    Write-Host "Initializing virtual environment..."
    python -m venv venv
}

if (-not (Test-Path "venv\Scripts\mkdocs.exe")) {
    Write-Host "Installing dependencies..."
    .\venv\Scripts\pip install -r requirements.txt
}

.\venv\Scripts\mkdocs serve