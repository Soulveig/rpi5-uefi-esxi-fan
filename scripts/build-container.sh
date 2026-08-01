#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "$0")/.." && pwd)"
source_dir="$repo_root/build/container-source"
output_dir="$repo_root/build/container-output"

rm -rf "$source_dir" "$output_dir"
"$repo_root/scripts/checkout-source.sh" "$source_dir"

export PATH="$ARM_GNU_TOOLCHAIN_BIN:$IASL_BIN:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
export CROSS_COMPILE=aarch64-none-elf-
export SOURCE_DATE_EPOCH=1722384000

make -C "$source_dir/edk2/BaseTools/Source/C" \
  BUILD_OPTFLAGS='-O2 -Wno-macro-redefined'
(cd "$source_dir" && ./build.sh)

mkdir -p "$output_dir"
cp "$source_dir/RPI_EFI.fd" "$output_dir/RPI_EFI.fd"
sha256sum "$output_dir/RPI_EFI.fd"
