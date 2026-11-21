#!/usr/bin/env bash
set -Eeuo pipefail
ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
OUT="$ROOT_DIR/output/branding"
mkdir -p "$OUT"
if command -v magick >/dev/null 2>&1; then IM=magick; elif command -v convert >/dev/null 2>&1; then IM=convert; else echo "Missing ImageMagick" >&2; exit 1; fi
command -v python3 >/dev/null 2>&1 || { echo "Missing Python 3" >&2; exit 1; }
command -v manim >/dev/null 2>&1 || { echo "Missing Manim Community Edition" >&2; exit 1; }
python3 "$ROOT_DIR/scripts/redstone-wallpapers.py"
for SVG in "$OUT"/redstone-wallpaper-*.svg; do "$IM" "$SVG" -strip "${SVG%.svg}.png"; done
# Device-specific bonus crops from edition 01.
"$IM" "$OUT/redstone-wallpaper-01-circuit-core.png" -resize '3440x1440^' -gravity center -extent 3440x1440 "$OUT/redstone-ultrawide-3440x1440.png"
"$IM" "$OUT/redstone-wallpaper-01-circuit-core.png" -resize '1080x2400^' -gravity center -extent 1080x2400 "$OUT/redstone-pixel-7a-1080x2400.png"
# Exactly twenty matching animated editions.
manim --renderer=cairo -ql --fps 24 -r 1280,720 -a "$ROOT_DIR/scripts/redstone-intro.py"
for N in $(seq -w 1 20); do
 SCENE="RedstoneMotion${N}"
 RENDERED="$(find "$ROOT_DIR/media/videos" -type f -name "$SCENE.mp4" -print -quit)"
 if [[ -z "$RENDERED" || ! -s "$RENDERED" ]]; then echo "Missing Manim output: $SCENE" >&2; exit 1; fi
 cp "$RENDERED" "$OUT/$SCENE.mp4"
done
rm -f "$OUT"/redstone-wallpaper-*.svg
cat > "$OUT/README.txt" <<'TXT'
Redstone OS branding pack:
20 distinct 2560x1440 wallpapers, 20 matching Manim animations
(RedstoneMotion01.mp4 through RedstoneMotion20.mp4), plus a 3440x1440
ultrawide wallpaper and a 1080x2400 Pixel 7a wallpaper.
All artwork is generated from editable sources in scripts/.
TXT
WC="$(find "$OUT" -maxdepth 1 -name 'redstone-wallpaper-*.png' | wc -l)"
AC="$(find "$OUT" -maxdepth 1 -name 'RedstoneMotion*.mp4' | wc -l)"
[[ "$WC" -eq 20 ]] || { echo "Expected 20 wallpapers, found $WC" >&2; exit 1; }
[[ "$AC" -eq 20 ]] || { echo "Expected 20 animations, found $AC" >&2; exit 1; }
echo "Generated $WC wallpapers and $AC matching Manim animations."
ls -lh "$OUT"
