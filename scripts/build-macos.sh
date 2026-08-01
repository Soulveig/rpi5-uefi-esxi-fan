#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 SOURCE_DIRECTORY" >&2
  exit 2
fi

source_dir="$(cd "$1" && pwd)"
repo_root="$(cd "$(dirname "$0")/.." && pwd)"
output_dir="$repo_root/build/output"

: "${ARM_GNU_TOOLCHAIN_BIN:?Set ARM_GNU_TOOLCHAIN_BIN to the GCC 12.3.Rel1 bin directory}"
: "${IASL_BIN:?Set IASL_BIN to the directory containing iasl}"

compiler="$ARM_GNU_TOOLCHAIN_BIN/aarch64-none-elf-gcc"
if [[ ! -x "$compiler" ]]; then
  echo "Compiler not found: $compiler" >&2
  exit 1
fi
if [[ ! -x "$IASL_BIN/iasl" ]]; then
  echo "IASL not found: $IASL_BIN/iasl" >&2
  exit 1
fi
if ! "$compiler" -dumpfullversion | grep -Eq '^12\.3(\.1)?$'; then
  echo "This release requires the verified GCC 12.3.x toolchain" >&2
  "$compiler" --version | head -1 >&2
  exit 1
fi

export PATH="$ARM_GNU_TOOLCHAIN_BIN:$IASL_BIN:/usr/bin:/bin:/usr/sbin:/sbin"
export CROSS_COMPILE="aarch64-none-elf-"

(cd "$source_dir" && ./build.sh)

mkdir -p "$output_dir"
cp "$source_dir/RPI_EFI.fd" "$output_dir/RPI_EFI.fd"
shasum -a 256 "$output_dir/RPI_EFI.fd"
