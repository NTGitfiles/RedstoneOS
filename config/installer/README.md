# Installer design

The installer is a planned Redstone-owned experience. The current ISO wrapper does not implement an installer UI or partition disks.

Required flow:
1. Welcome screen and release/hardware summary.
2. Keyboard layout and locale.
3. Network check and optional Wi-Fi setup.
4. Disk discovery with explicit target confirmation.
5. Partitioning choices, including erase/install and manual layout.
6. Btrfs layout and optional full-disk encryption.
7. Bootloader setup, with Secure Boot status clearly explained.
8. User account creation and administrator policy.
9. Timezone and clock configuration.
10. Package installation with visible progress and useful logs.
11. Install completion, reboot prompt and first-boot handoff.

Safety requirements:
- Never select or format a disk without explicit user confirmation.
- Show the exact device, model, capacity and partition changes before writing.
- Fail closed on ambiguous storage layouts or unsupported firmware modes.
- Keep encryption recovery guidance visible and never log secrets.
- Test BIOS/UEFI, NVMe/SATA, Btrfs, encrypted and multi-disk scenarios in virtual machines first.

Status: design specification only. No disk-writing installer is implemented.
