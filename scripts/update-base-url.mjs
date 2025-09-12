import fs from "fs";
import path from "path";

const BASE_URL = process.env.BASE_URL || "https://docs.coreplatform.io";
const PLACEHOLDER = "https://base-url-placeholder.example.com";

console.log(`Updating BASE_URL to: ${BASE_URL}`);

function findHtmlFiles(dir, fileList = []) {
  const files = fs.readdirSync(dir);

  files.forEach((file) => {
    const filePath = path.join(dir, file);
    const stat = fs.statSync(filePath);

    if (stat.isDirectory()) {
      findHtmlFiles(filePath, fileList);
    } else if (path.extname(file) === ".html") {
      fileList.push(filePath);
    }
  });

  return fileList;
}

const files = findHtmlFiles(".next");

files.forEach((file) => {
  try {
    let content = fs.readFileSync(file, "utf8");
    const originalContent = content;
    content = content.replace(new RegExp(PLACEHOLDER, "g"), BASE_URL);
    if (content !== originalContent) {
      fs.writeFileSync(file, content, "utf8");
    }
  } catch (error) {
    console.error(`Error updating ${file}:`, error.message);
  }
});
