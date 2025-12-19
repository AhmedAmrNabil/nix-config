{ config, ... }:
{
  xdg.configFile."micro" = {
    source = config.lib.file.mkOutOfStoreSymlink "/home/btngana/dotfiles/config/micro";
    recursive = true;
  };
}