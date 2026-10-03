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
