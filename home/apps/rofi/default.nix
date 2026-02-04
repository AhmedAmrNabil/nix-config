{
  config,
  pkgs,
  lib,
  username,
  ...
}:
let
  cfg = config.apps.rofi;
in
{
  options.apps.rofi = {
    enable = lib.mkEnableOption "Rofi with custom config";
  };
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      rofi
    ];

    xdg.configFile."rofi/themes" = lib.mkForce {
      source = config.lib.file.mkOutOfStoreSymlink "/home/${username}/dotfiles/home/apps/rofi/themes";
      recursive = true;
    };
    xdg.configFile."rofi/config.rasi" = lib.mkForce {
      source = config.lib.file.mkOutOfStoreSymlink "/home/${username}/dotfiles/home/apps/rofi/config.rasi";
    };
  };
}
