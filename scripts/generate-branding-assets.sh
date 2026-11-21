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

command -v manim >/dev/null 2>&1 || {
  echo "Missing required tool: Manim Community Edition" >&2
  exit 1
}

# Desktop wallpaper: a custom pixel-art redstone world, not a generic stone logo.
cat > "$OUT/redstone-desktop.svg" <<'SVG'
<svg xmlns="http://www.w3.org/2000/svg" width="2560" height="1440" viewBox="0 0 2560 1440">
<defs>
 <linearGradient id="sky" x2="0" y2="1"><stop stop-color="#101c29"/><stop offset="1" stop-color="#080d14"/></linearGradient>
 <pattern id="pixels" width="128" height="128" patternUnits="userSpaceOnUse"><path d="M0 0H128V128H0Z" fill="none" stroke="#8193a4" stroke-opacity=".055" stroke-width="5"/><path d="M64 0V128M0 64H128" stroke="#8193a4" stroke-opacity=".025" stroke-width="3"/></pattern>
 <radialGradient id="redglow"><stop stop-color="#ff553e" stop-opacity=".38"/><stop offset="1" stop-color="#ff553e" stop-opacity="0"/></radialGradient>
</defs>
<rect width="2560" height="1440" fill="url(#sky)"/><rect width="2560" height="1440" fill="url(#pixels)"/>
<ellipse cx="1300" cy="700" rx="1050" ry="620" fill="url(#redglow)"/>
<!-- Floating block-built terrain -->
<g opacity=".85">
 <path d="M0 940H360V850H520V940H740V1080H0Z" fill="#17232b"/>
 <path d="M0 940H360V850H520V940H740" fill="none" stroke="#35434a" stroke-width="12"/>
 <path d="M1830 880H2040V760H2200V880H2560V1120H1830Z" fill="#18242c"/>
 <path d="M1830 880H2040V760H2200V880H2560" fill="none" stroke="#3a474d" stroke-width="12"/>
 <g fill="#31434a"><rect x="170" y="780" width="96" height="96"/><rect x="2180" y="640" width="96" height="96"/><rect x="2280" y="540" width="96" height="96"/></g>
</g>
<!-- Redstone dust circuit, stepped like a block-game build -->
<g fill="none" stroke-linecap="square" stroke-linejoin="miter">
 <path d="M180 1130H520V1010H760V890H1000V770H1240V890H1500V1010H1760V1130H2260" stroke="#542626" stroke-width="28"/>
 <path d="M180 1130H520V1010H760V890H1000V770H1240V890H1500V1010H1760V1130H2260" stroke="#f04b3e" stroke-width="9"/>
</g>
<g fill="#ff7655"><rect x="500" y="990" width="40" height="40"/><rect x="740" y="870" width="40" height="40"/><rect x="980" y="750" width="40" height="40"/><rect x="1220" y="870" width="40" height="40"/><rect x="1480" y="990" width="40" height="40"/><rect x="1740" y="1110" width="40" height="40"/></g>
<!-- Isometric redstone block -->
<g transform="translate(1280 590)">
 <path d="M0-270 245-135 0 0-245-135Z" fill="#ef8060" stroke="#ffb18a" stroke-width="8"/>
 <path d="M-245-135 0 0V270L-245 135Z" fill="#a43d35" stroke="#d65a46" stroke-width="8"/>
 <path d="M245-135 0 0V270L245 135Z" fill="#712b2e" stroke="#a9433b" stroke-width="8"/>
 <path d="M-85-145 0-190 85-145 0-100Z" fill="#ffb77d"/>
 <path d="M-85-145 0-100V-10L-85-55Z" fill="#e34b3f"/>
 <path d="M85-145 0-100V-10L85-55Z" fill="#a72d32"/>
 <path d="M0-65 62-30V42L0 78-62 42V-30Z" fill="#211b20" stroke="#ffc28e" stroke-width="7"/>
 <path d="M0-38 34-19V19L0 38-34 19V-19Z" fill="#ff543d"/>
</g>
<!-- Redstone torch -->
<g transform="translate(1280 185)"><rect x="-20" y="40" width="40" height="130" fill="#9c593d"/><rect x="-34" y="0" width="68" height="62" fill="#f04b3e"/><rect x="-16" y="15" width="32" height="30" fill="#ffc06b"/></g>
<g fill="#f6eee8" text-anchor="middle" font-family="DejaVu Sans Mono,monospace">
 <text x="1280" y="1260" font-size="76" font-weight="bold" textLength="850" lengthAdjust="spacingAndGlyphs">REDSTONE OS</text>
 <text x="1280" y="1320" font-size="25" letter-spacing="10" fill="#ff9272">POWERED BY REDSTONE</text>
</g>
</svg>
SVG
"$IM" "$OUT/redstone-desktop.svg" -strip "$OUT/redstone-desktop-2560x1440.png"

# Matching tall Pixel 7a wallpaper, composed for a phone lock screen.
cat > "$OUT/redstone-pixel-7a.svg" <<'SVG'
<svg xmlns="http://www.w3.org/2000/svg" width="1080" height="2400" viewBox="0 0 1080 2400">
<defs>
 <linearGradient id="bg" x2="0" y2="1"><stop stop-color="#101c29"/><stop offset=".65" stop-color="#11151c"/><stop offset="1" stop-color="#080d14"/></linearGradient>
 <radialGradient id="glow"><stop stop-color="#ff553e" stop-opacity=".48"/><stop offset="1" stop-color="#ff553e" stop-opacity="0"/></radialGradient>
 <pattern id="grid" width="90" height="90" patternUnits="userSpaceOnUse"><path d="M90 0H0V90" fill="none" stroke="#91a2ad" stroke-opacity=".06" stroke-width="3"/></pattern>
</defs>
<rect width="1080" height="2400" fill="url(#bg)"/><rect width="1080" height="2400" fill="url(#grid)"/>
<ellipse cx="540" cy="1300" rx="650" ry="700" fill="url(#glow)"/>
<g opacity=".8" fill="#1a2a33"><rect x="0" y="1550" width="230" height="170"/><rect x="850" y="1460" width="230" height="260"/><rect x="120" y="1380" width="100" height="100"/><rect x="860" y="1300" width="100" height="100"/></g>
<path d="M80 1700H260V1580H400V1460H540V1580H680V1700H1000" fill="none" stroke="#e34b3f" stroke-width="12" stroke-linejoin="miter"/>
<g transform="translate(540 1110)">
 <path d="M0-300 260-150 0 0-260-150Z" fill="#ef8060" stroke="#ffb18a" stroke-width="8"/>
 <path d="M-260-150 0 0V300L-260 150Z" fill="#a43d35" stroke="#d65a46" stroke-width="8"/>
 <path d="M260-150 0 0V300L260 150Z" fill="#712b2e" stroke="#a9433b" stroke-width="8"/>
 <path d="M0-75 70-35V45L0 85-70 45V-35Z" fill="#211b20" stroke="#ffc28e" stroke-width="7"/>
 <path d="M0-43 38-21V21L0 43-38 21V-21Z" fill="#ff543d"/>
</g>
<g transform="translate(540 680)"><rect x="-17" y="35" width="34" height="110" fill="#9c593d"/><rect x="-30" y="0" width="60" height="55" fill="#f04b3e"/><rect x="-14" y="13" width="28" height="27" fill="#ffc06b"/></g>
<g fill="#f6eee8" text-anchor="middle" font-family="DejaVu Sans Mono,monospace"><text x="540" y="1940" font-size="58" font-weight="bold" textLength="620" lengthAdjust="spacingAndGlyphs">REDSTONE OS</text><text x="540" y="2010" font-size="23" letter-spacing="5" fill="#ff9272">POWERED BY REDSTONE</text></g>
</svg>
SVG

"$IM" "$OUT/redstone-pixel-7a.svg" -strip "$OUT/redstone-pixel-7a-1080x2400.png"

# Additional matching wallpaper editions: a clean circuit blueprint and a warm redstone sunset.
cat > "$OUT/redstone-circuit-blueprint.svg" <<'SVG'
<svg xmlns="http://www.w3.org/2000/svg" width="2560" height="1440" viewBox="0 0 2560 1440">
<defs><linearGradient id="b" x2="1" y2="1"><stop stop-color="#0b1928"/><stop offset="1" stop-color="#10101a"/></linearGradient><pattern id="g" width="80" height="80" patternUnits="userSpaceOnUse"><path d="M80 0H0V80" fill="none" stroke="#54a8b5" stroke-opacity=".16" stroke-width="2"/></pattern><radialGradient id="r"><stop stop-color="#ff604b" stop-opacity=".35"/><stop offset="1" stop-color="#ff604b" stop-opacity="0"/></radialGradient></defs>
<rect width="2560" height="1440" fill="url(#b)"/><rect width="2560" height="1440" fill="url(#g)"/><ellipse cx="1280" cy="700" rx="900" ry="600" fill="url(#r)"/>
<g fill="none" stroke="#e95043" stroke-width="12" stroke-linejoin="round"><path d="M180 1080H480V900H760V720H1050V540H1450V720H1740V900H2070V1080H2380"/><path d="M480 900V1120H760V1260M1740 900V1120H2010V1260"/></g>
<g fill="#ffad78"><rect x="455" y="875" width="50" height="50"/><rect x="735" y="695" width="50" height="50"/><rect x="1025" y="515" width="50" height="50"/><rect x="1425" y="695" width="50" height="50"/><rect x="1715" y="875" width="50" height="50"/></g>
<g text-anchor="middle" font-family="DejaVu Sans Mono,monospace"><text x="1280" y="260" fill="#f5eee8" font-size="86" font-weight="bold" letter-spacing="12">REDSTONE OS</text><text x="1280" y="330" fill="#78c3c5" font-size="26" letter-spacing="12">SIGNAL. SYSTEM. SOLID.</text></g>
</svg>
SVG
"$IM" "$OUT/redstone-circuit-blueprint.svg" -strip "$OUT/redstone-circuit-blueprint-2560x1440.png"

cat > "$OUT/redstone-redstone-sunset.svg" <<'SVG'
<svg xmlns="http://www.w3.org/2000/svg" width="2560" height="1440" viewBox="0 0 2560 1440">
<defs><linearGradient id="s" x2="0" y2="1"><stop stop-color="#261b36"/><stop offset=".48" stop-color="#8b3e43"/><stop offset="1" stop-color="#171522"/></linearGradient><radialGradient id="sun"><stop stop-color="#ffbd79"/><stop offset="1" stop-color="#f15b45" stop-opacity="0"/></radialGradient></defs>
<rect width="2560" height="1440" fill="url(#s)"/><circle cx="1280" cy="610" r="520" fill="url(#sun)"/>
<g fill="#171b29"><path d="M0 930H320V780H510V930H760V1080H0Z"/><path d="M1740 900H1950V740H2140V900H2560V1120H1740Z"/></g>
<path d="M0 1110H420V1000H720V890H980V1000H1300V1110H1640V1000H1940V1110H2560" fill="none" stroke="#ff684f" stroke-width="16" stroke-linejoin="miter"/>
<g transform="translate(1280 640)"><path d="M0-220 205-105 0 10-205-105Z" fill="#ff9a6b"/><path d="M-205-105 0 10V235L-205 120Z" fill="#b74442"/><path d="M205-105 0 10V235L205 120Z" fill="#78313c"/><path d="M0-35 55-5V55L0 85-55 55V-5Z" fill="#ffcf91"/></g>
<text x="1280" y="1300" text-anchor="middle" font-family="DejaVu Sans Mono,monospace" font-size="82" font-weight="bold" letter-spacing="12" fill="#fff1e6">REDSTONE OS</text>
</svg>
SVG
"$IM" "$OUT/redstone-redstone-sunset.svg" -strip "$OUT/redstone-redstone-sunset-2560x1440.png"

# A high-resolution ultrawide crop for 21:9 displays.
"$IM" "$OUT/redstone-desktop-2560x1440.png" -resize '3440x1440^' -gravity center -extent 3440x1440 "$OUT/redstone-ultrawide-3440x1440.png"

# Manim renders the animated intro from the same visual language.
manim --renderer=cairo -ql --fps 30 -r 1920,1080 \
  "$ROOT_DIR/scripts/redstone-intro.py" RedstoneBootIntro RedstonePulseIntro RedstoneOrbitIntro
for SCENE in RedstoneBootIntro RedstonePulseIntro RedstoneOrbitIntro; do
  RENDERED="$(find "$ROOT_DIR/media/videos" -type f -name "$SCENE.mp4" -print -quit)"
  if [[ -z "$RENDERED" || ! -s "$RENDERED" ]]; then
    echo "Manim did not produce the expected intro video for $SCENE" >&2
    find "$ROOT_DIR/media/videos" -type f -name '*.mp4' -print >&2 || true
    exit 1
  fi
  cp "$RENDERED" "$OUT/$SCENE.mp4"
done

rm -f "$OUT/redstone-desktop.svg" "$OUT/redstone-pixel-7a.svg" "$OUT/redstone-circuit-blueprint.svg" "$OUT/redstone-redstone-sunset.svg"
cat > "$OUT/README.txt" <<'TXT'
Redstone OS Minecraft-inspired branding pack
- redstone-desktop-2560x1440.png: pixel-art desktop wallpaper
- redstone-theme-intro-manim.mp4: animated Manim redstone-circuit boot intro
- redstone-pixel-7a-1080x2400.png: Google Pixel 7a portrait wallpaper
Generated by the standalone GitHub Actions branding workflow.
TXT

echo "Branding generated (wallpapers and three intros):"
ls -lh "$OUT"
