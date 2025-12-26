{ config, ... }:
{
  programs.btop.enable = true;

  xdg.configFile."btop/btop.conf" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/modules/apps/btop/btop.conf";
  };

  xdg.configFile."btop/themes/catppuccin_mocha.theme" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/modules/apps/btop/themes/catppuccin_mocha.theme";
  };
}
