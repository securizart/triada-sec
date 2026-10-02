# Known issues

Each has a write-up under [`docs/issues/`](issues/) (symptom, root cause,
workaround/fix, status).

| # | Issue | Affects | Status |
|---|---|---|---|
| 001 | [SSH banner-exchange timeout after sysprep](issues/001-ssh-banner-exchange-sysprep.md) | VM mother image | **Fixed** (sysprep v2) |

## Quick reference

- **SSH times out at "banner exchange" on a freshly cloned VM** -> the old
  sysprep used `dpkg-reconfigure openssh-server`, which left the
  `sshd-keygen.service -> ssh.service` chain unable to start the server.
  Fixed in sysprep v2 (`ssh-keygen -A` + `Before=sshd-keygen.service`).

## Carried over from prior work (relevant on metal)

- **Sudden power-off right after GRUB, after a macOS update** -> SMC firmware
  change; per-boot workaround: append `modprobe.blacklist=macsmc_power` to the
  GRUB `linux` line. Not made permanent on purpose.
- **GPU GL on M2 falls back to software** under the current Asahi kernel.
