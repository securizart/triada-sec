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
