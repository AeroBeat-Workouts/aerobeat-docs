#!/bin/bash

# scripts/ralph/loop.sh
# The interactive runner for the "Hybrid Ralph" Agentic Workflow.
# Generates context-heavy prompts for Planning and Building phases.

set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_ROOT="$(dirname "$(dirname "$SCRIPT_DIR")")"
DOCS_DIR="$PROJECT_ROOT/docs/ai-prompting"
OUTPUT_FILE="$PROJECT_ROOT/RALPH_PROMPT.txt"
PLAN_FILE="$PROJECT_ROOT/IMPLEMENTATION_PLAN.md"

# Template Processor
# Replaces {{FILENAME}} with the actual content of the file from docs/ai-prompting/
generate_prompt() {
    local template_name=$1
    local template_path="$SCRIPT_DIR/$template_name"

    echo "Generating prompt from $template_name..."
    
    # Clear output
    > "$OUTPUT_FILE"

    while IFS= read -r line; do
        # Check for mustache syntax {{FILE}}
        if [[ "$line" =~ \{\{(.*)\}\} ]]; then
            local fname="${BASH_REMATCH[1]}"
            local fpath="$DOCS_DIR/$fname"
            
            if [ -f "$fpath" ]; then
                echo "--> Injecting $fname"
                cat "$fpath" >> "$OUTPUT_FILE"
            else
                echo "⚠️  WARNING: Context file not found: $fname"
                echo "   (Expected at $fpath)"
            fi
        else
            echo "$line" >> "$OUTPUT_FILE"
        fi
    done < "$template_path"

    # If Building, append the Plan
    if [ "$template_name" == "PROMPT_build.md" ]; then
        if [ -f "$PLAN_FILE" ]; then
            echo "" >> "$OUTPUT_FILE"
            echo "## 3. Current Implementation Plan" >> "$OUTPUT_FILE"
            echo '```markdown' >> "$OUTPUT_FILE"
            cat "$PLAN_FILE" >> "$OUTPUT_FILE"
            echo '```' >> "$OUTPUT_FILE"
            echo "--> Injected IMPLEMENTATION_PLAN.md"
        else
            echo "⚠️  WARNING: IMPLEMENTATION_PLAN.md not found in root."
        fi
    fi

    echo "---------------------------------------------------"
    echo "✅ Prompt generated at: $OUTPUT_FILE"
    echo "📋 Copy the content of this file and paste it into your AI session."
    echo "---------------------------------------------------"
}

# Main Menu
echo "==================================================="
echo "   🕵️  RALPH AGENTIC LOOP"
echo "==================================================="
echo "1. Phase 1: PLAN (Gap Analysis -> Create Plan)"
echo "2. Phase 2: BUILD (Execute ONE task from Plan)"
echo "3. Exit"
echo "---------------------------------------------------"
read -p "Select Phase [1-3]: " choice

case $choice in
    1)
        generate_prompt "PROMPT_plan.md"
        ;;
    2)
        generate_prompt "PROMPT_build.md"
        ;;
    3)
        echo "Exiting."
        exit 0
        ;;
    *)
        echo "Invalid selection."
        exit 1
        ;;
esac

if [[ "$OSTYPE" == "darwin"* ]]; then
    pbcopy < "$OUTPUT_FILE"
    echo "✨ Content copied to clipboard!"
fi