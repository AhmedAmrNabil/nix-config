{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.apps.yazi;
  yazi-plugins = pkgs.fetchFromGitHub {
    owner = "yazi-rs";
    repo = "plugins";
    rev = "main";
    hash = "sha256-bqGN6JxbU+/o7TlM/Cm9Qj/s1McA4pB5QWArGZPcme4=";
  };
  starship-plugin = pkgs.fetchFromGitHub {
    owner = "Rolv-Apneseth";
    repo = "starship.yazi";
    rev = "main";
    hash = "sha256-CPRVJVunBLwFLCoj+XfoIIwrrwHxqoElbskCXZgFraw=";
  };
  yazi-catpuccin-flavour = pkgs.fetchgit {
    url = "https://github.com/yazi-rs/flavors";
    rev = "0f9204b";
    sparseCheckout = [
      "catppuccin-mocha.yazi"
      "catppuccin-latte.yazi"
    ];
    hash = "sha256-cVm41Oy1vA/8yU9LkFxIggIi9HQtpe31bxBk0SArJVw=";
  };
in
{
  options.apps.yazi = {
    enable = lib.mkEnableOption "yazi with custom config";
  };
  config = lib.mkIf cfg.enable {
    programs.yazi = {
      enable = true;
      enableBashIntegration = config.programs.bash.enable;
      enableFishIntegration = config.programs.fish.enable;
      shellWrapperName = "y";
      theme = {
        flavor = {
          dark = "catppuccin-mocha";
          light = "catppuccin-latte";
        };
      };

      extraPackages = with pkgs; [
        glow
        ouch
        starship
      ];

      settings = {
        mgr = {
          show_hidden = true;
        };
        preview = {
          max_width = 1000;
          max_height = 1000;
        };
        plugin.prepend_previewers = [
          {
            url = "*.md";
            run = ''piper -- CLICOLOR_FORCE=1 glow -w=$w -s=dark "$1"'';
          }
          {
            url = "*/";
            run = ''piper -- eza -TL=3 --color=always --icons=always --group-directories-first --no-quotes "$1"'';
          }
        ];
        opener.edit = [
          {
            run = "$EDITOR %s";
            desc = "Open with ${config.home.sessionVariables.EDITOR}";
            block = true;
          }
          {
            run = "code %s";
            desc = "Open with VS Code";
            orphan = true;
          }
        ];
      };

      plugins = {
        zoom = "${yazi-plugins}/zoom.yazi";
        smart-enter = "${yazi-plugins}/smart-enter.yazi";
        piper = "${yazi-plugins}/piper.yazi";
        starship = {
          package = "${starship-plugin}";
          setup = true;
          settings = {
            hide_flags = true;
          };
        };
      };

      flavors = {
        catppuccin-mocha = "${yazi-catpuccin-flavour}/catppuccin-mocha.yazi";
        catppuccin-latte = "${yazi-catpuccin-flavour}/catppuccin-latte.yazi";
      };

      keymap = {
        mgr.prepend_keymap = [
          {
            on = [ "+" ];
            run = "plugin zoom 1";
            desc = "Zoom in hovered file";
          }
          {
            on = [ "-" ];
            run = "plugin zoom -1";
            desc = "Zoom out hovered file";
          }
          {
            on = [ "<Enter>" ];
            run = "plugin smart-enter";
            desc = "Enter the child directory, or open the file";
          }
        ];
      };
    };
  };
}
