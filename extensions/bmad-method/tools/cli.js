#!/usr/bin/env node

/**
 * BMad Method CLI Tool
 * Main command line interface for the BMad methodology
 */

const { Command } = require('commander');
const chalk = require('chalk');
const fs = require('fs-extra');
const path = require('path');
const ora = require('ora');

const program = new Command();

program
  .name('bmad-method')
  .description('Breakthrough Method of Agile AI-driven Development')
  .version('4.35.0');

// Build command
program
  .command('build')
  .description('Build BMad methodology structure')
  .option('--agents-only', 'Build only agent structures')
  .option('--teams-only', 'Build only team structures')
  .action(async (options) => {
    const spinner = ora('Building BMad methodology structure...').start();
    
    try {
      if (options.agentsOnly) {
        await buildAgents();
        spinner.succeed('Agents built successfully');
      } else if (options.teamsOnly) {
        await buildTeams();
        spinner.succeed('Teams built successfully');
      } else {
        await buildAll();
        spinner.succeed('BMad methodology structure built successfully');
      }
    } catch (error) {
      spinner.fail(`Build failed: ${error.message}`);
      process.exit(1);
    }
  });

// List agents command
program
  .command('list:agents')
  .description('List all available BMad agents')
  .action(async () => {
    console.log(chalk.cyan('📋 Available BMad Agents:'));
    const agents = await listAgents();
    agents.forEach(agent => {
      console.log(`  • ${chalk.green(agent.name)} - ${agent.description}`);
    });
  });

// Validate command
program
  .command('validate')
  .description('Validate BMad methodology structure')
  .action(async () => {
    const spinner = ora('Validating BMad structure...').start();
    
    try {
      const isValid = await validateStructure();
      if (isValid) {
        spinner.succeed('BMad structure is valid');
      } else {
        spinner.fail('BMad structure validation failed');
        process.exit(1);
      }
    } catch (error) {
      spinner.fail(`Validation failed: ${error.message}`);
      process.exit(1);
    }
  });

// Helper functions
async function buildAgents() {
  const agentsDir = path.join(process.cwd(), 'agents');
  await fs.ensureDir(agentsDir);
  
  const defaultAgents = [
    'architect', 'developer', 'tester', 'devops', 'product-owner'
  ];
  
  for (const agent of defaultAgents) {
    const agentFile = path.join(agentsDir, `${agent}.md`);
    if (!await fs.pathExists(agentFile)) {
      await fs.writeFile(agentFile, generateAgentTemplate(agent));
    }
  }
}

async function buildTeams() {
  const teamsDir = path.join(process.cwd(), 'teams');
  await fs.ensureDir(teamsDir);
  
  const teamConfig = {
    name: 'BMad Development Team',
    agents: ['architect', 'developer', 'tester', 'devops'],
    methodology: 'agile-ai-driven'
  };
  
  await fs.writeJson(path.join(teamsDir, 'team-config.json'), teamConfig, { spaces: 2 });
}

async function buildAll() {
  await buildAgents();
  await buildTeams();
  
  // Create methodology structure
  const methodologyFile = path.join(process.cwd(), 'bmad-methodology.md');
  if (!await fs.pathExists(methodologyFile)) {
    await fs.writeFile(methodologyFile, generateMethodologyTemplate());
  }
}

async function listAgents() {
  return [
    { name: 'Architect', description: 'System design and architecture planning' },
    { name: 'Developer', description: 'Code implementation and development' },
    { name: 'Tester', description: 'Quality assurance and testing' },
    { name: 'DevOps', description: 'Deployment and infrastructure management' },
    { name: 'Product Owner', description: 'Requirements and feature management' }
  ];
}

async function validateStructure() {
  // Basic validation - check if core files exist
  const requiredPaths = [
    'agents',
    'teams',
    'bmad-methodology.md'
  ];
  
  for (const reqPath of requiredPaths) {
    if (!await fs.pathExists(reqPath)) {
      console.error(chalk.red(`Missing required path: ${reqPath}`));
      return false;
    }
  }
  
  return true;
}

function generateAgentTemplate(agentName) {
  return `# ${agentName.toUpperCase()} Agent

## Role
${agentName.charAt(0).toUpperCase() + agentName.slice(1)} specialist in the BMad methodology framework.

## Responsibilities
- Core ${agentName} tasks and deliverables
- Collaboration with other team agents
- Quality assurance for ${agentName} domain

## Tools & Integration
- Claude Code Ultimate MCP servers
- SuperClaude command framework
- BMad methodology protocols

## Workflow
1. Analyze requirements in ${agentName} domain
2. Execute specialized tasks
3. Collaborate with team agents
4. Deliver quality outputs
5. Continuous improvement

## Success Metrics
- Task completion quality
- Team collaboration effectiveness
- Delivery timeline adherence
`;
}

function generateMethodologyTemplate() {
  return `# BMad Methodology

## Overview
Breakthrough Method of Agile AI-driven Development (BMad) is a comprehensive framework for leveraging AI agents in software development workflows.

## Core Principles
1. **AI-First Development**: AI agents as primary development team members
2. **Agile Integration**: Seamless integration with agile methodologies  
3. **Continuous Collaboration**: Human-AI collaborative workflows
4. **Quality Focus**: Built-in quality assurance and testing
5. **Rapid Iteration**: Fast feedback loops and continuous improvement

## Implementation
- Agent-based team structure
- Automated workflow orchestration
- Integrated tooling ecosystem
- Continuous monitoring and optimization

## Getting Started
1. Run \`bmad build\` to set up methodology structure
2. Configure team agents for your project
3. Integrate with your development workflow
4. Start collaborating with AI team members
`;
}

// Error handling
process.on('unhandledRejection', (reason, promise) => {
  console.error(chalk.red('Unhandled Rejection at:'), promise, chalk.red('reason:'), reason);
  process.exit(1);
});

program.parse();
