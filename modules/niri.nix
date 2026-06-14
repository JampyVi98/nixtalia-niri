{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  cfg = config.workstation.niri;
in {
  options.workstation.niri.enable = lib.mkEnableOption "Niri-based workstation environment with Noctalia Shell";

  config = lib.mkIf cfg.enable {
    programs.niri.enable = true;

    qt = {
      enable = true;
    };

    environment.systemPackages = with pkgs; [
      inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
      xwayland-satellite
      swayimg
      rose-pine-cursor
      papirus-icon-theme
      nemo
      fuzzel
      gpu-screen-recorder
      wl-clipboard
      libsForQt5.qt5ct
      mpvpaper
    ];

    services.displayManager = {
      sddm = {
        enable = true;
        wayland = {
          enable = true;
          compositor = "kwin";
        };
      };
      defaultSession = "niri";
      # autoLogin.enable = true;
      # autoLogin.user = "jampyvi";
    };

    systemd.services.display-manager.environment = {
      KWIN_FORCE_SW_CURSOR = "1";
      WLR_NO_HARDWARE_CURSORS = "1";
    };
  };
}
