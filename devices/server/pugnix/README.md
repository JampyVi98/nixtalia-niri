# 🐶 PugNix — Headless Homelab Server

[English](#english) | [Español](#español)

---

## English

**PugNix** is the dedicated headless server configuration running on a Raspberry Pi ARM architecture. Designed for 24/7 reliability, it acts as a lightweight homelab anchor providing network security, DNS filtering, mesh connectivity, and an autonomous operations assistant.

### ⚙️ System Specifications & Services

- **Architecture:** `aarch64-linux` (Built on `nixos-26.05` Stable channel).
- **Target Platform:** Raspberry Pi 4 / 5 (SD card bootable image with generic ARM kernel).
- **Network & DNS Ad-blocking:** Docker-based [Pi-hole](https://pi-hole.net/) running as a systemd-managed service with persistent volumes and local DNS routing.
- **Mesh Networking:** Tailscale daemon enabled for secure remote access without port forwarding.
- **Autonomous Operations:** Integrated [Hermes Agent](https://github.com/NousResearch/hermes-agent) (`services.hermes-agent`) configured with declarative identity (`PugHermes Assistant`), system health inspection, and Pi-hole audit skills.
- **Container Runtime:** Docker engine enabled for homelab workloads.
- **Security & Access:** OpenSSH daemon with trusted remote deployment credentials for user `jampyvi`.

---

### 🚀 Bootstrapping & Deployment

#### 1. Building the Bootable SD Card Image

You can build the compressed ARM SD image directly from your workstation (using binfmt cross-compilation):

```bash
# Build the bootable SD card image
nix build .#pugnix-image
```

#### 2. Flashing the SD Card

Flash the generated image to your SD card (replace `/dev/sdX` with your target drive):

```bash
zstdcat result/sd-image/nixos-image-sd-card-*.img.zst | sudo dd of=/dev/sdX bs=4M status=progress oflag=sync
```

#### 3. First Boot & Network Connection

1. Insert the SD card into the Raspberry Pi and power it on connected via Ethernet.
2. PugNix will obtain an IP address via DHCP and start the OpenSSH service.
3. Authenticate with user `jampyvi` (or connect via Tailscale once enrolled).

#### 4. Remote Declarative Updates

Future changes to `pugnix` are pushed over the network without manual intervention using `nh`:

```bash
# Deploy to PugNix remotely:
nh os switch ~/nixos -H pugnix --target-host jampyvi@192.168.18.110

# Or via the short alias:
nrp
```

---

## Español

**PugNix** es la configuración de servidor headless dedicada ejecutándose sobre la arquitectura ARM de Raspberry Pi. Diseñado para operación continua y confiable, actúa como nodo central del homelab gestionando seguridad de red, bloqueo de publicidad DNS, conectividad mallada y asistencia de operaciones autónoma.

### ⚙️ Especificaciones y Servicios del Sistema

- **Arquitectura:** `aarch64-linux` (Canal `nixos-26.05` Estable).
- **Plataforma Objetivo:** Raspberry Pi 4 / 5 (imagen de tarjeta SD con kernel ARM).
- **Bloqueo DNS & Red:** [Pi-hole](https://pi-hole.net/) contenerizado bajo Docker y gestionado como servicio systemd con almacenamiento persistente.
- **Conectividad Mesh:** Demonio de Tailscale para acceso remoto cifrado punto a punto sin abrir puertos en el router.
- **Agente de Operaciones Autónomo:** Integración oficial de [Hermes Agent](https://github.com/NousResearch/hermes-agent) (`services.hermes-agent`) con identidad declarativa (`PugHermes`), diagnósticos de salud del homelab y auditoría de consultas Pi-hole.
- **Entorno de Contenedores:** Docker habilitado para cargas de trabajo del servidor.
- **Acceso:** OpenSSH configurado con usuarios de confianza para despliegues remotos (`jampyvi`).

---

### 🚀 Generación de Imagen y Despliegue

#### 1. Compilación de la Imagen SD de Arranque

Puedes generar la imagen comprimida directamente desde tu estación de trabajo (aprovechando la compilación cruzada con binfmt):

```bash
# Compilar la imagen para tarjeta SD
nix build .#pugnix-image
```

#### 2. Grabado en la Tarjeta SD

Graba la imagen generada en tu tarjeta SD (reemplazando `/dev/sdX` por tu lector de tarjetas):

```bash
zstdcat result/sd-image/nixos-image-sd-card-*.img.zst | sudo dd of=/dev/sdX bs=4M status=progress oflag=sync
```

#### 3. Primer Arranque y Conexión

1. Inserta la tarjeta SD en el Raspberry Pi, conecta el cable Ethernet y enciéndelo.
2. PugNix obtendrá dirección IP por DHCP e iniciará el servicio SSH.
3. Inicia sesión con el usuario `jampyvi` o vincúlalo a tu red de Tailscale.

#### 4. Despliegues Remotos

Para aplicar actualizaciones futuras sin necesidad de tocar el servidor físico, usa `nh` o el alias directo:

```bash
# Desplegar remotamente a PugNix:
nh os switch ~/nixos -H pugnix --target-host jampyvi@192.168.18.110

# O mediante el alias rápido:
nrp
```
