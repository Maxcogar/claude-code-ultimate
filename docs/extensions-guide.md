# Extensions Guide - Claude Code Ultimate

This guide covers all extensions included in the Claude Code Ultimate setup and how to use them effectively.

## 🧩 Available Extensions

### 1. BMad-Method (Agile AI Development Framework)
**Location**: `extensions/bmad-method/`
**Status**: ✅ Included
**Purpose**: Provides a complete agile development team as AI agents

**Features:**
- Multiple specialized AI personas (architect, frontend, backend, security, devops)
- Agile methodology workflows
- Sprint planning and task breakdown
- Automated code reviews and testing

**Usage:**
```bash
# Initialize BMad-Method in your project
cc init --template bmad-method

# Use specific personas
/persona architect "Design the system architecture for user authentication"
/persona frontend "Create a responsive dashboard component"
```

### 2. SuperDesign (AI Design Agent)
**Location**: `extensions/superdesign/`
**Status**: ✅ Included
**Purpose**: Generate UI mockups, components, and wireframes from natural language

**Features:**
- Product mockup generation
- UI component creation
- Wireframe exploration
- Fork and iterate designs
- Prompt-to-IDE integration

**Usage:**
```bash
# Generate UI designs
/design "Create a modern login screen with dark theme"
/wireframe "E-commerce product listing page"
/component "Responsive navigation bar with hamburger menu"
```

**IDE Integration:**
- Install SuperDesign extension in VS Code/Cursor
- Access via sidebar panel
- Copy generated designs directly to code

### 3. Rule2Hook (Natural Language Hook System)
**Location**: `extensions/claudecode-rule2hook/`
**Status**: ✅ Included
**Purpose**: Convert natural language rules into Claude Code automation hooks

**Features:**
- Natural language rule processing
- Automatic hook generation
- CLAUDE.md integration
- Safe configuration management
- Zero dependencies

**Usage:**
```bash
# Convert rules to hooks
/rule2hook "Format Python files with black after editing"
/rule2hook "Run tests when modifying test files"
/rule2hook "Execute git status when finishing a task"
```

**Supported Patterns:**
- Formatting: `"Format [language] files after editing"`
- Testing: `"Run tests when modifying test files"`
- Git: `"Execute git [command] when [event]"`
- Validation: `"Check/Validate [something] before [action]"`

### 4. Prompt Refinement (Intelligent Prompt Optimization)
**Location**: `extensions/prompt-refinement/`
**Status**: ✅ Included
**Purpose**: Analyze and refine prompts for clearer AI communication

**Features:**
- Smart suggestions and clarity scoring
- Context-aware prompt enhancements
- Template library for common tasks
- Agent coordination for multi-step workflows

**Usage:**
```bash
# Analyze current prompt
/sc prompt-analyze "Improve this function"

# Apply a template
/sc prompt-template code-review
```

## 🔧 Extension Configuration

### Global Configuration
Extensions are configured in `configs/settings.json`:

```json
{
  "extensions": {
    "bmadMethod": {
      "enabled": true,
      "path": "../extensions/bmad-method"
    },
    "superdesign": {
      "enabled": true,
      "path": "../extensions/superdesign"
    },
    "rule2hook": {
      "enabled": true,
      "path": "../extensions/claudecode-rule2hook"
    },
    "promptRefinement": {
      "enabled": true,
      "path": "../extensions/prompt-refinement"
    }
  }
}
```

### Project-Specific Configuration
Configure extensions per project in `.claude/extensions.json`:

```json
{
  "bmadMethod": {
    "enabled": true,
    "defaultPersona": "full-stack-developer",
    "sprintLength": 14
  },
  "superdesign": {
    "enabled": false,
    "autoGenerate": true
  },
  "promptRefinement": {
    "enabled": true,
    "autoSuggest": true
  }
}
```

## 🚀 Extension Development

### Creating Custom Extensions
1. Create new directory in `extensions/`
2. Add `README.md` with description and usage
3. Include any necessary scripts or configuration files
4. Update `configs/settings.json` to register the extension

### Extension Structure
```
extensions/my-extension/
├── README.md          # Documentation
├── package.json       # Dependencies (if any)
├── src/              # Source code
├── config/           # Configuration files
└── examples/         # Usage examples
```

## 🔍 Troubleshooting

### Extension Not Loading
1. Check `configs/settings.json` for proper configuration
2. Verify extension path exists
3. Review Claude Code logs for errors
4. Ensure required dependencies are installed

### Commands Not Working
1. Verify extension is enabled in project settings
2. Check command syntax and parameters
3. Review extension documentation for usage examples
4. Test with simple commands first

### Performance Issues
1. Disable unused extensions
2. Configure extensions for project-specific use
3. Review extension resource usage
4. Use `--debug` flag for detailed logging

## 📚 Additional Resources

- [SuperDesign Documentation](https://superdesign.dev)
- [BMad-Method GitHub](https://github.com/bmad-method/bmad-method)
- [Claude Code Hooks Documentation](https://docs.anthropic.com/en/docs/claude-code)
- [Extension API Reference](https://docs.anthropic.com/en/docs/claude-code/extensions)

---

*This guide is part of the Claude Code Ultimate setup. For more information, see the main [README.md](../README.md).*