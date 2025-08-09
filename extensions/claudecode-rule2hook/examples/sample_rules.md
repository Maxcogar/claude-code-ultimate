# Sample Project Rules

These are example rules that can be converted to Claude Code hooks using the claudecode-rule2hook command.

## Code Quality Rules

- Format Python code with `black` after editing .py files
- Format JavaScript/TypeScript with `prettier --write` after editing .js/.ts files
- Run `eslint --fix` on JavaScript files before saving
- Check for console.log statements before committing

## Git Workflow Rules

- Run `git status` when finishing a task
- Create a git commit message template when committing
- Prevent commits to main branch
- Run `git diff --cached` before confirming a commit

## Testing Rules

- Run unit tests after modifying files in the tests/ directory
- Run `pytest -xvs` when editing test_*.py files
- Validate JSON schema when saving .json files
- Check API endpoints after modifying routes

## Security Rules

- Scan for hardcoded secrets before any file write
- Prevent writing files containing API keys or passwords
- Check file permissions after creating scripts
- Validate environment variables before running commands

## Development Workflow

- Update requirements.txt after installing new packages
- Regenerate documentation after modifying docstrings
- Clear cache when modifying configuration files
- Restart development server after changing .env file

## Notification Rules

- Send Slack notification when deployment scripts are run
- Log all database migrations to audit file
- Alert when modifying production configuration
- Notify team when critical files are changed

## Custom Script Examples

- Run custom build process: `npm run build && npm test`
- Execute multi-step validation: Check syntax, run tests, then lint
- Conditional formatting: Format only if file size < 1000 lines
- Chain operations: Format, test, then commit if all pass
