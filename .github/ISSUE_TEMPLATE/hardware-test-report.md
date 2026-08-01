---
name: Hardware test report
about: Report a tested Raspberry Pi, PoE HAT, fan, operating system, or RP1 Ethernet configuration
title: "[Hardware test] "
labels: testing
assignees: ""
---

## Hardware

- Raspberry Pi model:
- Board revision / stepping:
- PoE HAT model and revision:
- Fan type and wire count:
- Power source:
- Boot media:

## Firmware and operating system

- Release or commit:
- `RPI_EFI.fd` SHA-256:
- Operating system / ESXi build:
- ESXi RP1 driver version, if applicable:

## Fan test

- Mode: Automatic / Manual / Manual Persistent
- Selected manual speed:
- Fan continues after OS boot: Yes / No / Not tested
- Lowest and highest observed temperature:
- Result and observations:

## Network test

- Interface name:
- Link speed and duplex:
- RX traffic duration and result:
- TX traffic duration and result:
- Packet or byte counters:
- Drops, DMA errors, watchdog events, or VMkernel errors:

## Boot and device health

- Keyboard works in UEFI: Yes / No
- Boot disk detected: Yes / No
- USB devices remain available: Yes / No
- Storage remains available: Yes / No
- Rollback tested or available: Yes / No

## Logs and reproduction steps

Do not attach passwords, tokens, private keys, or other secrets. Include only the relevant log excerpts and exact steps needed to reproduce the result.
