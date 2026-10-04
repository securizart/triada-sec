# 004 — "In kali-default" does not mean "in our default"

kali-linux-default optimizes GENERALIST coverage: it supports any hardware or
use case "just in case", because Kali does not know what the user will plug in
or do. triada-sec is a CURATED distro for a known purpose and known hardware.

Therefore: the diff against kali-default tells us what EXISTS. What ENTERS our
default is decided by our own value/weight/purpose criteria PLUS the `-s` gate.
"It is in kali-default" is a hint, never a sufficient reason — exactly like
"it is in a repo" was not (wapiti breaks the base despite being in Debian).

Examples excluded despite being in kali-default:
- uhd-host (218 pkgs for an absent USRP) -> full, Reason C.
- gqrx-sdr (pulls dkms, compiles kernel modules) -> full, Asahi red line.
- qemu-system-x86 / qemu-user -> NOT arsenal. They are emulators; Kali ships
  them as firmware/binary-emulation support. They belong to the TESTING/BUILD
  environment (the baremetal M1/M2 bench may need qemu to emulate/validate
  images or foreign-arch binaries), never inside any distro (Red/Blue/DFIR) —
  same way UTM itself is not shipped inside the distro.
