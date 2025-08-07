# claudecode-rule2hook 🪝

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Claude Code](https://img.shields.io/badge/Claude%20Code-Compatible-blue.svg)](https://docs.anthropic.com/en/docs/claude-code)

Convert natural language project rules into Claude Code hooks automatically! Write rules in plain English, and let Claude transform them into powerful automation hooks.

## ✨ Features

- 🎯 **Natural Language Processing** - Write rules in plain English
- 🔄 **Automatic Hook Generation** - Converts rules to proper hook configurations
- 🧠 **Smart Detection** - Intelligently identifies events, tools, and commands
- 📝 **CLAUDE.md Integration** - Reads from existing project memory files
- 🛡️ **Safe Configuration** - Backs up existing hooks before applying changes
- 🚀 **Zero Dependencies** - Works directly with Claude Code

## 🚀 Quick Start

In Claude Code, type:

```bash
/rule2hook "Format Python files with black after editing"
```

## 📚 How It Works

1. **Input** - Provide rules as text or let Claude read from CLAUDE.md
2. **Analysis** - Claude analyzes rules to determine trigger events, target tools, and commands
3. **Generation** - Creates proper hook configurations
4. **Application** - Saves hooks to `~/.claude/hooks.json`

## 🎯 Examples

### Code Formatting
**Input:** `"Format Python files with black after editing"`

**Generated Hook:**
```json
{
  "hooks": {
    "PostToolUse": [{
      "matcher": "Edit|MultiEdit|Write",
      "hooks": [{
        "type": "command",
        "command": "black ."
      }]
    }]
  }
}
```

### Git Workflow
**Input:** `"Run git status when finishing a task"`

## 📋 Supported Rule Patterns

- **Formatting**: `"Format [language] files after editing"`
- **Testing**: `"Run tests when modifying test files"`
- **Git**: `"Execute git [command] when [event]"`
- **Validation**: `"Check/Validate [something] before [action]"`
- **Notifications**: `"Alert/Notify when [condition]"`
- **Custom Commands**: Use backticks for specific commands

## 📄 License

MIT License - Built with ❤️ by the Claude Code community