#!/bin/bash
# triada-sec — disable automatic updates + manual-update disclaimer (common base)
# Copyright (C) 2026 Securizart
# GPL-3.0 — see <https://www.gnu.org/licenses/gpl-3.0.html>.
# =============================================================================
# Politica del proyecto: NINGUNA actualizacion automatica. Las tres distros se
# actualizan SOLO manualmente con `sudo triada-update`. Una actualizacion
# desatendida puede romper el arranque de Apple Silicon. Idempotente.
# =============================================================================
set -euo pipefail
[ "$(id -u)" -eq 0 ] || { echo "Ejecuta como root." >&2; exit 1; }

echo "[no-auto-update] Desactivando timers de apt..."
systemctl disable --now apt-daily.timer apt-daily-upgrade.timer 2>/dev/null || true
systemctl mask apt-daily.service apt-daily-upgrade.service 2>/dev/null || true

echo "[no-auto-update] Desactivando refresco automatico de firmware (fwupd)..."
systemctl disable --now fwupd-refresh.timer 2>/dev/null || true

echo "[no-auto-update] Refuerzo en config de apt..."
cat > /etc/apt/apt.conf.d/99triada-no-auto <<'CONF'
// triada-sec: sin actualizaciones automaticas (politica del proyecto)
APT::Periodic::Update-Package-Lists "0";
APT::Periodic::Download-Upgradeable-Packages "0";
APT::Periodic::Unattended-Upgrade "0";
APT::Periodic::AutocleanInterval "0";
CONF

echo "[no-auto-update] Frenando descarga automatica de GNOME Software..."
install -d /etc/dconf/profile /etc/dconf/db/local.d
grep -q '^user-db:user' /etc/dconf/profile/user 2>/dev/null || printf 'user-db:user\nsystem-db:local\n' > /etc/dconf/profile/user
cat > /etc/dconf/db/local.d/00-triada-no-auto-updates <<'CONF'
[org/gnome/software]
download-updates=false
download-updates-notify=true
CONF
dconf update 2>/dev/null || true

echo "[no-auto-update] Instalando disclaimer en /etc/motd..."
cat > /etc/motd <<'MOTD'

================================================================
  triada-sec  —  actualizacion MANUAL por diseño
----------------------------------------------------------------
  Las actualizaciones automaticas estan DESACTIVADAS para
  proteger la cadena de arranque de Apple Silicon (m1n1/U-Boot
  y kernel Asahi). El sistema NO se actualiza solo.

  Para actualizar de forma SEGURA:

        sudo triada-update

  (refresca indices, SIMULA, comprueba que no se toca el
   arranque, y pide confirmacion antes de aplicar)

  GNOME avisa si hay actualizaciones, pero no las descarga
  ni instala por su cuenta.
================================================================

MOTD

echo "[no-auto-update] Hecho."
