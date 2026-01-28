"""
AeroBeat Polyrepo Sync Script

What this script does:
    - Fetches all public repositories from the 'AeroBeat-Workouts' GitHub organization.
    - Iterates through each repository.
    - If the repository does not exist locally in the parent directory, it clones it.
    - If the repository already exists locally, it pulls the latest changes using rebase and autostash.

How it works:
    - Uses the GitHub API to list repositories (handles pagination).
    - Determines the root directory relative to this script's location.
    - Uses `subprocess` to execute `git` commands.
    - Runs `git fetch --all --prune` to ensure remote tracking branches are up to date.
    - Can use a GITHUB_TOKEN environment variable to avoid API rate limits.

Where it should be run from:
    - This script is located in `aerobeat-docs/scripts/`.
    - It calculates the 'Town Root' (parent of aerobeat-docs) automatically.
    - It syncs sibling repositories into that root folder.

Conflict Resolution:
    - This script uses `git pull --rebase --autostash` to minimize failures.
    - `--autostash`: Automatically stashes uncommitted local changes, pulls, and then unstashes.
      This prevents failures due to a "dirty" working directory.
    - `--rebase`: Re-applies your local commits on top of the latest remote changes, keeping history clean.
    - If a rebase conflict occurs (e.g., your local commit conflicts with a remote one), the script
      will fail for that repo and list it at the end.
    - To fix a conflict:
        1. `cd` into the failed repository.
        2. Run `git status` to see the conflicted files.
        3. Resolve the conflicts in your editor (look for `<<<`, `===`, `>>>`).
        4. Run `git add .` to stage the resolved files.
        5. Run `git rebase --continue` to finish.
        6. If you get stuck, you can always run `git rebase --abort` to cancel.
    - LLM Assistance:
        If you need help, run `git diff` on the conflicted file and ask an LLM (include the context so the AI knows what your talking about!):
        "I am resolving a git rebase conflict. Here is the file content with conflict markers.
        Please explain the difference between the upstream changes (HEAD) and my local changes, and suggest how to resolve it."
"""

import json
import os
import subprocess
import urllib.request
import urllib.error

# Configuration
ORG_NAME = "AeroBeat-Workouts"

def get_repos():
    """Fetches all public repositories for the organization."""
    repos = []
    page = 1
    per_page = 100
    
    # Optional: Use GITHUB_TOKEN if set to avoid rate limits
    token = os.environ.get("GITHUB_TOKEN")
    
    while True:
        url = f"https://api.github.com/orgs/{ORG_NAME}/repos?type=public&per_page={per_page}&page={page}"
        req = urllib.request.Request(url)
        if token:
            req.add_header("Authorization", f"Bearer {token}")
            req.add_header("Accept", "application/vnd.github.v3+json")
            
        try:
            print(f"Fetching page {page} of repositories from GitHub API...")
            with urllib.request.urlopen(req) as response:
                data = json.loads(response.read().decode())
                if not data:
                    break
                repos.extend(data)
                if len(data) < per_page:
                    break
                page += 1
        except urllib.error.HTTPError as e:
            print(f"Error fetching repos: {e}")
            break
        except Exception as e:
            print(f"An error occurred: {e}")
            break
            
    return repos

def sync_repo(repo, root_dir):
    """Clones or pulls the repository. Returns True if successful."""
    name = repo["name"]
    clone_url = repo["clone_url"]
    repo_path = os.path.join(root_dir, name)
    success = True

    print(f"\n[{name}]")

    if os.path.isdir(repo_path):
        # Check if it's a git repo before attempting git operations
        if os.path.isdir(os.path.join(repo_path, ".git")):
            try:
                # Fetch all remotes and prune deleted branches first
                subprocess.run(["git", "-C", repo_path, "fetch", "--all", "--prune"], check=True)
                # Then pull the current branch using rebase and autostash
                subprocess.run(["git", "-C", repo_path, "pull", "--rebase", "--autostash"], check=True)
            except subprocess.CalledProcessError:
                print(f"  ! Failed to pull {name}")
                success = False
        else:
            print(f"  ! Directory exists but is not a git repository. Skipping.")
            success = False
    else:
        try:
            subprocess.run(["git", "clone", clone_url, repo_path], check=True)
        except subprocess.CalledProcessError:
            print(f"  ! Failed to clone {name}")
            success = False
    return success

def main():
    # Determine the 'Town' root directory (parent of aerobeat-docs)
    # Script location: aerobeat-docs/scripts/sync_polyrepo.py
    script_dir = os.path.dirname(os.path.abspath(__file__))
    # Go up two levels: scripts -> aerobeat-docs -> Town Root
    root_dir = os.path.abspath(os.path.join(script_dir, "..", ".."))
    
    print(f"--- AeroBeat Polyrepo Sync ---")
    print(f"Organization: {ORG_NAME}")
    print(f"Target Root:  {root_dir}")
    
    repos = get_repos()
    failed_repos = []
    for repo in repos:
        if not sync_repo(repo, root_dir):
            failed_repos.append(repo["name"])
    
    print("\nSync complete.")
    if failed_repos:
        print("\n!!! The following repositories had conflicts or errors:")
        for name in failed_repos:
            print(f"  - {name}")

if __name__ == "__main__":
    main()