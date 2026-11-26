# ps2os — Standing Rules

In-house hobby OS: Japanese/anime-styled, PS2-era-themed Linux distro.
Boots from ISO in VirtualBox, runs a custom fullscreen HTML/CSS/JS shell.

Stack (locked unless DECISIONS.md says otherwise):
- Debian bookworm, live-build inside Docker
- X11, no window manager, Chromium kiosk -> file:///opt/shell/index.html
- Shell = HTML/CSS/Canvas/JS, no framework
- Fonts: DotGothic16 (OFL) + pixel fallback (Misaki Gothic / PixelMplus)
- Original assets only. No Sony bitmaps, fonts, or ripped audio in the repo.

Every session:
1. Read docs/STATE.md, docs/ROADMAP.md, docs/DECISIONS.md, last 5 commits.
   Print a 5-line state summary, then continue.
2. Work autonomously to completion. Log every technical decision in
   docs/DECISIONS.md (decision / alternatives / why). Ask only if genuinely
   ambiguous or if it could damage the host machine.
3. Real, runnable deliverables. No stubs, no TODOs except those tracked in STATE.md.
4. Build and test what you can. If you can't boot a VM here, make the build
   reproducible and print the exact one-line test command.
5. End every session: build -> fix or document failures -> rewrite
   docs/STATE.md (Done / In progress / Next 3 / Known issues) -> commit ->
   push -> tag if milestone -> print 10-line handoff summary.
