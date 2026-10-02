# 002 — Kali metapackages destroy the base; `-t kali-rolling` migrates libc

**Labels:** build, apt, kali, phase-3
**Affects:** Red profile (any profile adding Kali)
**Status:** Resolved by design (curated tools + per-package pinning)

## Symptom
Installing `kali-linux-core` with `-t kali-rolling` on the common base
(Debian 13 + Bananas) proposed: 164 upgraded, 80 new, **34 removed** —
including the entire GNOME desktop (`gnome`, `gnome-shell`, `gdm3`,
`mutter`...) and a migration of `libc6`, `perl`, `python3` from Debian
stable to Kali/testing versions. Rebooting would have left the system with
no desktop and a testing-grade base.

## Root cause
1. **`kali-linux-*` metapackages are designed to BE the system**, not to sit
   as a layer on another base. `kali-system-core` / `kali-defaults` reconfigure
   the system the Kali way, pulling in a GNOME replacement and removing the
   existing one.
2. **`-t kali-rolling` raises the whole Kali repo above everything for the
   entire transaction**, not just the named package. Every dependency (libc6,
   perl, ...) is then taken from Kali, defeating the 100-priority pin.

## Resolution (the golden rule)
- **Never install `kali-linux-*` metapackages** on this base.
- **Never use `-t kali-rolling`** (global override).
- Install **curated individual tools**. Debian wins by default (pin 100 keeps
  Kali below Debian's 500).
- For a tool that exists **only** in Kali, install it as
  `apt install <pkg>/kali-rolling` — takes that one package from Kali but
  resolves dependencies with normal priorities (Debian wins where it can,
  libc stays Debian). Verified with `nikto/kali-rolling`: nikto from Kali,
  libc6 untouched (stayed 2.41-...+deb13u4).

## Verification
After installing recon + web + network groups this way: GNOME intact,
`libc6` still Debian, `getconf PAGESIZE` 16384, all tools run without
`Bus error`.
