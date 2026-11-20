#!/usr/bin/env bash
set -Eeuo pipefail

ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

fail=0
for command in git bash; do
  if ! command -v "$command" >/dev/null 2>&1; then
    printf 'Missing required command: %s\n' "$command" >&2
    fail=1
  fi
done

for path in config patches scripts docs; do
  if [[ ! -d "$path" ]]; then
    printf 'Missing project directory: %s\n' "$path" >&2
    fail=1
  fi
done

if [[ ! -x scripts/build.sh ]]; then
  printf 'Build script is not executable: scripts/build.sh\n' >&2
  fail=1
fi

if (( fail )); then
  exit 1
fi

printf 'Redstone repository structure looks sane.\n'
printf 'This check does not validate upstream compatibility or produce an ISO.\n'
