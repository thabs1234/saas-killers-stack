#!/usr/bin/env bash
# setup_dub.sh — fetch Dub build context and start the local self-host stack.
# Dub's web app needs a build (no published image, no upstream Dockerfile). We clone the
# pinned commit into a temp dir, then sync it into ./build-context/dub-web so the custom
# Dockerfile already in that folder (build-context/dub-web/Dockerfile) is preserved and
# the compose build context resolves correctly.
set -euo pipefail
cd "$(dirname "$0")/.."

PINNED_DUB_COMMIT="cd857be"   # Dub main HEAD 2026-08-29; verify at github.com/dubinc/dub/commits/main
CTX_DIR="build-context/dub-web"
TMP="$(mktemp -d)"

if [ ! -f "$CTX_DIR/Dockerfile" ] || [ ! -d "$CTX_DIR/apps/web" ]; then
  echo "==> Cloning Dub (pinned $PINNED_DUB_COMMIT) into temp, syncing into $CTX_DIR..."
  rm -rf "$CTX_DIR"
  git clone https://github.com/dubinc/dub.git "$TMP/dub"
  git -C "$TMP/dub" checkout "$PINNED_DUB_COMMIT" 2>/dev/null || echo "WARN: pin checkout failed; using default branch"
  mkdir -p "$CTX_DIR"
  # Copy everything except our own Dockerfile, then ensure our Dockerfile is present.
  git -C "$TMP/dub" archive HEAD | tar -x -C "$CTX_DIR"
  # Our custom build file lives at build-context/dub-web/Dockerfile (committed in repo).
  test -f "build-context/dub-web/Dockerfile" || { echo "ERR: custom Dockerfile missing"; exit 1; }
  rm -rf "$TMP"
fi

echo "==> Starting Dub stack (web build + mysql + redis shim + mailhog + minio)..."
docker compose -f docker-dub.yml up -d

echo
echo "Dub web:        http://localhost:3000"
echo "Mailhog (dev email): http://localhost:8025"
echo "MySQL (planetscale db): localhost:3306  (empty root password)"
echo
echo "Create an account in the Dub UI; the confirmation email lands in Mailhog (localhost:8025)."
echo "Analytics/billing are stubbed — shortening + redirects + dashboard work; enterprise features do not."
