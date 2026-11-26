# State

Last updated: 2026-11-26

## Done
- P0 bootstrap files written: `.gitignore`, `.gitattributes`, `docker/Dockerfile`,
  `docker/build-iso.sh`, `Makefile` (setup / iso / vm / qemu / clean),
  `.github/workflows/build-iso.yml`, `image/` live-build config, `shell/index.html`,
  `README.md`, and `docs/` (ROADMAP, DECISIONS, STATE).
- Static checks pass: shell syntax, workflow YAML, `make -n` on every target.

## In progress
- Nothing.

## Next 3
1. Open the Actions tab and confirm the first `build-iso` run is green and the
   `ps2os-iso` artifact boots (`make vm` or `make qemu`). Fix whatever it reports.
2. P1: add X11, Chromium and an autostart to `image/config/` so the ISO boots into the
   kiosk on `file:///opt/shell/index.html`.
3. P1: vendor DotGothic16 into `shell/fonts/` with its OFL text and add the
   `@font-face` rule.

## Known issues
- The ISO build has not been run anywhere yet. Docker and network access were not
  available when P0 was written, so only static checks were done. Test command, on a
  machine with Docker: `make iso && make qemu`.
- DotGothic16 is named in the CSS but not bundled; until P1 the page falls back to
  `monospace`.
- On Windows, `make` needs GNU make (Git Bash, WSL, or `choco install make`). The
  exec bit on `image/auto/config` does not survive Windows
  checkouts; the build script re-applies it in the container.
