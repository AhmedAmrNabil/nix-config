{
  config,
  lib,
  ...
}:
let
  cfg = config.de.hyprland;
in
{
  options.de.hyprland = {
    enable = lib.mkEnableOption "Enable Hyprland with customizations";
  };
  config = lib.mkIf cfg.enable {

    xdg.configFile."hypr/hyprland.lua" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/home/de/hyprland/hyprland.lua";
    };

  };
}
