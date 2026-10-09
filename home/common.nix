{
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./editors/micro.nix
    ./programs
  ];

  home = {
    username = "jampyvi";
    homeDirectory = "/home/jampyvi";
    stateVersion = "25.05";
    sessionPath = [
      "$HOME/.local/bin"
    ];
    packages = [
      (pkgs.writeShellScriptBin "kando-term-run" ''
        CMD="$*"

        if [ -z "$CMD" ]; then
            CMD="zsh"
        fi

        NO_PAUSE=0
        case "$CMD" in
            ntv*|*yazi*|*btop*|*nvim*|*lazygit*|*fzf*)
                NO_PAUSE=1
                ;;
        esac

        if [ "$NO_PAUSE" -eq 1 ]; then
            EXEC_CMD="$CMD"
        else
            EXEC_CMD="$CMD; echo -e '\n\033[1;32m✓ Finalizado. Presiona Enter para cerrar...\033[0m'; read -r"
        fi

        if command -v alacritty >/dev/null 2>&1; then
            exec alacritty --class float-term -e zsh -i -c "$EXEC_CMD"
        elif command -v ghostty >/dev/null 2>&1; then
            exec ghostty --class=float-term -e "zsh -i -c '$EXEC_CMD'"
        elif command -v kitty >/dev/null 2>&1; then
            exec kitty --class float-term zsh -i -c "$EXEC_CMD"
        else
            exec x-terminal-emulator -e zsh -i -c "$EXEC_CMD"
        fi
      '')
      (pkgs.writeShellScriptBin "playwright-cli" ''
        exec ${pkgs.nodejs}/bin/npx -y @playwright/cli@latest "$@"
      '')
      (pkgs.writeShellScriptBin "astro" ''
        exec ${pkgs.nodejs}/bin/npx -y astro "$@"
      '')
      (pkgs.writeShellScriptBin "create-astro" ''
        exec ${pkgs.nodejs}/bin/npx -y create-astro "$@"
      '')
    ];
  };

  programs.home-manager.enable = true;
  programs.fuzzel.enable = true;

  programs.btop = {
    enable = true;
    settings = {
      color_theme = lib.mkForce "noctalia";
      theme_background = true;
      truecolor = true;
    };
  };

  services.gnome-keyring = {
    enable = true;
    components = ["secrets" "ssh"];
  };

  services.udiskie = {
    enable = true;
    automount = true;
    notify = true;
  };

  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = ["qemu:///system"];
      uris = ["qemu:///system"];
    };
  };
}
