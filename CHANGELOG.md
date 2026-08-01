# Changelog

All notable published changes are recorded here.

## [Unreleased]

- No firmware changes yet.

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

[Unreleased]: https://github.com/Soulveig/rpi5-uefi-esxi-fan/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/Soulveig/rpi5-uefi-esxi-fan/releases/tag/v0.1.0
