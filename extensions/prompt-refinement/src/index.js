const fs = require('fs');
const path = require('path');
const _ = require('lodash');
const yaml = require('yaml');
const Sentiment = require('sentiment');

const sentiment = new Sentiment();

// Simple built-in templates
const builtInTemplates = {
  'code-review': `Please review the following {{language}} code for:
- Code quality and best practices
- Security vulnerabilities
- Performance optimizations
- {{focus}} specific issues

Files to review: {{files}}`
};

function score(prompt) {
  if (!prompt) return 0;
  const wordCount = prompt.trim().split(/\s+/).length;
  let clarity = Math.min(10, Math.max(1, Math.round(wordCount / 3)));
  const tone = sentiment.analyze(prompt);
  if (tone.score < -2) clarity = Math.max(1, clarity - 1);
  return clarity;
}

function analyze({ original, context = {} }) {
  const clarity = score(original);
  let suggestion = '';
  if (clarity < 5) {
    suggestion = 'Consider adding more detail to your prompt.';
  }
  const contextStr = Object.keys(context).length
    ? `\n\nContext:\n${JSON.stringify(context, null, 2)}`
    : '';
  return {
    improved: `${original}${contextStr}`,
    clarity,
    suggestion
  };
}

function suggest(prompt) {
  const suggestions = [];
  if (!prompt || prompt.length < 20) {
    suggestions.push('Add more detail to your request.');
  }
  if (!/[.!?]$/.test(prompt)) {
    suggestions.push('End the prompt with proper punctuation.');
  }
  const tone = sentiment.analyze(prompt);
  if (tone.comparative < -0.5) {
    suggestions.push('Adjust tone to be more neutral.');
  }
  return suggestions;
}

function template(name, vars = {}) {
  const home = process.env.HOME || process.env.USERPROFILE || '.';
  const customDir = path.join(home, '.claude', 'prompt-templates');
  let tpl;
  const file = path.join(customDir, `${name}.yaml`);
  if (fs.existsSync(file)) {
    const obj = yaml.parse(fs.readFileSync(file, 'utf8'));
    tpl = obj.template;
  } else {
    tpl = builtInTemplates[name];
  }
  if (!tpl) {
    throw new Error(`Template ${name} not found`);
  }
  return _.template(tpl)(vars);
}

module.exports = {
  analyze,
  suggest,
  template,
  score
};
