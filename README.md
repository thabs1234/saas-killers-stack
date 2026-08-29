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

- `docker-compose.yml` — two services that run cleanly with one command: **Stirling-PDF** (port 8080) and **Listmonk + Postgres** (port 9000).
- `launchpad/index.html` — a local dashboard linking to every tool once it's up.
- `scripts/setup.sh` — creates data folders and starts the stack.
- `EXTENDED.md` — self-host notes for **Excalidraw**, **Cap**, and **Dub** (these need a little more than one command; instructions + official links included).

## Quick start

```bash
# from this folder
docker compose up -d
# then open:
#   Stirling-PDF  -> http://localhost:8080
#   Listmonk      -> http://localhost:9000  (admin setup on first open)
#   Launchpad     -> open launchpad/index.html
```

First run of Listmonk: open http://localhost:9000, run the DB migration, set admin login.
First run of Stirling-PDF: nothing to configure — it just works.

## Notes / honesty

- Docker is **not** installed on the build host this repo was generated on, so the compose file is verified for *syntax and image references*, not live-run here. Run it on any machine with Docker.
- **Cap** is a desktop screen-recorder app (download from its repo) plus an optional self-host server — it is not a single Docker container.
- **Dub** self-hosting needs Postgres + Redis + Tinybird; use the official `dubinc/dub` docker-compose for the full stack (see EXTENDED.md).
- **Excalidraw** has no official one-container image; use excalidraw.com (free) or deploy via its Vercel one-click (see EXTENDED.md).
- All projects are open source (check each license before commercial use). Verify a repo is actively maintained before trusting it on your machine.

Free-only. No paid tiers, no API keys, no external services required to run the core stack.
