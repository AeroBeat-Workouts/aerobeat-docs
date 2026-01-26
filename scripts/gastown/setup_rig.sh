#!/bin/bash

# scripts/gastown/setup_rig.sh
# Automates the setup of the Safety Layer for a Gastown Rig.
# Usage: ./scripts/gastown/setup_rig.sh <path_to_rig>

set -e

if [ -z "$1" ]; then
    echo "Usage: $0 <path_to_rig>"
    echo "Example: $0 ~/aerobeat_town/core"
    exit 1
fi

TARGET_RIG="$1"
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# Go up two levels: scripts/gastown -> scripts -> root
PROJECT_ROOT="$(dirname "$(dirname "$SCRIPT_DIR")")"

# Verify target exists
if [ ! -d "$TARGET_RIG" ]; then
    echo "ERROR: Target directory '$TARGET_RIG' does not exist."
    exit 1
fi

echo "Setting up Safety Layer for Rig: $TARGET_RIG"

# 1. Generate Context Bundle
echo "Generating Context Bundle..."
"$SCRIPT_DIR/inject_context.sh"

CONTEXT_FILE="$PROJECT_ROOT/CONTEXT_INJECTION.md"
SETTINGS_FILE="$SCRIPT_DIR/claude-settings.json"

# 2. Copy Context Bundle
echo "Copying Context Bundle..."
cp "$CONTEXT_FILE" "$TARGET_RIG/"

# 3. Configure Runtime Hooks
echo "Configuring Runtime Hooks..."
mkdir -p "$TARGET_RIG/.claude"
cp "$SETTINGS_FILE" "$TARGET_RIG/.claude/settings.json"

echo "✅ Rig setup complete. Safety Layer active."
echo "   - Context: $TARGET_RIG/CONTEXT_INJECTION.md"
echo "   - Settings: $TARGET_RIG/.claude/settings.json"