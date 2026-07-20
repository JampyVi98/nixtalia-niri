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
      (nemo-with-extensions.override { extensions = with pkgs; [ nemo-fileroller nemo-preview ]; })
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
        };
        settings = {
          Theme = {
            CursorTheme = "BreezeX-RosePine-Linux";
          };
        };
      };
      defaultSession = "niri";
    };

    services.dbus.packages = with pkgs; [
      nemo-preview
    ];

    systemd.services.display-manager.environment = {
      KWIN_FORCE_SW_CURSOR = "1";
      KWIN_DRM_NO_AMS = "1";
      WLR_NO_HARDWARE_CURSORS = "1";
      XCURSOR_THEME = "BreezeX-RosePine-Linux";
    };
  };
}
