FROM ubuntu:24.04

ARG ARM_TOOLCHAIN=arm-gnu-toolchain-12.3.rel1-x86_64-aarch64-none-elf.tar.xz
ARG ARM_TOOLCHAIN_SHA256=382c8c786285e415bc0ff4df463e101f76d6f69a894b03f132368147c37f0ba7

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    acpica-tools build-essential ca-certificates curl git nasm python3 uuid-dev xz-utils \
    && rm -rf /var/lib/apt/lists/*

RUN curl --fail --location --output "/tmp/${ARM_TOOLCHAIN}" \
      "https://developer.arm.com/-/media/Files/downloads/gnu/12.3.rel1/binrel/${ARM_TOOLCHAIN}" \
    && echo "${ARM_TOOLCHAIN_SHA256}  /tmp/${ARM_TOOLCHAIN}" | sha256sum --check - \
    && tar -xJf "/tmp/${ARM_TOOLCHAIN}" -C /opt \
    && rm "/tmp/${ARM_TOOLCHAIN}"

ENV ARM_GNU_TOOLCHAIN_BIN=/opt/arm-gnu-toolchain-12.3.rel1-x86_64-aarch64-none-elf/bin
ENV IASL_BIN=/usr/bin

WORKDIR /project
CMD ["./scripts/build-container.sh"]
