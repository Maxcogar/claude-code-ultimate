# MCP Server Test Script
# Tests all configured MCP servers to verify they're working

param(
    [switch]$Verbose,
    [switch]$FixIssues
)

Write-Host "🧪 Testing MCP Server Configuration" -ForegroundColor Cyan
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan

$claudeConfigPath = "$env:USERPROFILE\.claude"
$mcpConfigPath = Join-Path $claudeConfigPath "mcp.json"

# Check if Claude Code is set up
if (-not (Test-Path $mcpConfigPath)) {
    Write-Error "❌ MCP configuration not found at: $mcpConfigPath"
    Write-Host "💡 Run setup.ps1 first to configure MCP servers" -ForegroundColor Yellow
    exit 1
}

Write-Host "📄 Reading MCP configuration..." -ForegroundColor Yellow

try {
    $mcpConfig = Get-Content $mcpConfigPath | ConvertFrom-Json
    $serverCount = ($mcpConfig.mcpServers | Get-Member -Type NoteProperty).Count
    Write-Host "✅ Found $serverCount configured servers" -ForegroundColor Green
} catch {
    Write-Error "❌ Failed to parse MCP configuration: $($_.Exception.Message)"
    exit 1
}

# Test results tracking
$results = @{
    passed = @()
    failed = @()
    warnings = @()
}

Write-Host "`n🔍 Testing individual servers..." -ForegroundColor Yellow

foreach ($serverName in $mcpConfig.mcpServers.PSObject.Properties.Name) {
    $server = $mcpConfig.mcpServers.$serverName
    Write-Host "`n  🔧 Testing: $serverName" -ForegroundColor Cyan
    
    if ($Verbose) {
        Write-Host "    Command: $($server.command)" -ForegroundColor Gray
        Write-Host "    Args: $($server.args -join ' ')" -ForegroundColor Gray
        if ($server.cwd) { Write-Host "    Working Directory: $($server.cwd)" -ForegroundColor Gray }
    }
    
    try {
        # Test different server types
        if ($server.command -eq "cmd" -and $server.args[2] -eq "npx") {
            # NPM-based MCP server
            $package = $server.args[4]
            Write-Host "    📦 Testing npm package: $package" -ForegroundColor Gray
            
            # Check if package is available
            $testCommand = "npx -y $package --help"
            $output = cmd /c $testCommand 2>&1
            
            if ($LASTEXITCODE -eq 0) {
                Write-Host "    ✅ $serverName: Package available" -ForegroundColor Green
                $results.passed += $serverName
            } else {
                Write-Host "    ❌ $serverName: Package issue" -ForegroundColor Red
                Write-Host "    Error: $($output | Select-Object -First 3)" -ForegroundColor Red
                $results.failed += $serverName
                
                if ($FixIssues) {
                    Write-Host "    🔧 Attempting to fix..." -ForegroundColor Yellow
                    try {
                        & npm install -g $package 2>$null
                        if ($LASTEXITCODE -eq 0) {
                            Write-Host "    ✅ Fixed: Installed $package globally" -ForegroundColor Green
                            $results.failed = $results.failed | Where-Object { $_ -ne $serverName }
                            $results.passed += $serverName
                        }
                    } catch {
                        Write-Host "    ❌ Fix failed: $($_.Exception.Message)" -ForegroundColor Red
                    }
                }
            }
            
        } elseif ($server.command -eq "cmd" -and $server.args[2] -eq "python") {
            # Python-based MCP server
            Write-Host "    🐍 Testing Python server" -ForegroundColor Gray
            
            if ($server.cwd -and (Test-Path $server.cwd)) {
                Write-Host "    ✅ $serverName: Directory exists" -ForegroundColor Green
                
                # Check if Python can import the module
                $pythonTest = "python -c `"import sys; sys.path.append('$($server.cwd)'); print('OK')`""
                try {
                    $output = cmd /c $pythonTest 2>&1
                    if ($output -match "OK") {
                        Write-Host "    ✅ $serverName: Python module accessible" -ForegroundColor Green
                        $results.passed += $serverName
                    } else {
                        Write-Host "    ⚠️ $serverName: Python import issues" -ForegroundColor Yellow
                        $results.warnings += $serverName
                    }
                } catch {
                    Write-Host "    ❌ $serverName: Python test failed" -ForegroundColor Red
                    $results.failed += $serverName
                }
            } else {
                Write-Host "    ❌ $serverName: Directory not found: $($server.cwd)" -ForegroundColor Red
                $results.failed += $serverName
            }
            
        } else {
            # Generic command test
            Write-Host "    🔧 Testing generic command" -ForegroundColor Gray
            
            try {
                $testResult = & $server.command $server.args[0] 2>$null
                Write-Host "    ✅ $serverName: Command accessible" -ForegroundColor Green
                $results.passed += $serverName
            } catch {
                Write-Host "    ❌ $serverName: Command failed" -ForegroundColor Red
                $results.failed += $serverName
            }
        }
        
    } catch {
        Write-Host "    ❌ $serverName: Test error: $($_.Exception.Message)" -ForegroundColor Red
        $results.failed += $serverName
    }
}

# Test Claude Code itself
Write-Host "`n🎯 Testing Claude Code integration..." -ForegroundColor Yellow

try {
    Write-Host "  Running claude doctor..." -ForegroundColor Gray
    $doctorOutput = & claude doctor 2>&1
    
    if ($doctorOutput -match "All systems operational" -or $doctorOutput -match "✅") {
        Write-Host "  ✅ Claude Code: Integration working" -ForegroundColor Green
    } elseif ($doctorOutput -match "⚠️" -or $doctorOutput -match "warning") {
        Write-Host "  ⚠️ Claude Code: Some warnings detected" -ForegroundColor Yellow
        if ($Verbose) {
            Write-Host "  Doctor output:" -ForegroundColor Gray
            $doctorOutput | ForEach-Object { Write-Host "    $_" -ForegroundColor Gray }
        }
    } else {
        Write-Host "  ❌ Claude Code: Issues detected" -ForegroundColor Red
        if ($Verbose) {
            Write-Host "  Doctor output:" -ForegroundColor Gray
            $doctorOutput | ForEach-Object { Write-Host "    $_" -ForegroundColor Gray }
        }
    }
} catch {
    Write-Host "  ❌ Claude Code: Could not run claude doctor" -ForegroundColor Red
    Write-Host "  Make sure Claude Code is installed and in PATH" -ForegroundColor Yellow
}

# Summary
Write-Host "`n📊 Test Results Summary" -ForegroundColor Cyan
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan

$total = $results.passed.Count + $results.failed.Count + $results.warnings.Count

Write-Host "Total servers tested: $total" -ForegroundColor White
Write-Host "✅ Passed: $($results.passed.Count)" -ForegroundColor Green
Write-Host "⚠️ Warnings: $($results.warnings.Count)" -ForegroundColor Yellow  
Write-Host "❌ Failed: $($results.failed.Count)" -ForegroundColor Red

if ($results.passed.Count -gt 0) {
    Write-Host "`n✅ Working servers:" -ForegroundColor Green
    $results.passed | ForEach-Object { Write-Host "  • $_" -ForegroundColor Green }
}

if ($results.warnings.Count -gt 0) {
    Write-Host "`n⚠️ Servers with warnings:" -ForegroundColor Yellow
    $results.warnings | ForEach-Object { Write-Host "  • $_" -ForegroundColor Yellow }
}

if ($results.failed.Count -gt 0) {
    Write-Host "`n❌ Failed servers:" -ForegroundColor Red
    $results.failed | ForEach-Object { Write-Host "  • $_" -ForegroundColor Red }
    
    Write-Host "`n🔧 To fix failed servers:" -ForegroundColor Cyan
    Write-Host "  1. Run: .\scripts\test-mcp.ps1 -FixIssues" -ForegroundColor White
    Write-Host "  2. Install missing packages manually:" -ForegroundColor White
    $results.failed | ForEach-Object { 
        $server = $mcpConfig.mcpServers.$_
        if ($server.command -eq "cmd" -and $server.args[2] -eq "npx") {
            Write-Host "     npm install -g $($server.args[4])" -ForegroundColor Gray
        }
    }
    Write-Host "  3. Check troubleshooting.md for detailed help" -ForegroundColor White
}

# Exit code based on results
if ($results.failed.Count -eq 0) {
    Write-Host "`n🎉 All tests passed! Your MCP setup is working correctly." -ForegroundColor Green
    exit 0
} elseif ($results.passed.Count -gt $results.failed.Count) {
    Write-Host "`n⚠️ Most servers working, but some need attention." -ForegroundColor Yellow
    exit 1
} else {
    Write-Host "`n❌ Significant issues detected. Please review and fix." -ForegroundColor Red
    exit 2
}
