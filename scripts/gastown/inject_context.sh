#!/bin/bash

# scripts/gastown/inject_context.sh
# Generates a single markdown file containing the "Context Trinity" (Manifest, Style Guide, Glossary).
# This file is intended to be loaded by Gastown agents (Polecats) at startup to prevent
# license contamination and hallucination drift.

set -e

# Determine paths
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# Go up two levels: scripts/gastown -> scripts -> root
PROJECT_ROOT="$(dirname "$(dirname "$SCRIPT_DIR")")"
DOCS_PATH="$PROJECT_ROOT/docs/ai-prompting"
OUTPUT_FILE="$PROJECT_ROOT/CONTEXT_INJECTION.md"

echo "Building Context Trinity Bundle..."
echo "Source: $DOCS_PATH"
echo "Target: $OUTPUT_FILE"

# Header
cat <<EOF > "$OUTPUT_FILE"
# SYSTEM CONTEXT: AEROBEAT ARCHITECTURE

You are an autonomous agent working on the AeroBeat platform.
You must strictly adhere to the following architectural constraints, style guides, and terminology.

**CRITICAL LICENSE WARNING:**
This project uses a Polyrepo structure with mixed licenses (GPLv3, MPL 2.0, CC BY-NC).
Check the repository you are currently working in.
- If working in 'core' or 'tool' (MPL 2.0): DO NOT import code from 'feature' or 'assembly' (GPLv3).
- If working in 'feature' (GPLv3): You may import from 'core'.

---

EOF

# Function to inject file
inject_doc() {
    local file_name=$1
    local full_path="$DOCS_PATH/$file_name"

    if [ -f "$full_path" ]; then
        echo "## $file_name" >> "$OUTPUT_FILE"
        echo "" >> "$OUTPUT_FILE"
        cat "$full_path" >> "$OUTPUT_FILE"
        echo "" >> "$OUTPUT_FILE"
        echo "---" >> "$OUTPUT_FILE"
        echo "" >> "$OUTPUT_FILE"
        echo "-> Injected $file_name"
    else
        echo "ERROR: Could not find $file_name at $full_path"
        exit 1
    fi
}

# Inject the Trinity
inject_doc "AI_MANIFEST.md"
inject_doc "STYLE_GUIDE.md"
inject_doc "GLOSSARY.md"

echo "Context Bundle generated successfully."
echo "Configure your Gastown runtime to load: $OUTPUT_FILE"