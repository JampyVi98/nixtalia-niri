{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  cfg = config.workstation.baseline.packages;
  toolsPackages = with pkgs; [
    inputs.agenix.packages.${pkgs.stdenv.hostPlatform.system}.default
    alejandra
    blueman
    curl
    deadnix
    dig
    dysk
    dust
    ffmpeg
    file
    glow
    killall
    lazygit
    lazyssh
    loupe
    lsof
    manga-tui
    nh
    nix-search-tv
    nil
    parted
    parallel
    pciutils
    resources
    screen
    smartmontools
    statix
    tealdeer
    teams-for-linux
    unzip
    usbutils
    wev
    wget
    whois
    wtype
  ];

  devPackages = with pkgs; [
    # rustup
    # cargo
    # gcc
    # rustlings
    # terraform
    # distrobox
    docker-compose
    nodejs_22
    (python312.withPackages (ps: [ ps.virtualenv ]))
    tectonic
    texlab
    typst
  ];

  appsPackages = with pkgs; [
    bitwarden-desktop
    # (retroarch.withCores (cores: with cores; [ mgba ]))
    discord
    element-desktop
    file-roller
    gimp
    pear-desktop
    grim
    slurp
    satty
    gnome-calculator
    libreoffice
    mission-center
    nvtopPackages.full
    piper
    vivaldi
    vivaldi-ffmpeg-codecs
    vlc
    wineWow64Packages.waylandFull
    winetricks
    zathura
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
in {
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
