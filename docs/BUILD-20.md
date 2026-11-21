# Build 20: package integration and platform groundwork

## Implemented in this branch
- A read-only hardware report for CPU vendor, graphics devices, architecture and laptop battery presence.
- Optional package groups with checks against the currently configured official pacman repositories.
- Explicit confirmation before installing packages; unavailable and AUR-only names are skipped and reported.
- Hardware-specific CPU and GPU groups guarded by local hardware detection.
- Static validation for Bash syntax, TOML files and package-list tokens.
- Build target selection for x86_64 and aarch64 through the pinned upstream ISO builder.
- Documentation clarifying inherited Omarchy installer and Limine bootloader behaviour, plus existing upstream package overlap.

## Deliberately not automatic
- AUR helpers or third-party repositories.
- Proprietary driver installation without a manual hardware check.
- Power-manager switching.
- Bootloader replacement.
- Unverified emulator forks or proprietary game firmware.
- Raspberry Pi 5 board enablement.

## Validation

Run on Linux with Bash and Python 3.11 or newer:

```bash
bash scripts/verify.sh
bash scripts/detect-hardware.sh
bash scripts/install-redstone-extras.sh --list
bash scripts/install-redstone-extras.sh --dry-run gaming terminal
```

On an Arch-based Redstone installation, install selected available packages with:

```bash
bash scripts/install-redstone-extras.sh gaming terminal
```

Build x86_64:

```bash
REDSTONE_ARCH=x86_64 bash scripts/build.sh
```

Build the upstream generic aarch64 target (requires Docker with ARM64 emulation):

```bash
REDSTONE_ARCH=aarch64 bash scripts/build.sh
```

The aarch64 ISO is a generic upstream ARM64 image. Raspberry Pi 5 still needs explicit board boot-chain, firmware, kernel/device-tree, graphics, networking and storage validation before it can be advertised as Pi-ready.

The optional package helper is currently a repository tool, not yet bundled into the installed image. The branch must pass GitHub Actions and a VM installation test before its changes are merged into the active build branch.
