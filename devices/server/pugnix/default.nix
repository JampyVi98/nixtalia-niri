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

  # User configuration
  users.users.jampyvi = {
    isNormalUser = true;
    shell = pkgs.zsh;
    hashedPassword = "$6$P76zxyq4JXpeU0Df$Ew3tJ9yPGy5YAnVIYJiDhkK7MFqT/lSZUERXKeB4g1fyL9yPICkE8Zy1kr4S6QjtpcORReYuEejiFaSw9oMrp1"; # Default: pugnix123
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

  # Disable some desktop-oriented virtualisation features from baseline.server if not needed
  # but baseline.server only has docker and qemuGuest, which are fine.
}
