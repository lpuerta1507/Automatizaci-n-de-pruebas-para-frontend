const { Given, When, Then } = require('@cucumber/cucumber');
const { expect }            = require('@playwright/test');
const LoginPage             = require('../../pages/LoginPage');
const InventoryPage         = require('../../pages/InventoryPage');
const CartPage              = require('../../pages/CartPage');
const CheckoutPage          = require('../../pages/CheckoutPage');

const USERS = {
  standard_user: { username: 'standard_user', password: 'secret_sauce' },
};

// ── Given (checkout-specific) ─────────────────────────────────
Given('he agregado el producto {string} al carrito desde inventario', async function (productName) {
  this.inventoryPage = new InventoryPage(this.page);
  await this.inventoryPage.addProductToCart(productName);
});

Given('he agregado también el producto {string} al carrito', async function (productName) {
  // Navigate back to inventory if on cart page
  if (this.page.url().includes('cart')) {
    await this.page.click('[data-test="continue-shopping"]');
  }
  this.inventoryPage = this.inventoryPage || new InventoryPage(this.page);
  await this.inventoryPage.addProductToCart(productName);
});

Given('he navegado al carrito de compras', async function () {
  this.inventoryPage = this.inventoryPage || new InventoryPage(this.page);
  await this.inventoryPage.goToCart();
  await this.page.waitForURL('**/cart.html');
  this.cartPage = new CartPage(this.page);
});

// ── When ──────────────────────────────────────────────────────
When('inicio el proceso de checkout', async function () {
  this.cartPage = this.cartPage || new CartPage(this.page);
  await this.cartPage.proceedToCheckout();
  await this.page.waitForURL('**/checkout-step-one.html');
  this.checkoutPage = new CheckoutPage(this.page);
});

When('ingreso mis datos personales con nombre {string}, apellido {string} y código postal {string}',
  async function (firstName, lastName, postalCode) {
    this.checkoutPage = this.checkoutPage || new CheckoutPage(this.page);
    await this.checkoutPage.fillPersonalInfo({ firstName, lastName, postalCode });
  }
);

When('hago clic en continuar', async function () {
  await this.checkoutPage.clickContinue();
  await this.page.waitForURL('**/checkout-step-two.html', { timeout: 8000 });
});

When('confirmo la compra haciendo clic en Finish', async function () {
  await this.checkoutPage.clickFinish();
  await this.page.waitForURL('**/checkout-complete.html', { timeout: 8000 });
});

When('cancelo el checkout', async function () {
  this.checkoutPage = this.checkoutPage || new CheckoutPage(this.page);
  await this.checkoutPage.clickCancel();
});

// ── Then ──────────────────────────────────────────────────────
Then('debo ver el resumen de mi orden', async function () {
  const onStepTwo = await this.checkoutPage.isOnStepTwo();
  expect(onStepTwo).toBe(true);
});

Then('debo ver el producto {string} en el resumen', async function (productName) {
  const items = await this.checkoutPage.getOrderItems();
  const found = items.some(item => item.includes(productName));
  expect(found).toBe(true);
});

Then('debo ver la confirmación de compra exitosa', async function () {
  const isComplete = await this.checkoutPage.isOrderComplete();
  expect(isComplete).toBe(true);
});

Then('debo ver el mensaje {string}', async function (expectedMessage) {
  const header = await this.checkoutPage.getConfirmationHeader();
  expect(header).toBe(expectedMessage);
});

Then('debo regresar al carrito de compras', async function () {
  expect(this.page.url()).toContain('cart.html');
});
