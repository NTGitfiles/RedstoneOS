# Building Redstone OS

## Build host

The initial builder targets an Arch Linux environment with Bash, Git, and the ArchISO/Omarchy ISO build dependencies available. Use a disposable or dedicated build environment.

## Build flow

1. Check required host tools.
2. Initialise the three pinned upstream Git submodules under `source/` (or clone them if building from a source archive without submodule metadata).
3. Revert only patches that this builder previously applied, then reject unrelated local modifications.
4. Apply Redstone-maintained patches.
5. Invoke the upstream ISO builder with the local source directories.

The build script does not enable OEM provisioning and does not select a target disk.

## Reproducibility

The default refs are immutable commit IDs recorded in `.gitmodules`, the submodule gitlinks and `source/UPSTREAMS.lock`: Omarchy tag `v4.5.0`, package repository release commit, and ISO builder commit from the 4.5.0 release window. These can be overridden with `REDSTONE_OMARCHY_REF`, `REDSTONE_PKGS_REF`, and `REDSTONE_ISO_REF` only when intentionally testing a different source combination.

## Current status

The upstream source integration is pinned to Omarchy 4.5.0, but the Redstone distribution work remains a scaffold. It delegates ISO construction to the pinned upstream builder and does not yet implement Redstone-specific branding, package policy or hardware profiles. The source pins have not yet been exercised in a full ISO build.
