# triada-sec

> Tres distribuciones de ciberseguridad especializadas para Apple Silicon
> (M1/M2), construidas sobre Debian + Asahi Linux, con una base común y un
> escritorio GNOME/Wayland compartidos.

**English:** ver [README.md](README.md)

## La tríada

El nombre es un guiño a la **tríada CIA** — Confidencialidad, Integridad,
Disponibilidad — el fundamento de la seguridad de la información.
`triada-sec` la encarna en tres distribuciones:

| Distro | Rol | Enfoque |
|---|---|---|
| **Red** | Ofensiva / Red Team | Pentesting, explotación, auditoría de redes (herramientas Kali / Parrot) |
| **Blue** | Defensiva / Blue Team | Endurecimiento, monitorización, detección (referencia Kali Purple) |
| **DFIR** | Forense y Respuesta a Incidentes | Análisis de malware, ingeniería inversa, forense (SIFT / REMnux / CAINE) |

## Hardware objetivo

MacBook de Apple con **M1 o M2** (ARM64). Dos capas de validación:

- **Capa A — Virtualización (UTM/QEMU):** iteración rápida del escritorio
  GNOME, instalación de paquetes y scripts de configuración. Usa un kernel
  de **páginas de 16 KiB** para reproducir la disposición de memoria del Mac.
- **Capa B — Hardware real (M1/M2):** rendimiento bruto y validación de
  hardware específico (modo monitor/inyección del Wi-Fi nativo, acceso
  directo a GPU), más la cadena de arranque (m1n1/U-Boot).

## Diseño: dos capas de configuración

La base GNOME + kernel la **aporta siempre el entorno**, este proyecto no la
reconstruye:

- **metal** → clon de la instalación Debian/Asahi (Bananas), con su kernel
  Asahi y m1n1/U-Boot ya puestos.
- **vm** → un rootfs/qcow2 construido con mmdebstrap y el kernel 16k genérico
  de Debian, para UTM.

Sobre esa base aplicamos la **capa securizart**: configuración de GNOME más
el conjunto de paquetes de cada distro. Esa capa es lo que este repositorio
declara: una parte **común** (el usuario `securizart`, forzado de Wayland) y
una parte **por distro** (branding del escritorio, splash de arranque,
experiencia de desbloqueo LUKS).

## Estado

**Fase 2 (base común) completada** en la capa VM. Ver
[CHANGELOG.md](CHANGELOG.md) y [docs/](docs/).

## Riesgos

Este proyecto modifica el particionado y, en hardware real, interactúa con la
cadena de arranque de Apple Silicon. **Un error en metal puede dejar el Mac
sin arrancar.** Requiere conocimiento profundo de administración Linux (LUKS,
LVM, chroot, GRUB, pinning de APT). Copia de seguridad completa antes de tocar
ningún disco. Ver [docs/KNOWN_ISSUES.md](docs/KNOWN_ISSUES.md).

## Créditos

Se apoya en el trabajo del proyecto [Asahi Linux](https://asahilinux.org) y
del [equipo Bananas](https://wiki.debian.org/Teams/Bananas) de Debian.

## Licencia

GPL-3.0 — ver [LICENSE](LICENSE).
