# Sync Configuration Script for Claude Code Ultimate
# This script synchronizes configurations across the Claude Code Ultimate setup

Write-Host "Synchronizing Claude Code Ultimate Configuration..." -ForegroundColor Cyan

# Define paths
$claudeDir = "$env:USERPROFILE\.claude"
$ultimateDir = (Get-Location).Path
$configsDir = "$ultimateDir\configs"
$mcpServersDir = "$ultimateDir\mcp-servers"
$extensionsDir = "$ultimateDir\extensions"

# Function to backup existing files
function Backup-File {
    param([string]$FilePath)
    
    if (Test-Path $FilePath) {
        $backupPath = "$FilePath.backup.$(Get-Date -Format 'yyyyMMdd-HHmmss')"
        Copy-Item $FilePath $backupPath
        Write-Host "✅ Backed up $FilePath to $backupPath" -ForegroundColor Green
        return $backupPath
    }
    return $null
}

# Function to sync file with backup
function Sync-File {
    param([string]$SourcePath, [string]$DestPath, [string]$Description)
    
    if (Test-Path $SourcePath) {
        # Backup existing file
        $backup = Backup-File -FilePath $DestPath
        
        # Copy new file
        $destDir = Split-Path $DestPath -Parent
        if (-not (Test-Path $destDir)) {
            New-Item -Path $destDir -ItemType Directory -Force | Out-Null
        }
        
        Copy-Item $SourcePath $DestPath -Force
        Write-Host "✅ Synced $Description" -ForegroundColor Green
    } else {
        Write-Host "⚠️  Source file not found: $SourcePath" -ForegroundColor Yellow
    }
}

Write-Host "Starting configuration synchronization..." -ForegroundColor Yellow

# 1. Sync main Claude configuration
Write-Host "\n1. Syncing main Claude configuration..." -ForegroundColor Cyan
Sync-File "$configsDir\.claude.json" "$claudeDir\.claude.json" "main Claude configuration"

# 2. Sync global settings
Write-Host "\n2. Syncing global settings..." -ForegroundColor Cyan
Sync-File "$configsDir\settings.json" "$claudeDir\settings.json" "global settings"

# 3. Sync hooks configuration
Write-Host "\n3. Syncing hooks configuration..." -ForegroundColor Cyan
Sync-File "$configsDir\hooks.json" "$claudeDir\hooks.json" "global hooks"

# 4. Sync workspace defaults
Write-Host "\n4. Syncing workspace defaults..." -ForegroundColor Cyan
Sync-File "$configsDir\workspace-defaults.json" "$claudeDir\workspace-defaults.json" "workspace defaults"

# 5. Sync MCP server configurations
Write-Host "\n5. Syncing MCP server configurations..." -ForegroundColor Cyan

# Check if master MCP config exists
$masterMcpConfig = "$mcpServersDir\mcp-master.json"
if (Test-Path $masterMcpConfig) {
    Sync-File $masterMcpConfig "$claudeDir\mcp_settings.json" "MCP server configuration"
} else {
    Write-Host "⚠️  Master MCP configuration not found at $masterMcpConfig" -ForegroundColor Yellow
}

# 6. Create symlinks for extensions (if they don't exist)
Write-Host "\n6. Setting up extension links..." -ForegroundColor Cyan

$claudeExtensionsDir = "$claudeDir\extensions"
if (-not (Test-Path $claudeExtensionsDir)) {
    New-Item -Path $claudeExtensionsDir -ItemType Directory -Force | Out-Null
}

$extensions = @("bmad-method", "superdesign", "claudecode-rule2hook", "prompt-refinement")
foreach ($extension in $extensions) {
    $sourcePath = "$extensionsDir\$extension"
    $linkPath = "$claudeExtensionsDir\$extension"
    
    if ((Test-Path $sourcePath) -and (-not (Test-Path $linkPath))) {
        try {
            # Try to create symbolic link (requires admin privileges)
            New-Item -Path $linkPath -ItemType SymbolicLink -Value $sourcePath -Force | Out-Null
            Write-Host "✅ Created symbolic link for $extension" -ForegroundColor Green
        } catch {
            # Fallback to copying directory
            Copy-Item $sourcePath $linkPath -Recurse -Force
            Write-Host "✅ Copied $extension extension (symbolic link failed)" -ForegroundColor Yellow
        }
    } elseif (Test-Path $linkPath) {
        Write-Host "✅ $extension extension already linked" -ForegroundColor Green
    } else {
        Write-Host "⚠️  $extension extension source not found" -ForegroundColor Yellow
    }
}

# 7. Validate configuration
Write-Host "\n7. Validating configuration..." -ForegroundColor Cyan

# Check if Claude Code can find the configurations
if (Get-Command "claude" -ErrorAction SilentlyContinue) {
    Write-Host "Running 'claude doctor' to validate setup..." -ForegroundColor Yellow
    try {
        $doctorOutput = claude doctor 2>&1
        if ($LASTEXITCODE -eq 0) {
            Write-Host "✅ Claude Code configuration is valid" -ForegroundColor Green
        } else {
            Write-Host "⚠️  Claude doctor found issues:" -ForegroundColor Yellow
            Write-Host $doctorOutput -ForegroundColor Yellow
        }
    } catch {
        Write-Host "⚠️  Could not run claude doctor: $($_.Exception.Message)" -ForegroundColor Yellow
    }
} else {
    Write-Host "⚠️  Claude Code CLI not found in PATH" -ForegroundColor Yellow
    Write-Host "Please install Claude Code CLI to validate the configuration" -ForegroundColor Yellow
}

# 8. Summary
Write-Host "\n" + ("="*60) -ForegroundColor Cyan
Write-Host "Configuration Synchronization Complete!" -ForegroundColor Green
Write-Host ("="*60) -ForegroundColor Cyan

Write-Host "\nNext Steps:" -ForegroundColor Yellow
Write-Host "1. Run 'claude doctor' to verify all configurations" -ForegroundColor White
Write-Host "2. Test MCP servers with '.\test-mcp.ps1'" -ForegroundColor White
Write-Host "3. Initialize a new project to test the full setup" -ForegroundColor White

Write-Host "\nBackup files created with timestamp in case you need to restore" -ForegroundColor Gray