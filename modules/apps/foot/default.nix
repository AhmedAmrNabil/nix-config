{
  config,
  lib,
  username,
  ...
}:
let
  cfg = config.apps.foot;
in
{
  options.apps.foot = {
    enable = lib.mkEnableOption "Foot terminal emulator";
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.${username} =
      { ... }:
      {
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
            colors = {
              alpha = 0.90;
              foreground = "cdd6f4"; # Text
              background = "1e1e2e"; # Base
              regular0 = "45475a"; # Surface 1
              regular1 = "f38ba8"; # red
              regular2 = "a6e3a1"; # green
              regular3 = "f9e2af"; # yellow
              regular4 = "89b4fa"; # blue
              regular5 = "f5c2e7"; # pink
              regular6 = "94e2d5"; # teal
              regular7 = "bac2de"; # Subtext 1
              bright0 = "585b70"; # Surface 2
              bright1 = "f38ba8"; # red
              bright2 = "a6e3a1"; # green
              bright3 = "f9e2af"; # yellow
              bright4 = "89b4fa"; # blue
              bright5 = "f5c2e7"; # pink
              bright6 = "94e2d5"; # teal
              bright7 = "a6adc8"; # Subtext 0
            };
            key-bindings = {
              clipboard-paste = "Control+v XF86Paste";
            };
          };
        };
      };
  };
}
