#!/usr/bin/env bash
# Runs INSIDE the ps2os-builder container (see Makefile: `make iso`).
# Not meant to be run on the host.
set -euo pipefail

SRC=/work                  # repo, bind-mounted from the host
OUT="$SRC/out"             # ISO and log land here
WORK=/tmp/ps2os-lb         # container-local fs: debootstrap cannot run on a
                           # Windows/NTFS bind mount (no mknod, no symlinks)

if [ "$(id -u)" != "0" ]; then
  echo "build-iso.sh must run as root inside the builder container" >&2
  exit 1
fi

mkdir -p "$OUT"
rm -rf "$WORK"
mkdir -p "$WORK"

# Stage the live-build tree. image/ is the config; shell/ is the single source
# of truth for the kiosk page and is shipped at /opt/shell in the live system.
cp -a "$SRC/image/." "$WORK/"
mkdir -p "$WORK/config/includes.chroot/opt/shell"
cp -a "$SRC/shell/." "$WORK/config/includes.chroot/opt/shell/"

# git on Windows does not keep the exec bit.
find "$WORK/auto" -type f -exec chmod +x {} +

cd "$WORK"
lb config
lb build 2>&1 | tee "$OUT/build.log"

iso="$(find "$WORK" -maxdepth 1 -name '*.iso' | head -n 1)"
if [ -z "$iso" ]; then
  echo "live-build finished but produced no .iso" >&2
  exit 1
fi
cp -f "$iso" "$OUT/ps2os.iso"

# Smoke test: the ISO must contain the live squashfs and the shell page.
xorriso -indev "$OUT/ps2os.iso" -find /live -name 'filesystem.squashfs' 2>/dev/null \
  | grep -q 'filesystem.squashfs'
unsquashfs -l "$WORK/binary/live/filesystem.squashfs" 2>/dev/null \
  | grep -q 'opt/shell/index.html'

# Hand ownership back to the host user (no-op on Docker Desktop for Windows).
if [ -n "${HOST_UID:-}" ]; then
  chown -R "$HOST_UID:${HOST_GID:-$HOST_UID}" "$OUT" 2>/dev/null || true
fi

ls -lh "$OUT/ps2os.iso"
echo "OK: $OUT/ps2os.iso"
