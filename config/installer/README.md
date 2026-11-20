# Installer and first boot

Redstone inherits the Omarchy ISO installer rather than replacing it with a second disk-writing installer. The pinned upstream ISO provides a configurator, writes a pre-built Btrfs root image to the selected target, grows the filesystem, applies per-machine packages and provisions the user. This avoids maintaining a competing destructive disk tool.

Redstone-specific work still required:
- Brand the live session, configurator and installation screens.
- Verify the exact destructive disk confirmation and encryption flows against the pinned upstream revision.
- Add Redstone's optional software selection without making the base install enormous.
- Run a first-boot handoff for the hardware report and optional package groups.
- Test BIOS/UEFI and Btrfs/encryption paths in disposable virtual machines.

Safety requirements:
- Never select or format a disk without explicit user confirmation.
- Show the exact device, model, capacity and partition changes before writing.
- Fail closed on ambiguous storage layouts or unsupported firmware modes.
- Keep encryption recovery guidance visible and never log secrets.
- Test BIOS/UEFI, NVMe/SATA, Btrfs, encrypted and multi-disk scenarios in virtual machines first.

Status: upstream installer is inherited; Redstone-specific branding, first-boot integration and end-to-end validation remain open. The optional package helper is currently a repository script and is not yet injected into the installed image.
