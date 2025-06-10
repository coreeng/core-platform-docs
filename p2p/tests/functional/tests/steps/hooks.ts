import { After, Before } from "@cucumber/cucumber";
import { CustomWorld } from "./custom-world";

Before(async function (this: CustomWorld) {
  await this.launchBrowser();
  await this.createPage();
});

After(async function (this: CustomWorld) {
  await this.closePage();
  await this.closeBrowser();
});
