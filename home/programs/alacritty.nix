_: {
  programs.alacritty = {
    enable = true;
    settings = {
      window = {
        padding = {
          x = 14;
          y = 14;
        };
        decorations = "None";
        opacity = 0.85;
      };
      font = {
        normal = {
          family = "JetBrainsMono Nerd Font";
          style = "Regular";
        };
        size = 11.5;
      };
      cursor = {
        style = {
          shape = "Beam";
          blinking = "On";
        };
      };
    };
  };
}
