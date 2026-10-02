# Changelog

Format based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).
All dates in YYYY-MM-DD. Versions track project phases.

## [0.3.0] - 2026-10-02

Phase 3 begins — the Red (offensive) profile. Kali repository added and
pinned defensively; first three curated tool groups installed and verified on
the VM, without touching the Asahi base.

### Added
- **Kali repository, pinned to 100** (`profiles/red/apt/kali.sources`,
  `kali.pref`): below Debian's 500, so Kali never installs/upgrades
  automatically — only explicitly named packages. Keys (2025 + 2012) verified.
  Bananas (1050) still beats Kali on shared packages (e.g. `u-boot-asahi`), so
  the boot base stays protected.
- **Red tool groups** (`profiles/red/packages/`): recon, web (+ nikto from
  Kali), network/MITM. All 16k-verified; see docs/COMPATIBILITY.md.
- **securizart no-root capture**: wireshark group + debconf preseed.
- `profiles/red/profile.conf`, `docs/issues/002` (metapackage finding).

### Notes
- Golden rule: curated tools; Debian by default; `<pkg>/kali-rolling` for
  Kali-only; **never** `-t kali-rolling`. See docs/issues/002.
- Kali keyring created by procedure (not committed); fingerprints in
  docs/LICENSING.md.
## [0.2.0] - 2026-10-02

Phase 2 — common base — complete on the VM layer (Layer A). Debian 13 + the
Bananas Asahi archive, pinned; the common `securizart` user; Wayland enforced;
and the boot-family protection mechanism.

### Added
- **APT: Bananas archive + pinning.** `base/apt/sources/bananas.sources`
  (deb822, suite `trixie-bananas`, `Signed-By` the Bananas keyring) and
  `base/apt/preferences.d/bananas.pref` (official priority **1050**). The
  pin makes APT prefer Bananas' `u-boot-asahi` and Asahi kernel even over a
  newer Debian version — essential so the boot chain keeps the Apple Silicon
  patches. Bananas signing key verified: ed25519 fingerprint
  `0D61 768E 5A01 8502 46E6 9BDA F58B 90AE 2107 6A1A`, valid 2025-01-24 to
  2030-01-23, uid `team+bananas@tracker.debian.org`.
- **Common user `securizart`** (`base/overlay/10-create-user-securizart.sh`):
  idempotent, minimal-privilege groups (`sudo`, `wireshark`, `plugdev` — each
  created if missing), sudo WITH password (not NOPASSWD), disposable initial
  password and forced change on first login (`chage -d 0`). No credential is
  baked into the repository.
- **Wayland enforced** (`base/overlay/etc/gdm3/daemon.conf`,
  `WaylandEnable=true`) — keeps GNOME on Wayland and away from the Xorg/GLX
  crash seen on Apple Silicon in prior work.
- **Boot-family protection** (`lib/hold-boot-family.sh`): branch-aware helper
  that `apt-mark hold`s the Asahi kernel + `u-boot-asahi` + Mesa on **metal**,
  and is a deliberate no-op on **vm** (the generic 16k kernel must stay
  updatable). Branch detection via `/proc/device-tree/compatible`.
- **VM generalisation** (`images/vm/mother/sysprep.sh`): turns the working VM
  into a clonable mother image. Resets machine-id, host SSH keys (regenerated
  per clone on first boot via a oneshot unit), logs and APT state. Guarded to
  abort if run on real Apple/Asahi hardware.
- **VM-only APT tweak** (`images/vm/overlay/.../99force-ipv4`): forces IPv4 in
  the VM, whose network has no IPv6 route to the Bananas host. Not applied on
  metal.

### Notes
- Mesa comes from Bananas (25.1.0) in both branches; in the VM it keeps virgl
  working and improved it (glmark2 550 -> 775). See `docs/COMPATIBILITY.md`.
- Pending real-hardware (M1) validation is tracked in `docs/COMPATIBILITY.md`.
- First recorded issue (SSH banner-exchange timeout after sysprep) in
  `docs/issues/001-ssh-banner-exchange-sysprep.md`.
