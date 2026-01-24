<#
.SYNOPSIS
    Scans the repository for empty files (0 bytes) and empty directories.
    Useful for cleaning up artifacts left behind by AI tools or refactoring.

.DESCRIPTION
    Run this script from the root of the repository.
    It ignores the .git directory.

.EXAMPLE
    ./scripts/find_empty.ps1
#>

$ErrorActionPreference = "Stop"

$rootPath = (Get-Location).Path
$gitPath = Join-Path $rootPath ".git"
$venvPath = Join-Path $rootPath "venv"

Write-Host "Scanning for empty items in: $rootPath" -ForegroundColor Cyan
Write-Host "Ignoring: $gitPath, $venvPath" -ForegroundColor DarkGray

# 1. Find Empty Files
# We use -Force to see hidden files.
$allFiles = Get-ChildItem -Path $rootPath -Recurse -File -Force 

$emptyFiles = $allFiles | Where-Object { 
    $_.Length -eq 0 -and 
    $_.FullName -notmatch [regex]::Escape($gitPath) -and
    $_.FullName -notmatch [regex]::Escape($venvPath)
}

if ($emptyFiles.Count -gt 0) {
    Write-Host "`nFound $($emptyFiles.Count) empty files:" -ForegroundColor Yellow
    foreach ($file in $emptyFiles) {
        $relativePath = $file.FullName.Substring($rootPath.Length + 1)
        Write-Host "  [FILE] $relativePath" -ForegroundColor Red
    }

    $confirmation = Read-Host "`nDo you want to delete these files? (y/N)"
    if ($confirmation -eq 'y') {
        foreach ($file in $emptyFiles) {
            Remove-Item -Path $file.FullName -Force
            Write-Host "Deleted: $($file.Name)" -ForegroundColor DarkGray
        }
    }
} else {
    Write-Host "`nNo empty files found." -ForegroundColor Green
}

# 2. Find Empty Directories
$allDirs = Get-ChildItem -Path $rootPath -Recurse -Directory -Force | Where-Object {
    $_.FullName -notmatch [regex]::Escape($gitPath) -and
    $_.FullName -notmatch [regex]::Escape($venvPath)
}

$emptyDirs = @()

foreach ($dir in $allDirs) {
    $items = @(Get-ChildItem -Path $dir.FullName -Force)
    if ($items.Count -eq 0) {
        $emptyDirs += $dir
    }
}

if ($emptyDirs.Count -gt 0) {
    Write-Host "`nFound $($emptyDirs.Count) empty directories:" -ForegroundColor Yellow
    foreach ($dir in $emptyDirs) {
        $relativePath = $dir.FullName.Substring($rootPath.Length + 1)
        Write-Host "  [DIR]  $relativePath" -ForegroundColor Magenta
    }

    $confirmation = Read-Host "`nDo you want to delete these directories? (y/N)"
    if ($confirmation -eq 'y') {
        foreach ($dir in $emptyDirs) {
            Remove-Item -Path $dir.FullName -Force -Recurse
            Write-Host "Deleted: $($dir.Name)" -ForegroundColor DarkGray
        }
    }
} else {
    Write-Host "`nNo empty directories found." -ForegroundColor Green
}