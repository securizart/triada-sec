# 001 — SSH banner-exchange timeout after sysprep

**Labels:** build, sysprep, ssh
**Affects:** VM mother image (Layer A)
**Status:** Fixed in sysprep v2

## Symptom
After generalising a VM with the first sysprep and cloning it, SSH into the
clone hangs and fails with `Connection timed out during banner exchange`.
The TCP connection is established (no "connection refused"), but the server
never sends its SSH banner. `ssh.socket` is active; `ssh.service` is
`inactive (dead)` with a pending `start` job; `sshd -t` reports the config is
valid and the host keys exist.

## Root cause
The first sysprep regenerated host keys with
`dpkg-reconfigure openssh-server`. That left the
`sshd-keygen.service -> ssh.service` activation chain in a state where the
server would not start on the clone, so nothing produced the banner.

## Fix (sysprep v2)
- Regenerate host keys with `ssh-keygen -A` (writes only the missing keys;
  does not touch debconf or service activation).
- The first-boot oneshot unit declares `Before=ssh.service ssh.socket
  sshd-keygen.service` and `ConditionPathExistsGlob=!/etc/ssh/ssh_host_*_key`,
  so keys exist before any SSH activation path runs, and the unit is
  idempotent (does nothing once keys are present).
- Also `systemctl enable ssh.socket` so clones listen out of the box.

## Verification
On a clean clone of `debian-16k-base-RAW` + sysprep v2, a child clone boots
with a working SSH (keys unique per clone), unique machine-id, with no manual
intervention.
