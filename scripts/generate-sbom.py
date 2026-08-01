#!/usr/bin/env python3
"""Generate a release-specific SPDX SBOM from the reviewed component template."""

import argparse
from datetime import datetime, timezone
import hashlib
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
TEMPLATE = ROOT / "sbom/RPI_EFI.spdx.json"
FIRMWARE = ROOT / "firmware/RPI_EFI.fd"

parser = argparse.ArgumentParser()
parser.add_argument("version", help="release version without a leading v")
parser.add_argument("--output", type=Path, required=True)
parser.add_argument("--created", help="ISO-8601 creation time; defaults to current UTC")
args = parser.parse_args()

document = json.loads(TEMPLATE.read_text(encoding="utf-8"))
if args.created:
    parsed = datetime.fromisoformat(args.created.replace("Z", "+00:00"))
    created = parsed.astimezone(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ")
else:
    created = datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ")
document["documentNamespace"] = (
    f"https://github.com/Soulveig/rpi5-uefi-esxi-fan/sbom/v{args.version}"
)
document["creationInfo"]["created"] = created

firmware_hash = hashlib.sha256(FIRMWARE.read_bytes()).hexdigest()
firmware = next(pkg for pkg in document["packages"] if pkg["SPDXID"] == "SPDXRef-Firmware")
firmware["versionInfo"] = args.version
firmware["checksums"][0]["checksumValue"] = firmware_hash

args.output.parent.mkdir(parents=True, exist_ok=True)
args.output.write_text(json.dumps(document, indent=2) + "\n", encoding="utf-8")
print(args.output)
