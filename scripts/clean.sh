#!/usr/bin/env bash
set -Eeuo pipefail

ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

if [[ "${1:-}" != "--yes" ]]; then
  printf 'This removes generated output and upstream source checkouts.\n'
  printf 'Run: %s --yes\n' "$0"
  exit 0
fi

rm -rf -- "$ROOT_DIR/output" "$ROOT_DIR/source"
printf 'Removed Redstone generated output and source checkouts.\n'
