# Raspberry Pi 5 UEFI: ESXi network ACPI + Waveshare PoE HAT (F) Rev1.2 + Fan Control

[English](#english) | [Русский](#русский)

## English

Experimental UEFI build for Raspberry Pi 5, tested with VMware ESXi Arm and a Waveshare PoE HAT (F) Rev1.2 with one three-wire fan.

Ready-to-use image: [`firmware/RPI_EFI.fd`](firmware/RPI_EFI.fd)

### Improvements

#### Network

- preserves the working RP1 Ethernet ACPI layout from the tested v0.8 build;
- exposes the GEM controller as `RPI0001`, with one `RP1_ETH_BASE` MMIO range of `0x10000` bytes and an interrupt;
- exposes the diagnostic GPIO range as a separate `RPI0002` device, with an `RP1_IO_BANK0_BASE` range of `0x30000` bytes;
- keeps the fan implementation isolated from Ethernet: it does not modify Ethernet ACPI, Ethernet clocks, GPIO32, GEM, or PHY logic.

This is a foundation for the experimental RP1 Ethernet driver for ESXi, not a complete universal UEFI network driver. ESXi boot has been verified; this release does not claim continuous RX/TX operation.

#### Fan control

Three modes are available in the platform settings menu:

- **Automatic** — automatic fan curve based on SoC temperature;
- **Manual (0–100%)** — the selected speed remains active until control is handed over to the operating system;
- **Manual Persistent (0–100%)** — UEFI leaves the last programmed PWM state active after the operating system starts.

Automatic fan curve:

| Temperature | Fan speed |
|---|---:|
| below 50 °C | 0% |
| from 50 °C | 30% |
| from 60 °C | 50% |
| from 67.5 °C | 70% |
| from 75 °C | 100% |

A 5 °C downward hysteresis is used. UEFI timer updates stop at `ExitBootServices`.

In Automatic and standard Manual modes, the firmware restores the saved PWM1 clock, GPIO45, pad, PWM channel, and global PWM state. In Manual Persistent mode, the last programmed state is intentionally retained for an operating system that does not yet have a driver for this fan.

> **Warning:** Manual Persistent hands an already configured hardware state to the operating system and does not provide further thermal regulation. Select a sufficient fixed speed and monitor the temperature. For everyday Raspberry Pi OS use, Automatic control by the operating-system driver is recommended.

### Verified configuration

- Raspberry Pi 5 (non-D0);
- Waveshare PoE HAT (F) Rev1.2 with one three-wire fan;
- UEFI and ESXi Arm boot;
- Automatic mode changes fan speed;
- Manual mode produces distinguishable speed levels;
- ESXi boots with Manual Persistent set to 100%, and the fan continues running.

### Installation

1. Back up the current `RPI_EFI.fd` on the boot media.
2. Replace it with [`firmware/RPI_EFI.fd`](firmware/RPI_EFI.fd).
3. Verify its SHA-256 checksum using [`SHA256SUMS`](SHA256SUMS).
4. On the first boot, verify keyboard input, boot-disk detection, and temperature before running a long ESXi test.

Always keep a known-good rollback image. This is an experimental build and should not be installed without physical access to the Raspberry Pi.

### Upstream base

The build is based on the following branches and pinned commits:

- [NumberOneGit/rpi5-uefi, branch `master`](https://github.com/NumberOneGit/rpi5-uefi/tree/master) — [`ba315b63ffc778b633911416c0adedfc2a2763a7`](https://github.com/NumberOneGit/rpi5-uefi/commit/ba315b63ffc778b633911416c0adedfc2a2763a7);
- [worproject/arm-trusted-firmware, branch `rpi5`](https://github.com/worproject/arm-trusted-firmware/tree/rpi5) — [`682607fbd775e37fb5631508434dab9e60220c9a`](https://github.com/worproject/arm-trusted-firmware/commit/682607fbd775e37fb5631508434dab9e60220c9a);
- [Marcinoo97/edk2, branch `sdmmc-dev`](https://github.com/Marcinoo97/edk2/tree/sdmmc-dev) — [`118e09ed80f4d9ec9966c3d1ac9f5ec7c9f99880`](https://github.com/Marcinoo97/edk2/commit/118e09ed80f4d9ec9966c3d1ac9f5ec7c9f99880);
- [NumberOneGit/edk2-platforms, branch `rpi5-dev`](https://github.com/NumberOneGit/edk2-platforms/tree/rpi5-dev) — [`5654030569418c46e5a46066c495d4fad852b4f8`](https://github.com/NumberOneGit/edk2-platforms/commit/5654030569418c46e5a46066c495d4fad852b4f8);
- [tianocore/edk2-non-osi, branch `master`](https://github.com/tianocore/edk2-non-osi/tree/master) — [`1f4d7849f2344aa770f4de5224188654ae5b0e50`](https://github.com/tianocore/edk2-non-osi/commit/1f4d7849f2344aa770f4de5224188654ae5b0e50).

Compiler used for the tested build: Arm GNU Toolchain GCC 12.3.1 for macOS.

### Licenses

The firmware combines components from multiple upstream projects. Their original licenses remain applicable; see [`UPSTREAM.md`](UPSTREAM.md). This repository does not replace or override the licenses of the firmware components.

---

## Русский

Экспериментальная сборка UEFI для Raspberry Pi 5, проверенная с VMware ESXi Arm и Waveshare PoE HAT (F) Rev1.2 с одним трёхпроводным вентилятором.

Готовый образ: [`firmware/RPI_EFI.fd`](firmware/RPI_EFI.fd)

### Что улучшено

#### Сетевая часть

- сохранена рабочая ACPI-разметка RP1 Ethernet из проверенной сборки v0.8;
- контроллер GEM публикуется как `RPI0001`: один MMIO-диапазон `RP1_ETH_BASE` размером `0x10000` и прерывание;
- диагностический GPIO-диапазон вынесен в отдельное устройство `RPI0002`: `RP1_IO_BANK0_BASE` размером `0x30000`;
- реализация вентилятора изолирована от Ethernet: она не меняет ACPI-сетевую часть, тактирование Ethernet, GPIO32, GEM или PHY.

Это основа для экспериментального драйвера RP1 Ethernet в ESXi, а не законченный универсальный сетевой драйвер UEFI. Загрузка ESXi проверена; непрерывная работа RX/TX этой публикацией не заявляется.

#### Управление вентилятором

В меню настроек платформы доступны три режима:

- **Automatic** — автоматическая кривая по температуре SoC;
- **Manual (0–100%)** — заданная скорость действует до передачи управления ОС;
- **Manual Persistent (0–100%)** — UEFI оставляет последнее состояние PWM после запуска ОС.

Автоматическая кривая:

| Температура | Скорость |
|---|---:|
| ниже 50 °C | 0% |
| от 50 °C | 30% |
| от 60 °C | 50% |
| от 67,5 °C | 70% |
| от 75 °C | 100% |

При снижении температуры используется гистерезис 5 °C. Обновление от таймера UEFI прекращается при `ExitBootServices`.

В режимах Automatic и обычном Manual прошивка восстанавливает сохранённое состояние PWM1, GPIO45, pad, канала и глобальных регистров PWM. В режиме Manual Persistent последнее запрограммированное состояние намеренно сохраняется для ОС, в которой пока нет драйвера этого вентилятора.

> **Предупреждение:** Manual Persistent передаёт ОС уже настроенное аппаратное состояние и не выполняет дальнейшую терморегуляцию. Выбирайте достаточную постоянную скорость и контролируйте температуру. Для повседневной Raspberry Pi OS рекомендуется Automatic с управлением драйвером ОС.

### Проверенная конфигурация

- Raspberry Pi 5 (не D0);
- Waveshare PoE HAT (F) Rev1.2, один трёхпроводный вентилятор;
- запуск UEFI и ESXi Arm;
- Automatic изменяет скорость вентилятора;
- Manual даёт различимые уровни скорости;
- ESXi загружается при Manual Persistent 100%, вентилятор продолжает работать.

### Установка

1. Сохраните резервную копию текущего `RPI_EFI.fd` на загрузочном носителе.
2. Скопируйте [`firmware/RPI_EFI.fd`](firmware/RPI_EFI.fd) вместо текущего файла.
3. Проверьте SHA-256 по файлу [`SHA256SUMS`](SHA256SUMS).
4. При первом запуске проверьте клавиатуру, загрузочный диск и температуру до длительного теста ESXi.

Всегда держите рабочий образ для отката. Сборка экспериментальная и не предназначена для установки без физического доступа к Raspberry Pi.

### Исходная основа

Сборка создана на основе следующих веток и зафиксированных коммитов:

- [NumberOneGit/rpi5-uefi, ветка `master`](https://github.com/NumberOneGit/rpi5-uefi/tree/master) — [`ba315b63ffc778b633911416c0adedfc2a2763a7`](https://github.com/NumberOneGit/rpi5-uefi/commit/ba315b63ffc778b633911416c0adedfc2a2763a7);
- [worproject/arm-trusted-firmware, ветка `rpi5`](https://github.com/worproject/arm-trusted-firmware/tree/rpi5) — [`682607fbd775e37fb5631508434dab9e60220c9a`](https://github.com/worproject/arm-trusted-firmware/commit/682607fbd775e37fb5631508434dab9e60220c9a);
- [Marcinoo97/edk2, ветка `sdmmc-dev`](https://github.com/Marcinoo97/edk2/tree/sdmmc-dev) — [`118e09ed80f4d9ec9966c3d1ac9f5ec7c9f99880`](https://github.com/Marcinoo97/edk2/commit/118e09ed80f4d9ec9966c3d1ac9f5ec7c9f99880);
- [NumberOneGit/edk2-platforms, ветка `rpi5-dev`](https://github.com/NumberOneGit/edk2-platforms/tree/rpi5-dev) — [`5654030569418c46e5a46066c495d4fad852b4f8`](https://github.com/NumberOneGit/edk2-platforms/commit/5654030569418c46e5a46066c495d4fad852b4f8);
- [tianocore/edk2-non-osi, ветка `master`](https://github.com/tianocore/edk2-non-osi/tree/master) — [`1f4d7849f2344aa770f4de5224188654ae5b0e50`](https://github.com/tianocore/edk2-non-osi/commit/1f4d7849f2344aa770f4de5224188654ae5b0e50).

Компилятор проверенной сборки: Arm GNU Toolchain GCC 12.3.1 для macOS.

### Лицензии

Прошивка объединяет компоненты нескольких upstream-проектов. Их исходные лицензии продолжают действовать; ссылки приведены в [`UPSTREAM.md`](UPSTREAM.md). Этот репозиторий не заменяет и не переопределяет лицензии компонентов прошивки.
