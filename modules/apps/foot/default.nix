{
  flake.homeModules.foot = {
    programs.foot = {
      enable = true;
      settings = {
        main = {
          font = "JetbrainsMono nerd font:size=14";
          font-bold = "JetbrainsMono nerd font:size=14";
          box-drawings-uses-font-glyphs = "no";
          dpi-aware = "yes";
          initial-window-size-pixels = "1200x700";
          pad = "3x0 center";
        };
        url = {
          launch = "xdg-open \${url}";
        };

        cursor = {
          style = "underline";
        };
        colors-dark = {
          alpha = 0.90;
        };
        key-bindings = {
          clipboard-paste = "Control+v XF86Paste";
        };
      };
    };
  };
}
