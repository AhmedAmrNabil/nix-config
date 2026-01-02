{
  config,
  lib,
  ...
}:
let
  cfg = config.apps.open-tablet-driver;
in
{
  options.apps.open-tablet-driver = {
    enable = lib.mkEnableOption "OpenTabletDriver for drawing tablets";
  };
  config = lib.mkIf cfg.enable {
    xdg.configFile."OpenTabletDriver/settings.json" = lib.mkForce {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/home/apps/open-tablet-driver/OpenTabletDriver/settings.json";
      recursive = true;
    };

    xdg.configFile."OpenTabletDriver/Configurations" = lib.mkForce {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/home/apps/open-tablet-driver/OpenTabletDriver/Configurations";
      recursive = true;
    };
  };
}
