# Raspberry Pi 5 UEFI: ESXi network ACPI + PoE HAT fan control

Экспериментальная сборка UEFI для Raspberry Pi 5, проверенная с VMware ESXi Arm и Waveshare PoE HAT (F) с трёхпроводным вентилятором.

Готовый образ: [`firmware/RPI_EFI.fd`](firmware/RPI_EFI.fd)

## Что улучшено

### Сетевая часть

- сохранена рабочая ACPI-разметка RP1 Ethernet из проверенной сборки v0.8;
- контроллер GEM публикуется как `RPI0001`: один MMIO-диапазон `RP1_ETH_BASE` размером `0x10000` и прерывание;
- диагностический GPIO-диапазон вынесен в отдельное устройство `RPI0002`: `RP1_IO_BANK0_BASE` размером `0x30000`;
- реализация вентилятора изолирована от Ethernet: она не меняет ACPI-сетевую часть, тактирование Ethernet, GPIO32, GEM или PHY.

Это основа для экспериментального драйвера RP1 Ethernet в ESXi, а не законченный универсальный сетевой драйвер UEFI. Загрузка ESXi проверена; непрерывная работа RX/TX этой публикацией не заявляется.

### Вентилятор

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

## Проверено

- Raspberry Pi 5 (не D0);
- Waveshare PoE HAT (F), один трёхпроводный вентилятор;
- запуск UEFI и ESXi Arm;
- Automatic изменяет скорость вентилятора;
- Manual даёт различимые уровни скорости;
- ESXi загружается при Manual Persistent 100%, вентилятор продолжает работать.

## Установка

1. Сохраните резервную копию текущего `RPI_EFI.fd` на загрузочном носителе.
2. Скопируйте [`firmware/RPI_EFI.fd`](firmware/RPI_EFI.fd) вместо текущего файла.
3. Проверьте SHA-256 по файлу [`SHA256SUMS`](SHA256SUMS).
4. При первом запуске проверьте клавиатуру, загрузочный диск и температуру до длительного теста ESXi.

Всегда держите рабочий образ для отката. Сборка экспериментальная и не предназначена для установки без физического доступа к Raspberry Pi.

## Исходная основа

Сборка создана на основе следующих веток и зафиксированных коммитов:

- [NumberOneGit/rpi5-uefi, ветка `master`](https://github.com/NumberOneGit/rpi5-uefi/tree/master) — [`ba315b63ffc778b633911416c0adedfc2a2763a7`](https://github.com/NumberOneGit/rpi5-uefi/commit/ba315b63ffc778b633911416c0adedfc2a2763a7);
- [worproject/arm-trusted-firmware, ветка `rpi5`](https://github.com/worproject/arm-trusted-firmware/tree/rpi5) — [`682607fbd775e37fb5631508434dab9e60220c9a`](https://github.com/worproject/arm-trusted-firmware/commit/682607fbd775e37fb5631508434dab9e60220c9a);
- [Marcinoo97/edk2, ветка `sdmmc-dev`](https://github.com/Marcinoo97/edk2/tree/sdmmc-dev) — [`118e09ed80f4d9ec9966c3d1ac9f5ec7c9f99880`](https://github.com/Marcinoo97/edk2/commit/118e09ed80f4d9ec9966c3d1ac9f5ec7c9f99880);
- [NumberOneGit/edk2-platforms, ветка `rpi5-dev`](https://github.com/NumberOneGit/edk2-platforms/tree/rpi5-dev) — [`5654030569418c46e5a46066c495d4fad852b4f8`](https://github.com/NumberOneGit/edk2-platforms/commit/5654030569418c46e5a46066c495d4fad852b4f8);
- [tianocore/edk2-non-osi, ветка `master`](https://github.com/tianocore/edk2-non-osi/tree/master) — [`1f4d7849f2344aa770f4de5224188654ae5b0e50`](https://github.com/tianocore/edk2-non-osi/commit/1f4d7849f2344aa770f4de5224188654ae5b0e50).

Компилятор проверенной сборки: Arm GNU Toolchain GCC 12.3.1 для macOS.

## Лицензии

Прошивка объединяет компоненты нескольких upstream-проектов. Их исходные лицензии продолжают действовать; ссылки приведены в [`UPSTREAM.md`](UPSTREAM.md). Этот репозиторий не заменяет и не переопределяет лицензии компонентов прошивки.
