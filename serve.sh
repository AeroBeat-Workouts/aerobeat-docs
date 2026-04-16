#!/usr/bin/env bash
set -euo pipefail

if [ ! -d "venv" ]; then
  echo "Initializing virtual environment..."
  python3 -m venv venv
fi

source venv/bin/activate

echo "Syncing dependencies..."
pip install -r requirements.txt

echo "Ensuring placeholders exist..."
python scripts/create_placeholders.py

exec mkdocs serve "$@"
