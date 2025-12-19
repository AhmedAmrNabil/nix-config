{ config, ... }:

{
  programs.fish.enable = true;



  xdg.configFile."fish" = {
    source = config.lib.file.mkOutOfStoreSymlink "/home/btngana/dotfiles/config/fish";
    recursive = true;
  };

}
