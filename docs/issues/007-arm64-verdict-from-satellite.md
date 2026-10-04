# 007 — arm64 verdict inherited from the satellite: closed vocabulary in ARM64-NOTES.md

The satellite project (forensic-distros-silicon-external-disk) field-tested the
SIFT/REMnux/iK4lN3 forensic toolset on Ubuntu/Asahi arm64 and recorded, per tool,
what actually works on this architecture: iK4lN3's packages-skip.txt (X86/PC/PPA/
OLD/KERNEL classes), REMnux's exclude-list.txt (LOUD/SILENT/PIP-TAG/BUILD/NO-PKG/
SALT-MOD/CASCADE), and remnux-installer.sh's 20 resolved NO-PKG build recipes.
That knowledge was paid for with real-hardware runs; losing it means re-
discovering each arm64 failure during DFIR smoke tests.

Caveat: the satellite is Ubuntu noble + PPA/Salt; DFIR is Debian trixie + Kali.
Package NAMES and availability differ. So the satellite verdict is a HINT about
the architecture reality (does an arm64 build exist? does the binary run?), never
a package-name source for a .list. The `-s` gate still decides apt entry; the
arm64 verdict decides which gate (apt vs source) and flags execution risk the
`-s` gate cannot see (a binary that installs fine but is x86-64 inside).

docs/ARM64-NOTES.md records one line per tool with exactly ONE verdict from this
closed set:

  APT-OK     arm64 build in Debian/Kali, passes `-s`            -> core or default
  KALI-OK    installs clean from Kali (pin 100), base untouched   -> default (kali only, no Debian build)
  APT-16K?   in apt, but satellite flagged an execution risk    -> apt + priority smoke test
  APT?       satellite built it via apt on Ubuntu noble; unverified   -> apt tier after trixie -s check
  SOURCE     no arm64 apt build; satellite builds from source   -> source tier (ADR 006)
  NO-ARM64   no arm64 build and no alternative                  -> dropped, documented
  ALT        no arm64, but a native substitute exists           -> use the substitute
  OUT-SCOPE  not a DFIR tool (BLUE/RED territory)               -> noted for that distro

Line format (one tool per line):
  <tool>  <VERDICT>  <origin/substitute/recipe ref>  # note

Rules:
- Exactly one verdict per tool. If reality changes (a tool gains an arm64 build),
  edit the line; do not add a second.
- A verdict is INHERITED (from the satellite) until re-verified on trixie/arm64/
  16k; a re-verified line says so in its note. Inherited is a strong hint, not a
  guarantee: Ubuntu noble having an arm64 build does not prove Debian trixie does.
- KALI-OK is for a tool with no Debian build whose Kali candidate installs clean
  under pin 100 (no libc/python3 bump). Verified with `apt-get install -s`, often
  needing --no-install-recommends. It is NOT APT-OK (that means Debian). A Kali
  candidate that would bump libc or python3 is NOT KALI-OK: it is SOURCE or full.
- APT? is the inherited state of a tool the satellite installed via apt on Ubuntu
  noble. It becomes APT-OK only after `apt-get install -s` passes on trixie, or
  SOURCE / NO-ARM64 if it is not in Debian/Kali for arm64. Ubuntu noble package
  names and availability do not carry over to Debian trixie unchanged.
- NO-ARM64 and ALT tools never enter any tier. ALT names its substitute so the
  substitute can be picked up by the apt tiers (e.g. aeskeyfind ALT -> aesfix +
  rsakeyfind, both APT-OK).
- The file is a lookup table, not prose. No narrative, no per-tool paragraphs.
