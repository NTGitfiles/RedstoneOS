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

for command in git bash ffmpeg; do
  command -v "$command" >/dev/null 2>&1 || die "Required command not found: $command"
done

[[ "$(uname -m)" == "x86_64" ]] || die "This initial build wrapper currently targets x86_64 hosts."
mkdir -p "$SOURCE_DIR" "$OUTPUT_DIR"

# Populate pinned upstream source gitlinks recorded in this repository.
git -C "$ROOT_DIR" submodule update --init --recursive

# The generated theme lives inside the Omarchy source tree so the upstream
# ISO builder packages it. Remove only our own previous generated output
# before checking the submodule for unrelated local modifications.
GENERATED_THEME_DIR="$SOURCE_DIR/omarchy/themes/redstone"
remove_generated_theme() {
  if [[ -f "$GENERATED_THEME_DIR/.redstone-generated" ]]; then
    info "Removing previous generated Redstone theme"
    rm -rf -- "$GENERATED_THEME_DIR"
  fi
}

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
    if [[ "$name" == "omarchy" ]]; then
      remove_generated_theme
    fi
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

generate_redstone_theme() {
  local theme_dir="$GENERATED_THEME_DIR"
  local backgrounds_dir="$theme_dir/backgrounds"
  local wallpaper_svg="$backgrounds_dir/redstone.svg"
  local wallpaper_png="$backgrounds_dir/redstone.png"
  local intro_dir="$backgrounds_dir/intros"
  local intro_video="$intro_dir/redstone.mp4"
  local renderer=""

  if command -v magick >/dev/null 2>&1; then
    renderer="magick"
  elif command -v convert >/dev/null 2>&1; then
    renderer="convert"
  else
    die "The Redstone theme generator needs ImageMagick (install the imagemagick package)."
  fi

  if [[ -e "$theme_dir" ]]; then
    [[ -f "$theme_dir/.redstone-generated" ]] || die "Refusing to overwrite an existing upstream theme: $theme_dir"
    rm -rf -- "$theme_dir"
  fi

  info "Generating RedstoneOS theme and 2560x1440 wallpaper"
  mkdir -p "$backgrounds_dir"
  : > "$theme_dir/.redstone-generated"

  cat > "$theme_dir/colors.toml" <<'TOML'
mode = "dark"

accent = "#e34b3f"
selection = "#492522"
muted = "#8c5149"

background = "#171416"
dark_background = "#100e10"
darker_background = "#090809"
lighter_background = "#292326"

foreground = "#eee6e2"
dark_foreground = "#9c8c87"
light_foreground = "#f5eeeb"
bright_foreground = "#fff8f4"

red = "#e34b3f"
yellow = "#f2b45f"
orange = "#ed794d"
green = "#9dbb78"
cyan = "#76b7b2"
blue = "#7898c8"
magenta = "#c18ab4"
brown = "#8b5545"

bright_red = "#ff6658"
bright_yellow = "#ffd080"
bright_green = "#b5d98b"
bright_cyan = "#91d4ce"
bright_blue = "#91b4e8"
bright_magenta = "#e0a4d2"
TOML

  cat > "$wallpaper_svg" <<'SVG'
<svg xmlns="http://www.w3.org/2000/svg" width="2560" height="1440" viewBox="0 0 2560 1440">
  <defs>
    <linearGradient id="base" x1="0" y1="0" x2="1" y2="1">
      <stop offset="0" stop-color="#292124"/>
      <stop offset="0.52" stop-color="#171416"/>
      <stop offset="1" stop-color="#090809"/>
    </linearGradient>
    <linearGradient id="stone" x1="0" y1="0" x2="1" y2="1">
      <stop offset="0" stop-color="#f06a50"/>
      <stop offset="1" stop-color="#8f2928"/>
    </linearGradient>
    <radialGradient id="glow">
      <stop offset="0" stop-color="#e34b3f" stop-opacity=".32"/>
      <stop offset="1" stop-color="#e34b3f" stop-opacity="0"/>
    </radialGradient>
    <pattern id="grid" width="96" height="96" patternUnits="userSpaceOnUse">
      <path d="M96 0H0V96" fill="none" stroke="#f5eeeb" stroke-opacity=".035" stroke-width="2"/>
    </pattern>
  </defs>
  <rect width="2560" height="1440" fill="url(#base)"/>
  <rect width="2560" height="1440" fill="url(#grid)"/>
  <ellipse cx="1280" cy="720" rx="850" ry="650" fill="url(#glow)"/>
  <g transform="translate(1280 690)">
    <path d="M0-390 338-195 338 195 0 390-338 195-338-195Z" fill="none" stroke="#e34b3f" stroke-opacity=".22" stroke-width="5"/>
    <path d="M0-300 260-150 260 150 0 300-260 150-260-150Z" fill="#171416" stroke="#6f3431" stroke-width="8"/>
    <path d="M0-235 204-117 204 117 0 235-204 117-204-117Z" fill="url(#stone)"/>
    <path d="M0-235 204-117 0 0-204-117Z" fill="#ff8a69" fill-opacity=".9"/>
    <path d="M-204-117 0 0V235L-204 117Z" fill="#9d302c"/>
    <path d="M204-117 0 0V235L204 117Z" fill="#6f2425"/>
    <path d="M0-126 110-63 110 63 0 126-110 63-110-63Z" fill="#171416" stroke="#ffc18a" stroke-width="7"/>
    <path d="M0-72 62-36 62 36 0 72-62 36-62-36Z" fill="#e34b3f"/>
  </g>
  <g fill="#f5eeeb" fill-opacity=".68" font-family="sans-serif" text-anchor="middle">
    <text x="1280" y="1190" font-size="62" letter-spacing="22">REDSTONE</text>
    <text x="1280" y="1250" font-size="22" letter-spacing="10" fill-opacity=".42">BUILT ON OPEN SOURCE</text>
  </g>
  <path d="M930 1300H1630" stroke="#e34b3f" stroke-opacity=".55" stroke-width="3"/>
</svg>
SVG

  if [[ "$renderer" == "magick" ]]; then
    magick "$wallpaper_svg" -resize '2560x1440!' "$wallpaper_png"
    magick "$wallpaper_png" -resize '960x540!' "$theme_dir/preview.png"
  else
    convert "$wallpaper_svg" -resize '2560x1440!' "$wallpaper_png"
    convert "$wallpaper_png" -resize '960x540!' "$theme_dir/preview.png"
  fi

  [[ -s "$wallpaper_png" && -s "$theme_dir/preview.png" ]] || die "Theme wallpaper generation failed."

  info "Rendering six-second Redstone theme intro for Omarchy 4.5"
  mkdir -p "$intro_dir"
  ffmpeg -hide_banner -loglevel error -y \\
    -loop 1 -framerate 30 -i "$wallpaper_png" \\
    -vf "scale=1920:1080:force_original_aspect_ratio=increase,crop=1920:1080,zoompan=z='1+0.035*(0.5-0.5*cos(2*PI*on/180))':x='iw/2-(iw/zoom/2)':y='ih/2-(ih/zoom/2)':d=1:s=1920x1080:fps=30,eq=brightness='0.015*sin(2*PI*t/3)':eval=frame,fade=t=in:st=0:d=0.8,fade=t=out:st=5.4:d=0.6,format=yuv420p" \\
    -t 6 -an -c:v libx264 -preset veryfast -crf 20 -movflags +faststart "$intro_video"

  [[ -s "$intro_video" ]] || die "Redstone theme intro generation failed."
  printf 'Generated theme: %s\n' "$theme_dir"
  printf 'Generated wallpaper: %s\n' "$wallpaper_png"
  printf 'Generated theme intro: %s\n' "$intro_video"
}

generate_redstone_theme

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
  "$ISO_BUILDER" --keep-pkg-cache --local-source "$SOURCE_DIR/omarchy" "$SOURCE_DIR/omarchy-pkgs"
)

info "Build command completed. Check the upstream builder output for the generated ISO location."
printf 'Redstone output directory: %s\n' "$OUTPUT_DIR"
printf 'Note: upstream output is not automatically moved into output/ by this scaffold.\n'
