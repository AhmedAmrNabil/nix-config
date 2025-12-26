{ ... }:
{
  programs.alacritty = {
    enable = true;
    theme = "catppuccin_mocha";
    settings = {
      env = {
        WINIT_X11_SCALE_FACTOR = "1";
      };
      font = {
        normal = {
          family = "JetBrainsMono Nerd Font";
          style = "Regular";
        };
        bold = {
          family = "JetBrainsMono Nerd Font";
          style = "Bold";
        };
        size = 13.5;
      };
      cursor = {
        style = "Underline";
      };
      window = {
        padding = {
          x = 3;
          y = 4;
        };
        opacity = 0.9;
      };
    };
  };
}
