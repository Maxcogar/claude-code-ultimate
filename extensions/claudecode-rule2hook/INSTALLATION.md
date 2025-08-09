# claudecode-rule2hook Installation & Usage Guide

## 🚀 Quick Installation

### Step 1: Clone the Repository
```bash
git clone https://github.com/Maxcogar/claude-code-ultimate.git
cd claude-code-ultimate
```

### Step 2: Install rule2hook Command

Choose one of these installation methods:

#### Option A: Project-Specific (Recommended)
```bash
# For use in a specific project
mkdir -p your-project/.claude/commands
cp extensions/claudecode-rule2hook/commands/rule2hook.md your-project/.claude/commands/
cd your-project
# Now /project:rule2hook is available in this project
```

#### Option B: Global Installation
```bash
# For use in all projects
mkdir -p ~/.claude/commands
cp extensions/claudecode-rule2hook/commands/rule2hook.md ~/.claude/commands/
# Now /rule2hook is available globally
```

## 🎯 Usage Examples

### Basic Usage

In Claude Code, type one of these:

```bash
# If installed project-specific
/project:rule2hook "Format Python files with black after editing"

# If installed globally  
/rule2hook "Format Python files with black after editing"
```

### Common Rules You Can Use

```bash
# Code Formatting
/project:rule2hook "Format Python files with black after editing"
/project:rule2hook "Run prettier on JavaScript files after saving"
/project:rule2hook "Format code with eslint --fix before committing"

# Git Workflow
/project:rule2hook "Run git status when finishing a task"
/project:rule2hook "Check for TODO comments before committing"
/project:rule2hook "Run git diff before confirming commits"

# Testing
/project:rule2hook "Run pytest when modifying test files"
/project:rule2hook "Execute npm test after changing source files"
/project:rule2hook "Run unit tests before pushing to remote"

# Security
/project:rule2hook "Scan for API keys before saving configuration files"
/project:rule2hook "Check for hardcoded passwords before committing"

# Complex Commands
/project:rule2hook "Run 'npm run lint && npm test' after editing source files"
```

### Using CLAUDE.md for Rules

1. Create a `CLAUDE.md` file in your project with rules:
```markdown
# Project Rules

- Format Python files with black after editing
- Run tests before committing  
- Check for TODO comments before pushing
```

2. Convert all rules at once:
```bash
/project:rule2hook  # Reads and converts all rules from CLAUDE.md
```

## 🧪 Testing Your Setup

### Quick Test
```bash
# Run the interactive test script
cd claude-code-ultimate/extensions/claudecode-rule2hook
./quick-test.sh
```

### Manual Testing

1. **Create a test rule:**
```bash
/project:rule2hook "Format Python files with black after editing"
```

2. **Check the generated hooks:**
```bash
cat ~/.claude/hooks.json
```

3. **Validate the hooks:**
```bash
python3 validate-hooks.py
```

## 📁 File Structure

After installation, your structure should look like:

```
your-project/
├── .claude/
│   └── commands/
│       └── rule2hook.md     # The slash command
├── CLAUDE.md                # Optional: your project rules
└── ~/.claude/
    └── hooks.json          # Generated hooks configuration
```

## 🔧 Advanced Configuration

### Multiple Rules at Once
```bash
/project:rule2hook "Format Python files after editing, Run tests before committing, Check for TODOs"
```

### Custom Commands with Quotes
```bash
/project:rule2hook "Run 'black . && flake8 && pytest' before committing Python code"
```

### Conditional Rules
```bash
/project:rule2hook "Format only if file extension is .py or .js"
/project:rule2hook "Run tests only if changes affect src/ directory"
```

## 🛠️ Troubleshooting

### Command Not Found
- **Problem**: `/project:rule2hook` shows "command not found"
- **Solution**: Ensure you're in the correct directory and the file exists at `.claude/commands/rule2hook.md`

### Hooks Not Working
- **Problem**: Generated hooks don't execute
- **Solution**: 
  1. Check `~/.claude/hooks.json` exists and is valid JSON
  2. Run `python3 validate-hooks.py` to check configuration
  3. Ensure commands are executable in your shell

### Rule Not Understood  
- **Problem**: Claude doesn't generate the expected hook
- **Solution**:
  1. Be more specific with timing words ("after editing", "before committing")
  2. Specify exact commands in quotes: `"Run 'black .' after editing"`
  3. Use tool names Claude recognizes: "Edit", "Write", "Bash"

## 📋 Rule Pattern Guide

| Pattern | Example | Generated Hook Type |
|---------|---------|-------------------|
| "X after editing" | "Format Python after editing" | PostToolUse |
| "X before saving" | "Check syntax before saving" | PreToolUse |  
| "X when finishing" | "Run git status when finishing" | Stop |
| "X before committing" | "Run tests before committing" | PreToolUse (Bash) |

## 🔄 Updating

To get the latest version:
```bash
cd claude-code-ultimate
git pull origin main
# Re-copy the command file if needed
cp extensions/claudecode-rule2hook/commands/rule2hook.md ~/.claude/commands/
```

## 📚 Additional Resources

- [Test Cases](test-cases.md) - Comprehensive testing scenarios
- [Sample Rules](examples/sample_rules.md) - More rule examples
- [Validation Tool](validate-hooks.py) - Check your hooks
- [Quick Test Script](quick-test.sh) - Interactive testing

## 🤝 Need Help?

1. Check the [test cases](test-cases.md) for examples
2. Run the validation tool: `python3 validate-hooks.py`
3. Look at [sample rules](examples/sample_rules.md) for inspiration
4. Open an issue in the [claude-code-ultimate repository](https://github.com/Maxcogar/claude-code-ultimate/issues)

---

**✨ You're ready to automate your Claude Code workflow with natural language rules!**
