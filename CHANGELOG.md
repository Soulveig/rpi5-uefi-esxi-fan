# Changelog

All notable published changes are recorded here.

## [Unreleased]

### Added (build-verified, hardware test pending)

- Cooling Fan status telemetry, refreshed when the page is reopened;
- SoC temperature, requested PWM percentage and temperature-sensor status;
- Automatic curve stage display, including explicit fail-safe 100% status;
- volatile telemetry variables that do not write periodic updates to NVRAM.

### Changed

- simplified the repository to ready-to-use firmware and documentation; local experimental builds are published only after hardware validation;
- disabled automatic HII form refresh after hardware testing showed severe keyboard latency;

## [0.1.3] - 2026-08-01

- pinned the Ubuntu container image by digest and APT packages to an immutable snapshot;
- made SPDX SBOM generation release-version aware;
- added the explicit non-D0 firmware filename to `SHA256SUMS`;
- made the full container build part of required `verify` when build-chain files change.

## [0.1.2] - 2026-08-01

### Added

- repository-level BSD-2-Clause-Patent license and security policy;
- pinned container build using Arm GNU Toolchain 12.3.Rel1 with verified download checksum;
- source-patch policy, SPDX SBOM, documentation and required-artifact checks;
- signed GitHub artifact attestations and automatic tagged releases;
- explicit `RPI_EFI-RPi5-nonD0.fd` release naming and a no-unverified-D0 policy;
- protected `main` requirements and immutable GitHub Action references.

### Verified

- existing hardware-tested firmware remains byte-for-byte unchanged;
- clean macOS source checkout and build;
- GitHub verification workflow and container build workflow.

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

[Unreleased]: https://github.com/Soulveig/rpi5-uefi-esxi-fan/compare/v0.1.3...HEAD
[0.1.3]: https://github.com/Soulveig/rpi5-uefi-esxi-fan/compare/v0.1.2...v0.1.3
[0.1.2]: https://github.com/Soulveig/rpi5-uefi-esxi-fan/compare/v0.1.1...v0.1.2
[0.1.1]: https://github.com/Soulveig/rpi5-uefi-esxi-fan/compare/v0.1.0...v0.1.1
[0.1.0]: https://github.com/Soulveig/rpi5-uefi-esxi-fan/releases/tag/v0.1.0
