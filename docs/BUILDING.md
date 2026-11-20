# Building Redstone OS

## Build host

The initial builder targets an Arch Linux environment with Bash, Git, and the ArchISO/Omarchy ISO build dependencies available. Install ImageMagick (`imagemagick` on Arch) as well; the Redstone theme generator uses it to render the wallpaper PNG. Use a disposable or dedicated build environment.

## Build flow

1. Check required host tools.
2. Initialise the three pinned upstream Git submodules under `source/`.
3. Revert only patches that this builder previously applied, then reject unrelated local modifications.
4. Generate the RedstoneOS dark theme, wallpaper and preview inside the Omarchy source tree.
5. Apply Redstone-maintained patches.
6. Invoke the upstream ISO builder with the local source directories.

The generated theme is named `redstone`. Its generated marker prevents the builder from overwriting an unrelated upstream theme.

## Configuration ownership

Redstone-owned policy is kept outside the upstream submodules:

- `config/branding/`: identity, palette and artwork inventory.
- `config/packages/`: package groups. Lists remain empty until package names are verified.
- `config/hardware/`: detection policy and Intel, AMD, NVIDIA, laptop, touch, audio and peripheral profiles.
- `config/system/`: desktop, display, power, networking and accessibility defaults.
- `config/installer/`: installation flow and disk-safety requirements.
- `config/security/`: update, firewall, storage and permission policy.
- `config/maintenance/`: update, snapshot, rollback, diagnostics and recovery requirements.
- `patches/`: focused changes to pinned upstream repositories.

These files currently describe policy and intended behaviour. They are not yet consumed by a target-side provisioning service or installer.

## Reproducibility

The default refs are immutable commit IDs recorded in `.gitmodules`, the submodule gitlinks and `source/UPSTREAMS.lock`: Omarchy tag `v4.5.0`, package repository release commit, and ISO builder commit from the 4.5.0 release window. These can be overridden with `REDSTONE_OMARCHY_REF`, `REDSTONE_PKGS_REF`, and `REDSTONE_ISO_REF` only when intentionally testing a different source combination.

## Validation

Run:

```bash
bash -n scripts/*.sh
bash scripts/verify.sh
```

See [TESTING.md](TESTING.md) for the full ISO, virtual-machine, hardware, security and recovery test matrix.

## Current status

The upstream source integration is pinned to Omarchy 4.5.0 and the build script generates an initial RedstoneOS theme. A complete ISO build has not yet been validated. The feature inventory in [FEATURES.md](FEATURES.md) distinguishes implemented, scaffolded, validation-needed and planned work. Do not describe design documents or configuration placeholders as working system features.
