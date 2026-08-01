#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 OUTPUT_DIRECTORY" >&2
  exit 2
fi

output_dir="$1"
repo_root="$(cd "$(dirname "$0")/.." && pwd)"
patch_file="$repo_root/patches/0001-rpi5-esxi-acpi-waveshare-fan.patch"
build_patch_file="$repo_root/patches/0002-macos-build-compatibility.patch"

if [[ -e "$output_dir" ]]; then
  echo "Refusing to overwrite existing path: $output_dir" >&2
  exit 1
fi

git clone https://github.com/NumberOneGit/rpi5-uefi.git "$output_dir"
git -C "$output_dir" checkout ba315b63ffc778b633911416c0adedfc2a2763a7
git -C "$output_dir" submodule update --init

git -C "$output_dir/arm-trusted-firmware" checkout 682607fbd775e37fb5631508434dab9e60220c9a
git -C "$output_dir/edk2" checkout 118e09ed80f4d9ec9966c3d1ac9f5ec7c9f99880
git -C "$output_dir/edk2-platforms" checkout 5654030569418c46e5a46066c495d4fad852b4f8
git -C "$output_dir/edk2-non-osi" checkout 1f4d7849f2344aa770f4de5224188654ae5b0e50

# Initialize EDK2's direct build dependencies, but do not recurse into the
# upstream test-only submodules of projects such as OpenSSL.
git -C "$output_dir/edk2" submodule update --init
git -C "$output_dir/edk2-platforms" apply --check "$patch_file"
git -C "$output_dir/edk2-platforms" apply "$patch_file"
git -C "$output_dir" apply --check "$build_patch_file"
git -C "$output_dir" apply "$build_patch_file"

echo "Pinned source prepared in: $output_dir"
