# triada-sec

> Three specialised cybersecurity distributions for Apple Silicon (M1/M2),
> built on Debian + Asahi Linux, sharing one common base and a GNOME/Wayland
> desktop.

**Español:** see [README.es.md](README.es.md)

## The triad

The name is a nod to the **CIA triad** — Confidentiality, Integrity,
Availability — the foundation of information security. `triada-sec` embodies
it as three distributions:

| Distro | Role | Focus |
|---|---|---|
| **Red** | Offensive / Red Team | Pentesting, exploitation, network auditing (Kali / Parrot tooling) |
| **Blue** | Defensive / Blue Team | Hardening, monitoring, detection (Kali Purple reference) |
| **DFIR** | Forensics & Incident Response | Malware analysis, reverse engineering, forensics (SIFT / REMnux / CAINE) |

## Target hardware

Apple MacBook with **M1 or M2** (ARM64). Two validation layers:

- **Layer A — Virtualisation (UTM/QEMU):** fast iteration of the GNOME
  desktop, package installation and configuration scripts. Runs a **16 KiB
  page-size** kernel so it reproduces the Mac's memory layout.
- **Layer B — Real hardware (M1/M2):** raw performance and
  hardware-specific validation (native Wi-Fi monitor mode/injection, direct
  GPU access), plus the boot chain (m1n1/U-Boot).

## Design: two layers of configuration

The base GNOME + kernel is **always provided by the environment**, never
rebuilt by this project:

- **metal** → a clone of the Debian/Asahi (Bananas) install, with its Asahi
  kernel and m1n1/U-Boot already in place.
- **vm** → an mmdebstrap-built rootfs/qcow2 with Debian's generic 16k kernel,
  for UTM.

On top of that base we apply the **securizart layer**: GNOME configuration
plus each distro's package set. That layer is what this repository declares:
a **common** part (the `securizart` user, Wayland enforcement) and a
**per-distro** part (desktop branding, boot splash, LUKS unlock experience).

## Status

**Phase 2 (common base) complete** on the VM layer. See
[CHANGELOG.md](CHANGELOG.md) and [docs/](docs/).

## Risks

This project modifies partitioning and, on real hardware, interacts with the
Apple Silicon boot chain. **A mistake on metal can leave the Mac unable to
boot.** Deep Linux sysadmin knowledge is required (LUKS, LVM, chroot, GRUB,
APT pinning). Full backup before touching any disk. See
[docs/KNOWN_ISSUES.md](docs/KNOWN_ISSUES.md).

## Credits

Builds on the work of the [Asahi Linux](https://asahilinux.org) project and
the Debian [Bananas team](https://wiki.debian.org/Teams/Bananas).

## License

GPL-3.0 — see [LICENSE](LICENSE).
