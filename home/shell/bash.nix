{pkgs, ...}: {
  programs.bash = {
    enable = true;
    shellAliases = {
      ls = "eza";
      battery-health = "upower -i /org/freedesktop/UPower/devices/battery_BAT0";
      nix-forge2git = "rsync -avh --delete --exclude='.git' ~/nixos/ ~/git-repos/nix-cb/";
      yz = "yazi";
    };
    initExtra = ''
      # eval "$(${pkgs.starship}/bin/starship init bash)"
      export EZA_CONFIG_DIR="$HOME/.config/eza"
      export EZA_ICONS_AUTO=1
    '';
  };
}
