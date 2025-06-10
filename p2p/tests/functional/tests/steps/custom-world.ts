import { setWorldConstructor, World } from "@cucumber/cucumber";
import { Browser, BrowserContext, Page, chromium } from "@playwright/test";

export class CustomWorld extends World {
  browser!: Browser;
  context!: BrowserContext;
  page!: Page;

  async launchBrowser() {
    this.browser = await chromium.launch({ headless: true });
  }

  async createPage() {
    this.context = await this.browser.newContext();
    this.page = await this.context.newPage();
  }

  async closePage() {
    await this.page.close();
    await this.context.close();
  }

  async closeBrowser() {
    await this.browser.close();
  }
}

setWorldConstructor(CustomWorld);
