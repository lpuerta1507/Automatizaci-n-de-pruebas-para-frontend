const BasePage = require('./BasePage');

const SELECTORS = {
  // Step One
  pageTitle:        '.title',
  firstNameInput:   '[data-test="firstName"]',
  lastNameInput:    '[data-test="lastName"]',
  postalCodeInput:  '[data-test="postalCode"]',
  continueBtn:      '[data-test="continue"]',
  errorMessage:     '[data-test="error"]',

  // Step Two (overview)
  summaryItems:     '.cart_item',
  itemName:         '.inventory_item_name',
  summaryTotal:     '.summary_total_label',
  summarySubtotal:  '.summary_subtotal_label',
  summaryTax:       '.summary_tax_label',
  finishBtn:        '[data-test="finish"]',
  cancelBtn:        '[data-test="cancel"]',

  // Complete
  completeHeader:   '.complete-header',
  completeText:     '.complete-text',
  ponyExpressImg:   '.pony_express',
  backHomeBtn:      '[data-test="back-to-products"]'
};

/**
 * CheckoutPage — gestiona los 3 pasos del checkout:
 *   Step 1: Información personal
 *   Step 2: Resumen de la orden
 *   Step 3: Confirmación
 */
class CheckoutPage extends BasePage {
  constructor(page) {
    super(page);
  }

  // ── Step 1 ──────────────────────────────────────────────────
  async isOnStepOne() {
    return this.page.url().includes('checkout-step-one');
  }

  async fillPersonalInfo({ firstName, lastName, postalCode }) {
    await this.fill(SELECTORS.firstNameInput, firstName);
    await this.fill(SELECTORS.lastNameInput, lastName);
    await this.fill(SELECTORS.postalCodeInput, postalCode);
  }

  async clickContinue() {
    await this.click(SELECTORS.continueBtn);
  }

  async getStepOneError() {
    return this.getText(SELECTORS.errorMessage);
  }

  // ── Step 2 ──────────────────────────────────────────────────
  async isOnStepTwo() {
    return this.page.url().includes('checkout-step-two');
  }

  async getOrderTotal() {
    return this.getText(SELECTORS.summaryTotal);
  }

  async getSubtotal() {
    return this.getText(SELECTORS.summarySubtotal);
  }

  async getOrderItems() {
    return this.page.locator(SELECTORS.itemName).allInnerTexts();
  }

  async clickFinish() {
    await this.click(SELECTORS.finishBtn);
  }

  async clickCancel() {
    await this.click(SELECTORS.cancelBtn);
  }

  // ── Step 3 (Complete) ────────────────────────────────────────
  async isOrderComplete() {
    return this.page.url().includes('checkout-complete');
  }

  async getConfirmationHeader() {
    await this.page.locator(SELECTORS.completeHeader).waitFor({ state: 'visible' });
    return this.getText(SELECTORS.completeHeader);
  }

  async getConfirmationText() {
    return this.getText(SELECTORS.completeText);
  }

  async isConfirmationImageVisible() {
    return this.isVisible(SELECTORS.ponyExpressImg);
  }

  async backToProducts() {
    await this.click(SELECTORS.backHomeBtn);
  }
}

module.exports = CheckoutPage;
