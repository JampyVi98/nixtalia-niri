{
  programs.fastfetch = {
    enable = true;
    settings = {
      display = {
        separator = " ";
      };
      modules = [
        {
          type = "host";
          key = "╭─󰌢";
          keyColor = "cyan";
        }
        {
          type = "cpu";
          key = "├─";
          keyColor = "cyan";
        }
        {
          type = "gpu";
          key = "├─󰾲";
          keyColor = "cyan";
        }
        {
          type = "disk";
          key = "├─";
          keyColor = "cyan";
        }
        {
          type = "memory";
          key = "├─";
          keyColor = "cyan";
        }
        {
          condition = {
            "!system" = "macOS";
          };
          type = "disk";
          keyIcon = "";
          key = "╰─󰅐";
          folders = "/";
          format = "{create-time:10} [{days} days]";
          keyColor = "cyan";
        }
        "break"

        {
          type = "shell";
          key = "╭─";
          keyColor = "magenta";
        }
        {
          type = "terminal";
          key = "├─";
          keyColor = "magenta";
        }
        {
          type = "wm";
          key = "├─";
          keyColor = "magenta";
        }
        {
          type = "locale";
          key = "╰─";
          keyColor = "magenta";
        }
        "break"

        {
          type = "title";
          key = "╭─";
          format = "{user-name}@{host-name}";
          keyColor = "blue";
        }
        {
          type = "os";
          key = "├─{icon}";
          keyColor = "blue";
        }
        {
          type = "kernel";
          key = "├─";
          keyColor = "blue";
        }
        {
          type = "uptime";
          key = "├─󰅐";
          keyColor = "blue";
        }
        {
          type = "localip";
          key = "╰─󰩟";
          compact = true;
          keyColor = "blue";
        }
        "break"
        {
          type = "custom";
          format = " {#90}  {#31}  {#32}  {#33}  {#34}  {#35}  {#36}  {#37}  {#38}  {#39}";
        }
      ];
    };
  };
}
