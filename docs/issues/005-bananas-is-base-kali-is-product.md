# 005 — Bananas/Asahi is base, not product; triada-sec only manages the Kali layer

Every triada-sec machine has a three-layer apt stack:

    trixie-bananas (Asahi: 16k kernel, u-boot, mesa/GPU)   pin 1050
    Debian trixie (main/security/updates)                  pin 500
    kali-rolling                                           pin 100

Bananas is BASE. It ships with the Debian/Asahi mother image and is inherited
intact when a VM is cloned. Breaking it compromises boot (m1n1/U-Boot chain on
baremetal) and the GPU stack. Therefore no triada-sec script writes, copies,
moves or deletes any bananas file. Reading is allowed ONLY to verify the base
(apply-kali-layer.sh checks bananas.pref pins 1050 and refuses to run otherwise).
Bananas files are never part of profiles/*/apt/.

Bananas files on the base: /etc/apt/sources.list.d/bananas.sources,
/etc/apt/preferences.d/bananas.pref and /etc/apt/keyrings/bananas-archive-keyring.gpg
(canonical location, referenced by Signed-By). The Kali key is installed in the
same /etc/apt/keyrings/ directory under its own name; nothing else there is touched.

The Kali layer is PRODUCT and the only apt layer triada-sec manages, per profile,
declared in profile.conf as apt_sources / apt_prefs / apt_keyfpr:

    profiles/<distro>/apt/kali.sources      deb822, Signed-By /etc/apt/keyrings/...
    profiles/<distro>/apt/kali.pref         Pin: release n=kali-rolling, 100
    profiles/<distro>/apt/kali-archive.fpr  expected key fingerprint (text)

The Kali key itself is NOT versioned (.gitignore: *.gpg — binary keyrings never
go into git). That left v0.6.0 non-reproducible: the RED key had been placed by
hand. Fix: version the FINGERPRINT. bin/apply-kali-layer.sh downloads
archive-key.asc over HTTPS, requires exactly one primary key equal to the .fpr,
installs it, then verifies the post-state (kali 100, bananas 1050, no Kali
package pulled by dist-upgrade). Any failure after install rolls back the three
Kali files only. The script rejects any profile path outside
profiles/<distro>/apt/ or naming bananas.

Current key: Kali Linux Archive Automatic Signing Key (2025),
827C8569F2518CC677FECA1AED65462EC8D5E4C5, expires 2028-04-17. On rotation or
expiry: update every profiles/*/apt/kali-archive.fpr in a single commit, taking
the fingerprint from kali.org — never from a mirror.
