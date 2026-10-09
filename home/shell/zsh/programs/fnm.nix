{ pkgs, ... }: {
  home.packages = [ pkgs.fnm ];

  programs.zsh.initContent = ''
    # Fast Node Manager (fnm)
    eval "$(${pkgs.fnm}/bin/fnm env --use-on-cd --shell zsh)"
  '';
}
