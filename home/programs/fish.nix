{ config, lib, ... }:

{
  programs.fish = {
    enable = true;
    shellAliases = {
      ls = "eza --icons --hyperlink --color=always --group-directories-first";
    };
  };

  xdg.configFile."fish/config.fish" = lib.mkForce {
    source = config.lib.file.mkOutOfStoreSymlink "/home/btngana/dotfiles/config/fish/config.fish";
  };

  xdg.configFile."fish/functions" = lib.mkForce {
    source = config.lib.file.mkOutOfStoreSymlink "/home/btngana/dotfiles/config/fish/functions";
    recursive = true;
  };

  xdg.configFile."fish/themes" = lib.mkForce {
    source = config.lib.file.mkOutOfStoreSymlink "/home/btngana/dotfiles/config/fish/themes";
    recursive = true;
  };

}
