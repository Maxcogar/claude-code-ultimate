#!/usr/bin/env node

const { program } = require('commander');
const chalk = require('chalk');
const ora = require('ora');
const refiner = require('../src');

program
  .name('prompt-refine')
  .description('Prompt refinement utilities');

program
  .command('analyze')
  .argument('<prompt>', 'Prompt text to analyze')
  .option('-c, --context <json>', 'JSON string with context')
  .action((prompt, options) => {
    let context = {};
    if (options.context) {
      try {
        context = JSON.parse(options.context);
      } catch (e) {
        console.error(chalk.red('Invalid JSON for context')); 
      }
    }
    const spinner = ora('Analyzing prompt').start();
    const result = refiner.analyze({ original: prompt, context });
    spinner.stop();
    console.log(chalk.green(`Clarity: ${result.clarity}/10`));
    if (result.suggestion) console.log(chalk.yellow(result.suggestion));
    console.log(result.improved);
  });

program
  .command('suggest')
  .argument('<prompt>', 'Prompt text')
  .action((prompt) => {
    const suggestions = refiner.suggest(prompt);
    if (!suggestions.length) {
      console.log(chalk.green('No suggestions.'));
      return;
    }
    suggestions.forEach((s, i) => console.log(`${i + 1}. ${s}`));
  });

function parseKeyValue(value, previous) {
  const [key, val] = value.split('=');
  previous[key] = val;
  return previous;
}

program
  .command('template')
  .argument('<name>', 'Template name')
  .option('-v, --var <key=value>', 'Template variables', parseKeyValue, {})
  .action((name, options) => {
    try {
      const output = refiner.template(name, options.var);
      console.log(output);
    } catch (e) {
      console.error(chalk.red(e.message));
      process.exitCode = 1;
    }
  });

program.parse();
