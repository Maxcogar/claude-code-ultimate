---
allowed-tools: [Read, Edit, MultiEdit, Write, Grep, Bash, Glob, TodoWrite]
description: "Analyze and enhance code quality, performance, and maintainability"
---

# /sc improve - Code Improvement Command

## Description
Analyzes and improves existing code quality, performance, and maintainability. Suggests refactoring opportunities, code optimizations, and best practice implementations.

## Usage
```
/sc improve [target] [options]
```

## Options
- `--performance` - Focus on performance optimizations
- `--security` - Focus on security improvements
- `--maintainability` - Focus on code maintainability
- `--standards` - Apply coding standards and conventions
- `--all` - Comprehensive improvement analysis

## Examples
```
/sc improve src/auth.js --security
/sc improve . --performance
/sc improve components/ --maintainability
/sc improve --all
```

## Improvement Areas
- **Code Quality**: Remove code smells, improve readability
- **Performance**: Optimize algorithms, reduce complexity
- **Security**: Fix vulnerabilities, secure coding practices
- **Architecture**: Improve design patterns, separation of concerns
- **Testing**: Add missing tests, improve test coverage
- **Documentation**: Enhance code comments and documentation

## Integration
- Uses static analysis tools and MCP servers
- Integrates with testing frameworks
- Provides refactoring recommendations
- Maintains backward compatibility

## Expected Behavior
1. Analyzes target code or project
2. Identifies improvement opportunities
3. Provides specific recommendations with examples
4. Estimates impact and effort required
5. Offers to implement changes interactively
