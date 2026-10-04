#!/usr/bin/env bash
# new-profile.sh - scaffold a new profile.
# Copies ONLY the Kali layer (kali.sources, kali.pref, kali-archive.fpr) from an
# existing profile and writes a clean profile.conf with empty tiers.
# NEVER copies anything from bananas (Asahi base, see ADR 005).
set -euo pipefail
die(){ echo "ERROR: $*" >&2; exit 1; }
usage="uso: $0 <perfil-origen> <perfil-nuevo> \"<title>\" \"<description>\""
src=${1:?$usage}; dst=${2:?$usage}; title=${3:?$usage}; desc=${4:?$usage}
cd "$(git rev-parse --show-toplevel)" || die "ejecuta dentro del repo"
[[ $dst =~ ^[a-z0-9-]+$ ]] || die "nombre de perfil invalido: $dst"
S=profiles/$src; D=profiles/$dst
[ -e "$D" ] && die "$D ya existe; no sobrescribo"
for f in kali.sources kali.pref kali-archive.fpr; do
  [ -f "$S/apt/$f" ] || die "falta $S/apt/$f en el origen"
done
mkdir -p "$D/packages/core" "$D/packages/default" "$D/apt"
touch "$D/packages/core/.gitkeep" "$D/packages/default/.gitkeep"
for f in kali.sources kali.pref kali-archive.fpr; do
  install -m 0644 "$S/apt/$f" "$D/apt/$f"
done
{
  printf '# triada-sec \xc2\xb7 %s profile\n' "${dst^^}"
  printf 'name=%s\ntitle=%s\ndescription=%s\n' "$dst" "$title" "$desc"
  printf 'apt_sources=%s/apt/kali.sources\n' "$D"
  printf 'apt_prefs=%s/apt/kali.pref\n' "$D"
  printf 'apt_keyfpr=%s/apt/kali-archive.fpr\n' "$D"
  printf '\n# --- TIER: core (always) ---\ncore_lists=\n'
  printf '\n# --- TIER: default (core + these) ---\ndefault_lists=\n'
  printf '\n# --- TIER: full (default + isolated/heavy tools) \xe2\x80\x94 FUTURE ---\n'
  printf '# See docs/FULL-TOOLS.md.\n'
} > "$D/profile.conf"
echo "OK - andamiaje creado en $D"
