#!/usr/bin/env python3
# ..
# Scans the docs/ directory and ensures every Markdown file is referenced in mkdocs.yml.
# Helps prevent "orphaned" guides that are not accessible via the navigation menu.
#
# Usage: python scripts/validate_docs.py
# Dependencies: pip install PyYAML

import os
import sys
import yaml
from pathlib import Path

def load_mkdocs_nav(mkdocs_path):
    """Parses the 'nav' section from mkdocs.yml."""
    with open(mkdocs_path, 'r', encoding='utf-8') as f:
        try:
            config = yaml.safe_load(f)
            return config.get('nav', [])
        except yaml.YAMLError as e:
            print(f"Error parsing mkdocs.yml: {e}")
            sys.exit(1)

def flatten_nav(nav_item):
    """Recursively extracts file paths from the nested nav structure."""
    paths = []
    if isinstance(nav_item, list):
        for item in nav_item:
            paths.extend(flatten_nav(item))
    elif isinstance(nav_item, dict):
        for key, value in nav_item.items():
            paths.extend(flatten_nav(value))
    elif isinstance(nav_item, str):
        paths.append(nav_item)
    return paths

def main():
    # Determine paths
    script_path = Path(__file__).resolve()
    project_root = script_path.parent.parent
    docs_dir = project_root / 'docs'
    mkdocs_path = project_root / 'mkdocs.yml'

    if not mkdocs_path.exists():
        print(f"Error: {mkdocs_path} not found.")
        sys.exit(1)

    if not docs_dir.exists():
        print(f"Error: {docs_dir} not found.")
        sys.exit(1)

    # Load Nav
    nav_data = load_mkdocs_nav(mkdocs_path)
    referenced_paths = flatten_nav(nav_data)

    # Process references
    explicit_files = set()
    whitelisted_dirs = set()

    for p in referenced_paths:
        # Normalize path separators for the OS
        norm_p = os.path.normpath(p)
        
        if p.endswith('/') or p.endswith('\\'):
            # It's a directory reference (e.g., "api/core/")
            # This implies everything inside is covered (e.g., generated API docs)
            whitelisted_dirs.add(norm_p)
            # Implicitly includes index.md or README.md
            explicit_files.add(os.path.join(norm_p, 'index.md'))
            explicit_files.add(os.path.join(norm_p, 'README.md'))
        else:
            explicit_files.add(norm_p)

    # Configuration: Files/Dirs to ignore
    ignored_files = {'SUMMARY.md', 'CNAME', 'robots.txt', '_sidebar.md', '_navbar.md'}
    ignored_dirs = {'assets', 'theme', 'stylesheets', 'javascripts', 'img', 'images', 'css', 'js'}

    orphans = []

    # Walk docs directory
    for root, dirs, files in os.walk(docs_dir):
        # Filter ignored directories in-place
        dirs[:] = [d for d in dirs if d not in ignored_dirs and not d.startswith('.')]
        
        rel_root = Path(root).relative_to(docs_dir)
        
        for file in files:
            if not file.endswith('.md'):
                continue
            
            if file in ignored_files:
                continue

            # Get relative path from docs/ (e.g., guides/agentic_onboarding.md)
            if rel_root == Path('.'):
                file_rel_path = file
            else:
                file_rel_path = str(rel_root / file)
            
            norm_file_path = os.path.normpath(file_rel_path)

            # Check 1: Explicit match in nav
            if norm_file_path in explicit_files:
                continue

            # Check 2: Inside a whitelisted directory (e.g., api/core/SomeClass.md)
            parent = os.path.dirname(norm_file_path)
            covered = False
            while parent:
                if parent in whitelisted_dirs:
                    covered = True
                    break
                parent = os.path.dirname(parent)
            
            if covered:
                continue

            orphans.append(file_rel_path)

    if orphans:
        print(f"❌ Found {len(orphans)} orphaned documentation files:")
        for o in sorted(orphans):
            print(f"  - {o}")
        print("\nAction Required: Add these files to mkdocs.yml 'nav' or delete them.")
        sys.exit(1)
    else:
        print("✅ All documentation files are referenced in mkdocs.yml.")
        sys.exit(0)

if __name__ == '__main__':
    main()