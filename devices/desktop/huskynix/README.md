# 🐺 HuskyNix — Desktop Workstation

[English](#english) | [Español](#español)

---

## English

**HuskyNix** is the primary high-performance workstation configuration for this ecosystem. Built on `nixpkgs-unstable`, it provides a modern Wayland workflow, custom aesthetics, dual-GPU acceleration, and hardware-level security.

### ⚙️ System Specifications & Stack

- **Architecture:** `x86_64-linux` (`nixpkgs-unstable`)
- **Compositor & Shell:** [Niri](https://github.com/YaLTeR/niri) scrollable tiling Wayland compositor paired with [Noctalia Shell](https://github.com/noctalia-dev/noctalia) and `noctalia-greeter`.
- **GPU Architecture:** Hybrid graphics (AMD iGPU + NVIDIA dGPU) managed with NVIDIA PRIME offload (`PCI:1:0:0` / `PCI:22:0:0`) and sync modes.
- **Security & Boot:** Full UEFI Secure Boot integration using [Lanzaboote](https://github.com/nix-community/lanzaboote) (`sbctl`) and TPM2 support.
- **Audio Stack:** PipeWire with Low-Latency Pro Audio profile and EasyEffects presets.
- **Development Toolchain:** FNM (Fast Node Manager), Node.js 24, Python 3.12 with complete venv/wheel/pip tooling, Docker, and Pi Coding Agent.
- **Theming:** Catppuccin Mocha Mauve applied consistently across terminal, shell (Zsh + Starship), and UI components.

---

### 🚀 Bootstrapping & Installation

#### 1. Disk Preparation and Installation

Boot from an official NixOS Live USB, partition and format your drive (EFI + Btrfs/Ext4 root), and mount it to `/mnt`:

```bash
# Generate baseline hardware scan
nixos-generate-config --root /mnt

# Clone this repository
cd /mnt/etc && mv nixos nix.bak
git clone https://github.com/JampyVi98/nixtalia-niri.git nixos
mv nix.bak/hardware-configuration.nix nixos/devices/desktop/huskynix/hardware-configuration.nix
rm -rf nix.bak

# Install system configuration
cd nixos
nixos-install --flake .#huskynix
nixos-enter --root /mnt -c 'passwd jampyvi'
reboot
```

#### 2. User Setup

After logging into the newly installed system, move the configuration to your user directory:

```bash
sudo cp -r /etc/nixos ~/nixos
sudo chown -R jampyvi:users ~/nixos
```

#### 3. Secure Boot Enrollment (Lanzaboote)

To enable signed kernel boots through Lanzaboote:

1. Enter your motherboard UEFI firmware and set Secure Boot to **Setup Mode** (clear existing factory PK/KEK keys).
2. Boot into NixOS and run:

```bash
# Generate your personal cryptographic keys
sudo nix run nixpkgs#sbctl -- create-keys

# Unlock immutable efivars if protected by kernel
sudo chattr -i /sys/firmware/efi/efivars/{PK,KEK,db}* 2>/dev/null || true

# Enroll generated keys (including Microsoft signatures for dual-boot compatibility)
sudo nix run nixpkgs#sbctl -- enroll-keys --microsoft
```

3. Reboot, re-enter your BIOS, and toggle Secure Boot back to **Enabled**.

#### 4. System Rebuilds

Apply changes locally using `nh` or the quick alias:

```bash
# Using nh directly:
nh os switch ~/nixos -H huskynix

# Or with the quick alias:
nos
```

---

## Español

**HuskyNix** es la estación de trabajo principal de alto rendimiento de este ecosistema. Basada en `nixpkgs-unstable`, combina un entorno Wayland dinámico, aceleración gráfica híbrida y seguridad criptográfica en el arranque.

### ⚙️ Especificaciones y Stack del Sistema

- **Arquitectura:** `x86_64-linux` (`nixpkgs-unstable`)
- **Compositor y Shell:** Compositor de mosaico desplazable [Niri](https://github.com/YaLTeR/niri) (Wayland) integrado con [Noctalia Shell](https://github.com/noctalia-dev/noctalia) y `noctalia-greeter`.
- **Aceleración Gráfica:** Configuración híbrida (AMD iGPU + NVIDIA dGPU) con NVIDIA PRIME Offload (`PCI:1:0:0` / `PCI:22:0:0`).
- **Seguridad de Arranque:** UEFI Secure Boot gestionado por [Lanzaboote](https://github.com/nix-community/lanzaboote) (`sbctl`) con soporte para TPM2.
- **Audio:** PipeWire con perfil Pro Audio y ecualización con EasyEffects.
- **Entorno de Desarrollo:** FNM (Fast Node Manager), Node.js 24, Python 3.12 configurado con pip/uv/wheel/virtualenv, Docker y Pi Coding Agent.
- **Identidad Visual:** Catppuccin Mocha Mauve integrado de forma declarativa en el compositor, terminal, shell (Zsh + Starship) y utilitarios.

---

### 🚀 Instalación y Puesta a Punto

#### 1. Preparación de Discos e Instalación

Inicia desde una memoria USB Live de NixOS, particiona tus discos (partición EFI + partición raíz) y móntalos en `/mnt`:

```bash
# Generar escaneo de hardware base
nixos-generate-config --root /mnt

# Clonar este repositorio
cd /mnt/etc && mv nixos nix.bak
git clone https://github.com/JampyVi98/nixtalia-niri.git nixos
mv nix.bak/hardware-configuration.nix nixos/devices/desktop/huskynix/hardware-configuration.nix
rm -rf nix.bak

# Instalar configuración de HuskyNix
cd nixos
nixos-install --flake .#huskynix
nixos-enter --root /mnt -c 'passwd jampyvi'
reboot
```

#### 2. Configuración Post-Instalación

Al iniciar sesión en el nuevo sistema, copia el repositorio a tu directorio personal:

```bash
sudo cp -r /etc/nixos ~/nixos
sudo chown -R jampyvi:users ~/nixos
```

#### 3. Enrolamiento de Secure Boot (Lanzaboote)

Para firmar los kernels y binarios EFI mediante Lanzaboote:

1. Ingresa a la BIOS/UEFI de tu placa madre y coloca Secure Boot en **Setup Mode** (limpiando las llaves PK/KEK existentes).
2. Inicia NixOS y ejecuta:

```bash
# Generar llaves criptográficas privadas
sudo nix run nixpkgs#sbctl -- create-keys

# Desbloquear efivars inmutables si el kernel las protege
sudo chattr -i /sys/firmware/efi/efivars/{PK,KEK,db}* 2>/dev/null || true

# Enrolar llaves (incluye certificados de Microsoft para compatibilidad con Windows)
sudo nix run nixpkgs#sbctl -- enroll-keys --microsoft
```

3. Reinicia, ingresa a la BIOS y activa nuevamente Secure Boot a **Enabled**.

#### 4. Reconstrucción del Sistema

Para aplicar cambios locales usa `nh` o el alias integrado:

```bash
# Usando nh directamente:
nh os switch ~/nixos -H huskynix

# O con el alias rápido:
nos
```
