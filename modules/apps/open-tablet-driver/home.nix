{ config, lib, ... }:
{
  xdg.configFile."OpenTabletDriver/settings.json" = lib.mkForce {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/modules/apps/open-tablet-driver/OpenTabletDriver/settings.json";
    recursive = true;
  };

  xdg.configFile."OpenTabletDriver/Configurations" = lib.mkForce {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/modules/apps/open-tablet-driver/OpenTabletDriver/Configurations";
    recursive = true;
  };
}
