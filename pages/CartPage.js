const BasePage = require('./BasePage');

const SELECTORS = {
  pageTitle:       '.title',
  cartItems:       '.cart_item',
  itemName:        '.inventory_item_name',
  itemPrice:       '.inventory_item_price',
  itemQuantity:    '.cart_quantity',
  continueShoppingBtn: '[data-test="continue-shopping"]',
  checkoutBtn:     '[data-test="checkout"]'
};

/**
 * CartPage — página del carrito de compras.
 */
class CartPage extends BasePage {
  constructor(page) {
    super(page);
  }

  async isLoaded() {
    await this.page.locator(SELECTORS.cartItems).first().waitFor({ state: 'visible' }).catch(() => {});
    return this.page.url().includes('/cart');
  }

  async getPageTitle() {
    return this.getText(SELECTORS.pageTitle);
  }

  async getCartItems() {
    return this.page.locator(SELECTORS.cartItems).allInnerTexts();
  }

  async getItemNames() {
    return this.page.locator(SELECTORS.itemName).allInnerTexts();
  }

  async getItemCount() {
    return this.page.locator(SELECTORS.cartItems).count();
  }

  async isProductInCart(productName) {
    const names = await this.getItemNames();
    return names.some(n => n.includes(productName));
  }

  async proceedToCheckout() {
    await this.click(SELECTORS.checkoutBtn);
  }

  async continueShopping() {
    await this.click(SELECTORS.continueShoppingBtn);
  }
}

module.exports = CartPage;
