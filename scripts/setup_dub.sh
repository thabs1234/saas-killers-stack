#!/usr/bin/env bash
# setup_dub.sh — fetch Dub build context and start the local self-host stack.
# Dub's web app needs a build (no published image). We clone at a pinned commit and
# build locally. SaaS features (Tinybird analytics, Stripe, QStash, OAuth) are stubbed
# via env vars in docker-dub.yml — you get URL shortening + redirects + dashboard.
set -euo pipefail
cd "$(dirname "$0")/.."

PINNED_DUB_COMMIT="cd857be"   # Dub main HEAD 2026-08-29; verify at github.com/dubinc/dub/commits/main
CTX_DIR="build-context/dub-web"

if [ ! -d "$CTX_DIR/.git" ] && [ ! -f "$CTX_DIR/apps/web/Dockerfile" ]; then
  echo "==> Cloning Dub (pinned $PINNED_DUB_COMMIT) for web build context..."
  rm -rf "$CTX_DIR"
  git clone https://github.com/dubinc/dub.git "$CTX_DIR"
  git -C "$CTX_DIR" checkout "$PINNED_DUB_COMMIT" 2>/dev/null || echo "WARN: pin checkout failed; using default branch"
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
