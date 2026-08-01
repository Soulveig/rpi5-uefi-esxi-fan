# Reproducing the firmware build

This document describes the source state published with `v0.1.1`. Both patches have been verified with `git apply --check` against their pinned upstream commits, and a clean-room checkout and build completed successfully on macOS.

## Requirements

- macOS on Apple Silicon;
- Git, GNU Make, Python 3, IASL and the EDK2 BaseTools dependencies;
- Arm GNU Toolchain 12.3.Rel1 for `aarch64-none-elf`;
- sufficient disk space for EDK2 and all required submodules.

The tested compiler identified itself as:

```text
aarch64-none-elf-gcc (Arm GNU Toolchain 12.3.Rel1 (Build arm-12.35)) 12.3.1 20230626
```

GCC 15 was not used for the published firmware and is not currently part of the verified build environment.

## Pinned source revisions

| Component | Branch | Commit |
|---|---|---|
| `NumberOneGit/rpi5-uefi` | `master` | `ba315b63ffc778b633911416c0adedfc2a2763a7` |
| `worproject/arm-trusted-firmware` | `rpi5` | `682607fbd775e37fb5631508434dab9e60220c9a` |
| `Marcinoo97/edk2` | `sdmmc-dev` | `118e09ed80f4d9ec9966c3d1ac9f5ec7c9f99880` |
| `NumberOneGit/edk2-platforms` | `rpi5-dev` | `5654030569418c46e5a46066c495d4fad852b4f8` |
| `tianocore/edk2-non-osi` | `master` | `1f4d7849f2344aa770f4de5224188654ae5b0e50` |

## Checkout and patch

From this repository, run:

```bash
./scripts/checkout-source.sh ./build/source
```

The script checks out every pinned revision, initializes EDK2's direct build dependencies, applies [`patches/0001-rpi5-esxi-acpi-waveshare-fan.patch`](patches/0001-rpi5-esxi-acpi-waveshare-fan.patch), and applies the small root-build compatibility patch [`patches/0002-macos-build-compatibility.patch`](patches/0002-macos-build-compatibility.patch). It deliberately does not recurse into test-only submodules nested inside projects such as OpenSSL.

To check the patch without applying it:

```bash
git -C ./build/source/edk2-platforms apply --check \
  "$PWD/patches/0001-rpi5-esxi-acpi-waveshare-fan.patch"
```

## Build on macOS

Set the tool locations explicitly:

```bash
export ARM_GNU_TOOLCHAIN_BIN="/absolute/path/to/arm-gnu-toolchain-12.3.rel1-darwin-arm64-aarch64-none-elf/bin"
export IASL_BIN="/absolute/path/to/acpica/bin"
./scripts/build-macos.sh ./build/source
```

The wrapper verifies the compiler version, builds the required BaseTools C utilities when absent, sets `CROSS_COMPILE=aarch64-none-elf-`, invokes the patched upstream `build.sh` with its Raspberry Pi 5 release defaults, and copies the result to `build/output/RPI_EFI.fd`. It intentionally passes no command-line options because that old upstream script expects GNU `getopt` when options are supplied, while macOS provides a different implementation.

Only the BaseTools C utilities required by the firmware build are compiled. The old branch's unrelated Python test suite is not invoked because it expects a legacy `python` command and is not part of producing `RPI_EFI.fd`.

## Verify the result

```bash
shasum -a 256 ./build/output/RPI_EFI.fd
```

The hardware-tested firmware retained in `v0.1.1` has SHA-256:

```text
fe8b19fe7917df07952be0a40e176a4c6eaef238d0bc83206e43e870800bb8a0
```

A rebuild should be functionally equivalent. Byte-for-byte identity can depend on build-path or timestamp data emitted by the pinned toolchain and EDK2 build.

## Container build

The repository also provides a Linux container with the Ubuntu base image pinned by digest, APT packages resolved from the immutable `20260801T000000Z` Ubuntu snapshot, and Arm GNU Toolchain 12.3.Rel1 pinned by its official SHA-256 checksum:

```bash
docker build -t rpi5-uefi-builder:12.3 .
docker run --rm -v "$PWD:/project" rpi5-uefi-builder:12.3
```

The result is written to `build/container-output/RPI_EFI.fd`. This makes the host tools and source checkout repeatable. It does not claim byte identity with the hardware-tested macOS artifact; a newly built image must be tested on hardware before replacing the published firmware.
