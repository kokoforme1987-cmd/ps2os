# Decisions

Format: decision / alternatives / why. Newest last. Stack items marked "locked" come
from AGENTS.md and change only by a new entry here.

## D-001 Stack (locked)
- Decision: Debian bookworm, built with live-build inside Docker. X11 with no window
  manager, Chromium in kiosk mode loading `file:///opt/shell/index.html`. The shell is
  plain HTML/CSS/Canvas/JS with no framework.
- Alternatives: Alpine or Buildroot base; Wayland with a kiosk compositor; Electron;
  React/Vue for the shell.
- Why: live-build is the standard way to make a Debian ISO and runs unattended in CI.
  X11 plus Chromium kiosk is the smallest path to a fullscreen web UI. No framework keeps
  the shell small, offline and easy to reason about on a low-power VM.

## D-002 Fonts
- Decision: DotGothic16 (SIL OFL) as the primary face. Fallbacks, in order: Misaki Gothic,
  PixelMplus12, PixelMplus10, then generic `monospace`. The shell's CSS already lists this
  stack. The font files themselves are not in the repo yet: vendoring them (with the OFL
  text in `shell/fonts/`) is the first font task in P1.
- Alternatives: Press Start 2P, Silkscreen, a system font.
- Why: DotGothic16 has real Japanese glyph coverage in a pixel style, which fits the
  anime/PS2-era look, and its license allows bundling. Fonts must ship inside the ISO
  because the shell loads from `file://` with no network.

## D-003 Windows host, CI builds the ISO
- Decision: The development host is Windows. GitHub Actions is the reference ISO build
  and the place to download it. `make iso` still works locally through Docker Desktop.
- Alternatives: build only locally under WSL2; a Linux VM as the build host.
- Why: live-build needs root, mounts and device nodes. CI gives a clean, identical
  Linux environment on every push and removes local setup from the loop.

## D-004 Build on the container's own filesystem
- Decision: `docker/build-iso.sh` copies `image/` and `shell/` to `/tmp/ps2os-lb` inside
  the container, builds there, and copies only the finished ISO and log to the
  bind-mounted `out/`.
- Alternatives: run `lb build` directly in the bind-mounted repo; a named Docker volume.
- Why: debootstrap cannot create device nodes or symlinks on a Windows/NTFS bind mount,
  so building in the mount would fail on the user's own machine.

## D-005 One build path for local and CI
- Decision: `make iso` is the only entry point. It builds the `ps2os-builder` image and
  runs the build in a `--privileged` container. CI calls exactly that.
- Alternatives: CI runs `lb build` on the runner; CI uses the workflow `container:` key.
- Why: what CI builds is what a local run builds. The `container:` key would need
  privileged options and a second code path.

## D-006 BIOS hybrid ISO first
- Decision: `--binary-images iso-hybrid --bootloaders syslinux`. No UEFI yet. No installer,
  no memtest, no firmware packages, `main` archive area only.
- Alternatives: add `grub-efi` now; include the Debian installer.
- Why: VirtualBox boots BIOS by default, and the smallest config is the least likely to
  fail on the very first CI run. UEFI can be added when a target machine needs it.

## D-007 Phases P1..P8 are a proposal
- Decision: P1..P8 in ROADMAP.md were drafted by the agent from AGENTS.md. Only P0's
  content was specified by the owner.
- Alternatives: leave P1..P8 as bare names.
- Why: later sessions need a concrete "done when" to work against. Reordering is cheap.

## D-008 Line endings, and Docker image contents
- Decision: `.gitattributes` forces LF for `.sh`, `.md`, `Makefile`, `image/`, `shell/`,
  and also for `docker/` and `.github/`. The builder image installs live-build with
  its recommended packages and a few extras (isolinux, syslinux-utils, mtools, dosfstools).
- Alternatives: LF only for the paths first listed; `--no-install-recommends`.
- Why: CRLF in a Dockerfile or workflow breaks line continuations on Windows checkouts.
  A smaller image saves little compared with a late build failure from a missing tool.

## D-009 CI details
- Decision: the workflow runs on every push and on manual dispatch. It uploads
  `out/ps2os.iso` as artifact `ps2os-iso` and `out/build.log` as `build-log`, both kept 7
  days. The ISO is uploaded without extra compression because it is already compressed.
  Actions are pinned to major version 4.
- Alternatives: only build on `main`; publish ISOs as releases.
- Why: building every push catches breakage early. Releases are a P8 concern.
