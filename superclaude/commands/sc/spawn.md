---
allowed-tools: [Read, Write, Task, Bash, TodoWrite]
description: "Create and manage specialized AI agents for targeted development tasks"
---

# /sc spawn - Agent Spawning Command

## Description
Creates and deploys specialized AI agents for specific tasks or project roles. Manages agent lifecycle, configuration, and coordination between multiple agents.

## Usage
```
/sc spawn [agent-type] [options]
```

## Agent Types
- `code-reviewer` - Code review and quality analysis agent
- `test-generator` - Automated test creation agent
- `doc-generator` - Documentation generation agent
- `debug-assistant` - Debugging and troubleshooting agent
- `security-auditor` - Security analysis and audit agent
- `performance-optimizer` - Performance analysis agent
- `custom` - Custom agent with specified parameters

## Examples
```
/sc spawn code-reviewer --focus=security
/sc spawn test-generator --framework=jest
/sc spawn doc-generator --format=jsdoc
/sc spawn custom --role="API Designer" --expertise="REST,GraphQL"
```

## Features
- **Specialized Agents**: Purpose-built agents for specific tasks
- **Agent Coordination**: Manages communication between agents
- **Context Sharing**: Agents share project context and findings
- **Lifecycle Management**: Create, configure, monitor, and terminate agents
- **Custom Configurations**: Flexible agent parameter customization

## Integration
- Uses SuperClaude agent framework
- Integrates with all MCP servers and tools
- Supports multi-agent workflows
- Maintains agent state and memory

## Expected Behavior
1. Analyzes spawning request and requirements
2. Configures agent with appropriate parameters
3. Initializes agent with project context
4. Monitors agent performance and output
5. Coordinates with other active agents
6. Provides agent status and results summary
