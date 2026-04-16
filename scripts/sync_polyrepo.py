"""Synchronize AeroBeat sibling repositories into the local polyrepo root.

The script lists public repositories in the ``AeroBeat-Workouts`` GitHub
organization, then ensures each one exists as a sibling checkout next to
``aerobeat-docs``. Existing repositories are updated with
``git fetch --all --prune`` followed by ``git pull --rebase --autostash``;
missing repositories are cloned.

Set ``GITHUB_TOKEN`` to raise GitHub API rate limits when needed.
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
    # Script location: aerobeat-docs/scripts/sync_polyrepo.py
    script_dir = os.path.dirname(os.path.abspath(__file__))
    # Go up two levels: scripts -> aerobeat-docs -> polyrepo root
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