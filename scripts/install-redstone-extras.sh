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
Groups: browser gaming development productivity multimedia terminal system networking
        security creative iot fonts peripherals virtualisation appearance diagnostics
        accessibility communication desktop-utilities backup-recovery arm64-compatibility
        hardware-intel-cpu hardware-intel-gpu hardware-amd-cpu hardware-amd-gpu hardware-nvidia
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
if ((${#groups[@]} == 0)); then
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
for group in "${groups[@]}"; do
  case "$group" in
    arm64-compatibility)
      [[ "$(uname -m)" == aarch64 ]] || { echo "FEX group is ARM64-only; refusing on $(uname -m)." >&2; exit 2; } ;;
    hardware-intel-cpu)
      grep -q 'GenuineIntel' /proc/cpuinfo || { echo "Intel CPU not detected; refusing $group." >&2; exit 2; } ;;
    hardware-amd-cpu)
      grep -q 'AuthenticAMD' /proc/cpuinfo || { echo "AMD CPU not detected; refusing $group." >&2; exit 2; } ;;
    hardware-intel-gpu)
      command -v lspci >/dev/null 2>&1 && lspci | grep -qi Intel || { echo "Intel GPU not detected (or pciutils missing); refusing $group." >&2; exit 2; } ;;
    hardware-amd-gpu)
      command -v lspci >/dev/null 2>&1 && lspci | grep -qiE 'AMD|ATI|Radeon' || { echo "AMD GPU not detected (or pciutils missing); refusing $group." >&2; exit 2; } ;;
    hardware-nvidia)
      command -v lspci >/dev/null 2>&1 && lspci | grep -qi NVIDIA || { echo "NVIDIA GPU not detected (or pciutils missing); refusing $group." >&2; exit 2; } ;;
  esac
  file="$GROUP_DIR/$group.packages"
  [[ -f "$file" ]] || { echo "Unknown package group: $group" >&2; exit 2; }
  while IFS= read -r package; do
    package="${package%%#*}"
    package=$(printf '%s' "$package" | xargs)
    [[ -n "$package" ]] || continue
    [[ "$package" =~ ^[a-zA-Z0-9@._+-]+$ ]] || { echo "Invalid package token in $file: $package" >&2; exit 1; }
    [[ -z "${seen[$package]+x}" ]] || continue
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
printf '\nAvailable official-repository packages (%d):\n' "${#available[@]}"
printf '  %s\n' "${available[@]:-none}"
if ((${#unavailable[@]})); then
  printf '\nUnavailable in configured repositories (%d), skipped:\n' ${#unavailable[@]}
  printf '  %s\n' "${unavailable[@]}"
  printf 'Some may require a reviewed Flatpak or AUR source. Nothing was sourced automatically.\n'
fi
if [[ "$mode" == dry-run || "${#available[@]}" -eq 0 ]]; then exit 0; fi
printf '\nInstall %d package(s)? [y/N] ' "${#available[@]}"
read -r answer
[[ "$answer" == [yY] || "$answer" == [yY][eE][sS] ]] || { echo "Cancelled."; exit 0; }
sudo pacman -S --needed -- "${available[@]}"
