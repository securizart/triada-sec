#!/bin/bash
# triada-sec — Common user 'securizart' provisioning
# Copyright (C) 2026 Securizart
# This program is free software: you can redistribute it and/or modify it
# under the terms of the GNU General Public License v3 as published by the
# Free Software Foundation. See <https://www.gnu.org/licenses/gpl-3.0.html>.

set -euo pipefail

USERNAME="securizart"
USER_UID="${SECURIZART_UID:-1000}"
USER_SHELL="/bin/bash"
GROUPS_COMMON="sudo wireshark plugdev"

[ "$(id -u)" -eq 0 ] || { echo "Ejecuta como root." >&2; exit 1; }

echo "[user] Asegurando grupos comunes (crea los que falten)..."
for g in $GROUPS_COMMON; do
    getent group "$g" >/dev/null || groupadd "$g"
done

if id "$USERNAME" >/dev/null 2>&1; then
    echo "[user] '$USERNAME' ya existe; solo ajusto grupos/shell."
else
    echo "[user] Creando '$USERNAME' (uid $USER_UID)..."
    if getent passwd "$USER_UID" >/dev/null; then
        echo "[user] UID $USER_UID ocupado; el sistema asignara uno libre."
        useradd -m -s "$USER_SHELL" -c "Securizart" "$USERNAME"
    else
        useradd -m -u "$USER_UID" -s "$USER_SHELL" -c "Securizart" "$USERNAME"
    fi
fi

echo "[user] Asignando grupos (append, nunca reemplaza)..."
usermod -aG "$(echo "$GROUPS_COMMON" | tr ' ' ',')" "$USERNAME"

echo "[user] Estableciendo contrasena inicial (desechable) y forzando cambio..."
if [ -n "${SECURIZART_INITIAL_PASS:-}" ]; then
    echo "${USERNAME}:${SECURIZART_INITIAL_PASS}" | chpasswd
else
    TMP_PASS="$(head -c 18 /dev/urandom | base64 | tr -d '/+=' | head -c 16)"
    echo "${USERNAME}:${TMP_PASS}" | chpasswd
    unset TMP_PASS
fi
chage -d 0 "$USERNAME"

echo "[user] OK. '$USERNAME' en grupos: $(id -nG "$USERNAME")"
