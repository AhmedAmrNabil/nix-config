{ config, lib, ... }:
{
  programs.micro = {
    enable = true;
    settings = {
      colorscheme = "catppuccin-mocha";
    };
  };
  xdg.configFile."micro/colorschemes" = {
    source = config.lib.file.mkOutOfStoreSymlink "/home/btngana/dotfiles/config/micro/colorschemes";
    recursive = true;
  };
}
