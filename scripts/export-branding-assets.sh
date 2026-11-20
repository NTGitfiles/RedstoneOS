#!/usr/bin/env bash
set -Eeuo pipefail

ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
THEME_DIR="$ROOT_DIR/source/omarchy/themes/redstone"
BRANDING_OUT="$ROOT_DIR/output/branding"
DESKTOP_WALLPAPER="$THEME_DIR/backgrounds/redstone.png"
THEME_INTRO="$THEME_DIR/backgrounds/intros/redstone.mp4"

for asset in "$DESKTOP_WALLPAPER" "$THEME_INTRO"; do
  [[ -s "$asset" ]] || {
    printf 'ERROR: expected generated Redstone asset is missing: %s\n' "$asset" >&2
    exit 1
  }
done

if command -v magick >/dev/null 2>&1; then
  IM=magick
elif command -v convert >/dev/null 2>&1; then
  IM=convert
else
  echo "ERROR: ImageMagick is required to render the Pixel 7a wallpaper." >&2
  exit 1
fi

mkdir -p "$BRANDING_OUT"
cp -- "$DESKTOP_WALLPAPER" "$BRANDING_OUT/redstone-desktop-2560x1440.png"
cp -- "$THEME_INTRO" "$BRANDING_OUT/redstone-theme-intro.mp4"

# Pixel 7a native portrait canvas: 1080x2400 (20:9).
# Keep the upper portion quiet for the lock-screen clock and notifications.
cat > "$BRANDING_OUT/redstone-pixel-7a.svg" <<'SVG'
<svg xmlns="http://www.w3.org/2000/svg" width="1080" height="2400" viewBox="0 0 1080 2400">
  <defs>
    <linearGradient id="bg" x1="0" y1="0" x2="0.9" y2="1">
      <stop offset="0" stop-color="#08090d"/>
      <stop offset=".48" stop-color="#171116"/>
      <stop offset="1" stop-color="#09080b"/>
    </linearGradient>
    <radialGradient id="planet">
      <stop offset="0" stop-color="#ff604b"/>
      <stop offset=".55" stop-color="#b52c30"/>
      <stop offset="1" stop-color="#40151e"/>
    </radialGradient>
    <radialGradient id="halo">
      <stop offset="0" stop-color="#e34b3f" stop-opacity=".38"/>
      <stop offset="1" stop-color="#e34b3f" stop-opacity="0"/>
    </radialGradient>
    <linearGradient id="ridge" x1="0" y1="0" x2="1" y2="1">
      <stop offset="0" stop-color="#ef6452"/>
      <stop offset="1" stop-color="#3b2028"/>
    </linearGradient>
  </defs>
  <rect width="1080" height="2400" fill="url(#bg)"/>
  <ellipse cx="560" cy="1650" rx="650" ry="720" fill="url(#halo)"/>
  <circle cx="540" cy="1510" r="440" fill="url(#planet)" opacity=".92"/>
  <path d="M0 1770 170 1570 260 1660 390 1430 500 1600 625 1370 770 1595 900 1490 1080 1690V2400H0Z" fill="#0c0b10"/>
  <path d="m0 1770 170-200 90 90 130-230 110 170 125-230 145 225 130-105 180 200" fill="none" stroke="url(#ridge)" stroke-width="12" opacity=".9"/>
  <path d="M0 1880Q260 1760 540 1890T1080 1840V2400H0Z" fill="#08090c" opacity=".94"/>
  <g transform="translate(540 1190)">
    <path d="M0-190 165-95 165 95 0 190-165 95-165-95Z" fill="#171116" stroke="#ff6658" stroke-opacity=".65" stroke-width="7"/>
    <path d="M0-145 126-72 126 72 0 145-126 72-126-72Z" fill="#e34b3f"/>
    <path d="M0-145 126-72 0 0-126-72Z" fill="#ff8a69"/>
    <path d="M-126-72 0 0V145L-126 72Z" fill="#a52e30"/>
    <path d="M126-72 0 0V145L126 72Z" fill="#70242a"/>
    <path d="M0-74 65-37 65 37 0 74-65 37-65-37Z" fill="#171116" stroke="#ffd0a7" stroke-width="5"/>
  </g>
  <g fill="#f5eeeb" text-anchor="middle" font-family="sans-serif">
    <text x="540" y="1985" font-size="54" letter-spacing="12">REDSTONE OS</text>
    <text x="540" y="2045" font-size="21" letter-spacing="7" opacity=".58">BUILT ON OPEN SOURCE</text>
  </g>
  <path d="M300 2110H780" stroke="#e34b3f" stroke-opacity=".65" stroke-width="3"/>
</svg>
SVG

"$IM" "$BRANDING_OUT/redstone-pixel-7a.svg" -resize '1080x2400!' "$BRANDING_OUT/redstone-pixel-7a.png"
[[ -s "$BRANDING_OUT/redstone-pixel-7a.png" ]] || {
  echo "ERROR: Pixel 7a wallpaper rendering failed." >&2
  exit 1
}
rm -- "$BRANDING_OUT/redstone-pixel-7a.svg"

cat > "$BRANDING_OUT/README.txt" <<'TXT'
Redstone OS generated branding assets
- redstone-desktop-2560x1440.png: desktop wallpaper
- redstone-theme-intro.mp4: six-second Omarchy theme activation intro
- redstone-pixel-7a.png: 1080x2400 Google Pixel 7a portrait wallpaper
All files are generated/exported by the Redstone OS GitHub Actions build.
TXT

printf 'Generated branding assets:\n'
ls -lh "$BRANDING_OUT"
