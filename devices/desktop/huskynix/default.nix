{
  pkgs,
  inputs,
  ...
}: let
  heroic-wrapped = pkgs.symlinkJoin {
    name = "heroic";
    paths = [
      (pkgs.writeShellScriptBin "heroic" ''
        exec ${pkgs.steam-run}/bin/steam-run ${pkgs.heroic}/bin/heroic "$@"
      '')
      pkgs.heroic
    ];
  };
in {
  nixpkgs.overlays = [inputs.millennium.overlays.default];
  imports = [
    ./hardware-configuration.nix
    # ./backup.nix
    ../../../modules/baseline.nix # <-- shared config between laptop/desktop
    ../../../modules/flatpak.nix
    ../../../modules/niri.nix #     <-- niri environment
    ../../../modules/kde.nix # <-- kde environment
    ../../../modules/mount.nix
    ../../../modules/packages.nix
    ../../../modules/ssh.nix
    ../../../modules/nvidia.nix
    ../../../modules/amd.nix
    ../../../modules/virtualization.nix
    ../../../modules/polkit.nix
    ../../../modules/fingerprint.nix
  ];

  # hostname
  networking.hostName = "HuskyNix";

  workstation = {
    baseline = {
      enable = true; # enable baseline config
      packages = {
        tools = true; # enable common suite of CLI tools
        dev = true; # enable common langs/lang related tools
        apps = true; # enable common desktop applications
        cybersec = true; # enable pentesting and cybersecurity tools
      };
    };
    niri.enable = true; # change to a different profile if you want
    kde.enable = false;
    polkit.enable = true;
    ssh.enable = true; # enable default ssh configuration + authorized yubikeys
    virtualization.enable = true; # enable QEMU/KVM virtualization
    flatpak = {
      enable = true;
      onCalendar = "weekly";
      packages = [
        "flathub:app/com.github.tchx84.Flatseal//stable"
        "flathub:app/io.github.flattool.Warehouse//stable"
      ];
    };
  };

  # environments, switch to true or false as needed
  # workstation.hypr.enable = true;
  # workstation.gnome.enable = true;
  # workstation.kde.enable = true;
  # workstation.xfce.enable = true;

  mount = {
    media.enable = true;
    games.enable = true;
  };

  programs.steam = {
    enable = true;
    package = pkgs.millennium-steam;
  };
  programs.gamemode.enable = true;
  programs.coolercontrol.enable = true;
  services.ratbagd.enable = true;
  hardware.cpu.amd.updateMicrocode = true;
  boot.binfmt.emulatedSystems = ["aarch64-linux"];

  hardware.graphics = {
    enable = true;
  };

  hardware.nvidia.prime = {
    offload = {
      enable = true;
      enableOffloadCmd = true;
    };
    nvidiaBusId = "PCI:1:0:0";
    amdgpuBusId = "PCI:22:0:0";
  };

  environment.systemPackages = with pkgs; [
    lm_sensors
    steam-run
    heroic-wrapped
    input-remapper
    v4l-utils
    mangohud
    protonup-qt
  ];

  networking.firewall = {
    allowedTCPPorts = [25565];
  };

  services.btrfs.autoScrub = {
    enable = true;
    interval = "monthly";
    fileSystems = ["/"];
  };
}
