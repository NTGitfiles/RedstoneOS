# Redstone OS

Redstone OS is a custom, reproducible Linux distribution project built on the Omarchy/Arch Linux ecosystem.

The initial build system keeps upstream source checkouts separate from Redstone-owned configuration and patches. It does not copy or fork the complete upstream repositories into this repository.

## Upstream

- [Omarchy](https://github.com/omacom/omarchy) — branch: `quattro`
- [Omarchy Packages](https://github.com/omacom/omarchy-pkgs) — branch: `master`
- [Omarchy ISO](https://github.com/omacom/omarchy-iso) — branch: `quattro`

The defaults track those branches. Set the corresponding `REDSTONE_*_REF` environment variables to select a tag or commit for a reproducible build.

## Quick start

Run on a supported Arch Linux build host:

```bash
git clone --recurse-submodules https://github.com/NTGitfiles/RedstoneOS.git
cd RedstoneOS
bash scripts/build.sh
```

The official Omarchy 4.5.0 source, its matching package repository snapshot, and the ISO builder snapshot are tracked as pinned Git submodules under `source/`. The build script initialises those submodules, verifies the pinned revisions, applies Redstone-maintained patches, then invokes Omarchy ISO's own build entry point using the local source checkouts.

Use `git clone --recurse-submodules` to fetch all source code in one go. A normal clone also works because the build script initialises the submodules.

Build output and upstream checkouts are intentionally not committed.

## Project layout

- `config/` — Redstone branding, package selections and hardware policy
- `patches/` — Redstone-maintained patches for upstream projects
- `scripts/` — build, verification and cleanup helpers
- `source/omarchy` — Omarchy 4.5.0 source (pinned submodule)
- `source/omarchy-pkgs` — package definitions at the 4.5.0 release commit (pinned submodule)
- `source/omarchy-iso` — ISO builder at the 4.5.0 release-time commit (pinned submodule)
- `source/UPSTREAMS.lock` — human-readable revision manifest
- `output/` — generated ISO artifacts (ignored by Git)
- `docs/` — design notes and build documentation

## Important

This repository now contains pinned Git submodule references to the actual Omarchy 4.5.0 source and matching release-time package/ISO sources. The upstream source files are fetched from their original repositories when submodules are initialised; they are not duplicated into Redstone's own Git history. This is not yet a finished Redstone-branded operating system. Redstone branding, package choices, hardware profiles and patches must be implemented and tested before claiming a release.

The standard ISO build path is used. OEM provisioning is deliberately not enabled.

## License

No project license has been selected yet. Upstream components retain their own licenses.
