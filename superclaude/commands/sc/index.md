# /sc index - Project Indexing Command

## Description
Creates comprehensive project indexes, documentation maps, and searchable catalogs. Analyzes project structure and generates navigational aids for better project understanding.

## Usage
```
/sc index [type] [options]
```

## Index Types
- `files` - Generate file structure index
- `functions` - Index all functions and methods
- `classes` - Index all classes and objects
- `dependencies` - Index project dependencies
- `docs` - Index documentation and comments
- `api` - Generate API reference index
- `all` - Complete project index

## Examples
```
/sc index files
/sc index functions --export-json
/sc index api --public-only
/sc index all --update
```

## Features
- **Smart Analysis**: Understands project structure and patterns
- **Cross-References**: Links related components and dependencies
- **Search Integration**: Creates searchable indexes
- **Export Options**: Multiple output formats (JSON, Markdown, HTML)
- **Incremental Updates**: Updates existing indexes efficiently

## Integration
- Uses Context7 MCP for documentation indexing
- Integrates with project documentation systems
- Supports multiple project types and frameworks
- Maintains index consistency across updates

## Expected Behavior
1. Scans project structure and files
2. Analyzes code patterns and relationships
3. Generates comprehensive index with cross-references
4. Provides search and navigation capabilities
5. Maintains index updates with project changes
