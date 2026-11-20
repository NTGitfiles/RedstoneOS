# Testing and release gates

No full ISO build or hardware compatibility claim should be made until the following checks pass.

## Build host and source integrity
- [ ] Clean clone with recursive submodules.
- [ ] Verify each submodule is at the revision recorded in `source/UPSTREAMS.lock`.
- [ ] Run shell syntax checks on every Bash script.
- [ ] Run `scripts/verify.sh`.
- [ ] Generate the theme twice and confirm safe replacement of only marked generated output.
- [ ] Confirm an unrelated pre-existing theme directory is never overwritten.

## ISO and virtual machine
- [ ] Complete a full ISO build from pinned sources.
- [ ] Verify the generated ISO checksum and boot it in a UEFI VM.
- [ ] Test legacy BIOS where supported by the upstream builder.
- [ ] Verify boot menu, theme, networking, audio and desktop session.
- [ ] Test installation into a disposable virtual disk.
- [ ] Test Btrfs and encrypted installation paths before release.

## Hardware matrix
- [ ] Intel integrated graphics.
- [ ] AMD integrated/discrete graphics.
- [ ] Supported NVIDIA generations and driver/kernel combinations.
- [ ] Laptop battery, lid, suspend and resume.
- [ ] Touchpad, touchscreen, stylus and HiDPI.
- [ ] Multiple displays and mixed scaling.
- [ ] Audio devices, Bluetooth audio and external peripherals.
- [ ] Wi-Fi, Ethernet, printers and scanners.

## Security and recovery
- [ ] Confirm firewall policy and enabled services.
- [ ] Confirm updates use trusted signed repositories.
- [ ] Test snapshot creation and rollback on supported Btrfs layouts.
- [ ] Test recovery media and boot repair.
- [ ] Check diagnostic bundles for secrets and personal data.

A checkbox is only complete when test evidence is recorded. Do not mark a feature implemented merely because its configuration file exists.
