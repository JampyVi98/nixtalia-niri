{lib, ...}: {
  imports = [
    ./config
    ./editors/vscode
    ./editors/antigravity
  ];
  catppuccin = {
    enable = true;
    autoEnable = true;
    flavor = "mocha"; # Sabor Mocha
    accent = "sapphire"; # Color de acento (mauve, pink, blue, green, etc.)
    micro.transparent = true;
  };
  programs.ghostty = {
    enable = true;
    settings = {
      theme = lib.mkForce "noctalia";
    };
  };
  programs.zed-editor.enable = true;
  programs.prismlauncher.enable = true;

  home.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };
}
