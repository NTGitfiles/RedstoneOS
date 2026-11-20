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
git clone https://github.com/NTGitfiles/RedstoneOS.git
cd RedstoneOS
./scripts/build.sh
```

The build script checks prerequisites, fetches the upstream repositories into the ignored `source/` directory, then invokes Omarchy ISO's own build entry point using the local source checkouts.

Build output and upstream checkouts are intentionally not committed.

## Project layout

- `config/` — Redstone branding, package selections and hardware policy
- `patches/` — Redstone-maintained patches for upstream projects
- `scripts/` — build, verification and cleanup helpers
- `source/` — local upstream checkouts (ignored by Git)
- `output/` — generated ISO artifacts (ignored by Git)
- `docs/` — design notes and build documentation

## Important

This is an early project scaffold, not yet a finished Redstone-branded operating system. Redstone branding, package choices, hardware profiles and patches must be implemented and tested before claiming a release.

The standard ISO build path is used. OEM provisioning is deliberately not enabled.

## License

No project license has been selected yet. Upstream components retain their own licenses.
