#!/bin/bash
# triada-sec — Boot-family package protection (apt-mark hold)
# Copyright (C) 2026 Securizart
# This program is free software: you can redistribute it and/or modify it
# under the terms of the GNU General Public License v3 as published by the
# Free Software Foundation. See <https://www.gnu.org/licenses/gpl-3.0.html>.

set -euo pipefail

is_metal() {
    grep -qi "apple" /proc/device-tree/compatible 2>/dev/null
}

boot_family_installed() {
    dpkg --get-selections 2>/dev/null \
        | awk '$2 == "install" {print $1}' \
        | grep -E '^(linux-image-.*asahi|linux-headers-.*asahi|linux-image-asahi|linux-headers-asahi|u-boot-asahi|asahi-.*|.*mesa.*|libgl1-mesa-dri|libgbm1|libegl-mesa0|libglx-mesa0)$' \
        || true
}

ACTION="${1:-status}"

case "$ACTION" in
    hold)
        if ! is_metal; then
            echo "[hold-boot] Rama VM detectada: NO se aplica hold permanente."
            echo "[hold-boot] (el kernel generico debe poder actualizarse en la VM)"
            exit 0
        fi
        pkgs="$(boot_family_installed)"
        if [ -z "$pkgs" ]; then
            echo "[hold-boot] No se encontraron paquetes de la familia Asahi. Base correcta?" >&2
            exit 1
        fi
        echo "[hold-boot] Marcando hold sobre la familia de arranque Asahi:"
        echo "$pkgs" | sed 's/^/    /'
        apt-mark hold $pkgs
        echo "[hold-boot] Hecho. Estos paquetes ya no podran eliminarse/cambiarse por apt."
        ;;
    status)
        echo "[hold-boot] Paquetes actualmente en hold:"
        apt-mark showhold | sed 's/^/    /' || true
        echo "[hold-boot] Rama: $(is_metal && echo metal || echo vm)"
        ;;
    unhold)
        echo "[hold-boot] Liberando holds de la familia de arranque."
        pkgs="$(boot_family_installed)"
        [ -n "$pkgs" ] && apt-mark unhold $pkgs
        apt-mark showhold | sed 's/^/    /' || true
        ;;
    *)
        echo "Uso: $0 {hold|status|unhold}" >&2
        exit 2
        ;;
esac
