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
        xdg.configFile."micro/colorschemes" = {
          source = config.lib.file.mkOutOfStoreSymlink (builtins.toString ./colorschemes);
          recursive = true;
        };
      };

  };
}
