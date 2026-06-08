{...}: {
  imports = [
    ./editors/micro.nix
    ./programs
  ];

  home = {
    username = "jampyvi";
    homeDirectory = "/home/jampyvi";
    stateVersion = "25.05";
  };

  programs.home-manager.enable = true;
  programs.fuzzel.enable = true;

  programs.btop = {
    enable = true;
    settings = {
      # color_theme = "tokyo-night";
      theme_background = true;
      truecolor = true;
    };
  };

  services.gnome-keyring = {
    enable = true;
    components = ["secrets" "ssh"];
  };

  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = ["qemu:///system"];
      uris = ["qemu:///system"];
    };
  };
}
