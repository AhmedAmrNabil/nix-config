{ config,lib, ... }:

{

  xdg.configFile."fontconfig/fonts.conf" = lib.mkForce {
    source = config.lib.file.mkOutOfStoreSymlink "/home/btngana/dotfiles/config/fonts/fonts.conf";
  };

  xdg.configFile."fontconfig/conf.d/90-arabic.conf" = lib.mkForce {
    source = config.lib.file.mkOutOfStoreSymlink "/home/btngana/dotfiles/config/fonts/90-arabic.conf";
  };
}
