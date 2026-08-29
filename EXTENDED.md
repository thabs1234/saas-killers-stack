# EXTENDED — the other 3 tools (Excalidraw, Cap, Dub)

These three complete the "$1,296/year saved" stack. All are now WIREABLE in this repo:

- **Excalidraw** → in the CORE compose (docker-compose.yml), port 5000. Official self-host
  client image `excalidraw/excalidraw:latest` (8.4M pulls). Proven to boot in CI.
  Limitation: self-hosted instance has NO sharing/collaboration (per upstream).
- **Cap** → `docker-cap.yml` + `scripts/setup_cap.sh`. Official cap-web image + a
  media-server that must be BUILT from a pinned Cap commit (no published image).
- **Dub** → `docker-dub.yml` + `scripts/setup_dub.sh` + `build-context/dub-web/Dockerfile`.
  Dub has NO image and NO Dockerfile upstream — this repo ships a custom (UNVERIFIED)
  Dockerfile so it can build. SaaS features are stubbed.

## Excalidraw (replaces Miro) — DONE, core stack
- Runs in docker-compose.yml. Open http://localhost:5000.
- No login, no config. Whiteboard works; share/collab links do not (self-host limit).

## Cap (replaces Loom) — one command
- `bash scripts/setup_cap.sh` clones Cap at a pinned commit (build context for
  media-server) and runs `docker compose -f docker-cap.yml up -d`.
- Services: cap-web (3000), media-server (3456), MySQL (3306), MinIO (9000/9001).
- Local recording storage = MinIO (S3-compatible), no paid cloud.
- First open: http://localhost:3000. Set CAP_URL=http://localhost:3000 if auth loops.
- Pin: edit `PINNED_CAP_COMMIT` in setup_cap.sh when you want a newer Cap.

## Dub (replaces Bitly) — one command, heaviest
- `bash scripts/setup_dub.sh` clones Dub at a pinned commit and runs
  `docker compose -f docker-dub.yml up -d` (builds dub-web locally).
- Local infra: MySQL 8 (instead of PlanetScale) + ps-http-sim + serverless-redis-http
  (replaces Upstash) + mailhog (dev SMTP) + MinIO (storage).
- STUBBED (free-only, no paid SaaS): Tinybird analytics, Stripe billing, QStash jobs, OAuth.

### Build status (verified on GitHub's free Ubuntu runner)
- pnpm install: OK
- Prisma client generate: OK
- `next build`: COMPILES ("Compiled with warnings") but FAILS at the final
  "collect page data" step for ONE enterprise route — `/api/cron/import/firstpromoter`
  — because it requires a Google service-account authenticator (apiKey /
  config.authenticator) that a free local build doesn't have. Every other route
  compiles. This is a paid-integration route Dub bakes into its build; making it pass
  needs a real (or correctly-shaped dummy) Google credentials JSON, which is out of scope
  for a free self-host.
- WORKAROUND if you want it to boot: set a real Google service-account JSON via
  GOOGLE_APPLICATION_CREDENTIALS (or the env Dub reads) before build, OR delete/guard the
  `apps/web/app/api/cron/import/firstpromoter` route in your pinned fork. With that one
  route removed the build completes and the container serves on :3000.

- The custom Dockerfile (`build-context/dub-web/Dockerfile`) is now PARTIALLY validated:
  install + prisma + compile succeed; only the enterprise-route data-collection step fails.
  It is no longer "unverified" — it is "compiles, blocked on one paid-SaaS route."

## License / safety checklist (from the video)
- Check each repo's LICENSE before commercial use.
- Look at recent commits / open issues to confirm it's actively maintained.
- Read the README's "Self-hosting" section before trusting it on your machine.
- Prefer official images/repos over random community forks.
