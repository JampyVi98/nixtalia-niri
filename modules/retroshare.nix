{
  config,
  lib,
  ...
}: let
  cfg = config.workstation.retroshare;
in {
  options.workstation.retroshare.enable =
    lib.mkEnableOption "Syncthing RetroArch share";

  config = lib.mkIf cfg.enable {
    services.syncthing = {
      enable = true;
      user = "jampyvi";
      group = "users";
      dataDir = "/home/jampyvi/sync";
      configDir = "/home/jampyvi/.config/syncthing";
      overrideDevices = false;
      overrideFolders = false;
      openDefaultPorts = true;

      settings = {
        devices = {
          "manga" = {
            id = "I3J5UCJ-NZIOJCX-FIV6PUT-QSTITFA-4TI6PB7-MVR67TI-SW56QXD-6ARBAAE";
          };
        };
        folders = {
          "retro-bios" = {
            id = "p4epq-mmgmv";
            path = "/home/jampyvi/sync/retro/BIOS";
            devices = ["manga"];
            type = "receiveonly";
          };
          "retro-roms" = {
            id = "74edp-unucu";
            path = "/home/jampyvi/sync/retro/ROMs";
            devices = ["manga"];
            type = "receiveonly";
          };
          "retro-saves" = {
            id = "ymtp3-m4ngw";
            path = "/home/jampyvi/sync/retro/Saves";
            devices = ["manga"];
            type = "sendreceive";
          };
        };
      };
    };
  };
}
