{
  config,
  lib,
  username,
  ...
}:
let
  cfg = config.apps.btop;
in
{
  options.apps.btop = {
    enable = lib.mkEnableOption "btop with custom configuration";
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.${username} =
      { config, ... }:
      {
        programs.btop.enable = true;

        xdg.configFile."btop/btop.conf" = {
          source = config.lib.file.mkOutOfStoreSymlink "./btop.conf";
        };

        xdg.configFile."btop/themes" = {
          source = config.lib.file.mkOutOfStoreSymlink "./themes";
          recursive = true;
        };
      };
  };
}
