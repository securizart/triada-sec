# ARM64-NOTES.md — arm64/16k verdict per tool (ADR 007)

Lookup table, not prose. One line per tool, exactly one verdict:
  <tool>  <VERDICT>  <ref>  # note
Verdicts (ADR 007): APT-OK · APT? · APT-16K? · SOURCE · ALT · NO-ARM64 · OUT-SCOPE
All lines here are INHERITED from the satellite (Ubuntu noble) until re-verified
on trixie/arm64/16k. Inherited = strong hint, not a guarantee. Ref codes:
  ik4(=iK4lN3 packages-apt.txt) · ik4-skip · remnux-silent · remnux-nopkg · virt(=forensics-* virtual)

## APT-OK  (verified on trixie via -s; core tier)
snowdrop        APT-OK  catalog+s(trixie)  -- text watermarking, stego
creddump7       APT-OK  catalog+s(trixie)  # registry secrets, post-mortem
regripper       APT-OK  catalog+s(trixie)  # registry hive analysis
readpe          APT-OK  catalog+s(trixie)  # PE static analysis
missidentify    APT-OK  catalog+s(trixie)  # find Win32 executables
stegcracker     APT-OK  catalog+s(trixie)  # steghide payload brute-force
stegseek        APT-OK  catalog+s(trixie)  # fast steghide cracker
ssldump         APT-OK  catalog+s(trixie)  # TLS analysis on capture
dsniff          APT-OK  catalog+s(trixie)  # cleartext creds in seized traffic
exifprobe       APT-OK  catalog+s(trixie)  # image metadata
ed2k-hash       APT-OK  catalog+s(trixie)  # ed2k hashing
argon2          APT-OK  catalog+s(trixie)  # argon2 hashing util
ccrypt          APT-OK  catalog+s(trixie)  # file encrypt/decrypt
bruteforce-luks APT-OK  catalog+s(trixie)  # LUKS passphrase recovery (evidence access)
bruteforce-salted-openssl  APT-OK  catalog+s(trixie)  # OpenSSL passphrase recovery
bruteforce-wallet  APT-OK  catalog+s(trixie)  # encrypted wallet passphrase
rephrase        APT-OK  catalog+s(trixie)  # GnuPG passphrase recovery
usbrip          APT-OK  catalog+s(trixie)  # USB device artifacts
forensic-artifacts  APT-OK  catalog+s(trixie)  # forensic artifacts DB (data)
forensics-colorize  APT-OK  catalog+s(trixie)  # colorized diff for analysis
graudit         APT-OK  catalog+s(trixie)  # source-code audit by patterns
gpshell         APT-OK  catalog+s(trixie)  # smartcard scripting (GlobalPlatform)
de4dot          APT-OK  catalog+s(trixie) -- installs clean; Mono inst=49, assigned to full (Reason C)
time-decode     APT-OK  catalog+s(trixie) -- installs clean; Qt6 inst=40, assigned to full (Reason C)
sleuthkit       APT-OK  catalog+s(trixie)  # The Sleuth Kit; not from satellite
ewf-tools       APT-OK  catalog+s(trixie)  # E01/EWF acquisition
xmount          APT-OK  catalog+s(trixie)  # forensic image mounting, write-blocking
tcpdump         APT-OK  catalog+s(trixie)  # network capture

## APT?  (satellite built via apt on Ubuntu noble; needs trixie -s check)

### Disk imaging & acquisition
dc3dd           APT-OK  ik4+s(trixie)
dcfldd          APT?  ik4
gddrescue       APT?  ik4   # binary: ddrescue
ddrescueview    APT?  ik4
afflib-tools    APT-OK  ik4+s(trixie)
pff-tools       APT?  ik4
safecopy        APT-OK  ik4+s(trixie)
myrescue        APT-OK  ik4+s(trixie)

### Filesystem / partition analysis
disktype        APT?  ik4
testdisk        APT?  ik4   # also ships photorec
gpart           APT-OK  ik4+s(trixie)
fatcat          APT-OK  ik4+s(trixie)
hfsprogs        APT?  ik4
exfat-fuse      APT?  ik4
f2fs-tools      APT?  ik4
ext3grep        APT-OK  ik4+s(trixie)
ext4magic       APT-OK  ik4+s(trixie)
extundelete     APT-OK  ik4+s(trixie)
scrounge-ntfs   APT-OK  ik4+s(trixie)
dislocker       APT?  ik4
zulucrypt-cli   APT?  ik4
cryptmount      APT?  ik4

### File carving & recovery
foremost        APT?  ik4
scalpel         APT-OK  ik4+s(trixie)
magicrescue     APT-OK  ik4+s(trixie)
recoverjpeg     APT-OK  ik4+s(trixie)
recoverdm       APT-OK  ik4+s(trixie)
fdupes          APT?  ik4
jdupes          APT?  ik4

### Hashing & integrity
hashdeep        APT-OK  ik4+s(trixie)   # package: md5deep
ssdeep          APT-OK  ik4+s(trixie)
hashid          APT-OK  ik4+s(trixie)
hashrat         APT-OK  ik4+s(trixie)
rhash           APT-OK  ik4+s(trixie)
gtkhash         APT?  ik4

### Memory forensics
memdump         APT-OK  ik4+s(trixie)
aesfix          APT-OK  ik4+s(trixie)
rsakeyfind      APT-OK  ik4+s(trixie)
unhide          APT-OK  ik4+s(trixie)
mac-robber      APT-OK  ik4+s(trixie)
tableau-parm    APT-OK  ik4+s(trixie)

### Windows artifacts / registry
galleta         APT-OK  ik4+s(trixie)
pasco           APT-OK  ik4+s(trixie)
rifiuti         APT-OK  ik4+s(trixie)
rifiuti2        APT-OK  ik4+s(trixie)
vinetto         APT-OK  ik4+s(trixie)
undbx           APT-OK  ik4+s(trixie)
reglookup       APT-OK  ik4+s(trixie)
winregfs        APT-OK  ik4+s(trixie)
grokevt         APT-OK  ik4+s(trixie)
chntpw          APT?  ik4
samdump2        APT-OK  ik4+s(trixie)

### Timeline / triage
python3-plaso   APT?  ik4   # binaries: log2timeline.py, psort.py
mdbtools        APT?  ik4

### Hex / binary editors & RE
hexedit         APT?  ik4
dhex            APT?  ik4
hexcompare      APT?  ik4
shed            APT-OK  ik4+s(trixie)
ghex            APT?  ik4
wxhexeditor     APT?  ik4
radare2         KALI-OK  kali+s(trixie) -- --no-install-recommends, no libc bump
capstone-tool   APT-OK  ik4+s(trixie)
binwalk         APT?  ik4

### Steganography
steghide        APT-OK  ik4+s(trixie)
stegsnow        APT-OK  ik4+s(trixie)
stegosuite      APT?  ik4
outguess        APT-OK  ik4+s(trixie)
gifshuffle      APT?  ik4
stepic          APT?  ik4

### Metadata / images / documents
exif            APT?  ik4
exiftags        APT?  ik4
exiv2           APT?  ik4
metacam         APT-OK  ik4+s(trixie)
libimage-exiftool-perl  APT?  ik4   # binary: exiftool
antiword        APT?  ik4
catdoc          APT?  ik4
unrtf           APT?  ik4
pev             APT-OK  ik4+s(trixie)

### Secure wipe
nwipe           APT?  ik4
wipe            APT-OK  ik4+s(trixie)
bleachbit       APT?  ik4

### Network forensics / capture
wireshark       APT?  ik4
tshark          APT?  ik4
tcpflow         APT?  ik4
tcpick          APT-OK  ik4+s(trixie)
tcpreplay       APT?  ik4
tcptrace        APT?  ik4
tcpxtract       APT?  ik4
ngrep           APT-OK  ik4+s(trixie)
chaosreader     APT-OK  ik4+s(trixie)
netdiscover     APT?  ik4
nbtscan         APT-OK  ik4+s(trixie)
arp-scan        APT?  ik4

### Anti-rootkit / audit
chkrootkit      APT-OK  ik4+s(trixie)
rkhunter        APT?  ik4
lynis           APT?  ik4

### Password recovery — file/disk (forensic, in scope)
fcrackzip       APT-OK  ik4+s(trixie)
pdfcrack        APT?  ik4
rarcrack        APT?  ik4
sipcrack        APT?  ik4
ophcrack        APT?  ik4
ophcrack-cli    APT-OK  ik4+s(trixie)

## APT-16K?  (in apt somewhere, but satellite saw x86-64 inside / exec risk)
cutter          APT-16K?  remnux-silent  # ELF x86-64 on noble; verify rizin-cutter arm64 on trixie

## SOURCE  (no arm64 apt build; satellite builds from source — ADR 006)
rizin           SOURCE  kali-breaks-base  -- Kali binary needs libc>=2.42, build from source
floss           SOURCE  remnux-nopkg   # FLARE FLOSS (Mandiant)
manalyze        SOURCE  remnux-nopkg
pycdc           SOURCE  remnux-nopkg   # + pycdas
bearparser      SOURCE  remnux-nopkg   # binary: bearcommander
portex          SOURCE  remnux-nopkg   # Java
signsrch        SOURCE  remnux-nopkg
xorsearch       SOURCE  remnux-nopkg   # DidierStevensSuite python
binee           SOURCE  remnux-nopkg
evilclippy      SOURCE  remnux-nopkg   # Go
sandfly-processdecloak  SOURCE  remnux-nopkg   # Go
redress         SOURCE  remnux-nopkg   # Go native (goretk/redress)
yara-x          SOURCE  remnux-nopkg   # yr, cargo via rustup
msoffice-crypt  SOURCE  remnux-nopkg
ilspycmd        SOURCE  remnux-nopkg   # .NET
baksmali        SOURCE  remnux-nopkg   # Dalvik, Java
jd-gui          SOURCE  remnux-nopkg   # Java GUI
android-project-creator  SOURCE  remnux-nopkg   # Java jar

## ALT  (no arm64 build; use the native substitute — substitute is APT?)
aeskeyfind      ALT  ik4-skip  # -> aesfix + rsakeyfind (both APT?). SOURCE build also possible; prefer ALT first
rar             ALT  ik4-skip  # -> unar / p7zip for extraction (create-rar has no arm64)

## NO-ARM64  (no arm64 build, no alternative — dropped, documented)
cmospwd         NO-ARM64  ik4-skip  # x86 CMOS; meaningless on Apple Silicon
ree             NO-ARM64  virt      # reads x86 option ROMs
grub-rescue-pc  NO-ARM64  virt      # x86 BIOS GRUB
syslinux        NO-ARM64  ik4-skip  # x86 BIOS bootloader
syslinux-utils  NO-ARM64  ik4-skip
memtest86+      NO-ARM64  ik4-skip  # x86 memtest

## OUT-SCOPE  (not a DFIR tool)
ntopng          OUT-SCOPE  virt  # -> BLUE (network monitoring)
vuls            OUT-SCOPE  virt  # -> BLUE (vuln scanner)
wapiti          OUT-SCOPE  catalog  # -> RED (web scanner; already full in RED, breaks base)
hydra           OUT-SCOPE  ik4  # -> RED (network auth attack; already in RED 40-cracking)
hydra-gtk       OUT-SCOPE  ik4  # -> RED
medusa          OUT-SCOPE  ik4  # -> RED
ncrack          OUT-SCOPE  ik4  # -> RED
john            OUT-SCOPE  ik4  # -> RED (already in RED 40-cracking)
