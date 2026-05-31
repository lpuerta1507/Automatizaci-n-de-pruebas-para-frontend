/**
 * BasePage — Page Object Model base class.
 * All page objects extend this class to share common browser interactions.
 */
class BasePage {
  /**
   * @param {import('playwright').Page} page
   */
  constructor(page) {
    this.page = page;
  }

  async navigate(url) {
    await this.page.goto(url, { waitUntil: 'domcontentloaded' });
  }

  async getTitle() {
    return this.page.title();
  }

  async getText(selector) {
    return this.page.locator(selector).innerText();
  }

  async isVisible(selector) {
    return this.page.locator(selector).isVisible();
  }

  async click(selector) {
    await this.page.locator(selector).click();
  }

  async fill(selector, value) {
    await this.page.locator(selector).fill(value);
  }

  async waitForURL(pattern) {
    await this.page.waitForURL(pattern);
  }
}

module.exports = BasePage;
