#!/usr/bin/env bash
# saas-killers-stack setup — creates data dirs and starts the core stack.
# Windows users: run this from Git Bash / WSL2, or just use "docker compose up -d".
set -euo pipefail

cd "$(dirname "$0")/.."

echo "==> Creating data folders..."
mkdir -p data/stirling data/listmonk

if ! command -v docker >/dev/null 2>&1; then
  echo "ERROR: Docker is not installed."
  echo "Install it first (free): https://www.docker.com/products/docker-desktop"
  exit 1
fi

echo "==> Starting core stack (Stirling-PDF + Listmonk)..."
docker compose up -d

echo
echo "Done. Open:"
echo "  Stirling-PDF : http://localhost:8080"
echo "  Listmonk     : http://localhost:9000  (run DB migration on first open)"
echo "  Launchpad    : open launchpad/index.html"
echo
echo "For Excalidraw / Cap / Dub, see EXTENDED.md."
