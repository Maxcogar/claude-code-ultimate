#!/usr/bin/env python3
"""
Validate the generated hooks.json file
"""

import json
import sys
from pathlib import Path


def validate_hooks_file(file_path):
    """Validate hooks.json file"""
    print(f"🔍 Validating file: {file_path}")
    print("-" * 50)
    
    # Check if file exists
    if not file_path.exists():
        print("❌ File does not exist")
        return False
    
    # Read and parse JSON
    try:
        with open(file_path, 'r') as f:
            config = json.load(f)
        print("✅ JSON format is valid")
    except json.JSONDecodeError as e:
        print(f"❌ JSON parsing error: {e}")
        return False
    
    # Validate structure
    if not isinstance(config, dict):
        print("❌ Root element must be an object")
        return False
    
    if "hooks" not in config:
        print("❌ Missing 'hooks' key")
        return False
    
    hooks = config["hooks"]
    if not isinstance(hooks, dict):
        print("❌ 'hooks' must be an object")
        return False
    
    # Validate each event type
    valid_events = {"PreToolUse", "PostToolUse", "Stop", "Notification"}
    hook_count = 0
    
    for event, event_hooks in hooks.items():
        if event not in valid_events:
            print(f"⚠️  Unknown event type: {event}")
        
        if not isinstance(event_hooks, list):
            print(f"❌ Value of {event} must be an array")
            return False
        
        print(f"\n📌 {event} ({len(event_hooks)} configurations)")
        
        for i, hook_group in enumerate(event_hooks):
            if not isinstance(hook_group, dict):
                print(f"  ❌ Configuration {i+1} must be an object")
                continue
            
            # Check matcher (optional)
            matcher = hook_group.get("matcher", "")
            if matcher:
                print(f"  Matcher: {matcher}")
            
            # Check hooks array
            if "hooks" not in hook_group:
                print(f"  ❌ Configuration {i+1} missing 'hooks' array")
                continue
            
            hook_list = hook_group["hooks"]
            if not isinstance(hook_list, list):
                print(f"  ❌ 'hooks' must be an array")
                continue
            
            for j, hook in enumerate(hook_list):
                if not isinstance(hook, dict):
                    print(f"    ❌ Hook {j+1} must be an object")
                    continue
                
                # Validate hook type and command
                hook_type = hook.get("type")
                command = hook.get("command")
                
                if hook_type != "command":
                    print(f"    ⚠️  Hook {j+1} type: {hook_type} (expected: command)")
                
                if not command:
                    print(f"    ❌ Hook {j+1} missing command")
                else:
                    print(f"    ✅ Command: {command[:50]}{'...' if len(command) > 50 else ''}")
                    hook_count += 1
    
    print(f"\n📊 Total: {hook_count} hooks")
    print("✅ Validation passed" if hook_count > 0 else "⚠️  No valid hooks found")
    
    return True


def display_hooks_summary(file_path):
    """Display hooks summary"""
    with open(file_path, 'r') as f:
        config = json.load(f)
    
    print("\n📋 Hooks Summary")
    print("=" * 50)
    
    for event, event_hooks in config.get("hooks", {}).items():
        print(f"\n{event}:")
        for hook_group in event_hooks:
            matcher = hook_group.get("matcher", "All tools")
            for hook in hook_group.get("hooks", []):
                command = hook.get("command", "")
                print(f"  [{matcher}] → {command}")


if __name__ == "__main__":
    # Default to check user's hooks.json
    hooks_file = Path.home() / ".claude" / "hooks.json"
    
    # Can also specify other files
    if len(sys.argv) > 1:
        hooks_file = Path(sys.argv[1])
    
    if validate_hooks_file(hooks_file):
        display_hooks_summary(hooks_file)
    else:
        print("\n❌ Validation failed")
        sys.exit(1)