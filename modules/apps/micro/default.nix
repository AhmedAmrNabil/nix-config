{
  config,
  lib,
  username,
  pkgs,
  ...
}:
let
  cfg = config.apps.micro;
  catppuccin-micro = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "micro";
    rev = "015a2bb208f61a2d5a33121de2644bf4a059436b";
    hash = "sha256-XbhUwRz21/XLkdOb6VOqLwzxWtehf6qRms0YcepNQ0s=";
  };
in
{
  options.apps.micro = {
    enable = lib.mkEnableOption "Micro editor with custom configuration";
    defaultEditor = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Set micro as the default editor for the user.";
    };
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.${username} = {
      programs.micro = {
        enable = true;
        settings = {
          colorscheme = "catppuccin-mocha-transparent";
        };
      };

      home.sessionVariables = lib.mkIf cfg.defaultEditor {
        EDITOR = "micro";
        VISUAL = "micro";
      };

      xdg.configFile."micro/colorschemes/catppuccin-mocha-transparent.micro".source =
        "${catppuccin-micro}/themes/catppuccin-mocha-transparent.micro";
      xdg.configFile."micro/colorschemes/catppuccin-mocha.micro".source =
        "${catppuccin-micro}/themes/catppuccin-mocha.micro";
    };
  };
}
