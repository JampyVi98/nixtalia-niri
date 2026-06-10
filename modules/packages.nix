{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  cfg = config.workstation.baseline.packages;
  toolsPackages = with pkgs; [
    inputs.agenix.packages.${pkgs.stdenv.hostPlatform.system}.default
    alejandra
    git
    curl
    ghostty
    blueman
    ffmpeg
    whois
    parted
    usbutils
    smartmontools
    pciutils
    file
    screen
    parallel
    dig
    deadnix
    dysk
    dust
    fastfetch
    lazygit
    lazyssh
    manga-tui
    nh
    nix-search-tv
    nil
    resources
    statix
    tealdeer
    teams-for-linux
    udiskie
    unzip
    wev
    wget
  ];

  devPackages = with pkgs; [
    rustup
    cargo
    gcc
    rustlings
    terraform
    distrobox
  ];

  appsPackages = with pkgs; [
    bitwarden-desktop
    brave
    # (retroarch.withCores (cores: with cores; [ mgba ]))
    discord
    element-desktop
    gimp
    gnome-calculator
    libreoffice
    piper
    vlc
    ytmdesktop
  ];

  cybersecPackages = with pkgs; [
    hashcat
    john
    metasploit
    nmap
    nikto
    openvas-scanner
    sqlmap
    wireshark
  ];
in
{
  options.workstation.baseline.packages = {
    tools = lib.mkEnableOption "CLI tools and utilities";
    dev = lib.mkEnableOption "Development tools";
    apps = lib.mkEnableOption "Desktop applications";
    cybersec = lib.mkEnableOption "Pentesting and security tools";
  };

  config = {
    environment.systemPackages =
      (lib.optionals cfg.tools toolsPackages)
      ++ (lib.optionals cfg.dev devPackages)
      ++ (lib.optionals cfg.apps appsPackages)
      ++ (lib.optionals cfg.cybersec cybersecPackages);
  };
}
