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
    ];
    hash = "sha256-cVm41Oy1vA/8yU9LkFxIggIi9HQtpe31bxBk0SArJVw=";
  };

  patchedToml = (pkgs.formats.toml { }).generate "starship.toml" (
    config.programs.starship.settings
    // {
      format = "$directory$git_branch$git_state$git_status$cmd_duration";
    }
  );
in
{
  options.apps.yazi = {
    enable = lib.mkEnableOption "yazi with custom config";
  };
  config = lib.mkIf cfg.enable {
    programs.yazi = {
      enable = true;
      enableFishIntegration = config.apps.fish.enable;
      enableBashIntegration = config.apps.bash.enable;
      shellWrapperName = "y";
      theme = {
        flavor = {
          dark = "catppuccin-mocha";
          light = "catppuccin-mocha";
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
      };

      plugins = {
        zoom = "${yazi-plugins}/zoom.yazi";
        smart-enter = "${yazi-plugins}/smart-enter.yazi";
        piper = "${yazi-plugins}/piper.yazi";
        starship = {
          package = "${starship-plugin}";
          setup = true;
          settings = {
            config_file = "${patchedToml}";
          };
        };
      };

      flavors = {
        catppuccin-mocha = "${yazi-catpuccin-flavour}/catppuccin-mocha.yazi";
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
        ];
      };
    };
  };
}
