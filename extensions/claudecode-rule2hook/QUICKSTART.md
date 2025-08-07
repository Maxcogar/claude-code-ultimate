# Quick Start 🚀

## 1. Install the Command

Choose your installation method:

```bash
# Project-specific (recommended)
mkdir -p .claude/commands
cp path/to/claudecode-rule2hook/.claude/commands/rule2hook.md .claude/commands/

# OR Global installation
mkdir -p ~/.claude/commands  
cp path/to/claudecode-rule2hook/.claude/commands/rule2hook.md ~/.claude/commands/
```

## 2. Try It Now!

In Claude Code, type:

```
# Project-specific command
/project:rule2hook "Format Python files after editing"

# OR if globally installed
/rule2hook "Format Python files after editing"
```

Claude will:
1. Analyze your rule
2. Generate a hook configuration
3. Save it to `~/.claude/hooks.json`
4. Show you what was configured

## 3. Use Your CLAUDE.md

If you have rules in CLAUDE.md, just type:

```
/project:rule2hook  # or /rule2hook if global
```

## 4. Common Rules

```
# Use the appropriate command format based on your installation
/project:rule2hook "Run black on Python files after editing"
/project:rule2hook "Execute git status when finishing tasks"
/project:rule2hook "Run tests after modifying test files"
/project:rule2hook "Check for TODO comments before committing"

# OR if globally installed
/rule2hook "Run black on Python files after editing"
# etc.
```

## 5. Check Results

See your configured hooks:
```
cat ~/.claude/hooks.json
```

That's it! Your rules are now active hooks in Claude Code. 🎉