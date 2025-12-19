{ config, ... }:
{
  programs.cava.enable = true;
  xdg.configFile."cava" = {
    source = config.lib.file.mkOutOfStoreSymlink "/home/btngana/dotfiles/config/cava";
  };
}