# 003 — Debian-first sourcing for the default tier

## Decision
Build the `default` tier from the **Debian Security Tools** catalog first
(metapackages `forensics-all`, `forensics-all-gui`, `forensics-extra` — a
broad security set, not only forensics), and reach for Kali only to fill the
gaps Debian does not cover (burpsuite, nuclei, amass, metasploit, wpscan,
gophish, AD collectors...).

Rationale: Debian-native packages are built against the stable base, so they
are **base-safe and 16k-safe by construction** (apt compiles for the running
page size; no 4k prebuilt binaries). This is cleaner and more maintainable
than "filtered Kali", and keeps the distro closer to its Debian base — the
same base the Asahi boot chain is validated against.

Method note: the `kali-*` and `forensics-*` metapackages are used as a
**reference catalog only — never installed** (installing them drags unwanted
tools and, for kali-*, breaks the base). Mine the menu, don't eat the buffet.

## Refined golden rule (supersedes the naive "is it in a repo?")
A tool goes to `default` only if:
  1. it exists in the Debian or (pinned) Kali repo, AND
  2. `apt-get install -s <tool>` does NOT pull a newer libc or python3.
If it is in a repo but `-s` raises libc/python3.14/newer-module -> it breaks
the base -> `full` (isolated pipx/gem/container).

**The `-s` dry-run is the arbiter; the catalog is only the hint.**
Example that proves it: `wapiti` is in the Debian catalog, yet its Debian
package pulls mitmproxy -> python3.14 -> libc 2.42 and breaks the base. It
stays in `full`. (First assumed it could drop to default from Debian — the
`-s` corrected that.)

## Gotcha — .gitignore blocks `*password*`
`.gitignore:16` has `*password*`. Any NEW file whose path contains "password"
is silently ignored by git (exists on disk, never tracked, absent from
`git status`). The core list `core/40-password.list` survives only because it
was committed BEFORE that rule was added (git keeps tracking already-tracked
files). New lists must avoid the word: we use `40-cracking.list` in default.

## Consistency check (Phase 4)
A `.list` on disk that is NOT declared in `profile.conf` disappears from its
tier with no error. Phase 4 must run a check that every `packages/**/*.list`
is referenced in `profile.conf` (and vice-versa). This bit us twice while
wiring default_lists.
