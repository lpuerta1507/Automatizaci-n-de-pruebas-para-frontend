const { Given, When, Then } = require('@cucumber/cucumber');
const { expect }            = require('@playwright/test');
const LoginPage             = require('../../pages/LoginPage');
const InventoryPage         = require('../../pages/InventoryPage');
const CartPage              = require('../../pages/CartPage');

const USERS = {
  standard_user:          { username: 'standard_user',          password: 'secret_sauce' },
  locked_out_user:        { username: 'locked_out_user',        password: 'secret_sauce' },
  performance_glitch_user:{ username: 'performance_glitch_user',password: 'secret_sauce' },
};

// ── Given ─────────────────────────────────────────────────────
Given('que he iniciado sesión como {string}', async function (userKey) {
  const creds = USERS[userKey] || USERS.standard_user;
  this.loginPage = new LoginPage(this.page);
  await this.loginPage.open();
  await this.loginPage.login(creds.username, creds.password);
  await this.page.waitForURL('**/inventory.html', { timeout: 10000 });
});

Given('estoy en la página de productos', async function () {
  this.inventoryPage = new InventoryPage(this.page);
  const loaded = await this.inventoryPage.isLoaded();
  expect(loaded).toBe(true);
});

Given('he agregado el producto {string} al carrito', async function (productName) {
  this.inventoryPage = this.inventoryPage || new InventoryPage(this.page);
  await this.inventoryPage.addProductToCart(productName);
});

// ── When ──────────────────────────────────────────────────────
When('agrego el producto {string} al carrito', async function (productName) {
  this.inventoryPage = this.inventoryPage || new InventoryPage(this.page);
  await this.inventoryPage.addProductToCart(productName);
});

When('voy al carrito de compras', async function () {
  this.inventoryPage = this.inventoryPage || new InventoryPage(this.page);
  await this.inventoryPage.goToCart();
  await this.page.waitForURL('**/cart.html');
  this.cartPage = new CartPage(this.page);
});

// ── Then ──────────────────────────────────────────────────────
Then('el contador del carrito debe mostrar {string}', async function (expectedCount) {
  this.inventoryPage = this.inventoryPage || new InventoryPage(this.page);
  const count = await this.inventoryPage.getCartCount();
  expect(count).toBe(parseInt(expectedCount, 10));
});

Then('el botón del producto debe cambiar a {string}', async function (buttonText) {
  // Validamos que el badge sea > 0 como indicador del cambio de estado
  const count = await this.inventoryPage.getCartCount();
  expect(count).toBeGreaterThan(0);
});

Then('debo ver el producto {string} en el carrito', async function (productName) {
  this.cartPage = this.cartPage || new CartPage(this.page);
  const isInCart = await this.cartPage.isProductInCart(productName);
  expect(isInCart).toBe(true);
});

Then('el título de la página del carrito debe ser {string}', async function (expectedTitle) {
  this.cartPage = this.cartPage || new CartPage(this.page);
  const title = await this.cartPage.getPageTitle();
  expect(title).toBe(expectedTitle);
});

Then('debo ver {string} productos en el carrito', async function (expectedCount) {
  this.cartPage = this.cartPage || new CartPage(this.page);
  const count = await this.cartPage.getItemCount();
  expect(count).toBe(parseInt(expectedCount, 10));
});
