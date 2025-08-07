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

## 📦 Installation

### Option 1: Project-Specific Installation (Recommended)

To use the rule2hook command in your own project:

```bash
# 1. Clone this repository
git clone https://github.com/zxdxjtu/claudecode-rule2hook.git

# 2. Copy the command to your project
mkdir -p your-project/.claude/commands
cp claudecode-rule2hook/.claude/commands/rule2hook.md your-project/.claude/commands/

# 3. Use in your project
cd your-project
# Now /project:rule2hook is available when using Claude Code in this directory
```

### Option 2: Global Installation

To make the command available in all projects:

```bash
# Clone the repository
git clone https://github.com/zxdxjtu/claudecode-rule2hook.git

# Copy to global Claude commands directory
mkdir -p ~/.claude/commands
cp claudecode-rule2hook/.claude/commands/rule2hook.md ~/.claude/commands/

# Now /rule2hook is available globally (without /project: prefix)
```

## 🚀 Quick Start

After installation, in Claude Code, type:

```bash
# If using project-specific installation (Option 1)
/project:rule2hook "Format Python files with black after editing"

# If using global installation (Option 2)
/rule2hook "Format Python files with black after editing"

# Convert rules from CLAUDE.md
/project:rule2hook  # or /rule2hook if global

# Convert multiple rules
/project:rule2hook "Run tests after editing, Format code before committing"
```

## 📋 Supported Rule Patterns

- **Formatting**: `"Format [language] files after editing"`
- **Testing**: `"Run tests when modifying test files"`
- **Git**: `"Execute git [command] when [event]"`
- **Validation**: `"Check/Validate [something] before [action]"`
- **Notifications**: `"Alert/Notify when [condition]"`
- **Custom Commands**: Use backticks for specific commands

## 📄 License

MIT License - Built with ❤️ by the Claude Code community