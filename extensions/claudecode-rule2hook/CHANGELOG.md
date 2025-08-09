# Changelog

All notable changes to claudecode-rule2hook will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Initial release of claudecode-rule2hook
- Natural language rule parsing
- Support for all Claude Code hook events (PreToolUse, PostToolUse, Stop, Notification)
- CLAUDE.md integration for reading project rules
- Automatic hook configuration generation
- Safe configuration merging with existing hooks
- Comprehensive test suite and validation tools
- Interactive testing script (`quick-test.sh`)
- Hook validation tool (`validate-hooks.py`)
- Example rules and test cases

### Features
- Convert plain English rules to Claude Code hooks
- Support for multiple rule patterns:
  - Code formatting rules
  - Testing and validation rules
  - Git workflow automation
  - Security checks
  - Custom command execution
- Zero dependencies - works directly with Claude Code
- Intelligent event and tool detection
- Command extraction from natural language

## [1.0.0] - TBD

### Added
- First stable release
- Complete documentation
- MIT License
- Contributing guidelines
- Code of Conduct

---

## Release Notes Format

### Added
- New features

### Changed
- Changes in existing functionality

### Deprecated
- Soon-to-be removed features

### Removed
- Removed features

### Fixed
- Bug fixes

### Security
- Security vulnerability fixes

---