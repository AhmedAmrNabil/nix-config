{ config, lib, ... }:
{
  xdg.configFile."OpenTabletDriver/settings.json" = lib.mkForce {
    source = config.lib.file.mkOutOfStoreSymlink (builtins.toString ./OpenTabletDriver/settings.json);
    recursive = true;
  };

  xdg.configFile."OpenTabletDriver/Configurations" = lib.mkForce {
    source = config.lib.file.mkOutOfStoreSymlink (builtins.toString ./OpenTabletDriver/Configurations);
    recursive = true;
  };
}
