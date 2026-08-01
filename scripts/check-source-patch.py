#!/usr/bin/env python3
"""Perform lightweight policy checks on the published source patch."""

from pathlib import Path
import re

ROOT = Path(__file__).resolve().parent.parent
patch = (ROOT / "patches/0001-rpi5-esxi-acpi-waveshare-fan.patch").read_text(encoding="utf-8")

if re.search(r"^\+[^+].*[ \t]$", patch, re.MULTILINE):
    raise SystemExit("added source line contains trailing whitespace")

required_sources = ("FanControl.c", "FanControl.h")
for source in required_sources:
    marker = f"+++ b/Platform/RaspberryPi/RPi5/Drivers/RpiPlatformDxe/{source}"
    if marker not in patch:
        raise SystemExit(f"missing expected source in patch: {source}")

if patch.count("SPDX-License-Identifier: BSD-2-Clause-Patent") < 2:
    raise SystemExit("new fan-control C/H files must carry SPDX identifiers")

for forbidden in ("strcpy(", "sprintf(", "gets("):
    if forbidden in patch:
        raise SystemExit(f"forbidden unsafe function in patch: {forbidden}")

print("Source patch policy: OK")
