#!/bin/bash
# triada-sec — VM mother-image generalisation (sysprep)
# Copyright (C) 2026 Securizart
# This program is free software: you can redistribute it and/or modify it
# under the terms of the GNU General Public License v3 as published by the
# Free Software Foundation. See <https://www.gnu.org/licenses/gpl-3.0.html>.

# =============================================================================
# sysprep.sh — v2
# Generaliza una VM Debian/16k (Capa A, UTM) para convertirla en "madre"
# clonable: quita toda identidad única y estado acumulado, de modo que cada
# clon nazca como una máquina independiente y con el SSH sano de fábrica.
#
# NUNCA ejecutar en hardware real (Capa B, Mac M1/M2 con Asahi): borra
# machine-id y claves SSH de host, lo que dejaría sin identidad de red ni
# acceso SSH estable a una instalación de producción. La GUARDA lo impide.
#
# Cambios v1 -> v2 (ver docs/issues/):
#   - Regeneración de claves SSH con `ssh-keygen -A` en lugar de
#     `dpkg-reconfigure openssh-server`. El dpkg-reconfigure dejaba la cadena
#     sshd-keygen.service -> ssh.service en un estado que bloqueaba el arranque
#     del servidor tras clonar (síntoma: "Connection timed out during banner
#     exchange"). `ssh-keygen -A` sólo escribe las claves que falten, sin
#     tocar debconf ni la activación del servicio.
#   - El servicio oneshot declara `Before=... sshd-keygen.service` para que
#     nuestras claves existan ANTES de que esa unidad entre en juego y, al
#     existir ya, no pueda bloquear a ssh.service.
# =============================================================================
set -euo pipefail

# --- GUARDA: abortar si esto es un Mac con Asahi (Capa B) --------------------
if grep -qi "apple" /proc/device-tree/compatible 2>/dev/null; then
    echo "ABORTADO: detectado hardware Apple/Asahi. sysprep es SÓLO para VMs (Capa A)." >&2
    exit 1
fi

# Requiere privilegios de root
if [ "$(id -u)" -ne 0 ]; then
    echo "ABORTADO: ejecútalo con sudo/root." >&2
    exit 1
fi

echo "[sysprep] Limpiando APT (caché y listas)..."
apt-get clean
rm -rf /var/lib/apt/lists/*

echo "[sysprep] Vaciando logs..."
find /var/log -type f -exec truncate -s 0 {} +

echo "[sysprep] Reseteando machine-id (se regenera en el próximo arranque)..."
truncate -s 0 /etc/machine-id
rm -f /var/lib/dbus/machine-id
ln -s /etc/machine-id /var/lib/dbus/machine-id 2>/dev/null || true

echo "[sysprep] Borrando claves SSH de host (se regeneran POR CLON al arrancar)..."
rm -f /etc/ssh/ssh_host_*

echo "[sysprep] Instalando servicio de regeneración de claves en primer arranque..."
cat > /etc/systemd/system/regen-ssh-host-keys.service <<'UNIT'
[Unit]
Description=Regenera claves SSH de host en el primer arranque (post-sysprep)
Before=ssh.service ssh.socket sshd-keygen.service
ConditionPathExistsGlob=!/etc/ssh/ssh_host_*_key

[Service]
Type=oneshot
ExecStart=/usr/bin/ssh-keygen -A
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
UNIT
systemctl enable regen-ssh-host-keys.service

echo "[sysprep] Asegurando que ssh.socket quede habilitado..."
systemctl enable ssh.socket 2>/dev/null || true

echo "[sysprep] Limpiando temporales e histórico de shell..."
rm -rf /tmp/* /var/tmp/* 2>/dev/null || true
rm -f /root/.bash_history
find /home -name '.bash_history' -delete 2>/dev/null || true

# Limpia known_hosts del usuario para que los clones no arrastren huellas
# de pruebas anteriores (cosmético, evita warnings en la Capa A).
find /home -name 'known_hosts' -delete 2>/dev/null || true

echo ""
echo "[sysprep] Hecho. AHORA:"
echo "          1) sudo shutdown -h now"
echo "          2) clona la VM apagada en UTM (NO la rearranques antes de clonar)"
echo "          3) arranca un clon y verifica SSH_OK + machine-id/huella propios"
