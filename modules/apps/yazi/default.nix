{
  flake.homeModules.yazi =
    { config, pkgs, ... }:
    let
      yazi-plugins = pkgs.fetchFromGitHub {
        owner = "yazi-rs";
        repo = "plugins";
        rev = "4dc7f1b6458c2578f4494f10d468c68c1082214f";
        hash = "sha256-BSAOkL4H4LVMbTRFv4kzGGRpLgtKkfNTEsDH2EQ219Q=";
      };
      starship-plugin = pkgs.fetchFromGitHub {
        owner = "Rolv-Apneseth";
        repo = "starship.yazi";
        rev = "ea92cf49380466f07231c952b409831e6afd2156";
        hash = "sha256-CPRVJVunBLwFLCoj+XfoIIwrrwHxqoElbskCXZgFraw=";
      };
      yazi-catpuccin-flavour = pkgs.fetchFromGitHub {
        owner = "yazi-rs";
        repo = "flavors";
        rev = "20b47bfd78880c2674899597fd26bc01b21ff48c";
        hash = "sha256-NGnfrQdsnQITKCZ0oh6DCxeCR2ozJoPAZetsi3ghHAI=";
      };
    in
    {
      programs.yazi = {
        enable = true;
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
              desc = "Open with ${config.home.sessionVariables.EDITOR or "micro"}";
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
