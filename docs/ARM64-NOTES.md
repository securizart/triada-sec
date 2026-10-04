# ARM64-NOTES.md — arm64/16k verdict per tool (ADR 007)

Lookup table, not prose. One line per tool, exactly one verdict:
  <tool>  <VERDICT>  <ref>  # note
Verdicts (ADR 007): APT-OK · APT? · APT-16K? · SOURCE · ALT · NO-ARM64 · OUT-SCOPE
All lines here are INHERITED from the satellite (Ubuntu noble) until re-verified
on trixie/arm64/16k. Inherited = strong hint, not a guarantee. Ref codes:
  ik4(=iK4lN3 packages-apt.txt) · ik4-skip · remnux-silent · remnux-nopkg · virt(=forensics-* virtual)

## APT-OK  (verified on trixie via -s; core tier)
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
hashid          APT?  ik4
hashrat         APT?  ik4
rhash           APT-OK  ik4+s(trixie)
gtkhash         APT?  ik4

### Memory forensics
memdump         APT?  ik4
aesfix          APT?  ik4
rsakeyfind      APT?  ik4
unhide          APT?  ik4
mac-robber      APT?  ik4
tableau-parm    APT-OK  ik4+s(trixie)

### Windows artifacts / registry
galleta         APT?  ik4
pasco           APT?  ik4
rifiuti         APT?  ik4
rifiuti2        APT?  ik4
vinetto         APT?  ik4
undbx           APT?  ik4
reglookup       APT?  ik4
winregfs        APT?  ik4
grokevt         APT?  ik4
chntpw          APT?  ik4
samdump2        APT?  ik4

### Timeline / triage
python3-plaso   APT?  ik4   # binaries: log2timeline.py, psort.py
mdbtools        APT?  ik4

### Hex / binary editors & RE
hexedit         APT?  ik4
dhex            APT?  ik4
hexcompare      APT?  ik4
shed            APT?  ik4
ghex            APT?  ik4
wxhexeditor     APT?  ik4
radare2         APT?  ik4   # catalog also had it KALI-only (Debian retired it)
capstone-tool   APT?  ik4
binwalk         APT?  ik4

### Steganography
steghide        APT?  ik4
stegsnow        APT?  ik4
stegosuite      APT?  ik4
outguess        APT?  ik4
gifshuffle      APT?  ik4
stepic          APT?  ik4

### Metadata / images / documents
exif            APT?  ik4
exiftags        APT?  ik4
exiv2           APT?  ik4
metacam         APT?  ik4
libimage-exiftool-perl  APT?  ik4   # binary: exiftool
antiword        APT?  ik4
catdoc          APT?  ik4
unrtf           APT?  ik4
pev             APT?  ik4

### Secure wipe
nwipe           APT?  ik4
wipe            APT?  ik4
bleachbit       APT?  ik4

### Network forensics / capture
wireshark       APT?  ik4
tshark          APT?  ik4
tcpflow         APT?  ik4
tcpick          APT?  ik4
tcpreplay       APT?  ik4
tcptrace        APT?  ik4
tcpxtract       APT?  ik4
ngrep           APT?  ik4
chaosreader     APT?  ik4
netdiscover     APT?  ik4
nbtscan         APT?  ik4
arp-scan        APT?  ik4

### Anti-rootkit / audit
chkrootkit      APT?  ik4
rkhunter        APT?  ik4
lynis           APT?  ik4

### Password recovery — file/disk (forensic, in scope)
fcrackzip       APT?  ik4
pdfcrack        APT?  ik4
rarcrack        APT?  ik4
sipcrack        APT?  ik4
ophcrack        APT?  ik4
ophcrack-cli    APT?  ik4

## APT-16K?  (in apt somewhere, but satellite saw x86-64 inside / exec risk)
cutter          APT-16K?  remnux-silent  # ELF x86-64 on noble; verify rizin-cutter arm64 on trixie

## SOURCE  (no arm64 apt build; satellite builds from source — ADR 006)
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
