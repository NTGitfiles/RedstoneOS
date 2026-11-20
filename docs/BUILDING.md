# Building Redstone OS

## Build host

The initial builder targets an Arch Linux environment with Bash, Git, and the ArchISO/Omarchy ISO build dependencies available. Use a disposable or dedicated build environment.

## Build flow

1. Check required host tools.
2. Clone or update the three upstream repositories under `source/`.
3. Revert only patches that this builder previously applied, then reject unrelated local modifications.
4. Apply Redstone-maintained patches.
5. Invoke the upstream ISO builder with the local source directories.

The build script does not enable OEM provisioning and does not select a target disk.

## Reproducibility

The default refs track the upstream branches (`quattro`, `master`, `quattro`). For a release build, set `REDSTONE_OMARCHY_REF`, `REDSTONE_PKGS_REF`, and `REDSTONE_ISO_REF` to immutable tags or commit IDs after validating compatibility.

## Current status

This is a scaffold. It fetches upstream sources and delegates ISO construction, but it does not yet implement Redstone-specific branding, package policy or hardware profiles. Validate the upstream build interface against the exact checked-out Omarchy ISO revision before producing a release.
