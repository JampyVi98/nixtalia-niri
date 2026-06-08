{pkgs, ...}: {
  home.packages = with pkgs; [
    (writeShellApplication {
      name = "ntv";
      runtimeInputs = [
        fzf
        nix-search-tv
      ];
      text = builtins.readFile "${nix-search-tv.src}/nixpkgs.sh";
    })
  ];
}
