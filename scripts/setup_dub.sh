#!/usr/bin/env bash
# setup_dub.sh — fetch Dub build context and start the local self-host stack.
# Dub's web app needs a build (no published image, no upstream Dockerfile). We clone the
# pinned commit into a temp dir, then copy it into ./build-context/dub-web WITHOUT wiping
# the custom Dockerfile that already lives there (committed in this repo). Then build.
set -euo pipefail
cd "$(dirname "$0")/.."

PINNED_DUB_COMMIT="cd857be"   # Dub main HEAD 2026-08-29; verify at github.com/dubinc/dub/commits/main
CTX_DIR="build-context/dub-web"
TMP="$(mktemp -d)"

# Always start from a clean clone so the context matches the pinned commit exactly,
# but PRESERVE our own Dockerfile (it is not part of the upstream repo).
OUR_DOCKER="$CTX_DIR/Dockerfile"
cp "$OUR_DOCKER" "$TMP/Dockerfile.bak" 2>/dev/null || { echo "ERR: custom Dockerfile missing at $OUR_DOCKER"; exit 1; }

if [ ! -d "$CTX_DIR/apps/web" ]; then
  echo "==> Cloning Dub (pinned $PINNED_DUB_COMMIT) into temp..."
  git clone https://github.com/dubinc/dub.git "$TMP/dub"
  git -C "$TMP/dub" checkout "$PINNED_DUB_COMMIT" 2>/dev/null || echo "WARN: pin checkout failed; using default branch"
  echo "==> Syncing Dub source into $CTX_DIR (keeping our Dockerfile)..."
  rm -rf "$CTX_DIR"
  mkdir -p "$CTX_DIR"
  # Copy the clone (minus .git) into the context.
  (cd "$TMP/dub" && tar cf - --exclude='.git' .) | (cd "$CTX_DIR" && tar xf -)
fi

# Restore / ensure our custom Dockerfile is present at the compose context root.
cp "$TMP/Dockerfile.bak" "$CTX_DIR/Dockerfile"
test -f "$CTX_DIR/Dockerfile" || { echo "ERR: custom Dockerfile not in context"; exit 1; }
rm -rf "$TMP"

echo "==> Starting Dub stack (web build + mysql + redis shim + mailhog + minio)..."
docker compose -f docker-dub.yml up -d

echo
echo "Dub web:        http://localhost:3000"
echo "Mailhog (dev email): http://localhost:8025"
echo "MySQL (planetscale db): localhost:3306  (empty root password)"
echo
echo "Create an account in the Dub UI; the confirmation email lands in Mailhog (localhost:8025)."
echo "Analytics/billing are stubbed — shortening + redirects + dashboard work; enterprise features do not."
