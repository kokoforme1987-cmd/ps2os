# ps2os

A hobby Linux distro with a Japanese/anime look and a PS2-era feel. It boots from
an ISO (made for VirtualBox) and runs a fullscreen HTML/CSS/JS shell in a Chromium
kiosk on bare X11. Debian bookworm, built with live-build inside Docker. All assets
are original.

Status: Phase 0 (bootstrap). The ISO is a plain Debian live image plus a placeholder
shell page. See [docs/ROADMAP.md](docs/ROADMAP.md) and [docs/STATE.md](docs/STATE.md).

## Download the ISO built by CI

Every push to any branch runs the `build-iso` workflow.

1. Open the [Actions tab](https://github.com/kokoforme1987-cmd/ps2os/actions/workflows/build-iso.yml).
2. Open the latest green run.
3. Under **Artifacts**, download `ps2os-iso` (a zip containing `ps2os.iso`).

You need to be signed in to GitHub to download artifacts, and they are deleted after
7 days. With the GitHub CLI:

```
gh run download --repo kokoforme1987-cmd/ps2os --name ps2os-iso --dir out
```

Boot it in VirtualBox: new VM, type Linux / Debian (64-bit), 2 GB RAM, attach
`ps2os.iso` as the optical drive. Or put it at `out/ps2os.iso` and run `make vm`.

## Build locally

Needs GNU make and Docker (Docker Desktop is fine on Windows; run from Git Bash or WSL).

```
make setup   # build the builder image
make iso     # build out/ps2os.iso inside the container
make vm      # VirtualBox VM + boot (needs VBoxManage on PATH)
make qemu    # boot in QEMU (QEMU_ACCEL=whpx on Windows, kvm on Linux)
make clean
```

## Layout

| Path | What |
| --- | --- |
| `AGENTS.md` | standing rules for every session |
| `docker/` | builder image and the in-container build script |
| `image/` | live-build config |
| `shell/` | the HTML shell, shipped at `/opt/shell` in the ISO |
| `docs/` | roadmap, decisions, current state |
| `.github/workflows/` | CI that builds the ISO |
