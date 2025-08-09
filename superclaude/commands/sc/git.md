---
allowed-tools: [Read, Write, Bash, Glob, TodoWrite, Task]
description: "Execute Git version control operations via integrated MCP server"
---

# /sc git - Git Operations Command

## Description
Performs Git version control operations using the integrated Git MCP server. Handles repository management, commit operations, branch management, and collaboration workflows.

## Usage
```
/sc git [operation] [options]
```

## Operations
- `status` - Show repository status
- `add [files]` - Stage files for commit
- `commit [message]` - Commit staged changes
- `push [remote] [branch]` - Push changes to remote
- `pull [remote] [branch]` - Pull changes from remote
- `branch [name]` - Create or switch branches
- `merge [branch]` - Merge branches
- `log [options]` - View commit history

## Examples
```
/sc git status
/sc git add .
/sc git commit "feat: add new authentication system"
/sc git push origin main
/sc git branch feature/user-auth
/sc git merge develop
```

## Integration
- Uses Git MCP server for version control operations
- Integrates with project workflows and deployment
- Supports multi-repository management
- Provides conflict resolution assistance

## Expected Behavior
1. Analyzes current repository state
2. Executes requested Git operations
3. Provides clear feedback on operation results
4. Suggests next steps or conflict resolution
5. Maintains project workflow consistency
