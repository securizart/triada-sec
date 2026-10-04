# 006 — DFIR source tier: non-apt forensic tools, versioned build, final binary isolated from toolchain

Debian-first plus the `-s` gate decides the apt tiers (core, default). But DFIR
needs forensic/RE tools that are NOT packaged for Debian/Kali on arm64 and that
the satellite project (forensic-distros-silicon-external-disk) already resolved
by building from source or fetching an official arm64 binary: floss, manalyze,
pycdc, aeskeyfind, bearparser, portex, signsrch, and similar. Dropping them
would lose the field-tested arm64 recipes; apt cannot carry them.

New tier `source`, declared in profile.conf as `source_lists=`, with its own
lists under profiles/dfir/packages/source/NN-group.list and one build script per
tool under profiles/dfir/build/NN-tool.sh. It is NOT an apt tier: the `-s` gate
does not apply. Each source tool gets its own gate instead:

1. arm64 verdict first. A tool enters `source` only if ARM64-NOTES.md (ADR 007)
   marks it SOURCE. NO-ARM64 and ALT never enter; APT-OK/APT-16K? stay in apt.
2. Smoke test EXECUTES the final binary, never just compiles it. A binary that
   builds on arm64 can still die on 16k pages (hardcoded 4k assumptions, fixed
   mmap alignment). Compiling clean is not passing; running clean is.
3. Toolchain isolation (the base-protection rule, same spirit as the `-s` gate
   for apt). Build dependencies (build-essential, cmake, cargo, go, JDK) are
   installed to build and the FINAL ARTIFACT ONLY goes to the system, in
   /usr/local/bin (or /opt for bundles with a wrapper). The build toolchain is
   NEVER part of the shipped distro image: it is resolved at build time and left
   out of the VM/baremetal deliverable. A build script that cannot produce a
   standalone artifact without leaving its toolchain installed does not qualify
   for `source` — it goes to `full` for later, isolated packaging.
4. No base contamination. A build step must never pull a newer libc or
   python3.14 into the base. Language toolchains that need a newer compiler than
   Debian ships (e.g. yara-x needs rustc newer than apt's) use a user-space
   toolchain (rustup, a vendored Go) confined to the build, never an apt upgrade
   of the base.

Build scripts are adapted from the satellite's remnux-installer.sh "extra" phase
(the 20 NO-PKG tools), re-targeted from Ubuntu noble to Debian trixie: Debian
package names for build-deps, Debian paths, and a re-run of the smoke test on
this base. The satellite recipe is the starting point, not the final word — each
is re-verified on trixie/arm64/16k before it enters the tier.

Relation to `full`: `full` is heavy platforms with a backend (Autopsy, cutter +
rz-ghidra) packaged in isolation at the end of the project. `source` is
light, self-contained CLI tools built from source now, as part of DFIR default
capability. A tool whose build drags a heavy runtime or cannot be isolated
belongs to `full`, not `source`.
