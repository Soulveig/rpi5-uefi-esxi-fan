#!/usr/bin/env python3
"""Verify local Markdown links and required release files."""

from pathlib import Path
import re
import sys
from urllib.parse import unquote

ROOT = Path(__file__).resolve().parent.parent
REQUIRED = (
    "README.md",
    "BUILD.md",
    "CHANGELOG.md",
    "LICENSE",
    "SECURITY.md",
    "Dockerfile",
    "SHA256SUMS",
    "sbom/RPI_EFI.spdx.json",
    "firmware/RPI_EFI.fd",
    "firmware/RPI_EFI-RPi5-nonD0.fd",
    "patches/0001-rpi5-esxi-acpi-waveshare-fan.patch",
    "patches/0002-macos-build-compatibility.patch",
)
LINK = re.compile(r"!?\[[^]]*\]\(([^)]+)\)")

errors: list[str] = []

for relative in REQUIRED:
    if not (ROOT / relative).is_file():
        errors.append(f"required file is missing: {relative}")

for document in ROOT.rglob("*.md"):
    if ".git" in document.parts:
        continue
    for match in LINK.finditer(document.read_text(encoding="utf-8")):
        target = match.group(1).strip().strip("<>").split("#", 1)[0]
        if not target or re.match(r"^[a-z][a-z0-9+.-]*:", target, re.I):
            continue
        target_path = (document.parent / unquote(target)).resolve()
        if not target_path.exists():
            errors.append(f"{document.relative_to(ROOT)}: missing local target {target}")

if errors:
    print("\n".join(errors), file=sys.stderr)
    raise SystemExit(1)

print("Documentation links and required files: OK")
