# Licensing and third-party sources

## This project's own code
All original code and documentation in `triada-sec` (scripts, configuration,
docs) is licensed under **GPL-3.0** — see [../LICENSE](../LICENSE).

## Third-party software: not redistributed
`triada-sec` does **not** repackage or redistribute any third-party packages.
It adds the **official repositories** of each distribution and lets `apt`
install packages **directly from their own servers**. Each installed package
keeps its own upstream license; this project only provides the recipe to reach
those official repos.

## Trademarks
Installing a project's packages is not the same as using its trademark.
"Kali Linux" (OffSec), "Parrot" (Parrot Security), and others are trademarks
of their owners. `triada-sec`'s distributions are named Red / Blue / DFIR and
do not claim to be official products of, or endorsed by, those projects.

## Per-source register (to be completed in Phase 3)
As package sources are added, each row records: source, official repo URL,
license under which it installs, and any trademark/usage note.

| Source | Official repo | Installs under | Notes |
|---|---|---|---|
| Debian | deb.debian.org | per-package | base |
| Bananas (Asahi for Debian) | bananas-archive.debian.net | per-package (mostly GPL) | kernel/u-boot/mesa |
| _(Kali, Parrot, SIFT, REMnux, ... — Phase 3)_ | | | |

## Phase 3 additions (Red profile)

| Source | Official repo | Installs under | Notes |
|---|---|---|---|
| Kali Linux | http.kali.org/kali | per-package | Added as `kali-rolling`, pinned to 100 (below Debian). Only explicitly named packages install; `-t kali-rolling` never used. Keys verified (2025 `827C8569...ED65462EC8D5E4C5`; 2012 `44C6513A...ED444FF07D8D0BF6`). |
| nikto | http.kali.org/kali (**non-free**) | nikto's own license | Web scanner, Kali **non-free** only. Installed via `nikto/kali-rolling`. non-free = not fully DFSG-free per Debian; redistributable, documented for transparency. |

Most Red tools (nmap, sqlmap, gobuster, dirb, whatweb, wfuzz, tshark,
tcpdump, ettercap, bettercap, dsniff, macchanger, masscan, dnsutils, whois,
netcat) install from **Debian stable** under their own upstream licenses.
