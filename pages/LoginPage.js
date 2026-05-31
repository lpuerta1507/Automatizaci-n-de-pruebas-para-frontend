const BasePage = require('./BasePage');

const URL = 'https://www.saucedemo.com/';

// ── Selectors ─────────────────────────────────────────────────
const SELECTORS = {
  usernameInput:  '#user-name',
  passwordInput:  '#password',
  loginButton:    '#login-button',
  errorMessage:   '[data-test="error"]',
  errorIcon:      '.error_icon'
};

/**
 * LoginPage — encapsula todas las interacciones con la página de login.
 */
class LoginPage extends BasePage {
  constructor(page) {
    super(page);
  }

  async open() {
    await this.navigate(URL);
  }

  async enterUsername(username) {
    await this.fill(SELECTORS.usernameInput, username);
  }

  async enterPassword(password) {
    await this.fill(SELECTORS.passwordInput, password);
  }

  async clickLogin() {
    await this.click(SELECTORS.loginButton);
  }

  /**
   * Flujo completo de login en un solo método.
   */
  async login(username, password) {
    await this.enterUsername(username);
    await this.enterPassword(password);
    await this.clickLogin();
  }

  async getErrorMessage() {
    await this.page.locator(SELECTORS.errorMessage).waitFor({ state: 'visible' });
    return this.getText(SELECTORS.errorMessage);
  }

  async isErrorVisible() {
    return this.isVisible(SELECTORS.errorMessage);
  }

  async isOnLoginPage() {
    return this.isVisible(SELECTORS.loginButton);
  }
}

module.exports = LoginPage;
