{
  config,
  lib,
  pkgs,
  pkgsUnstable,
  inputs,
  ...
}:
let
  cfg = config.de.hyprland;
  hyprlandPackages = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system};
in
{
  options.de.hyprland = {
    enable = lib.mkEnableOption "Enable Hyprland with customizations";
  };
  config = lib.mkIf cfg.enable {

    xdg.configFile."hypr/hyprland.lua" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/home/de/hyprland/hyprland.lua";
    };

    services.hyprpaper = {
      enable = true;
      package = pkgsUnstable.hyprpaper;
      settings = {
        wallpaper = [
          {
            monitor = "DP-1";
            path = "${config.home.homeDirectory}/Pictures/wallpapers/pale-mountains.jpg";
            fit_mode = "cover";
          }
          {
            monitor = "DP-2";
            path = "${config.home.homeDirectory}/Pictures/wallpapers/pale-mountains.jpg";
            fit_mode = "cover";
          }
        ];
      };
    };

    apps.swaync.enable = true;

    home.packages = with pkgs; [
      playerctl
      grim
      slurp
    ];
  };
}
