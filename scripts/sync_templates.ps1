# Syncs local template folders to standalone GitHub repositories.
# Usage: .\scripts\sync_templates.ps1

# 1. CONFIGURATION
# Map the local folder name (inside /templates/) to the destination GitHub Repo URL.
# YOU MUST CREATE THESE REPOS ON GITHUB FIRST.
$TemplateMap = @{
    "assembly"      = "https://github.com/AeroBeat-Workouts/aerobeat-template-assembly.git"
    "feature"       = "https://github.com/AeroBeat-Workouts/aerobeat-template-feature.git"
    "input"         = "https://github.com/AeroBeat-Workouts/aerobeat-template-input.git"
    "ui-kit"        = "https://github.com/AeroBeat-Workouts/aerobeat-template-ui-kit.git"
    "ui-shell"      = "https://github.com/AeroBeat-Workouts/aerobeat-template-ui-shell.git"
    "asset"         = "https://github.com/AeroBeat-Workouts/aerobeat-template-asset.git"
    "skins"         = "https://github.com/AeroBeat-Workouts/aerobeat-template-skin.git"
    "avatars"       = "https://github.com/AeroBeat-Workouts/aerobeat-template-avatar.git"
    "cosmetics"     = "https://github.com/AeroBeat-Workouts/aerobeat-template-cosmetic.git"
    "environments"  = "https://github.com/AeroBeat-Workouts/aerobeat-template-environment.git"
    "tool"          = "https://github.com/AeroBeat-Workouts/aerobeat-template-tool.git"
}

# 2. EXECUTION
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$RootDir = Split-Path -Parent $ScriptDir
$TemplatesDir = Join-Path $RootDir "templates"
$CommonDir = Join-Path $TemplatesDir "_common"

foreach ($key in $TemplateMap.Keys) {
    $folderName = $key
    $remoteUrl = $TemplateMap[$key]
    $sourcePath = Join-Path $TemplatesDir $folderName

    if (-not (Test-Path $sourcePath)) {
        Write-Host "❌ Error: Folder '$folderName' not found in templates/." -ForegroundColor Red
        continue
    }

    Write-Host "🚀 Syncing '$folderName' to $remoteUrl..."

    # Create a temporary staging area to avoid messing up the main repo's git
    $tempDir = Join-Path ([IO.Path]::GetTempPath()) "aerobeat_sync_$folderName"
    if (Test-Path $tempDir) { Remove-Item $tempDir -Recurse -Force }
    New-Item -ItemType Directory -Path $tempDir | Out-Null

    # 1. Inject Common Files (LICENSE, CLA)
    if (Test-Path $CommonDir) {
        Write-Host "  + Injecting _common files..." -ForegroundColor Gray
        Copy-Item -Path "$CommonDir\*" -Destination $tempDir -Recurse -Force
    }

    # 2. Copy Template Files (Overwrites common if specific overrides exist)
    Get-ChildItem -Path $sourcePath -Force | ForEach-Object {
        $name = $_.Name
        
        # Skip local dev artifacts to speed up copy and keep repo clean
        if ($name -eq "addons" -or $name -eq "__pycache__" -or $name -eq ".DS_Store" -or $name -eq ".git") { return }

        # Copy everything else recursively
        Copy-Item -Path $_.FullName -Destination $tempDir -Recurse -Force
    }

    # 3. Cleanup Duplicates (e.g. LICENSE vs LICENSE.md)
    if ((Test-Path (Join-Path $tempDir "LICENSE.md")) -and (Test-Path (Join-Path $tempDir "LICENSE"))) {
        Remove-Item (Join-Path $tempDir "LICENSE") -Force
    }

    # Initialize temporary git repo and push
    Push-Location $tempDir
    try {
        git init -b main | Out-Null
        git add . | Out-Null
        git commit -m "Sync from aerobeat-docs source of truth" | Out-Null
        git remote add origin $remoteUrl | Out-Null
        git push -f origin main
        Write-Host "✅ Success!" -ForegroundColor Green
    } finally {
        Pop-Location
    }
}