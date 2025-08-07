# Backup Script for Claude Code Ultimate Setup
# Creates comprehensive backups of your Claude Code configuration

param(
    [string]$BackupPath = "",
    [switch]$IncludeProjects,
    [switch]$Compress,
    [string]$Description = ""
)

# Set default backup path if not provided
if (-not $BackupPath) {
    $timestamp = Get-Date -Format 'yyyyMMdd-HHmmss'
    $BackupPath = "$env:USERPROFILE\.claude\backups\manual-backup-$timestamp"
}

Write-Host "💾 Claude Code Ultimate Backup" -ForegroundColor Cyan
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan

$claudeConfigPath = "$env:USERPROFILE\.claude"

# Check if Claude Code is set up
if (-not (Test-Path $claudeConfigPath)) {
    Write-Error "❌ Claude Code configuration not found at: $claudeConfigPath"
    exit 1
}

Write-Host "📂 Backing up to: $BackupPath" -ForegroundColor Yellow

# Create backup directory
try {
    New-Item -ItemType Directory -Path $BackupPath -Force | Out-Null
    Write-Host "✅ Created backup directory" -ForegroundColor Green
} catch {
    Write-Error "❌ Failed to create backup directory: $($_.Exception.Message)"
    exit 1
}

# Backup core configuration files
Write-Host "`n📋 Backing up core configuration..." -ForegroundColor Yellow

$coreFiles = @(
    "mcp.json",
    "mcp.json.example", 
    "settings.json",
    "settings.local.json",
    "hooks.json",
    ".superclaude-metadata.json"
)

$backedUpFiles = 0
foreach ($file in $coreFiles) {
    $sourcePath = Join-Path $claudeConfigPath $file
    $destPath = Join-Path $BackupPath $file
    
    if (Test-Path $sourcePath) {
        try {
            Copy-Item $sourcePath -Destination $destPath -Force
            Write-Host "  ✅ $file" -ForegroundColor Green
            $backedUpFiles++
        } catch {
            Write-Host "  ❌ $file - Error: $($_.Exception.Message)" -ForegroundColor Red
        }
    } else {
        Write-Host "  ⚠️ $file - Not found" -ForegroundColor Yellow
    }
}

# Backup directories
Write-Host "`n📁 Backing up directories..." -ForegroundColor Yellow

$directories = @(
    "agents",
    "commands", 
    "backups",
    "logs"
)

if ($IncludeProjects) {
    $directories += "projects"
    Write-Host "  Including projects directory..." -ForegroundColor Cyan
}

foreach ($dir in $directories) {
    $sourcePath = Join-Path $claudeConfigPath $dir
    $destPath = Join-Path $BackupPath $dir
    
    if (Test-Path $sourcePath) {
        try {
            Copy-Item $sourcePath -Destination $destPath -Recurse -Force
            $itemCount = (Get-ChildItem $sourcePath -Recurse | Measure-Object).Count
            Write-Host "  ✅ $dir ($itemCount items)" -ForegroundColor Green
            $backedUpFiles += $itemCount
        } catch {
            Write-Host "  ❌ $dir - Error: $($_.Exception.Message)" -ForegroundColor Red
        }
    } else {
        Write-Host "  ⚠️ $dir - Not found" -ForegroundColor Yellow
    }
}

# Create backup manifest
Write-Host "`n📄 Creating backup manifest..." -ForegroundColor Yellow

$manifest = @{
    BackupDate = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    BackupPath = $BackupPath
    Description = $Description
    IncludeProjects = $IncludeProjects
    TotalFiles = $backedUpFiles
    ClaudeVersion = ""
    NodeVersion = ""
    PythonVersion = ""
    SystemInfo = @{
        OS = (Get-CimInstance Win32_OperatingSystem).Caption
        PowerShellVersion = $PSVersionTable.PSVersion.ToString()
        ComputerName = $env:COMPUTERNAME
        UserName = $env:USERNAME
    }
}

# Get version information
try {
    $manifest.NodeVersion = (& node --version 2>$null) -replace 'v', ''
} catch {
    $manifest.NodeVersion = "Not found"
}

try {
    $manifest.PythonVersion = & python --version 2>$null
} catch {
    $manifest.PythonVersion = "Not found"
}

try {
    $claudeHelp = & claude --version 2>$null
    $manifest.ClaudeVersion = $claudeHelp
} catch {
    $manifest.ClaudeVersion = "Not found"
}

# Save manifest
$manifestPath = Join-Path $BackupPath "backup-manifest.json"
try {
    $manifest | ConvertTo-Json -Depth 3 | Set-Content $manifestPath
    Write-Host "  ✅ Manifest created" -ForegroundColor Green
} catch {
    Write-Host "  ❌ Failed to create manifest: $($_.Exception.Message)" -ForegroundColor Red
}

# Create restore script
Write-Host "`n🔧 Creating restore script..." -ForegroundColor Yellow

$restoreScript = @"
# Restore script for Claude Code Ultimate backup
# Created: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")
# Backup from: $BackupPath

param(
    [switch]`$Force,
    [switch]`$KeepCurrent
)

Write-Host "🔄 Restoring Claude Code configuration..." -ForegroundColor Cyan

`$claudeConfigPath = "`$env:USERPROFILE\.claude"
`$backupPath = "`$BackupPath"

if (-not `$Force) {
    `$confirm = Read-Host "This will overwrite your current Claude Code configuration. Continue? (y/N)"
    if (`$confirm -ne 'y' -and `$confirm -ne 'Y') {
        Write-Host "❌ Restore cancelled" -ForegroundColor Red
        exit 1
    }
}

# Backup current config if requested
if (`$KeepCurrent) {
    `$currentBackupPath = "`$env:USERPROFILE\.claude\backups\pre-restore-$(Get-Date -Format 'yyyyMMdd-HHmmss')"
    Write-Host "💾 Backing up current configuration to: `$currentBackupPath" -ForegroundColor Yellow
    Copy-Item `$claudeConfigPath `$currentBackupPath -Recurse -Force
}

# Restore files
Write-Host "📂 Restoring configuration files..." -ForegroundColor Yellow

try {
    # Restore individual files
    Get-ChildItem `$backupPath -File | ForEach-Object {
        `$destPath = Join-Path `$claudeConfigPath `$_.Name
        Copy-Item `$_.FullName -Destination `$destPath -Force
        Write-Host "  ✅ `$(`$_.Name)" -ForegroundColor Green
    }
    
    # Restore directories
    Get-ChildItem `$backupPath -Directory | ForEach-Object {
        `$destPath = Join-Path `$claudeConfigPath `$_.Name
        if (Test-Path `$destPath) {
            Remove-Item `$destPath -Recurse -Force
        }
        Copy-Item `$_.FullName -Destination `$destPath -Recurse -Force
        Write-Host "  ✅ `$(`$_.Name)" -ForegroundColor Green
    }
    
    Write-Host "`n🎉 Restore completed successfully!" -ForegroundColor Green
    Write-Host "💡 Run 'claude doctor' to verify the restored configuration" -ForegroundColor Cyan
    
} catch {
    Write-Error "❌ Restore failed: `$(`$_.Exception.Message)"
    exit 1
}
"@

$restoreScriptPath = Join-Path $BackupPath "restore.ps1"
try {
    $restoreScript | Set-Content $restoreScriptPath
    Write-Host "  ✅ Restore script created" -ForegroundColor Green
} catch {
    Write-Host "  ❌ Failed to create restore script: $($_.Exception.Message)" -ForegroundColor Red
}

# Compress if requested
if ($Compress) {
    Write-Host "`n📦 Compressing backup..." -ForegroundColor Yellow
    
    $zipPath = "$BackupPath.zip"
    try {
        # Use .NET compression
        Add-Type -AssemblyName System.IO.Compression.FileSystem
        [System.IO.Compression.ZipFile]::CreateFromDirectory($BackupPath, $zipPath)
        
        # Remove original directory
        Remove-Item $BackupPath -Recurse -Force
        
        Write-Host "  ✅ Compressed to: $zipPath" -ForegroundColor Green
        $BackupPath = $zipPath
    } catch {
        Write-Host "  ❌ Compression failed: $($_.Exception.Message)" -ForegroundColor Red
    }
}

# Calculate backup size
try {
    if ($Compress) {
        $backupSize = (Get-Item $BackupPath).Length
    } else {
        $backupSize = (Get-ChildItem $BackupPath -Recurse | Measure-Object -Property Length -Sum).Sum
    }
    
    $sizeInMB = [math]::Round($backupSize / 1MB, 2)
    $sizeDisplay = if ($sizeInMB -lt 1) { "$([math]::Round($backupSize / 1KB, 2)) KB" } else { "$sizeInMB MB" }
} catch {
    $sizeDisplay = "Unknown"
}

# Summary
Write-Host "`n📊 Backup Summary" -ForegroundColor Cyan
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan

Write-Host "📂 Backup Location: $BackupPath" -ForegroundColor White
Write-Host "📄 Total Files: $backedUpFiles" -ForegroundColor White
Write-Host "💾 Backup Size: $sizeDisplay" -ForegroundColor White
Write-Host "🗓️ Created: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" -ForegroundColor White

if ($Description) {
    Write-Host "📝 Description: $Description" -ForegroundColor White
}

Write-Host "`n🔧 To restore this backup:" -ForegroundColor Cyan
if ($Compress) {
    Write-Host "  1. Extract: $BackupPath" -ForegroundColor White
    Write-Host "  2. Run: .\restore.ps1" -ForegroundColor White
} else {
    Write-Host "  1. Run: $BackupPath\restore.ps1" -ForegroundColor White
}

Write-Host "`n💡 Pro Tips:" -ForegroundColor Cyan
Write-Host "  • Regular backups help prevent configuration loss" -ForegroundColor White
Write-Host "  • Use -IncludeProjects to backup project files too" -ForegroundColor White
Write-Host "  • Use -Compress to save disk space" -ForegroundColor White
Write-Host "  • Keep multiple backups before major changes" -ForegroundColor White

Write-Host "`n🎉 Backup completed successfully!" -ForegroundColor Green
