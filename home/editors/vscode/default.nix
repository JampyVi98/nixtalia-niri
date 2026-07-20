{pkgs, ...}: {
  imports = [
    ./extensions.nix
    ./keybindings.nix
    ./usersettings.nix
  ];

  programs.vscodium = {
    enable = true;
    mutableExtensionsDir = true;
    package = pkgs.vscodium.override {
      commandLineArgs = "--password-store=gnome-libsecret";
    };
  };
}
