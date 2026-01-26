#!/bin/bash

# scripts/gastown/setup_town.sh
# Iterates over a Gastown workspace and applies the Safety Layer to known AeroBeat repositories.
# Usage: ./scripts/gastown/setup_town.sh <path_to_town>

set -e

if [ -z "$1" ]; then
    echo "Usage: $0 <path_to_town>"
    echo "Example: $0 ~/aerobeat_town"
    exit 1
fi

TOWN_DIR="$1"
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [ ! -d "$TOWN_DIR" ]; then
    echo "ERROR: Town directory '$TOWN_DIR' does not exist."
    exit 1
fi

# List of known AeroBeat repositories (Short aliases and full names)
# This ensures we catch rigs regardless of how they were named during 'gt rig add'.
KNOWN_RIGS=(
    "core" "aerobeat-core"
    "boxing" "aerobeat-feature-boxing"
    "flow" "aerobeat-feature-flow"
    "step" "aerobeat-feature-step"
    "dance" "aerobeat-feature-dance"
    "ui-shell" "aerobeat-ui-shell"
    "ui-kit" "aerobeat-ui-kit"
    "assembly" "aerobeat-assembly-community"
    "tool-api" "aerobeat-tool-api"
    "tool-analytics" "aerobeat-tool-analytics"
    "tool-settings" "aerobeat-tool-settings"
    "tool-discord" "aerobeat-tool-discord"
    "input-joycon" "aerobeat-input-joycon"
    "input-mediapipe" "aerobeat-input-mediapipe"
)

echo "Scanning Town at: $TOWN_DIR"
echo "Looking for ${#KNOWN_RIGS[@]} known repository names..."

FOUND_COUNT=0

for rig_name in "${KNOWN_RIGS[@]}"; do
    RIG_PATH="$TOWN_DIR/$rig_name"
    
    if [ -d "$RIG_PATH" ]; then
        # Check if it's actually a git repo/rig to avoid false positives
        if [ -d "$RIG_PATH/.git" ]; then
            echo "---------------------------------------------------"
            echo "Found known rig: $rig_name"
            "$SCRIPT_DIR/setup_rig.sh" "$RIG_PATH"
            FOUND_COUNT=$((FOUND_COUNT + 1))
        fi
    fi
done

if [ "$FOUND_COUNT" -eq 0 ]; then
    echo "---------------------------------------------------"
    echo "⚠️  No known AeroBeat rigs found in $TOWN_DIR."
    echo "   Ensure you have added rigs using 'gt rig add <name> <url>'."
    echo "   Expected names: core, boxing, ui-shell, etc."
else
    echo "---------------------------------------------------"
    echo "✅ Town setup complete. Safety Layer applied to $FOUND_COUNT rigs."
fi