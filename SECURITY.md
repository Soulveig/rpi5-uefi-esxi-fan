# Security policy

## Supported version

Only the latest published release is supported. This is experimental firmware and is not intended for unattended or safety-critical systems.

## Reporting a vulnerability

Please use GitHub's private vulnerability reporting feature for this repository. Do not publish credentials, private network addresses, crash dumps containing secrets, or an unpatched vulnerability in a public issue.

Include the Raspberry Pi revision, firmware version and SHA-256, boot mode, operating system, PoE HAT revision, and minimal reproduction steps. Reports are acknowledged when reviewed; no fixed response time is guaranteed for this experimental project.

## Operational risks

- Keep physical access and a known-good boot-media backup.
- `Manual Persistent` disables ongoing UEFI thermal regulation after boot. Use a sufficient fixed speed and monitor temperature.
- A firmware image marked `non-D0` must not be assumed compatible with D0 boards.
- Network support depends on the separate experimental ESXi driver and the documented ACPI layout.
