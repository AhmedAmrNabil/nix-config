{ config, ... }:

{
  xdg.configFile."Code/User/settings.json".source =
    config.lib.file.mkOutOfStoreSymlink "/home/btngana/dotfiles/config/code/settings.json";

  xdg.configFile."Code/User/keybindings.json".source =
    config.lib.file.mkOutOfStoreSymlink "/home/btngana/dotfiles/config/code/keybindings.json";
}
