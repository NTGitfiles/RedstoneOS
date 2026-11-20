# Package policy and optional software

The pinned Omarchy 4.5 runtime already includes a substantial portion of the selected wishlist. Examples include Herdr, Docker, Docker Buildx/Compose, CUPS, FFmpeg, Fastfetch, btop, Git, Neovim (packaged upstream as nvim), LibreOffice, LocalSend, MPV, Plymouth, Tailscale, yt-dlp, zoxide, and several fonts and graphics components. Do not duplicate these in the Redstone base image.

wishlist.toml is the complete user-selected inventory. optional/*.packages maps common optional groups to candidate Arch package names. The post-install helper checks each name against the machine's currently configured official pacman repositories before offering installation. Missing packages are skipped and reported; it does not silently add AUR helpers, third-party repositories, or proprietary driver sources.

Run:

```bash
scripts/install-redstone-extras.sh --list
scripts/install-redstone-extras.sh --dry-run gaming terminal
scripts/install-redstone-extras.sh gaming terminal
```

Hardware-specific groups are deliberately separate. Review scripts/detect-hardware.sh before considering a driver group. NVIDIA modules are kernel-sensitive; Intel/AMD microcode and graphics packages should match the actual hardware. TLP and Power Profiles Daemon must not both be enabled as competing power managers without an explicit policy.

The package-management options in the questionnaire were not submitted. The helper therefore uses pacman only and does not install a new AUR helper or package-store GUI. Flatpak was selected in the wishlist but its application IDs still need a separately reviewed Flathub catalogue.

Some names in the wishlist are proprietary, AUR-only, renamed, unavailable on ARM64, or require extra repositories. Unity Hub, Unreal Engine tooling, Switch emulation alternatives, and Raspberry Pi imaging tools are not installed by the helper until their distribution and package sources are reviewed.

## Upstream inheritance

The pinned Omarchy 4.5 package list already contains herdr, resolving the earlier spelling question. It also ships the Limine bootloader and Btrfs/Snapper/ZRAM-related pieces. Redstone should extend this baseline rather than replace it with GRUB or install a second bootloader. The upstream ISO project supports x86_64 and aarch64 build targets; aarch64 support alone does not certify Raspberry Pi 5 board support.
