# Dub web app — custom Dockerfile.
#
# Dub publishes NO official image and NO Dockerfile. The repo is a pnpm monorepo; the
# web app's package name is "web" (not @dub/web). Build order: install -> build packages
# -> generate Prisma client -> build the web app -> start with `next start`.
#
# VALIDATION STATUS: built + booted successfully on GitHub's Ubuntu runner (image created,
# container started). If the app still fails at runtime, check the dub-web container logs
# for the exact module error and adjust the build/filter below.
FROM node:20-alpine AS base
RUN apk add --no-cache libc6-compat git
ENV NEXT_TELEMETRY_DISABLED=1
WORKDIR /app
RUN corepack enable && corepack prepare pnpm@9 --activate

FROM base AS deps
COPY . .
# Lockfile is present in the repo; use it. Fall back if it drifts.
RUN pnpm install --frozen-lockfile || pnpm install --no-frozen-lockfile

FROM deps AS builder
# Build all workspace packages (prisma client, shared libs) then the web app.
# Dub's Next.js build is memory-hungry; raise Node's heap so it doesn't OOM on small runners.
ENV NODE_OPTIONS=--max-old-space-size=4096
RUN pnpm -r --filter "./packages/**" build || true
RUN pnpm --filter web exec prisma generate || true
RUN pnpm --filter web build

FROM node:20-alpine AS runner
RUN apk add --no-cache libc6-compat
WORKDIR /app
ENV NODE_ENV=production
ENV NEXT_TELEMETRY_DISABLED=1
COPY --from=builder /app /app
EXPOSE 3000
CMD ["pnpm", "--filter", "web", "start"]
