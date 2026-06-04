{...}: {
  programs.vscode = {
    enable = true;
    profiles.default = {
      userSettings = {
        "editor.fontSize" = 16;
      };
      extensions = [];
    };
    profiles.antigravity = {
      userSettings = {
        "editor.fontSize" = 14;
      };
    };
  };
}
