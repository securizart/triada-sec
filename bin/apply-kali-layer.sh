#!/usr/bin/env bash
# apply-kali-layer.sh - apply a profile's Kali apt layer: sources + pref + key verified by fingerprint.
# Paths come from profile.conf (apt_sources / apt_prefs / apt_keyfpr).
# NEVER touches bananas (Asahi base). Rolls back its own files on failure. See ADR 005.
set -euo pipefail
K_SRC=/etc/apt/sources.list.d/kali.sources
K_PREF=/etc/apt/preferences.d/kali.pref
K_KEY=/etc/apt/keyrings/kali-archive-keyring.gpg
installed=0
die(){
  echo "ERROR: $*" >&2
  if [ "$installed" = 1 ]; then
    rm -f "$K_SRC" "$K_PREF" "$K_KEY"
    echo "ROLLBACK: capa Kali retirada (bananas intacto)" >&2
  fi
  exit 1
}
prof=${1:?uso: sudo $0 <perfil>}
[ "$(id -u)" -eq 0 ] || die "ejecutar con sudo"
[ "$(uname -m)" = aarch64 ] || die "arquitectura no aarch64"
cd "$(dirname "$(readlink -f "$0")")/.."
conf=profiles/$prof/profile.conf
[ -f "$conf" ] || die "no existe $conf"
get(){ sed -n "s/^$1=//p" "$conf" | head -n1; }
SRC=$(get apt_sources); PREF=$(get apt_prefs); FPR=$(get apt_keyfpr)
for f in "$SRC" "$PREF" "$FPR"; do
  [ -n "$f" ] || die "$conf: falta apt_sources, apt_prefs o apt_keyfpr"
  [[ $f == profiles/$prof/apt/* ]] || die "ruta fuera de profiles/$prof/apt/: $f"
  [[ $f != *bananas* ]] || die "ruta prohibida (bananas es base): $f"
  [ -f "$f" ] || die "no existe $f"
done
for c in curl gpg apt-cache apt-get; do command -v "$c" >/dev/null || die "falta $c"; done
# --- pre-validation: Asahi base present, Kali pin correct (read-only) ---
grep -q 'Pin-Priority: 1050' /etc/apt/preferences.d/bananas.pref 2>/dev/null \
  || die "bananas.pref ausente o sin 1050: base Asahi no verificada, aborto"
grep -qE '^Pin-Priority: 100$' "$PREF" || die "$PREF no fija prioridad 100"
expected=$(grep -v '^#' "$FPR" | tr -d ' \n' | tr 'a-f' 'A-F')
[[ $expected =~ ^[0-9A-F]{40}$ ]] || die "huella mal formada en $FPR"
# --- download + verify key in a throwaway keyring ---
tmp=$(mktemp -d); trap 'rm -rf "$tmp"' EXIT
export GNUPGHOME=$tmp/gnupg; install -d -m 700 "$GNUPGHOME"
curl -fsSL --proto '=https' --tlsv1.2 https://archive.kali.org/archive-key.asc -o "$tmp/key.asc" \
  || die "descarga de la clave fallida"
got=$(gpg --batch --show-keys --with-colons "$tmp/key.asc" \
  | awk -F: '$1=="pub"{p=1;next} p&&$1=="fpr"{print $10;p=0}')
n=$(grep -c . <<<"$got" || true)
[ "$n" -eq 1 ] || die "el fichero contiene $n claves primarias; se esperaba 1"
[ "$got" = "$expected" ] || die "HUELLA NO COINCIDE: obtenida $got / esperada $expected"
gpg --batch --yes --dearmor -o "$tmp/kali.gpg" "$tmp/key.asc"
# --- install (from here on, any failure rolls back) ---
installed=1
install -d -m 0755 /etc/apt/keyrings
install -m 0644 "$tmp/kali.gpg" "$K_KEY"
install -m 0644 "$SRC" "$K_SRC"
install -m 0644 "$PREF" "$K_PREF"
# --- post-verification ---
apt-get update -q || die "apt-get update fallo"
pol=$(apt-cache policy)
grep -qE '^ *100 .*kali-rolling' <<<"$pol" || die "kali-rolling no aparece con prioridad 100"
grep -qE '^ *1050 .*trixie-bananas' <<<"$pol" || die "trixie-bananas no aparece con 1050"
if apt-get -s dist-upgrade | grep -E '^Inst' | grep -qi kali; then
  die "dist-upgrade arrastraria paquetes de Kali sobre la base"
fi
echo "OK - capa Kali aplicada (perfil: $prof) - clave $expected verificada"
