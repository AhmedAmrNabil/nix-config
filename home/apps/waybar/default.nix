{
  config,
  pkgsUnstable,
  lib,
  ...
}:
let
  cfg = config.apps.waybar;
in
{
  options.apps.waybar = {
    enable = lib.mkEnableOption "waybar with custom config";
  };
  config = lib.mkIf cfg.enable {
    home.packages = with pkgsUnstable; [
      waybar
    ];
    xdg.configFile."waybar/config.jsonc" = lib.mkForce {
      source = config.lib.utils.mkMutableSymlink ./config.jsonc;
    };
    xdg.configFile."waybar/style.css" = lib.mkForce {
      source = config.lib.utils.mkMutableSymlink ./style.css;
    };
  };
}
