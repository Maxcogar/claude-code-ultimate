# Task: Convert Project Rules to Claude Code Hooks

You are an expert at converting natural language project rules into Claude Code hook configurations. Your task is to analyze the given rules and generate appropriate hook configurations following the official Claude Code hooks specification.

## Instructions

1. If rules are provided as arguments, analyze those rules
2. If no arguments are provided, read and analyze the CLAUDE.md file from these locations:
   - `./CLAUDE.md` (project memory)
   - `./CLAUDE.local.md` (local project memory)  
   - `~/.claude/CLAUDE.md` (user memory)

3. For each rule, determine:
   - The appropriate hook event (PreToolUse, PostToolUse, Stop, Notification)
   - The tool matcher pattern (exact tool names or regex)
   - The command to execute

4. Generate the complete hook configuration following the exact JSON structure
5. Save it to `~/.claude/hooks.json` (merge with existing hooks if present)
6. Provide a summary of what was configured

## Hook Events

### PreToolUse
- **When**: Runs BEFORE a tool is executed
- **Common Keywords**: "before", "check", "validate", "prevent", "scan", "verify"
- **Available Tool Matchers**: 
  - `Task` - Before launching agent tasks
  - `Bash` - Before running shell commands
  - `Edit` - Before editing single files
  - `MultiEdit` - Before batch editing files
  - `Write` - Before writing/creating files
- **Special Feature**: Can block tool execution if command returns non-zero exit code

### PostToolUse
- **When**: Runs AFTER a tool completes successfully
- **Common Keywords**: "after", "following", "once done", "when finished"
- **Available Tool Matchers**: Same as PreToolUse
- **Common Uses**: Formatting, linting, building, testing after file changes

### Stop
- **When**: Runs when Claude Code finishes responding
- **Common Keywords**: "finish", "complete", "end task", "done", "wrap up"
- **No matcher needed**: Applies to all completions
- **Common Uses**: Final status checks, summaries, cleanup

## Hook Configuration Structure

```json
{
  "hooks": {
    "EventName": [
      {
        "matcher": "ToolName|AnotherTool|Pattern.*",
        "hooks": [
          {
            "type": "command",
            "command": "your-command-here"
          }
        ]
      }
    ]
  }
}
```

## Examples with Analysis

### Example 1: Python Formatting
**Rule**: "Format Python files with black after editing"
**Analysis**: 
- Keyword "after" → PostToolUse
- "editing" → Edit|MultiEdit|Write tools
- "Python files" → command should target .py files

```json
{
  "hooks": {
    "PostToolUse": [{
      "matcher": "Edit|MultiEdit|Write",
      "hooks": [{
        "type": "command",
        "command": "black . --quiet 2>/dev/null || true"
      }]
    }]
  }
}
```

### Example 2: Git Status Check
**Rule**: "Run git status when finishing a task"
**Analysis**:
- "finishing" → Stop event
- No specific tool mentioned → no matcher needed

```json
{
  "hooks": {
    "Stop": [{
      "hooks": [{
        "type": "command",
        "command": "git status"
      }]
    }]
  }
}
```

## User Input
$ARGUMENTS