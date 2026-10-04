#!/usr/bin/env bash
# check-profile.sh - QA: cada .list en disco <-> declarada en profile.conf.
# Tambien detecta listas no trackeadas bloqueadas por .gitignore (gotcha *password*).
# Exit 0 si todo consistente; 1 si hay inconsistencias (apto para CI / Fase 4).
set -uo pipefail
cd "$(git rev-parse --show-toplevel 2>/dev/null)" || { echo "Ejecuta dentro del repo"; exit 1; }
rc=0; shopt -s nullglob
for conf in profiles/*/profile.conf; do
  pdir=$(dirname "$conf"); prof=$(basename "$pdir")
  echo "== profile: $prof =="
  declared=$(grep -E '^(core|default|full|hardware)_lists=' "$conf" | sed 's/^[^=]*=//' \
    | tr ' ' '\n' | grep -E '\.list$' | sed "s#^#$pdir/#" | sort -u)
  ondisk=$(find "$pdir/packages" -type f -name '*.list' 2>/dev/null | sort -u)
  while IFS= read -r file; do [ -z "$file" ] && continue
    grep -qxF "$file" <<<"$declared" || { echo "  [ORPHAN]  en disco, NO declarada: $file"; rc=1; }
    git check-ignore -q "$file" && { echo "  [IGNORED] .gitignore la bloquea (no trackeada): $file"; rc=1; }
  done <<<"$ondisk"
  while IFS= read -r file; do [ -z "$file" ] && continue
    [ -f "$file" ] || { echo "  [MISSING] declarada, NO en disco: $file"; rc=1; }
  done <<<"$declared"
  echo "  declaradas=$(grep -c . <<<"$declared")  en-disco=$(grep -c . <<<"$ondisk")"
done
[ "$rc" -eq 0 ] && echo "OK - listas consistentes (disco <-> profile.conf)" || echo "FAIL - inconsistencias (ver arriba)"
exit $rc
