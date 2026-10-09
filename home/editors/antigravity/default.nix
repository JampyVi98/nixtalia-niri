{
  config,
  pkgs,
  inputs,
  ...
}: {
  disabledModules = ["programs/antigravity.nix"];

  imports = [
    (import "${inputs.home-managerU}/modules/programs/vscode/mkVscodeModule.nix" {
      modulePath = ["programs" "antigravity"];
      name = "Antigravity IDE";
      packageName = "antigravity-ide";
      nameShort = "Antigravity IDE";
      dataFolderName = ".antigravity-ide";
      skipVersionCheck = true;
    })
  ];

  programs.antigravity = {
    enable = true;
    package = pkgs.antigravity-ide;
    mutableExtensionsDir = true;
    profiles.default = {
      enableExtensionUpdateCheck = true;
      userSettings = config.programs.vscodium.profiles.default.userSettings;
      keybindings = config.programs.vscodium.profiles.default.keybindings;
      extensions = config.programs.vscodium.profiles.default.extensions;
    };
  };
}
