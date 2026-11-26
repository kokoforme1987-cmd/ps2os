# State

Last updated: 2026-11-26

## Done
- P0 bootstrap files: `.gitignore`, `.gitattributes`, `docker/Dockerfile`,
  `docker/build-iso.sh`, `Makefile` (setup / iso / vm / qemu / clean),
  `.github/workflows/build-iso.yml`, `image/` live-build config, `shell/index.html`,
  `README.md`, and `docs/` (ROADMAP, DECISIONS, STATE).
- First CI run: live-build itself completed ("Build completed successfully").
- Fixed the exit 141 that followed it: SIGPIPE from `grep -q` / `head` pipelines under
  pipefail in `docker/build-iso.sh` (D-010). Reproduced against stub tools, old script exits
  141, new script exits 0, and exits 1 with a message if the shell page is missing.

## In progress
- Nothing.

## Next 3
1. Confirm the next `build-iso` run is fully green and the `ps2os-iso` artifact boots
   (`make vm` or `make qemu`).
2. P1: add X11, Chromium and an autostart to `image/config/` so the ISO boots into the
   kiosk on `file:///opt/shell/index.html`.
3. P1: vendor DotGothic16 into `shell/fonts/` with its OFL text and add the
   `@font-face` rule.

## Known issues
- The fix for the 141 was tested against stubs only. Docker and network access are not
  available where it was written, so the real check is the next CI run. Test command, on a
  machine with Docker: `make iso && make qemu`.
- No ISO from CI has been booted yet.
- DotGothic16 is named in the CSS but not bundled; until P1 the page falls back to
  `monospace`.
- On Windows, `make` needs GNU make (Git Bash, WSL, or `choco install make`). The
  exec bit on `image/auto/config` does not survive Windows checkouts; the build script
  re-applies it in the container.
