# Reproducing the firmware build

This document describes the source state used for `v0.1.0`. The published patch has been verified with `git apply --check` against the pinned `edk2-platforms` commit.

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

The script checks out every pinned revision, initializes nested submodules and applies [`patches/0001-rpi5-esxi-acpi-waveshare-fan.patch`](patches/0001-rpi5-esxi-acpi-waveshare-fan.patch).

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

The wrapper verifies the compiler version, sets `CROSS_COMPILE=aarch64-none-elf-`, invokes the upstream `build.sh` with its Raspberry Pi 5 release defaults, and copies the result to `build/output/RPI_EFI.fd`. It intentionally passes no command-line options because that old upstream script expects GNU `getopt` when options are supplied, while macOS provides a different implementation.

The upstream build expects EDK2 BaseTools to be available. If they have not been built in the new workspace, build them according to the pinned EDK2 branch before invoking the wrapper. The previously tested macOS workspace used already-built BaseTools because that branch's legacy test runner expects a `python` command.

## Verify the result

```bash
shasum -a 256 ./build/output/RPI_EFI.fd
```

The published `v0.1.0` binary has SHA-256:

```text
fe8b19fe7917df07952be0a40e176a4c6eaef238d0bc83206e43e870800bb8a0
```

A rebuild should be functionally equivalent. Byte-for-byte identity can depend on build-path or timestamp data emitted by the pinned toolchain and EDK2 build.
