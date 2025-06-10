const WIREMOCK_BASEURL = "http://wiremock";

export const wiremock = {
  stubFor: async (stub: { [key: string]: unknown }) => {
    await fetch(`${WIREMOCK_BASEURL}/__admin/mappings`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(stub),
    });
  },
  reset: async () => {
    await fetch(`${WIREMOCK_BASEURL}/__admin/reset`, { method: "POST" });
  },
};
