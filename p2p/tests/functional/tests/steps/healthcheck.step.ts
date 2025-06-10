import { When, Then } from "@cucumber/cucumber";
import { expect, request, APIResponse } from "@playwright/test";

let response: APIResponse;
let responseBody: string;

const BASE_URL = process.env.SERVICE_ENDPOINT || "http://localhost:3000";

When("User sends a GET request to {string}", async function (endpoint: string) {
  const requestContext = await request.newContext();
  response = await requestContext.get(`${BASE_URL}${endpoint}`);

  responseBody = (await response.text()).trim();

  await requestContext.dispose();
});

Then("The response status code should be {int}", async function (statusCode: number) {
  expect(response.status()).toBe(statusCode);
});

Then("The response body should be {string}", async function (expectedBody: string) {
  expect(responseBody).toBe(expectedBody);
});
