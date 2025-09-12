import { spawn } from "child_process";

async function start() {
  try {
    await import("./update-base-url.mjs");
  } catch (error) {
    console.error("Failed to update BASE_URL:", error.message);
    process.exit(1);
  }

  const server = spawn("node", ["server.js"], {
    stdio: "inherit",
    env: process.env,
  });

  server.on("close", (code) => {
    console.log(`Server exited with code ${code}`);
    process.exit(code);
  });

  server.on("error", (error) => {
    console.error("Failed to start server:", error);
    process.exit(1);
  });
}

start();
