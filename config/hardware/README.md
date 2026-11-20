# Hardware profiles

detection.toml defines conservative CPU, PCI, kernel-driver and DMI detection policy. Device-specific policy lives in profiles/ for Intel, AMD, NVIDIA, laptops, touch devices, audio and peripherals.

Run scripts/detect-hardware.sh for a read-only report of CPU vendor, graphics devices, architecture and laptop battery presence. The report does not install drivers or alter firmware.

The pinned Omarchy 4.5 package baseline already provides broad firmware, Mesa/Vulkan and NVIDIA driver options. Redstone keeps additional hardware packages in separate optional groups. Do not automatically install proprietary NVIDIA modules or enable competing power managers. Raspberry Pi 5 remains a separate board-support target: the upstream aarch64 builder is not proof that every ARM board boots.
