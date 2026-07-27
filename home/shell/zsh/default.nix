{
  pkgs,
  lib,
  hostName,
  ...
}: {
  imports = [
    ./programs/bat.nix
    ./programs/dircolors.nix
    ./programs/direnv.nix
    ./programs/eza.nix
    ./programs/fzf.nix
    ./programs/nix-search.nix
    ./programs/starship.nix
    ./programs/yazi.nix
    ./programs/zoxide.nix
  ];

  programs.zsh = {
    enable = true;
    enableCompletion = true;

    initExtra = ''
      # Fix locale issues over SSH causing duplicated characters and broken prompts
      export LANG="en_US.UTF-8"
      export LC_ALL="en_US.UTF-8"
    '';

    autosuggestion = {
      enable = true;
      strategy = ["history" "completion"];
    };

    syntaxHighlighting = {
      enable = true;
      highlighters = ["main" "brackets" "pattern" "cursor" "regexp" "root" "line"];
    };

    shellAliases = let
      inherit (lib) getExe;
      inherit (pkgs) bat ripgrep dust procs;
    in {
      cat = "${getExe bat} --color=always --theme=base16 --style=plain --paging=never";
      du = "${getExe dust}";
      grep = "${getExe ripgrep}";
      ps = "${getExe procs}";

      cp = "cp -iv";
      rm = "rm -iv";
      mv = "mv -iv";

      nb = "nix-build";
      nd = "nix develop";
      nr = "nix run";
      ns = "nix-shell -p";
      nu = "nix-update";
      nos = "nh os switch ~/nixos -H huskynix";
      nhs = "nh home switch ~/nixos -H huskynix";
      nrp = "nh os switch ~/nixos -H pugnix --target-host jampyvi@192.168.18.110";

      cleanup = "sudo nix-collect-garbage --delete-older-than 3d && nix-collect-garbage -d";
      bloat = "nix path-info -Sh /run/current-system";
      repair = "nix-store --verify --check-contents --repair";

      # ls = "eza";
      battery-health = "upower -i /org/freedesktop/UPower/devices/battery_BAT0";
      lz = "lazyssh";
      lg = "lazygit";
      borg_backup = "systemctl restart borgbackup-job-${hostName}-home";
      borg_logs = "journalctl -u borgbackup-job-${hostName}-home";
      port_forward = "while true ; do date ; natpmpc -a 1 0 udp 60 -g 10.2.0.1 && natpmpc -a 1 0 tcp 60 -g 10.2.0.1 || { echo -e 'ERROR with natpmpc command \a' ; break ; } ; sleep 45 ; done";
    };

    plugins = with pkgs; [
      {
        name = "zsh-forgit";
        src = zsh-forgit;
        file = "share/zsh/zsh-forgit/forgit.plugin.zsh";
      }
      {
        name = "zsh-autopair";
        src = zsh-autopair;
        file = "share/zsh/zsh-autopair/autopair.zsh";
      }
      {
        name = "zsh-you-should-use";
        src = zsh-you-should-use;
        file = "share/zsh/plugins/you-should-use/you-should-use.plugin.zsh";
      }
      {
        name = "zsh-nix-shell";
        src = zsh-nix-shell;
        file = "share/zsh-nix-shell/nix-shell.plugin.zsh";
      }
      {
        name = "zsh-vi-mode";
        src = zsh-vi-mode;
        file = "share/zsh-vi-mode/zsh-vi-mode.plugin.zsh";
      }
    ];

    # initContent = lib.mkMerge [
    #   (lib.mkOrder 1000 ''
    #     export EZA_CONFIG_DIR="$HOME/.config/eza"
    #     export EZA_ICONS_AUTO=1
    #   '')
    #   (lib.mkOrder 1500 ''
    #     eval "$(${pkgs.starship}/bin/starship init zsh)"
    #   '')
    # ];
    history.size = 10000;
    oh-my-zsh = {
      enable = true;
      package = pkgs.oh-my-zsh;
      plugins = [
        "sudo"
        "git"
        "nmap"
      ];
    };
  };
}
