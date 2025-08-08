# /sc load - Project Loading Command

## Description
Loads and analyzes project context, dependencies, and configuration. Prepares the development environment and gathers necessary information for effective AI assistance.

## Usage
```
/sc load [target] [options]
```

## Load Types
- `project` - Load complete project context
- `config` - Load configuration files and settings
- `dependencies` - Load and analyze dependencies
- `docs` - Load project documentation
- `tests` - Load test suites and configurations
- `env` - Load environment and deployment configs

## Examples
```
/sc load project
/sc load config --validate
/sc load dependencies --check-updates
/sc load docs --index
/sc load . --complete
```

## Features
- **Context Analysis**: Understands project structure and patterns
- **Dependency Mapping**: Maps all project dependencies and versions
- **Configuration Validation**: Checks config files for issues
- **Environment Setup**: Prepares development environment
- **Smart Caching**: Caches loaded context for efficiency

## Integration
- Uses Context7 MCP for project analysis
- Integrates with package managers (npm, pip, etc.)
- Supports multiple project types and frameworks
- Maintains loaded context across sessions

## Expected Behavior
1. Scans and analyzes project structure
2. Loads configuration and dependency information
3. Validates project setup and requirements
4. Caches context for efficient access
5. Provides project status and recommendations
6. Prepares environment for development tasks
