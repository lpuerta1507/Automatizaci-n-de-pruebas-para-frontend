const { Given, When, Then } = require('@cucumber/cucumber');
const { expect } = require('@playwright/test');
const LoginPage = require('../../pages/LoginPage');
const InventoryPage = require('../../pages/InventoryPage');

Given('que estoy en la página de login', async function () {
  this.loginPage = new LoginPage(this.page);
  await this.loginPage.open();

  const onLogin = await this.loginPage.isOnLoginPage();
  expect(onLogin).toBe(true);
});

When('ingreso el usuario {string} y la contraseña {string}', async function (username, password) {
  this.loginPage = this.loginPage || new LoginPage(this.page);

  await this.loginPage.enterUsername(username);
  await this.loginPage.enterPassword(password);
});

When('hago clic en el botón de login', async function () {
  await this.loginPage.clickLogin();
});

Then('debo ser redirigido a la página de productos', async function () {
  await this.page.waitForURL('**/inventory.html', {
    timeout: 20000
  });

  expect(this.page.url()).toContain('inventory.html');
});

Then('debo ver el título {string}', async function (expectedTitle) {
  this.inventoryPage = new InventoryPage(this.page);

  const title = await this.inventoryPage.getPageTitle();
  expect(title).toBe(expectedTitle);
});

Then('debo ver un mensaje de error que indica que el usuario está bloqueado', async function () {
  const error = await this.loginPage.getErrorMessage();
  expect(error).toContain('locked out');
});

Then('debo permanecer en la página de login', async function () {
  expect(this.page.url()).not.toContain('inventory');

  const onLogin = await this.loginPage.isOnLoginPage();
  expect(onLogin).toBe(true);
});

Then('debo ver un mensaje de error de credenciales incorrectas', async function () {
  const hasError = await this.loginPage.isErrorVisible();

  expect(hasError).toBe(true);

  const error = await this.loginPage.getErrorMessage();
  expect(error.length).toBeGreaterThan(0);
});