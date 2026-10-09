# ❄️ Nixtalia Niri

_A declarative, reproducible, and multi-architecture NixOS configuration ecosystem._

[English](#english) | [Español](#español)

---

## English

Welcome to **Nixtalia Niri**, a centralized, modular NixOS ecosystem managed with **Nix Flakes** and **Home Manager**. This repository coordinates workstations and servers across different hardware architectures (`x86_64-linux` and `aarch64-linux`).

### 🖥️ Managed Hosts

| Host | Type | Architecture | Base Channel | Documentation |
| :--- | :--- | :--- | :--- | :--- |
| **[HuskyNix](devices/desktop/huskynix/README.md)** | Desktop Workstation | `x86_64-linux` | `nixos-unstable` | [Read Guide](devices/desktop/huskynix/README.md) |
| **[PugNix](devices/server/pugnix/README.md)** | Headless Homelab Server | `aarch64-linux` | `nixos-26.05` (Stable) | [Read Guide](devices/server/pugnix/README.md) |

---

### 🌟 Ecosystem Highlights

- **Window Management & Aesthetics:** [Niri](https://github.com/YaLTeR/niri) scrollable tiling Wayland compositor paired with [Noctalia Shell](https://github.com/noctalia-dev/noctalia) and native **Catppuccin Mocha Mauve** theming across desktop and terminal tools.
- **Hardware Security:** Full UEFI Secure Boot support on the desktop via [Lanzaboote](https://github.com/nix-community/lanzaboote) with TPM2 integration.
- **Multi-Device Deployment:** Managed via `nh` (Nix Helper) with cross-compilation support and network-targeted closures.
- **Autonomous AI Ops:** Declarative integration of [Hermes Agent](https://github.com/NousResearch/hermes-agent) on server infrastructure with homelab diagnostic skills.
- **Developer Stack:** Fast Node Manager (`fnm`), Node.js 24, Python 3.12 (pip/virtualenv/uv/wheel), Docker, and Pi Coding Agent.

---

### 📁 Repository Structure

```text
.
├── config/                 # Raw window manager and terminal configs (Niri, Ghostty, Starship)
├── devices/                # Host-specific hardware profiles and configurations
│   ├── desktop/huskynix/   # Primary desktop workstation profile & README
│   └── server/pugnix/      # Raspberry Pi headless server profile & README
├── home/                   # Home Manager modules and user environments
│   ├── config/             # XDG, GTK, QT and cursor settings
│   ├── editors/            # Editor configs (Antigravity IDE, Micro)
│   ├── programs/           # Declarative CLI and GUI applications (Hermes, Pi, etc.)
│   └── shell/              # Shell configuration (Zsh, plugins, fnm, yazi)
├── modules/                # Reusable NixOS system modules (audio, baseline, nvidia, amd, etc.)
└── flake.nix               # Flake entrypoint and system definitions
```

---

### ⚡ Common Commands & Aliases

| Alias / Command | Description |
| :--- | :--- |
| `nos` | Rebuild and switch local workstation (`nh os switch ~/nixos -H huskynix`) |
| `npu` | Update flake lock and rebuild local workstation (`nh os switch ~/nixos -H huskynix --update`) |
| `nrp` | Deploy configuration remotely to Raspberry Pi (`nh os switch ~/nixos -H pugnix --target-host ...`) |
| `nix build .#pugnix-image` | Cross-compile bootable SD card image for Raspberry Pi |
| `cleanup` | Delete old Nix generations and garbage collect store (`nix-collect-garbage`) |

---

### 🙏 Acknowledgements

- [raexera/yuki](https://github.com/raexera/yuki)
- [epic9491/nixos](https://github.com/epic9491/nixos)

---

## Español

Bienvenido a **Nixtalia Niri**, un ecosistema modular y declarativo de NixOS administrado mediante **Nix Flakes** y **Home Manager**. Este repositorio coordina estaciones de trabajo y servidores a través de múltiples arquitecturas (`x86_64-linux` y `aarch64-linux`).

### 🖥️ Equipos Administrados

| Host | Tipo | Arquitectura | Canal Base | Documentación |
| :--- | :--- | :--- | :--- | :--- |
| **[HuskyNix](devices/desktop/huskynix/README.md)** | PC de Escritorio | `x86_64-linux` | `nixos-unstable` | [Ver Guía](devices/desktop/huskynix/README.md) |
| **[PugNix](devices/server/pugnix/README.md)** | Servidor Homelab Headless | `aarch64-linux` | `nixos-26.05` (Estable) | [Ver Guía](devices/server/pugnix/README.md) |

---

### 🌟 Aspectos Destacados del Ecosistema

- **Entorno Visual y Ventanas:** Compositor Wayland de mosaico desplazable [Niri](https://github.com/YaLTeR/niri) junto a [Noctalia Shell](https://github.com/noctalia-dev/noctalia) y paleta **Catppuccin Mocha Mauve** integrada de forma nativa.
- **Seguridad Criptográfica:** UEFI Secure Boot habilitado en el equipo principal mediante [Lanzaboote](https://github.com/nix-community/lanzaboote) con soporte TPM2.
- **Despliegues Multi-Dispositivo:** Gestión ágil con `nh` (Nix Helper) con soporte de compilación cruzada y despliegues remotos por red.
- **Operaciones Autónomas con IA:** Integración declarativa oficial de [Hermes Agent](https://github.com/NousResearch/hermes-agent) en el servidor con habilidades de diagnóstico homelab.
- **Stack de Desarrollo:** Fast Node Manager (`fnm`), Node.js 24, Python 3.12 (pip/virtualenv/uv/wheel), Docker y Pi Coding Agent.

---

### 📁 Estructura del Repositorio

```text
.
├── config/                 # Configuraciones de compositor y terminal (Niri, Ghostty, Starship)
├── devices/                # Perfiles de hardware por equipo
│   ├── desktop/huskynix/   # Perfil y README del equipo principal
│   └── server/pugnix/      # Perfil y README del servidor Raspberry Pi
├── home/                   # Módulos de Home Manager y entorno de usuario
│   ├── config/             # Parámetros XDG, GTK, QT y cursores
│   ├── editors/            # Editores de código (Antigravity IDE, Micro)
│   ├── programs/           # Aplicaciones CLI y GUI (Hermes, Pi, etc.)
│   └── shell/              # Shell (Zsh, plugins, fnm, yazi)
├── modules/                # Módulos de sistema reutilizables (audio, baseline, nvidia, amd, etc.)
└── flake.nix               # Punto de entrada del Flake y definición de sistemas
```

---

### ⚡ Comandos y Alias Frecuentes

| Alias / Comando | Descripción |
| :--- | :--- |
| `nos` | Reconstruir y aplicar cambios en el equipo local (`nh os switch ~/nixos -H huskynix`) |
| `npu` | Actualizar flake lock y reconstruir el equipo local (`nh os switch ~/nixos -H huskynix --update`) |
| `nrp` | Desplegar configuración remotamente al Raspberry Pi (`nh os switch ~/nixos -H pugnix --target-host ...`) |
| `nix build .#pugnix-image` | Compilar la imagen de arranque para tarjeta SD del Raspberry Pi |
| `cleanup` | Limpiar generaciones antiguas y liberar espacio en Nix store |

---

### 🙏 Créditos y Referencias

- [raexera/yuki](https://github.com/raexera/yuki)
- [epic9491/nixos](https://github.com/epic9491/nixos)
