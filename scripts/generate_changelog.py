import json
import os
import urllib.request
import urllib.error

# Configuration
REPO = "AeroBeat-Fitness/aerobeat-assembly" # The main game client
OUTPUT_FILE = "docs/releases/changelog.md"

def main():
    print(f"Fetching releases for {REPO}...")
    url = f"https://api.github.com/repos/{REPO}/releases"
    
    req = urllib.request.Request(url)
    token = os.environ.get("GITHUB_TOKEN")
    if token:
        req.add_header("Authorization", f"Bearer {token}")
        
    try:
        with urllib.request.urlopen(req) as response:
            data = json.loads(response.read().decode())
    except urllib.error.HTTPError as e:
        print(f"Error fetching releases: {e}")
        return
    except Exception as e:
        print(f"An error occurred: {e}")
        return

    # Ensure directory exists
    os.makedirs(os.path.dirname(OUTPUT_FILE), exist_ok=True)

    with open(OUTPUT_FILE, "w", encoding="utf-8") as f:
        f.write("# Release Notes\n\n")
        f.write(f"Latest updates for **{REPO}**.\n\n")
        
        stable_releases = []
        beta_releases = []

        for release in data:
            if release.get("draft"):
                continue
            if release.get("prerelease"):
                beta_releases.append(release)
            else:
                stable_releases.append(release)

        if not stable_releases and not beta_releases:
            f.write("_No releases found._\n")
            return

        if stable_releases:
            latest = stable_releases[0]
            version = latest.get("tag_name", "Latest")
            url = latest.get("html_url", "")
            f.write(f"[:material-download: Download Latest Stable ({version})]({url}){{ .md-button .md-button--primary }} ")
            f.write(f"[:material-bug: Report Bug](https://github.com/{REPO}/issues/new){{ .md-button }}\n\n")

        f.write("??? note \"Table of Contents\"\n    [TOC]\n\n")

        def write_releases(releases):
            for release in releases:
                name = release.get("name") or release.get("tag_name")
                date = release.get("published_at", "")[:10] # YYYY-MM-DD
                body = release.get("body", "").replace("\r\n", "\n")
                link = release.get("html_url", "")
                
                f.write(f"### [{name}]({link})\n")
                f.write(f"**{date}**\n\n")
                f.write(f"{body}\n\n")
                f.write("---\n\n")

        if stable_releases:
            f.write("## Stable Releases\n\n")
            write_releases(stable_releases)

        if beta_releases:
            f.write("## Beta / Pre-Releases\n\n")
            write_releases(beta_releases)
    
    print(f"Successfully generated {OUTPUT_FILE}")

if __name__ == "__main__":
    main()