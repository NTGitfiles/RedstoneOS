# Package policy

`groups.toml` defines the intended package groups: base, desktop, Intel graphics, AMD graphics, NVIDIA graphics, laptop, accessibility, printing and development.

The lists are intentionally empty. Before adding package names, inspect the pinned Omarchy package snapshot, confirm package availability, dependencies, architecture and licensing, and document why Redstone needs each addition or removal. Do not treat this file as an instruction to install every optional group.

## Collected application wishlist

`wishlist.toml` records the application and optional-tool selections collected for Redstone OS. It is deliberately separate from `groups.toml`: entries are user-approved wishlist items, not yet validated Arch package names and not automatically installed by the ISO build.

Next steps before wiring it into the image:

1. Map each friendly name to a verified package source and exact package identifier.
2. Check the pinned upstream package snapshot, architecture, licensing and dependencies.
3. Split universal packages from optional, hardware-specific and ARM64-only packages.
4. Resolve known overlaps and conflicts (for example, power managers and bootloaders).
5. Generate reviewed install groups and add build-time validation.

The package-management options in the questionnaire were not selected and are explicitly recorded as unapproved in the wishlist.
