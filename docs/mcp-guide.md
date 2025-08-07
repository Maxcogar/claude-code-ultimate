# MCP Servers Guide

This guide explains all MCP servers included in your Claude Code Ultimate setup.

## 🔧 Core MCP Servers (Always Active)

These servers are loaded automatically and provide essential functionality.

### Context7 (`@context7/mcp-server`)
**Purpose**: Documentation lookup and reference management
**Usage**: Automatically provides context for coding questions
**Commands**: 
- Document search and retrieval
- Code reference lookup
- API documentation access

### Sequential (`@sequential/mcp-server`) 
**Purpose**: Sequential thinking and problem-solving
**Usage**: Breaks down complex problems into manageable steps
**Commands**:
- Step-by-step problem analysis
- Sequential workflow management
- Logic chain building

### Playwright (`@playwright/mcp-server`)
**Purpose**: Browser automation and testing
**Usage**: Automates web interactions and testing
**Commands**:
- Web scraping and automation
- UI testing and validation
- Browser-based workflows

### Magic (`@magic/mcp-server`)
**Purpose**: Current magic server for UI generation
**Usage**: Generates UI components and interfaces
**Commands**:
- UI component creation
- Interface generation
- Layout assistance

## 🎯 Specialized MCP Servers (On-Demand)

These servers are available when you need specific functionality.

### Magic-MCP (`@21st-dev/magic`)
**Purpose**: Advanced UI builder and design system
**Installation**: `npm install -g @21st-dev/magic`
**Usage**: Enhanced UI generation with design systems
**Best For**: 
- Complex UI projects
- Design system creation
- Professional web applications

**Add to MCP config**:
```json
{
  "mcpServers": {
    "magic-mcp": {
      "command": "cmd",
      "args": ["/c", "npx", "-y", "@21st-dev/magic"],
      "env": {}
    }
  }
}
```

### Ref-Tools-MCP (`ref-tools-mcp`)
**Purpose**: Reference tools and documentation assistance v3.0.0
**Installation**: `npm install -g ref-tools-mcp`
**Usage**: Advanced reference management and documentation
**Best For**:
- Technical documentation projects
- API reference management
- Code documentation generation

**Add to MCP config**:
```json
{
  "mcpServers": {
    "ref-tools-mcp": {
      "command": "cmd",
      "args": ["/c", "npx", "-y", "ref-tools-mcp"],
      "env": {}
    }
  }
}
```

### FreeCAD-MCP
**Purpose**: FreeCAD integration for parametric CAD
**Path**: `C:\\Users\\maxco\\freecad-mcp`
**Usage**: Automate FreeCAD operations and CAD workflows
**Best For**:
- 3D modeling automation
- Parametric design workflows
- CAD file processing

**Add to MCP config**:
```json
{
  "mcpServers": {
    "freecad-mcp": {
      "command": "cmd",
      "args": ["/c", "python", "-m", "freecad_mcp.server"],
      "cwd": "C:\\Users\\maxco\\freecad-mcp",
      "env": {}
    }
  }
}
```

### Fusion-MCP-Server
**Purpose**: Fusion 360 integration for professional CAD/CAM
**Path**: `C:\\Users\\maxco\\Fusion-MCP-Server`
**Usage**: Automate Fusion 360 operations and engineering workflows
**Best For**:
- Engineering design automation
- CAM workflow automation
- Fusion 360 API operations

**Add to MCP config**:
```json
{
  "mcpServers": {
    "fusion-mcp-server": {
      "command": "cmd",
      "args": ["/c", "python", "server.py"],
      "cwd": "C:\\Users\\maxco\\Fusion-MCP-Server",
      "env": {}
    }
  }
}
```

## 🚀 How to Add Specialized Servers

### Option 1: Use Pre-configured Files
1. Copy the configuration from `mcp-servers/specialized/[server-name].json`
2. Add it to your `~/.claude/mcp.json` file
3. Restart Claude Code

### Option 2: Use Master Configuration
Replace your entire MCP config with the master configuration:
```powershell
copy mcp-servers\mcp-master.json %USERPROFILE%\.claude\mcp.json
```

### Option 3: Manual Addition
1. Edit `~/.claude/mcp.json`
2. Add the server configuration under `mcpServers`
3. Save and restart Claude Code

## 🔍 Troubleshooting

### Windows Wrapper Issues
- **Problem**: MCP servers fail to start
- **Solution**: Ensure commands use `cmd /c` wrapper
- **Example**: 
  ```json
  "command": "cmd",
  "args": ["/c", "npx", "-y", "package-name"]
  ```

### Package Not Found
- **Problem**: npm package not found
- **Solution**: Install globally first
  ```powershell
  npm install -g package-name
  ```

### Python MCP Servers
- **Problem**: Python server won't start
- **Check**: 
  1. Python is in PATH
  2. Server directory exists
  3. Required Python packages installed

### Testing Your Setup
Run these commands to verify:
```powershell
# Test Claude Code
claude doctor

# Test specific server
npx -y @context7/mcp-server --help
```

## 📋 Server Selection Guide

**For Web Development**: Core + Magic-MCP + Ref-Tools-MCP
**For CAD/Engineering**: Core + FreeCAD-MCP or Fusion-MCP-Server  
**For Documentation**: Core + Ref-Tools-MCP
**For Testing/Automation**: Core + Playwright (already included)
**For Everything**: Use `mcp-master.json` (includes all servers)

---

**Pro Tip**: Start with core servers and add specialized ones as needed to avoid overwhelming your setup.