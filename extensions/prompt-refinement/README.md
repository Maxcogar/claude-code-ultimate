# Prompt Refinement Extension

## Overview
The Prompt Refinement Extension enhances communication between users and AI agents by providing intelligent prompt optimization, context analysis, and communication improvement suggestions.

## Features

### 🎯 **Prompt Optimization**
- **Smart Suggestions**: Analyzes prompts and suggests improvements
- **Context Enhancement**: Adds relevant context automatically
- **Clarity Scoring**: Rates prompt clarity and provides feedback
- **Template Library**: Pre-built prompt templates for common tasks

### 🔄 **Real-time Analysis**
- **Intent Detection**: Understands what the user is trying to achieve
- **Ambiguity Detection**: Identifies unclear or ambiguous requests
- **Missing Information**: Suggests additional details that would help
- **Tone Adjustment**: Recommends appropriate communication tone

### 📚 **Template System**
- **Task-Specific**: Templates for coding, design, documentation, etc.
- **Role-Based**: Templates optimized for different agent roles
- **Project Context**: Templates that adapt to your project type
- **Custom Templates**: Create and save your own prompt patterns

### 🎨 **Integration Features**
- **VS Code Extension**: Works directly in your IDE
- **Claude Code Integration**: Seamless integration with Claude Code
- **Agent Coordination**: Optimizes prompts for multi-agent workflows
- **Context Awareness**: Understands project context and history

## Installation

### Via VS Code
1. Open VS Code
2. Go to Extensions (Ctrl+Shift+X)
3. Search for "Claude Prompt Refinement"
4. Click Install

### Via Claude Code Ultimate
```bash
# Automatic installation via setup script
./scripts/setup.ps1

# Manual installation
npm install -g claude-prompt-refinement
```

## Usage

### Basic Prompt Analysis
```javascript
// Analyze and improve a prompt
const improvedPrompt = promptRefiner.analyze({
  original: "Fix this code",
  context: {
    language: "JavaScript",
    project: "React App",
    file: "components/Button.jsx"
  }
});

// Output: "Please review and fix the issues in this React Button component..."
```

### Template Usage
```javascript
// Use a pre-built template
const codeReviewPrompt = promptRefiner.template('code-review', {
  language: 'TypeScript',
  focus: 'security',
  files: ['auth.ts', 'user.service.ts']
});
```

### VS Code Commands
- `Ctrl+Shift+P` → "Refine Prompt" - Analyze current selection
- `Ctrl+Alt+R` → Quick prompt refinement
- `Ctrl+Alt+T` → Open template picker

### CLI Usage
```bash
# Analyze a prompt
prompt-refine analyze "Fix this code" --context '{"language":"js"}'

# Get improvement suggestions
prompt-refine suggest "Improve docs"

# Apply template with variables
prompt-refine template code-review -v language=TypeScript -v files="auth.ts"
```

## Configuration

### Settings
```json
{
  "promptRefinement.enabled": true,
  "promptRefinement.autoSuggest": true,
  "promptRefinement.clarityThreshold": 7,
  "promptRefinement.contextDepth": "medium",
  "promptRefinement.templates": {
    "custom": true,
    "builtin": true
  }
}
```

### Custom Templates
Create custom templates in `.claude/prompt-templates/`:
```yaml
name: "Custom Code Review"
category: "development"
template: |
  Please review the following {{language}} code for:
  - Code quality and best practices
  - Security vulnerabilities
  - Performance optimizations
  - {{focus}} specific issues
  
  Files to review: {{files}}
  
  Context: {{context}}
```

## API Reference

### Core Functions
```javascript
const promptRefiner = require('claude-prompt-refinement');

// Analyze prompt quality
const analysis = promptRefiner.analyze(prompt, options);

// Get improvement suggestions
const suggestions = promptRefiner.suggest(prompt);

// Apply template
const result = promptRefiner.template(templateName, variables);

// Custom scoring
const score = promptRefiner.score(prompt);
```

## Built-in Templates

### Development Templates
- `code-review` - Code review and analysis
- `debug-help` - Debugging assistance
- `feature-request` - Feature implementation
- `refactor` - Code refactoring
- `test-generation` - Test creation
- `documentation` - Documentation writing

### Design Templates
- `ui-component` - UI component creation
- `wireframe` - Wireframe generation
- `design-system` - Design system development
- `accessibility` - Accessibility improvements

### Project Management
- `requirements` - Requirements gathering
- `planning` - Project planning
- `estimation` - Time/effort estimation
- `architecture` - System architecture

## Integration with Claude Code Ultimate

The extension integrates seamlessly with the Claude Code Ultimate ecosystem:

### MCP Server Integration
```json
{
  "prompt-refinement": {
    "command": "cmd",
    "args": ["/c", "npx", "-y", "claude-prompt-refinement"],
    "env": {}
  }
}
```

### SuperClaude Commands
- `/sc prompt-analyze` - Analyze current prompt
- `/sc prompt-improve` - Get improvement suggestions
- `/sc prompt-template` - Apply templates

## Best Practices

### Writing Effective Prompts
1. **Be Specific**: Include exact requirements and constraints
2. **Provide Context**: Share relevant project information
3. **Define Success**: Clearly state expected outcomes
4. **Use Examples**: Show what you want when possible
5. **Iterate**: Refine based on responses

### Template Guidelines
1. **Reusable**: Create templates for repeated tasks
2. **Flexible**: Use variables for customization
3. **Clear**: Write self-explanatory templates
4. **Tested**: Verify templates work well

## Troubleshooting

### Common Issues
- **Low Clarity Score**: Add more specific details
- **Missing Context**: Include project/file information
- **Ambiguous Intent**: Clarify what you want to achieve
- **Template Errors**: Check variable substitution

### Performance Tips
- Enable auto-suggestions for real-time help
- Use templates for consistent communication
- Set appropriate clarity thresholds
- Customize templates for your workflow

## Contributing

We welcome contributions! Please see our [Contributing Guide](CONTRIBUTING.md) for details.

### Development Setup
```bash
git clone https://github.com/maxcogar/claude-prompt-refinement
cd claude-prompt-refinement
npm install
npm run dev
```

### Build

Run the following to create a production build using Webpack:

```bash
npm run build
```

## License

MIT License - see [LICENSE](LICENSE) for details.
