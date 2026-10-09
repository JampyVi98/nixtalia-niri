# Note that baseline packages are now in ./packages.nix, and nested into the workstation.baseline module
{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.workstation.baseline;
in {
  options.workstation.baseline.enable = lib.mkEnableOption "Baseline workstation configuration";

  config = lib.mkIf cfg.enable {
    nix.settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      substituters = [
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };

    nixpkgs.config = {
      allowUnfree = true;
      permittedInsecurePackages = [
        "electron-39.8.10"
      ];
    };

    catppuccin = {
      enable = true;
      autoEnable = true;
      flavor = "mocha";
      accent = "sapphire";
    };

    boot = {
      loader = {
        systemd-boot.enable = lib.mkForce false;
        efi.canTouchEfiVariables = true;
      };
      lanzaboote = {
        enable = true;
        pkiBundle = "/var/lib/sbctl";
      };
      kernelPackages = pkgs.linuxPackages_latest;
      kernelModules = ["uvcvideo"];
      plymouth.enable = true;
      consoleLogLevel = 0;
      initrd.verbose = false;
      kernelParams = [
        "quiet"
        "splash"
        "boot.shell_on_fail"
        "loglevel=3"
        "rd.systemd.show_status=false"
        "rd.udev.log_level=3"
        "udev.log_priority=3"
      ];
    };

    environment.systemPackages = [pkgs.sbctl];

    hardware.enableAllFirmware = true;

    networking.networkmanager.enable = true;

    nix.gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };

    nix.optimise = {
      automatic = true;
      dates = ["weekly"];
    };

    time.timeZone = "America/Guayaquil";

    services.xserver.xkb = {
      layout = "latam";
    };

    i18n.defaultLocale = "en_US.UTF-8";
    console = {
      font = "Lat2-Terminus16";
      keyMap = "la-latin1";
    };

    users.users.jampyvi = {
      isNormalUser = true;
      shell = pkgs.zsh;
      extraGroups = [
        "wheel"
        "networkmanager"
        "input"
        "sound"
        "video"
        "audio"
        "libvirtd"
        "borg"
        "docker"
      ];
    };

    hardware.bluetooth = {
      enable = true;
      powerOnBoot = false;
      package = pkgs.bluez5-experimental;
      settings = {
        General = {
          Experimental = true;
          FastConnectable = true;
        };
        Policy = {
          AutoEnable = true;
        };
      };
    };

    hardware.uinput.enable = true;
    hardware.logitech.wireless.enable = true;

    fonts = {
      enableDefaultPackages = true;
      packages = with pkgs; [
        nerd-fonts.jetbrains-mono
        nerd-fonts.iosevka
        inter
        corefonts
        vista-fonts
      ];
      fontconfig = {
        enable = true;
        defaultFonts = {
          sansSerif = [
            "Inter"
            "Iosevka"
          ];
          serif = ["Iosevka"];
          monospace = ["JetBrainsMono Nerd Font"];
        };
      };
      fontDir.enable = true;
    };

    programs.dconf.enable = true;
    programs.appimage = {
      enable = true;
      binfmt = true;
    };
    programs.nix-ld = {
      enable = true;
      libraries = with pkgs; [
        stdenv.cc.cc.lib
        zlib
        glib
        libGL
        libglvnd
        libX11
        libXcursor
        libXrandr
        libXi
        libXinerama
        libXext
        libXfixes
        libXrender
        libXcomposite
        libXdamage
        libxshmfence
        libxcb
        libxkbcommon
        wayland
        fontconfig
        freetype
        fribidi
        openssl
        alsa-lib
        dbus
        udev
        nspr
        nss
        at-spi2-atk
        at-spi2-core
        cups
        expat
        libdrm
        mesa
        libgbm
        cairo
        pango
        gdk-pixbuf
        gtk3
        gtk4
        harfbuzz
        libjpeg
        libpng
        libopus
        libvpx
        libevent
        ffmpeg
      ];
    };
    services.envfs.enable = true;
    documentation.doc.enable = false;
    programs.zsh.enable = true;
    environment.localBinInPath = true;
    environment.pathsToLink = ["/share/zsh"];

    services = {
      tailscale.enable = true;
      syncthing = {
        enable = true;
        user = "jampyvi";
        dataDir = "/home/jampyvi/Documents/syncthing";
        configDir = "/home/jampyvi/.config/syncthing";
        openDefaultPorts = true;
      };
      libinput.enable = true;
      upower.enable = true;
      gvfs.enable = true;
      udisks2.enable = true;
      power-profiles-daemon.enable = true;
      pipewire = {
        enable = true;
        pulse.enable = true;
        alsa.enable = true;
      };
    };
    security.rtkit.enable = true;

    xdg.portal.enable = true;
    xdg.portal.extraPortals = [pkgs.xdg-desktop-portal-gtk];

    system.stateVersion = "25.05";
  };
}
