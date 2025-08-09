# claudecode-rule2hook Test Cases

## Test Preparation

```bash
# 1. Ensure current directory is project directory
pwd  # Should display /Users/jessica/Desktop/repo/claude-hook-demo

# 2. Check if Slash Command is ready
ls -la .claude/commands/rule2hook.md

# 3. Backup existing hooks (if any)
cp ~/.claude/hooks.json ~/.claude/hooks.json.backup 2>/dev/null || echo "No existing hooks"
```

## Test Case 1: Single Formatting Rule

**Input Command:**
```
/project:rule2hook "Format Python files with black after editing"
```

**Expected Result:**
- Claude should generate configuration with PostToolUse hook
- Matcher should include "Edit|MultiEdit|Write"
- Command should be "black ."

## Test Case 2: Git Workflow Rule

**Input Command:**
```
/project:rule2hook "Run git status when finishing a task"
```

**Expected Result:**
- Should generate Stop event hook
- No matcher needed (applies to all tools)
- Command should be "git status"

## Test Case 3: Multiple Rules

**Input Command:**
```
/project:rule2hook "Run prettier on JavaScript files after saving, Check for console.log before committing"
```

**Expected Result:**
- Should generate two hooks
- First: PostToolUse + prettier
- Second: PreToolUse + check console.log

## Test Case 4: Read from CLAUDE.md

**Preparation:**
```bash
# Ensure CLAUDE.md exists and contains rules
cat CLAUDE.md
```

**Input Command:**
```
/project:rule2hook
```

**Expected Result:**
- Claude should read and analyze all rules in CLAUDE.md
- Generate corresponding hook for each rule

## Test Case 5: Validation Rule

**Input Command:**
```
/project:rule2hook "Validate JSON files before saving them"
```

**Expected Result:**
- Should generate PreToolUse hook
- Matcher should target Write or Edit
- Command might include JSON validation logic

## Test Case 6: Test Hook

**Input Command:**
```
/project:rule2hook "Run npm test after modifying files in tests directory"
```

**Expected Result:**
- PostToolUse hook
- Might include path checking logic
- Command: "npm test"

## Verification Steps

### 1. Check Generated Configuration

```bash
# View generated hooks
cat ~/.claude/hooks.json | jq .

# If jq is not available, use:
cat ~/.claude/hooks.json
```

### 2. Test if Hook is Working

```bash
# Create a test file to trigger hook
echo "# Test file" > test.py

# Edit file (should trigger formatting hook)
echo "def test(): pass" >> test.py

# Complete task (should trigger git status)
# In Claude Code say "I'm done with the task"
```

### 3. Verify Merge Functionality

```bash
# Run another rule, check if merging works correctly
/project:rule2hook "Send notification when deploying"

# Verify original hooks are preserved
cat ~/.claude/hooks.json
```

## Edge Case Testing

### Test Case 7: Ambiguous Rule

**Input Command:**
```
/project:rule2hook "Make sure code is clean"
```

**Expected:** Claude should attempt to interpret and generate reasonable hook

### Test Case 8: Complex Command

**Input Command:**
```
/project:rule2hook "Run 'npm run build && npm test' after changing source files"
```

**Expected:** Correctly handle complex command with &&

### Test Case 9: Special Characters

**Input Command:**
```
/project:rule2hook "Check for patterns like TODO: or FIXME: before committing"
```

**Expected:** Correctly handle special characters and regex patterns

## Cleanup

```bash
# Restore original hooks (if needed)
cp ~/.claude/hooks.json.backup ~/.claude/hooks.json 2>/dev/null || echo "No backup to restore"

# Or clear hooks
echo '{"hooks": {}}' > ~/.claude/hooks.json
```

## Test Record Template

```markdown
### Test Case X: [Name]
- **Execution Time**: 2024-XX-XX
- **Input**: `/project:rule2hook "..."`
- **Actual Output**:
  ```json
  [Paste generated configuration]
  ```
- **Result**: ✅ Pass / ❌ Fail
- **Notes**: [Any observed issues or highlights]
```