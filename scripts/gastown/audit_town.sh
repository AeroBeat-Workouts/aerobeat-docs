#!/bin/bash

# scripts/gastown/audit_town.sh
# Audits the Gastown workspace to verify the Safety Layer is active.
# Usage: ./scripts/gastown/audit_town.sh <path_to_town>

set -e

if [ -z "$1" ]; then
    echo "Usage: $0 <path_to_town>"
    echo "Example: $0 ~/aerobeat_town"
    exit 1
fi

TOWN_DIR="$1"

if [ ! -d "$TOWN_DIR" ]; then
    echo "ERROR: Town directory '$TOWN_DIR' does not exist."
    exit 1
fi

# List of known AeroBeat repositories (Short aliases and full names)
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

echo "Auditing Town at: $TOWN_DIR"
echo "---------------------------------------------------"

ISSUES_FOUND=0
CHECKED_COUNT=0

for rig_name in "${KNOWN_RIGS[@]}"; do
    RIG_PATH="$TOWN_DIR/$rig_name"
    
    if [ -d "$RIG_PATH" ] && [ -d "$RIG_PATH/.git" ]; then
        CHECKED_COUNT=$((CHECKED_COUNT + 1))
        RIG_ISSUES=0
        
        # Check 1: Context Bundle
        if [ ! -f "$RIG_PATH/CONTEXT_INJECTION.md" ]; then
            echo "❌ [$rig_name] Missing CONTEXT_INJECTION.md"
            RIG_ISSUES=1
        fi

        # Check 2: Claude Settings
        if [ ! -f "$RIG_PATH/.claude/settings.json" ]; then
            echo "❌ [$rig_name] Missing .claude/settings.json"
            RIG_ISSUES=1
        else
            # Check content of settings
            if ! grep -q "CONTEXT_INJECTION.md" "$RIG_PATH/.claude/settings.json"; then
                echo "❌ [$rig_name] .claude/settings.json does not reference context bundle"
                RIG_ISSUES=1
            fi
        fi

        if [ "$RIG_ISSUES" -eq 1 ]; then
            ISSUES_FOUND=$((ISSUES_FOUND + 1))
        else
            echo "✅ [$rig_name] Safety Layer Active"
        fi
    fi
done

echo "---------------------------------------------------"
if [ "$CHECKED_COUNT" -eq 0 ]; then
    echo "⚠️  No known AeroBeat rigs found."
elif [ "$ISSUES_FOUND" -eq 0 ]; then
    echo "🎉 All $CHECKED_COUNT rigs are compliant."
else
    echo "🚫 Found issues in $ISSUES_FOUND rigs. Run setup_town.sh to fix."
    exit 1
fi