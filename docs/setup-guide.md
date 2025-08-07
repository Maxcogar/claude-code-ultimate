# Setup Guide - Claude Code Ultimate

Complete step-by-step guide to set up your ultimate Claude Code development environment.

## 📋 Prerequisites

Before starting, ensure you have:
- **Windows 10/11** (this setup is optimized for Windows)
- **Node.js >= 18.0.0** ([Download here](https://nodejs.org/))
- **npm >= 9.0.0** (comes with Node.js)
- **Python >= 3.8** (for CAD integrations)
- **Claude Code** installed and working
- **Git** for version control

## 🚀 Quick Start (5 minutes)

### Option 1: Clone and Auto-Setup
```powershell
# 1. Clone the repository
git clone https://github.com/maxco/claude-code-ultimate.git
cd claude-code-ultimate

# 2. Run automated setup
.\scripts\setup.ps1

# 3. Test the configuration
claude doctor
```

### Option 2: Download and Setup
1. Download the repository as ZIP
2. Extract to your desired location
3. Open PowerShell in the extracted folder
4. Run `.\scripts\setup.ps1`

## 🔧 Manual Setup (15 minutes)

If you prefer to understand each step:

### Step 1: Backup Current Setup
```powershell
# Create backup directory
mkdir $env:USERPROFILE\.claude\backups\manual-backup-$(Get-Date -Format 'yyyyMMdd-HHmmss')

# Backup current configuration
copy $env:USERPROFILE\.claude\*.* $env:USERPROFILE\.claude\backups\manual-backup-$(Get-Date -Format 'yyyyMMdd-HHmmss')\
```

### Step 2: Update MCP Configuration
```powershell
# Copy the master MCP configuration with Windows wrappers
copy mcp-servers\mcp-master.json $env:USERPROFILE\.claude\mcp.json
```

### Step 3: Install Required npm Packages
```powershell
# Core MCP servers (always install these)
npm install -g @context7/mcp-server
npm install -g @sequential/mcp-server
npm install -g @playwright/mcp-server
npm install -g @magic/mcp-server

# Specialized servers (install as needed)
npm install -g @21st-dev/magic
npm install -g ref-tools-mcp
```

### Step 4: Enhance SuperClaude (if installed)
```powershell
# Check if SuperClaude is installed
if (Test-Path $env:USERPROFILE\.claude\.superclaude-metadata.json) {
    # Copy enhanced agents and commands
    copy superclaude\agents\* $env:USERPROFILE\.claude\agents\
    copy superclaude\commands\* $env:USERPROFILE\.claude\commands\ -Recurse
    Write-Host "✅ SuperClaude enhanced"
} else {
    Write-Host "ℹ️ SuperClaude not found - install it first if desired"
}
```

### Step 5: Test Configuration
```powershell
# Test MCP servers
.\scripts\test-mcp.ps1 -Verbose

# Test Claude Code integration
claude doctor
```

## 🎯 Project-Specific Setup

### For Web Development Projects
Add these specialized servers:
```powershell
# Enhanced UI generation
npm install -g @21st-dev/magic

# Documentation tools  
npm install -g ref-tools-mcp
```

Update your MCP config:
```json
{
  "mcpServers": {
    // ... core servers
    "magic-mcp": {
      "command": "cmd",
      "args": ["/c", "npx", "-y", "@21st-dev/magic"],
      "env": {}
    },
    "ref-tools-mcp": {
      "command": "cmd",
      "args": ["/c", "npx", "-y", "ref-tools-mcp"],
      "env": {}
    }
  }
}
```

### For CAD/Engineering Projects
Set up Python-based MCP servers:

1. **FreeCAD Integration**:
   ```powershell
   # Make sure freecad-mcp is at C:\Users\maxco\freecad-mcp
   cd C:\Users\maxco\freecad-mcp
   pip install -r requirements.txt
   ```

2. **Fusion 360 Integration**:
   ```powershell
   # Make sure Fusion-MCP-Server is at C:\Users\maxco\Fusion-MCP-Server
   cd C:\Users\maxco\Fusion-MCP-Server
   pip install -r requirements.txt
   ```

3. **Update MCP config** with the configurations from `mcp-servers/specialized/`

## 🛠 Advanced Configuration

### Custom MCP Server Selection
Instead of loading all servers, customize your setup:

1. **Start with core servers only**:
   ```powershell
   copy mcp-servers\core\*.json temp\
   # Combine only the servers you want into mcp.json
   ```

2. **Add specialized servers as needed**:
   ```powershell
   # Copy specific server configs
   copy mcp-servers\specialized\magic-mcp.json temp\
   # Merge into your mcp.json
   ```

### Extension Setup
Currently the extensions are placeholders. To set them up:

1. **BMad-Method**:
   ```powershell
   cd extensions\bmad-method
   # Follow setup instructions in README.md
   ```

2. **Superdesign**:
   ```powershell
   cd extensions\superdesign
   # Follow setup instructions in README.md
   ```

3. **Rule2Hook**:
   ```powershell
   cd extensions\claudecode-rule2hook
   # Follow setup instructions in README.md
   ```

## 🧪 Verification Steps

### 1. Test MCP Servers
```powershell
# Run comprehensive tests
.\scripts\test-mcp.ps1 -Verbose

# Test individual servers
npx -y @context7/mcp-server --help
npx -y @sequential/mcp-server --help
```

### 2. Test Claude Code Integration
```powershell
# Full system check
claude doctor

# Test a simple command
claude --help
```

### 3. Test SuperClaude (if installed)
```powershell
# List available agents
claude /agents_list

# Test an agent
claude /sc analyze "Test project analysis"
```

## 🎨 Project Templates

Use the included templates for new projects:

### Web App Template
```powershell
# Copy template to new project
copy templates\web-app C:\your-projects\my-new-app -Recurse
cd C:\your-projects\my-new-app
# Follow template README.md
```

### IoT Project Template
```powershell
# Copy template for IoT development
copy templates\iot-project C:\your-projects\my-iot-project -Recurse
cd C:\your-projects\my-iot-project
# Follow template README.md  
```

### Fusion360 Addon Template
```powershell
# Copy template for Fusion 360 development
copy templates\fusion360-addon C:\your-projects\my-fusion-addon -Recurse
cd C:\your-projects\my-fusion-addon
# Follow template README.md
```

## 📚 Next Steps

After setup is complete:

1. **Read the Documentation**:
   - `docs/mcp-guide.md` - Understand your MCP servers
   - `docs/troubleshooting.md` - Fix common issues
   - `docs/extensions-guide.md` - Set up extensions (when ready)

2. **Start a Project**:
   - Use project templates as starting points
   - Test different MCP servers with your workflows
   - Explore SuperClaude agents for automation

3. **Customize Your Setup**:
   - Add/remove MCP servers based on your needs
   - Create custom agents for your specific workflows  
   - Set up extensions for enhanced functionality

## 🆘 Getting Help

If you run into issues:

1. **Check the logs**:
   ```powershell
   # View recent Claude Code logs
   ls $env:USERPROFILE\.claude\logs\ | sort LastWriteTime -Descending | select -First 5
   ```

2. **Run diagnostics**:
   ```powershell
   .\scripts\test-mcp.ps1 -Verbose
   claude doctor
   ```

3. **Review troubleshooting guide**: See `docs/troubleshooting.md`

4. **Reset if needed**:
   ```powershell
   .\scripts\setup.ps1 -Force
   ```

---

**🎉 Congratulations!** You now have the ultimate Claude Code development environment ready to tackle any project!