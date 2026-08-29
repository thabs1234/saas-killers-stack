# Dub web app — custom Dockerfile (UNVERIFIED).
#
# Dub publishes NO official image and NO Dockerfile. The repo is a pnpm monorepo; the
# web app builds with `pnpm --filter @dub/web build` (Next.js). This file is a
# best-effort multi-stage build provided so `docker-dub.yml` has something to build.
#
# ⚠ NOT VALIDATED: the build host for this project has no Docker, so this image has
#   never been built. Test it before relying on it:
#     docker build -f Dockerfile -t dub-web ./build-context/dub-web
#   Known risks: monorepo pnpm workspace install, Prisma client generation at build
#   time, and build-time env vars. If the build fails, adjust here and re-run.
FROM node:20-alpine AS base
RUN apk add --no-cache libc6-compat git
ENV NEXT_TELEMETRY_DISABLED=1
WORKDIR /app
RUN corepack enable && corepack prepare pnpm@9 --activate

FROM base AS deps
COPY . .
# No lockfile pin available from a shallow clone; fall back if frozen fails.
RUN pnpm install --no-frozen-lockfile || pnpm install

FROM deps AS builder
# Generate Prisma client + build the web app.
RUN pnpm --filter @dub/web exec prisma generate || true
RUN pnpm --filter @dub/web build || pnpm --filter @dub/web... build

FROM node:20-alpine AS runner
RUN apk add --no-cache libc6-compat
WORKDIR /app
ENV NODE_ENV=production
ENV NEXT_TELEMETRY_DISABLED=1
COPY --from=builder /app /app
EXPOSE 3000
CMD ["pnpm","--filter","@dub/web","start"]
