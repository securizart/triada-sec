# Architecture

## Two-layer model

The base (GNOME + kernel) is always supplied by the environment; this project
does not rebuild it. On top of the base we apply the **securizart layer**.
             base (provided by the environment)

metal: Debian/Asahi (Bananas) clone — Asahi kernel, m1n1/U-Boot
vm: mmdebstrap rootfs/qcow2 — Debian generic 16k kernel, UTM/edk2
|
+----------------+----------------+
| securizart layer |
| common: securizart user, |
| Wayland enforcement |
| per-distro: branding, boot |
| splash, LUKS unlock |
+----------------+----------------+
|
Red (offensive) | Blue (defensive) | DFIR (forensics)


## Branches: vm vs metal

| | vm (Layer A) | metal (Layer B) |
|---|---|---|
| Base origin | mmdebstrap rootfs/qcow2 | clone of Debian/Asahi (Bananas) |
| Kernel | `linux-image-arm64-16k` (Debian) | Asahi kernel (Bananas, 6.17) |
| Boot | UEFI (edk2) + GRUB | m1n1 -> U-Boot -> GRUB |
| Graphics | virgl (virtio-gpu -> ANGLE -> Metal) | Mesa Asahi (AGX) |
| Page size | 16 KiB (reproduces the Mac) | 16 KiB (native) |
| Boot-family hold | no-op (kernel stays updatable) | applied (protects boot) |

The VM reproduces the Mac's **16 KiB page size** so that 4k-only prebuilt
binaries fail during the build, not on the user's Mac. virgl is NOT the Asahi
AGX driver: real GPU behaviour is only validated on metal.

## Delivery

- **metal:** a rootfs cloned to a LUKS-encrypted external disk (as in the
  prior installer), preserving the Asahi boot chain. A rootfs is NOT bootable
  on a Mac by itself — never install GRUB/m1n1 by hand against internal
  partitions.
- **vm:** mmdebstrap builds the rootfs; a packaging step turns it into a
  bootable qcow2 for UTM. A clonable "mother" VM is used for fast iteration.

## Build tooling

`mmdebstrap` (declarative, reproducible, native arm64) produces the VM rootfs.
It must run on a **16k arm64 host** (this VM or the M1) — never under
`qemu-user` on x86, which would hide 16k incompatibilities.
