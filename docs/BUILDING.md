# Building Redstone OS

## Build host

The initial builder targets an Arch Linux environment with Bash, Git, and the ArchISO/Omarchy ISO build dependencies available. Install ImageMagick (`imagemagick` on Arch) as well; the Redstone theme generator uses it to render the wallpaper PNG. Use a disposable or dedicated build environment.

## Build flow

1. Check required host tools.
2. Initialise the three pinned upstream Git submodules under `source/` (or clone them if building from a source archive without submodule metadata).
3. Revert only patches that this builder previously applied, then reject unrelated local modifications.
4. Generate the RedstoneOS dark theme, its 2560x1440 wallpaper, and a theme preview inside the Omarchy source tree.
5. Apply Redstone-maintained patches.
6. Invoke the upstream ISO builder with the local source directories.

The generated theme is named `redstone` and is built from `themes/redstone/colors.toml`, `themes/redstone/backgrounds/redstone.png`, and `themes/redstone/preview.png`. The SVG wallpaper source is kept alongside the PNG. The generator only removes its own output, identified by `.redstone-generated`, on the next build. It refuses to overwrite a theme directory that it did not create.

The build script does not enable OEM provisioning and does not select a target disk.

## Reproducibility

The default refs are immutable commit IDs recorded in `.gitmodules`, the submodule gitlinks and `source/UPSTREAMS.lock`: Omarchy tag `v4.5.0`, package repository release commit, and ISO builder commit from the 4.5.0 release window. These can be overridden with `REDSTONE_OMARCHY_REF`, `REDSTONE_PKGS_REF`, and `REDSTONE_ISO_REF` only when intentionally testing a different source combination.

## Current status

The upstream source integration is pinned to Omarchy 4.5.0, and the build script now generates the initial RedstoneOS theme and wallpaper. Redstone-specific package policy and hardware profiles remain scaffold placeholders. The source pins and generated theme have not yet been exercised in a full ISO build.
