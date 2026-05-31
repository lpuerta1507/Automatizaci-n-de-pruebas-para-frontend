const reporter = require('multiple-cucumber-html-reporter');
const path     = require('path');

reporter.generate({
  jsonDir: path.join(__dirname),
  reportPath: path.join(__dirname, 'html'),
  metadata: {
    browser: { name: 'chromium', version: 'latest' },
    device:  'Desktop',
    platform:{ name: 'ubuntu', version: '24' }
  },
  customData: {
    title: 'Sauce Demo — Automation QA Report',
    data: [
      { label: 'Proyecto',    value: 'SauceDemo Playwright + Cucumber' },
      { label: 'Versión',     value: '1.0.0' },
      { label: 'QA Autor',    value: 'Luis Puerta Del Aguila' },
      { label: 'Patrón',      value: 'Page Object Model (POM)' },
      { label: 'Framework',   value: 'Playwright + Cucumber' },
    ]
  },
  disableLog: false,
  openReportInBrowser: false,
});

console.log('✅ Reporte HTML generado en reports/html/index.html');
