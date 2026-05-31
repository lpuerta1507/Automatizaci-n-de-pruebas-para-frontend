module.exports = {
  default: {
    paths: ['features/**/*.feature'],
    require: [
      'support/hooks.js',
      'features/step-definitions/**/*.js'
    ],
    format: [
      'progress-bar',
      'json:reports/cucumber-report.json',
      'html:reports/cucumber-report.html'
    ],
    formatOptions: { snippetInterface: 'async-await' },
    parallel: 1
  }
};