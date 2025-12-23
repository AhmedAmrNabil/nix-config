{ config, ... }:

{

  xdg.configFile."OpenTabletDriver" = {
    source = config.lib.file.mkOutOfStoreSymlink "/home/btngana/dotfiles/config/OpenTabletDriver";
  };

}
