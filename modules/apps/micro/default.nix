{
  config,
  lib,
  username,
  ...
}:
let
  cfg = config.apps.micro;
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
    home-manager.users.${username} =
      { config, ... }:
      {
        programs.micro = {
          enable = true;
          settings = {
            colorscheme = "catppuccin-mocha";
          };
        };

        home.sessionVariables = lib.mkIf cfg.defaultEditor {
          EDITOR = "micro";
          VISUAL = "micro";
        };

        xdg.configFile."micro/colorschemes" = {
          source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/modules/apps/micro/colorschemes";
        };
      };
  };
}
