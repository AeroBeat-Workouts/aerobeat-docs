# Syncs local template folders to standalone GitHub repositories.
# Usage: .\scripts\sync_templates.ps1

# 1. CONFIGURATION
# Map the local folder name (inside /templates/) to the destination GitHub Repo URL.
# YOU MUST CREATE THESE REPOS ON GITHUB FIRST.
$TemplateMap = @{
    "assembly" = "https://github.com/AeroBeat-Fitness/aerobeat-template-assembly.git"
    "feature"  = "https://github.com/AeroBeat-Fitness/aerobeat-template-feature.git"
    "input"    = "https://github.com/AeroBeat-Fitness/aerobeat-template-input.git"
    "ui-kit"   = "https://github.com/AeroBeat-Fitness/aerobeat-template-ui-kit.git"
    "ui-shell" = "https://github.com/AeroBeat-Fitness/aerobeat-template-ui-shell.git"
    "asset"    = "https://github.com/AeroBeat-Fitness/aerobeat-template-asset.git"
}

# 2. EXECUTION
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$RootDir = Split-Path -Parent $ScriptDir
$TemplatesDir = Join-Path $RootDir "templates"

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

    # Copy files
    Copy-Item -Path "$sourcePath\*" -Destination $tempDir -Recurse -Force

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