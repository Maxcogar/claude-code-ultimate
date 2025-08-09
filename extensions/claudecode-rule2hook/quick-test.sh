#!/bin/bash

echo "🧪 claudecode-rule2hook Quick Test Script"
echo "=========================="
echo ""
echo "This script will help you test the rule2hook command"
echo ""

# Color definitions
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Test function
test_rule() {
    local rule="$1"
    local test_name="$2"
    
    echo -e "${YELLOW}Test:${NC} $test_name"
    echo -e "${YELLOW}Rule:${NC} $rule"
    echo ""
    echo "Please execute in Claude Code:"
    echo -e "${GREEN}/project:rule2hook \"$rule\"${NC}"
    echo ""
    echo "Press Enter to continue to next test..."
    read
    echo "---"
    echo ""
}

# Start testing
echo "Preparation:"
echo "1. Ensure you are in Claude Code"
echo "2. Ensure current directory is project directory"
echo "3. Be ready to copy and paste commands"
echo ""
echo "Press Enter to start testing..."
read

# Backup existing hooks
if [ -f ~/.claude/hooks.json ]; then
    cp ~/.claude/hooks.json ~/.claude/hooks.json.test_backup
    echo -e "${GREEN}✓${NC} Backed up existing hooks to ~/.claude/hooks.json.test_backup"
fi

# Test 1
test_rule "Format Python files with black after editing" "Python Formatting Rule"

# Check results
echo "Check generated hooks:"
echo -e "${GREEN}cat ~/.claude/hooks.json${NC}"
echo ""
echo "Press Enter to continue..."
read

# Test 2
test_rule "Run git status when finishing a task" "Git Workflow Rule"

# Test 3
test_rule "Check for TODO comments before committing" "Code Check Rule"

# Test 4 - Read from CLAUDE.md
echo -e "${YELLOW}Test:${NC} Read rules from CLAUDE.md"
echo "Please execute in Claude Code:"
echo -e "${GREEN}/project:rule2hook${NC}"
echo ""
echo "Press Enter to continue..."
read

# Test 5 - Complex command
test_rule "Run 'npm run lint && npm run test' after editing source files" "Complex Command Rule"

# Show final results
echo "📊 Testing complete!"
echo ""
echo "View final hooks configuration:"
echo -e "${GREEN}cat ~/.claude/hooks.json | python -m json.tool${NC}"
echo ""

# Ask if restore
echo "Restore original hooks? (y/n)"
read restore
if [ "$restore" = "y" ]; then
    if [ -f ~/.claude/hooks.json.test_backup ]; then
        cp ~/.claude/hooks.json.test_backup ~/.claude/hooks.json
        echo -e "${GREEN}✓${NC} Restored original hooks"
    fi
fi

echo ""
echo "✨ Test script completed!"