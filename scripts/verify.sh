#!/usr/bin/env bash
set -Eeuo pipefail
ROOT_DIR="$(cd -- "$(dirname -- "$0")/.." && pwd)"
cd "$ROOT_DIR"

fail() { printf 'FAIL: %s\n' "$*" >&2; exit 1; }
for command in git bash python3; do
  command -v "$command" >/dev/null 2>&1 || fail "Missing required command: $command"
done
for path in config patches scripts docs; do
  [[ -d "$path" ]] || fail "Missing project directory: $path"
done
[[ -f scripts/build.sh ]] || fail "Missing scripts/build.sh"
[[ -f config/packages/wishlist.toml ]] || fail "Missing package wishlist"

while IFS= read -r -d '' script; do
  bash -n "$script" || fail "Bash syntax error: $script"
done < <(find scripts -type f -name '*.sh' -print0)

python3 - <<'PY'
from pathlib import Path
import re
import tomllib

for path in Path("config").rglob("*.toml"):
    with path.open("rb") as handle:
        tomllib.load(handle)

for path in Path("config/packages/optional").glob("*.packages"):
    seen = set()
    for number, raw in enumerate(path.read_text().splitlines(), 1):
        token = raw.split("#", 1)[0].strip()
        if not token:
            continue
        if not re.fullmatch(r"[A-Za-z0-9@._+-]+", token):
            raise SystemExit(f"{path}:{number}: invalid package token {token!r}")
        if token in seen:
            raise SystemExit(f"{path}:{number}: duplicate package token {token!r}")
        seen.add(token)
print("TOML and optional package-list syntax: OK")
PY

printf 'Redstone static verification passed.\n'
printf 'This does not build an ISO or prove package availability on every architecture.\n'
