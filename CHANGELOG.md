# Changelog

All notable published changes are recorded here.

## [Unreleased]

- added a repository-level BSD-2-Clause-Patent license for original project material;
- pinned the GitHub checkout action to an immutable commit;
- added local Markdown-link and required-artifact validation;
- added automatic GitHub Release publication for verified version tags;
- enabled protected-main workflow requirements.

## [0.1.1] - 2026-08-01

### Added

- complete pinned-source checkout and macOS build scripts;
- separate macOS compatibility patch for the upstream root build script;
- GitHub Actions checks for patch applicability, firmware checksum, shell syntax, accidental local-path or secret leakage, and release/tag consistency.

### Verified

- a clean-room checkout, direct dependency initialization, patch application, BaseTools C build, and complete firmware build on macOS;
- the hardware-tested `RPI_EFI.fd` is unchanged from `v0.1.0` and retains SHA-256 `fe8b19fe7917df07952be0a40e176a4c6eaef238d0bc83206e43e870800bb8a0`.

## [0.1.0] - 2026-07-31

### Added

- stable RP1 Ethernet ACPI layout used by the experimental ESXi Arm driver;
- `RPI0001` GEM resources and separate `RPI0002` diagnostic GPIO resources;
- Waveshare PoE HAT (F) Rev1.2 fan control through RP1 PWM1 channel 3 and GPIO45;
- Automatic temperature curve with 5 °C downward hysteresis;
- Manual speed selection from 0% to 100%;
- Manual Persistent mode that retains the selected PWM state after `ExitBootServices`;
- warning text for persistent fixed-speed operation;
- restoration of saved PWM, GPIO and pad state in non-persistent modes.

### Verified

- UEFI and ESXi Arm boot;
- keyboard and boot-disk operation;
- Automatic and Manual fan-speed behavior;
- Manual Persistent at 100% across ESXi startup;
- sustained RX and TX through the separate experimental `RP1_GEM` ESXi driver on the published ACPI resource layout.

[Unreleased]: https://github.com/Soulveig/rpi5-uefi-esxi-fan/compare/v0.1.1...HEAD
[0.1.1]: https://github.com/Soulveig/rpi5-uefi-esxi-fan/compare/v0.1.0...v0.1.1
[0.1.0]: https://github.com/Soulveig/rpi5-uefi-esxi-fan/releases/tag/v0.1.0
