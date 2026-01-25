# scripts/audit_references.ps1
# Scans the repository for legacy topology keywords and outputs a markdown-friendly list.

$Keywords = @("topology", "core", "feature", "features", "singleton", "autoload", "manager", "service", "api", "telemetry", "discord", "settings")
$TargetDirs = @("docs", "templates", "scripts")

# Get the root directory of the repo (parent of the scripts folder)
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$RootDir = Split-Path -Parent $ScriptDir

$FoundFiles = @()

Write-Host "Auditing codebase for legacy references..." -ForegroundColor Cyan

foreach ($dir in $TargetDirs) {
    $path = Join-Path $RootDir $dir
    if (Test-Path $path) {
        # Get all files recursively
        $files = Get-ChildItem -Path $path -Recurse -File
        
        foreach ($file in $files) {
            # Skip .git directory or other hidden folders
            if ($file.FullName.Contains(".git")) { continue }
            
            try {
                # Read file content
                $content = Get-Content -Path $file.FullName -Raw -ErrorAction SilentlyContinue
                
                if ($null -ne $content) {
                    foreach ($kw in $Keywords) {
                        # Case-insensitive match
                        if ($content -match $kw) {
                            # Get relative path from root and normalize slashes
                            $relPath = $file.FullName.Substring($RootDir.Length + 1)
                            $relPath = $relPath.Replace('\', '/')
                            $FoundFiles += $relPath
                            break # Stop checking keywords for this file, it's already flagged
                        }
                    }
                }
            } catch {
                Write-Warning "Could not read file: $($file.FullName)"
            }
        }
    }
}

# Output unique files in the requested format
$FoundFiles | Select-Object -Unique | Sort-Object | ForEach-Object {
    $val = $_
    # Construct string at runtime to avoid parser issues with backticks
    Write-Host ("- " + [char]96 + $val + [char]96)
}

Write-Host ""
Write-Host "Audit Complete. Copy the list above into plan.md" -ForegroundColor Green