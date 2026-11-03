#!/usr/bin/env bash
# Assemble Reliability Copilot from the public pre-event baseline + this event patch.
# Usage: ./setup.sh [--force] [target-dir]
set -euo pipefail

UPSTREAM="https://github.com/prasannaba/reliability-ai-agent.git"
PIN="688b1c7e1c04d1cd50886a81278a5a5d174e3203"
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PATCH="$ROOT/patches/reliability-copilot-event.patch"
TARGET="app"
FORCE=0

for arg in "$@"; do
  case "$arg" in
    --force) FORCE=1 ;;
    *) TARGET="$arg" ;;
  esac
done
TARGET_PATH="$ROOT/$TARGET"

command -v git >/dev/null 2>&1 || { echo "git not found. Install Git first." >&2; exit 1; }
[ -f "$PATCH" ] || { echo "Patch not found at $PATCH" >&2; exit 1; }

if [ -e "$TARGET_PATH" ]; then
  if [ "$FORCE" -ne 1 ]; then
    echo "Target '$TARGET_PATH' already exists. Delete it or re-run with --force." >&2
    exit 1
  fi
  echo "Removing existing $TARGET_PATH ..."
  rm -rf "$TARGET_PATH"
fi

echo "Cloning pre-event baseline $UPSTREAM ..."
git clone "$UPSTREAM" "$TARGET_PATH"

echo "Checking out pinned baseline $PIN ..."
git -C "$TARGET_PATH" checkout --detach "$PIN"

ACTUAL="$(git -C "$TARGET_PATH" rev-parse HEAD)"
[ "$ACTUAL" = "$PIN" ] || { echo "Baseline mismatch: expected $PIN, got $ACTUAL" >&2; exit 1; }

echo "Applying event patch ..."
git -C "$TARGET_PATH" apply --check --binary --whitespace=nowarn "$PATCH"
git -C "$TARGET_PATH" apply --binary --whitespace=nowarn "$PATCH"

echo ""
echo "Assembled app at: $TARGET_PATH"
echo "Next steps:"
echo "  cd $TARGET"
echo "  cp .env.example .env   # set LLM_API_BASE + LLM_API_KEY, never commit .env"
echo "  docker compose up --build -d"
echo "  curl http://localhost:8000/health"
