#!/usr/bin/env bash
set -Eeuo pipefail
ROOT_DIR=$(cd -- "$(dirname -- "$0")/.." && pwd)
GROUP_DIR="$ROOT_DIR/config/packages/optional"
usage() {
  cat <<'EOF'
Usage: scripts/install-redstone-extras.sh [--list | --dry-run | GROUP ...]
Installs only packages available in configured official pacman repositories.
Missing/AUR-only names are reported and skipped. No third-party repository,
AUR helper, bootloader, or proprietary driver is installed automatically.
Groups: gaming development productivity multimedia terminal system networking
        security creative iot fonts peripherals virtualisation
        hardware-intel hardware-amd hardware-nvidia
EOF
}
mode=install
groups=()
while (($#)); do
  case "$1" in
    --list) mode=list ;;
    --dry-run) mode=dry-run ;;
    -h|--help) usage; exit 0 ;;
    *) groups+=("$1") ;;
  esac
  shift
done
[[ -d "$GROUP_DIR" ]] || { echo "Package groups not found: $GROUP_DIR" >&2; exit 1; }
if (("\${#groups[@]}" == 0)); then
  if [[ "$mode" == list ]]; then
    printf 'Available groups:\n'
    for file in "$GROUP_DIR"/*.packages; do basename "$file" .packages; done
    exit 0
  fi
  usage
  exit 2
fi
command -v pacman >/dev/null 2>&1 || { echo "This helper requires pacman on Redstone/Arch." >&2; exit 1; }
declare -a available=()
declare -a unavailable=()
declare -A seen=()
for group in "\${groups[@]}"; do
  file="$GROUP_DIR/$group.packages"
  [[ -f "$file" ]] || { echo "Unknown package group: $group" >&2; exit 2; }
  while IFS= read -r package; do
    package="\${package%%#*}"
    package=$(printf '%s' "$package" | xargs)
    [[ -n "$package" ]] || continue
    [[ "$package" =~ ^[a-zA-Z0-9@._+-]+$ ]] || { echo "Invalid package token in $file: $package" >&2; exit 1; }
    [[ -z "\${seen[$package]+x}" ]] || continue
    seen[$package]=1
    if pacman -Q "$package" >/dev/null 2>&1; then
      printf 'Already installed: %s\n' "$package"
    elif pacman -Si "$package" >/dev/null 2>&1; then
      available+=("$package")
    else
      unavailable+=("$package")
    fi
  done < "$file"
done
printf '\nAvailable official-repository packages (%d):\n' "\${#available[@]}"
printf '  %s\n' "\${available[@]:-none}"
if (("\${#unavailable[@]}")); then
  printf '\nUnavailable in configured repositories (%d), skipped:\n' "\${#unavailable[@]}"
  printf '  %s\n' "\${unavailable[@]}"
  printf 'Some may require a reviewed Flatpak or AUR source. Nothing was sourced automatically.\n'
fi
if [[ "$mode" == dry-run || "\${#available[@]}" -eq 0 ]]; then exit 0; fi
printf '\nInstall %d package(s)? [y/N] ' "\${#available[@]}"
read -r answer
[[ "$answer" == [yY] || "$answer" == [yY][eE][sS] ]] || { echo "Cancelled."; exit 0; }
sudo pacman -S --needed -- "\${available[@]}"
