{ config, lib, ... }:
{
  programs.alacritty.enable = true;

  xdg.configFile."alacritty" = lib.mkForce {
    source = config.lib.file.mkOutOfStoreSymlink "/home/btngana/dotfiles/config/alacritty";
    recursive = true;
  };
}