{config, ...}: {
  programs.antigravity = {
    enable = true;
    mutableExtensionsDir = true;
    profiles.default = {
      userSettings = config.programs.vscode.profiles.default.userSettings;
      keybindings = config.programs.vscode.profiles.default.keybindings;
      extensions = config.programs.vscode.profiles.default.extensions;
    };
  };
}
