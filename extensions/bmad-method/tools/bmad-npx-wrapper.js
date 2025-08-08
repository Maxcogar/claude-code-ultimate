#!/usr/bin/env node

/**
 * BMad Method NPX Wrapper
 * Handles npx execution and global installation
 */

const path = require('path');
const { spawn } = require('child_process');

// Get the CLI script path
const cliPath = path.join(__dirname, 'cli.js');

// Forward all arguments to the main CLI
const args = process.argv.slice(2);

// Spawn the CLI process
const child = spawn('node', [cliPath, ...args], {
  stdio: 'inherit',
  cwd: process.cwd()
});

// Handle exit codes
child.on('exit', (code) => {
  process.exit(code || 0);
});

// Handle errors
child.on('error', (error) => {
  console.error('Failed to start BMad CLI:', error.message);
  process.exit(1);
});
