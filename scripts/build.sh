#!/usr/bin/env bash
set -Eeuo pipefail

ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
SOURCE_DIR="$ROOT_DIR/source"
OUTPUT_DIR="$ROOT_DIR/output"

OMARCHY_URL="${REDSTONE_OMARCHY_URL:-https://github.com/omacom/omarchy.git}"
PKGS_URL="${REDSTONE_PKGS_URL:-https://github.com/omacom/omarchy-pkgs.git}"
ISO_URL="${REDSTONE_ISO_URL:-https://github.com/omacom/omarchy-iso.git}"

OMARCHY_REF="${REDSTONE_OMARCHY_REF:-ac2690cd7be4f47e4a255f5e2e78d904d436b068}"
PKGS_REF="${REDSTONE_PKGS_REF:-9043460ca583d8f012c75f2321bfc0f39cb3649e}"
ISO_REF="${REDSTONE_ISO_REF:-d5136a69782c00fe8d53fc98e4f3a990447d4840}"

die() { printf 'ERROR: %s\n' "$*" >&2; exit 1; }
info() { printf '\n==> %s\n' "$*"; }

for command in git bash; do
  command -v "$command" >/dev/null 2>&1 || die "Required command not found: $command"
done

[[ "$(uname -m)" == "x86_64" ]] || die "This initial build wrapper currently targets x86_64 hosts."
mkdir -p "$SOURCE_DIR" "$OUTPUT_DIR"

# Populate pinned upstream source gitlinks recorded in this repository.
git -C "$ROOT_DIR" submodule update --init --recursive

# Undo only exact patches maintained in this repository. Any unrelated local
# modifications remain untouched and are rejected by the clean-tree check.
unapply_patches() {
  local repository="$1" patch_folder="$2"
  git -C "$repository" rev-parse --is-inside-work-tree >/dev/null 2>&1 || return 0
  [[ -d "$patch_folder" ]] || return 0
  shopt -s nullglob
  local patches=("$patch_folder"/*.patch)
  shopt -u nullglob
  local patch
  for patch in "${patches[@]}"; do
    if git -C "$repository" apply --reverse --check "$patch" >/dev/null 2>&1; then
      git -C "$repository" apply --reverse "$patch"
    fi
  done
}

sync_repo() {
  local name="$1" url="$2" ref="$3" destination="$4"
  if ! git -C "$destination" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    info "Cloning $name"
    git clone "$url" "$destination"
  else
    unapply_patches "$destination" "$ROOT_DIR/patches/$name"
    if [[ -n "$(git -C "$destination" status --porcelain)" ]]; then
      die "$name has uncommitted changes unrelated to cleanly reversible Redstone patches: $destination"
    fi
    info "Fetching $name"
    git -C "$destination" fetch --tags --prune origin
  fi

  info "Selecting $name ref: $ref"
  git -C "$destination" checkout --force "$ref"
}

sync_repo omarchy "$OMARCHY_URL" "$OMARCHY_REF" "$SOURCE_DIR/omarchy"
sync_repo packages "$PKGS_URL" "$PKGS_REF" "$SOURCE_DIR/omarchy-pkgs"
sync_repo iso "$ISO_URL" "$ISO_REF" "$SOURCE_DIR/omarchy-iso"

apply_patches() {
  local name="$1" repository="$2" patch_folder="$3"
  [[ -d "$patch_folder" ]] || return 0
  shopt -s nullglob
  local patches=("$patch_folder"/*.patch)
  shopt -u nullglob
  local patch
  for patch in "${patches[@]}"; do
    info "Applying $name patch: $(basename "$patch")"
    git -C "$repository" apply --check "$patch" || die "Patch does not apply cleanly: $patch"
    git -C "$repository" apply "$patch"
  done
}

apply_patches omarchy "$SOURCE_DIR/omarchy" "$ROOT_DIR/patches/omarchy"
apply_patches packages "$SOURCE_DIR/omarchy-pkgs" "$ROOT_DIR/patches/packages"
apply_patches iso "$SOURCE_DIR/omarchy-iso" "$ROOT_DIR/patches/iso"

ISO_BUILDER="$SOURCE_DIR/omarchy-iso/bin/omarchy-iso-make"
[[ -x "$ISO_BUILDER" ]] || die "Expected executable not found: $ISO_BUILDER"

info "Starting upstream ISO build with local Omarchy and package sources"
(
  cd "$SOURCE_DIR/omarchy-iso"
  "$ISO_BUILDER" --local-source "$SOURCE_DIR/omarchy" "$SOURCE_DIR/omarchy-pkgs"
)

info "Build command completed. Check the upstream builder output for the generated ISO location."
printf 'Redstone output directory: %s\n' "$OUTPUT_DIR"
printf 'Note: upstream output is not automatically moved into output/ by this scaffold.\n'
