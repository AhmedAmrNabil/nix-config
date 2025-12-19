{ config, lib, ... }:
{
  programs.btop.enable = true;

  xdg.configFile."btop/btop.conf" = {
    source = config.lib.file.mkOutOfStoreSymlink "/home/btngana/dotfiles/config/btop/btop.conf";
  };

  xdg.configFile."btop/themes" = {
    source = config.lib.file.mkOutOfStoreSymlink "/home/btngana/dotfiles/config/btop/themes";
    recursive = true;
  };
}
