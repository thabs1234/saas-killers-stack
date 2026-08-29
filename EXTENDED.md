# EXTENDED — the other 3 tools (Excalidraw, Cap, Dub)

These three are part of the "$1,296/year saved" stack but don't fit a one-command
Docker container the way Stirling-PDF and Listmonk do. Instructions below.

## Excalidraw  (replaces Miro — whiteboard/diagrams)
- Fastest: use https://excalidraw.com (free, no account, runs in browser).
- Self-host (Vercel one-click): https://vercel.com/new/clone?repository-url=https://github.com/excalidraw/excalidraw
- There is **no official single-container Docker image**. Community images exist
  but are unmaintained — prefer the Vercel deploy or the hosted app for reliability.

## Cap  (replaces Loom — screen recording + share links)
- Cap is primarily a **desktop app**: download from https://cap.so or build from
  https://github.com/CapSoftware/Cap.
- It also has an optional self-hosted **server** (for hosting your own recordings)
  documented in the repo's `apps/server` + `apps/web` with its own Docker setup.
- Practical path: install the desktop app, record, and either keep recordings local
  or run the self-host server if you want your own link host.

## Dub  (replaces Bitly — link shortening + click tracking)
- Full self-host needs: Postgres + Redis + Tinybird (analytics).
- Official self-host guide + docker-compose: https://github.com/dubinc/dub (see `apps/web` / self-host docs).
- Lighter alternative: the Dub open-source repo can run with just Postgres + Redis
  if you skip Tinybird (you lose some analytics depth).
- This is the heaviest of the five — start with Stirling-PDF + Listmonk (the
  docker-compose.yml) before attempting Dub.

## License / safety checklist (from the video)
- Check each repo's LICENSE before commercial use.
- Look at recent commits / open issues to confirm it's actively maintained.
- Read the README's "Self-hosting" section before trusting it on your machine.
- Prefer official images/repos over random community forks.
