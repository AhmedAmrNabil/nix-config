{ config, ... }:

{
  programs.fish.enable = true;

  xdg.configFile."fish" = {
    source = config.lib.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/config/fish";
    recursive = true;
  }
}
