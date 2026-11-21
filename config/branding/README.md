# Redstone OS branding pack

Run `bash scripts/generate-branding-assets.sh` with ImageMagick, Python 3, FFmpeg and Manim Community Edition installed.

The generator creates 20 distinct 2560x1440 wallpapers and 20 corresponding Manim animations (`RedstoneMotion01.mp4` through `RedstoneMotion20.mp4`), plus a 3440x1440 ultrawide wallpaper and a 1080x2400 Google Pixel 7a wallpaper.

Wallpaper titles use a fixed measured width and generous horizontal margins so the full **REDSTONE OS** name remains visible. Editable sources are in `scripts/redstone-wallpapers.py` and `scripts/redstone-intro.py`. GitHub Actions publishes the complete `output/branding/` directory.
