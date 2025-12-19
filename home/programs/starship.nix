{ config, ... }:

{
  programs.starship.enable = true;
  
  xdg.configFile."starship.toml" = {
    source = config.lib.file.mkOutOfStoreSymlink "/home/btngana/dotfiles/config/starship/starship.toml";
  };

}
