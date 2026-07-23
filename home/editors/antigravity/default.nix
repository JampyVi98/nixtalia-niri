{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.antigravity = {
    enable = true;
    package = pkgs.antigravity.override { commandLineArgs = "--no-sandbox --disable-gpu"; };
    mutableExtensionsDir = true;
    profiles.default = {
      userSettings = config.programs.vscode.profiles.default.userSettings;
      keybindings = config.programs.vscode.profiles.default.keybindings;
      extensions = config.programs.vscode.profiles.default.extensions;
    };
  };
}
