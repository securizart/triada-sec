# Full tier — tools not installable cleanly from apt on the stable base

The base is always Debian stable (Trixie). It is NOT migrated to testing
despite that unblocking more tools, because the risk to the Asahi boot chain
(kernel/u-boot/Mesa validated against stable), the loss of security support,
and reproducibility are not worth it for a security distro. Tools that clash
with the stable base's libc/Python go to the **full** tier, installed in
isolated environments (pipx for Python, gem --user for Ruby, or containers)
that bring their own dependencies without touching the base.

## Three categories of blockage (seen building Red default)

1. **Touches libc/base** — needs a newer libc/Python than stable ships.
   - wapiti (-> mitmproxy -> python3.14 -> libc 2.42)
   - gvm-tools (-> python3-gvm/libpython3.14 -> libc 2.42) + openvas
   - crackmapexec (-> python3-aardwolf -> python3 >= 3.14)
2. **Language-package version conflict** (not libc) — gems/modules clash.
   - evil-winrm (-> ruby-winrm -> ruby-zip >= 3.0, have 2.3.2)
   - theharvester (-> python3-aiodns/uvloop too new)
3. **Heavy platform** — works but disproportionate for default.
   - bloodhound CE (full platform + neo4j). Default ships only the
     collectors (sharphound, azurehound, ~16 MB).

## Install method in full (future)
- Python tools: `pipx install <tool>` (respects EXTERNALLY-MANAGED, isolated venv).
- Ruby tools: `gem install --user-install <tool>`.
- Platforms (bloodhound CE, openvas/gvm): container or dedicated setup.
- openvas/gvm: review Greenbone license (community vs enterprise feed) first.

## Method note
`apt-get install --simulate` shows if the base is touched, but NOT size.
For suspected-heavy tools, also check "After this operation, X will be used".
After a `remove`, review what `autoremove` proposes before running it with -y
(it can sweep shared deps like kali-defaults and wanted collectors).

## Declared full tools (install recipe)

### netexec (nxc) — INSTALLED
- roles: [vulnerability/credentials] [active-directory]
- install: `pipx install git+https://github.com/Pennyw0rth/NetExec`
- build-deps: pipx git rustc cargo build-essential python3-dev
- why full: Kali .deb needs python3 >= 3.14 (forbidden on the stable base)
- 16k: OK (netifaces/arc4 C-extensions compile against system python 3.13)
- replaces: crackmapexec (same python3.14 clash, blocked)

## Full roster by reason

Tools live in `full` for one of two distinct reasons. The `-s` dry-run is the
arbiter: a tool is only default-eligible if `apt-get install -s` does NOT raise
libc/python3. "In a repo" is necessary but NOT sufficient (wapiti is in Debian
yet still breaks the base).

### Reason A — breaks the stable base (libc / python3.14 / newer module)
Must be installed isolated (pipx/gem). Confirmed via `-s`:
- wapiti        -> mitmproxy -> python3-mitmproxy-rs -> libpython3.14 -> libc 2.42
                  (breaks from BOTH Debian and Kali)
- theharvester  -> python3-aiodns >= 4.0 (base has 3.2.0)
- evil-winrm    -> ruby-nori >= 2.7.1 (base has 2.6.0)  [gem install]
- faraday       -> python3-mako >= 1.3.10 (base has 1.3.9)
- legion        -> libpython3.14-stdlib -> libc 2.42
- crackmapexec  -> python3-aardwolf -> python3 >= 3.14   (superseded by netexec)
- gvm-tools/openvas -> libpython3.14 -> libc 2.42  (+ Greenbone license review)

### Reason B — installs clean but needs a backend/account (not base breakage)
`-s` is clean, but unfit for a "install-and-run" default:
- starkiller    -> GUI client, needs PowerShell Empire backend running
- beef-xss      -> raises a service + its own DB
- maltego       -> Java client, requires registering an account to be useful
- bloodhound-CE -> full platform + neo4j (default ships only the collectors)

## Install method in full
- Python: `pipx install <tool>` (or `git+https://...` when not on PyPI).
- Ruby:   `gem install --user-install <tool>`.
- Platforms: container / dedicated setup; review licenses (openvas) first.

### Reason A — additions (base breakage, confirmed via -s)
- wpscan     -> ruby-addressable >= 2.9 (base 2.8.7)  [gem]
- proxmark3  -> libc6 >= 2.42 (base 2.41)  [+ needs physical reader/firmware]

## Reason C — disproportionate weight for niche/absent hardware
Installs clean, no base breakage, no backend — but pulls a huge dependency tree
to support a specific, expensive, rarely-present device. Excluded from default
by curation, not by a technical blocker. `apt install` adds it when the hardware
shows up.
- uhd-host   -> 218 pkgs (USRP/Ettus SDR driver + boost/DSP/build stack).
               Kali ships it in kali-tools-sdr for max hardware coverage;
               triada-sec curates for known hardware. Common SDRs (RTL-SDR,
               HackRF) are covered by the lighter default+hardware tools.
- gqrx-sdr   -> pulls dkms (compiles kernel modules) — forbidden on Asahi base.
- gnuradio (+gr-*), uhd-images -> heavyweight SDR framework + firmware blobs.
- spiderfoot -> 63 pkgs (OSINT platform: local web server + scan DB).
               Curation call: too heavy for the base; optional/full.
