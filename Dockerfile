FROM ubuntu:24.04@sha256:4fbb8e6a8395de5a7550b33509421a2bafbc0aab6c06ba2cef9ebffbc7092d90

ARG ARM_TOOLCHAIN=arm-gnu-toolchain-12.3.rel1-x86_64-aarch64-none-elf.tar.xz
ARG ARM_TOOLCHAIN_SHA256=382c8c786285e415bc0ff4df463e101f76d6f69a894b03f132368147c37f0ba7

ADD --checksum=sha256:6bac2a01979e210d9eac1d4d56747ec709ea60654744d66705dc3c36e7629e50 \
    https://snapshot.ubuntu.com/ubuntu/20260801T000000Z/pool/main/c/ca-certificates/ca-certificates_20260601~24.04.1_all.deb \
    /tmp/ca-certificates.deb

RUN dpkg -i /tmp/ca-certificates.deb \
    && rm /tmp/ca-certificates.deb \
    && printf '%s\n' \
      'deb [check-valid-until=no] https://snapshot.ubuntu.com/ubuntu/20260801T000000Z noble main restricted universe multiverse' \
      'deb [check-valid-until=no] https://snapshot.ubuntu.com/ubuntu/20260801T000000Z noble-updates main restricted universe multiverse' \
      'deb [check-valid-until=no] https://snapshot.ubuntu.com/ubuntu/20260801T000000Z noble-security main restricted universe multiverse' \
      > /etc/apt/sources.list \
    && rm -f /etc/apt/sources.list.d/ubuntu.sources \
    && apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
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
