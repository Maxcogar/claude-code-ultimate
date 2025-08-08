---
allowed-tools: [Read, Write, Edit, Glob, Grep, TodoWrite, Task, mcp__sequential__sequential, mcp__context7__context7]
description: "Generate structured implementation workflows from PRDs and feature requirements with expert guidance"
wave-enabled: true
complexity-threshold: 0.6
performance-profile: complex
personas: [architect, analyzer, frontend, backend, security, devops, project-manager]
mcp-servers: [sequential, context7, magic]
---

# /sc:workflow - Implementation Workflow Generator

## Purpose
Analyze Product Requirements Documents (PRDs) and feature specifications to generate comprehensive, step-by-step implementation workflows with expert guidance, dependency mapping, and automated task orchestration.

## Usage
```
/sc:workflow [prd-file|feature-description] [--persona expert] [--c7] [--sequential] [--strategy systematic|agile|mvp] [--output roadmap|tasks|detailed]
```

## Arguments
- `prd-file|feature-description` - Path to PRD file or direct feature description
- `--persona` - Force specific expert persona (architect, frontend, backend, security, devops, etc.)
- `--strategy` - Workflow strategy (systematic, agile, mvp)
- `--output` - Output format (roadmap, tasks, detailed)
- `--estimate` - Include time and complexity estimates
- `--dependencies` - Map external dependencies and integrations
- `--risks` - Include risk assessment and mitigation strategies
- `--parallel` - Identify parallelizable work streams
- `--milestones` - Create milestone-based project phases

## MCP Integration Flags
- `--c7` / `--context7` - Enable Context7 for framework patterns and best practices
- `--sequential` - Enable Sequential thinking for complex multi-step analysis
- `--magic` - Enable Magic for UI component workflow planning
- `--all-mcp` - Enable all MCP servers for comprehensive workflow generation

## Usage Examples

### Generate Workflow from PRD File
```
/sc:workflow docs/feature-100-prd.md --strategy systematic --c7 --sequential --estimate
```

### Create Frontend-Focused Workflow
```
/sc:workflow "User dashboard with real-time analytics" --persona frontend --magic --output detailed
```

### MVP Planning with Risk Assessment
```
/sc:workflow user-authentication-system --strategy mvp --risks --parallel --milestones
```

## Claude Code Integration
- **Multi-Tool Orchestration** - Coordinates Read, Write, Edit, Glob, Grep for comprehensive analysis
- **Progressive Task Creation** - Uses TodoWrite for immediate next steps and Task for long-term planning
- **MCP Server Coordination** - Intelligent routing to Context7, Sequential, and Magic based on workflow needs
- **Cross-Command Integration** - Seamless handoff to implement, analyze, design, and other SuperClaude commands