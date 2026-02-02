#!/usr/bin/env python3
"""
AeroBeat Gastown Setup Script
-----------------------------
This script bootstraps the entire AeroBeat Polyrepo ecosystem into a Gastown Town.

What it does:
    1. Fetches all public repositories from the 'AeroBeat-Workouts' GitHub organization.
    2. Converts repository names to Gastown-compatible Rig names (hyphens -> underscores).
    3. Executes `gt rig add` for each repository.
    4. Ensures all rigs are tracked by the Mayor.

Usage:
    python setup_gastown.py

Prerequisites:
    - Gastown CLI (`gt`) must be installed and in PATH.
    - A Gastown workspace must be initialized (run `gt install ~/gt` first).
    - Optional: GITHUB_TOKEN env var for higher API rate limits.
"""

import json
import os
import subprocess
import urllib.request
import urllib.error
import shutil

# Configuration
ORG_NAME = "AeroBeat-Workouts"
GT_BINARY = shutil.which("gt") # Auto-detect 'gt' in PATH

def get_repos():
    """Fetches all public repositories for the organization (Pagination support)."""
    repos = []
    page = 1
    per_page = 100
    token = os.environ.get("GITHUB_TOKEN")
    
    print(f"🔍 Fetching repositories for org: {ORG_NAME}...")
    
    while True:
        url = f"https://api.github.com/orgs/{ORG_NAME}/repos?type=public&per_page={per_page}&page={page}"
        req = urllib.request.Request(url)
        if token:
            req.add_header("Authorization", f"Bearer {token}")
            req.add_header("Accept", "application/vnd.github.v3+json")
            
        try:
            with urllib.request.urlopen(req) as response:
                data = json.loads(response.read().decode())
                if not data:
                    break
                repos.extend(data)
                if len(data) < per_page:
                    break
                page += 1
        except urllib.error.HTTPError as e:
            print(f"❌ Error fetching repos: {e}")
            break
        except Exception as e:
            print(f"❌ An error occurred: {e}")
            break
            
    print(f"✅ Found {len(repos)} repositories.")
    return repos

def sanitize_rig_name(repo_name):
    """
    Converts GitHub repo names to Gastown Rig names.
    Rule: Replace hyphens, dots, and spaces with underscores.
    Example: 'aerobeat-core' -> 'aerobeat_core'
    """
    return repo_name.replace("-", "_").replace(".", "_").replace(" ", "_")

def add_rig(repo):
    """Adds a single repository as a Gastown Rig."""
    repo_name = repo["name"]
    clone_url = repo["clone_url"]
    rig_name = sanitize_rig_name(repo_name)
    
    print(f"\n🏗️  Processing: {repo_name} -> Rig: {rig_name}")

    if not GT_BINARY:
        print("❌ Error: 'gt' binary not found. Please install Gastown first.")
        return False

    # Check if rig directory likely exists to avoid unnecessary calls
    # Note: This assumes standard ~/gt layout. A more robust way would be `gt rig list`.
    # But since we are running inside the rig scripts folder, we might not know the town root easily.
    # We'll rely on `gt` to fail gracefully if it exists.

    try:
        # We assume the user is running this from within a valid Town context or has GT_ROOT set.
        # If not, they might need to cd ~/gt first, but let's try invoking it.
        
        # We use subprocess to call `gt rig add`
        # We capture output to check for "already exists" messages without crashing.
        result = subprocess.run(
            [GT_BINARY, "rig", "add", rig_name, clone_url],
            capture_output=True,
            text=True
        )
        
        if result.returncode == 0:
            print(f"✅ Successfully added rig: {rig_name}")
            return True
        else:
            if "already exists" in result.stderr or "already exists" in result.stdout:
                print(f"ℹ️  Rig {rig_name} already exists. Skipping.")
                return True # Treat as success
            else:
                print(f"❌ Failed to add rig {rig_name}")
                print(f"   Error: {result.stderr.strip()}")
                return False

    except Exception as e:
        print(f"❌ Execution error: {e}")
        return False

def main():
    print("--- AeroBeat Gastown Setup ---")
    
    if not GT_BINARY:
        print("❌ Critical: 'gt' command not found in PATH.")
        print("   Please install Gastown: go install github.com/steveyegge/gastown/cmd/gt@latest")
        return

    # 1. Get the list of repos
    repos = get_repos()
    
    if not repos:
        print("⚠️  No repositories found. Check your network or Org name.")
        return

    # 2. Iterate and add each one
    success_count = 0
    failed_repos = []

    for repo in repos:
        if add_rig(repo):
            success_count += 1
        else:
            failed_repos.append(repo["name"])
    
    print(f"\n🎉 Setup Complete. Rigs: {success_count}/{len(repos)}")
    
    if failed_repos:
        print("\n⚠️  The following repositories failed to add:")
        for name in failed_repos:
            print(f"  - {name}")

if __name__ == "__main__":
    main()
