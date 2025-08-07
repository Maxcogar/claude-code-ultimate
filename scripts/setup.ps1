# Claude Code Ultimate Setup Script
# Installs and configures the ultimate Claude Code development environment

param(
    [switch]$SkipBackup,
    [switch]$Force,
    [string]$BackupPath = "$env:USERPROFILE\.claude\backups\setup-backup-$(Get-Date -Format 'yyyyMMdd-HHmmss')"
)

Write-Host "🚀 Claude Code Ultimate Setup" -ForegroundColor Cyan
Write-Host "Setting up your ultimate development environment..." -ForegroundColor Green

# Check if Claude Code is installed
$claudeConfigPath = "$env:USERPROFILE\.claude"
if (-not (Test-Path $claudeConfigPath)) {
    Write-Error "Claude Code not found. Please install Claude Code first."
    exit 1
}

Write-Host "📁 Found existing Claude Code setup at: $claudeConfigPath" -ForegroundColor Green

# Create backup if requested
if (-not $SkipBackup) {
    Write-Host "💾 Creating backup..." -ForegroundColor Yellow
    New-Item -ItemType Directory -Path $BackupPath -Force | Out-Null
    Copy-Item "$claudeConfigPath\*" -Destination $BackupPath -Recurse -Force
    Write-Host "✅ Backup created at: $BackupPath" -ForegroundColor Green
}

# Get the script directory (where setup.ps1 is located)
$setupDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$repoRoot = Split-Path -Parent $setupDir

Write-Host "📦 Repository root: $repoRoot" -ForegroundColor Cyan

# Update MCP configuration with Windows-compatible wrappers
Write-Host "🔧 Updating MCP server configuration..." -ForegroundColor Yellow

$mcpMasterPath = Join-Path $repoRoot "mcp-servers\mcp-master.json"
$claudeMcpPath = Join-Path $claudeConfigPath "mcp.json"

if (Test-Path $mcpMasterPath) {
    Copy-Item $mcpMasterPath -Destination $claudeMcpPath -Force
    Write-Host "✅ MCP configuration updated with Windows wrappers" -ForegroundColor Green
} else {
    Write-Warning "⚠️ Master MCP configuration not found at: $mcpMasterPath"
}

# Preserve existing SuperClaude setup but enhance it
Write-Host "🤖 Checking SuperClaude integration..." -ForegroundColor Yellow

$scMetadataPath = Join-Path $claudeConfigPath ".superclaude-metadata.json"
if (Test-Path $scMetadataPath) {
    Write-Host "✅ SuperClaude already installed" -ForegroundColor Green
    
    # Copy enhanced agents and commands if they don't exist
    $repoScPath = Join-Path $repoRoot "superclaude"
    $claudeScPath = $claudeConfigPath
    
    # Only copy if repo versions are newer or don't exist in claude config
    Get-ChildItem "$repoScPath\agents\*" -File | ForEach-Object {
        $targetPath = Join-Path "$claudeScPath\agents" $_.Name
        if (-not (Test-Path $targetPath) -or (Get-Item $_).LastWriteTime -gt (Get-Item $targetPath).LastWriteTime) {
            Copy-Item $_.FullName -Destination $targetPath -Force
            Write-Host "📋 Updated agent: $($_.Name)" -ForegroundColor Cyan
        }
    }
    
    Get-ChildItem "$repoScPath\commands\*" -File -Recurse | ForEach-Object {
        $relativePath = $_.FullName.Substring($repoScPath.Length + 1)
        $targetPath = Join-Path $claudeScPath $relativePath
        $targetDir = Split-Path -Parent $targetPath
        
        if (-not (Test-Path $targetDir)) {
            New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
        }
        
        if (-not (Test-Path $targetPath) -or (Get-Item $_).LastWriteTime -gt (Get-Item $targetPath).LastWriteTime) {
            Copy-Item $_.FullName -Destination $targetPath -Force
            Write-Host "⚡ Updated command: $relativePath" -ForegroundColor Cyan
        }
    }
} else {
    Write-Host "📥 SuperClaude not installed. Skipping enhancement." -ForegroundColor Yellow
    Write-Host "💡 Install SuperClaude first, then run this setup again." -ForegroundColor Cyan
}

# Check Node.js and required packages
Write-Host "🔍 Checking dependencies..." -ForegroundColor Yellow

try {
    $nodeVersion = & node --version 2>$null
    Write-Host "✅ Node.js found: $nodeVersion" -ForegroundColor Green
} catch {
    Write-Warning "⚠️ Node.js not found. Please install Node.js first."
}

try {
    $npmVersion = & npm --version 2>$null
    Write-Host "✅ npm found: $npmVersion" -ForegroundColor Green
} catch {
    Write-Warning "⚠️ npm not found. Please install npm first."
}

# Test MCP servers
Write-Host "🧪 Testing MCP server configurations..." -ForegroundColor Yellow

$mcpConfig = Get-Content $claudeMcpPath | ConvertFrom-Json
$workingServers = @()
$failedServers = @()

foreach ($serverName in $mcpConfig.mcpServers.PSObject.Properties.Name) {
    $server = $mcpConfig.mcpServers.$serverName
    Write-Host "  Testing $serverName..." -ForegroundColor Gray
    
    try {
        if ($server.command -eq "cmd" -and $server.args[2] -eq "npx") {
            # Test npx package availability
            $package = $server.args[4]
            $testResult = & npm list -g $package 2>$null
            if ($LASTEXITCODE -eq 0 -or $package -match "@") {
                $workingServers += $serverName
                Write-Host "  ✅ $serverName ready" -ForegroundColor Green
            } else {
                $failedServers += $serverName
                Write-Host "  ⚠️ $serverName needs package: $package" -ForegroundColor Yellow
            }
        } elseif ($server.command -eq "cmd" -and $server.args[2] -eq "python") {
            # Test Python-based MCP servers
            if ($server.cwd -and (Test-Path $server.cwd)) {
                $workingServers += $serverName
                Write-Host "  ✅ $serverName ready" -ForegroundColor Green
            } else {
                $failedServers += $serverName
                Write-Host "  ⚠️ $serverName path not found: $($server.cwd)" -ForegroundColor Yellow
            }
        } else {
            $workingServers += $serverName
            Write-Host "  ✅ $serverName configured" -ForegroundColor Green
        }
    } catch {
        $failedServers += $serverName
        Write-Host "  ❌ $serverName failed: $($_.Exception.Message)" -ForegroundColor Red
    }
}

# Summary
Write-Host "`n🎉 Setup Complete!" -ForegroundColor Cyan
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan

Write-Host "📊 Status Summary:" -ForegroundColor White
Write-Host "  • Working MCP servers: $($workingServers.Count)" -ForegroundColor Green
Write-Host "  • Servers needing attention: $($failedServers.Count)" -ForegroundColor Yellow

if ($workingServers.Count -gt 0) {
    Write-Host "`n✅ Working servers:" -ForegroundColor Green
    $workingServers | ForEach-Object { Write-Host "  • $_" -ForegroundColor Green }
}

if ($failedServers.Count -gt 0) {
    Write-Host "`n⚠️ Servers needing attention:" -ForegroundColor Yellow
    $failedServers | ForEach-Object { Write-Host "  • $_" -ForegroundColor Yellow }
}

Write-Host "`n🚀 Next Steps:" -ForegroundColor Cyan
Write-Host "  1. Run 'claude doctor' to verify the setup" -ForegroundColor White
Write-Host "  2. Install missing npm packages if needed" -ForegroundColor White
Write-Host "  3. Test Claude Code with your new setup" -ForegroundColor White
Write-Host "  4. Explore specialized MCP servers in mcp-servers/specialized/" -ForegroundColor White

Write-Host "`n💡 Pro Tips:" -ForegroundColor Cyan
Write-Host "  • Use 'claude -h' to see all available commands" -ForegroundColor White
Write-Host "  • Check the templates/ folder for project starters" -ForegroundColor White
Write-Host "  • Your original setup is backed up at: $BackupPath" -ForegroundColor White

Write-Host "`n🎯 Happy coding with your ultimate Claude Code setup!" -ForegroundColor Green