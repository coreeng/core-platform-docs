import { Then, Given } from "@cucumber/cucumber";
import { expect, Locator } from "@playwright/test";
import { CustomWorld } from "./custom-world";

const BASE_URL = process.env.SERVICE_ENDPOINT || "http://localhost:3000";

Given("User navigates to the homepage", async function (this: CustomWorld) {
  await this.page.goto(BASE_URL);
});

Then("It should show the title {string}", async function (this: CustomWorld, expectedTitle: string) {
  await expect(this.page.locator("h1")).toContainText(expectedTitle);
});
