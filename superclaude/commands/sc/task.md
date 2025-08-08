---
allowed-tools: [Read, Glob, Grep, TodoWrite, Task, mcp__sequential__sequential]
description: "Execute complex tasks with intelligent workflow management and cross-session persistence"
wave-enabled: true
complexity-threshold: 0.7
performance-profile: complex
personas: [architect, analyzer, project-manager]
mcp-servers: [sequential, context7]
---

# /sc:task - Enhanced Task Management

## Purpose
Execute complex tasks with intelligent workflow management, cross-session persistence, hierarchical task organization, and advanced orchestration capabilities.

## Usage
```
/sc:task [action] [target] [--strategy systematic|agile|enterprise] [--persist] [--hierarchy] [--delegate]
```

## Actions
- `create` - Create new project-level task hierarchy
- `execute` - Execute task with intelligent orchestration
- `status` - View task status across sessions
- `analytics` - Task performance and analytics dashboard
- `optimize` - Optimize task execution strategies
- `delegate` - Delegate tasks across multiple agents
- `validate` - Validate task completion with evidence

## Arguments
- `target` - Task description, project scope, or existing task ID
- `--strategy` - Execution strategy (systematic, agile, enterprise)
- `--persist` - Enable cross-session task persistence
- `--hierarchy` - Create hierarchical task breakdown
- `--delegate` - Enable multi-agent task delegation
- `--wave-mode` - Enable wave-based execution
- `--validate` - Enforce quality gates and validation

## Claude Code Integration
- **TodoWrite Integration**: Seamless session-level task coordination
- **Wave System**: Advanced multi-stage execution orchestration
- **Hook System**: Real-time task monitoring and optimization
- **MCP Coordination**: Intelligent server routing and resource utilization