FROM mcr.microsoft.com/playwright:v1.57.0-noble

WORKDIR /app

# Install dependencies
COPY package.json yarn.lock* ./
RUN yarn --frozen-lockfile --ignore-scripts;

# Copy only the needed files and folders individually
COPY tsconfig.json cucumber.json ./
COPY tests ./tests

CMD ["yarn", "test:cucumber"]
