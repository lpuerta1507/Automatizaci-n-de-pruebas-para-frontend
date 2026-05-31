const BasePage = require('./BasePage');

const SELECTORS = {
  pageTitle:        '.title',
  inventoryList:    '.inventory_list',
  inventoryItem:    '.inventory_item',
  itemName:         '.inventory_item_name',
  itemPrice:        '.inventory_item_price',
  addToCartBtn:     (name) => `[data-test="add-to-cart-${name.toLowerCase().replace(/ /g, '-')}"]`,
  removeBtn:        (name) => `[data-test="remove-${name.toLowerCase().replace(/ /g, '-')}"]`,
  cartBadge:        '.shopping_cart_badge',
  cartLink:         '.shopping_cart_link',
  sortDropdown:     '[data-test="product_sort_container"]'
};

/**
 * InventoryPage — página de listado de productos.
 */
class InventoryPage extends BasePage {
  constructor(page) {
    super(page);
  }

  async isLoaded() {
    await this.page.locator(SELECTORS.inventoryList).waitFor({ state: 'visible' });
    return true;
  }

  async getPageTitle() {
    return this.getText(SELECTORS.pageTitle);
  }

  async addProductToCart(productName) {
    const btn = SELECTORS.addToCartBtn(productName);
    await this.page.locator(btn).click();
  }

  async removeProductFromCart(productName) {
    const btn = SELECTORS.removeBtn(productName);
    await this.page.locator(btn).click();
  }

  async getCartCount() {
    const badge = this.page.locator(SELECTORS.cartBadge);
    const visible = await badge.isVisible();
    if (!visible) return 0;
    return parseInt(await badge.innerText(), 10);
  }

  async goToCart() {
    await this.click(SELECTORS.cartLink);
  }

  async getProductNames() {
    return this.page.locator(SELECTORS.itemName).allInnerTexts();
  }

  async isAddToCartVisible(productName) {
    return this.isVisible(SELECTORS.addToCartBtn(productName));
  }

  async isRemoveButtonVisible(productName) {
    return this.isVisible(SELECTORS.removeBtn(productName));
  }
}

module.exports = InventoryPage;
