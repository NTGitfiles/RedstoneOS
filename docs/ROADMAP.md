# Redstone OS Roadmap

This document tracks the non-application work required to turn the current Omarchy-based build scaffold into a complete, recognisably Redstone operating system.

Items are planned work, not claims that the feature already exists. Check items only when implementation and appropriate testing are complete. Prefer extending Omarchy and its upstream components where they already provide a reliable solution; Redstone should own its identity, defaults, hardware policy and genuinely new functionality.

## 1. Redstone identity and visual design

- [ ] Define and document the Redstone visual identity, palette and design tokens.
- [ ] Create and maintain primary, compact, monochrome and reversed logo variants.
- [ ] Create application, system, folder and installer icon assets.
- [ ] Apply Redstone branding to boot messages and bootloader presentation.
- [ ] Brand the login / display-manager screen.
- [ ] Apply consistent desktop colours, icon theme, fonts and cursor theme.
- [ ] Define system sounds and notification sounds.
- [ ] Create a curated wallpaper collection and generated default wallpaper.
- [ ] Create installer graphics, welcome artwork and release graphics.
- [ ] Ensure light/dark and accessibility-conscious contrast choices are documented.

## 2. Desktop and system configuration

- [ ] Establish Redstone-owned Hyprland defaults and configuration overlays.
- [ ] Establish Redstone-owned Quickshell panel, launcher and shell configuration.
- [ ] Define keyboard shortcuts and document them.
- [ ] Tune window layouts, gaps, borders, animations and workspaces.
- [ ] Set sensible display scaling and multi-monitor defaults.
- [ ] Configure power profiles and laptop power-management defaults.
- [ ] Define suspend, resume and hibernate behaviour, including hardware caveats.
- [ ] Set terminal, shell and file-manager defaults and configuration.
- [ ] Configure fonts, font rendering and language coverage.
- [ ] Configure NetworkManager, Wi-Fi and Bluetooth defaults.
- [ ] Define audio defaults, device selection and session behaviour.
- [ ] Document which settings are inherited from Omarchy and which are Redstone overrides.

## 3. Hardware detection, drivers and compatibility

- [ ] Create a modular hardware-detection and capability-reporting layer.
- [ ] Detect Intel and AMD CPU platforms reliably.
- [ ] Detect Intel, AMD/ATI and NVIDIA graphics hardware.
- [ ] Define Intel graphics driver and firmware policy.
- [ ] Define AMD graphics driver and firmware policy.
- [ ] Define NVIDIA driver selection, kernel compatibility and fallback behaviour.
- [ ] Handle hybrid graphics and switchable-GPU laptops.
- [ ] Define laptop power-management support and profiles.
- [ ] Support touchscreens, touchpads, gestures and common input devices.
- [ ] Handle HiDPI panels and mixed-DPI multi-monitor setups.
- [ ] Detect and configure audio devices and common codecs.
- [ ] Document printer and scanner support and optional driver handling.
- [ ] Detect and configure common Bluetooth adapters and peripherals.
- [ ] Create maintainable hardware profiles rather than hard-coding machine-specific assumptions.
- [ ] Provide a diagnostic report for detected hardware, drivers and firmware.
- [ ] Test on representative Intel, AMD and NVIDIA systems, including laptops and virtual machines.

## 4. Installer and first-boot experience

- [ ] Design a Redstone-branded boot and live-session experience.
- [ ] Provide an installation welcome screen and clear installation guidance.
- [ ] Implement safe disk discovery and disk selection.
- [ ] Implement partitioning choices with clear destructive-action warnings.
- [ ] Configure Btrfs layouts and subvolume policy.
- [ ] Support optional full-disk encryption and secure key handling.
- [ ] Configure bootloader installation and boot entries.
- [ ] Provide user creation and administrator account setup.
- [ ] Configure timezone, locale, keyboard and regional settings.
- [ ] Show installation progress, useful status and actionable error messages.
- [ ] Validate installation prerequisites before making disk changes.
- [ ] Implement a first-boot setup wizard for remaining user choices.
- [ ] Document recovery options if installation is interrupted or fails.

## 5. Updates, maintenance and recovery

- [ ] Define a supported Redstone update workflow and release channels.
- [ ] Integrate update handling with the upstream Arch/Omarchy model safely.
- [ ] Provide clear update status, errors and restart guidance.
- [ ] Define Btrfs snapshot creation and retention policy.
- [ ] Provide a tested rollback workflow for failed updates.
- [ ] Provide a recovery environment and bootable recovery guidance.
- [ ] Add package-cache management and cleanup guidance.
- [ ] Provide repair and diagnostic tools for common boot and system failures.
- [ ] Establish useful system log collection and support-bundle guidance.
- [ ] Expose Redstone version, build ID, upstream revision and release notes.
- [ ] Document backup and restore procedures.

## 6. Security, privacy and reliability

- [ ] Define a minimal, documented default service set.
- [ ] Establish firewall defaults and a user-understandable configuration path.
- [ ] Review permissions, privileged services and default user access.
- [ ] Define full-disk encryption defaults and threat-model documentation.
- [ ] Establish secure update and package-source practices.
- [ ] Evaluate optional Secure Boot support and document its limitations.
- [ ] Define firmware and microcode update policy.
- [ ] Review secrets handling in installer, first-boot and maintenance scripts.
- [ ] Establish security issue reporting and supported update policy.
- [ ] Test failure recovery, interrupted updates and power-loss scenarios.
- [ ] Document privacy-relevant services, telemetry (if any) and network behaviour.

## 7. Build, release and project infrastructure

- [ ] Keep upstream sources pinned and reproducible through the upstream lock manifest.
- [ ] Validate the generated Redstone theme against the actual upstream theme schema.
- [ ] Verify that generated theme assets are included in the built image.
- [ ] Add automated shell linting and static validation.
- [ ] Add build-host prerequisite and environment checks.
- [ ] Add automated checks for configuration, package manifests and patch applicability.
- [ ] Add a repeatable ISO build and artifact verification workflow.
- [ ] Capture build metadata, source revisions and checksums for each artifact.
- [ ] Define ISO naming, versioning and release notes.
- [ ] Test booting and installation in virtual machines before hardware release testing.
- [ ] Define hardware test coverage and a release checklist.
- [ ] Add a user guide, installation guide and troubleshooting documentation.
- [ ] Document contribution workflow, coding conventions and patch maintenance.
- [ ] Track upstream changes and define a deliberate update/rebase process.

## Repository ownership map

| Path | Responsibility |
| --- | --- |
| `config/branding/` | Logos, icons, palettes, boot/login/installer artwork and visual assets |
| `config/packages/` | Base package manifest, package groups, optional components and package policy |
| `config/hardware/` | Hardware profiles, detection rules, driver and firmware policy |
| `patches/omarchy/` | Redstone desktop and system integration changes |
| `patches/packages/` | Redstone-maintained package changes and packaging overrides |
| `patches/iso/` | ISO, boot and installer customisation |
| `scripts/` | Build, validation, hardware detection, installation, update and recovery helpers |
| `docs/` | Architecture, user, installation, security, troubleshooting and release documentation |
| `source/UPSTREAMS.lock` | Immutable upstream source revision manifest |

## Suggested implementation sequence

1. **Build foundation:** validate the existing build, generated theme, upstream integration and reproducibility.
2. **Configuration foundation:** establish package manifests, branding assets and hardware-profile formats.
3. **Desktop identity:** implement the Redstone desktop, boot and login experience.
4. **Hardware compatibility:** add detection, driver policy, diagnostics and representative hardware tests.
5. **Installation:** build and test the installer and first-boot flow.
6. **Operations:** implement updates, snapshots, rollback, recovery and diagnostics.
7. **Release hardening:** security review, documentation, automated tests and release process.

## Scope and implementation notes

- This roadmap deliberately excludes application selection and app-store additions.
- A roadmap checkbox is not complete merely because a package or upstream feature exists; Redstone integration, defaults, documentation and testing must be considered.
- Do not replace working upstream functionality without a clear reason.
- Features that can damage data, alter boot configuration or affect encryption require explicit safeguards and destructive-action confirmation.
- Keep optional hardware-specific components separate from the universal base image where practical.
- The full ISO build and the items above remain subject to implementation and testing; this roadmap does not imply they are already working.
