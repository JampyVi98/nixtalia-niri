{pkgs, ...}: {
  programs.vscodium.profiles.default = {
    extensions = with pkgs.vscode-extensions; [
      alefragnani.project-manager
      bradlc.vscode-tailwindcss
      christian-kohler.path-intellisense
      eamodio.gitlens
      editorconfig.editorconfig
      esbenp.prettier-vscode
      formulahendry.code-runner
      james-yu.latex-workshop
      meganrogge.template-string-converter
      mikestead.dotenv
      mkhl.direnv
      ms-azuretools.vscode-docker
      naumovs.color-highlight
      oderwat.indent-rainbow
      redhat.vscode-yaml
      tamasfe.even-better-toml
      usernamehw.errorlens
      yzhang.markdown-all-in-one
    ];
  };
}
