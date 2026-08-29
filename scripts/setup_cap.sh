#!/usr/bin/env bash
# setup_cap.sh — fetch Cap build context and start the stack.
# media-server has no published image, so we clone Cap at a pinned commit and build it.
set -euo pipefail
cd "$(dirname "$0")/.."

PINNED_CAP_COMMIT="9f6d8dd"   # Cap main HEAD 2026-08-28; verify at github.com/CapSoftware/Cap/commits/main
CTX_DIR="build-context/cap-media-server"

if [ ! -d "$CTX_DIR/.git" ] && [ ! -f "$CTX_DIR/apps/media-server/Dockerfile.standalone" ]; then
  echo "==> Cloning Cap (pinned $PINNED_CAP_COMMIT) for media-server build context..."
  rm -rf "$CTX_DIR"
  git clone https://github.com/CapSoftware/Cap.git "$CTX_DIR"
  git -C "$CTX_DIR" checkout "$PINNED_CAP_COMMIT" 2>/dev/null || echo "WARN: pin checkout failed; using default branch"
fi
# Safety: confirm the context the compose expects really exists.
test -f "$CTX_DIR/apps/media-server/Dockerfile.standalone" || { echo "ERR: media-server Dockerfile.standalone not found"; exit 1; }

echo "==> Starting Cap stack (cap-web + media-server + mysql + minio)..."
docker compose -f docker-cap.yml up -d

echo
echo "Cap web:        http://localhost:3000"
echo "MinIO console:  http://localhost:9001  (user/pass from docker-cap.yml: cap-admin / cap-minio-pwd-456)"
echo "MySQL (cap db): localhost:3306  user cap / cap-local-pwd-123"
echo
echo "Browser login for Cap web uses NEXTAUTH — for local use set CAP_URL=http://localhost:3000 in a .env if needed."
