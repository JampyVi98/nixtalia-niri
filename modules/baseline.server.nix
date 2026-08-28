{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  cfg = config.server.baseline;
in {
  options.server.baseline.enable = lib.mkEnableOption "Baseline server configuration";

  config = lib.mkIf cfg.enable {
    nix.settings.experimental-features = [
      "nix-command"
      "flakes"
    ];

    nixpkgs.config.allowUnfree = true;

    environment.enableAllTerminfo = true;

    networking.networkmanager.enable = true;

    nix.gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };

    nix.optimise = {
      automatic = true;
      dates = ["weekly"];
    };

    services.journald.extraConfig = ''
      SystemMaxUse=500M
    '';

    time.timeZone = "America/Guayaquil";

    i18n.defaultLocale = "en_US.UTF-8";
    console = {
      font = "Lat2-Terminus16";
      keyMap = "us";
    };

    programs.zsh.enable = true;
    environment.pathsToLink = ["/share/zsh"];

    environment.systemPackages = with pkgs; [
      # tools/etc
      inputs.agenix.packages.${pkgs.stdenv.hostPlatform.system}.default
      autojump
      compose2nix
      curl
      dig
      eza
      fastfetch
      ffmpeg
      file
      git
      htop
      jq
      lazydocker
      oh-my-zsh
      parted
      pciutils
      screen
      smartmontools
      starship
      tree
      usbutils
      vim
      wget
      whois
    ];

    services = {
      tailscale.enable = true;
      qemuGuest.enable = true;
    };

    virtualisation.docker = {
      rootless = {
        enable = true;
        setSocketVariable = true;
      };
    };

    system.stateVersion = "25.05";
  };
}
