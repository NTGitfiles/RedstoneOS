# Redstone OS

Redstone OS is a custom, reproducible Linux distribution project built on the Omarchy/Arch Linux ecosystem.

The initial build system keeps upstream source checkouts separate from Redstone-owned configuration and patches. It does not copy or fork the complete upstream repositories into this repository.

## Roadmap

The [Redstone OS Roadmap](docs/ROADMAP.md) tracks the complete non-application scope: visual identity, desktop configuration, hardware support, installer and first-boot experience, updates and recovery, security, and build/release infrastructure. These are planned work items, not claims of completed functionality. [Testing gates](docs/TESTING.md) define what must be validated before release.

## Upstream

- [Omarchy](https://github.com/omacom/omarchy) — release tag: `v4.5.0`
- [Omarchy Packages](https://github.com/omacom/omarchy-pkgs) — release commit: `9043460`
- [Omarchy ISO](https://github.com/omacom/omarchy-iso) — release-window commit: `d5136a6`

All three sources are pinned to immutable commit IDs in the submodule entries and `source/UPSTREAMS.lock`.

## Quick start

Run on a supported Arch Linux build host with ImageMagick installed (`sudo pacman -S imagemagick`):

```bash
git clone --recurse-submodules https://github.com/NTGitfiles/RedstoneOS.git
cd RedstoneOS
bash scripts/build.sh

# Optional generic ARM64 ISO build (requires Docker ARM64 emulation)
REDSTONE_ARCH=aarch64 bash scripts/build.sh
```

The build script generates the initial RedstoneOS dark theme and desktop wallpaper before invoking the upstream ISO builder. The standalone branding workflow produces a collection of desktop, ultrawide and Pixel 7a wallpapers, plus three animated Manim intro variants. These are uploaded together as a GitHub Actions artifact. A full ISO build has not yet been validated.

## Project layout

- `config/branding/` — Redstone visual identity and artwork inventory
- `config/packages/` — package policy groups
- `config/hardware/` — conservative hardware detection policy and device profiles
- `config/system/` — desktop, display, power and network defaults
- `config/installer/` — installation flow and safety requirements
- `config/security/` — security baseline policy
- `config/maintenance/` — updates, snapshots, rollback and recovery design
- `patches/` — Redstone-maintained patches for upstream projects
- `scripts/` — build, theme generation, hardware detection, optional package installation and verification helpers
- `source/` — pinned Omarchy, package and ISO-builder submodules
- `docs/ROADMAP.md` — full non-app feature list and implementation sequence
- `docs/TESTING.md` — build, VM, hardware, security and recovery test matrix

## Current status

The repository contains the complete non-application feature roadmap and configuration scaffolding for branding, desktop defaults, hardware profiles, installation, security, maintenance and recovery. The generated theme and pinned upstream integration still need full build validation. Installer, first-boot wizard, automatic hardware configuration, update/rollback and recovery tooling are not implemented yet.

Configuration files marked as policy or scaffold are not automatically applied to a running system. The application wishlist is kept separate from the compact upstream base. Optional package groups are checked against the current pacman repositories before installation; unavailable packages are skipped rather than sourced from unreviewed repositories. Hardware detection is read-only. The upstream ISO supports x86_64 and aarch64 builds; Raspberry Pi 5 board support remains unverified.

## Design principle

Redstone should reuse Omarchy functionality wherever it is reliable, while keeping its own identity, configuration, hardware policy and genuinely new features in this repository. Avoid unnecessary forks of upstream components.

## License

No project license has been selected yet. Upstream components retain their own licenses.
