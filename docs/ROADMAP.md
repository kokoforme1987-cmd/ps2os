# Roadmap

Phases P0..P8. The phase list below beyond P0 was drafted from AGENTS.md (see
DECISIONS.md D-007) and can be reordered.

**Current phase: P0**

| Phase | Name | Done when |
| --- | --- | --- |
| **P0** (current) | Bootstrap | Repo scaffold, builder container, `make` targets, CI builds and uploads the ISO, placeholder shell page, docs. No real OS work yet. |
| P1 | Boot to kiosk | The ISO boots in VirtualBox straight into X11 with no window manager and Chromium in kiosk mode on `file:///opt/shell/index.html`. DotGothic16 vendored with its OFL text. |
| P2 | Shell core | Canvas render loop, fixed internal resolution scaled to the screen, keyboard and gamepad input, focus and menu navigation. |
| P3 | Visual identity | Original PS2-era-style animated background, boot sequence, icon set and type scale. Original assets only. |
| P4 | Launcher | Shell launches system apps (terminal, file browser, browser) through a small local bridge and returns to the shell on exit. |
| P5 | Audio | Original UI sounds and background music, volume control. |
| P6 | System settings | Display, network, time, shutdown and reboot from inside the shell. |
| P7 | Persistence and install | Optional persistence on the live USB or disk, and installing to disk. |
| P8 | Release | Versioned release ISOs, tags, checksums, polished docs. |
