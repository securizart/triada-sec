# Compatibility matrix

## Layer A — UTM VM on M2 (validated, Phase 2)

| Item | Value |
|---|---|
| Base | Debian 13 "Trixie" (stable) |
| Kernel | `6.12.111+deb13-arm64-16k` |
| Page size | 16384 (16 KiB) — reproduces the Mac |
| Session | GNOME / Wayland |
| Mesa | 25.1.0 (Bananas) |
| GL renderer | virgl -> ANGLE -> Metal (Apple M2) |
| glmark2 | 775 (was 550 on Debian's Mesa 25.0.7) |
| Storage | external SSD (exFAT), isolated from Layer B |

Diagnostic note: on virtio-gpu, `eglinfo -B` reports `llvmpipe` via the
default (surfaceless) platform even when the session is accelerated. The
valid measure of acceleration is `glmark2-wayland` / Mutter, not `eglinfo`.

## Pinning evidence (Phase 2)

`u-boot-asahi`: Debian ships `2025.01-3+deb13u1` (newer, mainline, no Asahi
patches); Bananas ships `2025.01-1` (older, with Asahi patches). The 1050 pin
makes APT pick the Bananas one **despite being older** — required for metal to
boot. Verified with `apt-cache policy u-boot-asahi`.

## Pending real-hardware (M1) validation

1. Bananas pin over the REAL Asahi kernel / u-boot (VM only proves it
   resolves).
2. Apply and verify `lib/hold-boot-family.sh hold` on the cloned base; then
   install a distro layer and confirm the Mac still boots after reboot.
3. GDM-on-Bananas behaviour with `securizart`'s expired password (graphical
   change may differ from the SSH/TTY path).
4. Wayland overlay on the Bananas GNOME (not only the netinst GNOME).

## Hardware note (M1 vs M2)

On real hardware, M1 (G13 GPU) has working hardware GL; M2 (G14) falls back to
software rendering under the current Asahi kernel. This is a metal concern,
not a VM concern (the VM uses virgl, not AGX).

## Phase 3 — Red tools, 16k verification (VM)

All via apt (Debian/Kali arm64 binaries are built for 16k). Each ran without
`Bus error` on the 16k VM:

| Tool | Lang | Source | 16k |
|---|---|---|---|
| nmap, masscan, whois, dnsutils, netcat-openbsd | C/mixed | Debian | OK |
| gobuster | Go | Debian | OK |
| dirb | C | Debian | OK |
| sqlmap, wfuzz | Python | Debian | OK (interpreted) |
| whatweb | Ruby | Debian | OK (interpreted) |
| nikto | Perl | Kali (non-free) | OK (interpreted) |
| tshark, tcpdump, ettercap, dsniff, macchanger | C | Debian | OK |
| bettercap | Go | Debian | OK |

Interpreted tools (Python/Perl/Ruby) have no 16k risk. Compiled tools (C/Go)
from apt are built for 16k. Real 16k risk is prebuilt binaries fetched OUTSIDE
apt (GitHub releases, AppImages) — verified case by case.

Pending on M1: Wi-Fi monitor mode / packet injection for ettercap/bettercap
(needs the Mac's Broadcom chip, absent in the VM).

## Update policy (all profiles)

Automatic updates are **disabled by design** (apt-daily timers masked,
fwupd-refresh disabled, GNOME Software set to notify-but-not-download). An
unattended update could break the Apple Silicon boot chain. Update manually
and deliberately with `sudo triada-update`, which refreshes, simulates, checks
that the Asahi boot family is not touched, and asks for confirmation before
applying. Trade-off: security updates are NOT applied automatically — the user
must run `triada-update` periodically. GNOME notifies when updates exist.

## Phase 3 — Red complete (password + wireless), 16k verification (VM)

| Tool | Lang | Source | 16k | Notes |
|---|---|---|---|---|
| hydra, medusa, crunch | C | Debian | OK | |
| john (+john-data) | C | Debian | OK | binary in /usr/sbin |
| hashid | Python | Debian | OK | |
| hashcat | C | Debian | OK | --no-install-recommends; OpenCL via PoCL (CPU) works in VM |
| aircrack-ng, reaver, pixiewps, mdk4 | C | Debian | OK (arranca) | wireless function = M1 only |
| wifite | Python | Debian | OK (arranca) | /usr/sbin |
| hcxtools, hcxdumptool | C | Debian | OK (arranca) | |

Privileged tools live in /usr/sbin (invoked with sudo): john suite, dsniff
suite, wifite, mdk4, aircrack-ng's airmon/airodump/aireplay. `command not
found` as a normal user is expected, not a failure.

## Mesa drivers — why the Bananas pin is mandatory (confirmed by Debian wiki)

Debian does NOT ship the Asahi AGX Mesa drivers in Trixie (only the generic
Mesa, no AGX acceleration). The AGX drivers were upstreamed in Mesa 25.1,
after Trixie. They must come from Bananas (we run 25.1.0). The 1050 pin is
therefore mandatory, not optional: if the generic Debian Mesa won on metal,
AGX acceleration would be lost (cf. the M2 software-render issue). Source:
Debian wiki Teams/Bananas and InstallingDebianOn/Apple/M1.

## hashcat + GPU AGX on metal — viable via rusticl (corrected outlook)

The Asahi Mesa (Bananas, >=24.3) ships **rusticl**, which exposes the M1/M2
GPU as an OpenCL device — Apple Silicon on Asahi is the first Khronos-listed
conformant OpenCL 3.1 implementation via rusticl. So on metal, `hashcat -I`
should list the AGX GPU alongside the CPU. Caveat from field reports: GPU
compute can hang the GUI (GPU preemption not implemented yet) and perf is
below macOS; prefer cracking from a TTY without an active graphical session.
Verify on M1: clinfo detects AGX, hashcat -I lists it, short benchmark.

## Red profile — M1-pending block (function not verifiable in VM)

- **Wireless (whole group)**: monitor mode / capture / injection on the Mac's
  Broadcom chip — the hardest offensive unknown. VM has only virtio-net.
- **hashcat GPU** via rusticl (see above).
- **Live network capture** (tshark/ettercap/bettercap) on a physical interface.

## Architecture decision: stable base, never testing

The base stays Debian stable (Trixie). Migrating to testing would unblock
bleeding-edge tools (Python 3.14 / libc 2.42) but risks the Asahi boot chain,
loses security support, and breaks reproducibility. Bleeding-edge tools go to
the full tier via pipx/gem/container instead. See docs/FULL-TOOLS.md.

## Red default tier — added tools (16k-OK, base untouched)
recon/OSINT: dnsrecon, dnsenum, fierce, recon-ng, sublist3r, amass
vuln: nuclei
Active Directory: smbmap, impacket-scripts, enum4linux, responder,
  sharphound, azurehound
