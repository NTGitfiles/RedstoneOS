#!/usr/bin/env bash
set -Eeuo pipefail

ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
OUT="$ROOT_DIR/output/branding"
mkdir -p "$OUT"

if command -v magick >/dev/null 2>&1; then
  IM=magick
elif command -v convert >/dev/null 2>&1; then
  IM=convert
else
  echo "Missing required tool: ImageMagick (magick or convert)" >&2
  exit 1
fi

command -v ffmpeg >/dev/null 2>&1 || {
  echo "Missing required tool: ffmpeg" >&2
  exit 1
}

# Desktop wallpaper, rendered at native 2560x1440.
cat > "$OUT/redstone-desktop.svg" <<'SVG'
<svg xmlns="http://www.w3.org/2000/svg" width="2560" height="1440" viewBox="0 0 2560 1440">
<defs>
 <linearGradient id="bg" x2="1" y2="1"><stop stop-color="#292124"/><stop offset=".52" stop-color="#171416"/><stop offset="1" stop-color="#090809"/></linearGradient>
 <linearGradient id="stone" x2="1" y2="1"><stop stop-color="#ff9270"/><stop offset="1" stop-color="#8f2928"/></linearGradient>
 <radialGradient id="glow"><stop stop-color="#e34b3f" stop-opacity=".4"/><stop offset="1" stop-color="#e34b3f" stop-opacity="0"/></radialGradient>
 <pattern id="grid" width="96" height="96" patternUnits="userSpaceOnUse"><path d="M96 0H0V96" fill="none" stroke="#fff" stroke-opacity=".035" stroke-width="2"/></pattern>
</defs>
<rect width="2560" height="1440" fill="url(#bg)"/><rect width="2560" height="1440" fill="url(#grid)"/>
<ellipse cx="1280" cy="680" rx="900" ry="700" fill="url(#glow)"/>
<g transform="translate(1280 650)">
 <path d="M0-390 338-195V195L0 390-338 195V-195Z" fill="none" stroke="#e34b3f" stroke-opacity=".28" stroke-width="6"/>
 <path d="M0-290 251-145V145L0 290-251 145V-145Z" fill="#171416" stroke="#713532" stroke-width="9"/>
 <path d="M0-225 195-112V112L0 225-195 112V-112Z" fill="url(#stone)"/>
 <path d="M0-225 195-112 0 0-195-112Z" fill="#ffb08a"/>
 <path d="M-195-112 0 0V225L-195 112Z" fill="#a53230"/>
 <path d="M195-112 0 0V225L195 112Z" fill="#6f2425"/>
 <path d="M0-120 104-60V60L0 120-104 60V-60Z" fill="#171416" stroke="#ffd0a7" stroke-width="7"/>
 <path d="M0-65 56-32V32L0 65-56 32V-32Z" fill="#e34b3f"/>
</g>
<g fill="#f5eeeb" text-anchor="middle" font-family="sans-serif"><text x="1280" y="1110" font-size="68" letter-spacing="24">REDSTONE OS</text><text x="1280" y="1170" font-size="23" letter-spacing="11" opacity=".55">BUILT ON OPEN SOURCE</text></g>
<path d="M930 1220H1630" stroke="#e34b3f" stroke-opacity=".6" stroke-width="3"/>
</svg>
SVG
"$IM" "$OUT/redstone-desktop.svg" -strip "$OUT/redstone-desktop-2560x1440.png"

# Animated six-second theme intro using the same generated desktop artwork.
ffmpeg -hide_banner -loglevel error -y -loop 1 -framerate 30 \
  -i "$OUT/redstone-desktop-2560x1440.png" \
  -vf "scale=1920:1080:force_original_aspect_ratio=increase,crop=1920:1080,zoompan=z='1+0.045*(0.5-0.5*cos(2*PI*on/180))':x='iw/2-(iw/zoom/2)':y='ih/2-(ih/zoom/2)':d=1:s=1920x1080:fps=30,fade=t=in:st=0:d=0.7,fade=t=out:st=5.3:d=0.7,format=yuv420p" \
  -t 6 -an -c:v libx264 -preset veryfast -crf 20 -movflags +faststart \
  "$OUT/redstone-theme-intro-6s.mp4"

# Google Pixel 7a portrait wallpaper, 1080x2400.
cat > "$OUT/redstone-pixel-7a.svg" <<'SVG'
<svg xmlns="http://www.w3.org/2000/svg" width="1080" height="2400" viewBox="0 0 1080 2400">
<defs>
 <linearGradient id="bg" x2=".8" y2="1"><stop stop-color="#09090d"/><stop offset=".55" stop-color="#211419"/><stop offset="1" stop-color="#08090c"/></linearGradient>
 <radialGradient id="glow"><stop stop-color="#e34b3f" stop-opacity=".5"/><stop offset="1" stop-color="#e34b3f" stop-opacity="0"/></radialGradient>
 <linearGradient id="gem" x2="1" y2="1"><stop stop-color="#ff9a70"/><stop offset="1" stop-color="#8f2928"/></linearGradient>
</defs>
<rect width="1080" height="2400" fill="url(#bg)"/>
<ellipse cx="540" cy="1500" rx="620" ry="760" fill="url(#glow)"/>
<circle cx="540" cy="1460" r="390" fill="#32171d" stroke="#b9433a" stroke-opacity=".35" stroke-width="4"/>
<g transform="translate(540 1450)">
 <path d="M0-330 286-165V165L0 330-286 165V-165Z" fill="#171116" stroke="#e34b3f" stroke-width="8"/>
 <path d="M0-255 221-127V127L0 255-221 127V-127Z" fill="url(#gem)"/>
 <path d="M0-255 221-127 0 0-221-127Z" fill="#ffb08a"/>
 <path d="M-221-127 0 0V255L-221 127Z" fill="#a53230"/>
 <path d="M221-127 0 0V255L221 127Z" fill="#70242a"/>
 <path d="M0-105 91-52V52L0 105-91 52V-52Z" fill="#171116" stroke="#ffd0a7" stroke-width="7"/>
</g>
<path d="M0 1840Q270 1690 540 1850T1080 1810V2400H0Z" fill="#09090d" opacity=".9"/>
<g fill="#f5eeeb" text-anchor="middle" font-family="sans-serif"><text x="540" y="2040" font-size="52" letter-spacing="12">REDSTONE OS</text><text x="540" y="2100" font-size="21" letter-spacing="7" opacity=".55">BUILT ON OPEN SOURCE</text></g>
<path d="M300 2160H780" stroke="#e34b3f" stroke-opacity=".65" stroke-width="3"/>
</svg>
SVG
"$IM" "$OUT/redstone-pixel-7a.svg" -strip "$OUT/redstone-pixel-7a-1080x2400.png"
rm -f "$OUT/redstone-desktop.svg" "$OUT/redstone-pixel-7a.svg"

cat > "$OUT/README.txt" <<'TXT'
Redstone OS branding pack
- redstone-desktop-2560x1440.png: desktop wallpaper
- redstone-theme-intro-6s.mp4: six-second animated theme intro
- redstone-pixel-7a-1080x2400.png: Google Pixel 7a portrait wallpaper
Generated by the standalone GitHub Actions branding workflow.
TXT

echo "Branding generated:"
ls -lh "$OUT"
