{
  pkgs,
  lib,
  inputs,
  ...
}: {
  imports = [
    # Baseline server config
    ../../../modules/baseline.server.nix
    ../../../modules/ssh.nix
  ];

  networking.hostName = "PugNix";

  # Enable baseline server config
  server.baseline.enable = true;

  # Enable SSH
  workstation.ssh.enable = true;

  # Enable password login for OpenSSH (initially convenient for headless setup)
  services.openssh.settings.PasswordAuthentication = lib.mkForce true;

  # Catppuccin theme for CLI tools (starship, btop, bat, etc.)
  catppuccin = {
    enable = true;
    flavor = "mocha";
    accent = "mauve";
  };

  # User configuration
  users.users.jampyvi = {
    isNormalUser = true;
    shell = pkgs.zsh;
    hashedPassword = "$6$aGcOhn9g1.uBso1m$i3Pm8hQ8Ao.4bjS8oqU0mYyxfZwSBUCWzFa045uimCfelSVl/fNmZHzZ5bHN2ouEYYgA6zucTYZsMKoE18JFF/";
    extraGroups = [
      "wheel"
      "networkmanager"
      "docker"
    ];
  };

  # Raspberry Pi / SD Image settings
  # The sd-image-aarch64 module will handle the bootloader and filesystem setup.
  # We just specify some custom kernel settings.
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    supportedFilesystems = lib.mkForce [ "vfat" "ext4" ];
  };

  # Custom packages for PugNix server
  environment.systemPackages = with pkgs; [
    lsof
    nh
    unzip
    tealdeer
    docker-compose
    nmap
  ];

  # Disable some desktop-oriented virtualisation features from baseline.server if not needed
  # but baseline.server only has docker and qemuGuest, which are fine.
  system.stateVersion = lib.mkForce "26.05";
}
