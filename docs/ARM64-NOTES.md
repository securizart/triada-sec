# ARM64-NOTES.md — arm64/16k verdict per tool (ADR 007)

Lookup table, not prose. One line per tool, exactly one verdict:
  <tool>  <VERDICT>  <ref>  # note
Verdicts (ADR 007): APT-OK · APT? · APT-16K? · SOURCE · ALT · NO-ARM64 · OUT-SCOPE
All lines here are INHERITED from the satellite (Ubuntu noble) until re-verified
on trixie/arm64/16k. Inherited = strong hint, not a guarantee. Ref codes:
  ik4(=iK4lN3 packages-apt.txt) · ik4-skip · remnux-silent · remnux-nopkg · virt(=forensics-* virtual)

## APT-OK  (verified on trixie via -s; core tier)
arc             APT-OK  catalog+s(trixie)  -- extraction
brotli          APT-OK  catalog+s(trixie)  -- extraction
bzip3           APT-OK  catalog+s(trixie)  -- extraction
cabextract      APT-OK  catalog+s(trixie)  -- extraction (MS cab)
clzip           APT-OK  catalog+s(trixie)  -- extraction
comprez         APT-OK  catalog+s(trixie)  -- extraction
dact            APT-OK  catalog+s(trixie)  -- extraction
lrzip           APT-OK  catalog+s(trixie)  -- extraction
lz4             APT-OK  catalog+s(trixie)  -- extraction
lzop            APT-OK  catalog+s(trixie)  -- extraction
minizip         APT-OK  catalog+s(trixie)  -- extraction
mscompress      APT-OK  catalog+s(trixie)  -- extraction
ncompress       APT-OK  catalog+s(trixie)  -- extraction
nomarch         APT-OK  catalog+s(trixie)  -- extraction (arj)
plzip           APT-OK  catalog+s(trixie)  -- extraction
rzip            APT-OK  catalog+s(trixie)  -- extraction
squashfs-tools-ng  APT-OK  catalog+s(trixie)  -- extraction
ugrep           APT-OK  catalog+s(trixie)  -- grep in archives
unrar-free      APT-OK  catalog+s(trixie)  -- extraction (rar)
wzip            APT-OK  catalog+s(trixie)  -- extraction
zpaq            APT-OK  catalog+s(trixie)  -- extraction
binutils        APT-OK  catalog+s(trixie)  -- RE: objdump/readelf/strings
nasm            APT-OK  catalog+s(trixie)  -- RE: assembler
ddrutility      APT-OK  catalog+s(trixie)  -- ddrescue helper
dares           APT-OK  catalog+s(trixie)  -- data recovery
erofs-utils     APT-OK  catalog+s(trixie)  -- EROFS
exfatprogs      APT-OK  catalog+s(trixie)  -- exFAT (already in base)
gdisk           APT-OK  catalog+s(trixie)  -- GPT
parted          APT-OK  catalog+s(trixie)  -- partitions (already in base)
pcapfix         APT-OK  catalog+s(trixie)  -- repair pcap
pcaputils       APT-OK  catalog+s(trixie)  -- pcap utils
ipgrab          APT-OK  catalog+s(trixie)  -- header dump
dhcpdump        APT-OK  catalog+s(trixie)  -- DHCP traffic
sngrep          APT-OK  catalog+s(trixie)  -- SIP flows (VoIP forensics)
sipgrep         APT-OK  catalog+s(trixie)  -- SIP grep
secure-delete   APT-OK  catalog+s(trixie)  -- secure wipe
mboxgrep        APT-OK  catalog+s(trixie)  -- mbox search
mblaze          APT-OK  catalog+s(trixie)  -- maildir/MH mail
mpack           APT-OK  catalog+s(trixie)  -- MIME pack/unpack
pngcheck        APT-OK  catalog+s(trixie)  -- PNG analysis
psrip           APT-OK  catalog+s(trixie)  -- extract images from PS
imageindex      APT-OK  catalog+s(trixie)  -- HTML image gallery of evidence
pecomato        APT-OK  catalog+s(trixie)  -- PE editor/analyzer
readstat        APT-OK  catalog+s(trixie)  -- SPSS/SAS/Stata data
ansifilter      APT-OK  catalog+s(trixie)  -- ANSI text conversion
uni2ascii       APT-OK  catalog+s(trixie)  -- unicode<->ascii
dictconv        APT-OK  catalog+s(trixie)  -- dictionary conversion
memstat         APT-OK  catalog+s(trixie)  -- memory by process
openpace        APT-OK  catalog+s(trixie)  -- eID crypto (PACE)
funcoeszz       APT-OK  catalog+s(trixie)  -- shell utilities
hwinfo          APT-OK  catalog+s(trixie)  -- hardware inventory (live triage)
lshw            APT-OK  catalog+s(trixie)  -- hardware list
dmidecode       APT-OK  catalog+s(trixie)  -- DMI/SMBIOS (already in base)
inxi            APT-OK  catalog+s(trixie)  -- system summary
wamerican       APT-OK  catalog+s(trixie)  -- en-US dict (cracking)
wbritish        APT-OK  catalog+s(trixie)  -- en-GB dict (cracking)
guestfs-tools   APT-OK  catalog+s(trixie)  -- installs clean but inst=116 (libguestfs+qemu); full, baremetal-relevant (Reason C)
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
dcfldd          APT-OK  ik4+s(trixie)
gddrescue       APT-OK  ik4+s(trixie)   # binary: ddrescue
ddrescueview    APT?  ik4
afflib-tools    APT-OK  ik4+s(trixie)
pff-tools       APT?  ik4
safecopy        APT-OK  ik4+s(trixie)
myrescue        APT-OK  ik4+s(trixie)

### Filesystem / partition analysis
disktype        APT-OK  ik4+s(trixie)
testdisk        APT-OK  ik4+s(trixie)   # also ships photorec
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
cryptmount      APT-OK  ik4+s(trixie)

### File carving & recovery
foremost        APT-OK  ik4+s(trixie)
scalpel         APT-OK  ik4+s(trixie)
magicrescue     APT-OK  ik4+s(trixie)
recoverjpeg     APT-OK  ik4+s(trixie)
recoverdm       APT-OK  ik4+s(trixie)
fdupes          APT-OK  ik4+s(trixie)
jdupes          APT-OK  ik4+s(trixie)

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
chntpw          APT-OK  ik4+s(trixie)
samdump2        APT-OK  ik4+s(trixie)

### Timeline / triage
python3-plaso   APT?  ik4   # binaries: log2timeline.py, psort.py
mdbtools        APT?  ik4

### Hex / binary editors & RE
hexedit         APT-OK  ik4+s(trixie)
dhex            APT?  ik4
hexcompare      APT-OK  ik4+s(trixie)
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
stepic          APT-OK  ik4+s(trixie)

### Metadata / images / documents
exif            APT-OK  ik4+s(trixie)
exiftags        APT-OK  ik4+s(trixie)
exiv2           APT-OK  ik4+s(trixie)
metacam         APT-OK  ik4+s(trixie)
libimage-exiftool-perl  APT-OK  ik4+s(trixie)   # binary: exiftool
antiword        APT?  ik4
catdoc          APT?  ik4
unrtf           APT?  ik4
pev             APT-OK  ik4+s(trixie)

### Secure wipe
nwipe           APT-OK  ik4+s(trixie)
wipe            APT-OK  ik4+s(trixie)
bleachbit       APT?  ik4

### Network forensics / capture
wireshark       APT?  ik4
tshark          APT-OK  ik4+s(trixie)
tcpflow         APT-OK  ik4+s(trixie)
tcpick          APT-OK  ik4+s(trixie)
tcpreplay       APT-OK  ik4+s(trixie)
tcptrace        APT-OK  ik4+s(trixie)
tcpxtract       SOURCE  ik4  -- not in trixie/kali (no candidate); build from source
ngrep           APT-OK  ik4+s(trixie)
chaosreader     APT-OK  ik4+s(trixie)
netdiscover     APT-OK  ik4+s(trixie)
nbtscan         APT-OK  ik4+s(trixie)
arp-scan        APT?  ik4

### Anti-rootkit / audit
chkrootkit      APT-OK  ik4+s(trixie)
rkhunter        APT?  ik4
lynis           APT-OK  ik4+s(trixie)

### Password recovery — file/disk (forensic, in scope)
fcrackzip       APT-OK  ik4+s(trixie)
pdfcrack        APT-OK  ik4+s(trixie)
rarcrack        APT-OK  ik4+s(trixie)
sipcrack        APT-OK  ik4+s(trixie)
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
