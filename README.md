# saas-killers-stack — Kill Your Monthly SaaS Bills

Self-hosted open-source replacements for the paid tools you already use.
Built from the method in Nuno Tavares' video *"Kill Your Monthly SaaS Bills: 5 Github Repos to Replace Everything"* — but as a free, runnable stack, no paid SaaS required.

## What this replaces (and what you save)

| Paid tool | Yearly cost | Free GitHub repo | What it does |
|-----------|------------|------------------|--------------|
| Adobe Acrobat | ~$240 | [Stirling-Tools/Stirling-PDF](https://github.com/Stirling-Tools/Stirling-PDF) | Merge / split / compress / edit PDFs |
| Loom | ~$144 | [CapSoftware/Cap](https://github.com/CapSoftware/Cap) | Screen recording + shareable links |
| Mailchimp | ~$360 | [knadh/listmonk](https://github.com/knadh/listmonk) | Newsletter + bulk email marketing |
| Miro | ~$144 | [excalidraw/excalidraw](https://github.com/excalidraw/excalidraw) | Whiteboard / diagrams |
| Bitly | ~$408 | [dubinc/dub](https://github.com/dubinc/dub) | Link shortening + click tracking |

Total saved in the video: **~$1,296/year**. The real win is owning your stack instead of renting it.

## How it works (the method)

1. **Install Docker** (free, personal/small-business use). Windows: download Docker Desktop, accept defaults, it pulls in WSL2. Mac/Linux: same installer, accept defaults. Keep Docker running — the whale icon in your tray.
2. **Use an AI coding assistant** (Claude Code, Cursor, Codex, or any agent) to install each repo *in its own folder*. Prompt example:
   > "Install Stirling-PDF here using Docker. Explain each step before you run it."
3. **Run it.** Docker ships the app + everything it needs in a sealed container. Delete the container and it leaves nothing behind.

You do NOT need to be a developer. The repo + an AI assistant do the heavy lifting.

## This repo

- `docker-compose.yml` — the core stack, one command: **Stirling-PDF** (8080), **Listmonk + Postgres** (9000), and **Excalidraw** (5000).
- `docker-cap.yml` + `scripts/setup_cap.sh` — **Cap** (Loom replacement): cap-web + media-server + MySQL + MinIO.
- `docker-dub.yml` + `scripts/setup_dub.sh` + `build-context/dub-web/Dockerfile` — **Dub** (Bitly replacement): local MySQL + Redis shim + mailhog + MinIO, with SaaS features stubbed.
- `launchpad/index.html` — a local dashboard linking to every tool once it's up.
- `EXTENDED.md` — self-host notes + limitations for Cap and Dub.

## Quick start

```bash
# from this folder
docker compose up -d
# then open:
#   Stirling-PDF  -> http://localhost:8080
#   Listmonk      -> http://localhost:9000  (admin: listmonk/listmonk, DB auto-migrated via --install)
#   Excalidraw    -> http://localhost:5000  (no login, no config)
#   Launchpad     -> open launchpad/index.html

# Cap (Loom replacement):  bash scripts/setup_cap.sh   -> http://localhost:3000
# Dub (Bitly replacement): bash scripts/setup_dub.sh  -> http://localhost:3000 (see EXTENDED.md for stubs/limits)
```

First run of Listmonk: the container runs `listmonk --install --idempotent && --upgrade && serve` (chained in the compose `command`), auto-migrating the Postgres schema on first boot, then serves. Log in with `listmonk` / `listmonk`.
First run of Stirling-PDF: nothing to configure — it just works. `SECURITY_ENABLELOGIN=false` is set in the compose so the root stays open for local use (newer images gate the UI behind a login by default).

## Prove it actually runs (CI smoke test)

The `.github/workflows/smoke.yml` is LIVE (pushed, runs on every push + manual dispatch).
It boots the core stack on GitHub's free Linux runners (which have Docker) and curls all
three core ports — Stirling-PDF, Listmonk, and Excalidraw — to prove they really serve
(not just parse). Cap and Dub compose files are validated for syntax via `docker compose
config`; their images require builds that aren't run in CI (see EXTENDED.md for the
one-command setup scripts).

The smoke test is green: see the Actions tab for run history.

## Notes / honesty

- Docker is **not** installed on the build host this repo was generated on, so per-service
  live runs happen in CI (GitHub's free runners), not locally. Run it on any machine with Docker.
- **Excalidraw** self-hosted client works but has NO sharing/collaboration (upstream limit).
- **Cap** needs a media-server build (no published image) — `scripts/setup_cap.sh` clones a
  pinned Cap commit and builds it. Local recording storage is MinIO (free, S3-compatible).
- **Dub** has NO official image and NO Dockerfile. This repo ships a custom Dockerfile
  (`build-context/dub-web/Dockerfile`) that is **UNVERIFIED** — no Docker here to build it.
  SaaS features (Tinybird analytics, Stripe, QStash, OAuth) are stubbed; you get shortening,
  redirects, and a dashboard. Expect to tweak the build before it runs.
- All projects are open source (check each license before commercial use). Verify a repo is
  actively maintained before trusting it on your machine.

Free-only. No paid tiers, no API keys, no external services required to run the core stack.
