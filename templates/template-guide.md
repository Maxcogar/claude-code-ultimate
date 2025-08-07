# Project Templates Guide - Claude Code Ultimate

This guide covers all project templates included in the Claude Code Ultimate setup and how to use them effectively.

## 🎯 Available Templates

### 1. Web Application Template
**Directory**: `templates/web-app/`
**Best For**: React/Next.js web applications, SaaS products, dashboards
**MCP Servers**: context7, sequential, playwright, magic-mcp
**Extensions**: bmadMethod, superdesign

**Includes:**
- Modern React/Next.js boilerplate
- TypeScript configuration
- Tailwind CSS setup
- ESLint and Prettier configuration
- Testing framework setup (Jest, React Testing Library)
- CI/CD pipeline templates
- Docker configuration

**Usage:**
```bash
cc init my-web-app --template web-app
cd my-web-app
cc setup
```

### 2. IoT Project Template
**Directory**: `templates/iot-project/`
**Best For**: ESP32/Arduino projects, embedded systems, hardware automation
**MCP Servers**: context7, sequential, ref-tools-mcp
**Extensions**: bmadMethod

**Includes:**
- ESP32 development environment
- Arduino IDE integration
- Hardware abstraction layers
- Sensor libraries and examples
- MQTT/WiFi communication templates
- OTA update framework
- Circuit diagrams and documentation

**Usage:**
```bash
cc init my-iot-device --template iot-project
cd my-iot-device
cc setup --platform esp32
```

### 3. Fusion 360 Addon Template
**Directory**: `templates/fusion360-addon/`
**Best For**: CAD automation, design tools, manufacturing workflows
**MCP Servers**: context7, sequential, freecad-mcp
**Extensions**: bmadMethod

**Includes:**
- Fusion 360 API boilerplate
- Python addon framework
- UI panel templates
- Command and event handlers
- Documentation templates
- Testing utilities
- Deployment scripts

**Usage:**
```bash
cc init my-fusion-addon --template fusion360-addon
cd my-fusion-addon
cc setup --fusion360
```

## 🛠 Template Usage

### Initializing Projects
```bash
# List available templates
cc templates list

# Initialize with specific template
cc init <project-name> --template <template-name>

# Initialize with custom configuration
cc init my-project --template web-app --config custom-config.json
```

### Customizing Templates
1. **Fork Template**: Copy template to new directory
2. **Modify Structure**: Update files and folders as needed
3. **Update Config**: Modify `template.json` configuration
4. **Register Template**: Add to `configs/workspace-defaults.json`

### Template Configuration
Each template includes a `template.json` file:
```json
{
  "name": "web-app",
  "description": "React/Next.js web application",
  "version": "1.0.0",
  "mcpServers": ["context7", "sequential", "playwright", "magic-mcp"],
  "extensions": ["bmadMethod", "superdesign"],
  "dependencies": {
    "node": ">=18.0.0",
    "npm": ">=8.0.0"
  },
  "postInstall": [
    "npm install",
    "cc setup"
  ]
}
```

## 🔧 Advanced Features

### Variable Substitution
Templates support variable substitution:
- `{{PROJECT_NAME}}` - Project name
- `{{AUTHOR_NAME}}` - Author name from git config
- `{{CURRENT_DATE}}` - Current date
- `{{TEMPLATE_VERSION}}` - Template version

### Conditional Files
Use `.claudeignore` patterns for conditional inclusion:
```
# Only include if TypeScript is enabled
*.ts
*.tsx

# Exclude if testing is disabled
!__tests__/
!*.test.*
```

### Hook Integration
Templates can define setup hooks:
```json
{
  "hooks": {
    "preInstall": "scripts/pre-install.js",
    "postInstall": "scripts/post-install.js",
    "preSetup": "scripts/pre-setup.js",
    "postSetup": "scripts/post-setup.js"
  }
}
```

## 📋 Creating Custom Templates

### Template Structure
```
templates/my-template/
├── template.json          # Template configuration
├── .claudeignore         # Files to ignore/conditionally include
├── README.md            # Template documentation
├── src/                # Source files with {{variables}}
├── config/             # Configuration templates
├── scripts/            # Setup and initialization scripts
└── docs/               # Additional documentation
```

### Step-by-Step Creation
1. **Create Directory**: `mkdir templates/my-template`
2. **Add Configuration**: Create `template.json`
3. **Add Source Files**: Include boilerplate code with variables
4. **Test Template**: Use `cc template test my-template`
5. **Register Template**: Update global configuration

### Best Practices
- Keep templates focused and purpose-specific
- Use meaningful variable names
- Include comprehensive documentation
- Test templates with different configurations
- Version templates for backward compatibility

## 🚀 Template Automation

### Batch Project Creation
```bash
# Create multiple projects from templates
cc batch-init projects.json
```

### Template Updates
```bash
# Update template to latest version
cc template update web-app

# Apply template updates to existing project
cc project update --template web-app
```

### Template Marketplace
```bash
# Search community templates
cc template search react

# Install community template
cc template install community/advanced-react
```

## 🔍 Troubleshooting

### Template Not Found
1. Check template exists in `templates/` directory
2. Verify template is registered in configuration
3. Ensure `template.json` is valid JSON

### Variable Substitution Issues
1. Check variable syntax: `{{VARIABLE_NAME}}`
2. Verify variables are defined in template config
3. Test with `cc template preview my-template`

### Setup Script Failures
1. Review script permissions and execution policy
2. Check script dependencies are available
3. Run scripts individually for debugging

## 📚 Additional Resources

- [Template API Reference](../docs/template-api.md)
- [Community Templates](https://github.com/claude-code-community/templates)
- [Template Best Practices](../docs/template-best-practices.md)
- [Troubleshooting Guide](../docs/troubleshooting.md)

---

*This guide is part of the Claude Code Ultimate setup. For more information, see the main [README.md](../README.md).*