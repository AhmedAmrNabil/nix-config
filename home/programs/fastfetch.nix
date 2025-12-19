{ config, lib, ... }:
{
  programs.fastfetch.enable = true;

  xdg.configFile."fastfetch" = lib.mkForce {
    source = config.lib.file.mkOutOfStoreSymlink "/home/btngana/dotfiles/config/fastfetch";
    recursive = true;
  };
}