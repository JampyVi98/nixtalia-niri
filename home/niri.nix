{ ... }:
{
  imports = [
    ./config
    ./editors/vscode
    ./editors/antigravity
  ];
  catppuccin = {
    enable = true;
    flavor = "mocha"; # Sabor Mocha
    accent = "mauve"; # Color de acento (mauve, pink, blue, green, etc.)
    micro.transparent = true;
  };
  programs.ghostty.enable = true;
  programs.zed-editor.enable = true;
  programs.prismlauncher.enable = true;

  home.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };
}
