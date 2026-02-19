FROM docker.io/node:25.3.0-alpine3.23 AS base

# Install dependencies only when needed
FROM base AS deps
RUN apk add --no-cache gcompat=1.1.0-r4
WORKDIR /app

# Install dependencies
COPY package.json yarn.lock* ./
RUN yarn --frozen-lockfile --ignore-scripts;

# Rebuild the source code only when needed
FROM base AS build
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY package.json yarn.lock* eslint.config.mjs next.config.ts postcss.config.mjs tsconfig.json jest.config.ts jest.setup.ts ./
COPY public ./public
COPY src ./src
COPY scripts ./scripts

# Build and test the app
RUN yarn run test && yarn run build

# Production image, copy all the files and run next
FROM base AS runner
WORKDIR /app

ENV NODE_ENV=production
ENV NEXT_TELEMETRY_DISABLED=1

RUN addgroup --system --gid 1001 nodejs \
 && adduser --system --uid 1001 nextjs

COPY --from=build /app/public ./public
COPY --from=build --chown=nextjs:nodejs /app/.next/standalone ./
COPY --from=build --chown=nextjs:nodejs /app/.next/static ./.next/static
COPY --from=build /app/scripts ./scripts

USER nextjs

EXPOSE 3000

ENV PORT=3000
ENV HOSTNAME="0.0.0.0"

CMD ["node", "scripts/start-with-runtime-url.mjs"]
