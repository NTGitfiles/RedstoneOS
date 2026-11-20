# Hardware profiles

`detection.toml` defines conservative CPU, PCI, kernel-driver and DMI detection policy. Device-specific policy lives in `profiles/` for Intel, AMD, NVIDIA, laptops, touch devices, audio and peripherals.

These are policy-only profiles, not an implemented hardware detection or driver installation service. Unknown devices should produce a warning. Driver installation, especially proprietary NVIDIA modules, must not happen automatically without explicit policy and compatibility checks.
