{
  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    shellWrapperName = "y";
    settings = {
      yazi = {
        ratio = [
          1
          4
          3
        ];
        sort_by = "natural";
        sort_sensitive = true;
        sort_reverse = false;
        sort_dir_first = true;
        linemode = "none";
        show_hidden = true;
        show_symlink = true;
      };
      opener = {
        edit = [
          {
            run = "micro %s";
            block = true;
            for = "unix";
            desc = "Micro";
          }
        ];
      };
      open = {
        prepend_rules = [
          {
            mime = "text/*";
            use = "edit";
          }
          {
            mime = "application/{json,ndjson,javascript,wine-extension-ini}";
            use = "edit";
          }
        ];
      };
    };
  };
}
