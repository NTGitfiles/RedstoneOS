# Updates, maintenance and recovery

Planned user-facing maintenance capabilities:
- Supported system update workflow with signature/repository checks.
- Clear release notes and installed Redstone/upstream version reporting.
- Btrfs snapshot creation before risky system updates where the layout supports it.
- Rollback selection and recovery boot entry.
- Package cache cleanup with dry-run/space reporting.
- Repair mode for boot, package database and filesystem issues.
- Diagnostic bundle containing useful logs while excluding credentials and personal data.
- Backup/restore guidance and recovery media instructions.

Do not implement destructive cleanup or rollback commands until the filesystem layout and snapshot lifecycle are defined and tested. The current build wrapper only builds the ISO; it does not provide these runtime maintenance features.
