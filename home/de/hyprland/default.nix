{
  config,
  lib,
  pkgs,
  pkgsUnstable,
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

    xdg.configFile."hypr/hyprland.lua".source = config.lib.utils.mkMutableSymlink ./hyprland.lua;

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
    apps.waybar.enable = true;
    programs.hyprlock.enable = true;

    home.packages = with pkgs; [
      playerctl
      grim
      slurp
    ];
  };
}
