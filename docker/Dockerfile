# ps2os builder: everything needed to run live-build for a Debian bookworm ISO.
FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8

# Recommends are left on for live-build on purpose: it shells out to many small
# tools and a missing one fails the build late. Image size is not a goal.
RUN apt-get update \
 && apt-get install -y \
      ca-certificates \
      cpio \
      curl \
      debian-archive-keyring \
      debootstrap \
      dosfstools \
      file \
      git \
      gnupg \
      isolinux \
      live-build \
      make \
      mtools \
      procps \
      rsync \
      squashfs-tools \
      syslinux \
      syslinux-common \
      syslinux-utils \
      xorriso \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /work
CMD ["bash"]
