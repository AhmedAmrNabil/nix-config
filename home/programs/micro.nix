{ config, lib, ... }:
{
  programs.micro.enable = true;

  xdg.configFile."micro/settings.json" = lib.mkForce {
    source = config.lib.file.mkOutOfStoreSymlink "/home/btngana/dotfiles/config/micro/settings.json";
  };

  xdg.configFile."micro/bindings.json" = {
    source = config.lib.file.mkOutOfStoreSymlink "/home/btngana/dotfiles/config/micro/bindings.json";
  };

  xdg.configFile."micro/colorschemes" = {
    source = config.lib.file.mkOutOfStoreSymlink "/home/btngana/dotfiles/config/micro/colorschemes";
    recursive = true;
  };
}