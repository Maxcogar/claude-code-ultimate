# Troubleshooting Guide - Claude Code Ultimate

Solutions to common issues when setting up and using your Claude Code Ultimate environment.

## 🚨 Common Issues

### MCP Server Issues

#### ❌ Problem: `claude doctor` shows MCP server warnings
```
⚠️ MCP server 'context7' configuration issue
⚠️ MCP server 'sequential' not responding
```

**✅ Solution**: Update to Windows-compatible configuration
```powershell
# Copy the fixed configuration
copy mcp-servers\mcp-master.json $env:USERPROFILE\.claude\mcp.json

# Test the fix
claude doctor
```

**Root Cause**: Windows requires `cmd /c` wrapper for npm commands

---

#### ❌ Problem: "Package not found" errors
```
npx -y @context7/mcp-server --help
# Error: Could not determine executable to run for @context7/mcp-server
```

**✅ Solution**: Install missing packages
```powershell
# Install core packages
npm install -g @context7/mcp-server
npm install -g @sequential/mcp-server
npm install -g @playwright/mcp-server
npm install -g @magic/mcp-server

# Install specialized packages
npm install -g @21st-dev/magic
npm install -g ref-tools-mcp
```

---

#### ❌ Problem: Python MCP servers fail
```
❌ freecad-mcp: Directory not found
❌ fusion-mcp-server: Python import issues
```

**✅ Solution**: Set up Python servers
```powershell
# Check if directories exist
Test-Path "C:\Users\maxco\freecad-mcp"
Test-Path "C:\Users\maxco\Fusion-MCP-Server"

# Install dependencies if directories exist
cd "C:\Users\maxco\freecad-mcp"
pip install -r requirements.txt

cd "C:\Users\maxco\Fusion-MCP-Server" 
pip install -r requirements.txt
```

### Setup Script Issues

#### ❌ Problem: "Execution policy" error
```
PowerShell execution of scripts is disabled on this system
```

**✅ Solution**: Enable script execution
```powershell
# Temporarily allow scripts
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# Run the setup
.\scripts\setup.ps1

# Reset policy (optional)
Set-ExecutionPolicy -ExecutionPolicy Restricted -Scope CurrentUser
```

---

#### ❌ Problem: Setup script fails with "Path not found"
```
Cannot find path 'C:\Users\maxco\.claude' because it does not exist
```

**✅ Solution**: Install Claude Code first
1. Install Claude Code from official source
2. Run it at least once to create the configuration directory
3. Then run the setup script

### SuperClaude Integration Issues

#### ❌ Problem: SuperClaude agents not found
```
❌ Agent 'meta_agent' not found
```

**✅ Solution**: Check SuperClaude installation
```powershell
# Check if SuperClaude is installed
Test-Path $env:USERPROFILE\.claude\.superclaude-metadata.json

# If not found, install SuperClaude first
# Then run setup again to enhance it
.\scripts\setup.ps1
```

### Node.js and npm Issues

#### ❌ Problem: "node is not recognized"
```
'node' is not recognized as an internal or external command
```

**✅ Solution**: Install Node.js
1. Download from https://nodejs.org/
2. Install with "Add to PATH" option checked
3. Restart PowerShell
4. Verify: `node --version`

---

#### ❌ Problem: npm permission errors
```
EACCES: permission denied, mkdir 'C:\Users\...\npm'
```

**✅ Solution**: Fix npm permissions
```powershell
# Set npm prefix to user directory
npm config set prefix $env:USERPROFILE\.npm-global

# Add to PATH permanently
$env:PATH += ";$env:USERPROFILE\.npm-global"
```

## 🔧 Diagnostic Commands

### Quick Health Check
```powershell
# Test everything quickly
.\scripts\test-mcp.ps1 -Verbose
claude doctor
```

### Detailed Diagnostics
```powershell
# Check Node.js setup
node --version
npm --version

# Check Python setup (for CAD servers)
python --version
pip --version

# Check Claude Code
claude --help

# List installed npm packages
npm list -g --depth=0
```

### Reset Everything
```powershell
# Nuclear option: completely reset
.\scripts\backup.ps1 -Description "Before reset"
.\scripts\setup.ps1 -Force
```

## 🛠 Manual Fixes

### Manually Fix MCP Configuration
If the automated setup fails:

1. **Backup current config**:
   ```powershell
   copy $env:USERPROFILE\.claude\mcp.json $env:USERPROFILE\.claude\mcp.json.backup
   ```

2. **Copy master config**:
   ```powershell
   copy mcp-servers\mcp-master.json $env:USERPROFILE\.claude\mcp.json
   ```

3. **Test the fix**:
   ```powershell
   claude doctor
   ```

### Manually Install MCP Servers
```powershell
# Core servers (required)
npm install -g @context7/mcp-server
npm install -g @sequential/mcp-server  
npm install -g @playwright/mcp-server
npm install -g @magic/mcp-server

# Test installation
npx -y @context7/mcp-server --help
npx -y @sequential/mcp-server --help
```

## 🔍 Debugging Tips

### Check Logs
```powershell
# Claude Code logs
ls $env:USERPROFILE\.claude\logs\ | sort LastWriteTime -Descending

# View latest log
Get-Content $env:USERPROFILE\.claude\logs\claude-latest.log -Tail 50
```

### Test Individual Components
```powershell
# Test MCP servers individually
.\scripts\test-mcp.ps1 -Server context7 -Verbose

# Test SuperClaude
claude /agents_list

# Test specific functionality
claude "Test basic functionality"
```

### Environment Verification
```powershell
# Check environment variables
echo $env:PATH
echo $env:USERPROFILE
echo $env:NODE_PATH

# Check Claude Code installation
where.exe claude
claude --version
```

## 🚑 Emergency Recovery

### Restore from Backup
```powershell
# List available backups
ls $env:USERPROFILE\.claude\backups\

# Restore specific backup
$backupPath = "$env:USERPROFILE\.claude\backups\setup-backup-20240807-143022"
& "$backupPath\restore.ps1"
```

### Complete Reset
```powershell
# Backup everything first
.\scripts\backup.ps1 -Description "Emergency backup"

# Reset to fresh state
Remove-Item $env:USERPROFILE\.claude\* -Recurse -Force -Exclude backups
.\scripts\setup.ps1
```

### Reinstall Everything
```powershell
# Uninstall global npm packages
npm uninstall -g @context7/mcp-server @sequential/mcp-server @playwright/mcp-server @magic/mcp-server @21st-dev/magic ref-tools-mcp

# Clear npm cache
npm cache clean --force

# Reinstall
npm install -g @context7/mcp-server @sequential/mcp-server @playwright/mcp-server @magic/mcp-server

# Run setup
.\scripts\setup.ps1
```

## 📞 Getting Help

### Self-Help Resources
1. **Read the documentation**: Check `docs/` folder
2. **Run diagnostics**: Use test scripts with `-Verbose`
3. **Check logs**: Review Claude Code logs
4. **Search issues**: Look for similar problems

### Information to Collect
When reporting issues, include:

```powershell
# System information
systeminfo | findstr /B /C:"OS Name" /C:"OS Version"

# Node.js information
node --version
npm --version

# Python information (if relevant)
python --version

# Claude Code information
claude --version
claude doctor

# MCP server test results
.\scripts\test-mcp.ps1 -Verbose
```

### Creating Support Requests
Include this diagnostic information:
- Operating System version
- Node.js and npm versions
- Python version (if using CAD servers)
- Claude Code version
- Complete error messages
- What you were trying to do
- What happened vs what you expected

## 🎯 Prevention Tips

### Regular Maintenance
```powershell
# Weekly health check
.\scripts\test-mcp.ps1
claude doctor

# Monthly updates
npm update -g
git pull  # if using git version
.\scripts\setup.ps1
```

### Best Practices
- **Always backup** before major changes
- **Test after updates** to catch issues early  
- **Keep logs** of any custom modifications
- **Document changes** you make to the setup

---

**🛟 Remember**: Most issues are configuration problems that can be fixed by running the setup script with `-Force` option!