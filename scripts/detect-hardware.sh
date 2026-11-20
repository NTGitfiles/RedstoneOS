#!/usr/bin/env bash
set -Eeuo pipefail
arch=$(uname -m 2>/dev/null || printf unknown)
cpu_vendor=$(awk -F': ' '/vendor_id/{print $2; exit}' /proc/cpuinfo 2>/dev/null || true)
[[ -n "$cpu_vendor" ]] || cpu_vendor=unknown
gpu_info=""
if command -v lspci >/dev/null 2>&1; then
  gpu_info=$(lspci -nn 2>/dev/null | grep -Ei 'VGA compatible controller|3D controller|Display controller' || true)
fi
case "$cpu_vendor" in
  GenuineIntel) cpu_profile=intel ;;
  AuthenticAMD) cpu_profile=amd ;;
  *) cpu_profile=unknown ;;
esac
gpu_profile=unknown
if grep -qi NVIDIA <<<"$gpu_info"; then gpu_profile=nvidia
elif grep -qiE 'AMD|ATI|Radeon' <<<"$gpu_info"; then gpu_profile=amd
elif grep -qi Intel <<<"$gpu_info"; then gpu_profile=intel
fi
form_factor=desktop
if compgen -G '/sys/class/power_supply/BAT*' >/dev/null; then form_factor=laptop; fi
printf 'Redstone OS hardware report\n'
printf 'Architecture: %s\nCPU vendor: %s (%s profile)\nGPU profile: %s\nForm factor: %s\n' \
  "$arch" "$cpu_vendor" "$cpu_profile" "$gpu_profile" "$form_factor"
if [[ -n "$gpu_info" ]]; then
  printf '\nDetected graphics devices:\n%s\n' "$gpu_info"
else
  printf '\nGraphics devices: unavailable (install pciutils)\n'
fi
if [[ "$arch" == aarch64 ]]; then
  printf '\nARM64 detected. FEX is optional and is not installed automatically.\n'
fi
printf '\nRead-only report: no drivers or firmware were installed or changed.\n'
