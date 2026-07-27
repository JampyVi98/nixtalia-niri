# ❄️ Nixtalia Niri

_A declarative, reproducible, and secure NixOS configuration ecosystem._

[English](#english) | [Español](#español)

---

## English

Welcome to **Nixtalia Niri**, my personal NixOS configuration suite. This repository uses **Flakes** and **Home Manager** to manage the entire system state declaratively across different devices.

### 🖥️ Devices

- **huskynix** (Desktop PC): Running `nixpkgs-unstable` with the **Niri** window manager, **Catppuccin** theme, and **Lanzaboote** for Secure Boot.
- **pugnix** (Raspberry Pi Server): Headless server running `nixos-26.05` stable. Features Docker (rootless), Tailscale, and more.

### 🌟 Features

- **Window Manager:** Niri (Wayland) for the workstation.
- **Theming:** Catppuccin Mocha Mauve natively integrated across tools (Kitty, Zsh, Btop, etc.).
- **Shell Environment:** Custom developer environments via [Noctalia Shell](https://github.com/noctalia-dev/noctalia-shell).
- **Security:** Full UEFI Secure Boot support via [Lanzaboote](https://github.com/nix-community/lanzaboote) on the desktop.
- **Deployment:** Managed via `nh` (Nix Helper) with cross-compilation & remote deployment support.

---

### 🚀 Installation & Setup

#### 1. Workstation Bootstrapping (huskynix)

Boot from a NixOS Live USB. Partition your drives manually and mount them to `/mnt`. Then, generate the base hardware configuration and clone this repository:

```bash
nixos-generate-config --root /mnt
cd /mnt/etc && mv nixos nix.bak
git clone https://github.com/JampyVi98/nixtalia-niri.git && rm -rf nixos/.git
mv nix.bak/hardware-configuration.nix nixos/devices/desktop/huskynix
cd nixos && git init && git add .
nixos-install --flake .#huskynix
nixos-enter --root /mnt -c 'passwd jampyvi'
reboot
```

#### 2. Post-Installation

After rebooting into your new system, log in and copy the configuration to your home folder:

```bash
sudo cp -r /etc/nixos ~/nixos
sudo chown -R jampyvi:users ~/nixos
```

#### 3. Configure Secure Boot (Lanzaboote)

If you format your root partition, you will lose your private PKI keys (`/var/lib/sbctl`). You must generate new ones and enroll them in your motherboard's UEFI.

**Step A:** Put your motherboard BIOS in **Setup Mode** (usually by clearing the current Secure Boot keys). Boot into NixOS.

**Step B:** Generate new keys and enroll them:

```bash
# Generate the keys
sudo nix run nixpkgs#sbctl -- create-keys

# Remove immutable flag if your kernel protects EFI variables
sudo chattr -i /sys/firmware/efi/efivars/{PK,KEK,db}*

# Enroll keys (including Microsoft keys for Windows Dual Boot)
sudo nix run nixpkgs#sbctl -- enroll-keys --microsoft
```

**Step C:** Reboot your PC, enter the BIOS, and change Secure Boot to **Enabled**.

#### 4. Rebuild the Workstation

Apply the configuration. The first time, it's recommended to use the official `nixos-rebuild` command and point it to the `huskynix` host:

```bash
sudo nixos-rebuild switch --flake .#huskynix
```

For future everyday updates, you can use `nh`:

```bash
nh os switch ~/nixos -H huskynix
# or using the 'nos' alias:
nos
```

#### 5. Headless Server (pugnix - Raspberry Pi)

To build the bootable SD card image and manage the headless server:

**Step A:** Build the image on your workstation (cross-compilation enabled via binfmt):
```bash
nix build .#pugnix-image
```

**Step B:** Flash the SD card (assumes `/dev/sda` is your card reader):
```bash
zstdcat result/sd-image/nixos-image-sd-card-*.img.zst | sudo dd of=/dev/sda bs=4M status=progress oflag=sync
```

**Step C:** Deploy future updates remotely over the network using the `npi` alias:
```bash
npi
# or manually:
nh os switch ~/nixos -H pugnix --target-host jampyvi@192.168.18.110
```

---

### 🙏 Acknowledgements

A huge thanks to the following repositories for serving as inspiration and providing excellent architectural references for this setup:

- [raexera/yuki](https://github.com/raexera/yuki)
- [epic9491/nixos](https://github.com/epic9491/nixos)

---

## Español

Bienvenido a **Nixtalia Niri**, mi suite de configuración personal de NixOS. Este repositorio utiliza **Flakes** y **Home Manager** para administrar todo el estado del sistema de forma declarativa en distintos dispositivos.

### 🖥️ Equipos

- **huskynix** (PC de Escritorio): Ejecuta `nixpkgs-unstable` con el gestor de ventanas **Niri**, temas **Catppuccin**, y **Lanzaboote** para Secure Boot.
- **pugnix** (Servidor Raspberry Pi): Servidor headless corriendo `nixos-26.05` estable. Incluye Docker (rootless), Tailscale, y más.

### 🌟 Características

- **Window Manager:** Niri (Wayland) para la estación de trabajo.
- **Temas:** Catppuccin Mocha Mauve integrado nativamente (Kitty, Zsh, Btop, etc.).
- **Entorno Shell:** Entornos de desarrollo a medida usando [Noctalia Shell](https://github.com/noctalia-dev/noctalia-shell).
- **Seguridad:** Soporte completo para UEFI Secure Boot usando [Lanzaboote](https://github.com/nix-community/lanzaboote) en el escritorio.
- **Despliegues:** Gestionado con `nh` (Nix Helper) con soporte de compilación cruzada y despliegue remoto.

---

### 🚀 Instalación y Puesta a Punto

#### 1. Preparar e Instalar el Sistema (huskynix)

Arranca desde un Live USB de NixOS. Particiona tus discos manualmente y móntalos en `/mnt`. Luego, genera la configuración de hardware base y clona este repositorio:

```bash
nixos-generate-config --root /mnt
cd /mnt/etc && mv nixos nix.bak
git clone https://github.com/JampyVi98/nixtalia-niri.git && rm -rf nixos/.git
mv nix.bak/hardware-configuration.nix nixos/devices/desktop/huskynix
cd nixos && git init && git add .
nixos-install --flake .#huskynix
nixos-enter --root /mnt -c 'passwd jampyvi'
reboot
```

#### 2. Post-Instalación

Tras reiniciar y entrar a tu nuevo sistema, inicia sesión y copia la configuración a tu carpeta personal:

```bash
sudo cp -r /etc/nixos ~/nixos
sudo chown -R jampyvi:users ~/nixos
```

#### 3. Configurar Secure Boot (Lanzaboote)

Al formatear la partición raíz, perderás tus llaves privadas de Secure Boot (`/var/lib/sbctl`). Debes generar unas nuevas y enrolarlas en la placa madre.

**Paso A:** Entra a la BIOS de tu placa madre y ponla en **Setup Mode** (usualmente borrando las llaves actuales de Secure Boot). Inicia NixOS.

**Paso B:** Genera llaves nuevas y enrólalas en la placa madre:

```bash
# Generar las llaves
sudo nix run nixpkgs#sbctl -- create-keys

# Quitar protección de inmutabilidad del kernel (si te da error de efivars al enrolar)
sudo chattr -i /sys/firmware/efi/efivars/{PK,KEK,db}*

# Enrolar las llaves (incluyendo las de Microsoft para compatibilidad con Windows)
sudo nix run nixpkgs#sbctl -- enroll-keys --microsoft
```

**Paso C:** Reinicia tu PC, entra a la BIOS y cambia el Secure Boot a **Enabled**.

#### 4. Reconstruir el Escritorio

Aplica la configuración. Para la primera vez, se recomienda usar el comando oficial apuntando al host `huskynix`:

```bash
sudo nixos-rebuild switch --flake .#huskynix
```

Para tus actualizaciones del día a día, puedes usar `nh`:

```bash
nh os switch ~/nixos -H huskynix
# o usando el alias 'nos':
nos
```

#### 5. Servidor Headless (pugnix - Raspberry Pi)

Para construir la imagen de arranque de la tarjeta SD y administrar el servidor:

**Paso A:** Compila la imagen en tu PC (compilación cruzada habilitada mediante binfmt):
```bash
nix build .#pugnix-image
```

**Paso B:** Flashea la tarjeta SD (asumiendo que `/dev/sda` es el lector):
```bash
zstdcat result/sd-image/nixos-image-sd-card-*.img.zst | sudo dd of=/dev/sda bs=4M status=progress oflag=sync
```

**Paso C:** Despliega actualizaciones futuras de forma remota sobre la red usando el alias `npi`:
```bash
npi
# o manualmente:
nh os switch ~/nixos -H pugnix --target-host jampyvi@192.168.18.110
```

---

### 🙏 Créditos

Un enorme agradecimiento a los siguientes repositorios por servir como inspiración y proveer excelentes referencias arquitectónicas para esta configuración:

- [raexera/yuki](https://github.com/raexera/yuki)
- [epic9491/nixos](https://github.com/epic9491/nixos)
