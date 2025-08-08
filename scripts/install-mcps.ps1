# Install MCP Servers Script for Claude Code Ultimate
# This script installs and configures all MCP servers with proper Windows wrappers

Write-Host "Installing MCP Servers for Claude Code Ultimate..." -ForegroundColor Cyan

# Check if Node.js is available
if (-not (Get-Command "node" -ErrorAction SilentlyContinue)) {
    Write-Host "Error: Node.js is required but not found in PATH" -ForegroundColor Red
    Write-Host "Please install Node.js from https://nodejs.org/" -ForegroundColor Yellow
    exit 1
}

# Check if npx is available
if (-not (Get-Command "npx" -ErrorAction SilentlyContinue)) {
    Write-Host "Error: npx is required but not found in PATH" -ForegroundColor Red
    Write-Host "Please update Node.js to a version that includes npx" -ForegroundColor Yellow
    exit 1
}

# Define MCP servers to install
$mcpServers = @(
    @{name="context7"; package="@context7/mcp-server"; version="latest"},
    @{name="sequential"; package="@sequential/mcp-server"; version="latest"},
    @{name="playwright"; package="@playwright/mcp-server"; version="latest"},
    @{name="magic"; package="@magic/mcp-server"; version="latest"},
    @{name="magic-mcp"; package="@21st-dev/magic"; version="latest"},
    @{name="ref-tools-mcp"; package="ref-tools-mcp"; version="latest"},
    @{name="git-mcp"; package="git-mcp-server"; version="latest"},
    @{name="prompt-refinement"; package="claude-prompt-refinement"; version="latest"}
)

# Create logs directory if it doesn't exist
$logsDir = "$env:USERPROFILE\.claude\logs"
if (-not (Test-Path $logsDir)) {
    New-Item -Path $logsDir -ItemType Directory -Force | Out-Null
}

# Install each MCP server
foreach ($server in $mcpServers) {
    Write-Host "Installing $($server.name)..." -ForegroundColor Green
    
    try {
        # Install the package globally
        $installCmd = "npm install -g $($server.package)@$($server.version)"
        Invoke-Expression $installCmd
        
        Write-Host "✅ Successfully installed $($server.name)" -ForegroundColor Green
        
        # Test the installation (skip for some packages that may not have --version)
        if ($server.name -notin @("magic-mcp", "ref-tools-mcp", "prompt-refinement")) {
            $testCmd = "cmd /c npx $($server.package) --version"
            $result = Invoke-Expression $testCmd -ErrorAction SilentlyContinue
            
            if ($LASTEXITCODE -eq 0) {
                Write-Host "✅ $($server.name) is working correctly" -ForegroundColor Green
            } else {
                Write-Host "⚠️  $($server.name) installed but version check failed" -ForegroundColor Yellow
            }
        }
        
    } catch {
        Write-Host "❌ Failed to install $($server.name): $($_.Exception.Message)" -ForegroundColor Red
        # Continue with other servers
    }
    
    Write-Host ""
}

# Update MCP configuration with Windows wrappers
Write-Host "Updating MCP configuration with Windows wrappers..." -ForegroundColor Cyan

$mcpConfigPath = "$env:USERPROFILE\.claude\mcp_settings.json"
if (Test-Path $mcpConfigPath) {
    try {
        $mcpConfig = Get-Content $mcpConfigPath | ConvertFrom-Json
        
        # Ensure all servers have proper Windows command wrappers
        foreach ($serverName in $mcpConfig.mcpServers.PSObject.Properties.Name) {
            $server = $mcpConfig.mcpServers.$serverName
            if ($server.command -and $server.command.StartsWith("npx") -and -not $server.command.StartsWith("cmd /c")) {
                $server.command = "cmd /c $($server.command)"
                Write-Host "✅ Updated $serverName with Windows wrapper" -ForegroundColor Green
            }
        }
        
        # Save updated configuration
        $mcpConfig | ConvertTo-Json -Depth 10 | Set-Content $mcpConfigPath
        Write-Host "✅ MCP configuration updated successfully" -ForegroundColor Green
        
    } catch {
        Write-Host "⚠️  Could not update MCP configuration: $($_.Exception.Message)" -ForegroundColor Yellow
    }
} else {
    Write-Host "⚠️  MCP configuration file not found at $mcpConfigPath" -ForegroundColor Yellow
    Write-Host "Run 'claude doctor' to generate the configuration file" -ForegroundColor Yellow
}

Write-Host "MCP Server installation complete!" -ForegroundColor Cyan
Write-Host "Run '.\test-mcp.ps1' to verify all servers are working correctly." -ForegroundColor Yellow
